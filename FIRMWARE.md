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

## 5. Máquina de estados de cada tarea

Los `enum` de estados **no tienen inicializador**, así que el primer miembro vale 0 y las variables
de estado globales (`stateAp`, `stateAlarm`, `stateAnaTrama1`, `stateCluster`, `stateBuzzer`,
`state_ledLive`) arrancan en 0 por estar en `.bss`. Por eso todas las tareas parten del primer
estado declarado.

**Ninguno de los seis `switch` tiene rama `default:`** — ver [D16](#d16--ningún-switch-de-estados-tiene-rama-default).

### 5.1 Tarea Aplicación — `Aplicacion.c:56-240`

Enum en `Aplicacion.h:173-181`. Estado inicial: `ST_ARRANQUE_AP`.

Usa un patrón auxiliar de "primera entrada al estado": `cambiarEstado()` (`Aplicacion.c:266-270`)
pone `ap.uiStatePrevious = 0xffff` y cambia el estado; `inicioEstado(s)` (`Aplicacion.c:255-263`)
devuelve `true` solo la primera vez que se evalúa dentro de ese estado. De ahí que estados como
`ST_READ_VOLT_AP` tarden dos ciclos (uno para actuar, otro para transitar).

```mermaid
stateDiagram-v2
    [*] --> ST_ARRANQUE_AP

    ST_ARRANQUE_AP --> ST_READ_MEMO_AP : ++uiCntAplicacion >= 500 (5,12 s) / flagArranque=true, twoBeep() [Aplicacion.c:69-79]

    ST_READ_MEMO_AP --> ST_READ_MEMO_AP : ucInitMemory != 0x06 / inicializa 36 celdas EEPROM + twoBeep() [Aplicacion.c:94-139]
    ST_READ_MEMO_AP --> ST_ESPERA_AP : ucInitMemory == 0x06 / readMemoriaValues(), ala.flagUpdate=true, banner UART [Aplicacion.c:141-152]

    ST_ESPERA_AP --> ST_ESPERA_AP : flagEventoRead / oneBeep() + readDevide() [Aplicacion.c:172-177]
    ST_ESPERA_AP --> ST_ESPERA_AP : flagEventReloj / oneBeep() [Aplicacion.c:178-182]
    ST_ESPERA_AP --> ST_ESPERA_AP : flagEventalarm / readMemoriaValues() + ala.flagUpdate [Aplicacion.c:183-189]
    ST_ESPERA_AP --> ST_ESPERA_AP : sin evento / cl.flagEvento = ap.flagAlarm [Aplicacion.c:197-204]
    ST_ESPERA_AP --> ST_READ_VOLT_AP : ++uiCntVolt >= 6000 (~61 s) [Aplicacion.c:190-194]

    ST_READ_VOLT_AP --> ST_ESPERA_AP : 2do ciclo (1ro fVolt = ADC_read(1)) [Aplicacion.c:209-221]

    ST_READ_TEMP_AP --> ST_ESPERA_AP : 2do ciclo (1ro fTemp = ADC_read(3)) [Aplicacion.c:225-235]

    note right of ST_READ_TEMP_AP
        INALCANZABLE: nadie llama
        cambiarEstado(ST_READ_TEMP_AP).
        Ver D23
    end note

    note right of ST_PRUEBA_AP
        Cuerpo VACIO y sin transicion
        (Aplicacion.c:159-162).
        Inalcanzable hoy; si se entrara,
        la tarea se congela. Ver D16
    end note
```

**Detalle importante de `ST_ESPERA_AP`:** todas las condiciones están encadenadas con `else if`
(`Aplicacion.c:172-204`). Consecuencias:

- Si llega un evento serie en ese ciclo, `++ap.uiCntVolt` **no se evalúa** y `cl.flagEvento`
  **no se actualiza** ese ciclo. Como los eventos son esporádicos, no llega a notarse.
- La asignación `cl.flagEvento = true/false` (`Aplicacion.c:197-204`) es el único puente entre la
  lógica de alarmas y el actuador. Se reevalúa cada 10,24 ms.

### 5.2 Tarea Alarma — `Alarma.c:40-561`

Enum en `Alarma.h:71-90`. Estado inicial: `ST_ARRANQUE_ALA`.

```mermaid
stateDiagram-v2
    [*] --> ST_ARRANQUE_ALA

    ST_ARRANQUE_ALA --> ST_ESPERA_ALA : ap.flagArranque / leerRTC(...) [Alarma.c:52-55]

    ST_ESPERA_ALA --> ST_UPDATE_SEG_ALA : ++uiCnt>=50 y rtc.seg != 0 [Alarma.c:105-112]
    ST_ESPERA_ALA --> ST_UPDATE_VALUE_ALA : ++uiCnt>=50 y rtc.seg == 0 [Alarma.c:113-116]
    ST_ESPERA_ALA --> ST_CHECK_ALL_ALA : uiCnt<50 y ++uiCnt2>=20 [Alarma.c:118-122]
    ST_ESPERA_ALA --> ST_UPDATE_ALA : uiCnt<50 y uiCnt2<20 y ala.flagUpdate [Alarma.c:123-127]

    ST_UPDATE_SEG_ALA --> ST_ESPERA_ALA : leerRtcSeg(and rtc.seg) [Alarma.c:191-194]
    ST_UPDATE_VALUE_ALA --> ST_ESPERA_ALA : leerRTC (hora completa) [Alarma.c:196-199]
    ST_UPDATE_ALA --> ST_ESPERA_ALA : copia memo hacia ala1..ala5 [Alarma.c:59-102]

    ST_CHECK_ALL_ALA --> ST_CHECK_ALARM1 : ++ucCntCheck==1 y ala1.flagAlarm
    ST_CHECK_ALL_ALA --> ST_CHECK_ALARM2 : ucCntCheck==2 y ala2.flagAlarm
    ST_CHECK_ALL_ALA --> ST_CHECK_ALARM3 : ucCntCheck==3 y ala3.flagAlarm
    ST_CHECK_ALL_ALA --> ST_CHECK_ALARM4 : ucCntCheck==4 y ala4.flagAlarm
    ST_CHECK_ALL_ALA --> ST_CHECK_ALARM5 : ucCntCheck==5 y ala5.flagAlarm (ucCntCheck=0)
    ST_CHECK_ALL_ALA --> ST_ESPERA_ALA : la alarma N esta deshabilitada [Alarma.c:130-188]

    ST_CHECK_ALARM1 --> ST_CHECK_HOUR1 : !flagDayAlar y (dayAlar==8 o (==9 y LUN..VIE) o (==10 y SAB/DOM))
    ST_CHECK_ALARM1 --> ST_ESPERA_ALA : el dia no coincide o dayAlar invalido
    ST_CHECK_ALARM1 --> ST_CHECK_ALARM1 : flagDayAlar == true / RAMA VACIA SIN TRANSICION [Alarma.c:241-245]

    ST_CHECK_HOUR1 --> ST_ESPERA_ALA : hor==hourInit y min==minInit -> ap.flagAlarm=true ; hor==hourEnd y min==minEnd -> ap.flagAlarm=false [Alarma.c:421-447]

    note right of ST_CHECK_ALARM1
        ST_CHECK_ALARM2..5 (Alarma.c:249-419)
        y ST_CHECK_HOUR2..5 (Alarma.c:450-557)
        son copias literales con otro indice.
        Las cinco tienen la misma rama vacia.
        Ver D03
    end note
```

**Cadencia real de `ST_ESPERA_ALA`.** El código es (`Alarma.c:104-128`):

```c
case ST_ESPERA_ALA:
    if(++ala.uiCnt >= 50)          { ala.uiCnt = RST;  /* refresco de RTC */ }
    else if(++ala.uiCnt2 >= 20)    { ala.uiCnt2 = RST; stateAlarm = ST_CHECK_ALL_ALA; }
    else if(ala.flagUpdate)        { /* ... */ }
```

Traza de una ronda completa (cada visita = 10,24 ms):

| Visita | `uiCnt` | `uiCnt2` | Acción |
|---|---|---|---|
| 1…19 | 1…19 | 1…19 | nada |
| **20** | 20 | 20→0 | → `ST_CHECK_ALL_ALA` (≈205 ms) |
| 21…39 | 21…39 | 1…19 | nada |
| **40** | 40 | 20→0 | → `ST_CHECK_ALL_ALA` |
| 41…49 | 41…49 | 1…9 | nada |
| **50** | 50→0 | **9 (no incrementa)** | → refresco de RTC (≈530 ms) |
| 51… | 1… | 10,11,… | llega a 20 tras 11 visitas más |

- **`uiCnt2` no se incrementa en la visita en la que `uiCnt` llega a 50.** Es el efecto lateral en
  el `else if` que hay que analizar: ver [D19](#d19--efecto-lateral-de-uicnt2-dentro-de-un-else-if).
  El resultado no es un fallo funcional, pero desincroniza las dos cadencias y hace que el intervalo
  entre comprobaciones oscile entre 20 y 11 visitas.
- **Además, `uiCnt` y `uiCnt2` no cuentan mientras la máquina está fuera de `ST_ESPERA_ALA`.** Cada
  excursión a `ST_CHECK_ALL_ALA → ST_CHECK_ALARMn → ST_CHECK_HOURn` consume 3 ciclos que no
  aparecen en el conteo. Por eso el refresco de RTC nominal de 50 × 10,24 ms = 512 ms se convierte
  en la práctica en unos **560–590 ms**.
- Esto importa porque el minuto solo se actualiza cuando se lee `rtc.seg == 0`, y **para no perder
  ningún minuto hace falta muestrear los segundos al menos una vez por segundo**. Con 560–590 ms hay
  margen, pero es un margen del 40 %: si alguien añade una alarma más, alarga la lectura I2C o
  aumenta `PERIOD_ALARM`, el firmware empezará a saltarse minutos en silencio. Ver
  [D07](#d07--comparación-de-alarmas-por-igualdad-exacta-de-hora-y-minuto).
- **`ST_CHECK_ALL_ALA` evalúa una sola alarma por visita**, en round-robin con `ala.ucCntCheck`
  (`Alarma.c:131-188`). Cada alarma concreta se revisa una de cada cinco veces, es decir
  aproximadamente **una vez por segundo**. Suficiente para una resolución de un minuto.

### 5.3 Tarea Serial / AnalizaUart1 — `Serial.c:90-427`

Enum en `Serial.h:86-93`. Estado inicial: `ST_ARRANQUE_ANA1`. Periodo 1,024 ms.

```mermaid
stateDiagram-v2
    [*] --> ST_ARRANQUE_ANA1

    ST_ARRANQUE_ANA1 --> ST_ESPERA_ANA1 : ap.flagArranque / limpia bufferRx, ucCntRX=0, flagRx=false [Serial.c:102-111]

    ST_ESPERA_ANA1 --> ST_INIT_FRAME_ANA1 : serial1.flagRx y ++anaT1.uiCnt >= 5 (~5 ms sin bytes) / copia filtrando los 0x00 [Serial.c:114-143]

    ST_INIT_FRAME_ANA1 --> ST_ANALYSIS_ANA1 : strstr(bufferRx, INIT_FRAME) != NULL [Serial.c:148-151]
    ST_INIT_FRAME_ANA1 --> ST_ESPERA_ANA1 : sin delimitador de inicio [Serial.c:152-155]

    ST_ANALYSIS_ANA1 --> ST_ESPERA_ANA1 : contiene L / flagEventoRead = true [Serial.c:160-164]
    ST_ANALYSIS_ANA1 --> ST_ESPERA_ANA1 : contiene R / extrae hora y calendario, escribirRTC(), flagEventReloj=true [Serial.c:166-179]
    ST_ANALYSIS_ANA1 --> ST_WAIT_ANA1 : contiene A y E / ucNumAlarm, ucEncAlarm, y si E=1 extrae I, F, D [Serial.c:181-211]
    ST_ANALYSIS_ANA1 --> ST_ESPERA_ANA1 : contiene A pero no E [Serial.c:212-215]
    ST_ANALYSIS_ANA1 --> ST_ESPERA_ANA1 : ningun identificador reconocido [Serial.c:217-220]

    ST_WAIT_ANA1 --> ST_ESPERA_ANA1 : escribe ala1..ala5 y EEPROM / flagEventalarm = true [Serial.c:224-418]
```

**Orden de evaluación en `ST_ANALYSIS_ANA1`.** Se comprueba `"L"` primero (`Serial.c:160`), luego
`"R"` (`Serial.c:166`) y por último `"A"` (`Serial.c:181`). Como las tramas reales no contienen
letras cruzadas (`¿A3,E1,I0830,F1745,D9,?` no tiene ni `L` ni `R`), el orden funciona. Pero si dos
tramas llegan pegadas en la misma ráfaga, gana la primera de la lista y la otra se descarta sin
aviso: ver [D31](#d31--dos-tramas-en-la-misma-ráfaga-la-segunda-se-pierde).

### 5.4 Tarea Cluster — `Cluster.c:29-98`

Enum en `Cluster.h:26-33`. Estado inicial: `ST_ARRANQUE_CL`. Periodo 10,24 ms.

```mermaid
stateDiagram-v2
    [*] --> ST_ARRANQUE_CL

    ST_ARRANQUE_CL --> ST_ESPERA_CL : ap.flagArranque [Cluster.c:39-42]

    ST_ESPERA_CL --> ST_HIGH_CL : cl.flagEvento / ON_CLUSTER (LATC2=1) + oneBeep() [Cluster.c:46-51]
    ST_ESPERA_CL --> ST_ESPERA_CL : !cl.flagEvento / OFF_CLUSTER (LATC2=0) [Cluster.c:52-55]

    ST_HIGH_CL --> ST_LOW_CL : ++uiCnt >= 5 (~51 ms) / OFF_CLUSTER [Cluster.c:60-65]

    ST_LOW_CL --> ST_HIGH_CL : ++uiCnt>=5 y ++itera < 5 / ON_CLUSTER [Cluster.c:69-82]
    ST_LOW_CL --> ST_LOW_SLOW_CL : ++uiCnt>=5 y ++itera >= 5 / itera=0, queda apagado [Cluster.c:73-77]

    ST_LOW_SLOW_CL --> ST_ESPERA_CL : ++uiCnt >= 50 (~512 ms) / cl.flagEvento = false [Cluster.c:87-93]
```

**Patrón resultante.** Cinco destellos de ~51 ms encendido / ~51 ms apagado (≈512 ms en total),
seguidos de una pausa larga de ~512 ms. Ciclo completo ≈ **1,024 s**.

**Y se repite indefinidamente mientras la alarma esté activa**, porque `Cluster.c:91` pone
`cl.flagEvento = false` pero `Aplicacion.c:199` lo vuelve a poner a `true` en menos de 10,24 ms si
`ap.flagAlarm` sigue levantada. Es decir: `cl.flagEvento = false` de `Cluster.c:91` es efímero por
diseño y sirve solo para que la ráfaga vuelva a arrancar desde `ST_ESPERA_CL`.

**Efecto colateral grave:** `oneBeep()` en `Cluster.c:49` se ejecuta al inicio de **cada** ráfaga.
El zumbador suena ~51 ms **una vez por segundo durante toda la franja horaria**, que puede durar
horas. Ver [D14](#d14--el-zumbador-pita-una-vez-por-segundo-durante-toda-la-franja).

### 5.5 Tarea Buzzer — `Buzzer.c:18-119`

Enum en `Buzzer.h:33-40`. Estado inicial: `ST_WAIT_BUZZER`. Periodo 10,24 ms.
El disparo es por variable global `ucTypeBeep` (`Buzzer.c:9`), fijada por `oneBeep()`
(`Buzzer.c:133-137`), `twoBeep()` (`Buzzer.c:138-143`), `alarmBeep()` (`Buzzer.c:144-148`) y
`cancelBeep()` (`Buzzer.c:149-153`).

```mermaid
stateDiagram-v2
    [*] --> ST_WAIT_BUZZER

    ST_WAIT_BUZZER --> ST_ONE_BUZZER : ucTypeBeep == 1 / ON_BUZZER [Buzzer.c:33-37]
    ST_WAIT_BUZZER --> ST_TWO_BUZZER : ucTypeBeep == 2 / ucIteradorBuzzer-- y ON_BUZZER [Buzzer.c:38-43]
    ST_WAIT_BUZZER --> ST_ALARM_BUZZER : ucTypeBeep == 3 / ON_BUZZER [Buzzer.c:44-48]
    ST_WAIT_BUZZER --> ST_WAIT_BUZZER : ucTypeBeep == 0 / OFF_BUZZER, flagStartBuzzer=false [Buzzer.c:49-56]

    ST_ONE_BUZZER --> ST_WAIT_BUZZER : ++ucCntTimeBuzzer >= 5 (~51 ms) / OFF_BUZZER, ucTypeBeep=0 [Buzzer.c:64-70]

    ST_TWO_BUZZER --> ST_WAIT_BUZZER : ++cnt>=5 y ucIteradorBuzzer==0 / OFF_BUZZER, ucTypeBeep=0 [Buzzer.c:81-86]
    ST_TWO_BUZZER --> ST_WAIT_LOW_BUZZER : ++cnt>=5 y ucIteradorBuzzer!=0 / OFF_BUZZER [Buzzer.c:87-91]

    ST_ALARM_BUZZER --> ST_WAIT_LOW_BUZZER : ++cnt >= 5 / OFF_BUZZER [Buzzer.c:99-104]

    ST_WAIT_LOW_BUZZER --> ST_WAIT_BUZZER : ++cnt >= 5 [Buzzer.c:110-114]
```

**`twoBeep()` verificado:** `ucIteradorBuzzer = 2` (`Buzzer.c:141`) → primera entrada decrementa a
1, pita, apaga y va a `ST_WAIT_LOW_BUZZER`; vuelve a `ST_WAIT_BUZZER` con `ucTypeBeep` todavía a 2
→ decrementa a 0, pita, y esta vez sí cancela. **Dos pitidos.** Correcto.

**`alarmBeep()` no se llama desde ningún sitio** y no tiene condición de salida propia: entraría en
un ciclo `ST_ALARM_BUZZER ↔ ST_WAIT_LOW_BUZZER` indefinido hasta que alguien llamara a
`cancelBeep()`, que **tampoco se llama desde ningún sitio**. Igual que `endBeep()`
(`Buzzer.c:155-158`). Ver [D39](#d39--funciones-y-variables-muertas).

### 5.6 Tarea LedLive — `LedLive.c:35-89`

Enum en `LedLive.h:36-41`. Estado inicial: `ST_ARRANQUE_LED`. Periodo 10,24 ms.
Nótese que la lógica del LED está **invertida** (`LedLive.h:26-27`): `ON_LED_LIVE` escribe
`LATA0 = 0` y `OFF_LED_LIVE` escribe `LATA0 = 1`, lo que implica que el LED va conectado del pin a
Vcc a través de `R1 = 330R`.

```mermaid
stateDiagram-v2
    [*] --> ST_ARRANQUE_LED

    ST_ARRANQUE_LED --> ST_ARRANQUE_LED : !ap.flagArranque / ON_LED_LIVE (fijo encendido) [LedLive.c:46-50]
    ST_ARRANQUE_LED --> ST_HIGH_LED : ap.flagArranque [LedLive.c:47-50]

    ST_HIGH_LED --> ST_HIGH_LED : !flagInitStLed / flagInitStLed=true, ON_LED_LIVE [LedLive.c:54-58]
    ST_HIGH_LED --> ST_LOW_LED : ++uiCntLedLive >= 5 (~51 ms) / reset contador y flagInitStLed [LedLive.c:61-66]

    ST_LOW_LED --> ST_LOW_LED : !flagInitStLed / flagInitStLed=true, OFF_LED_LIVE [LedLive.c:71-75]
    ST_LOW_LED --> ST_HIGH_LED : ++uiCntLedLive >= 195 (~2,0 s) [LedLive.c:78-83]
```

Resultado: destello corto de ~51 ms cada ~2,05 s. **Durante los primeros 5,12 s tras el arranque
el LED queda fijo encendido** (`LedLive.c:46`), lo que sirve de indicador visual de que el equipo
está en `ST_ARRANQUE_AP`.

---

## 6. Protocolo serie / Bluetooth

Enlace físico: UART del PIC (RC6/RC7) contra un módulo Bluetooth **HC-06** en modo SPP
(`U2 = HC06_Module` en el esquemático). Parámetros: **8N1, ~9469,7 baud nominales 9600**
(ver [§2.3](#23-uart-verificación-de-spbrg-contra-la-fórmula-del-datasheet)).

La app Android que genera las tramas está en
`D:\@Proyect\Baliza\1 Firmware\Doc Aplicativo Movil\BalizaV10\app\src\main\java\com\example\balizav10\MainActivity2.java`.

### 6.1 Identificadores y delimitadores

Definidos en `Serial.h:27-37`:

| Macro | Valor en el fuente | Byte real | Uso | Línea |
|---|---|---|---|---|
| `INIT_FRAME` | (carácter no ASCII) | **`0xBF`** | Delimitador de inicio de trama | `Serial.h:27` |
| `END_FRAME` | `"?"` | `0x3F` | Delimitador de fin de trama | `Serial.h:28` |
| `ID_NUM_ALARM` | `"A"` | `0x41` | Número de alarma (1..5) | `Serial.h:29` |
| `ID_ENC_ALARM` | `"E"` | `0x45` | Enable (0 = apagada, 1 = encendida) | `Serial.h:30` |
| `ID_INIT_ALARM` | `"I"` | `0x49` | Hora de inicio, formato `HHMM` | `Serial.h:31` |
| `ID_END_ALARM` | `"F"` | `0x46` | Hora de fin, formato `HHMM` | `Serial.h:32` |
| `ID_DAY_ALARM` | `"D"` | `0x44` | Código de días (8, 9 o 10) | `Serial.h:33` |
| `ID_RELOJ` | `"R"` | `0x52` | Puesta en hora, formato `HHMM` | `Serial.h:34` |
| `ID_CALENDAR` | `"C"` | `0x43` | Calendario, formato `DDMMYY-U` | `Serial.h:35` |
| `ID_COMA` | `","` | `0x2C` | Separador de campos | `Serial.h:36` |
| `ID_READ_DEV` | `"L"` | `0x4C` | Petición de volcado del dispositivo | `Serial.h:37` |

### 6.2 El byte exacto de `INIT_FRAME` (investigación)

En `Serial.h:27` el literal aparece corrupto en cualquier editor que asuma UTF-8. El volcado
hexadecimal del fichero resuelve la duda:

```
$ sed -n '27,28p' Serial.h | xxd
00000000: 2364 6566 696e 6520 494e 4954 5f46 5241  #define INIT_FRA
00000010: 4d45 2020 2020 2020 22bf 220a 2364 6566  ME      ".".#def
00000020: 696e 6520 454e 445f 4652 414d 4520 2020  ine END_FRAME
00000030: 2020 2020 223f 220a                          "?".
```

- **`INIT_FRAME` es la cadena de un solo byte `0xBF`** (`22 bf 22` = `"` `0xBF` `"`).
  El fichero `Serial.h` está guardado en **CP1252 / ISO-8859-1**, donde `0xBF` es el carácter
  `¿` (signo de interrogación de apertura).
- **`END_FRAME` es `0x3F`**, el `?` ASCII normal. Sin sorpresa.

Contraste con lo que envía la app Android. En `MainActivity2.java:182`, `:208`, `:214` y `:408`
las tramas se construyen con el carácter `¿`. El fichero Java está en **UTF-8**:

```
$ sed -n '182p;208p;214p' MainActivity2.java | xxd
00000020: 22c2 bf52 222b 2053 7472 696e 672e 7661  "..R"+ String.va
00000080: 7346 7261 6d65 436f 6e66 203d 2022 c2bf  sFrameConf = "..
000000f0: 7261 6d65 436f 6e66 203d 2022 c2bf 4122  rameConf = "..A"
```

`c2 bf` es la codificación UTF-8 de U+00BF (`¿`). El canal de salida se abre en
`MainActivity2.java:419` como:

```java
PrintWriter out = new PrintWriter(new BufferedWriter(new OutputStreamWriter(socket.getOutputStream())), true);
```

`OutputStreamWriter` sin charset explícito usa `Charset.defaultCharset()`, que en Android **siempre
es UTF-8**. Por tanto, **por el cable viajan dos bytes: `0xC2 0xBF`**, mientras que el firmware
busca uno solo, `0xBF`.

**¿Funciona?** Sí, por casualidad. `strstr(anaT1.bufferRx, INIT_FRAME)` en `Serial.c:148` busca la
subcadena de un byte `0xBF` y la encuentra en la **segunda** posición de la secuencia UTF-8. El
`0xC2` sobrante queda al principio del buffer sin molestar a nadie porque ningún identificador es
`0xC2` y el análisis posterior usa `strstr` sobre el resto de la cadena.

> **Riesgos.** (a) Si alguien reabre `Serial.h` en un editor con UTF-8 y lo guarda, el byte `0xBF`
> puede convertirse en el carácter de sustitución U+FFFD (`EF BF BD`) y el firmware dejaría de
> reconocer tramas. (b) Si la app se porta a otra plataforma cuyo charset por defecto sea
> ISO-8859-1, enviaría un único `0xBF` — que también funcionaría, pero por otro camino.
> (c) Cualquier byte `0xBF` de basura en la línea abre una trama falsa.
> **Recomendación:** cambiar `Serial.h:27` a un carácter ASCII imprimible e inequívoco,
> por ejemplo `#define INIT_FRAME "#"`, y `MainActivity2.java` en consecuencia. Es un cambio de
> dos líneas en cada lado. Ver [D29](#d29--delimitador-de-inicio-no-ascii-y-dependiente-de-la-codificación).

### 6.3 Troceado de la trama: detección de fin por silencio

No hay máquina de estados de recepción byte a byte. El mecanismo es:

1. La ISR (`main.c:77-85`) mete cada byte recibido en `serial1.bufferRx` mediante
   `receiverUart1()` (`Serial.c:74-77`), levanta `serial1.flagRx` y **pone `anaT1.uiCnt = 0`**.
2. La tarea `taskAnalizaUart1` corre cada 1,024 ms. Mientras `serial1.flagRx` esté levantada,
   incrementa `anaT1.uiCnt` (`Serial.c:118`). Si llega otro byte, la ISR lo vuelve a poner a cero.
3. Cuando pasan **5 ciclos sin recibir nada** (`++anaT1.uiCnt >= 5`, es decir ≈5,1 ms) se da la
   trama por terminada.

A 9600 baud un byte tarda ~1,04 ms, así que 5,1 ms equivale a unos 5 tiempos de byte. Es un umbral
razonable para SPP, pero no está garantizado: si el enlace Bluetooth introduce una pausa de más de
5 ms en mitad de una trama (retransmisión, congestión del canal), la trama se parte en dos, y la
primera mitad —que sí contiene `INIT_FRAME`— se analiza con delimitadores ausentes.
Ver [D04](#d04--desbordamiento-de-buffer-en-extraervalue-y-extraerframe).

4. Al cerrar la trama, `Serial.c:122-137` copia `serial1.bufferRx` a `anaT1.bufferRx`
   **filtrando los bytes `0x00`**:

```c
char x = 0;
for(char i = 0; i <= SIZE_BUFFER_RX1; i++)
{
    if(serial1.bufferRx[i] != '\0')
        anaT1.bufferRx[x++] = serial1.bufferRx[i];
}
```

Ese filtro **es imprescindible** y probablemente se añadió por prueba y error, porque la app
Android inyecta bytes nulos en mitad de las tramas (ver [§6.5](#65-el-detalle-de-los-bytes-nulos-que-inyecta-la-app)).
El bucle tiene un off-by-one: `i <= 40` recorre 41 posiciones de un array de 40
(`SIZE_BUFFER_RX1 = 40`, `Serial.h:24`). Ver [D13](#d13--off-by-one-en-el-bucle-de-copia-del-buffer-de-recepción).

### 6.4 Gramática de las tramas

```
trama       ::= 0xBF cuerpo '?'
cuerpo      ::= lectura | reloj | alarma_off | alarma_on

lectura     ::= 'L'
reloj       ::= 'R' HHMM ',' 'C' DDMMYY '-' U
alarma_off  ::= 'A' n ',' 'E' '0' ','
alarma_on   ::= 'A' n ',' 'E' '1' ',' 'I' HHMM ',' 'F' HHMM ',' 'D' d ','

n           ::= '1'..'5'
HHMM        ::= 4 dígitos, hora 00-23 y minuto 00-59
DDMMYY      ::= 6 dígitos
U           ::= '1'..'7'   (1 = lunes … 7 = domingo)
d           ::= '8' | '9' | '10'
```

Todas las tramas de la app terminan además con `\n\r` y el `println()` de Java añade un `\n`
adicional. El firmware **no usa el fin de línea para nada**: le basta con el silencio de 5 ms.

### 6.5 El detalle de los bytes nulos que inyecta la app

En `MainActivity2.java:171-182`:

```java
char bufferHour[]  = new char[6];
char bufferCalen[] = new char[10];
Date.getChars(0,4,  bufferHour, 0);    // rellena solo los índices 0..3
Date.getChars(5,13, bufferCalen, 0);   // rellena solo los índices 0..7
sFrameHourCal = "¿R"+ String.valueOf(bufferHour)+",C"+String.valueOf(bufferCalen)+"?\n\r";
```

`String.valueOf(char[])` convierte **el array entero**, no la parte rellena. Por tanto
`bufferHour` aporta `"2145\0\0"` y `bufferCalen` aporta `"211025-2\0\0"`. La trama que sale por
el aire es:

```
C2 BF 52 32 31 34 35 00 00 2C 43 32 31 31 30 32 35 2D 32 00 00 3F 0A 0D 0A
 ¿  ¿  R  2  1  4  5 \0 \0  ,  C  2  1  1  0  2  5  -  2 \0 \0  ?  \n \r \n
```

y el filtro de `Serial.c:126-132` es lo que la deja utilizable. **Si alguien "arregla" ese filtro
sin entender por qué está ahí, el reloj deja de poder ponerse en hora.**

### 6.6 Ejemplos completos de trama

#### (a) Programar la alarma 3 de 08:30 a 17:45, de lunes a viernes

Texto: `¿A3,E1,I0830,F1745,D9,?\n\r`

Bytes tal como los envía la app Android (UTF-8):

```
C2 BF 41 33 2C 45 31 2C 49 30 38 33 30 2C 46 31 37 34 35 2C 44 39 2C 3F 0A 0D 0A
    ¿   A  3  ,  E  1  ,  I  0  8  3  0  ,  F  1  7  4  5  ,  D  9  ,  ?  \n \r \n
```

Bytes mínimos que acepta el firmware (sin el `C2`, sin fin de línea):

```
BF 41 33 2C 45 31 2C 49 30 38 33 30 2C 46 31 37 34 35 2C 44 39 2C 3F
```

Recorrido por el código:
`Serial.c:148` encuentra `0xBF` → `Serial.c:181` encuentra `"A"` →
`Serial.c:184` `extraerValue(bufferRx,"A",",")` → `ucNumAlarm = 3` →
`Serial.c:186` encuentra `"E"` → `Serial.c:189` `ucEncAlarm = 1` →
`Serial.c:199-200` `extraerFrame(...,"I",",")` = `"0830"` → `horaInit=8, minInit=30` →
`Serial.c:202-203` `extraerFrame(...,"F",",")` = `"1745"` → `horaEnd=17, minEnd=45` →
`Serial.c:205-207` `extraerFrame(...,"D",",")` = `"9"` → `ulDayAlarm = 9` →
`ST_WAIT_ANA1` `Serial.c:326-355` escribe `ala3` y las 7 celdas de EEPROM 0x0F–0x15.

> **Obsérvese la coma final obligatoria antes del `?`.** `extraerFrame` para el campo `D` busca
> `ID_COMA` como terminador (`Serial.c:205`), no `END_FRAME`. Si se omite esa coma —por ejemplo
> escribiendo `...,D9?`— el bucle de `Serial.c:486-489` sigue leyendo memoria hasta encontrar por
> casualidad un byte `,`, desbordando `buffer[10]`. La app siempre la pone
> (`MainActivity2.java:208`: `"...,D"+sAlarmD+",?\n\r"`), pero cualquier cliente hecho a mano que
> la omita provoca corrupción de pila.

#### (b) Apagar la alarma 2

Texto: `¿A2,E0,?\n\r`

```
C2 BF 41 32 2C 45 30 2C 3F 0A 0D 0A
```

Recorrido: `Serial.c:184` → `ucNumAlarm = 2`; `Serial.c:189` → `ucEncAlarm = 0`;
`Serial.c:192-195` salta a `ST_WAIT_ANA1` sin extraer horas; `Serial.c:233-237` pone
`ala2.flagAlarm = false` y `EEpromWrite(ADDRESS_EN_ALA2, 0)`.

> Nótese que **solo se escribe la celda de enable (0x08)**; las horas y días de la alarma 2 quedan
> en la EEPROM tal como estaban. Al volver a encenderla hay que reenviar todos los campos.

#### (c) Poner en hora — 21:45 del martes 21/10/2025

Texto: `¿R2145,C211025-2?\n\r`

```
BF 52 32 31 34 35 2C 43 32 31 31 30 32 35 2D 32 3F
    R  2  1  4  5  ,  C  2  1  1  0  2  5  -  2  ?
```

(La app real intercala los nulos descritos en [§6.5](#65-el-detalle-de-los-bytes-nulos-que-inyecta-la-app).)

Recorrido: `Serial.c:166` encuentra `"R"` → `Serial.c:168` `extraerFrame(...,"R",",")` = `"2145"`
→ `Serial.c:169` `extraerHora` → `hora=21, min=45` → `Serial.c:171`
`extraerFrame(...,"C","?")` = `"211025-2"` → `Serial.c:172` `extraerCalendar` →
`dia=21, mes=10, ano=25, diaSem=2` → `Serial.c:174`
`escribirRTC(21,45,0,21,10,25,2)`.

Verificación del recorrido de punteros de `extraerCalendar` (`Serial.c:521-560`) sobre `"211025-2"`:
`'2','1'`→21; `'1','0'`→10; `'2','5'`→25; `Serial.c:549` salta el `'-'`; `'2'`→2. Correcto.

**Los segundos se fuerzan a 0** (`Serial.c:174`, tercer argumento). Efecto secundario útil: al
escribir `0x00` en el registro 0x00 del DS1307 se limpia el bit CH (Clock Halt) y el oscilador
arranca. Efecto secundario malo: un equipo recién fabricado tiene el RTC **parado** hasta que
alguien le pone la hora por primera vez, porque el firmware nunca limpia CH en el arranque.
Ver [D28](#d28--el-bit-ch-del-ds1307-nunca-se-limpia-en-el-arranque).

**El día de la semana** viene de `SimpleDateFormat("HHmm ddMMyy-u")` (`MainActivity2.java:177`).
El patrón `u` de Java es el día ISO: 1 = lunes … 7 = domingo, que coincide exactamente con
`LUNE..DOMI` de `Alarma.h:13-19` y con `Dias_semana` de `DS1307.h:19-28`. ✅

#### (d) Pedir volcado del dispositivo

Texto: `¿L?\n\r` (`MainActivity2.java:408`)

```
C2 BF 4C 3F 0A 0D 0A
```

Recorrido: `Serial.c:160` encuentra `"L"` → `serial1.flagEventoRead = true` →
`Aplicacion.c:172-177` hace `oneBeep()` y llama a `readDevide()`.

### 6.7 Formato de la RESPUESTA generada por `readDevide()`

`Aplicacion.c:285-334`. Envía **9 cadenas independientes** mediante `transmitUart1()`, cada una
formateada con `sprintf` sobre `ap.bufferTx[45]`:

| # | Línea | Formato | Origen |
|---|---|---|---|
| 1 | Hora actual | `"%d:%d:%d\n\r"` | `rtc.hor, rtc.min, rtc.seg` — `Aplicacion.c:292` |
| 2 | Fecha | `"%d/%d/%d-%d\n\r\n\r\n\r"` | `rtc.day, rtc.month, rtc.year, rtc.dayWeek` — `Aplicacion.c:296` |
| 3 | Cabecera | `"No -    Ini    -   Fin    - On - Dias \n\r\n\r"` | literal — `Aplicacion.c:300` |
| 4–8 | Alarmas 1..5 | `" %d   - %d:%d   - %d:%d  - %s - %s\n\r"` | `memo.*` — `Aplicacion.c:306, 312, 318, 324, 330` |

Los dos campos `%s` los rellenan dos funciones auxiliares:

- `convOnOff()` (`Aplicacion.c:345-351`): `"ON"` si el enable es distinto de 0, `"OFF"` si es 0.
- `convStringDayWeek()` (`Aplicacion.c:336-343`): `8 → "Dia"`, `9 → "LV"`, **cualquier otro valor
  → `"SD"`**. Es decir, un valor corrupto de EEPROM se muestra como fin de semana sin avisar, y el
  caso "personalizado" no tiene representación.

**Ejemplo de respuesta real** (hora 21:45:03, martes 21/10/2025, solo la alarma 3 programada
de 08:30 a 17:45 de lunes a viernes):

```
21:45:3
21/10/25-2


No -    Ini    -   Fin    - On - Dias

 1   - 0:0   - 0:0  - OFF - Dia
 2   - 0:0   - 0:0  - OFF - Dia
 3   - 8:30   - 17:45  - ON - LV
 4   - 0:0   - 0:0  - OFF - Dia
 5   - 0:0   - 0:0  - OFF - Dia

```

Detalles que hay que conocer al escribir un cliente que parsee esta respuesta:

1. **`%d` no rellena con ceros**: sale `21:45:3` y no `21:45:03`; sale `8:30` y no `08:30`. Las
   columnas no quedan alineadas y el ancho de cada campo es variable. Cualquier parser tiene que
   ser tolerante.
2. **Cada cadena lleva un byte `0x00` de más al final.** `transmitUart1()` en `Serial.c:61` usa
   `for(int x = 0; x <= ucCntTx1 ; x++)` con `ucCntTx1 = strlen(bufferTx1)`, de modo que la última
   iteración transmite el terminador nulo. Ver [D20](#d20--transmituart1-envía-un-byte-nulo-de-más-en-cada-cadena).
3. **El volcado no incluye la tensión ni la temperatura** medidas en `ST_READ_VOLT_AP` /
   `ST_READ_TEMP_AP`. `ap.fVolt` y `ap.fTemp` se calculan y no se usan nunca.
   Ver [D23](#d23--medidas-de-tensión-y-temperatura-calculadas-y-nunca-usadas).
4. **No hay respuesta ni confirmación para las tramas de configuración de alarma ni de reloj.** El
   único acuse es un pitido del zumbador (`Aplicacion.c:175`, `:181`, `:188`). La app no puede saber
   si el comando llegó. Ver [D30](#d30--no-hay-acuse-de-recibo-de-la-configuración).
5. `readDevide()` imprime `memo.*`, es decir lo que hay en EEPROM, no las estructuras vivas
   `ala1..ala5`. En operación normal coinciden porque `Serial.c` escribe ambas, pero divergirían si
   una escritura de EEPROM fallara.

---

## 7. Modelo de datos en EEPROM

La EEPROM interna de datos del PIC18F2550 (256 bytes, `0xF00000`–`0xF000FF` en el mapa del
enlazador) guarda la configuración de las cinco alarmas. Se usan **36 bytes**, de `0x00` a `0x23`.
Las direcciones están definidas como macros en `Aplicacion.h:40-102`.

### 7.1 Mapa dirección por dirección

| Dir. | `#define` | Línea | Qué guarda | Rango válido | Valor tras inicialización |
|---|---|---|---|---|---|
| `0x00` | `ADDRESS_INIT_EEPROM` | `Aplicacion.h:41` | Marca de "memoria inicializada" | `0x06` (`INIT_VALUE_EEPROM`) | `0x06` |
| `0x01` | `ADDRESS_EN_ALA1` | `Aplicacion.h:44` | Alarma 1 habilitada | 0 / 1 | `0` |
| `0x02` | `ADDRESS_FLAGDAYALA1` | `Aplicacion.h:45` | Alarma 1 con días personalizados | 0 / 1 | `0` |
| `0x03` | `ADDRESS_DAYWEEK1` | `Aplicacion.h:46` | Alarma 1: código de días | 1..10 | `8` (diario) |
| `0x04` | `ADDRESS_INIT_HOUR1` | `Aplicacion.h:48` | Alarma 1: hora de inicio | 0..23 | `0` |
| `0x05` | `ADDRESS_INIT_MIN1` | `Aplicacion.h:49` | Alarma 1: minuto de inicio | 0..59 | `0` |
| `0x06` | `ADDRESS_END_HOUR1` | `Aplicacion.h:51` | Alarma 1: hora de fin | 0..23 | `0` |
| `0x07` | `ADDRESS_END_MIN1` | `Aplicacion.h:52` | Alarma 1: minuto de fin | 0..59 | `0` |
| `0x08` | `ADDRESS_EN_ALA2` | `Aplicacion.h:55` | Alarma 2 habilitada | 0 / 1 | `0` |
| `0x09` | `ADDRESS_FLAGDAYALA2` | `Aplicacion.h:56` | Alarma 2 días personalizados | 0 / 1 | `0` |
| `0x0A` | `ADDRESS_DAYWEEK2` | `Aplicacion.h:57` | Alarma 2: código de días | 1..10 | `8` |
| `0x0B` | `ADDRESS_INIT_HOUR2` | `Aplicacion.h:59` | Alarma 2: hora de inicio | 0..23 | `0` |
| `0x0C` | `ADDRESS_INIT_MIN2` | `Aplicacion.h:60` | Alarma 2: minuto de inicio | 0..59 | `0` |
| `0x0D` | `ADDRESS_END_HOUR2` | `Aplicacion.h:62` | Alarma 2: hora de fin | 0..23 | `0` |
| `0x0E` | `ADDRESS_END_MIN2` | `Aplicacion.h:63` | Alarma 2: minuto de fin | 0..59 | `0` |
| `0x0F` | `ADDRESS_EN_ALA3` | `Aplicacion.h:68` | Alarma 3 habilitada | 0 / 1 | `0` |
| `0x10` | `ADDRESS_FLAGDAYALA3` | `Aplicacion.h:69` | Alarma 3 días personalizados | 0 / 1 | `0` |
| `0x11` | `ADDRESS_DAYWEEK3` | `Aplicacion.h:70` | Alarma 3: código de días | 1..10 | `8` |
| `0x12` | `ADDRESS_INIT_HOUR3` | `Aplicacion.h:72` | Alarma 3: hora de inicio | 0..23 | `0` |
| `0x13` | `ADDRESS_INIT_MIN3` | `Aplicacion.h:73` | Alarma 3: minuto de inicio | 0..59 | `0` |
| `0x14` | `ADDRESS_END_HOUR3` | `Aplicacion.h:75` | Alarma 3: hora de fin | 0..23 | `0` |
| `0x15` | `ADDRESS_END_MIN3` | `Aplicacion.h:76` | Alarma 3: minuto de fin | 0..59 | `0` |
| `0x16` | `ADDRESS_EN_ALA4` | `Aplicacion.h:81` | Alarma 4 habilitada | 0 / 1 | `0` |
| `0x17` | `ADDRESS_FLAGDAYALA4` | `Aplicacion.h:82` | Alarma 4 días personalizados | 0 / 1 | `0` |
| `0x18` | `ADDRESS_DAYWEEK4` | `Aplicacion.h:83` | Alarma 4: código de días | 1..10 | `8` |
| `0x19` | `ADDRESS_INIT_HOUR4` | `Aplicacion.h:85` | Alarma 4: hora de inicio | 0..23 | `0` |
| `0x1A` | `ADDRESS_INIT_MIN4` | `Aplicacion.h:86` | Alarma 4: minuto de inicio | 0..59 | `0` |
| `0x1B` | `ADDRESS_END_HOUR4` | `Aplicacion.h:88` | Alarma 4: hora de fin | 0..23 | `0` |
| `0x1C` | `ADDRESS_END_MIN4` | `Aplicacion.h:89` | Alarma 4: minuto de fin | 0..59 | `0` |
| `0x1D` | `ADDRESS_EN_ALA5` | `Aplicacion.h:94` | Alarma 5 habilitada | 0 / 1 | `0` |
| `0x1E` | `ADDRESS_FLAGDAYALA5` | `Aplicacion.h:95` | Alarma 5 días personalizados | 0 / 1 | `0` |
| `0x1F` | `ADDRESS_DAYWEEK5` | `Aplicacion.h:96` | Alarma 5: código de días | 1..10 | `8` |
| `0x20` | `ADDRESS_INIT_HOUR5` | `Aplicacion.h:98` | Alarma 5: hora de inicio | 0..23 | `0` |
| `0x21` | `ADDRESS_INIT_MIN5` | `Aplicacion.h:99` | Alarma 5: minuto de inicio | 0..59 | `0` |
| `0x22` | `ADDRESS_END_HOUR5` | `Aplicacion.h:101` | Alarma 5: hora de fin | 0..23 | `0` |
| `0x23` | `ADDRESS_END_MIN5` | `Aplicacion.h:102` | Alarma 5: minuto de fin | 0..59 | `0` |
| `0x24`–`0xFF` | — | — | Sin usar | — | `0xFF` (borrado) |

**El bloque de cada alarma ocupa 7 bytes y arranca en `0x01 + 7×(N−1)`.** Esa regularidad es
justo lo que permitiría sustituir las 60 líneas de `#define` de `Aplicacion.h:43-102` por una
macro de dos líneas. Ver [D34](#d34--código-duplicado-cinco-veces-en-tres-ficheros).

### 7.2 `INIT_VALUE_EEPROM 0x06` — la marca de memoria inicializada

`Aplicacion.h:40`:

```c
#define INIT_VALUE_EEPROM       0X06
```

El mecanismo está en `ST_READ_MEMO_AP` (`Aplicacion.c:83-157`):

```c
memo.ucInitMemory = EEpromRead(ADDRESS_INIT_EEPROM);   // Aplicacion.c:92

if(memo.ucInitMemory != INIT_VALUE_EEPROM)             // Aplicacion.c:94
{
    EEpromWrite(ADDRESS_INIT_EEPROM, INIT_VALUE_EEPROM);
    twoBeep();
    // ... 35 escrituras más, Aplicacion.c:99-137 ...
    cambiarEstado(ST_READ_MEMO_AP);                    // Aplicacion.c:139 — se relee
}
else
{
    readMemoriaValues();                               // Aplicacion.c:144
    ala.flagUpdate = true;
    transmitUart1("\n\rBALIZA ALARMA V1.0\n\r\n\r");
    cambiarEstado(ST_ESPERA_AP);                       // Aplicacion.c:152
}
```

**Qué hace.** Es un "número mágico" de formateo. Un PIC virgen tiene la EEPROM a `0xFF`, que es
distinto de `0x06`, así que la primera vez el firmware escribe los valores por defecto de las cinco
alarmas (todas deshabilitadas, días = 8 = diario, horas a 00:00) y marca la celda `0x00` con `0x06`.
En los arranques siguientes la marca coincide y se lee la configuración guardada.

Después de inicializar, `Aplicacion.c:139` vuelve a entrar en `ST_READ_MEMO_AP`, lo que reinicia
el contador de 200 ciclos (`Aplicacion.c:90`) y en la segunda pasada, ya con la marca correcta,
cae por la rama `else`. El usuario oye **dos series de dos pitidos** (`Aplicacion.c:78` en el
arranque y `Aplicacion.c:97` al formatear) la primera vez que enciende un equipo nuevo, y solo una
serie en los arranques posteriores. Es el único indicio externo de que se ha formateado la memoria.

**Qué pasa si se cambia `INIT_VALUE_EEPROM`.** Es el mecanismo de migración de datos del firmware:
al cambiar el valor (por ejemplo a `0x07`), el siguiente arranque de un equipo ya en campo detecta
que la marca no coincide y **borra toda la configuración de alarmas del usuario**, dejándola en los
valores por defecto. Es la forma de forzar un reformateo cuando se cambia la disposición de la
EEPROM en una versión nueva. **Hay que hacerlo obligatoriamente si se añaden campos o se mueven
direcciones**, o el equipo interpretará datos viejos con el mapa nuevo.

> **Debilidad:** con solo un byte de marca, la probabilidad de que una EEPROM de un chip reutilizado
> (o corrompida por un brown-out) contenga por casualidad `0x06` en la dirección `0x00` es de
> 1/256. En ese caso el firmware **no formatea** y arranca con las 35 celdas restantes a basura.
> Un valor de basura en `ADDRESS_FLAGDAYALAn` dispara el defecto
> [D03](#d03--las-ramas-de-días-personalizados-están-vacías-y-congelan-la-máquina-de-estados).
> Una marca de 2 o 4 bytes, o un checksum de los 36 bytes, eliminaría el riesgo.

### 7.3 Codificación de los días

Definida en `Alarma.h:13-23`:

| Valor | Macro | Significado | ¿Implementado? |
|---|---|---|---|
| 1 | `LUNE` | Lunes | Solo como valor de `rtc.dayWeek`, no como selección de alarma |
| 2 | `MART` | Martes | idem |
| 3 | `MIER` | Miércoles | idem |
| 4 | `JUEV` | Jueves | idem |
| 5 | `VIER` | Viernes | idem |
| 6 | `SABA` | Sábado | idem |
| 7 | `DOMI` | Domingo | idem |
| **8** | `DIAR` | **Diariamente** | ✅ `Alarma.c:205-208` |
| **9** | `SEMA` | **Lunes a viernes** | ✅ `Alarma.c:210-221` |
| **10** | `FINS` | **Fin de semana** (sábado y domingo) | ✅ `Alarma.c:223-234` |

**Los valores 1..7 son días concretos y NO están implementados como selección de alarma.** El
diseño previsto era:

- `flagDayAlar = 0` → el campo `dayAlar` contiene 8, 9 o 10 (un "grupo" de días).
- `flagDayAlar = 1` → alarma "personalizada": los días individuales estarían en
  `srtAlarmas.bufferDayAlar[8]` (`Alarma.h:59`, comentario *"1,2,3,4,5,6,7"*).

Pero `bufferDayAlar` **no se escribe ni se lee en ningún punto del firmware** (única aparición:
`Alarma.h:59`), no hay dirección de EEPROM reservada para él, y las ramas que lo usarían están
vacías tanto en `Serial.c` (`:289-292`, `:320-323`, `:350-353`, `:380-383`, `:409-412`) como en
`Alarma.c` (`:241-245`, `:286-289`, `:329-332`, `:372-375`, `:415-418`).

La app Android tampoco ofrece la opción: su selector solo tiene tres entradas
(`MainActivity2.java:101`: `{"Diario", "Lun-Vie", "Sab-Dom"}`) mapeadas a 8, 9 y 10 en
`MainActivity2.java:203-205`. Y `Serial.c:274` solo acepta valores en el rango
`(ulDayAlarm > 7) && (ulDayAlarm < 11)`, o sea 8, 9 y 10; cualquier otro cae en el `else` vacío y
**no se escribe nada en EEPROM**, con lo que la alarma queda con `flagAlarm = true` en RAM pero sin
respaldo persistente — un estado incoherente que desaparece en el siguiente arranque.

En resumen: **la personalización por días concretos está diseñada a medias y es código muerto
peligroso**, no una funcionalidad disponible.

### 7.4 Cómo se escribe y cómo se lee

**Escritura** — `EEpromWrite()`, `EEprom.c:8-26`. Se llama desde dos sitios:
`Aplicacion.c:96-137` (formateo inicial, 36 escrituras seguidas) y `Serial.c:231-407` (al
configurar una alarma, 1 o 7 escrituras). Cada escritura de EEPROM del PIC18 tarda unos 4 ms y la
función espera activamente (`EEprom.c:23`), así que un formateo completo bloquea la tarea de
aplicación **unos 150 ms**. Ver [D11](#d11--eepromwrite-reactiva-gie-de-forma-incondicional).

**Lectura** — `EEpromRead()`, `EEprom.c:29-38`:

```c
EEADR = address;
EECON1bits.EEPGD = 0;
EECON1bits.CFGS = 0;
EECON1bits.RD = 1;
return EEDATA;
```

Puede llamar la atención que devuelva `EEDATA` inmediatamente sin esperar. **Es correcto**: el
datasheet del PIC18F2550 (sección de EEPROM de datos) especifica que la lectura de EEPROM de datos
se completa en un ciclo y que `EEDATA` es válido en la instrucción siguiente a poner `RD = 1`; el
propio ejemplo en ensamblador del fabricante hace `BSF EECON1, RD` seguido de `MOVF EEDATA, W`.
Solo las lecturas de **memoria de programa** (`EEPGD = 1`) requieren dos `NOP`. No es un defecto.

`readMemoriaValues()` (`Aplicacion.c:353-409`) hace **35 lecturas** consecutivas y se invoca tanto
en el arranque (`Aplicacion.c:144`) como cada vez que llega una trama de alarma
(`Aplicacion.c:186`), lo que es aceptable dado el coste despreciable de la lectura.

---

## 8. Lógica de alarmas

### 8.1 Cadena completa: del RTC al cluster

```mermaid
flowchart TD
    A["DS1307 por I2C<br/>leerRTC / leerRtcSeg<br/>DS1307.c:19-58"] --> B["struct rtc<br/>hor, min, seg, dayWeek<br/>DS1307.c:9"]
    C["EEPROM 0x00-0x23"] --> D["readMemoriaValues<br/>Aplicacion.c:353-409"]
    D --> E["struct memo<br/>Aplicacion.c:46"]
    E -->|"ala.flagUpdate<br/>ST_UPDATE_ALA<br/>Alarma.c:59-102"| F["ala1..ala5<br/>srtAlarmas<br/>Alarma.c:24-28"]
    B --> G["ST_CHECK_ALARMn<br/>filtro por dia<br/>Alarma.c:201-419"]
    F --> G
    G --> H["ST_CHECK_HOURn<br/>comparacion hora:minuto<br/>Alarma.c:421-557"]
    H -->|"hor==hourInit y min==minInit"| I["ap.flagAlarm = true"]
    H -->|"hor==hourEnd y min==minEnd"| J["ap.flagAlarm = false"]
    I --> K["ST_ESPERA_AP<br/>Aplicacion.c:197-204"]
    J --> K
    K --> L["cl.flagEvento"]
    L --> M["taskCluster<br/>rafaga de 5 destellos<br/>Cluster.c:45-93"]
    M --> N["LATC2 -> Q2 -> lampara"]
    M --> O["oneBeep -> LATC0"]
```

### 8.2 Paso 1 — De la EEPROM a `ala1..ala5`

`ST_UPDATE_ALA` (`Alarma.c:59-102`) copia los 35 campos de `memo` a las cinco estructuras
`srtAlarmas`. Se dispara con `ala.flagUpdate`, que se levanta en dos sitios:

- `Aplicacion.c:145`, tras leer la EEPROM en el arranque.
- `Aplicacion.c:187`, tras recibir una trama de configuración de alarma.

La transición ocurre en `Alarma.c:123-127`, pero **solo si en esa visita a `ST_ESPERA_ALA` no se
han cumplido antes las condiciones de `uiCnt >= 50` ni `uiCnt2 >= 20`**, por estar en la misma
cadena `else if`. Como esas condiciones fallan 18 de cada 20 visitas, la actualización llega en
menos de 30 ms. No es un problema, pero es una dependencia sutil.

### 8.3 Paso 2 — Filtro por día: `ST_CHECK_ALARMn`

Para la alarma 1 (`Alarma.c:201-246`; las otras cuatro son copias literales):

```c
if(!ala1.flagDayAlar)                       // Alarma.c:203 — días NO personalizados
{
    if(ala1.dayAlar == DIAR)                // == 8  → siempre
        stateAlarm = ST_CHECK_HOUR1;
    else if(ala1.dayAlar == SEMA)           // == 9  → lunes a viernes
        stateAlarm = (rtc.dayWeek >= LUNE && rtc.dayWeek <= VIER)
                     ? ST_CHECK_HOUR1 : ST_ESPERA_ALA;
    else if(ala1.dayAlar == FINS)           // == 10 → sábado o domingo
        stateAlarm = (rtc.dayWeek == SABA || rtc.dayWeek == DOMI)
                     ? ST_CHECK_HOUR1 : ST_ESPERA_ALA;
    else
        stateAlarm = ST_ESPERA_ALA;         // Alarma.c:235-238 — valor inválido
}
else
{
    // Alarma.c:241-245 — VACÍO, sin asignación de estado
}
```

La rama `else` final (`Alarma.c:235-238`) sí protege contra un `dayAlar` corrupto. **La rama de
días personalizados (`Alarma.c:241-245`) no protege nada: no asigna estado.** Es el defecto
[D03](#d03--las-ramas-de-días-personalizados-están-vacías-y-congelan-la-máquina-de-estados).

### 8.4 Paso 3 — Comparación horaria: `ST_CHECK_HOURn`

`Alarma.c:421-447` para la alarma 1 (las otras cuatro, idénticas):

```c
if(rtc.hor == ala1.hourInit)
    if(rtc.min == ala1.minInit)
        ap.flagAlarm = true;      // Alarma.c:429

if(rtc.hor == ala1.hourEnd)
    if(rtc.min == ala1.minEnd)
        ap.flagAlarm = false;     // Alarma.c:440

stateAlarm = ST_ESPERA_ALA;       // Alarma.c:445
```

Cuatro observaciones estructurales:

1. **Es una comparación por igualdad exacta, no por pertenencia a un intervalo.** El firmware no
   pregunta "¿estoy dentro de la franja?" sino "¿es este el minuto exacto en que empieza / acaba?".
   Es un detector de flanco, no un comparador de rango. Consecuencias en
   [D07](#d07--comparación-de-alarmas-por-igualdad-exacta-de-hora-y-minuto).
2. **Los dos `if` son independientes, no `else if`.** Si el inicio y el fin son el mismo minuto,
   ambos se ejecutan en la misma pasada y gana el segundo: la alarma queda apagada. Una franja de
   longitud cero se comporta correctamente por accidente.
3. **`ap.flagAlarm` es un único bit compartido por las cinco alarmas** (`Aplicacion.h:115`). No hay
   estado por alarma. Ver [D06](#d06--flagalarm-es-una-única-bandera-para-las-cinco-alarmas).
4. **Ninguna alarma "recuerda" que está activa.** El estado activo vive exclusivamente en
   `ap.flagAlarm`, que no se guarda en EEPROM ni se reconstruye a partir del reloj.

### 8.5 Paso 4 — De `ap.flagAlarm` a `cl.flagEvento`

`ST_ESPERA_AP`, `Aplicacion.c:197-204`:

```c
else if(ap.flagAlarm)
{
    cl.flagEvento = true;
}
else
{
    cl.flagEvento = false;
}
```

Se evalúa cada 10,24 ms. Es una copia continua, no un flanco: mientras `ap.flagAlarm` esté
levantada, `cl.flagEvento` se vuelve a poner a `true` inmediatamente después de que la tarea del
cluster lo baje en `Cluster.c:91`, lo que hace que las ráfagas se encadenen sin fin.

Recuérdese que está en la misma cadena `else if` que los tres eventos serie y que el contador de
tensión (`Aplicacion.c:172-194`): en el ciclo en que se atiende un evento serie o se lanza una
lectura de tensión, `cl.flagEvento` no se refresca. Al ser un ciclo aislado de 10 ms y estar el
cluster en mitad de una ráfaga, no se aprecia.

### 8.6 Paso 5 — El patrón del cluster

Detallado en [§5.4](#54-tarea-cluster--clusterc29-98). Resumen del comportamiento observable
cuando `ap.flagAlarm` está levantada:

| Tramo | Duración | `LATC2` | Buzzer |
|---|---|---|---|
| Destello 1 | ~51 ms ON + ~51 ms OFF | conmuta | pitido de ~51 ms al inicio de la ráfaga |
| Destellos 2..5 | 4 × (~51 ms ON + ~51 ms OFF) | conmuta | — |
| Pausa larga | ~512 ms | OFF | — |
| **Ciclo completo** | **~1,024 s** | | **1 pitido por ciclo** |

Y este ciclo se repite **durante toda la franja horaria**. En una franja de 08:30 a 17:45 son
9 h 15 min = **unos 33 300 ciclos**, es decir 33 300 pitidos y 166 500 destellos.
Ver [D14](#d14--el-zumbador-pita-una-vez-por-segundo-durante-toda-la-franja).

### 8.7 Qué pasa al terminar la franja

Cuando `ST_CHECK_HOURn` detecta el minuto de fin, `ap.flagAlarm` baja, `Aplicacion.c:203` pone
`cl.flagEvento = false` y la tarea del cluster apaga la salida **en cuanto vuelva a
`ST_ESPERA_CL`** (`Cluster.c:54`). Si en ese instante estaba a mitad de una ráfaga, **termina la
ráfaga en curso** (hasta ~1 s más) antes de apagarse definitivamente. Es un retardo aceptable.

---
