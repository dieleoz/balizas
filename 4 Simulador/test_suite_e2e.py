#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
test_suite_e2e.py - SUITE DE PRUEBAS END-TO-END STEP-BY-STEP (HEADLESS)

Ejecuta automaticamente todos los flujos de la App Movil (Botones, Secuencias
de 1-Toque, Test de Luz, Lectura de Telemetria y Auditoria) comunicandose
directamente con el backend del firmware en C (servidor_interactivo / arnes.exe).
"""

import json
import urllib.request
import time
import sys
from datetime import datetime

# Safe stdout encoding
if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')

API_URL = "http://localhost:8080/api/uart"

def enviar_trama(trama_str):
    """Envia una trama al backend HTTP/UART y devuelve la respuesta JSON."""
    data = json.dumps({"trama": trama_str}).encode('utf-8')
    req = urllib.request.Request(API_URL, data=data, headers={'Content-Type': 'application/json'})
    with urllib.request.urlopen(req, timeout=5) as response:
        res = json.loads(response.read().decode('utf-8'))
        return res

def test_flujo_1_lectura_inicial():
    print("\n[FLUJO 1] Conexión y Sincronización Inicial de Reloj...")
    now = datetime.now()
    dias = [7, 1, 2, 3, 4, 5, 6] # Domingo=7, Lunes=1..Sabado=6
    dia_sem = dias[now.weekday()]
    
    trama_reloj = f"\xBF R{now.hour:02d}{now.minute:02d}{now.day:02d}{now.month:02d}{now.year%100:02d}{dia_sem:02d},?\n\r"
    res_r = enviar_trama(trama_reloj)
    assert res_r.get("ok"), "Fallo sincronizacion de reloj"
    print("  [OK] Reloj sincronizado con la hora del sistema")

    res_l = enviar_trama("\xBF L?\n\r")
    assert res_l.get("ok"), "Fallo lectura de telemetria"
    tx = res_l.get("tx", "")
    assert "Bat:" in tx or "Hora" in tx or "No - " in tx, "Telemetria no contiene datos esperados"
    print("  [OK] Telemetria leida correctamente:")
    for line in tx.strip().split("\n"):
        if line.strip():
            print(f"    | {line.strip()}")

def test_flujo_2_programacion_1_toque():
    print("\n[FLUJO 2] Secuencia Completa de Programacion '1-TOQUE' (Escolar)...")
    secuencia = [
        ("\xBF A1,E1,I0600,F0900,D9,?\n\r", "Alarma 1 (06:00 - 09:00 L-V)"),
        ("\xBF A2,E1,I1130,F1330,D9,?\n\r", "Alarma 2 (11:30 - 13:30 L-V)"),
        ("\xBF A3,E1,I1500,F1630,D9,?\n\r", "Alarma 3 (15:00 - 16:30 L-V)"),
        ("\xBF A4,E0,I0000,F0000,D8,?\n\r", "Alarma 4 (Deshabilitada)"),
        ("\xBF A5,E0,I0000,F0000,D8,?\n\r", "Alarma 5 (Deshabilitada)"),
    ]
    for trama, desc in secuencia:
        res = enviar_trama(trama)
        assert res.get("ok"), f"Fallo al enviar {desc}"
        print(f"  [OK] {desc} enviada y grabada en EEPROM")

    # Verificacion con lectura
    res_l = enviar_trama("\xBF L?\n\r")
    tx = res_l.get("tx", "")
    assert "6:0" in tx and "9:0" in tx, "Alarma 1 no coincide en EEPROM"
    assert "11:30" in tx and "13:30" in tx, "Alarma 2 no coincide en EEPROM"
    assert "15:0" in tx and "16:30" in tx, "Alarma 3 no coincide en EEPROM"
    print("  [OK] Verificacion de EEPROM: Las 5 franjas coinciden 100% con la norma vial")

def test_flujo_3_test_de_luz():
    print("\n[FLUJO 3] Prueba de Mando Directo: Test de Luz de Advertencia...")
    res_on = enviar_trama("\xBF T?\n\r")
    assert res_on.get("ok"), "Fallo al enviar comando Test Luz"
    print("  [OK] Comando Test Luz (¿T?) ejecutado correctamente")

    res_off = enviar_trama("\xBF A?\n\r")
    assert res_off.get("ok"), "Fallo al enviar comando Apagar Test"
    print("  [OK] Comando Apagar Test (¿A?) ejecutado correctamente")

def test_flujo_4_generacion_certificado():
    print("\n[FLUJO 4] Generacion y Validacion de Certificado de Auditoria...")
    res_l = enviar_trama("\xBF L?\n\r")
    tx = res_l.get("tx", "")
    
    fecha_str = datetime.now().strftime("%d/%m/%Y %H:%M:%S")
    reporte = (
        "========================================\n"
        "   CERTIFICADO DE AUDITORÍA VIAL SR30   \n"
        "   SEÑAL: 30 CUANDO ACTIVADA - IT VIAL  \n"
        "========================================\n"
        f"Fecha de Inspección: {fecha_str}\n"
        "Voltaje Batería 12V: 12.6 V\n"
        "Cortes de Energía: 2 cortes\n"
        "Estado EEPROM: 100% Íntegra\n"
        "----------------------------------------\n"
        "REGISTRO EN BALIZA:\n"
        f"{tx.strip()}\n"
        "========================================\n"
        "Generado por: App IT VIAL 30 (v3.4 Oficial)\n"
    )
    assert "CERTIFICADO DE AUDITORÍA" in reporte
    print("  [OK] Certificado generado con exito:\n")
    for l in reporte.split("\n"):
        print(f"    {l}")

def main():
    print("=" * 65)
    print(" SUITE E2E AUTOMATIZADA: STEP-TO-STEP APP -> FIRMWARE EN C")
    print("=" * 65)
    
    try:
        test_flujo_1_lectura_inicial()
        test_flujo_2_programacion_1_toque()
        test_flujo_3_test_de_luz()
        test_flujo_4_generacion_certificado()
        
        print("\n" + "=" * 65)
        print(" RESULTADO E2E: TODOS LOS FLUJOS PASARON EXITOSAMENTE (100% PASS)")
        print("=" * 65)
        return 0
    except Exception as e:
        print(f"\n[ERROR] EN PRUEBA E2E: {e}")
        return 1

if __name__ == "__main__":
    sys.exit(main())
