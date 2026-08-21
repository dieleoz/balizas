# Firmware Baliza — documentación técnica

**Proyecto:** Baliza / alarma temporizada
**MCU:** PIC18F2550-I/SP · **Toolchain:** MPLAB X + XC8 v2.46 (C99)
**Autor original:** Ing. Freiman Parga, octubre–noviembre 2022
**Código fuente:** `D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza_ V1.X\`
**Hardware de referencia:** `D:\@Proyect\Baliza\2 Hardware tarjeta\balizaSR30.kicad_sch` (revisión SR30, gerbers 2025-06-24)

Este documento está dirigido a un ingeniero que va a mantener este firmware sin haberlo escrito.
Cada afirmación lleva la referencia `archivo:línea`. Lo que no se puede determinar leyendo el
código está en la sección [21. Preguntas abiertas](#21-preguntas-abiertas), no inventado.

---

## Índice

1. [Qué es el equipo y qué hace](#1-qué-es-el-equipo-y-qué-hace)
2. [Plataforma y configuración](#2-plataforma-y-configuración)
3. [Mapa de pines y periféricos](#3-mapa-de-pines-y-periféricos)
4. [Arquitectura de tareas (protothreads)](#4-arquitectura-de-tareas-protothreads)
5. [Máquina de estados de cada tarea](#5-máquina-de-estados-de-cada-tarea)
6. [Protocolo serie / Bluetooth](#6-protocolo-serie--bluetooth)
7. [Modelo de datos en EEPROM](#7-modelo-de-datos-en-eeprom)
8. [Lógica de alarmas](#8-lógica-de-alarmas)
9. [Defectos y riesgos encontrados](#9-defectos-y-riesgos-encontrados)
10. [Cómo compilar y grabar](#10-cómo-compilar-y-grabar)
11. [Glosario de la nomenclatura](#11-glosario-de-la-nomenclatura)
21. [Preguntas abiertas](#21-preguntas-abiertas)

---

## 1. Qué es el equipo y qué hace

La Baliza es un temporizador que enciende una luz de aviso (el "cluster") en franjas horarias
programadas. Lleva un reloj de tiempo real DS1307 con pila de respaldo (`DS1307.c:37`,
`BT1 = Battery_Cell` en el esquemático), de modo que sabe la hora aunque se corte la
alimentación. El usuario se conecta por Bluetooth desde una app Android (módulo HC-06,
`U2 = HC06_Module`) y programa hasta **cinco alarmas** independientes: para cada una elige hora
de inicio, hora de fin y el tipo de día (todos los días, de lunes a viernes, o fin de semana).
Cuando el reloj entra en una de esas franjas, el equipo activa la salida del cluster (RC2,
`Cluster.h:15`) con un patrón de destellos y hace sonar un zumbador. Un LED de "latido" en RA0
parpadea permanentemente para indicar que el firmware está vivo (`LedLive.c:35-89`).

Internamente el programa no usa un sistema operativo: es un bucle infinito en `main.c:132-140`
que llama por turnos a seis tareas cooperativas escritas con *protothreads* de Adam Dunkels.
Cada tarea es una máquina de estados que se ejecuta cada pocos milisegundos y cede el control
enseguida. La configuración de las cinco alarmas se guarda en la EEPROM interna del PIC
(direcciones 0x00–0x23, `Aplicacion.h:40-102`), así que sobrevive a los cortes de luz. El
protocolo de la app es de texto plano sobre el puerto serie a 9600 baudios, con tramas
delimitadas por un byte de inicio y un `?` de fin (`Serial.h:27-37`). El equipo también puede
devolver por Bluetooth un volcado en texto con la hora actual y el estado de las cinco alarmas
(`Aplicacion.c:285-334`).

---

## 2. Plataforma y configuración

### 2.1 Bits de configuración

Todos los `#pragma config` están en `main.h:12-70`. Los valores relevantes:

| Pragma | Valor | Línea | Efecto |
|---|---|---|---|
| `FOSC` | `HS` | `main.h:17` | Oscilador de cristal alta velocidad, **sin PLL** |
| `PLLDIV` | `1` | `main.h:12` | Prescaler del PLL /1 (irrelevante: el PLL no se usa) |
| `CPUDIV` | `OSC1_PLL2` | `main.h:13` | Fuente primaria /1 → **Fosc = frecuencia del cristal** |
| `USBDIV` | `1` | `main.h:14` | Reloj USB directo (USB no se usa) |
| `FCMEN` | `OFF` | `main.h:18` | Sin monitor de fallo de reloj |
| `IESO` | `OFF` | `main.h:19` | Sin conmutación int/ext de oscilador |
| `PWRT` | `ON` | `main.h:22` | Power-up timer activo (72 ms) |
| **`BOR`** | **`OFF`** | `main.h:23` | **Brown-out reset deshabilitado** → ver [D15](#d15--sin-brown-out-reset-con-escrituras-de-eeprom) |
| `VREGEN` | `OFF` | `main.h:25` | Regulador USB apagado |
| **`WDT`** | **`OFF`** | `main.h:28` | **Watchdog deshabilitado** → ver [D02](#d02--sin-watchdog-y-con-esperas-bloqueantes-sin-timeout) |
| `CCP2MX` | `ON` | `main.h:32` | CCP2 en RC1 |
| `PBADEN` | `ON` | `main.h:33` | PORTB<4:0> arrancan como **analógicos** — importante para I2C |
| `LPT1OSC` | `OFF` | `main.h:34` | Timer1 en modo alta potencia |
| `MCLRE` | `ON` | `main.h:35` | MCLR habilitado como reset |
| `STVREN` | `ON` | `main.h:38` | Desbordamiento de pila hardware → reset |
| `LVP` | `OFF` | `main.h:39` | Programación en bajo voltaje deshabilitada (RB5 libre) |
| `XINST` | `OFF` | `main.h:40` | Set de instrucciones extendido apagado (modo legacy) |
| `CP0..3`, `CPB`, `CPD` | `OFF` | `main.h:43-50` | Sin protección de lectura de código ni de EEPROM |
| `WRT0..3`, `WRTC`, `WRTB`, `WRTD` | `OFF` | `main.h:53-61` | Sin protección de escritura |

Estos pragmas se pueden verificar contra el `.hex` de producción. El registro de configuración
grabado es, en `18f2550_baliza__V1.X.production.hex:1359`:

```
:020000040030CA
:0E000000000C181EFF8381FF0FC00FE00F40A1
```

que en la dirección `0x300000` deja `CONFIG1L=0x00`, `CONFIG1H=0x0C`. `CONFIG1H = 0x0C` tiene
`FOSC<3:0> = 1100` = HS, e `IESO=FCMEN=0`. `CONFIG1L = 0x00` da `PLLDIV=000` (/1),
`CPUDIV=00` y `USBDIV=0`. **El `.hex` de producción coincide con los pragmas del fuente.**

### 2.2 Cristal y `_XTAL_FREQ` — verificación

`main.h:76` declara:

```c
#define _XTAL_FREQ 20000000
```

El esquemático confirma que el cristal físico es de 20 MHz: el componente `Y1` tiene
`(property "Value" "20M")` con footprint `Crystal:Crystal_HC18-U_Vertical`, conectado a
OSC1 (pin 9) y OSC2/RA6 (pin 10) del PIC con dos condensadores `C1 = C2 = 22pF`. El segundo
cristal, `Y2 = 37Khz` (etiquetado mal, es el 32.768 kHz estándar), pertenece al DS1307.

Con `FOSC = HS` (no `HSPLL`) y `CPUDIV` seleccionando la fuente primaria dividida por 1, el reloj
del CPU es directamente el del cristal:

**Fosc = 20 MHz · Tcy = 4/Fosc = 200 ns**

Es decir: `_XTAL_FREQ 20000000` **sí corresponde al reloj real**. No hay la incoherencia de reloj
que cabría sospechar. Sí hay dos problemas de temporización derivados, que se detallan abajo.

### 2.3 UART: verificación de SPBRG contra la fórmula del datasheet

`main.c:117` llama a `UART_init_baud(9600)`. Esa función, en `UART.h:20-42`, hace:

```c
TXSTAbits.BRGH = 0;     // UART.h:26  → baja velocidad
TXSTAbits.SYNC = 0;     // UART.h:31  → asíncrono
SPBRG = 32;             // UART.h:34
```

No se toca `BAUDCON`, luego `BRG16 = 0` (valor por defecto tras reset). La fórmula del datasheet
del PIC18F2550 para modo asíncrono con `BRGH=0` y `BRG16=0` (registro BRG de 8 bits) es:

```
Baudios = Fosc / (64 × (SPBRG + 1))
```

Sustituyendo `SPBRG = 32` y `Fosc = 20 MHz`:

```
Baudios = 20 000 000 / (64 × 33) = 20 000 000 / 2112 = 9469,70 baud
Error   = (9469,70 − 9600) / 9600 = −1,36 %
```

**Conclusión.** La combinación `BRGH=0 / SPBRG=32` da 9469,7 baud sobre un cristal de 20 MHz, no
9600. Para que esa pareja diera 9600 exactos haría falta:

```
Fosc = 9600 × 64 × 33 = 20 275 200 Hz ≈ 20,275 MHz
```

que no es un cristal comercial. Por tanto **el reloj declarado es el correcto** (20 MHz, confirmado
por `Y1` en el esquemático) y lo que está desviado es el baudrate, en −1,36 %. Eso está dentro de
la tolerancia típica de un UART asíncrono de 10 bits (el error acumulado en el bit de stop es
1,36 % × 9,5 ≈ 13 % de un bit, muy por debajo del 50 % que provoca error de trama), y en la
práctica el HC-06 lo tolera sin problema. **No es una avería, es un descuido.**

Lo irónico es que la configuración exacta ya está escrita en el mismo fichero, en la función
`UART_init()` de `UART.h:6-18`, que **nunca se llama desde ningún sitio**:

```c
TXSTAbits.BRGH = 1;     // UART.h:13  → alta velocidad
SPBRG = 129;            // UART.h:14  → "9600 a 20MHZ"
```

Verificación: `Baudios = Fosc / (16 × (SPBRG+1)) = 20e6 / (16 × 130) = 9615,4` → error **+0,16 %**.

> **Recomendación.** Cambiar `UART.h:26` a `TXSTAbits.BRGH = 1;` y `UART.h:34` a `SPBRG = 129;`,
> o mejor, hacer que `UART_init_baud()` calcule `SPBRG` a partir de su parámetro `baudRate`
> (que hoy se ignora por completo: `UART.h:20` recibe `baudRate` y no lo usa nunca).

### 2.4 Base de tiempos: el "tick de 1 ms" no es de 1 ms

`INT_init()` en `main.c:148-164` configura Timer0:

```c
TMR0  = 0xFFEC;   // main.c:162
T0CON = 0x87;     // main.c:163
```

`T0CON = 0x87 = 0b1000_0111` significa:

| Bit | Nombre | Valor | Significado |
|---|---|---|---|
| 7 | `TMR0ON` | 1 | Timer0 en marcha |
| 6 | `T08BIT` | 0 | Modo **16 bits** |
| 5 | `T0CS` | 0 | Fuente = reloj interno (Fosc/4) |
| 4 | `T0SE` | 0 | Irrelevante en modo interno |
| 3 | `PSA` | 0 | Prescaler **asignado** a Timer0 |
| 2:0 | `T0PS<2:0>` | 111 | Prescaler **1:256** |

Cuenta:

```
Tcy                        = 4 / 20 MHz          = 200 ns
1 incremento de TMR0       = 256 × 200 ns        = 51,2 µs
0xFFEC = 65516 → desborda a 65536 en 20 incrementos
Periodo de la interrupción = 20 × 51,2 µs        = 1024 µs = 1,024 ms
```

**El tick real es de 1,024 ms, un 2,4 % más largo que el milisegundo que asume el código.**
(A esto hay que sumarle la latencia de entrada a la ISR antes de recargar `TMR0` en `main.c:53`,
del orden de 1–2 µs, despreciable frente al error del 2,4 %.)

Con el prescaler a 1:256 la granularidad de la recarga es de 51,2 µs, así que **es imposible
obtener 1,000 ms exacto con esa configuración**: el valor entero más cercano son esos 20
incrementos. Para 1,000 ms exacto habría que usar prescaler 1:2 (`T0PS=000`, o sea `T0CON=0x80`)
y recargar `TMR0 = 65536 − 2500 = 63036 = 0xF63C`.

Consecuencias prácticas del +2,4 %:

| Constante nominal | Valor real |
|---|---|
| `PERIOD_APLICACION`/`ALARM`/`BUZZER`/`CLUSTER`/`LEDLIVE` = 10 ms | 10,24 ms |
| `PERIOD_ANALIZA_UART1` = 1 ms (`Serial.h:21`) | 1,024 ms |
| "un minuto de tiks" = 60000 (`main.c:57-58`) | **61,44 s** |
| Parpadeo LED live: 5 + 195 ticks (`LedLive.h:29-30`) = 2,00 s | 2,048 s |
| Beep: 5 ticks (`Buzzer.c:64`) = 50 ms | 51,2 ms |
| Arranque: 500 ciclos (`Aplicacion.h:24`) = 5,0 s | 5,12 s |
| Ráfaga del cluster ≈ 1,00 s | 1,024 s |

**Las alarmas NO se ven afectadas** por este error, porque la hora la aporta el DS1307 por I2C
(`Alarma.c:197`) y no el contador de ticks. El error solo desplaza cadencias internas.

### 2.5 Consumo de memoria

Del mapa del enlazador `dist/default/debug/18f2550_baliza__V1.X.debug.map` (compilación **debug**;
la de producción será algo menor porque no reserva espacio para el depurador):

| Recurso | Uso | Total | % |
|---|---|---|---|
| Programa (`CODE` hasta 0x5310 + `mediumconst` 0x7BBC–0x7D3F) | ≈ 21 652 B | 32 064 B disponibles | ≈ 67 % |
| Libre contiguo en flash | 0x5310–0x7BBB = 0x28AC = 10 412 B | | |
| RAM `cstackCOMRAM` 0x01–0x51 | 81 B | | |
| RAM `cstackBANK0` 0x60–0xF2 | 147 B | | |
| RAM `bssBANK1` 0x100–0x1FC | 253 B | | |
| RAM `bssBANK2` 0x200–0x252 | 83 B | | |
| **RAM total** | **564 B** | 2048 B | 27,5 % |
| EEPROM de datos usada | 36 B (0x00–0x23) | 256 B | 14 % |

La pila software del compilador (`cstack*`) suma unos **228 bytes**. Ahí viven los buffers locales
`bufferTx1[45]` de `Serial.c:53`, `buffer[10]` de `Serial.c:479` y `buffer[4]` de `Serial.c:457`
y `Serial.c:497` — que son precisamente los que se desbordan en [D04](#d04--desbordamiento-de-buffer-en-extraervalue-y-extraerframe).

---

## 3. Mapa de pines y periféricos

Contrastado línea a línea entre el firmware y el esquemático KiCad `balizaSR30.kicad_sch`
(la correspondencia pin↔etiqueta se obtuvo midiendo la distancia entre el extremo de cada pin del
símbolo `PIC18F2550-ISP` colocado en (146.558, 104.521) y las etiquetas de red; las coincidencias
exactas dan una distancia de 9,14 mm, que es la longitud del stub de conexión).

| Función | Pin | Puerto | Dir. | Configurado en | Etiqueta esquemático | ¿Coincide? |
|---|---|---|---|---|---|---|
| LED "live" | 2 | RA0 / AN0 | Salida | `LedLive.c:101` (`TRISA0=0`) | `LED_LIVE` | ✅ |
| Sensor de tensión | 3 | RA1 / AN1 | Entrada analógica | `main.c:175` (PCFG=1011) + `Aplicacion.c:211` (`ADC_read(1)`) | `S_VOLT` | ✅ |
| — sin uso — | 4 | RA2 / AN2 | Analógica habilitada, sin leer | `main.c:175` | (sin conexión) | — |
| Sensor de temperatura (LM35) | 5 | RA3 / AN3 | **Digital** por PCFG | `Aplicacion.c:227` (`ADC_read(3)`) | `S_TEMP` (→ `U5 = LM35-LP`) | ⚠️ ver [D21](#d21--an3-se-lee-por-adc-pero-pcfg-lo-deja-como-digital) |
| Cristal 20 MHz | 9 | OSC1 | — | `main.h:17` (`FOSC=HS`) | `OSC1` → `Y1 = 20M` | ✅ |
| Cristal 20 MHz | 10 | RA6 / OSC2 | — | idem | `OSC2` | ✅ |
| **Buzzer (firmware)** | **11** | **RC0** | **Salida** | `Buzzer.c:163` (`TRISC0=0`), `Buzzer.h:24-25` (`LATC0`) | **`BUTTON`** (→ `SW1 = SW_Push`) | ❌ ver [D01](#d01--el-firmware-usa-rc0-como-buzzer-pero-el-esquemático-dice-que-rc0-es-el-pulsador) |
| **Buzzer (hardware)** | **12** | **RC1** | — | `Buzzer.c:162` **comentado** | `BUZZER` (→ `R11 2.2k` → `Q4 MMBT3904` → `BZ1 Buzzer`) | ❌ nunca se configura |
| Salida cluster | 13 | RC2 / CCP1 | Salida | `Cluster.c:113` (`TRISC2=0`), `Cluster.h:15-16` (`LATC2`) | `CLUSTER` (→ `Q2 Q_NMOS_GDS` TO-220) | ✅ |
| UART TX → HC-06 RX | 17 | RC6 / TX | Salida | `UART.h:29` (`TRISC6=0`) | `MCU_TX` | ✅ |
| UART RX ← HC-06 TX | 18 | RC7 / RX | Entrada | `UART.h:28` (`TRISC7=1`) | `MCU_RX` | ✅ |
| I2C SDA (DS1307) | 21 | RB0 / SDA | Entrada (control MSSP) | `I2C.c:11` (`TRISB.RB0=1`) | `SDA` (→ `U4 = DS1307_`, `R5/R6 4.7k` pull-ups) | ✅ |
| I2C SCL (DS1307) | 22 | RB1 / SCL | Entrada (control MSSP) | `I2C.c:12` (`TRISB.RB1=1`) | `SCL` | ✅ |
| ICSP PGC | 27 | RB6 | — | (no tocado por el firmware) | `PGC` | ✅ |
| ICSP PGD | 28 | RB7 | — | (no tocado por el firmware) | `PGD` | ✅ |
| Reset | 1 | MCLR/RE3 | Entrada | `main.h:35` (`MCLRE=ON`) | `MCLR` | ✅ |

**Notas importantes sobre el mapa de pines:**

1. **RC0/RC1 están cruzados** entre firmware y hardware. Es el defecto [D01](#d01--el-firmware-usa-rc0-como-buzzer-pero-el-esquemático-dice-que-rc0-es-el-pulsador),
   el más grave del documento. El propio código deja la huella del cambio: `Buzzer.c:162` contiene
   `//TRISCbits.TRISC1 = 0;` comentado justo encima de `TRISCbits.TRISC0 = 0;` en `Buzzer.c:163`.

2. **Hay un pulsador físico (`SW1`) sin ningún soporte en el firmware.** No existe módulo
   `Buttons.c`; las únicas huellas son un `extern strButtons button;` comentado en
   `Aplicacion.c:35` y un `ulCntPeriodButtons = 0;` comentado en `main.c:65`. Ver [D33](#d33--pulsador-físico-sin-soporte-en-firmware).

3. **RB0/RB1 con `PBADEN = ON`.** Como `main.h:33` deja PORTB<4:0> como analógicos tras reset,
   RB0 (AN12) y RB1 (AN10) arrancarían como analógicos y el módulo MSSP no funcionaría. Lo salva
   `main.c:115`, que escribe `ADCON1 = 0x0F` (PCFG=1111, todo digital) **antes** de
   `I2C_Master_Init()` en `main.c:121`. Después `ADC_init()` (`main.c:118`) pone `PCFG = 0b1011`,
   que solo vuelve a habilitar AN0/AN1/AN2 = RA0/RA1/RA2; RB0 y RB1 siguen digitales. **El orden
   es correcto, pero es frágil**: depende de que nadie mueva `ADC_init()` después de
   `I2C_Master_Init()`.

4. **RA0 es a la vez la salida del LED y el canal AN0.** `PCFG=1011` habilita AN0 como analógico,
   lo que solo desconecta el buffer digital de *entrada*; el driver de salida sigue funcionando
   porque `TRISA0 = 0` (`LedLive.c:101`). El LED funciona, pero es una asignación de pin sucia.

### 3.1 Configuración del ADC

`ADC_init()` en `main.c:172-182`:

```c
ADCON1bits.VCFG = 0b00;     // main.c:174 — referencias = VSS y VDD
ADCON1bits.PCFG = 0b1011;   // main.c:175 — "Entradas Analogicas a0, a1, a2"
ADCON2bits.ACQT = 0b010;    // main.c:177 — 4 TAD de adquisición
ADCON2bits.ADCS = 0b100;    // main.c:178 — Fosc/4
ADCON2bits.ADFM = 1;        // main.c:179 — justificación a la derecha
ADCON0bits.ADON = 1;        // main.c:181
```

**¿Está el canal 3 habilitado como analógico?** No. Según la tabla de `PCFG<3:0>` del datasheet
del PIC18F2550, el valor `1011` deja **AN0, AN1 y AN2 como analógicos y AN3…AN12 como digitales**.
El comentario del propio autor en `main.c:175` lo dice: *"Entradas Analogicas a0, a1, a2"*.

Por tanto:

- `ADC_read(1)` en `Aplicacion.c:211` lee **AN1, que sí es analógico** → eléctricamente correcto.
- `ADC_read(3)` en `Aplicacion.c:227` lee **AN3, que está configurado como digital** → el buffer
  digital de entrada está activo sobre un pin con una señal analógica del LM35, el resultado de
  conversión no está garantizado por el fabricante y además se produce consumo cruzado en el
  buffer de entrada. Ver [D21](#d21--an3-se-lee-por-adc-pero-pcfg-lo-deja-como-digital).

**Además, el tiempo de conversión está fuera de especificación.** `ADCS = 0b100` selecciona
`Fosc/4`, luego:

```
TAD = 4 / 20 MHz = 200 ns
```

El datasheet exige `TAD ≥ 0,8 µs` y, en su tabla de "TAD vs. frecuencia del dispositivo", limita
`Fosc/4` a un máximo de 5 MHz. A 20 MHz habría que usar `ADCS = 0b010` (Fosc/32 → 1,6 µs) o
`ADCS = 0b110` (Fosc/64 → 3,2 µs). Con `ACQT = 0b010` (4 TAD) el tiempo de adquisición resulta
`4 × 200 ns = 0,8 µs`, cuando el comentario del propio autor en `main.c:177` pide `> 2,45 µs`.
Ver [D22](#d22--tad-y-tacq-del-adc-fuera-de-especificación).

### 3.2 Configuración del I2C

`I2C_Master_Init(100000)` se llama desde `main.c:121`. En `I2C.c:9-22`:

```c
SSPSTATbits.SMP = 1;       // I2C.c:14 — control de slew rate deshabilitado (modo 100 kHz)
SSPCON1bits.SSPEN = 1;     // I2C.c:15
SSPCON1bits.SSPM = 0b1000; // I2C.c:16 — modo maestro I2C
SSPADD = (uint8_t)((_XTAL_FREQ/(4.0*clock))-1);   // I2C.c:20
```

Verificación: `SSPADD = 20e6 / (4 × 100000) − 1 = 50 − 1 = 49` → `SCL = 20e6/(4×50) = 100 kHz`. ✅

La dirección del esclavo se escribe a mano en `DS1307.c`: `208 = 0xD0` para escritura y
`209 = 0xD1` para lectura (`DS1307.c:24`, `DS1307.c:27`), que corresponde a la dirección de 7 bits
`1101000` del DS1307. ✅

---

## 4. Arquitectura de tareas (protothreads)

### 4.1 El bucle principal

`main.c:132-140`:

```c
while(1)
{
    executeTaskLedLive();
    executeTaskAnalizaUart1();
    executeTaskAplicacion();
    executeTaskAlarm();
    executeTaskBuzzer();
    executeTaskCluster();
}
```

Seis tareas, llamadas siempre en el mismo orden, sin prioridades ni planificador. Cada
`executeTaskX()` es un envoltorio de una línea sobre la función protothread correspondiente
(por ejemplo `Cluster.c:104-107`).

Antes del bucle, `main.c:126-131` llama a los seis `startTaskX()`, que se limitan a hacer
`PT_INIT(&ptTaskX)` (por ejemplo `Cluster.c:100-103`).

### 4.2 Cómo funcionan los protothreads aquí

La librería es la de Adam Dunkels (`Rtos/pt.h`, `Rtos/lc.h`). `Rtos/lc.h:114-118` selecciona la
implementación por defecto, `lc-switch.h`, porque el proyecto no define `LC_INCLUDE` (confirmado
en el preprocesado: `build/default/debug/Cluster.i:5140` incluye `./Rtos/lc-switch.h`).

Las macros clave (`Rtos/lc-switch.h:64-72`):

```c
typedef unsigned short lc_t;
#define LC_INIT(s)   s = 0;
#define LC_RESUME(s) switch(s) { case 0:
#define LC_SET(s)    s = __LINE__; case __LINE__:
#define LC_END(s)    }
```

y `Rtos/pt.h:148-154`:

```c
#define PT_WAIT_UNTIL(pt, condition)  \
  do { LC_SET((pt)->lc);              \
       if(!(condition)) { return PT_WAITING; } } while(0)
```

Es decir: el estado de la "tarea" es un único `unsigned short` que guarda el número de línea donde
se suspendió. Al reentrar, el `switch` de `PT_BEGIN` (`Rtos/pt.h:115`) salta directamente a ese
`case`. **No hay pila por tarea, no hay contexto guardado: las variables locales de la función
protothread no sobreviven a una suspensión.** Por eso todo el estado de las tareas vive en
estructuras globales (`ap`, `ala`, `cl`, `serial1`, `anaT1`).

> ⚠️ **Trampa de mantenimiento.** `Rtos/lc-switch.h:60-61` avisa: *"lc implementation using
> switch() does not work if an LC_SET() is done within another switch() statement"*. En este
> firmware todos los `PT_WAIT_UNTIL` están **fuera** del `switch(stateX)`, justo al principio del
> `while(1)` de cada tarea (`Aplicacion.c:62-63`, `Alarma.c:46-47`, `Serial.c:96-98`,
> `Cluster.c:34-35`, `Buzzer.c:24-25`, `LedLive.c:40-41`), así que funciona. Pero si alguien añade
> un `PT_WAIT_UNTIL` o `PT_YIELD` **dentro** de un `case ST_XXX:`, el `case __LINE__:` generado
> caerá en el `switch` interno de estados y la resunción se romperá de forma silenciosa o dará un
> error de compilación confuso. Ver [D45](#d45--lc-switch-impide-poner-esperas-dentro-del-switch-de-estados).

### 4.3 La base de tiempos: `getMillis()` y `ulCntTick1ms`

`main.c:39` declara la única variable de tiempo del sistema:

```c
unsigned long ulCntTick1ms;
```

La ISR de alta prioridad la incrementa en cada desbordamiento de Timer0 (`main.c:50-75`), y
`TimeBase.c:15-18` la expone:

```c
unsigned long getMillis(void) { return ulCntTick1ms; }
```

### 4.4 El patrón de periodo

Todas las tareas usan exactamente la misma plantilla. Ejemplo de `Cluster.c:32-36`:

```c
while (1)
{
    ulCntPeriodCluster = getMillis() + PERIOD_CLUSTER;
    PT_WAIT_UNTIL(pt, getMillis() >= ulCntPeriodCluster);
    switch(stateCluster) { ... }
}
```

Se calcula un instante de vencimiento absoluto y se cede el control hasta alcanzarlo. Los periodos
de cada módulo:

| Tarea | Constante | Valor | Definida en | Periodo real (tick 1,024 ms) |
|---|---|---|---|---|
| `taskLedLive` | `PERIOD_LEDLIVE` | 10 | `LedLive.h:23` | 10,24 ms |
| `taskAnalizaUart1` | `PERIOD_ANALIZA_UART1` | 1 | `Serial.h:21` | 1,024 ms |
| `taskAplicacion` | `PERIOD_APLICACION` | 10 | `Aplicacion.h:22` | 10,24 ms |
| `taskAlarm` | `PERIOD_ALARM` | 10 | `Alarma.h:33` | 10,24 ms |
| `taskBuzzer` | `PERIOD_BUZZER` | 10 | `Buzzer.h:22` | 10,24 ms |
| `taskCluster` | `PERIOD_CLUSTER` | 10 | `Cluster.h:13` | 10,24 ms |

Cada variable `ulCntPeriodX` se define en el `.c` de su módulo (`LedLive.c:31`, `Serial.c:82`,
`Aplicacion.c:52`, `Alarma.c:36`, `Buzzer.c:15`, `Cluster.c:26`) y se declara `extern` en
`main.c:30-35` para que la ISR pueda tocarlas.

### 4.5 El reset a los 60000 ticks: por qué existe y qué pasa en el wrap

En la ISR de Timer0, `main.c:57-73`:

```c
//si hay un minuto de tiks!!
if(++ulCntTick1ms >= 60000)
{
    ulCntTick1ms = 0;

    ulCntPeriodLedLive = 0;
    ulCntPeriodAplicacion = 0;
    ulCntPeriodAlarm = 0;
    ulCntPeriodBuzzer = 0;
    ulCntPeriodAnaUart1 = 0;
    ulCntPeriodCluster = 0;
}
```

**Por qué existe.** `getMillis()` devuelve un contador que se reinicia a 0 cada 60000 ticks. Si solo
se reiniciara el contador y no los vencimientos, ocurriría lo siguiente: una tarea que a t=59 995
calcula `ulCntPeriodX = 59 995 + 10 = 60 005` se quedaría esperando `getMillis() >= 60005`, cosa
que no puede pasar nunca porque el contador vuelve a 0 en 60 000. La tarea quedaría bloqueada para
siempre. Poner a cero los seis vencimientos en el mismo instante en que se reinicia el contador
convierte la condición en `getMillis() >= 0`, que es trivialmente cierta, y todas las tareas se
desbloquean en la siguiente pasada.

Es decir: es un **manejo manual del wrap-around**, resuelto por fuerza bruta. La forma limpia sería
dejar que el contador desborde de forma natural en 2^32 y comparar por diferencia con signo
(`(long)(getMillis() - deadline) >= 0`), lo que elimina el reinicio y su ventana de carrera.

**Qué pasa exactamente en el instante del wrap.**

1. Las seis tareas se vuelven simultáneamente elegibles. En la siguiente vuelta del `while(1)` de
   `main.c:132-140` las seis ejecutan una iteración de su máquina de estados, una detrás de otra.
2. Una tarea que estuviera a mitad de su periodo ve ese periodo **truncado**. Por ejemplo, si la
   tarea del cluster acababa de programar un vencimiento a +10 ms y el wrap ocurre 2 ms después,
   ese ciclo dura 2 ms en lugar de 10. Los contadores por ciclo (`cl.uiCnt`, `ucCntTimeBuzzer`,
   `uiCntLedLive`, `ala.uiCnt`, `ap.uiCntVolt`) avanzan un paso "gratis".
3. El efecto acumulado: **una vez cada 61,44 s todos los temporizados por conteo de ciclos
   adelantan hasta un periodo completo (≤10 ms).** Sobre un parpadeo de 2 s o una ráfaga de 1 s es
   jitter irrelevante. Sobre `ap.uiCntVolt` (6000 ciclos = 60 s) supone que la lectura de tensión
   se dispara ligeramente antes de lo nominal.
4. La ISR escribe seis `unsigned long` en cada wrap. En un PIC18 eso son 24 escrituras de byte
   dentro de la interrupción, alargándola. No es crítico porque solo ocurre una vez cada 61 s.

**Y hay una carrera real** entre esos ceros y la asignación de las tareas: ver
[D08](#d08--carrera-entre-el-reset-del-wrap-y-la-asignación-del-vencimiento).

### 4.6 La ISR de alta prioridad

`main.c:45-86`. Atiende dos fuentes:

**Timer0** (`main.c:50-75`): recarga `TMR0 = 0xFFEC`, limpia `T0IF` e incrementa el tick.
Obsérvese que la recarga se hace **antes** de limpiar el flag (`main.c:53` y `main.c:55`), lo cual
es correcto.

**Recepción UART** (`main.c:77-85`):

```c
if(PIR1bits.RCIF)
{
    ch = UART_read();
    receiverUart1(&ch);
    serial1.flagRx = true;
    anaT1.uiCnt = 0;
}
```

`UART_read()` (`UART.h:44-61`) limpia la condición de overrun (`OERR`) si se ha producido, lo cual
es imprescindible porque el `CREN` se bloquea al desbordarse. `receiverUart1()` (`Serial.c:74-77`)
mete el byte en `serial1.bufferRx` **sin comprobar el límite** — ver
[D05](#d05--receiveruart1-escribe-en-el-buffer-sin-comprobar-el-límite).

`anaT1.uiCnt = 0` reinicia el contador de silencio: es el mecanismo de detección de fin de trama
(ver [§6.3](#63-troceado-de-la-trama-detección-de-fin-por-silencio)).

### 4.7 La ISR de baja prioridad

`main.c:92-101`:

```c
void __interrupt(low_priority) INT_ISR_LOW (void)
{
    if(INTCON3bits.INT1IE == 1 && INTCON3bits.INT1IF == 1)
    {
         printf("INICIO INTERRUPCION INT1\r\n");
         __delay_ms(4000);
         printf("FIN INTERRUPCION INT1\r\n");
         INTCON3bits.INT1IF = 0;
    }
}
```

`INT1IE` **no se habilita en ningún punto del firmware** (única aparición: `main.c:94`), así que
este cuerpo nunca se ejecuta. Pero se compila, y arrastra `printf` y su cadena de llamadas al
contexto de interrupción. Ver [D12](#d12--isr-de-baja-prioridad-con-printf-y-un-retardo-de-4-segundos).

`RCONbits.IPEN = 1` en `main.c:152` habilita el esquema de prioridades; `GIEH` y `GIEL` se activan
en `main.c:153-154`. Con `IPEN=1`, el bit `INTCONbits.GIE` **es** `GIEH`, dato relevante para
entender [D11](#d11--eepromwrite-reactiva-gie-de-forma-incondicional).

---
