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
# 1. ILUSTRACIÓN DE ALTA CALIDAD: SEÑAL VIAL «30 CUANDO ACTIVADA» COMPLETA
# ==============================================================================
def gen_senal_vial_hd():
    w, h = 600, 840
    img = Image.new("RGB", (w, h), "#F0F4F8")
    draw = ImageDraw.Draw(img)

    # Fondo degradado cielo sutil
    for y in range(h):
        r = int(235 + (245 - 235) * (y / h))
        g = int(240 + (248 - 240) * (y / h))
        b = int(248 + (252 - 248) * (y / h))
        draw.line([(0, y), (w, y)], fill=(r, g, b))

    # Poste galvanizado central
    poste_x = w // 2
    draw.rectangle([poste_x - 18, 20, poste_x + 18, h - 20], fill="#B0BEC5", outline="#78909C", width=2)
    # Brillo metálico del poste
    draw.line([poste_x - 6, 20, poste_x - 6, h - 20], fill="#CFD8DC", width=4)

    # -------------------------------------------------------------
    # A. FOCO / BALIZA DESTELLANTE SUPERIOR (AMBAR / 1 Hz)
    # -------------------------------------------------------------
    # Gabinete del foco
    draw.rounded_rectangle([poste_x - 65, 45, poste_x + 65, 175], radius=16, fill="#263238", outline="#1A1A1A", width=3)
    # Visera superior
    draw.polygon([(poste_x - 70, 50), (poste_x + 70, 50), (poste_x + 60, 35), (poste_x - 60, 35)], fill="#1A1A1A")
    
    # Destello de luz ámbar (Halo)
    for rad, alpha_color in [(62, "#FFF8E1"), (56, "#FFE082"), (50, "#FFB300")]:
        draw.ellipse([poste_x - rad, 110 - rad, poste_x + rad, 110 + rad], fill=alpha_color)
    
    # Lente óptico LED con textura
    draw.ellipse([poste_x - 42, 110 - 42, poste_x + 42, 110 + 42], fill="#FF8F00", outline="#E65100", width=3)
    draw.ellipse([poste_x - 30, 110 - 30, poste_x + 30, 110 + 30], fill="#FFC107")
    draw.text((poste_x - 32, 160), "1.0 Hz", fill="#FFF59D", font=FONTS["small_bold"])

    # -------------------------------------------------------------
    # B. SEÑAL VIAL REGLAMENTARIA (PLACA PRINCIPAL BLANCA / REFLECTIVA)
    # -------------------------------------------------------------
    placa_top = 195
    placa_bottom = 545
    placa_left = 65
    placa_right = w - 65

    # Sombra de la placa
    draw.rounded_rectangle([placa_left + 6, placa_top + 6, placa_right + 6, placa_bottom + 6], radius=24, fill="#B0BEC5")
    # Placa metálica blanca con borde redondeado
    draw.rounded_rectangle([placa_left, placa_top, placa_right, placa_bottom], radius=24, fill="#FFFFFF", outline="#37474F", width=4)
    # Borde interno reflectivo
    draw.rounded_rectangle([placa_left + 10, placa_top + 10, placa_right - 10, placa_bottom - 10], radius=16, fill="#FFFFFF", outline="#90A4AE", width=2)

    # Círculo Reglamentario Rojo de Límite de Velocidad
    circ_y = placa_top + 145
    draw.ellipse([poste_x - 120, circ_y - 120, poste_x + 120, circ_y + 120], fill="#D32F2F")
    draw.ellipse([poste_x - 94, circ_y - 94, poste_x + 94, circ_y + 94], fill="#FFFFFF")
    
    # Número "30" en negro oficial
    draw.text((poste_x - 52, circ_y - 45), "30", fill="#1A1A1A", font=FONTS["huge"])
    draw.text((poste_x - 32, circ_y + 35), "km/h", fill="#424242", font=FONTS["small_bold"])

    # Texto inferior en placa: "CUANDO ACTIVADA"
    draw.text((poste_x - 150, placa_top + 285), "CUANDO ACTIVADA", fill="#1A1A1A", font=FONTS["title"])

    # Tornillos de sujeción
    for tx, ty in [(placa_left + 22, placa_top + 22), (placa_right - 22, placa_top + 22),
                   (placa_left + 22, placa_bottom - 22), (placa_right - 22, placa_bottom - 22)]:
        draw.ellipse([tx - 6, ty - 6, tx + 6, ty + 6], fill="#78909C", outline="#37474F", width=1)
        draw.line([tx - 3, ty, tx + 3, ty], fill="#263238", width=1)

    # -------------------------------------------------------------
    # C. PLACA SECUNDARIA DE HORARIOS ESCOLARES ATORNILLADA
    # -------------------------------------------------------------
    h_top = 570
    h_bottom = 800
    h_left = 90
    h_right = w - 90

    # Sombra
    draw.rounded_rectangle([h_left + 5, h_top + 5, h_right + 5, h_bottom + 5], radius=14, fill="#B0BEC5")
    # Placa aluminio cepillado / blanco técnico
    draw.rounded_rectangle([h_left, h_top, h_right, h_bottom], radius=14, fill="#FFFFFF", outline="#37474F", width=3)
    draw.rounded_rectangle([h_left + 6, h_top + 6, h_right - 6, h_bottom - 6], radius=10, fill="#FFFFFF", outline="#B0BEC5", width=1)

    # Encabezado Placa Horario
    draw.rounded_rectangle([h_left + 12, h_top + 12, h_right - 12, h_top + 52], radius=6, fill="#FFF8E1", outline="#FFE082")
    draw.text((poste_x - 125, h_top + 20), "HORARIO ZONA ESCOLAR", fill="#D84315", font=FONTS["bold"])

    # Las 3 Franjas Oficiales
    draw.text((h_left + 24, h_top + 68), "• Entre 06:00 am y 09:00 am", fill="#212121", font=FONTS["bold"])
    draw.text((h_left + 24, h_top + 112), "• Entre 11:30 am y 01:30 pm (13:30)", fill="#212121", font=FONTS["bold"])
    draw.text((h_left + 24, h_top + 156), "• Entre 03:00 pm y 04:30 pm (16:30)", fill="#212121", font=FONTS["bold"])

    # Días
    draw.text((poste_x - 90, h_top + 195), "Lunes a Viernes", fill="#546E7A", font=FONTS["small_bold"])

    # Remaches esquinas
    for rx, ry in [(h_left + 14, h_top + 14), (h_right - 14, h_top + 14),
                   (h_left + 14, h_bottom - 14), (h_right - 14, h_bottom - 14)]:
        draw.ellipse([rx - 4, ry - 4, rx + 4, ry + 4], fill="#90A4AE", outline="#455A64", width=1)

    # Guardar en ambas ubicaciones
    img.save(os.path.join(IMG_DIR, "senal_vial.jpeg"), quality=95)
    img.save(os.path.join(IMG_DIR, "senal_vial_hd.png"))
    print("Señal vial generada exitosamente en HD.")

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
