#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
servidor_interactivo.py
Servidor Web y Puente en Tiempo Real entre la UI Web (APK Emulator)
y el Firmware PIC18F2550 compilado en C (arnes.exe --interactivo).
"""

import http.server
import json
import os
import subprocess
import sys
import threading
import time
import webbrowser

AQUI = os.path.dirname(os.path.abspath(__file__))
HTML_DIR = os.path.join(AQUI, "emulador_app")
ARNES_EXE = os.path.join(AQUI, "arnes.exe")

proc_sim = None
sim_lock = threading.Lock()

def arrancar_subproceso_simulador():
    global proc_sim
    if not os.path.exists(ARNES_EXE):
        print(f"[ERROR] No se encuentra {ARNES_EXE}")
        return False
    
    proc_sim = subprocess.Popen(
        [ARNES_EXE, "--interactivo"],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        cwd=AQUI,
        text=True,
        bufsize=1
    )
    
    # Leer hasta [SIM_LISTO]
    for line in proc_sim.stdout:
        if "[SIM_LISTO]" in line:
            print(">>> Firmware PIC18F2550 en C Inicializado y Listo en Memoria. <<<")
            break
    return True

def enviar_a_firmware(trama):
    global proc_sim
    with sim_lock:
        if proc_sim is None or proc_sim.poll() is not None:
            arrancar_subproceso_simulador()
            if proc_sim is None:
                return {"error": "Simulador no disponible", "tx": "", "lamp": 0}

        try:
            proc_sim.stdin.write(trama + "\n")
            proc_sim.stdin.flush()

            tx_lines = []
            capturando_tx = False
            lamp_state = 0

            for line in proc_sim.stdout:
                line_str = line.rstrip("\r\n")
                if line_str == "[TX_START]":
                    capturando_tx = True
                    continue
                elif line_str == "[TX_END]":
                    capturando_tx = False
                    continue
                elif line_str.startswith("[LAMP]:"):
                    lamp_state = int(line_str.split(":")[1])
                    continue
                elif line_str == "[SIM_OK]":
                    break

                if capturando_tx:
                    tx_lines.append(line_str)

            return {
                "ok": True,
                "tx": "\n".join(tx_lines),
                "lamp": lamp_state
            }
        except Exception as e:
            return {"ok": False, "error": str(e), "tx": "", "lamp": 0}

class SimuladorHTTPHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=HTML_DIR, **kwargs)

    def do_POST(self):
        if self.path == "/api/uart":
            content_length = int(self.headers.get("Content-Length", 0))
            body = self.rfile.read(content_length).decode("utf-8")
            data = json.loads(body)
            trama = data.get("trama", "")
            
            print(f"[RX de la App -> Firmware]: {repr(trama)}")
            res = enviar_a_firmware(trama)
            print(f"[TX del Firmware -> App]: {repr(res.get('tx', ''))} (Lamp: {res.get('lamp')})")

            self.send_response(200)
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.send_header("Access-Control-Allow-Origin", "*")
            self.end_headers()
            self.wfile.write(json.dumps(res).encode("utf-8"))
        else:
            self.send_response(404)
            self.end_headers()

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()

def main():
    print("================================================================================")
    print("      SERVIDOR INTERACTIVO PUENTE APP <-> FIRMWARE C EN TIEMPO REAL             ")
    print("================================================================================\n")
    
    if not arrancar_subproceso_simulador():
        sys.exit(1)

    puerto = 8080
    servidor = http.server.ThreadingHTTPServer(("0.0.0.0", puerto), SimuladorHTTPHandler)
    print(f"\n>>> Servidor Web y Bridge activo en http://localhost:{puerto} <<<")
    print(f">>> Abriendo en el navegador...")
    
    webbrowser.open(f"http://localhost:{puerto}")
    
    try:
        servidor.serve_forever()
    except KeyboardInterrupt:
        print("\nCerrando servidor...")
        if proc_sim:
            proc_sim.stdin.write("SALIR\n")
            proc_sim.terminate()

if __name__ == "__main__":
    main()
