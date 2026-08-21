#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
generar_word.py - Convierte los manuales de .md a .docx

POR QUE EXISTE
--------------
Los manuales se escriben en Markdown, que es lo que se versiona y lo que se
puede comparar entre versiones. Pero al que va al campo, al funcional y al
responsable les llega el **Word**.

La regla del proyecto es: **el .md es la fuente unica**. Si se edita el .md hay
que regenerar el .docx EN EL MISMO CAMBIO -- no es un paso posterior, es parte
del cambio.

Si se edita el .docx a mano queda una segunda copia que diverge de la primera
sin que nadie lo note hasta que alguien las compara. Y si se edita el .md y
nadie regenera, la correccion **no existe** para quien la necesita: al que va al
camion le llega el Word, no el fuente.

USO
---
    python generar_word.py              # regenera todos los .md de esta carpeta
    python generar_word.py FICHERO.md   # solo ese
    python generar_word.py --revisar    # NO genera: solo avisa de los .docx
                                        # mas viejos que su .md. Codigo de
                                        # salida 1 si hay alguno desfasado.

`--revisar` es lo que hay que correr antes de mandar un paquete a nadie. En otro
proyecto de la casa hubo dos manuales **85 horas** desfasados, y las
definiciones nuevas nunca llegaron al documento de campo.

DEPENDE DE
----------
pandoc, en el PATH. Si no esta, el script aborta y dice donde bajarlo -- no
intenta apanarselo con otra herramienta, porque un .docx generado de otra forma
saldria con otro aspecto y nadie sabria por que.
"""

import os
import subprocess
import sys

AQUI = os.path.dirname(os.path.abspath(__file__))


def buscar_pandoc():
    for cmd in ("pandoc", "pandoc.exe"):
        try:
            r = subprocess.run([cmd, "--version"], capture_output=True, text=True)
            if r.returncode == 0:
                return cmd
        except (OSError, FileNotFoundError):
            continue
    return None


def markdowns():
    return sorted(
        f for f in os.listdir(AQUI)
        if f.endswith(".md") and not f.startswith("_")
    )


def revisar():
    """Avisa de los .docx que se han quedado atras. No genera nada."""
    desfasados = []
    sin_word = []
    for md in markdowns():
        docx = md[:-3] + ".docx"
        p_md = os.path.join(AQUI, md)
        p_dx = os.path.join(AQUI, docx)
        if not os.path.isfile(p_dx):
            sin_word.append(md)
        elif os.path.getmtime(p_dx) < os.path.getmtime(p_md):
            horas = (os.path.getmtime(p_md) - os.path.getmtime(p_dx)) / 3600.0
            desfasados.append((md, horas))

    if not desfasados and not sin_word:
        print("Todos los .docx estan al dia con su .md.")
        return 0

    for md in sin_word:
        print("SIN WORD    %s  (nunca se genero)" % md)
    for md, horas in desfasados:
        print("DESFASADO   %s  (el .md es %.0f horas mas nuevo)" % (md, horas))
    print("\nAl que va al campo le llega el Word, no el .md.")
    print("Regenera con:  python generar_word.py")
    return 1


def convertir(pandoc, md):
    docx = md[:-3] + ".docx"
    cmd = [
        pandoc,
        os.path.join(AQUI, md),
        "-f", "gfm",                 # tablas y listas de tareas de GitHub
        "-o", os.path.join(AQUI, docx),
        "--toc",                     # indice: son documentos largos
        "--toc-depth=3",
        "--highlight-style=tango",
        "-V", "lang=es",
    ]
    r = subprocess.run(cmd, capture_output=True, text=True, errors="replace")
    if r.returncode != 0:
        print("  FALLO %s" % md)
        print(r.stdout + r.stderr)
        return False
    tam = os.path.getsize(os.path.join(AQUI, docx)) / 1024.0
    print("  %-38s -> %-38s %7.1f KB" % (md, docx, tam))
    return True


def main():
    if "--revisar" in sys.argv:
        return revisar()

    pandoc = buscar_pandoc()
    if pandoc is None:
        print("ABORTADO: no encuentro pandoc en el PATH.")
        print("Descargalo de https://pandoc.org/installing.html")
        print("\nNo se genera el Word con otra herramienta a proposito: saldria")
        print("con otro aspecto y nadie sabria por que los manuales no se parecen.")
        return 2

    objetivo = [a for a in sys.argv[1:] if a.endswith(".md")]
    lista = objetivo if objetivo else markdowns()

    print("Generando Word desde el .md fuente (pandoc):\n")
    fallos = 0
    for md in lista:
        if not convertir(pandoc, md):
            fallos += 1

    print("\n%d de %d generados." % (len(lista) - fallos, len(lista)))
    if fallos:
        return 1

    print("\nRecordatorio: el .md es la fuente unica. El .docx NO se edita a mano.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
