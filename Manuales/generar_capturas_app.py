#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
generar_capturas_app.py
Genera capturas de pantalla de alta fidelidad para el Manual de Usuario de la App Móvil IT VIAL 30.
"""

import os
from PIL import Image, ImageDraw, ImageFont

# ---------------------------------------------------------------------------
# Los emoji salian como CUADROS VACIOS en las figuras del manual.
#
# Estas ilustraciones se dibujan con Arial, que no tiene glifos de emoji: PIL
# no falla, dibuja el rectangulo de "caracter ausente". En pantalla se ve un
# cuadrito; en un manual que va a la interventoria se ve como un documento roto.
#
# En vez de ir quitandolos uno a uno cada vez que alguien anade texto, se filtra
# aqui: lo que la fuente no puede representar, no se dibuja. Latin-1 cubre todo
# el castellano con acentos y enes, que es lo que estas figuras necesitan.
_dibujar_original = ImageDraw.ImageDraw.text


def _dibujar_sin_tofu(self, xy, text, *a, **kw):
    if isinstance(text, str):
        text = "".join(c for c in text if ord(c) < 0x2500)
        text = text.replace("  ", " ").strip() if text.strip() else text
    return _dibujar_original(self, xy, text, *a, **kw)


ImageDraw.ImageDraw.text = _dibujar_sin_tofu
# ---------------------------------------------------------------------------

AQUI = os.path.dirname(os.path.abspath(__file__))
IMG_DIR = os.path.join(AQUI, "img")
os.makedirs(IMG_DIR, exist_ok=True)

# Intentar cargar fuentes de Windows
def get_fonts():
    try:
        font_regular = ImageFont.truetype("arial.ttf", 16)
        font_bold = ImageFont.truetype("arialbd.ttf", 16)
        font_title = ImageFont.truetype("arialbd.ttf", 20)
        font_small = ImageFont.truetype("arial.ttf", 13)
        font_small_bold = ImageFont.truetype("arialbd.ttf", 13)
        font_mono = ImageFont.truetype("consola.ttf", 13)
        font_button = ImageFont.truetype("arialbd.ttf", 15)
        font_bar = ImageFont.truetype("arialbd.ttf", 18)
    except Exception:
        font_regular = ImageFont.load_default()
        font_bold = ImageFont.load_default()
        font_title = ImageFont.load_default()
        font_small = ImageFont.load_default()
        font_small_bold = ImageFont.load_default()
        font_mono = ImageFont.load_default()
        font_button = ImageFont.load_default()
        font_bar = ImageFont.load_default()
    return {
        "reg": font_regular, "bold": font_bold, "title": font_title,
        "small": font_small, "small_bold": font_small_bold,
        "mono": font_mono, "btn": font_button, "bar": font_bar
    }

FONTS = get_fonts()

def draw_status_bar(draw, width=420):
    # Fondo barra estado
    draw.rectangle([0, 0, width, 28], fill="#37474F")
    draw.text((14, 6), "08:30", fill="#FFFFFF", font=FONTS["small"])
    draw.text((width - 95, 6), "📶 100% 🔋", fill="#FFFFFF", font=FONTS["small"])

def draw_action_bar(draw, title="IT VIAL 30", width=420):
    draw.rectangle([0, 28, width, 80], fill="#D32F2F")
    # Icono logo
    icon_path = os.path.join(IMG_DIR, "logo_icon.png")
    if os.path.exists(icon_path):
        try:
            im_icon = Image.open(icon_path).resize((40, 40), Image.Resampling.LANCZOS)
            # Pegado luego sobre lienzo
        except Exception:
            pass
    draw.text((65, 42), title, fill="#FFFFFF", font=FONTS["bar"])

def create_phone_frame(height=840, width=420, bg="#ECEFF1"):
    img = Image.new("RGB", (width, height), bg)
    draw = ImageDraw.Draw(img)
    draw_status_bar(draw, width)
    return img, draw

# ==========================================
# 1. CAPTURA PASO 1: INSTALACIÓN APK
# ==========================================
def gen_paso1_instalacion():
    w, h = 420, 680
    img, draw = create_phone_frame(h, w, bg="#263238")
    
    # Fondo semi transparente / oscurecido estilo WhatsApp
    draw.rectangle([0, 28, w, h], fill="#37474F")
    draw.text((20, 60), "WhatsApp · Archivo recibido", fill="#B0BEC5", font=FONTS["small"])
    
    # Burbuja WhatsApp
    draw.rounded_rectangle([20, 90, w - 20, 190], radius=12, fill="#E1F5FE")
    draw.rectangle([35, 105, 75, 145], fill="#0288D1")
    draw.text((45, 115), "APK", fill="#FFFFFF", font=FONTS["bold"])
    draw.text((85, 110), "Baliza_v3.3.apk", fill="#212121", font=FONTS["bold"])
    draw.text((85, 135), "3.4 MB  ·  Aplicación Oficial IT VIAL 30", fill="#546E7A", font=FONTS["small"])
    
    # Modal "Abrir con"
    draw.rounded_rectangle([25, 230, w - 25, 590], radius=24, fill="#FFFFFF")
    draw.text((50, 260), "Abrir con", fill="#212121", font=FONTS["title"])
    
    # Opción Tienda
    draw.rounded_rectangle([60, 310, 160, 410], radius=16, fill="#F5F5F5")
    draw.rounded_rectangle([80, 325, 140, 385], radius=12, fill="#0288D1")
    draw.text((87, 345), "HONOR", fill="#FFFFFF", font=FONTS["small_bold"])
    draw.text((65, 420), "Tienda de apps", fill="#455A64", font=FONTS["small"])
    
    # Opción Instalador de paquetes (DESTACADA)
    draw.rounded_rectangle([240, 310, 340, 410], radius=16, fill="#E0F2F1")
    draw.rounded_rectangle([260, 325, 320, 385], radius=12, fill="#00796B")
    draw.text((280, 340), "📥", fill="#FFFFFF", font=FONTS["bold"])
    draw.text((230, 420), "Instalador de paquetes", fill="#004D40", font=FONTS["small_bold"])
    
    # Circulo naranja de indicacion
    draw.ellipse([230, 295, 350, 440], outline="#E65100", width=4)
    
    # Botones Siempre / Solo una vez
    draw.rounded_rectangle([50, 470, w - 50, 515], radius=22, fill="#F0F4F8")
    draw.text((175, 485), "Siempre", fill="#1976D2", font=FONTS["bold"])
    
    draw.rounded_rectangle([50, 525, w - 50, 570], radius=22, fill="#F0F4F8")
    draw.text((155, 540), "Solo una vez", fill="#1976D2", font=FONTS["bold"])
    
    # Barra navegacion inferior
    draw.rectangle([0, h-40, w, h], fill="#212121")
    draw.text((w//2 - 20, h-30), "◀   ●   ■", fill="#9E9E9E", font=FONTS["small"])
    
    img.save(os.path.join(IMG_DIR, "paso1_instalacion_apk.png"))

# ==========================================
# 1.2 DETALLE: CONFIRMAR INSTALACIÓN
# ==========================================
def gen_paso1_confirmacion():
    w, h = 420, 340
    img, draw = create_phone_frame(h, w, bg="#263238")
    
    # Modal "¿Deseas instalar esta app?"
    draw.rounded_rectangle([20, 60, w - 20, 270], radius=20, fill="#FFFFFF")
    
    # Icono IT VIAL
    icon_path = os.path.join(IMG_DIR, "logo_icon.png")
    if os.path.exists(icon_path):
        try:
            im_icon = Image.open(icon_path).resize((44, 44), Image.Resampling.LANCZOS)
            img.paste(im_icon, (40, 80))
        except Exception:
            draw.rounded_rectangle([40, 80, 84, 124], radius=10, fill="#FFA000")
            draw.text((54, 90), "t", fill="#212121", font=FONTS["title"])
    else:
        draw.rounded_rectangle([40, 80, 84, 124], radius=10, fill="#FFA000")
        draw.text((54, 90), "t", fill="#212121", font=FONTS["title"])
    
    draw.text((95, 90), "IT VIAL 30", fill="#1A1A1A", font=FONTS["title"])
    draw.text((40, 145), "¿Deseas instalar esta app?", fill="#333333", font=FONTS["reg"])
    
    # Botones Cancelar / Instalar
    draw.text((70, 215), "Cancelar", fill="#1976D2", font=FONTS["bold"])
    draw.text((w - 130, 215), "Instalar", fill="#1976D2", font=FONTS["bold"])
    
    # Circulo o indicacion en Instalar
    draw.rounded_rectangle([w - 145, 205, w - 50, 245], radius=8, outline="#E65100", width=2)
    
    img.save(os.path.join(IMG_DIR, "paso1_confirmar_instalacion.png"))


# ==========================================
# 1.3 DETALLE: PROGRESO INSTALACIÓN
# ==========================================
def gen_paso1_progreso():
    w, h = 420, 340
    img, draw = create_phone_frame(h, w, bg="#263238")
    
    # Modal "Instalando..."
    draw.rounded_rectangle([20, 60, w - 20, 270], radius=20, fill="#FFFFFF")
    
    # Icono IT VIAL
    icon_path = os.path.join(IMG_DIR, "logo_icon.png")
    if os.path.exists(icon_path):
        try:
            im_icon = Image.open(icon_path).resize((44, 44), Image.Resampling.LANCZOS)
            img.paste(im_icon, (40, 80))
        except Exception:
            draw.rounded_rectangle([40, 80, 84, 124], radius=10, fill="#FFA000")
            draw.text((54, 90), "t", fill="#212121", font=FONTS["title"])
    else:
        draw.rounded_rectangle([40, 80, 84, 124], radius=10, fill="#FFA000")
        draw.text((54, 90), "t", fill="#212121", font=FONTS["title"])
    
    draw.text((95, 90), "IT VIAL 30", fill="#1A1A1A", font=FONTS["title"])
    draw.text((40, 145), "Instalando...", fill="#333333", font=FONTS["reg"])
    
    # Barra de progreso
    draw.rounded_rectangle([40, 180, w - 40, 186], radius=3, fill="#ECEFF1")
    draw.rounded_rectangle([40, 180, 240, 186], radius=3, fill="#1976D2")
    
    # Boton Cancelar atenuado
    draw.text((w // 2 - 35, 225), "Cancelar", fill="#B0BEC5", font=FONTS["bold"])
    
    img.save(os.path.join(IMG_DIR, "paso1_instalando_progreso.png"))


# ==========================================
# 1.4 DETALLE: GOOGLE PLAY PROTECT
# ==========================================
def gen_paso1_play_protect():
    w, h = 420, 720
    img, draw = create_phone_frame(h, w, bg="#FAFAFA")
    
    # Header Play Protect
    draw.text((w // 2 - 75, 45), "🛡️ Google Play Protect", fill="#424242", font=FONTS["bold"])
    
    # Titulo Principal
    draw.text((40, 90), "Se bloqueó la app no", fill="#1A1A1A", font=FONTS["title"])
    draw.text((150, 125), "segura", fill="#1A1A1A", font=FONTS["title"])
    
    # Tarjeta Pill App
    draw.rounded_rectangle([30, 175, w - 30, 245], radius=30, fill="#F0F4F8")
    icon_path = os.path.join(IMG_DIR, "logo_icon.png")
    if os.path.exists(icon_path):
        try:
            im_icon = Image.open(icon_path).resize((40, 40), Image.Resampling.LANCZOS)
            img.paste(im_icon, (50, 190))
        except Exception:
            draw.rounded_rectangle([50, 190, 90, 230], radius=8, fill="#FFA000")
            draw.text((62, 198), "t", fill="#212121", font=FONTS["title"])
    else:
        draw.rounded_rectangle([50, 190, 90, 230], radius=8, fill="#FFA000")
        draw.text((62, 198), "t", fill="#212121", font=FONTS["title"])
    
    # Insignia de advertencia amarilla
    draw.ellipse([80, 218, 98, 236], fill="#FBC02D")
    draw.text((86, 218), "!", fill="#212121", font=FONTS["small_bold"])
    
    draw.text((105, 200), "IT VIAL 30", fill="#1A1A1A", font=FONTS["title"])
    
    # Texto explicativo de Play Protect
    draw.text((30, 275), "Esta app se diseñó para una versión anterior de\n"
                         "Android, por lo que no incluye las protecciones de\n"
                         "la privacidad más recientes.\n\n"
                         "La instalación de esta app podría poner tu\n"
                         "dispositivo en riesgo.", fill="#424242", font=FONTS["reg"])
    
    draw.text((30, 400), "Obtén más información sobre Play Protect.", fill="#1565C0", font=FONTS["small"])
    
    # ENLACE CRÍTICO: "Instalar de todas formas" (Destacado con flecha/caja)
    draw.rounded_rectangle([25, 455, 260, 500], radius=8, outline="#E65100", width=2)
    draw.text((35, 470), "👉 Instalar de todas formas", fill="#BF360C", font=FONTS["bold"])
    
    # Boton Azul "Entendido" (Con nota de NO pulsar para no cancelar)
    draw.rounded_rectangle([30, 530, w - 30, 585], radius=16, fill="#D3E3FD")
    draw.text((w // 2 - 40, 550), "Entendido", fill="#041E49", font=FONTS["btn"])
    
    # Nota explicativa
    draw.rounded_rectangle([25, 610, w - 25, 680], radius=8, fill="#FFF3E0", outline="#FFE0B2")
    draw.text((35, 620), "⚠️ IMPORTANTE: Toque 'Instalar de todas formas'.", fill="#E65100", font=FONTS["small_bold"])
    draw.text((35, 645), "Si pulsa 'Entendido', la instalación se cancelará.", fill="#D84315", font=FONTS["small"])

    # Barra navegacion
    draw.rectangle([0, h-35, w, h], fill="#ECEFF1")
    draw.text((w//2 - 20, h-25), "◀   ●   ■", fill="#78909C", font=FONTS["small"])

    img.save(os.path.join(IMG_DIR, "paso1_play_protect_bloqueo.png"))


# ==========================================
# 1.5 DETALLE: INSTALACIÓN FINALIZADA ("Se instaló la app")
# ==========================================
def gen_paso1_instalado_final():
    w, h = 420, 340
    img, draw = create_phone_frame(h, w, bg="#263238")
    
    # Modal "Se instaló la app."
    draw.rounded_rectangle([20, 60, w - 20, 270], radius=20, fill="#FFFFFF")
    
    # Icono IT VIAL
    icon_path = os.path.join(IMG_DIR, "logo_icon.png")
    if os.path.exists(icon_path):
        try:
            im_icon = Image.open(icon_path).resize((44, 44), Image.Resampling.LANCZOS)
            img.paste(im_icon, (40, 80))
        except Exception:
            draw.rounded_rectangle([40, 80, 84, 124], radius=10, fill="#FFA000")
            draw.text((54, 90), "t", fill="#212121", font=FONTS["title"])
    else:
        draw.rounded_rectangle([40, 80, 84, 124], radius=10, fill="#FFA000")
        draw.text((54, 90), "t", fill="#212121", font=FONTS["title"])
    
    draw.text((95, 90), "IT VIAL 30", fill="#1A1A1A", font=FONTS["title"])
    draw.text((40, 145), "Se instaló la app.", fill="#333333", font=FONTS["reg"])
    
    # Botones Listo / Abrir
    draw.text((70, 215), "Listo", fill="#1976D2", font=FONTS["bold"])
    draw.text((w - 115, 215), "Abrir", fill="#1976D2", font=FONTS["bold"])
    
    # Destacar "Abrir"
    draw.rounded_rectangle([w - 130, 205, w - 40, 245], radius=8, outline="#E65100", width=2)
    
    img.save(os.path.join(IMG_DIR, "paso1_instalacion_finalizada.png"))


# ==========================================
# 1.6 DETALLE: SOLICITUD DE PERMISOS DISPOSITIVOS CERCANOS
# ==========================================
def gen_paso2_permisos_runtime():
    w, h = 420, 720
    img, draw = create_phone_frame(h, w, bg="#CFD8DC")
    
    # Fondo con login semi visible
    draw.rounded_rectangle([40, 80, w - 40, 600], radius=16, fill="#ECEFF1")
    icon_path = os.path.join(IMG_DIR, "logo_icon.png")
    if os.path.exists(icon_path):
        try:
            im_icon = Image.open(icon_path).resize((50, 50), Image.Resampling.LANCZOS)
            img.paste(im_icon, (w // 2 - 25, 140))
        except Exception:
            pass
            
    # Modal Permisos Android
    draw.rounded_rectangle([25, 240, w - 25, 620], radius=24, fill="#FFFFFF")
    
    # Icono rombo permisos
    draw.text((w // 2 - 12, 265), "❖", fill="#212121", font=FONTS["title"])
    
    draw.text((45, 310), "¿Permitir que IT VIAL 30\n"
                         "encuentre dispositivos\n"
                         "cercanos, se conecte a ellos\n"
                         "y determine su ubicación\n"
                         "relativa?", fill="#212121", font=FONTS["bold"])
    
    # Boton Permitir (DESTACADO)
    draw.rounded_rectangle([45, 475, w - 45, 520], radius=22, fill="#F0F4F8")
    draw.text((w // 2 - 30, 490), "Permitir", fill="#1976D2", font=FONTS["bold"])
    draw.rounded_rectangle([45, 475, w - 45, 520], radius=22, outline="#E65100", width=3)
    
    # Boton No permitir
    draw.rounded_rectangle([45, 545, w - 45, 590], radius=22, fill="#F0F4F8")
    draw.text((w // 2 - 45, 560), "No permitir", fill="#1976D2", font=FONTS["bold"])
    
    # Toast flotante "EL Bluetooth esta Apagado"
    draw.rounded_rectangle([60, 525, w - 60, 565], radius=18, fill="#424242")
    draw.text((95, 538), "EL Bluetooth esta Apagado", fill="#FFFFFF", font=FONTS["small"])

    # Barra navegacion
    draw.rectangle([0, h-35, w, h], fill="#B0BEC5")
    draw.text((w//2 - 20, h-25), "◀   ●   ■", fill="#37474F", font=FONTS["small"])

    img.save(os.path.join(IMG_DIR, "paso2_permisos_dispositivos_cercanos.png"))


# ==========================================
# 1.7 DETALLE: SOLICITUD DE HABILITACIÓN DE BLUETOOTH
# ==========================================
def gen_paso2_habilitar_bt():
    w, h = 420, 720
    img, draw = create_phone_frame(h, w, bg="#ECEFF1")
    draw_action_bar(draw, "IT VIAL 30", w)
    
    # Fondo con la tarjeta de Login real
    draw.rounded_rectangle([24, 100, w - 24, 650], radius=16, fill="#FFFFFF", outline="#CFD8DC")
    
    banner_path = os.path.join(IMG_DIR, "logo_banner.png")
    if os.path.exists(banner_path):
        try:
            im_ban = Image.open(banner_path)
            bw = w - 80
            bh = int(im_ban.height * (bw / im_ban.width))
            if bh > 70: bh = 70
            im_ban = im_ban.resize((bw, bh), Image.Resampling.LANCZOS)
            img.paste(im_ban, (40, 115))
        except Exception:
            pass
            
    draw.text((105, 195), "BALIZA IT VIAL 30", fill="#D32F2F", font=FONTS["title"])
    draw.text((85, 225), "Versión v3.3 · Control y Diagnóstico", fill="#546E7A", font=FONTS["small"])
    
    draw.text((45, 260), "Usuario:", fill="#37474F", font=FONTS["bold"])
    draw.rounded_rectangle([45, 285, w - 45, 330], radius=8, fill="#FAFAFA", outline="#90A4AE")
    draw.text((60, 300), "admin", fill="#212121", font=FONTS["reg"])
    
    draw.text((45, 350), "Contraseña:", fill="#37474F", font=FONTS["bold"])
    draw.rounded_rectangle([45, 375, w - 45, 420], radius=8, fill="#FAFAFA", outline="#90A4AE")
    draw.text((60, 390), "•••••", fill="#212121", font=FONTS["reg"])
    
    draw.rounded_rectangle([45, 450, w - 45, 495], radius=10, fill="#D32F2F")
    draw.text((w // 2 - 35, 465), "ENTRAR", fill="#FFFFFF", font=FONTS["btn"])
    
    # Capa oscura modal
    overlay = Image.new("RGBA", (w, h), (0, 0, 0, 100))
    img.paste(overlay, (0, 0), overlay)
    draw = ImageDraw.Draw(img)
    
    # Modal "¿Permitir que IT VIAL 30 habilite Bluetooth?"
    draw.rounded_rectangle([20, 480, w - 20, 680], radius=24, fill="#FFFFFF")
    draw.text((40, 510), "¿Permitir que IT VIAL 30\n"
                         "habilite Bluetooth?", fill="#212121", font=FONTS["title"])
    
    # Boton Rechazar
    draw.rounded_rectangle([40, 605, 180, 650], radius=20, fill="#F5F5F5")
    draw.text((75, 620), "Rechazar", fill="#1976D2", font=FONTS["bold"])
    
    # Boton Permitir (DESTACADO)
    draw.rounded_rectangle([w - 180, 605, w - 40, 650], radius=20, fill="#F5F5F5")
    draw.text((w - 145, 620), "Permitir", fill="#1976D2", font=FONTS["bold"])
    draw.rounded_rectangle([w - 180, 605, w - 40, 650], radius=20, outline="#E65100", width=3)

    # Barra navegacion
    draw.rectangle([0, h-35, w, h], fill="#B0BEC5")
    draw.text((w//2 - 20, h-25), "◀   ●   ■", fill="#37474F", font=FONTS["small"])

    img.save(os.path.join(IMG_DIR, "paso2_habilitar_bluetooth_dialog.png"))







# ==========================================
# 2. CAPTURA PASO 2: EMPAREJAMIENTO BT
# ==========================================
def gen_paso2_bluetooth():
    w, h = 420, 680
    img, draw = create_phone_frame(h, w, bg="#FAFAFA")
    
    # Header Ajustes
    draw.rectangle([0, 28, w, 80], fill="#FFFFFF")
    draw.text((20, 45), "← Bluetooth", fill="#212121", font=FONTS["title"])
    
    # Switch Bluetooth ON
    draw.rounded_rectangle([20, 95, w - 20, 150], radius=10, fill="#FFFFFF", outline="#E0E0E0")
    draw.text((35, 115), "Bluetooth activado", fill="#212121", font=FONTS["bold"])
    draw.rounded_rectangle([w - 80, 110, w - 35, 135], radius=12, fill="#4CAF50")
    draw.ellipse([w - 55, 112, w - 37, 133], fill="#FFFFFF")
    
    # Seccion Dispositivos Disponibles
    draw.text((25, 175), "DISPOSITIVOS DISPONIBLES", fill="#757575", font=FONTS["small_bold"])
    
    # Item JDY-31
    draw.rounded_rectangle([20, 200, w - 20, 275], radius=10, fill="#FFFFFF", outline="#00C853", width=2)
    draw.text((35, 215), "📶 JDY-31-SPP", fill="#2E7D32", font=FONTS["bold"])
    draw.text((35, 240), "Dirección MAC: 20:22:08:21:49:15 · Tocar para vincular", fill="#616161", font=FONTS["small"])
    
    # Modal PIN
    draw.rounded_rectangle([30, 310, w - 30, 560], radius=16, fill="#FFFFFF", outline="#BDBDBD", width=2)
    draw.text((50, 335), "Solicitud de vinculación", fill="#212121", font=FONTS["bold"])
    draw.text((50, 365), "Vincular con JDY-31-SPP.\nIngrese el código PIN (normalmente 1234):", fill="#424242", font=FONTS["small"])
    
    # Caja PIN
    draw.rounded_rectangle([50, 420, w - 50, 465], radius=8, fill="#F5F5F5", outline="#1E88E5", width=2)
    draw.text((65, 435), "1 2 3 4", fill="#212121", font=FONTS["title"])
    
    # Botones Cancelar / Aceptar
    draw.text((w - 190, 515), "CANCELAR", fill="#757575", font=FONTS["bold"])
    draw.text((w - 95, 515), "VINCULAR", fill="#1E88E5", font=FONTS["bold"])
    
    # Barra navegacion
    draw.rectangle([0, h-40, w, h], fill="#ECEFF1")
    draw.text((w//2 - 20, h-30), "◀   ●   ■", fill="#78909C", font=FONTS["small"])
    
    img.save(os.path.join(IMG_DIR, "paso2_emparejamiento_bt.png"))

# ==========================================
# 3. CAPTURA PASO 3: LOGIN DE LA APP
# ==========================================
def gen_paso3_login():
    w, h = 420, 720
    img, draw = create_phone_frame(h, w, bg="#ECEFF1")
    draw_action_bar(draw, "IT VIAL 30", w)
    
    icon_path = os.path.join(IMG_DIR, "logo_icon.png")
    if os.path.exists(icon_path):
        try:
            im_icon = Image.open(icon_path).resize((36, 36), Image.Resampling.LANCZOS)
            img.paste(im_icon, (16, 35))
        except Exception:
            pass

    # Tarjeta Central Login
    draw.rounded_rectangle([24, 100, w - 24, 660], radius=16, fill="#FFFFFF", outline="#CFD8DC")
    
    # Banner IT Vial
    banner_path = os.path.join(IMG_DIR, "logo_banner.png")
    if os.path.exists(banner_path):
        try:
            im_ban = Image.open(banner_path)
            bw = w - 80
            bh = int(im_ban.height * (bw / im_ban.width))
            if bh > 70: bh = 70
            im_ban = im_ban.resize((bw, bh), Image.Resampling.LANCZOS)
            img.paste(im_ban, (40, 120))
        except Exception:
            pass
    
    draw.text((105, 205), "BALIZA IT VIAL 30", fill="#D32F2F", font=FONTS["title"])
    draw.text((85, 235), "Versión v3.3 · Control y Diagnóstico", fill="#546E7A", font=FONTS["small"])
    
    # Campo Usuario
    draw.text((45, 275), "Usuario:", fill="#37474F", font=FONTS["bold"])
    draw.rounded_rectangle([45, 300, w - 45, 345], radius=8, fill="#FAFAFA", outline="#90A4AE")
    draw.text((60, 315), "admin", fill="#212121", font=FONTS["reg"])
    
    # Campo Contraseña
    draw.text((45, 365), "Contraseña:", fill="#37474F", font=FONTS["bold"])
    draw.rounded_rectangle([45, 390, w - 45, 435], radius=8, fill="#FAFAFA", outline="#90A4AE")
    draw.text((60, 405), "•••••", fill="#212121", font=FONTS["reg"])
    
    # Boton ENTRAR AL SISTEMA
    draw.rounded_rectangle([45, 465, w - 45, 530], radius=10, fill="#D32F2F")
    draw.text((w//2 - 80, 480), "ENTRAR AL\n  SISTEMA", fill="#FFFFFF", font=FONTS["btn"])
    
    # Nota al pie
    draw.text((w//2 - 110, 560), "Credenciales de técnico: admin /\n                     admin", fill="#78909C", font=FONTS["small"])
    
    # Barra navegacion
    draw.rectangle([0, h-35, w, h], fill="#B0BEC5")
    draw.text((w//2 - 20, h-25), "◀   ●   ■", fill="#37474F", font=FONTS["small"])
    
    img.save(os.path.join(IMG_DIR, "paso3_login_app.png"))


# ==========================================
# 4. CAPTURA PASO 4: CONEXION Y PANTALLA PRINCIPAL
# ==========================================
def gen_paso4_pantalla_principal():
    w, h = 420, 880
    img, draw = create_phone_frame(h, w, bg="#F5F5F5")
    draw_action_bar(draw, "IT VIAL 30", w)
    
    icon_path = os.path.join(IMG_DIR, "logo_icon.png")
    if os.path.exists(icon_path):
        try:
            im_icon = Image.open(icon_path).resize((36, 36), Image.Resampling.LANCZOS)
            img.paste(im_icon, (16, 35))
        except Exception:
            pass

    # 1. Consola de datos inicial
    draw.rounded_rectangle([16, 95, w - 16, 285], radius=10, fill="#1E1E1E")
    draw.text((28, 105), "Consola de Datos IT VIAL 30 v3.3", fill="#AAAAAA", font=FONTS["small_bold"])
    draw.text((28, 130), "Seleccione un dispositivo\nBluetooth y presione LEER...", fill="#00FF66", font=FONTS["mono"])

    # 2. Fila de Botones principales (Dispositivo, Leer, Config)
    # Boton Dispositivo (Rojo)
    draw.rounded_rectangle([16, 300, 130, 355], radius=6, fill="#D32F2F")
    draw.text((32, 310), "DISPOSI-\n  TIVO", fill="#FFFFFF", font=FONTS["small_bold"])
    
    # Boton Leer (Azul)
    draw.rounded_rectangle([140, 300, 260, 355], radius=6, fill="#1976D2")
    draw.text((180, 320), "LEER", fill="#FFFFFF", font=FONTS["bold"])
    
    # Boton Config (Verde)
    draw.rounded_rectangle([270, 300, w - 16, 355], radius=6, fill="#388E3C")
    draw.text((310, 320), "CONFIG", fill="#FFFFFF", font=FONTS["bold"])

    # 3. Tarjeta Horario Escolar Oficial (1 Toque)
    draw.rounded_rectangle([16, 375, w - 16, 595], radius=12, fill="#FFF9C4", outline="#FFE082", width=2)
    draw.text((28, 390), "🏫 Horario Escolar\nOficial (Placa)", fill="#D84315", font=FONTS["bold"])
    draw.rounded_rectangle([w - 95, 390, w - 28, 415], radius=4, fill="#FFE082")
    draw.text((w - 85, 395), "Lun a Vie", fill="#BF360C", font=FONTS["small_bold"])
    
    draw.text((28, 440), "• Alarma 1: 06:00 am — 09:00 am\n• Alarma 2: 11:30 am — 01:30 pm (13:30)\n• Alarma 3: 03:00 pm (15:00) — 04:30 pm\n  (16:30)", fill="#4E342E", font=FONTS["small"])
    
    draw.rounded_rectangle([28, 525, w - 28, 575], radius=8, fill="#E65100")
    draw.text((45, 535), "🏫 PROGRAMAR HORARIO\n    ESCOLAR (1 TOQUE)", fill="#FFFFFF", font=FONTS["small_bold"])

    # 4. Tarjeta Configuración de Franja
    draw.rounded_rectangle([16, 615, w - 16, 815], radius=8, fill="#FFFFFF", outline="#E0E0E0")
    draw.text((28, 628), "Configuración de Franja Horaria", fill="#212121", font=FONTS["bold"])
    
    # Selector Alarma y Switch
    draw.text((28, 660), "Alarma N°:", fill="#424242", font=FONTS["small"])
    draw.rounded_rectangle([100, 652, 160, 680], radius=4, fill="#ECEFF1")
    draw.text((125, 658), "1 ▾", fill="#212121", font=FONTS["small_bold"])
    
    draw.text((w - 140, 660), "Habilitar:", fill="#424242", font=FONTS["small"])
    draw.rounded_rectangle([w - 75, 655, w - 35, 678], radius=10, fill="#4CAF50")
    draw.ellipse([w - 53, 657, w - 37, 676], fill="#FFFFFF")

    # Hora Inicio y Fin
    draw.text((28, 695), "Hora Inicio:", fill="#424242", font=FONTS["small"])
    draw.rounded_rectangle([110, 688, 170, 715], radius=4, fill="#ECEFF1")
    draw.text((130, 695), "06 ▾", fill="#212121", font=FONTS["small"])
    draw.text((178, 695), ":", fill="#212121", font=FONTS["bold"])
    draw.rounded_rectangle([190, 688, 250, 715], radius=4, fill="#ECEFF1")
    draw.text((210, 695), "00 ▾", fill="#212121", font=FONTS["small"])

    draw.text((28, 730), "Hora Fin:", fill="#424242", font=FONTS["small"])
    draw.rounded_rectangle([110, 723, 170, 750], radius=4, fill="#ECEFF1")
    draw.text((130, 730), "09 ▾", fill="#212121", font=FONTS["small"])
    draw.text((178, 730), ":", fill="#212121", font=FONTS["bold"])
    draw.rounded_rectangle([190, 723, 250, 750], radius=4, fill="#ECEFF1")
    draw.text((210, 730), "00 ▾", fill="#212121", font=FONTS["small"])

    draw.text((28, 765), "Días:", fill="#424242", font=FONTS["small"])
    draw.rounded_rectangle([110, 758, w - 35, 785], radius=4, fill="#ECEFF1")
    draw.text((130, 765), "Lun-Vie ▾", fill="#212121", font=FONTS["small_bold"])

    # Barra navegacion
    draw.rectangle([0, h-35, w, h], fill="#B0BEC5")
    draw.text((w//2 - 20, h-25), "◀   ●   ■", fill="#37474F", font=FONTS["small"])

    img.save(os.path.join(IMG_DIR, "paso4_pantalla_principal.png"))


    # 3. Tarjeta Horario Escolar Oficial (1 Toque)
    draw.rounded_rectangle([16, 350, w - 16, 490], radius=10, fill="#FFF9C4", outline="#FFE082", width=2)
    draw.text((28, 362), "🏫 Horario Escolar Oficial (Placa)", fill="#D84315", font=FONTS["bold"])
    draw.rounded_rectangle([w - 95, 360, w - 28, 382], radius=4, fill="#FFE082")
    draw.text((w - 85, 365), "Lun a Vie", fill="#BF360C", font=FONTS["small_bold"])
    
    draw.text((28, 390), "• Alarma 1: 06:00 am — 09:00 am\n• Alarma 2: 11:30 am — 01:30 pm (13:30)\n• Alarma 3: 03:00 pm (15:00) — 04:30 pm (16:30)", fill="#4E342E", font=FONTS["small"])
    
    draw.rounded_rectangle([28, 445, w - 28, 480], radius=6, fill="#E65100")
    draw.text((55, 455), "🏫 Programar Horario Escolar (1 Toque)", fill="#FFFFFF", font=FONTS["btn"])

    # 4. Tarjeta Configuración de Franja
    draw.rounded_rectangle([16, 505, w - 16, 685], radius=8, fill="#FFFFFF", outline="#E0E0E0")
    draw.text((28, 518), "Configuración de Franja Horaria", fill="#212121", font=FONTS["bold"])
    
    # Selector Alarma y Switch
    draw.text((28, 550), "Alarma N°:", fill="#424242", font=FONTS["small"])
    draw.rounded_rectangle([100, 542, 160, 570], radius=4, fill="#ECEFF1")
    draw.text((125, 548), "1 ▾", fill="#212121", font=FONTS["small_bold"])
    
    draw.text((w - 140, 550), "Habilitar:", fill="#424242", font=FONTS["small"])
    draw.rounded_rectangle([w - 75, 545, w - 35, 568], radius=10, fill="#4CAF50")
    draw.ellipse([w - 53, 547, w - 37, 566], fill="#FFFFFF")

    # Hora Inicio
    draw.text((28, 585), "Hora Inicio:", fill="#424242", font=FONTS["small"])
    draw.rounded_rectangle([110, 578, 170, 605], radius=4, fill="#ECEFF1")
    draw.text((130, 585), "06 ▾", fill="#212121", font=FONTS["small"])
    draw.text((178, 585), ":", fill="#212121", font=FONTS["bold"])
    draw.rounded_rectangle([190, 578, 250, 605], radius=4, fill="#ECEFF1")
    draw.text((210, 585), "00 ▾", fill="#212121", font=FONTS["small"])

    # Hora Fin
    draw.text((28, 620), "Hora Fin:", fill="#424242", font=FONTS["small"])
    draw.rounded_rectangle([110, 613, 170, 640], radius=4, fill="#ECEFF1")
    draw.text((130, 620), "09 ▾", fill="#212121", font=FONTS["small"])
    draw.text((178, 620), ":", fill="#212121", font=FONTS["bold"])
    draw.rounded_rectangle([190, 613, 250, 640], radius=4, fill="#ECEFF1")
    draw.text((210, 620), "00 ▾", fill="#212121", font=FONTS["small"])

    # Horario / Días
    draw.text((28, 655), "Días:", fill="#424242", font=FONTS["small"])
    draw.rounded_rectangle([110, 648, w - 35, 675], radius=4, fill="#ECEFF1")
    draw.text((130, 655), "Lun-Vie ▾", fill="#212121", font=FONTS["small_bold"])

    # 5. Tarjeta Diagnóstico y Test
    draw.rounded_rectangle([16, 700, w - 16, 830], radius=8, fill="#FFFFFF", outline="#E0E0E0")
    draw.text((28, 712), "⚡ Diagnóstico de Banco / Terreno", fill="#212121", font=FONTS["bold"])
    draw.text((28, 735), "Verifica destello normativo de 1.0 Hz (500ms ON / 500ms OFF):", fill="#616161", font=FONTS["small"])
    
    draw.rounded_rectangle([28, 755, w - 28, 788], radius=6, fill="#FF8F00")
    draw.text((80, 765), "💡 Activar Test Luz (2 Minutos)", fill="#FFFFFF", font=FONTS["small_bold"])

    draw.rounded_rectangle([28, 794, w - 28, 824], radius=6, fill="#607D8B")
    draw.text((150, 803), "⛔ Apagar Test", fill="#FFFFFF", font=FONTS["small_bold"])

    # Barra navegacion
    draw.rectangle([0, h-40, w, h], fill="#212121")
    draw.text((w//2 - 20, h-30), "◀   ●   ■", fill="#9E9E9E", font=FONTS["small"])

    img.save(os.path.join(IMG_DIR, "paso4_pantalla_principal.png"))

# ==========================================
# 5. DETALLE: SELECCIÓN DE DISPOSITIVO BT
# ==========================================
def gen_paso4_dialog_dispositivo():
    w, h = 420, 520
    img, draw = create_phone_frame(h, w, bg="#37474F")
    
    # Modal Lista BT
    draw.rounded_rectangle([30, 80, w - 30, 440], radius=16, fill="#FFFFFF")
    draw.text((50, 105), "Seleccione el Módulo Bluetooth:", fill="#212121", font=FONTS["title"])
    
    # Item 1: JDY-31
    draw.rounded_rectangle([45, 155, w - 45, 230], radius=8, fill="#E8F5E9", outline="#4CAF50", width=2)
    draw.ellipse([60, 180, 80, 200], fill="#4CAF50")
    draw.text((95, 170), "JDY-31-SPP", fill="#2E7D32", font=FONTS["bold"])
    draw.text((95, 195), "(20:22:08:21:49:15)", fill="#616161", font=FONTS["small"])
    
    # Item 2: HC-06
    draw.rounded_rectangle([45, 245, w - 45, 320], radius=8, fill="#FAFAFA", outline="#E0E0E0")
    draw.ellipse([60, 270, 80, 290], outline="#9E9E9E", width=2)
    draw.text((95, 260), "HC-06 / IT VIAL", fill="#424242", font=FONTS["bold"])
    draw.text((95, 285), "(98:D3:31:F8:24:10)", fill="#757575", font=FONTS["small"])
    
    # Indicación
    draw.text((50, 350), "💡 Al tocar el dispositivo se conecta automáticamente.", fill="#1565C0", font=FONTS["small"])
    
    # Boton cancelar
    draw.text((w - 130, 395), "CANCELAR", fill="#757575", font=FONTS["bold"])

    img.save(os.path.join(IMG_DIR, "paso4_dialog_dispositivos.png"))

# ==========================================
# 6. DETALLE: PROGRAMACIÓN 1-TOQUE
# ==========================================
def gen_detalle_horario_escolar():
    """Tarjeta HORARIO DE ESTA PLACA.

    Sustituye a la del 1-Toque, que grababa tres franjas fijas de un colegio
    concreto. El horario va impreso en la placa de cada senal y puede llevar
    hasta CUATRO franjas, asi que la figura tiene que ensenar las cuatro.
    """
    w, h = 420, 430
    img = Image.new("RGB", (w, h), "#FFFFFF")
    draw = ImageDraw.Draw(img)

    draw.rounded_rectangle([10, 10, w - 10, h - 10], radius=12,
                           fill="#FFFFFF", outline="#CBD5E1", width=2)
    draw.text((25, 24), "HORARIO DE ESTA PLACA", fill="#0F172A", font=FONTS["bold"])
    draw.text((25, 48), "Copie lo que dice la placa atornillada a ESTA senal.",
              fill="#B45309", font=FONTS["small"])
    draw.text((25, 66), "Cada colegio tiene el suyo: hasta 4 franjas.",
              fill="#B45309", font=FONTS["small"])

    franjas = [("1", "06:00", "09:00", True),
               ("2", "11:30", "13:30", True),
               ("3", "15:00", "16:30", True),
               ("4", "00:00", "00:00", False)]
    y = 95
    for num, ini, fin, activa in franjas:
        # interruptor
        col = "#15803D" if activa else "#94A3B8"
        draw.rounded_rectangle([25, y + 6, 61, y + 26], radius=10, fill=col)
        cx = 51 if activa else 35
        draw.ellipse([cx - 8, y + 8, cx + 8, y + 24], fill="#FFFFFF")
        draw.text((68, y + 8), num, fill="#0F172A", font=FONTS["bold"])

        for x0, txt in ((92, ini), (250, fin)):
            draw.rounded_rectangle([x0, y, x0 + 130, y + 32], radius=6,
                                   fill="#E2E8F0", outline="#CBD5E1")
            draw.text((x0 + 38, y + 7), txt, fill="#0F172A", font=FONTS["bold"])
        draw.text((228, y + 8), "a", fill="#475569", font=FONTS["small"])
        y += 42

    draw.text((25, y + 4), "Dias:", fill="#0F172A", font=FONTS["small_bold"])
    draw.rounded_rectangle([80, y, w - 25, y + 30], radius=6,
                           fill="#FFFFFF", outline="#CBD5E1")
    draw.text((92, y + 7), "Lunes a viernes", fill="#0F172A", font=FONTS["small"])

    y += 44
    draw.rounded_rectangle([25, y, w - 25, y + 46], radius=8, fill="#15803D")
    draw.text((48, y + 15), "GRABAR ESTE HORARIO EN LA BALIZA",
              fill="#FFFFFF", font=FONTS["btn"])

    img.save(os.path.join(IMG_DIR, "paso6_detalle_horario_escolar.png"))


def gen_detalle_receso_escolar():
    """Botones de receso. En vacaciones no hay escolares y el limite no rige:
    una senal destellando semanas sin alumnos acostumbra al conductor."""
    w, h = 420, 210
    img = Image.new("RGB", (w, h), "#FFFFFF")
    draw = ImageDraw.Draw(img)

    draw.rounded_rectangle([10, 10, w - 10, h - 10], radius=12,
                           fill="#FFFFFF", outline="#CBD5E1", width=2)
    draw.text((25, 24), "RECESO ESCOLAR", fill="#0F172A", font=FONTS["bold"])
    draw.text((25, 50), "En vacaciones no hay escolares y la restriccion",
              fill="#475569", font=FONTS["small"])
    draw.text((25, 68), "no rige. Apague la senal y reanude al volver.",
              fill="#475569", font=FONTS["small"])

    draw.rounded_rectangle([25, 100, 205, 150], radius=8, fill="#B45309")
    draw.text((52, 118), "APAGAR (RECESO)", fill="#FFFFFF", font=FONTS["btn"])

    draw.rounded_rectangle([215, 100, w - 25, 150], radius=8, fill="#1D4ED8")
    draw.text((238, 118), "REANUDAR CLASES", fill="#FFFFFF", font=FONTS["btn"])

    draw.text((25, 165), "Los dos piden confirmacion antes de actuar.",
              fill="#B45309", font=FONTS["small"])

    img.save(os.path.join(IMG_DIR, "paso6_detalle_receso_escolar.png"))


# ==========================================
# 6.2 DETALLE: CONFIGURACIÓN MANUAL Y DROPDOWNS
# ==========================================
def gen_paso7_config_dropdowns():
    w, h = 420, 520
    img = Image.new("RGB", (w, h), "#FFFFFF")
    draw = ImageDraw.Draw(img)
    
    # Tarjeta Configuración Manual
    draw.rounded_rectangle([10, 10, w - 10, h - 10], radius=12, fill="#FFFFFF", outline="#CBD5E1", width=2)
    draw.text((25, 24), "6. PROGRAMACIÓN MANUAL DE FRANJA", fill="#0F172A", font=FONTS["bold"])
    draw.text((25, 48), "Ajuste puntual de una sola alarma sin tocar las demas.", fill="#475569", font=FONTS["small"])
    
    # Alarma No y Switch ON-OFF
    draw.text((25, 85), "Alarma:", fill="#475569", font=FONTS["small_bold"])
    draw.rounded_rectangle([90, 75, 160, 110], radius=6, fill="#F1F5F9", outline="#CBD5E1")
    draw.text((115, 85), "3  ▾", fill="#0F172A", font=FONTS["bold"])
    
    draw.text((200, 85), "ON/OFF:", fill="#475569", font=FONTS["small_bold"])
    draw.rounded_rectangle([270, 80, 320, 105], radius=12, fill="#15803D")
    draw.ellipse([295, 82, 316, 103], fill="#FFFFFF")

    # Hora Inicio
    draw.text((25, 135), "Inicio:", fill="#475569", font=FONTS["small_bold"])
    draw.rounded_rectangle([90, 125, 160, 160], radius=6, fill="#F1F5F9", outline="#CBD5E1")
    draw.text((110, 135), "14 ▾", fill="#0F172A", font=FONTS["bold"])
    draw.text((170, 135), ":", fill="#0F172A", font=FONTS["bold"])
    draw.rounded_rectangle([185, 125, 255, 160], radius=6, fill="#F1F5F9", outline="#CBD5E1")
    draw.text((205, 135), "30 ▾", fill="#0F172A", font=FONTS["bold"])

    # Hora Fin
    draw.text((25, 185), "Fin:", fill="#475569", font=FONTS["small_bold"])
    draw.rounded_rectangle([90, 175, 160, 210], radius=6, fill="#F1F5F9", outline="#CBD5E1")
    draw.text((110, 185), "16 ▾", fill="#0F172A", font=FONTS["bold"])
    draw.text((170, 185), ":", fill="#0F172A", font=FONTS["bold"])
    draw.rounded_rectangle([185, 175, 255, 210], radius=6, fill="#F1F5F9", outline="#CBD5E1")
    draw.text((205, 185), "30 ▾", fill="#0F172A", font=FONTS["bold"])

    # Horario / Días
    draw.text((25, 235), "Dias:", fill="#475569", font=FONTS["small_bold"])
    draw.rounded_rectangle([90, 225, w - 25, 260], radius=6, fill="#F1F5F9", outline="#CBD5E1")
    draw.text((105, 235), "Lunes a viernes ▾", fill="#0F172A", font=FONTS["bold"])

    # Boton Verde Directo ENVIAR Y GRABAR
    draw.rounded_rectangle([25, 290, w - 25, 345], radius=8, fill="#059669")
    draw.text((45, 308), "⚡ ENVIAR Y GRABAR ESTA FRANJA", fill="#FFFFFF", font=FONTS["btn"])

    draw.text((25, 370), "💡 Al presionar el boton, la trama viaja al instante por BT", fill="#0369A1", font=FONTS["small_bold"])
    draw.text((25, 390), "y se guarda en la memoria EEPROM física del microcontrolador.", fill="#0369A1", font=FONTS["small"])

    img.save(os.path.join(IMG_DIR, "paso7_config_franja_detalle.png"))


def gen_comparativa_grabar_vs_manual():
    w, h = 600, 360
    img = Image.new("RGB", (w, h), "#F8FAFC")
    draw = ImageDraw.Draw(img)

    # Titulo principal
    draw.text((20, 15), "¿QUÉ MÉTODO USAR EN CAMPO?", fill="#0F172A", font=FONTS["title"])
    draw.text((20, 42), "Comparativa de flujos de configuración del horario escolar", fill="#64748B", font=FONTS["small"])

    # Columna 1: Grabar Horario de Placa (Recomendado 95%)
    draw.rounded_rectangle([20, 75, 290, 340], radius=10, fill="#FFFFFF", outline="#15803D", width=2)
    draw.rounded_rectangle([20, 75, 290, 110], radius=8, fill="#15803D")
    draw.text((30, 85), "⚡ GRABAR HORARIO PLACA", fill="#FFFFFF", font=FONTS["bold"])
    
    draw.text((30, 120), "• Alcance: Integral (4 Franjas a la vez)", fill="#0F172A", font=FONTS["small_bold"])
    draw.text((30, 145), "• Reloj: Sincroniza RTC con el celular", fill="#15803D", font=FONTS["small"])
    draw.text((30, 170), "• Tramas: 5 tramas con pausa de 450ms", fill="#475569", font=FONTS["small"])
    draw.text((30, 195), "• Confirmacion: Dialogo previo de aviso", fill="#475569", font=FONTS["small"])
    draw.text((30, 220), "• Seguridad: Apaga franjas no usadas", fill="#475569", font=FONTS["small"])
    draw.rounded_rectangle([30, 260, 280, 320], radius=6, fill="#DCFCE7")
    draw.text((40, 275), "⭐ USO HABITUAL (95% VISITAS)", fill="#166534", font=FONTS["small_bold"])
    draw.text((40, 295), "Instalacion y calibracion escolar", fill="#166534", font=FONTS["small"])

    # Columna 2: Programacion Manual
    draw.rounded_rectangle([310, 75, 580, 340], radius=10, fill="#FFFFFF", outline="#0284C7", width=2)
    draw.rounded_rectangle([310, 75, 580, 110], radius=8, fill="#0284C7")
    draw.text((320, 85), "⚙️ CONFIGURACIÓN MANUAL", fill="#FFFFFF", font=FONTS["bold"])

    draw.text((320, 120), "• Alcance: Quirurgico (1 sola alarma)", fill="#0F172A", font=FONTS["small_bold"])
    draw.text((320, 145), "• Reloj: NO altera la hora del RTC", fill="#B45309", font=FONTS["small"])
    draw.text((320, 170), "• Tramas: 1 sola trama directa", fill="#475569", font=FONTS["small"])
    draw.text((320, 195), "• Boton: Directo en la tarjeta", fill="#475569", font=FONTS["small"])
    draw.text((320, 220), "• Memoria: Las demas alarmas siguen", fill="#475569", font=FONTS["small"])
    draw.rounded_rectangle([320, 260, 570, 320], radius=6, fill="#E0F2FE")
    draw.text((330, 275), "🔧 USO TECNICO (5% VISITAS)", fill="#075985", font=FONTS["small_bold"])
    draw.text((330, 295), "Ajuste puntual o pruebas de banco", fill="#075985", font=FONTS["small"])

    img.save(os.path.join(IMG_DIR, "comparativa_grabar_vs_manual.png"))

# ==========================================
# 6.2 DROPDOWNS: ALARMA, HORAS, MINUTOS Y HORARIO
# ==========================================
def gen_paso7_dropdowns_combinados():
    w, h = 420, 680
    img, draw = create_phone_frame(h, w, bg="#F5F5F5")
    draw_action_bar(draw, "IT VIAL 30", w)
    
    # Tarjeta base
    draw.rounded_rectangle([16, 95, w - 16, 430], radius=12, fill="#FFFFFF", outline="#CFD8DC")
    draw.text((28, 110), "Configuración de Franja Horaria", fill="#212121", font=FONTS["bold"])
    draw.text((28, 160), "Alarma No:   1 ▾    ON-OFF", fill="#37474F", font=FONTS["reg"])
    draw.text((28, 205), "Alarma Inicio:    :    ▾", fill="#37474F", font=FONTS["reg"])
    draw.text((28, 250), "Alarma Fin:       :    ▾", fill="#37474F", font=FONTS["reg"])
    draw.text((28, 295), "Horario:       Diario ▾", fill="#37474F", font=FONTS["reg"])

    # Dropdown 1: Alarma No (1..5)
    draw.rounded_rectangle([25, 340, 95, 520], radius=8, fill="#FFFFFF", outline="#BDBDBD", width=2)
    draw.text((32, 345), "Alarma:\n 1\n 2\n 3\n 4\n 5", fill="#212121", font=FONTS["mono"])

    # Dropdown 2: Horas (00..23)
    draw.rounded_rectangle([105, 340, 200, 620], radius=8, fill="#FFFFFF", outline="#BDBDBD", width=2)
    horas_txt = "Horas:\n 00  12\n 01  13\n 02  14\n 03  15\n 04  16\n 05  17\n 06  18\n 07  19\n 08  20\n 09  21\n 10  22\n 11  23"
    draw.text((115, 345), horas_txt, fill="#212121", font=FONTS["small"])

    # Dropdown 3: Minutos (paso 5)
    draw.rounded_rectangle([210, 340, 305, 620], radius=8, fill="#FFFFFF", outline="#BDBDBD", width=2)
    min_txt = "Minutos:\n 00   30\n 05   35\n 10   40\n 15   45\n 20   50\n 25   55"
    draw.text((220, 345), min_txt, fill="#212121", font=FONTS["small"])

    # Dropdown 4: Horario (Días)
    draw.rounded_rectangle([315, 340, 405, 480], radius=8, fill="#FFFFFF", outline="#BDBDBD", width=2)
    draw.text((322, 345), "Días:\nDiario\nLun-Vie\nSab-Dom", fill="#212121", font=FONTS["small_bold"])

    img.save(os.path.join(IMG_DIR, "paso7_dropdowns_combinados.png"))



# ==========================================
# 7. DETALLE: TEST DE LUZ (2 MIN)
# ==========================================
def gen_detalle_diagnostico_luz():
    w, h = 420, 210
    img = Image.new("RGB", (w, h), "#FFFFFF")
    draw = ImageDraw.Draw(img)
    
    draw.rounded_rectangle([10, 10, w - 10, h - 10], radius=12, fill="#FAFAFA", outline="#CFD8DC", width=2)
    draw.text((25, 20), "⚡ Diagnóstico de Banco / Terreno", fill="#212121", font=FONTS["bold"])
    draw.text((25, 45), "Activa inmediatamente la luz por 2 minutos para validar el foco:", fill="#616161", font=FONTS["small"])
    
    draw.rounded_rectangle([25, 75, w - 25, 125], radius=8, fill="#FF8F00")
    draw.text((70, 90), "💡 Activar Test Luz (2 Minutos)", fill="#FFFFFF", font=FONTS["btn"])
    
    draw.rounded_rectangle([25, 140, w - 25, 185], radius=8, fill="#607D8B")
    draw.text((140, 152), "⛔ Apagar Test", fill="#FFFFFF", font=FONTS["btn"])
    
    img.save(os.path.join(IMG_DIR, "paso8_detalle_diagnostico_luz.png"))


# ==========================================
# 8. DETALLE: CRÉDITOS Y CONTACTO IT VIAL
# ==========================================
def gen_creditos_it_vial():
    w, h = 480, 320
    img = Image.new("RGB", (w, h), "#1A1A1A")
    draw = ImageDraw.Draw(img)
    
    # Líneas curvas estilizadas viales
    draw.arc([-50, -50, w + 50, h + 100], start=180, end=0, fill="#757575", width=12)
    draw.arc([-30, -30, w + 30, h + 80], start=180, end=0, fill="#FBC02D", width=6)

    # Logo Central IT Vial
    icon_path = os.path.join(IMG_DIR, "logo_icon.png")
    if os.path.exists(icon_path):
        try:
            im_icon = Image.open(icon_path).resize((90, 90), Image.Resampling.LANCZOS)
            img.paste(im_icon, (w // 2 - 45, 30))
        except Exception:
            draw.rounded_rectangle([w//2 - 45, 30, w//2 + 45, 120], radius=16, fill="#FFA000")
            draw.text((w//2 - 12, 50), "t", fill="#212121", font=FONTS["title"])
    else:
        draw.rounded_rectangle([w//2 - 45, 30, w//2 + 45, 120], radius=16, fill="#FFA000")
        draw.text((w//2 - 12, 50), "t", fill="#212121", font=FONTS["title"])

    # Textos de contacto y créditos
    draw.text((w // 2 - 80, 135), "IT VIAL S.A.S", fill="#FFFFFF", font=FONTS["title"])
    draw.text((w // 2 - 85, 175), "WWW.ITVIAL.COM", fill="#E0E0E0", font=FONTS["bold"])
    
    draw.text((w // 2 - 100, 215), "Designed and powered by", fill="#B0BEC5", font=FONTS["small"])
    draw.text((w // 2 - 170, 235), "INFRAESTRUCTURA Y TECNOLOGÍA VIAL S.A.S", fill="#FFFFFF", font=FONTS["small_bold"])
    draw.text((w // 2 - 80, 265), "Celular: 3188200400", fill="#FBC02D", font=FONTS["bold"])

    img.save(os.path.join(IMG_DIR, "portada_it_vial_creditos.png"))





def _tarjeta_mantenimiento(altura):
    """Dibuja la tarjeta propuesta. altura=False -> inspeccion desde el suelo.

    La idea que gobierna el diseno: los puntos que NO se pueden verificar en esa
    modalidad no se muestran en gris, NO SE MUESTRAN. Si no estan en pantalla no
    se pueden marcar por descuido, y un checklist que permite afirmar lo que no
    se ha comprobado es peor que no tener checklist.
    """
    # El ESTADO FISICO va primero: es lo que mira un auditor antes que nada, y
    # casi todo el se ve desde abajo -- una senal existe para leerse desde la via.
    suelo_items = [
        "Lamina reflectiva limpia, sin grafiti ni golpes",
        "Placa del horario legible y bien sujeta",
        "Senal sin obstruccion (ramas, vegetacion, avisos)",
        "Poste vertical y sin dano visible en la base",
        "Hora del equipo coincide con la del telefono",
        "Horario grabado coincide con la placa",
        "Tension de bateria en rango        12.6 V",
        "Sin cortes de energia nuevos       2 cortes",
        "Destello verificado (prueba 2 min)",
    ]
    altura_items = [
        "Herrajes y abrazaderas apretados al poste",
        "Gabinete cerrado y hermetico, sin agua",
        "Lente del foco limpia por dentro",
        "Panel solar limpio, orientado y sin sombra",
        "Fusible de 12 V verificado",
        "Borneras apretadas, sin sulfatacion ni juego",
        "Pila CR2032 verificada o sustituida",
    ]
    items = suelo_items + (altura_items if altura else [])

    w = 460
    h = 258 + len(items) * 30 + (70 if not altura else 40)
    img = Image.new("RGB", (w, h), "#FFFFFF")
    draw = ImageDraw.Draw(img)
    draw.rounded_rectangle([10, 10, w - 10, h - 10], radius=12,
                           fill="#FFFFFF", outline="#CBD5E1", width=2)

    draw.text((25, 24), "MANTENIMIENTO E INSPECCION", fill="#0F172A", font=FONTS["bold"])

    # El tecnico se escribe una vez por jornada y queda guardado en el telefono.
    draw.text((25, 52), "Tecnico / cuadrilla", fill="#475569", font=FONTS["small_bold"])
    draw.rounded_rectangle([25, 70, w - 25, 104], radius=6,
                           fill="#FFFFFF", outline="#CBD5E1")
    draw.text((38, 79), "Cuadrilla 01 - D. Zuniga", fill="#0F172A", font=FONTS["small"])

    draw.text((25, 118), "TIPO DE INSPECCION", fill="#475569", font=FONTS["small_bold"])

    # Control de dos posiciones
    y0, y1 = 138, 184
    mitad = w // 2
    sel_bg, off_bg = "#1D4ED8", "#F1F5F9"
    draw.rounded_rectangle([25, y0, mitad, y1], radius=8,
                           fill=(off_bg if altura else sel_bg))
    draw.rounded_rectangle([mitad, y0, w - 25, y1], radius=8,
                           fill=(sel_bg if altura else off_bg))
    draw.text((52, y0 + 8), "A NIVEL DE SUELO",
              fill=("#475569" if altura else "#FFFFFF"), font=FONTS["small_bold"])
    draw.text((60, y0 + 26), "(sin subir)",
              fill=("#94A3B8" if altura else "#DBEAFE"), font=FONTS["small"])
    draw.text((mitad + 30, y0 + 8), "EN ALTURA (poste)",
              fill=("#FFFFFF" if altura else "#475569"), font=FONTS["small_bold"])
    draw.text((mitad + 34, y0 + 26), "escalera o canasta",
              fill=("#DBEAFE" if altura else "#94A3B8"), font=FONTS["small"])

    # Checklist
    y = 206
    for n, txt in enumerate(items, 1):
        marcado = n <= (8 if not altura else 12)
        draw.rounded_rectangle([28, y, 48, y + 20], radius=4,
                               fill=("#15803D" if marcado else "#FFFFFF"),
                               outline="#94A3B8", width=1)
        if marcado:
            draw.line([32, y + 10, 37, y + 15], fill="#FFFFFF", width=3)
            draw.line([37, y + 15, 44, y + 5], fill="#FFFFFF", width=3)
        draw.text((60, y + 2), "%d. %s" % (n, txt), fill="#0F172A", font=FONTS["small"])
        y += 30

    y += 8
    if not altura:
        draw.rounded_rectangle([25, y, w - 25, y + 52], radius=8,
                               fill="#FEF3C7", outline="#F59E0B")
        draw.text((40, y + 8), "Inspeccion a nivel de suelo.", fill="#92400E",
                  font=FONTS["small_bold"])
        draw.text((40, y + 28), "7 puntos requieren subir al poste y NO se han verificado.",
                  fill="#92400E", font=FONTS["small"])
        y += 62
    draw.rounded_rectangle([25, y, w - 25, y + 44], radius=8, fill="#7C3AED")
    draw.text((70, y + 13), "COMPARTIR ACTA DE INSPECCION",
              fill="#FFFFFF", font=FONTS["btn"])
    return img


def gen_propuesta_mantenimiento():
    suelo = _tarjeta_mantenimiento(False)
    altura = _tarjeta_mantenimiento(True)
    # Mismo dibujo con dos nombres a proposito: la propuesta y el manual ensenan
    # la misma tarjeta, y desde el 22-ago-2026 ya no es propuesta -- esta hecha.
    suelo.save(os.path.join(IMG_DIR, "propuesta_mant_suelo.png"))
    altura.save(os.path.join(IMG_DIR, "propuesta_mant_altura.png"))
    suelo.save(os.path.join(IMG_DIR, "paso9_mantenimiento_suelo.png"))
    altura.save(os.path.join(IMG_DIR, "paso9_mantenimiento_altura.png"))


def main():
    print("Generando capturas de pantalla para el Manual de Usuario...")
    gen_paso1_instalacion()
    gen_paso1_confirmacion()
    gen_paso1_progreso()
    gen_paso1_play_protect()
    gen_paso1_instalado_final()
    gen_paso2_permisos_runtime()
    gen_paso2_habilitar_bt()
    gen_paso2_bluetooth()
    gen_paso3_login()
    gen_paso4_pantalla_principal()
    gen_paso4_dialog_dispositivo()
    gen_detalle_horario_escolar()
    gen_detalle_receso_escolar()
    gen_propuesta_mantenimiento()
    gen_paso7_config_dropdowns()
    gen_comparativa_grabar_vs_manual()
    gen_paso7_dropdowns_combinados()
    gen_detalle_diagnostico_luz()
    gen_creditos_it_vial()
    print("Capturas generadas exitosamente en Manuales/img/.")


if __name__ == "__main__":
    main()

