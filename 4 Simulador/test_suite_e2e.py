#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
test_suite_e2e.py - LA APP CONTRA EL FIRMWARE REAL, POR HTTP

Manda las tramas EXACTAS de MainActivity2.java al firmware en C que corre
detras de servidor_interactivo.py, y comprueba el EFECTO leyendo la baliza con
"¿L?". No comprueba que la peticion HTTP fuera bien: comprueba que la baliza
quedo como tiene que quedar.

    0  PASS   |  1  FALLA  |  2  ABORTADO (el servidor no esta)

POR QUE SE REESCRIBIO ENTERO (22-ago-2026). La version anterior no podia pasar
nunca, y aun asi el repositorio afirmaba "100% PASS":

  - Comprobaba res.get("ok") y res.get("tx"). El servidor solo devuelve
    {"respuesta": ...}: las dos claves eran None SIEMPRE.
  - Mandaba "\\xBF A1,..." CON UN ESPACIO detras del 0xBF. La app no manda ese
    espacio. Se estaba midiendo un protocolo que no existe.
  - El flujo 3 mandaba "¿T?" y "¿A?" como test de luz. Ninguno de los dos esta
    en el protocolo: la app usa "¿A5,E1,...?" y "¿A5,E0,?".
  - El flujo 4 construia un texto y luego comprobaba que ese texto contenia lo
    que el mismo acababa de meter. No podia fallar.

REQUIERE el servidor levantado:  python servidor_interactivo.py
Y OJO: ese servidor retiene arnes.exe, asi que hay que pararlo antes de correr
correr.py o el arnes no enlaza.
"""

import json
import sys
import urllib.error
import urllib.request

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

API_URL = "http://localhost:8080/api/uart"

fallos = []


def enviar(trama):
    """Manda una trama tal cual y devuelve lo que el firmware saco por la UART."""
    data = json.dumps({"trama": trama}).encode("utf-8")
    req = urllib.request.Request(
        API_URL, data=data, headers={"Content-Type": "application/json"}
    )
    with urllib.request.urlopen(req, timeout=10) as r:
        return json.loads(r.read().decode("utf-8")).get("respuesta", "")


def leer_baliza():
    """El volcado de '¿L?'. Es la unica fuente de verdad de este fichero."""
    return enviar("\xBFL?\r\n")


def check(condicion, descripcion):
    if condicion:
        print(f"   ok    {descripcion}")
    else:
        print(f"   FALLA {descripcion}")
        fallos.append(descripcion)


def flujo_1_reloj():
    """Trama de MainActivity2.java:208 -> "¿R" + HHmm + ",C" + ddMMyy-u + "?" """
    print("\n-- 1. Sincronizacion de reloj")
    enviar("\xBFR1130,C210826-4?\r\n")
    d = leer_baliza()
    check("11:30" in d, "el reloj de la baliza quedo en 11:30 tras la trama de la app")
    check("21/8/26" in d, "la fecha quedo en 21/8/26")


def flujo_2_un_toque():
    """La secuencia literal del boton 1-Toque: MainActivity2.java:686-709.

    Las horas NO se inventan aqui: son las de la chapa atornillada a la senal."""
    print("\n-- 2. Boton 1-Toque (horario escolar de la chapa)")
    for t in [
        "\xBFA1,E1,I0600,F0900,D9,?\r\n",
        "\xBFA2,E1,I1130,F1330,D9,?\r\n",
        "\xBFA3,E1,I1500,F1630,D9,?\r\n",
        "\xBFA4,E0,?\r\n",
        "\xBFA5,E0,?\r\n",
    ]:
        enviar(t)

    d = leer_baliza()
    check("6:0" in d and "9:0" in d, "franja 1 grabada: 06:00 a 09:00")
    check("11:30" in d and "13:30" in d, "franja 2 grabada: 11:30 a 13:30")
    check("15:0" in d and "16:30" in d, "franja 3 grabada: 15:00 a 16:30")
    check(d.count("LV") >= 3, "las tres franjas quedaron en Lunes-Viernes (LV)")
    check(d.count("OFF") >= 2, "las alarmas 4 y 5 quedaron apagadas")


def flujo_3_test_de_luz():
    """Test de foco: MainActivity2.java:562 y 577. Usa la alarma 5 temporal."""
    print("\n-- 3. Test de foco de 2 minutos")
    enviar("\xBFR1200,C210826-4?\r\n")
    enviar("\xBFA5,E1,I1200,F1202,D8,?\r\n")
    d = leer_baliza()
    check("12:0" in d and "12:2" in d, "la alarma 5 temporal quedo de 12:00 a 12:02")

    enviar("\xBFA5,E0,?\r\n")
    d = leer_baliza()
    lineas = [l for l in d.split("\n") if l.strip().startswith("5")]
    check(bool(lineas) and "OFF" in lineas[0],
          "tras apagar, la alarma 5 vuelve a OFF")


def flujo_4_nombre_ota():
    """Nombre por el aire: MainActivity2.java:876 -> "¿N<nombre>?".

    [ROJO ESPERADO 22-ago-2026] El despachador de Serial.c elige comando por
    LETRA SUELTA y en orden (L, R, N, A), asi que las letras del propio nombre
    compiten con los identificadores. Medido tambien en el arnes, bloque J."""
    print("\n-- 4. Nombre por el aire (OTA)")
    enviar("\xBFR0900,C210826-4?\r\n")

    enviar("\xBFNCOLEGIO SAN JOSE?\r\n")
    d = leer_baliza()
    check("OK_NAME" in enviar("\xBFNCOLEGIO SAN JOSE?\r\n"),
          "un nombre con L mayuscula se acepta como nombre")

    enviar("\xBFNCARRERA 30 CON 45?\r\n")
    d = leer_baliza()
    check("9:0" in d,
          "grabar un nombre con R mayuscula NO corrompe la hora de la baliza")


def main():
    print("=" * 65)
    print(" E2E: LAS TRAMAS DE LA APP CONTRA EL FIRMWARE EN C")
    print("=" * 65)

    try:
        enviar("\xBFL?\r\n")
    except (urllib.error.URLError, OSError) as e:
        print(f"\nABORTADO: no hay servidor en {API_URL}")
        print(f"  ({e})")
        print("\n  Levantalo con:  python servidor_interactivo.py")
        print("\nUn instrumento que no corre no dice NADA del firmware.")
        return 2

    for flujo in (flujo_1_reloj, flujo_2_un_toque,
                  flujo_3_test_de_luz, flujo_4_nombre_ota):
        try:
            flujo()
        except Exception as e:
            print(f"   FALLA {flujo.__name__}: excepcion {e!r}")
            fallos.append(flujo.__name__)

    print("\n" + "=" * 65)
    if fallos:
        print(f" RESULTADO: FALLA -- {len(fallos)} comprobacion(es) en rojo")
        for f in fallos:
            print(f"   - {f}")
    else:
        print(" RESULTADO: PASS")
    print("=" * 65)
    print("\nLo que este fichero NO dice:")
    print("  - que el APK instalado mande de verdad estas tramas (aqui van a mano)")
    print("  - que el Bluetooth empareje")
    print("  - que el horario coincida con la chapa atornillada de esa senal")
    return 1 if fallos else 0


if __name__ == "__main__":
    sys.exit(main())
