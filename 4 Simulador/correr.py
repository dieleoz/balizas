#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
correr.py - LA COMPUERTA DEL FIRMWARE DE LA BALIZA

Un comando, un codigo de salida:

    0  PASS      compilo, corrio, y el firmware cumple lo que se le exige
    1  FALLA     compilo, corrio, y el firmware NO cumple
    2  ABORTADO  NO PUDO CORRER: falta el compilador, o el arnes no compila

ABORTADO GANA SOBRE FALLA. Si el arnes no compila, la compuerta no puede decir
que el firmware falla: no lo ha medido. Devuelve 2 y manda arreglar el
instrumento. Tratar un abortado como un fallo mas invita a tocar el firmware
cuando lo roto es la regla de medir.

El compilador va por RUTA ABSOLUTA y aborta si no esta. No cae al gcc del PATH:
en esta maquina el del PATH vive bajo una carpeta con 'n' con tilde y su enlazador
no encuentra crt2.o. Un instrumento que se busca un compilador de repuesto mide
con el equivocado y acusa de un fallo que no existe.
"""

import os
import subprocess
import sys

AQUI = os.path.dirname(os.path.abspath(__file__))
FW = os.path.join(AQUI, "..", "1 Firmware", "Doc mplabx", "18f2550_baliza_ V1.X")
SALIDA = os.path.join(AQUI, "arnes.exe")

GCC = r"D:\toolchain\mingw64\bin\gcc.exe"

# Los .c del firmware que SI se compilan. main.c, EEprom.c, DS1307.c e I2C.c
# quedan fuera y estan sustituidos por sim/plataforma.c -- el motivo de cada
# exclusion esta escrito en la cabecera de arnes.c.
FUENTES_FW = [
    # Adc.c salio de main.c justo para que el arnes pudiera compilar el PCFG:
    # mientras vivio dentro de main.c, el simulador no podia ver que canales
    # quedaban analogicos y el defecto de AN3 pasaba en verde.
    "Adc.c",
    "TimeBase.c",
    "LedLive.c",
    "Buzzer.c",
    "Cluster.c",
    "Serial.c",
    "Alarma.c",
    "Aplicacion.c",
]

# -fcommon: XC8 fusiona las definiciones tentativas duplicadas del firmware
#           (`strAplicacion ap;` en Aplicacion.c y LedLive.c, `srtAlarmas ala1..5`
#           en Serial.c y Alarma.c). gcc >= 10 las rechaza por defecto. Con
#           -fcommon se enlaza como en el PIC: se mide el firmware real.
# -finput-charset/-fexec-charset CP1252: los fuentes vienen en Windows-1252 y el
#           delimitador de trama es el byte 0xBF. En UTF-8 se leeria mal y el
#           protocolo dejaria de coincidir con el del equipo.
BANDERAS = [
    "-std=c11",
    "-fcommon",
    "-finput-charset=CP1252",
    "-fexec-charset=CP1252",
    "-Wno-unknown-pragmas",   # los #pragma config de main.h son de XC8
    "-Wall",
    "-Wno-unused-variable",
    "-Wno-unused-but-set-variable",
]

INCLUDES = [
    "-I", os.path.join(AQUI, "stubs"),
    "-I", os.path.join(AQUI, "sim"),
    "-I", FW,
]


def abortar(motivo, detalle=""):
    print("\nABORTADO: " + motivo)
    if detalle:
        print(detalle)
    print("\nUn instrumento que no corre no dice NADA del firmware.")
    sys.exit(2)


def main():
    if not os.path.isfile(GCC):
        abortar(
            "no esta el compilador en %s" % GCC,
            "Este arnes no usa el gcc del PATH a proposito. Instala MinGW-w64 en\n"
            "una ruta SIN acentos ni enes, o corrige la constante GCC de este archivo.",
        )

    if not os.path.isdir(FW):
        abortar("no encuentro el firmware en %s" % FW)

    fuentes = [os.path.join(FW, f) for f in FUENTES_FW]
    faltan = [f for f in fuentes if not os.path.isfile(f)]
    if faltan:
        abortar(
            "faltan fuentes del firmware",
            "\n".join("  " + f for f in faltan)
            + "\n\nSi se movio o renombro un .c, actualizar FUENTES_FW en el MISMO\n"
              "commit. Un arnes que apunta a un archivo que ya no existe no grita:\n"
              "aborta, y quien mire por encima lo confunde con un fallo del firmware.",
        )

    print("Compilando el firmware real con %s ..." % GCC)

    objetos = []
    obj_dir = os.path.join(AQUI, "obj")
    if not os.path.isdir(obj_dir):
        os.makedirs(obj_dir)

    # Serial.c lleva una bandera extra: renombra transmitUart1 para que el arnes
    # pueda envolverla. Ver la cabecera de arnes.c.
    for ruta in fuentes:
        extra = []
        if os.path.basename(ruta) == "Serial.c":
            extra = ["-DtransmitUart1=fw_transmitUart1"]
        obj = os.path.join(obj_dir, os.path.basename(ruta) + ".o")
        cmd = [GCC] + BANDERAS + INCLUDES + extra + ["-c", ruta, "-o", obj]
        r = subprocess.run(cmd, capture_output=True, text=True, errors="replace")
        if r.returncode != 0:
            abortar("no compila %s" % os.path.basename(ruta), r.stdout + r.stderr)
        objetos.append(obj)

    for ruta in [os.path.join(AQUI, "sim", "plataforma.c"), os.path.join(AQUI, "arnes.c")]:
        obj = os.path.join(obj_dir, os.path.basename(ruta) + ".o")
        cmd = [GCC] + BANDERAS + INCLUDES + ["-c", ruta, "-o", obj]
        r = subprocess.run(cmd, capture_output=True, text=True, errors="replace")
        if r.returncode != 0:
            abortar("no compila %s" % os.path.basename(ruta), r.stdout + r.stderr)
        objetos.append(obj)

    r = subprocess.run([GCC] + objetos + ["-o", SALIDA],
                       capture_output=True, text=True, errors="replace")
    if r.returncode != 0:
        abortar("no enlaza el arnes", r.stdout + r.stderr)

    print("Compilado. Corriendo el arnes ...\n")

    r = subprocess.run([SALIDA], capture_output=True, text=True, errors="replace")
    sys.stdout.write(r.stdout)
    if r.stderr:
        sys.stderr.write(r.stderr)

    if r.returncode not in (0, 1):
        abortar("el arnes murio con codigo %d" % r.returncode,
                "Un arnes que se cae a mitad no midio los escenarios que faltaban.")

    if r.returncode == 0:
        print("\nRESULTADO: PASS")
    else:
        print("\nRESULTADO: FALLA")
    return r.returncode


if __name__ == "__main__":
    sys.exit(main())
