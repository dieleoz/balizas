# Hoja de ruta — Baliza «30 CUANDO ACTIVADA»

**Última auditoría: 22-ago-2026.** Lo que aquí figura como entregado está medido, no
declarado: el arnés corrió (**58 de 58 · PASS**) y los hashes se recalcularon sobre los
ficheros del repositorio.

> Este documento dice **qué falta y en qué orden**. Un roadmap sin pendientes no es un
> roadmap terminado: es un roadmap que dejó de mirarse. Si algo se cierra, se mueve a la
> tabla de entregado con la fecha en que se midió.

---

## Pendientes

### 1. La temperatura se lee de un pin que el firmware dejó digital — ABIERTO

`Aplicacion.c:236` lee el sensor con `ADC_read(3)`, es decir **AN3**. Pero `main.c:175` deja
`ADCON1bits.PCFG = 0b1011`, que en el PIC18F2550 solo habilita **AN0, AN1 y AN2**. AN3 queda
como entrada digital, así que la conversión no mide el sensor: devuelve basura.

La fórmula **ya está bien** —`(ADC * 5000) / 1024` entrega décimas de grado para un LM35 de
10 mV/°C, y eso se corrigió—, pero una fórmula correcta sobre una lectura inválida sigue
dando un número inválido. El defecto sobrevivió porque **el simulador no lo puede ver**: el
arnés devuelve el valor que se le pida por `ADC_read()` y nunca se entera de `PCFG`.

- **Arreglo:** `PCFG = 0b1010` habilita AN0–AN3. Una línea, en `main.c`.
- **Antes de tocarlo:** hace falta el escenario que lo mida en rojo (regla 0). Hoy no existe,
  y por eso esto es un pendiente y no un cambio hecho.
- **Impacto:** la telemetría de batería (**AN1**) **no está afectada** y se lee bien. Solo la
  temperatura es basura.

### 2. Los 1 kΩ en serie en `MCU_TX` — ABIERTO, va en el arnés de cables

El `RXD` del módulo Bluetooth es de **3,3 V** y hoy se ataca con **5 V sin adaptación**. No
es un fallo: el enlace funciona (verificado el 21-ago-2026). Es un riesgo que mata módulos a
las semanas. **1 kΩ en serie en el arnés de cables — no en la PCB**, que está fabricada.

### 3. Dos `.hex` conviven y el README solo nombra a uno — POR DECIDIR

| Fichero | Tamaño | Fecha | Qué es |
|---|---|---|---|
| `1 Firmware/Doc mplabx/18f2550_baliza__V1.X.production.hex` | 61.008 B | oct-2025 | Lo que **corre hoy en la calle** (según `ESTADO.md`) |
| `1 Firmware/BALIZA_18F2550_V1_CORREGIDO.hex` | 49.068 B | ago-2026 | El binario **nuevo**, con la cadencia de 1,0 Hz y el buzzer en RC1 |

No es una contradicción —el binario nuevo aún no se ha desplegado— pero **el README lo
presenta como «el binario» sin decir que las señales montadas todavía llevan el viejo**.
Hasta que se grabe y se confirme en campo, los dos son ciertos y hay que decirlo.

### 4. Códigos de día 1..7 (días concretos) — NO IMPLEMENTADO

Hoy solo existen **8** (diario), **9** (lunes a viernes) y **10** (fin de semana). Los
valores 1..7 se aceptan en la trama pero no seleccionan un día concreto.

---

## Entregado y medido

| Entregable | Fichero | Cómo se comprobó |
|---|---|---|
| Firmware C99 | [`1 Firmware/Doc mplabx/18f2550_baliza_ V1.X/`](1%20Firmware/Doc%20mplabx/18f2550_baliza_%20V1.X/) | Arnés 58/58 PASS, 22-ago-2026 |
| Binario `.hex` | [`1 Firmware/BALIZA_18F2550_V1_CORREGIDO.hex`](1%20Firmware/BALIZA_18F2550_V1_CORREGIDO.hex) | SHA-256 recalculado sobre el fichero |
| Mapa de memoria `.map` | [`1 Firmware/BALIZA_18F2550_V1_CORREGIDO.map`](1%20Firmware/BALIZA_18F2550_V1_CORREGIDO.map) | Declara `XC8 Compiler V2.36`, leído del propio fichero |
| Instalador Android | [`7 sw apk/Baliza_IT_VIAL_30_v3.4.apk`](7%20sw%20apk/Baliza_IT_VIAL_30_v3.4.apk) | SHA-256 recalculado; cabecera `PK` válida |
| Arnés de pruebas | [`4 Simulador/arnes.c`](4%20Simulador/arnes.c) | 58 `CHECK` reales, contados en el fuente |
| Suite E2E | [`4 Simulador/test_suite_e2e.py`](4%20Simulador/test_suite_e2e.py) | — |
| Emulador web | [`4 Simulador/emulador_app/`](4%20Simulador/emulador_app/) | — |
| Cadencia 1,0 Hz | `Cluster.c` | Medida por el arnés (bloque C) |
| Buzzer en `RC1` | `Buzzer.h:24`, `pinConfBuzzer()` | Leído en el fuente: `LATC1`, `TRISC1=0` |

### Lo que ninguna de esas comprobaciones dice

El arnés no toca un pin real. No dice nada del ADC, del I²C, del DS1307 sin alimentación, de
que el módulo Bluetooth empareje, ni —lo que más importa— de que **el horario grabado
coincida con la chapa atornillada a esa señal**. Eso lo mira una persona con la señal delante.

---

## Referencias

* Manual de usuario de la App: [`Manuales/MANUAL_USUARIO_APP.md`](Manuales/MANUAL_USUARIO_APP.md)
* Manual técnico del firmware: [`Manuales/MANUAL_TECNICO_FIRMWARE_C99.md`](Manuales/MANUAL_TECNICO_FIRMWARE_C99.md)
* Compilar y grabar: [`Manuales/COMPILAR_Y_GRABAR.md`](Manuales/COMPILAR_Y_GRABAR.md)
* Restricciones de la tarjeta: [`Manuales/HARDWARE.md`](Manuales/HARDWARE.md)
* Bluetooth: [`Manuales/BLUETOOTH.md`](Manuales/BLUETOOTH.md)
* Certificado de calibración: [`Manuales/CERTIFICADO_FIRMWARE_v3.4.md`](Manuales/CERTIFICADO_FIRMWARE_v3.4.md)
* Estado de la última sesión: [`ESTADO.md`](ESTADO.md)
