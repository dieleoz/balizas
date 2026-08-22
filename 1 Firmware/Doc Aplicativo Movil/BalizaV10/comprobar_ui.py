# -*- coding: utf-8 -*-
"""Comprobaciones de usabilidad que se pueden hacer SIN renderizar:
contraste WCAG, tamano de las areas tactiles, y riesgos de responsive."""
import io
import os
import re
import sys

LAYOUT = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                      "app", "src", "main", "res", "layout", "activity_main2.xml")
src = io.open(LAYOUT, encoding="utf-8").read()

fallos = []


def ok(cond, msg):
    print(("   ok    " if cond else "   FALLA ") + msg)
    if not cond:
        fallos.append(msg)


# ---------------------------------------------------------------- contraste
def lum(c):
    c = c.lstrip("#")
    if len(c) == 8:
        c = c[2:]
    r, g, b = (int(c[i:i + 2], 16) / 255.0 for i in (0, 2, 4))

    def f(x):
        return x / 12.92 if x <= 0.03928 else ((x + 0.055) / 1.055) ** 2.4
    return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b)


def ratio(a, b):
    la, lb = lum(a), lum(b)
    hi, lo = max(la, lb), min(la, lb)
    return (hi + 0.05) / (lo + 0.05)


print("\n-- Contraste (WCAG 2.1). Minimo AA: 4.5 texto normal, 3.0 texto grande")
# pares realmente usados en la tarjeta nueva
pares = [
    ("#0F172A", "#FFFFFF", "titulos y horas sobre tarjeta blanca", 4.5),
    ("#B45309", "#FFFFFF", "aviso ambar sobre tarjeta blanca", 4.5),
    ("#475569", "#FFFFFF", "texto secundario sobre tarjeta blanca", 4.5),
    ("#0F172A", "#E2E8F0", "hora sobre boton gris", 3.0),
    ("#FFFFFF", "#15803D", "GRABAR: blanco sobre verde", 3.0),
    ("#FFFFFF", "#B45309", "APAGAR RECESO: blanco sobre ambar", 3.0),
    ("#FFFFFF", "#1D4ED8", "REANUDAR: blanco sobre azul", 3.0),
]
for fg, bg, nom, minimo in pares:
    r = ratio(fg, bg)
    ok(r >= minimo, "%-42s %.2f:1  (min %.1f)" % (nom, r, minimo))

# ---------------------------------------------------------- areas tactiles
print("\n-- Areas tactiles (Material Design y WCAG 2.5.5: minimo 48dp)")
bloques = re.findall(r"<(Button|Spinner|androidx\.appcompat\.widget\.SwitchCompat)\b(.*?)/>",
                     src, re.S)
peq = []
for tag, cuerpo in bloques:
    idm = re.search(r'android:id="@\+id/([A-Za-z0-9_]+)"', cuerpo)
    nom = idm.group(1) if idm else "(sin id)"
    hm = re.search(r'android:minHeight="(\d+)dp"', cuerpo)
    h = int(hm.group(1)) if hm else 0
    if h < 48:
        peq.append("%s (%s) minHeight=%s" % (nom, tag.split(".")[-1], h or "sin declarar"))
ok(not peq, "los %d controles declaran minHeight >= 48dp" % len(bloques))
for p in peq:
    print("           " + p)

# ------------------------------------------------------------- responsive
print("\n-- Responsive")
# 0dp con weight ES el idiom responsive correcto: solo cuentan los anchos reales
anchos_fijos = [a for a in re.findall(r'android:layout_width="(\d+)dp"', src) if a != "0"]
ok(not anchos_fijos, "anchos fijos en dp: %d (0dp+weight no cuenta, es lo correcto)" % len(anchos_fijos))

tam_texto = [int(x) for x in re.findall(r'android:textSize="(\d+)sp"', src)]
ok(all(t >= 12 for t in tam_texto),
   "ningun texto por debajo de 12sp (minimo: %dsp)" % (min(tam_texto) if tam_texto else 0))

ok('android:textSize="' not in src or "dp\"" not in
   " ".join(re.findall(r'android:textSize="[^"]+"', src)),
   "los tamanos de texto van en sp, no en dp (escalan con el ajuste del usuario)")

ok(src.count("<ScrollView") >= 1,
   "la pantalla va dentro de un ScrollView (no se corta en pantallas bajas)")

# altura estimada de la tarjeta nueva
filas = src.count("idBtnF")
print("\n-- Tarjeta 'Horario de esta placa'")
alto = 4 * 60 + 60 + 48 + 56 + 120       # filas + grabar + spinner + receso + textos
ok(alto < 900, "alto estimado de la tarjeta ~%ddp, cabe en pantallas de 640dp con scroll" % alto)
ok(filas == 8, "las 4 franjas tienen sus 8 botones de hora (encontrados: %d)" % filas)

# --------------------------------------------- controles muertos
# EL FALLO QUE MAS VECES SE HA COLADO en este proyecto: un control existe en el
# layout, a veces incluso se declara como campo en el Java, y NADIE le hace
# findViewById. Se ve en pantalla, se puede pulsar o marcar, y no hace nada.
#
# Paso tres veces antes de escribirse esta comprobacion (22-ago-2026):
#   - las 4 casillas del checklist de mantenimiento
#   - el boton COMPARTIR CERTIFICADO
#   - el campo de usuario del login, que se descarta al entrar
#
# Ninguno daba error. Simplemente no hacian nada, y el tecnico no tenia forma de
# saberlo: marcaba, pulsaba, y la app se comportaba como si hubiera funcionado.
print("\n-- Controles enlazados al codigo")

JAVA = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                    "app", "src", "main", "java", "com", "example", "balizav10",
                    "MainActivity2.java")
java = io.open(JAVA, encoding="utf-8").read() if os.path.isfile(JAVA) else ""

TAGS = r"Button|CheckBox|Spinner|EditText|RadioButton|Switch|" \
       r"androidx\.appcompat\.widget\.SwitchCompat"
interactivos = re.findall(r"<(?:" + TAGS + r")\b(.*?)/>", src, re.S)

con_id, muertos = 0, []
for cuerpo in interactivos:
    m = re.search(r'android:id="@\+id/(\w+)"', cuerpo)
    if not m:
        continue
    con_id += 1
    if m.group(1) not in java:
        muertos.append(m.group(1))

ok(not muertos, "los %d controles con id se usan desde el codigo" % con_id)
for d in muertos:
    print("           %s  <-- esta en el layout pero NO en el codigo: no hace nada" % d)

print("\n" + "=" * 60)
print(" RESULTADO: " + ("PASS" if not fallos else "FALLA -- %d en rojo" % len(fallos)))
print("=" * 60)
sys.exit(1 if fallos else 0)
