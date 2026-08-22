#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
generar_ilustraciones_viales.py
Genera ilustraciones de alta resolución y calidad vectorial de la Señal Vial '30 CUANDO ACTIVADA'
y de la Placa Metálica de Horarios Escolares para el Manual de Usuario.
"""

import os
from PIL import Image, ImageDraw, ImageFont

AQUI = os.path.dirname(os.path.abspath(__file__))
IMG_DIR = os.path.join(AQUI, "img")
os.makedirs(IMG_DIR, exist_ok=True)

def get_fonts():
    try:
        font_huge = ImageFont.truetype("arialbd.ttf", 64)
        font_big = ImageFont.truetype("arialbd.ttf", 36)
        font_title = ImageFont.truetype("arialbd.ttf", 26)
        font_bold = ImageFont.truetype("arialbd.ttf", 22)
        font_reg = ImageFont.truetype("arial.ttf", 20)
        font_small = ImageFont.truetype("arial.ttf", 16)
        font_small_bold = ImageFont.truetype("arialbd.ttf", 16)
    except Exception:
        font_huge = ImageFont.load_default()
        font_big = ImageFont.load_default()
        font_title = ImageFont.load_default()
        font_bold = ImageFont.load_default()
        font_reg = ImageFont.load_default()
        font_small = ImageFont.load_default()
        font_small_bold = ImageFont.load_default()
    return {
        "huge": font_huge, "big": font_big, "title": font_title,
        "bold": font_bold, "reg": font_reg, "small": font_small, "small_bold": font_small_bold
    }

FONTS = get_fonts()

# ==============================================================================
# 1. ILUSTRACIÓN DE ALTA CALIDAD: SEÑAL VIAL «30 CUANDO ACTIVADA» (INTEGRADA)
# ==============================================================================
def gen_senal_vial_hd():
    w, h = 600, 920
    img = Image.new("RGB", (w, h), "#ECEFF1")
    draw = ImageDraw.Draw(img)

    # Fondo degradado de estudio fotográfico suave
    for y in range(h):
        r = int(238 + (245 - 238) * (y / h))
        g = int(242 + (248 - 242) * (y / h))
        b = int(246 + (252 - 246) * (y / h))
        draw.line([(0, y), (w, y)], fill=(r, g, b))

    # Dimensiones de la lámina retroreflectiva única
    placa_left = 60
    placa_right = w - 60
    placa_top = 30
    placa_bottom = h - 40
    cx = w // 2

    # 1. Sombra exterior de la placa
    draw.rounded_rectangle([placa_left + 8, placa_top + 8, placa_right + 8, placa_bottom + 8], radius=32, fill="#B0BEC5")
    
    # 2. Placa de aluminio base con reborde metálico
    draw.rounded_rectangle([placa_left, placa_top, placa_right, placa_bottom], radius=32, fill="#FFFFFF", outline="#37474F", width=5)
    
    # 3. Marco perimetral gris oscuro / azul vial reglamentario
    draw.rounded_rectangle([placa_left + 14, placa_top + 14, placa_right - 14, placa_bottom - 14], radius=24, fill="#FFFFFF", outline="#455A64", width=5)
    
    # 4. Textura microprismática / retroreflectiva sutil de fondo
    # (Líneas finas diagonales para simular lámina tipo grado diamante / alta intensidad)
    for px in range(placa_left + 20, placa_right - 20, 20):
        draw.line([(px, placa_top + 20), (px + 10, placa_bottom - 20)], fill="#F5F7FA", width=1)

    # -------------------------------------------------------------
    # A. FOCO / CLUSTER LED INTEGRADO EN LA PARTE SUPERIOR DE LA LÁMINA
    # -------------------------------------------------------------
    foco_y = placa_top + 130
    foco_radius = 65

    # Halo de destello ámbar normativo (1.0 Hz)
    for rad, halo_col in [(82, "#FFF8E1"), (74, "#FFE082"), (68, "#FFD54F")]:
        draw.ellipse([cx - rad, foco_y - rad, cx + rad, foco_y + rad], fill=halo_col)

    # Marco circular embutido en la lámina
    draw.ellipse([cx - foco_radius, foco_y - foco_radius, cx + foco_radius, foco_y + foco_radius], fill="#263238", outline="#1A1A1A", width=3)
    
    # Lente óptico tipo panal LED
    draw.ellipse([cx - foco_radius + 6, foco_y - foco_radius + 6, cx + foco_radius - 6, foco_y + foco_radius - 6], fill="#FF8F00", outline="#E65100", width=2)
    
    # Matriz de LEDs / Óptica interna
    for dx in range(-36, 40, 12):
        for dy in range(-36, 40, 12):
            if dx*dx + dy*dy <= 38*38:
                draw.ellipse([cx + dx - 3, foco_y + dy - 3, cx + dx + 3, foco_y + dy + 3], fill="#FFC107")

    # Tornillos / remaches de sujeción del foco a la lámina (4 puntos)
    remaches_foco = [(cx - 50, foco_y - 75), (cx + 50, foco_y - 75), (cx - 50, foco_y + 75), (cx + 50, foco_y + 75)]
    for rx, ry in remaches_foco:
        draw.ellipse([rx - 4, ry - 4, rx + 4, ry + 4], fill="#90A4AE", outline="#455A64", width=1)
        draw.line([rx - 2, ry, rx + 2, ry], fill="#37474F", width=1)

    # -------------------------------------------------------------
    # B. CÍRCULO REGLAMENTARIO ROJO Y VELOCIDAD "30" EN EL CENTRO
    # -------------------------------------------------------------
    circ_y = placa_top + 450
    circ_r_ext = 185
    circ_r_int = 145

    # Anillo rojo reglamentario
    draw.ellipse([cx - circ_r_ext, circ_y - circ_r_ext, cx + circ_r_ext, circ_y + circ_r_ext], fill="#D32F2F")
    draw.ellipse([cx - circ_r_int, circ_y - circ_r_int, cx + circ_r_int, circ_y + circ_r_int], fill="#FFFFFF")
    
    # Número "30" en negro vial oficial
    try:
        font_num = ImageFont.truetype("arialbd.ttf", 150)
        draw.text((cx - 88, circ_y - 100), "30", fill="#263238", font=font_num)
    except Exception:
        draw.text((cx - 60, circ_y - 60), "30", fill="#263238", font=FONTS["huge"])

    # -------------------------------------------------------------
    # C. TEXTO INFERIOR: "CUANDO" / "ACTIVADA"
    # -------------------------------------------------------------
    try:
        font_txt = ImageFont.truetype("arialbd.ttf", 46)
    except Exception:
        font_txt = FONTS["big"]

    draw.text((cx - 105, placa_top + 675), "CUANDO", fill="#455A64", font=font_txt)
    draw.text((cx - 130, placa_top + 735), "ACTIVADA", fill="#455A64", font=font_txt)

    # Remaches de fijación en las esquinas de la lámina
    remaches_lamina = [
        (placa_left + 35, placa_top + 35), (placa_right - 35, placa_top + 35),
        (placa_left + 35, placa_bottom - 35), (placa_right - 35, placa_bottom - 35)
    ]
    for rx, ry in remaches_lamina:
        draw.ellipse([rx - 6, ry - 6, rx + 6, ry + 6], fill="#B0BEC5", outline="#546E7A", width=1)
        draw.line([rx - 3, ry, rx + 3, ry], fill="#37474F", width=1)

    # Guardar en ambas ubicaciones
    img.save(os.path.join(IMG_DIR, "senal_vial.jpeg"), quality=95)
    img.save(os.path.join(IMG_DIR, "senal_vial_hd.png"))
    print("Señal vial integrada generada exitosamente en HD.")

# ==============================================================================
# 2. ILUSTRACIÓN DE ALTA CALIDAD: PLACA FÍSICA DE HORARIOS ESCOLARES (MACRO)
# ==============================================================================
def gen_placa_horario_hd():
    w, h = 640, 420
    img = Image.new("RGB", (w, h), "#FAFAFA")
    draw = ImageDraw.Draw(img)

    # Sombra exterior
    draw.rounded_rectangle([25, 25, w - 15, h - 15], radius=20, fill="#CFD8DC")
    
    # Placa metálica de aluminio con borde biselado
    draw.rounded_rectangle([15, 15, w - 25, h - 25], radius=20, fill="#FFFFFF", outline="#455A64", width=4)
    # Borde interior reflectivo
    draw.rounded_rectangle([25, 25, w - 35, h - 35], radius=14, fill="#FFFFFF", outline="#B0BEC5", width=2)

    # Remaches metálicos en las 4 esquinas
    remaches = [(45, 45), (w - 55, 45), (45, h - 55), (w - 55, h - 55)]
    for rx, ry in remaches:
        draw.ellipse([rx - 9, ry - 9, rx + 9, ry + 9], fill="#CFD8DC", outline="#546E7A", width=2)
        draw.ellipse([rx - 5, ry - 5, rx + 5, ry + 5], fill="#ECEFF1")
        draw.line([rx - 6, ry, rx + 6, ry], fill="#37474F", width=2)

    # Encabezado amarillo vial escolar
    draw.rounded_rectangle([50, 40, w - 60, 105], radius=10, fill="#FFF9C4", outline="#FFD54F", width=2)
    draw.text((w // 2 - 165, 55), "HORARIO REGLAMENTARIO", fill="#E65100", font=FONTS["title"])
    draw.text((w // 2 - 105, 82), "ZONA ESCOLAR · LÍMITE 30 km/h", fill="#BF360C", font=FONTS["small_bold"])

    # Tarjetas de Franjas Horarias
    franjas = [
        ("TURNO MAÑANA:", "Entre  06:00 am  y  09:00 am", 125, "#E8F5E9", "#4CAF50"),
        ("TURNO MEDIODÍA:", "Entre  11:30 am  y  01:30 pm (13:30)", 195, "#E3F2FD", "#2196F3"),
        ("TURNO TARDE:", "Entre  03:00 pm (15:00)  y  04:30 pm (16:30)", 265, "#FFF3E0", "#FF9800")
    ]

    for label, horario, y_pos, bg_color, border_color in franjas:
        draw.rounded_rectangle([50, y_pos, w - 60, y_pos + 56], radius=8, fill=bg_color, outline=border_color, width=2)
        draw.text((65, y_pos + 8), label, fill="#37474F", font=FONTS["small_bold"])
        draw.text((65, y_pos + 26), horario, fill="#1A1A1A", font=FONTS["bold"])

    # Pie de placa
    draw.text((w // 2 - 170, 345), "VIGENCIA: LUNES A VIERNES (DÍAS ESCOLARES)", fill="#37474F", font=FONTS["small_bold"])
    draw.text((w // 2 - 120, 368), "IT VIAL S.A.S · SEÑALIZACIÓN OFICIAL", fill="#78909C", font=FONTS["small"])

    # Guardar en ambas ubicaciones
    img.save(os.path.join(IMG_DIR, "placa_horario.jpeg"), quality=95)
    img.save(os.path.join(IMG_DIR, "placa_horario_hd.png"))
    print("Placa de horarios generada exitosamente en HD.")

def main():
    gen_senal_vial_hd()
    gen_placa_horario_hd()

if __name__ == "__main__":
    main()
