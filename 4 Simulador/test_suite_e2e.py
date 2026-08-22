#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
test_suite_e2e.py - LAS TRAMAS DE LA APP CONTRA EL FIRMWARE EN C, SIN NADA EN MEDIO

Habla por tuberia con `arnes.exe --interactivo`, que es el firmware REAL del PIC
compilado para PC. Sin servidor HTTP, sin navegador, sin emulador web: solo las
tramas que manda MainActivity2.java entrando por la UART simulada.

    0  PASS   |   1  FALLA   |   2  ABORTADO (falta arnes.exe)

QUE MIDE: que el firmware haga lo que la app espera. Cada flujo manda las tramas
literales de la app y despues comprueba el EFECTO leyendo la baliza con "¿L?".
No comprueba que la trama se enviara: comprueba que la baliza quedo bien.

QUE NO MIDE, y hay que tenerlo presente:
  - Que el APK instalado mande de verdad estas tramas. Aqui van escritas a mano
    contra MainActivity2.java. Que el Java las construya igual es otra cosa.
  - Que el modulo Bluetooth empareje ni que el enlace aguante.
  - Que la etapa de potencia encienda la luz de la senal.
  - Que el horario coincida con la CHAPA ATORNILLADA de esa instalacion.

POR QUE NO USA HTTP (22-ago-2026). La version anterior iba contra
servidor_interactivo.py y encadenaba tramas sin dejar procesar la anterior. Eso
disparaba el defecto de solapamiento (arnes, bloque K) y hacia parecer roto el
ajuste de reloj, que esta bien. El modo interactivo procesa UNA trama por linea
con su propio tiempo, que es el caso que se quiere medir aqui.
"""

import os
import subprocess
import sys

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

AQUI = os.path.dirname(os.path.abspath(__file__))
ARNES = os.path.join(AQUI, "arnes.exe")

fallos = []


class Baliza:
    """El firmware del PIC al otro lado de una tuberia."""

    def __init__(self, proc):
        self.p = proc

    def _leer_hasta_ok(self):
        lineas = []
        while True:
            linea = self.p.stdout.readline()
            if not linea:
                raise RuntimeError("el arnes se murio a mitad")
            t = linea.decode("cp1252", "replace").rstrip("\r\n")
            if t == "[SIM_OK]":
                break
            lineas.append(t)
        return "\n".join(lineas)

    def enviar(self, trama):
        """Manda una trama tal cual la manda la app. Devuelve lo que salio por la UART."""
        self.p.stdin.write(trama.encode("cp1252") + b"\n")
        self.p.stdin.flush()
        return self._leer_hasta_ok()

    def leer(self):
        """El volcado de '¿L?'. Unica fuente de verdad de este fichero."""
        return self.enviar("\xBFL?")

    def cerrar(self):
        try:
            self.p.stdin.write(b"SALIR\n")
            self.p.stdin.flush()
            self.p.wait(timeout=5)
        except Exception:
            self.p.kill()


def check(condicion, descripcion):
    print(f"   {'ok   ' if condicion else 'FALLA'} {descripcion}")
    if not condicion:
        fallos.append(descripcion)


# ---------------------------------------------------------------- flujos


def flujo_reloj(b):
    """MainActivity2.java:208 -> "¿R" + HHmm + ",C" + ddMMyy-u + "?" """
    print("\n-- 1. Poner la baliza en hora")
    b.enviar("\xBFR1130,C210826-4?")
    d = b.leer()
    check("11:30" in d, "el reloj queda en 11:30")
    check("21/8/26" in d, "la fecha queda en 21/8/26")


def flujo_un_toque(b):
    """La secuencia literal del boton 1-Toque: MainActivity2.java:686-709.

    Las horas NO se eligen aqui: son las de la chapa atornillada a la senal."""
    print("\n-- 2. Boton 1-Toque (horario escolar de la chapa)")
    for t in (
        "\xBFA1,E1,I0600,F0900,D9,?",
        "\xBFA2,E1,I1130,F1330,D9,?",
        "\xBFA3,E1,I1500,F1630,D9,?",
        "\xBFA4,E0,?",
        "\xBFA5,E0,?",
    ):
        b.enviar(t)

    d = b.leer()
    check("6:0" in d and "9:0" in d, "franja 1: 06:00 a 09:00")
    check("11:30" in d and "13:30" in d, "franja 2: 11:30 a 13:30")
    check("15:0" in d and "16:30" in d, "franja 3: 15:00 a 16:30")
    check(d.count("LV") >= 3, "las tres franjas quedan en Lunes-Viernes")
    check(d.count("OFF") >= 2, "las alarmas 4 y 5 quedan apagadas")


def _muestrear_lampara(b, veces=8):
    """La luz PARPADEA a 1 Hz, asi que una sola muestra no dice nada: sale 0 o 1
    segun el instante. Se muestrea una ventana y se mira el conjunto.
    (Este fichero ya dio un rojo falso por muestrear una vez -- 22-ago-2026.)"""
    return "".join("1" if "[LAMP]:1" in b.enviar("TICK 200") else "0"
                   for _ in range(veces))


def flujo_luz_enciende(b):
    """Lo unico que le importa a un conductor: que la luz parpadee DENTRO de la
    franja y este apagada fuera."""
    print("\n-- 3. La luz obedece a la franja (LATC2)")

    b.enviar("¿R0700,C210826-5?")          # viernes 07:00, dentro de 06:00-09:00
    b.enviar("TICK 2000")
    m = _muestrear_lampara(b)
    check("1" in m and "0" in m,
          f"viernes 07:00: la luz PARPADEA dentro de la franja (muestras {m})")

    b.enviar("¿R1000,C210826-5?")          # 10:00, fuera de toda franja
    b.enviar("TICK 2000")
    m = _muestrear_lampara(b)
    check(m == "0" * len(m), f"viernes 10:00: la luz esta apagada (muestras {m})")

    b.enviar("¿R0700,C220826-6?")          # sabado: las franjas son L-V
    b.enviar("TICK 2000")
    m = _muestrear_lampara(b)
    check(m == "0" * len(m), f"sabado 07:00: la luz esta apagada (muestras {m})")


def flujo_test_foco(b):
    """Test de foco de 2 min: MainActivity2.java:562 y 577 (alarma 5 temporal)."""
    print("\n-- 4. Test de foco de 2 minutos")
    b.enviar("\xBFR1200,C210826-4?")
    b.enviar("\xBFA5,E1,I1200,F1202,D8,?")
    d = b.leer()
    check("12:0" in d and "12:2" in d, "la alarma 5 temporal queda de 12:00 a 12:02")

    b.enviar("\xBFA5,E0,?")
    d = b.leer()
    linea5 = [l for l in d.split("\n") if l.strip().startswith("5")]
    check(bool(linea5) and "OFF" in linea5[0], "tras apagar, la alarma 5 vuelve a OFF")


def flujo_nombre_ota(b):
    """Nombre por el aire: MainActivity2.java:876 -> "¿N<nombre>?".

    ALCANCE, y conviene leerlo antes de fiarse de estos verdes:

    1) Desde aqui NO se ve la EEPROM, asi que no se puede comprobar que el
       nombre quedara grabado. Eso lo mide el arnes (bloque J), que si lee 0x40.
    2) Tampoco se ve el eco "OK_NAME": arnes.c compila Serial.c con
       -DtransmitUart1=fw_transmitUart1, y las llamadas que Serial.c se hace a
       si mismo esquivan la envoltura que captura la UART. En el equipo real ese
       eco SI sale.

    Lo que si se puede comprobar aqui, y era el defecto GRAVE: que grabar un
    nombre no destroce la hora de la baliza. Arreglado el 22-ago-2026
    despachando por el caracter pegado al delimitador."""
    print("\n-- 5. Nombre por el aire (OTA)")

    # Control: nombre "afortunado", sin L ni R mayusculas. Antes tambien pasaba.
    b.enviar(chr(0xBF) + "R0900,C210826-4?")
    b.enviar(chr(0xBF) + "NCol. San Jose?")
    check("9:0" in b.leer(),
          "nombre sin L ni R mayusculas: la hora sigue en 09:00")

    # El que corrompia el reloj: R mayuscula y ninguna L.
    b.enviar(chr(0xBF) + "R0900,C210826-4?")
    b.enviar(chr(0xBF) + "NCARRERA 30 CON 45?")
    check("9:0" in b.leer(),
          "nombre con R mayuscula: la hora NO se corrompe")

    # El que se despachaba como lectura y perdia el nombre.
    b.enviar(chr(0xBF) + "R0900,C210826-4?")
    b.enviar(chr(0xBF) + "NCOLEGIO SAN JOSE?")
    check("9:0" in b.leer(),
          "nombre con L mayuscula: la hora sigue intacta")


# ---------------------------------------------------------------- main


def main():
    print("=" * 66)
    print(" LAS TRAMAS DE LA APP CONTRA EL FIRMWARE EN C (sin HTTP, sin front)")
    print("=" * 66)

    if not os.path.isfile(ARNES):
        print(f"\nABORTADO: no esta {ARNES}")
        print("  Generalo con:  python correr.py")
        print("\nUn instrumento que no corre no dice NADA del firmware.")
        return 2

    proc = subprocess.Popen(
        [ARNES, "--interactivo"],
        stdin=subprocess.PIPE, stdout=subprocess.PIPE, bufsize=0,
    )
    listo = proc.stdout.readline().decode("cp1252", "replace").strip()
    if listo != "[SIM_LISTO]":
        print(f"\nABORTADO: el arnes no saludo ([SIM_LISTO]), dijo: {listo!r}")
        proc.kill()
        return 2

    b = Baliza(proc)
    try:
        for f in (flujo_reloj, flujo_un_toque, flujo_luz_enciende,
                  flujo_test_foco, flujo_nombre_ota):
            try:
                f(b)
            except Exception as e:
                print(f"   FALLA {f.__name__}: excepcion {e!r}")
                fallos.append(f.__name__)
    finally:
        b.cerrar()

    print("\n" + "=" * 66)
    if fallos:
        print(f" RESULTADO: FALLA -- {len(fallos)} en rojo")
        for f in fallos:
            print(f"   - {f}")
    else:
        print(" RESULTADO: PASS")
    print("=" * 66)
    print("\nEsto NO dice que el APK mande estas tramas, ni que el Bluetooth")
    print("empareje, ni que el horario coincida con la chapa de esa senal.")
    return 1 if fallos else 0


if __name__ == "__main__":
    sys.exit(main())
