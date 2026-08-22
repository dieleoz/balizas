#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
medir_manual_usuario.py
Script de Validación Automática y Medición de Calidad del Manual de Usuario IT VIAL 30.
Verifica estructura de 10 pasos, fidelidad de imágenes, tablas, coherencia de diagnósticos y formato.
"""

import os
import re
import sys

AQUI = os.path.dirname(os.path.abspath(__file__))
MD_PATH = os.path.join(AQUI, "MANUAL_USUARIO_APP.md")
DOCX_PATH = os.path.join(AQUI, "MANUAL_USUARIO_APP.docx")
IMG_DIR = os.path.join(AQUI, "img")

def medir():
    print("================================================================================")
    print("      AUDITORÍA Y MEDICIÓN DE CALIDAD: MANUAL_USUARIO_APP (IT VIAL 30 v3.3)     ")
    print("================================================================================\n")
    
    score = 0
    total_checks = 0
    errores = []

    # 1. EXISTENCIA DE ARCHIVOS BASE
    for path, desc in [(MD_PATH, "Fuente Markdown"), (DOCX_PATH, "Documento Word Oficial")]:
        total_checks += 1
        if os.path.exists(path) and os.path.getsize(path) > 1000:
            score += 1
            print(f" [PASS] Archivo {desc} existe y tiene tamaño válido ({os.path.getsize(path):,} bytes).")
        else:
            errores.append(f"Falta archivo {desc} o está vacío.")

    # 2. LECTURA DEL MARKDOWN FUENTE
    with open(MD_PATH, "r", encoding="utf-8") as f:
        contenido = f.read()

    # 3. VERIFICACIÓN DE LAS 18 FIGURAS
    figuras_esperadas = [
        ("Figura 1", "senal_vial.jpeg"),
        ("Figura 2", "placa_horario.jpeg"),
        ("Figura 3", "paso1_instalacion_apk.png"),
        ("Figura 4", "paso1_confirmar_instalacion.png"),
        ("Figura 5", "paso1_instalando_progreso.png"),
        ("Figura 6", "paso1_play_protect_bloqueo.png"),
        ("Figura 7", "paso1_instalacion_finalizada.png"),
        ("Figura 8", "paso3_login_app.png"),
        ("Figura 9", "paso2_permisos_dispositivos_cercanos.png"),
        ("Figura 10", "paso2_habilitar_bluetooth_dialog.png"),
        ("Figura 11", "paso2_emparejamiento_bt.png"),
        ("Figura 12", "paso4_dialog_dispositivos.png"),
        ("Figura 13", "paso4_pantalla_principal.png"),
        ("Figura 14", "paso6_detalle_horario_escolar.png"),
        ("Figura 15", "paso7_config_franja_detalle.png"),
        ("Figura 16", "paso7_dropdowns_combinados.png"),
        ("Figura 17", "paso8_detalle_diagnostico_luz.png"),
        ("Figura 18", "portada_it_vial_creditos.png"),
    ]

    print("\n--- Verificación de Figuras y Capturas HD ---")
    for fig_label, img_file in figuras_esperadas:
        total_checks += 1
        img_path = os.path.join(IMG_DIR, img_file)
        if os.path.exists(img_path) and img_file in contenido and fig_label in contenido:
            score += 1
            print(f" [PASS] {fig_label} ({img_file}) referenciada y presente en disco.")
        else:
            errores.append(f"Problema con {fig_label} ({img_file}): no encontrada o no referenciada en MD.")

    # 4. VERIFICACIÓN DEL FLUJO DE 10 PASOS SECUENCIALES
    print("\n--- Verificación del Flujo de 10 Pasos ---")
    pasos_esperados = [
        "PASO 1: Instalación de la Aplicación",
        "PASO 2: Acceso e Inicio de Sesión en la Aplicación (Login)",
        "PASO 3: Concesión de Permisos de Dispositivos Cercanos",
        "PASO 4: Activación de Bluetooth desde la Aplicación",
        "PASO 5: Emparejamiento Bluetooth en Ajustes del Teléfono",
        "PASO 6: Conexión con la Baliza",
        "PASO 7: Función del Botón «LEER» y Consola de Datos",
        "PASO 8: Sincronización de Hora y Programación en «1 Toque»",
        "PASO 9: Configuración Manual de Franjas y Selectores de Horario",
        "PASO 10: Módulo de Diagnóstico y Modo de Prueba (2 Minutos)"
    ]

    for i, paso_titulo in enumerate(pasos_esperados, start=1):
        total_checks += 1
        if paso_titulo in contenido:
            score += 1
            print(f" [PASS] Paso {i:02d} correctamente titulado y estructurado.")
        else:
            errores.append(f"Falta o título incorrecto en Paso {i:02d}: {paso_titulo}")

    # 5. VERIFICACIÓN DE SECCIONES DE DIAGNÓSTICO Y TABLAS
    print("\n--- Verificación de Secciones Técnicas y Tablas ---")
    secciones_criticas = [
        ("4. Diagnóstico y Medición del Estado de Baterías", "Sección Baterías"),
        ("4.1 Batería Principal del Sistema (12 VDC)", "Batería 12V"),
        ("4.2 Pila Botón de Respaldo del Reloj Interno (CR2032 - 3V)", "Pila CR2032"),
        ("5. Lista de Chequeo para Entrega en Campo (Checklist)", "Checklist"),
        ("6. Tabla de Solución de Problemas (Troubleshooting)", "Troubleshooting"),
        ("7. Soporte Técnico y Contacto Oficial", "Contacto IT Vial"),
        ("CR2032", "Referencia Pila Botón"),
        ("1234", "PIN Bluetooth Principal"),
        ("1.0 Hz", "Cadencia Oficial de Destello (1.0 Hz)")
    ]

    for texto_clave, desc_sec in secciones_criticas:
        total_checks += 1
        if texto_clave in contenido:
            score += 1
            print(f" [PASS] {desc_sec} validado ({texto_clave}).")
        else:
            errores.append(f"Falta contenido crítico: {desc_sec} ({texto_clave})")

    # 6. RESULTADO FINAL Y CALIFICACIÓN
    porcentaje = (score / total_checks) * 100
    print("\n================================================================================")
    print(f" RESULTADO DE LA AUDITORÍA: {score}/{total_checks} comprobaciones superadas ({porcentaje:.1f} %)")
    print("================================================================================")

    if errores:
        print("\n[ALERTA] Se detectaron observaciones:")
        for err in errores:
            print("  * " + err)
        return False
    else:
        print("\n>>> MANUAL EN ESTADO ÓPTIMO: 100% CUMPLE TODAS LAS NORMAS Y PAUTAS CORPORATIVAS <<<")
        return True

if __name__ == "__main__":
    exito = medir()
    sys.exit(0 if exito else 1)
