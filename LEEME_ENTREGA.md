# LEEME — Entrega Baliza, 21 de agosto de 2026

Paquete para **compilar el firmware y grabarlo** en el PIC de la baliza.

---

## ⚠️ Lo primero, y no es una formalidad

**Este firmware NO ha pasado prueba de banco. Ningún pin se ha comprobado contra su carga.**

Lo que hay verificado es que la lógica pasa un banco de pruebas de PC —37 comprobaciones, las 37
en verde— y que compila. Eso significa que un modelo de ordenador no encuentra nada. **No
significa que el equipo funcione.**

Al otro lado del programador hay una **señal de tránsito instalada frente a un colegio**: cuando
su luz titila, el límite de 30 km/h está vigente para todo el que pasa.

Así que este paquete es para **grabar en banco y medir**, no para instalar en una señal en
servicio. Antes de que esto salga a la calle hay que comprobar, con el equipo delante:

- [ ] Que la luz enciende de verdad al activarse la salida (etapa de potencia).
- [ ] Que el buzzer suena.
- [ ] Que el DS1307 conserva la hora al quitar la alimentación.
- [ ] Que el horario programado coincide **con la placa atornillada a esa señal concreta**.

---

## Qué hay dentro

```
BALIZA_ENTREGA_21ago2026/
  LEEME.md  ·  LEEME.docx        este documento
  1_Firmware_fuente/             los .c y .h, más Rtos/ — el código que se compila
  2_Binario/
    baliza_21ago2026_XC8-2.36.hex        el .hex NUEVO, de este paquete
    baliza_ANTERIOR_en_produccion.hex    el que está hoy en las señales
  3_Manuales/
    COMPILAR_Y_GRABAR.docx               cómo compilar y cómo grabar, paso a paso
    MANUAL_FUNCIONAL_BLUETOOTH.docx      configurar y validar el módulo Bluetooth
    HARDWARE.docx                        la tarjeta, y dónde está la cabecera ICSP
```

Se dejan **los dos `.hex`** a propósito: si algo va mal después de grabar, hay que poder volver
en un minuto a lo que había antes.

---

## Compilar

Hace falta **MPLAB X v5.45** y **XC8 v2.36** (o v2.46, ver más abajo).

```
cd 1_Firmware_fuente
"C:\Program Files\Microchip\xc8\v2.36\bin\xc8.exe" --chip=18f2550 --std=c99 ^
   --outdir=..\2_Binario ^
   main.c Alarma.c Aplicacion.c Buzzer.c Cluster.c DS1307.c EEprom.c I2C.c ^
   LedLive.c Serial.c TimeBase.c
```

Tiene que terminar con **código de salida 0** y este resumen:

```
Program space   used  529Bh ( 21147) of  8000h bytes   ( 64.5%)
Data space      used   2B0h (   688) of   800h bytes   ( 33.6%)
```

**Si te salen otras cifras, no grabes:** o estás usando otra versión del compilador, o el código
no es este.

### Tres cosas que hacen perder la tarde

1. **`--std=c99` NO es opcional.** Sin esa bandera el compilador va en C90 y **falla**, en
   `DS1307.c` línea 66, con `(188) constant expression required`. **No toques ese fichero: el
   problema es la bandera.** Si recreas el proyecto en MPLAB X, pon el estándar en **C99** en las
   propiedades del proyecto.

2. **Compila siempre con `--outdir` apuntando fuera de la carpeta de fuentes.** Sin él, XC8 deja
   más de un mega de ficheros intermedios mezclados con el código.

3. **`File > Open Project` no va a funcionar.** Esta carpeta **no trae `nbproject/`**, así que
   MPLAB X no la reconoce como proyecto y parecerá que el IDE está roto. Hay que crear un
   proyecto nuevo (*Standalone*, dispositivo **PIC18F2550**, compilador XC8) y añadir los fuentes
   existentes. El paso a paso está en `3_Manuales/COMPILAR_Y_GRABAR.docx`.

### Sobre la versión del compilador

El `.hex` de este paquete se generó con **XC8 v2.36**. El que está hoy en las señales se compiló
con la **v2.46**, así que **los dos ficheros no son comparables byte a byte** — es normal que
difieran, no es un error.

Si quieres reproducir exactamente lo que hay instalado, instala la v2.46. Para desarrollar, la
v2.36 vale, pero **anota siempre con qué versión compilaste**: la versión del compilador y sus
banderas son parte del entregable.

---

## Grabar

El procedimiento completo está en `3_Manuales/COMPILAR_Y_GRABAR.docx`. Lo esencial:

- Programadores válidos: **PICkit 3/4, ICD 3/4, REAL ICE o PM3**.
- ⚠️ **MPLAB Snap NO soporta el PIC18F2550.** No lo intentes con ese.
- **Decide de dónde se alimenta la tarjeta: por sus 12 V o desde el programador. Nunca las dos a
  la vez.**
- La cabecera **ICSP** está en la tarjeta; su posición y patillaje, en `3_Manuales/HARDWARE.docx`.

---

## Qué cambia respecto al firmware anterior

| | antes | ahora |
|---|---|---|
| **Cadencia de la luz** | ráfagas de 5 destellos de 50 ms con pausa | **1 Hz: 500 ms encendida, 500 ms apagada** (60 destellos/min, según norma de señalización para zona escolar) |
| **Arranque dentro de una franja** | si el equipo arrancaba a las 06:30 dentro de la franja 06:00–09:00, la luz **no encendía hasta el día siguiente** | se evalúa si la hora actual está **dentro** del intervalo; un corte de luz ya no apaga la señal toda la mañana |
| **Franjas solapadas** | la primera franja que terminaba apagaba la luz aunque otra siguiera abierta | la luz depende de si hay **alguna** franja activa |
| **Trama malformada** | una trama cortada **tumbaba el firmware** | se comprueban los punteros y se acotan las copias |
| **Buzzer** | el firmware atacaba `RC0`, que en la tarjeta es el pulsador | **`RC1`**, que es donde lo tiene la placa, y `RC0` vuelve a ser entrada |

---

## Y el Bluetooth

Está en `3_Manuales/MANUAL_FUNCIONAL_BLUETOOTH.docx`. Dos cosas que ahorran días:

> 🚨 **Antes de enchufar un módulo, compara su serigrafía con el zócalo.** El pinout del SIG0109A
> está documentado de dos formas contradictorias, y en una de ellas **VCC y GND están
> intercambiados**. Si es esa, el módulo muere al alimentarlo. Es la explicación más probable de
> los módulos «quemados».

> **El firmware no distingue módulos.** Para él es un puerto serie transparente a **9600 8N1
> fijo**. El `.hex` no está «compilado para el HC-06»: si el Bluetooth falla, el problema está en
> el módulo, en su configuración, en el cableado o en la app — nunca en que el binario sea de
> otra versión.

Lo medido el 21-ago-2026: el módulo probado es un **JDY-31**, empareja con `1234` y **pasa la
prueba de bucle**, así que está sano.

---

## Si algo no cuadra

- Las cifras de memoria no coinciden → estás compilando otra cosa o con otra versión.
- El compilador falla en `DS1307.c:66` → te falta `--std=c99`.
- MPLAB X no abre la carpeta → falta `nbproject/`, hay que crear proyecto nuevo.
- Grabas y la señal no hace nada → **no toques el firmware todavía**: mide primero la salida en
  la bornera con el equipo alimentado.
