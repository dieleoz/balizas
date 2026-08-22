#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
lanzar_emulador.py
Lanzador del Emulador Visual Interactivo de la Aplicación IT VIAL 30 (v3.3)
Abre la interfaz en el navegador predeterminado para interactuar y capturar pantallas.
"""

import os
import sys
import webbrowser

AQUI = os.path.dirname(os.path.abspath(__file__))
HTML_PATH = os.path.join(AQUI, "index.html")

def main():
    print("================================================================================")
    print("      LANZADOR DEL EMULADOR INTERACTIVO IT VIAL 30 (v3.3)                       ")
    print("================================================================================\n")
    print(f"Abriendo interfaz en el navegador web: {HTML_PATH}")
    
    if os.path.exists(HTML_PATH):
        webbrowser.open(f"file:///{os.path.abspath(HTML_PATH)}")
        print("\n>>> Emulador abierto exitosamente. Puedes probar botones, tramas y capturas. <<<")
    else:
        print("Error: No se encontró index.html")
        sys.exit(1)

if __name__ == "__main__":
    main()
