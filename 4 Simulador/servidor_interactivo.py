import os
import sys
import json
import time
import subprocess
from http.server import HTTPServer, BaseHTTPRequestHandler

# Servidor interactivo que conecta la UI Web con arnes.exe vía pipes
PORT = 8080
ARN_PATH = r"D:\@Proyect\Baliza\4 Simulador\arnes.exe"

process = None

def start_backend():
    global process
    if process is not None:
        try:
            process.kill()
        except:
            pass
    process = subprocess.Popen(
        [ARN_PATH, "--interactivo"],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=False,
        bufsize=0
    )
    time.sleep(0.2)
    # Clear initial banner
    try:
        import msvcrt
        # drain initial bytes if any
    except:
        pass

def send_uart_frame(frame_bytes):
    global process
    if process is None or process.poll() is not None:
        start_backend()
    
    try:
        process.stdin.write(frame_bytes)
        process.stdin.flush()
        
        # Give firmware enough cycles to execute and transmit full multi-line response
        time.sleep(0.35)
        
        # Read available bytes from stdout non-blocking
        import ctypes
        from ctypes import wintypes
        kernel32 = ctypes.windll.kernel32
        
        handle = msvcrt.get_osfhandle(process.stdout.fileno())
        avail = wintypes.DWORD()
        res = kernel32.PeekNamedPipe(handle, None, 0, None, ctypes.byref(avail), None)
        
        response_bytes = b""
        if res and avail.value > 0:
            response_bytes = process.stdout.read(avail.value)
        
        return response_bytes.decode('latin1', errors='ignore')
    except Exception as e:
        print(f"Error UART: {e}")
        return ""

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/' or self.path == '/index.html':
            self.send_response(200)
            self.send_header('Content-Type', 'text/html; charset=utf-8')
            self.end_headers()
            with open(r"D:\@Proyect\Baliza\4 Simulador\emulador_app\index.html", 'rb') as f:
                self.wfile.write(f.read())
        else:
            self.send_error(404)

    def do_POST(self):
        if self.path == '/api/uart':
            content_length = int(self.headers.get('Content-Length', 0))
            body = self.rfile.read(content_length).decode('utf-8')
            data = json.loads(body)
            trama_str = data.get('trama', '')
            
            # Convert string to bytes handling \xBF
            trama_bytes = trama_str.encode('latin1')
            respuesta = send_uart_frame(trama_bytes)
            
            self.send_response(200)
            self.send_header('Content-Type', 'application/json; charset=utf-8')
            self.end_headers()
            self.wfile.write(json.dumps({'respuesta': respuesta}).encode('utf-8'))
        else:
            self.send_error(404)

    def log_message(self, format, *args):
        pass

if __name__ == '__main__':
    import msvcrt
    start_backend()
    server = HTTPServer(('127.0.0.1', PORT), Handler)
    print(f"Servidor Interactivo Baliza IT VIAL corriendo en http://localhost:{PORT}")
    server.serve_forever()
