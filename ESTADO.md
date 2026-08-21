# Estado — 21 de agosto de 2026

> Este archivo se reescribe cada sesión. Las cifras viven aquí y **no** en las skills ni en los
> manuales: allí se congelarían y mentirían en días.

## Qué corre hoy en la señal

El `.hex` que hay instalado es
[`1 Firmware/Doc mplabx/18f2550_baliza__V1.X.production.hex`](1%20Firmware/Doc%20mplabx/18f2550_baliza__V1.X.production.hex),
compilado con **XC8 v2.46** (según el `.map` de `dist/default/debug/`).

**No ha pasado prueba física de banco.** Ningún pin se ha comprobado contra su carga.

## Simulador

```
python "4 Simulador/correr.py"     →  FALLA (1)
MIDIERON: 33 comprobaciones   ok: 24   FALLA: 9
```

Los 9 rojos son **esperados y están fechados** en `4 Simulador/arnes.c`. Ninguno es un defecto
del instrumento.

| # | escenario | qué demuestra |
|---|---|---|
| C | cadencia de la luz | mide **50 ms encendida / 50 ms apagada**; lo definido son **2 s / 2 s** |
| D1 | arranque dentro de la franja | a las 07:00 con franja 06:00–09:00 la luz **no enciende** |
| D2 | días personalizados | una alarma pedida para un día concreto **no se graba** y no se avisa |
| D3 | días personalizados | la tarea de alarma se queda **clavada en `ST_CHECK_ALARM1`** para siempre |
| D4 | `transmitUart1` | transmite un **byte 0x00 de más** al final de cada línea |
| D5 | trama truncada | **tumba el firmware** (desbordamiento en `extraerValue`) |
| D6 | franjas solapadas | la primera franja que termina **apaga la luz** aunque otra siga abierta |

## Compilación

- **MPLAB X 5.45** instalado. **XC8 v2.36** instalado y verificado.
- El firmware **compila**, pero **solo con `--std=c99`**. En C90 falla en `DS1307.c:66`.
- ⚠️ **La carpeta del firmware no tiene `nbproject/`**: MPLAB X no la abre como proyecto. Hay
  que crear proyecto nuevo y añadir los fuentes.
- ⚠️ El tamaño resultante **depende de las banderas**: con `xc8.exe --chip=18f2550 --std=c99`
  salen **21.309 bytes (65 %)**; otra invocación de la misma sesión dio **26.863 (82 %)**. Hasta
  que no se fije un juego de banderas único y se anote junto al `.hex`, esa cifra no significa
  nada. **La versión del compilador y sus banderas son parte del entregable.**

## Firmware ↔ tarjeta: dos desajustes medidos

La tarjeta **ya está fabricada y es fija**. Se cambia el firmware.

| | tarjeta ([`HARDWARE.md`](HARDWARE.md)) | firmware | efecto |
|---|---|---|---|
| Buzzer | `RC1` | `RC0` (`Buzzer.h:24`) | no suena; y `RC0` es la línea del pulsador |
| Temperatura | LM35 en `AN3` | `PCFG = 0b1011` solo habilita AN0–AN2, y la fórmula usa factor 10 donde el LM35 pide 100 | la temperatura leída no es la temperatura |

La medida de **tensión sí es correcta**: el divisor de la placa da factor 6 y el firmware
aplica 6.

## Bluetooth

- Con **HC-06 funcionaba**. Con **HC-05** y con el **SIG0109A** «no lo reconoce».
- El SIG0109A **no es un HC-05**: es un clon con chip **Beken BK3231S**. El único PDF disponible
  es el del SoC, no el del módulo: no trae baudios de fábrica, ni comandos AT, ni pinout.
- El firmware **no distingue módulos**: para él es un puerto serie transparente a 9600 8N1 fijo.
  La creencia de que el `.hex` está «compilado para otro Bluetooth» es falsa y está costando
  tiempo.
- Diagnóstico y procedimiento de prueba: [`BLUETOOTH.md`](BLUETOOTH.md). Configuración y
  validación módulo a módulo: [`MANUAL_FUNCIONAL_BLUETOOTH.md`](MANUAL_FUNCIONAL_BLUETOOTH.md).

## Lo que sigue sin estar decidido

- La **convención de nombres** de los módulos Bluetooth es una propuesta, no un acuerdo. Sin
  ella, dos señales en la misma calle son indistinguibles desde el móvil.
- El horario que hay que programar en cada señal sale de **su** placa atornillada. No hay
  registro de qué señal lleva qué horario.

## Qué corresponde mandar hoy

Un **encargo de medida**, no una entrega de versión. Ver la skill
[`entregar`](.claude/skills/entregar/SKILL.md).
