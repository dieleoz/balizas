# Baliza SR30 — Diagnóstico del Bluetooth, y cómo probarlo

> ## ✅ ACTUALIZACIÓN 21-ago-2026: **el SIG0109A funciona. No había avería de módulo.**
>
> Este documento se escribió para encontrar una avería de Bluetooth que **resultó no existir**.
> Se conserva entero porque su procedimiento de prueba sigue siendo la forma correcta de aislar
> un fallo serie, y porque sus datos verificados (baudios, tramas, pinouts, niveles) siguen
> siendo válidos. Pero léelo sabiendo el final:
>
> Desde «Serial Bluetooth Terminal», con el **SIG0109A** montado en la tarjeta, se envió `¿L?` y
> volvió el **volcado legible**. El módulo empareja, conecta, transporta bytes **en los dos
> sentidos**, y sus **9600 8N1 de fábrica son correctos**. El `.hex` y el DS1307 también quedan
> demostrados de paso.
>
> **La causa real del *«no lo reconoce»*** era una de las tres de §4: buscarlo en la lista como
> «HC-06» cuando se anuncia con otro nombre, no haberlo emparejado antes desde los **ajustes**
> del teléfono, o la **Ubicación** apagada. Nunca fue el módulo, ni el pinout, ni los baudios.
>
> **Lo único de este documento que pasa a ser urgente es §4 causa 8:** el `RXD` de 3,3 V del
> módulo está atacado con **5 V sin adaptación**. Ese es el fallo que probablemente mató al
> HC-06, y está corriendo ya contra este módulo. **Resistencia de 1 kΩ en serie en `MCU_TX`.**

**Equipo:** señal vial «30 CUANDO ACTIVADA», zona escolar. La luz titila → el límite de 30 km/h está vigente.
**Horario impreso en la chapa:** 6:00–9:00 · 11:30–13:30 · 15:00–16:30.
**Controlador:** PIC18F2550 @ 20 MHz · `D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza_ V1.X\`
**Tarjeta:** `BALIZA_SR30` rev V1.0 — documentada en `D:\@Proyect\Baliza\HARDWARE.md`
**Fecha:** 21-ago-2026 · redactado tras la reunión con el cliente de ese día.

> **Premisa de trabajo:** la tarjeta **ya está fabricada y es fija**. Aquí no se propone rediseñar la placa. Lo que el hardware limita se enuncia como **restricción** y se trabaja alrededor.
>
> **Por qué esto es crítico:** el Bluetooth es el **único** camino para programar los horarios. Si no empareja, el equipo no se puede configurar en campo. No hay teclado, no hay display, no hay otro puerto de usuario.

---

## 0. Lo primero: NO es el .hex

El cliente sospecha que el `.hex` está «compilado para otro Bluetooth». **No lo está, y no puede estarlo.**

El firmware no sabe qué módulo Bluetooth hay al otro lado. Lo único que ve es el periférico EUSART del PIC: dos pines, `RC6` (TX) y `RC7` (RX), y un flujo de bytes. Toda la inicialización del puerto está en cinco líneas:

```c
// UART.h:26-38  — UART_init_baud()
TXSTAbits.BRGH = 0;
TXSTAbits.SYNC = 0;     // asíncrono
TXSTAbits.TX9  = 0;     // 8 bits
SPBRG = 32;             // divisor del generador de baudios
RCSTAbits.SPEN = 1;  TXSTAbits.TXEN = 1;  RCSTAbits.CREN = 1;
```

No hay una sola referencia a «HC-06», ni a un comando `AT`, ni a una secuencia de inicialización del módulo, ni a un pin de control del módulo, en **todo** el proyecto. El módulo Bluetooth es, para el PIC, **un cable serie transparente**. Da exactamente igual si al otro lado hay un HC-06, un HC-05, un SIG0109A, un adaptador USB-TTL o un cable cruzado a un PC: mientras los bytes lleguen a 9600 baudios 8N1, el firmware funciona.

**Consecuencia práctica:** recompilar el firmware, reprogramar el PIC o buscar «otra versión del .hex» **no va a arreglar nada**. Es tiempo perdido. El problema está en el módulo, en su configuración, en el emparejamiento del teléfono o en la app — nunca en «para qué Bluetooth está compilado el .hex».

**La única cosa del firmware que sí importa** es el número de la sección siguiente: **9600 baudios, y no es negociable.**

---

## 1. El número que manda: 9600 baudios, 8N1 — verificado

El PIC tiene la velocidad **fija en el código**. No la negocia, no la autodetecta, no la cambia nunca.

**Evidencia:**

| Dato | Valor | Fuente |
|---|---|---|
| Oscilador | Cristal 20 MHz, modo HS | `main.h:17` (`#pragma config FOSC = HS`), `main.h:76` (`_XTAL_FREQ 20000000`), `Y1 = 20M` en `balizaSR30.kicad_sch:11582` |
| Función que se ejecuta | `UART_init_baud(9600)` | `main.c:117` |
| `BRGH` | 0 (baja velocidad) | `UART.h:26` |
| `BRG16` (BAUDCON) | 0 — **nunca se escribe**, queda en su valor de reset | ausencia en todo el proyecto; PIC18F2550 DS39632E §20.1 |
| `SPBRG` | 32 | `UART.h:34` |
| Bits de datos | 8 (`TX9 = 0`) | `UART.h:32` |
| Paridad | ninguna (el EUSART del PIC18 no tiene generador de paridad) | PIC18F2550 DS39632E §20 |
| Bits de parada | 1 (fijo por hardware) | PIC18F2550 DS39632E §20 |

### 1.1 La cuenta, hecha con la fórmula del datasheet

PIC18F2550, hoja de datos **DS39632E, Tabla 20-1 «Baud Rate Formulas»**. Para `SYNC = 0` (asíncrono), `BRG16 = 0`, `BRGH = 0`:

```
Baudios = FOSC / ( 64 · (n + 1) )        con n = SPBRG
```

Sustituyendo `FOSC = 20 000 000` y `n = 32`:

```
Baudios = 20 000 000 / ( 64 · (32 + 1) )
        = 20 000 000 / ( 64 · 33 )
        = 20 000 000 / 2 112
        = 9 469,70 baudios
```

**Error frente a 9600:**

```
error = (9 469,70 − 9 600) / 9 600 × 100 = −1,357 %
```

### 1.2 ¿Es tolerable ese −1,36 %?

Sí, con margen. En una trama 8N1 el receptor engancha el flanco de bajada del bit de start y muestrea el bit de stop **9,5 tiempos de bit** después. Para que ese último muestreo caiga todavía dentro de su celda, la deriva acumulada entre los dos extremos debe ser menor de **±5 %** en el límite teórico, y por buena práctica se exige **menos de ±3 % sumando los dos extremos**.

- Extremo PIC: **−1,36 %**.
- Extremo módulo: desconocido, pero un módulo con cristal de 16 MHz y divisor entero típicamente queda por debajo de ±0,2 %.
- **Suma ≈ −1,5 %.** Sobra margen.

**Comprobación de que 32 es el mejor valor posible con `BRGH = 0`:** `n = 31` daría `20e6/(64·32) = 9765,6 bd` (+1,73 %), peor. Así que el valor elegido es el óptimo de su familia y coincide con la tabla de la hoja de datos de Microchip.

### 1.3 Detalle: hay una segunda función de inicialización, más exacta, que NO se usa

`UART.h:6-18` define `UART_init()` con `BRGH = 1` y `SPBRG = 129`:

```
Baudios = 20 000 000 / ( 16 · (129 + 1) ) = 20 000 000 / 2 080 = 9 615,38 bd  →  +0,16 %
```

Diez veces más exacta. Pero **`main.c:117` llama a `UART_init_baud(9600)`, no a `UART_init()`**, así que la que corre es la de −1,36 %. No es un problema (§1.2), pero conviene saberlo: si algún día apareciera un módulo con un reloj muy desviado, cambiar la llamada de `main.c:117` a `UART_init()` recupera 1,2 puntos de margen sin tocar nada más. **Hoy no hace falta.**

### 1.4 Y ojo con el argumento

`UART_init_baud(const long int baudRate)` **ignora su propio argumento**. El `9600` que se le pasa en `main.c:117` no se usa: `SPBRG` está escrito a pelo con `32` en `UART.h:34`, y la línea que lo calcularía está comentada (`UART.h:35`). Cambiar el `9600` de `main.c` no cambia la velocidad. Si alguna vez hay que cambiarla de verdad, se cambia `SPBRG` en `UART.h:34`.

> ### 🔴 Regla de oro
> **El módulo Bluetooth tiene que estar a 9600 baudios, 8 bits, sin paridad, 1 bit de stop.**
> Si está a 38400, a 115200 o a cualquier otra velocidad, **no hay nada que hacer**: emparejará perfectamente, la app se conectará, y sólo saldrá basura o nada. Esta es la primera cosa a comprobar y la que más veces explica «no funciona».

---

## 2. Las DOS averías distintas que se están confundiendo en una

Esta es la sección más útil del documento. «No lo reconoce» son **dos síntomas completamente distintos**, con causas distintas y arreglos distintos. Hasta ahora se están tocando todas las variables a la vez, y por eso no se avanza.

```
        ┌─────────────────────────────────────────────────────┐
        │  AVERÍA A — el móvil NO VE el módulo                 │
        │  Capas implicadas: alimentación · módulo · Android   │
        │  El PIC NO PINTA NADA. La app NO PINTA NADA.        │
        │  Los baudios NO PINTAN NADA.                         │
        └─────────────────────────────────────────────────────┘
                              ↓ (una vez emparejado)
        ┌─────────────────────────────────────────────────────┐
        │  AVERÍA B — empareja, pero no llegan datos          │
        │  Capas implicadas: baudios · TX/RX · niveles ·      │
        │                    permisos de Android · firmware   │
        └─────────────────────────────────────────────────────┘
```

### 2.1 Tabla: síntoma → capa culpable → prueba que lo decide

| # | Lo que se observa | Capa culpable | Lo que NO puede ser | Prueba que lo decide | ⏱ |
|---|---|---|---|---|---|
| A1 | El LED del módulo **no enciende** al dar tensión | Alimentación o módulo muerto | Nada del PIC, la app ni los baudios | **Prueba 0**, paso 3: medir 5 V entre VCC y GND del zócalo | 2 min |
| A2 | LED enciende/parpadea, pero el móvil **no lo encuentra** en la búsqueda de Bluetooth | Módulo (rol, visibilidad) o Android (ubicación/permisos del sistema) | Nada del PIC ni de la app | **Prueba 0**, pasos 5-6: buscar desde los ajustes del teléfono, con la ubicación encendida | 3 min |
| A3 | El móvil **lo encuentra pero falla el emparejamiento** («PIN incorrecto», «no se pudo emparejar») | PIN del módulo | Nada más | Probar `1234`, luego `0000` | 2 min |
| A4 | Empareja bien desde los ajustes, pero **no sale en la lista de la app** | **App**: sólo lista dispositivos **ya emparejados** (`MainActivity2.java:280`) | Módulo, PIC, baudios | Verificar que el módulo aparece en «Dispositivos emparejados» de los **ajustes del teléfono**, no en «disponibles» | 1 min |
| A5 | En los ajustes del teléfono no aparece ningún dispositivo nuevo, y el teléfono es Android 12+ | Android: permisos de ubicación / servicio de ubicación apagado | El módulo, si el LED parpadea | Encender la ubicación del teléfono y repetir la búsqueda | 2 min |
| B1 | Conecta, y la app dice **«Connect failed»** | Emparejamiento roto o módulo ocupado con **otro** teléfono | Baudios (aún no se ha hablado) | Apagar el otro teléfono; desemparejar y volver a emparejar | 3 min |
| B2 | Conecta, y llega **texto ilegible / caracteres raros** | **Baudios distintos de 9600** | Módulo muerto, cableado, app | **Prueba 3**: leer el banner `BALIZA ALARMA V1.0` | 5 min |
| B3 | Conecta, y **no llega absolutamente nada** (pantalla en blanco) | Cableado TX/RX, alimentación del PIC, o el PIC no arranca | Baudios (con baudios malos llegaría *algo*) | **Prueba 3**: ¿parpadea el LED de vida `D1` de la tarjeta? | 5 min |
| B4 | El banner **sí sale** legible, pero mandar `L` no devuelve nada | Sentido PIC ← módulo (RXD del módulo, o `MCU_TX` del PIC) | El sentido PIC → móvil, que ya está demostrado | **Prueba 3**, paso 6: enviar `¿L?` como bloque | 5 min |
| B5 | Todo va con un terminal serie, pero **la app no** | App / permisos de Android / `targetSdkVersion` | Módulo, PIC, baudios, cableado | **§5**, y **Prueba 4** | 10 min |

### 2.2 Lo que hay que dejar de hacer

- Dejar de recompilar el firmware (§0).
- Dejar de cambiar el módulo de sitio antes de saber si está vivo (**Prueba 0**).
- Dejar de probar con la app antes de que un terminal serie funcione (**Pruebas 1-3**).
- Dejar de cambiar dos cosas a la vez.

---

## 3. Los tres módulos, comparados

> **Cómo leer esta tabla.** Cada celda lleva una marca de procedencia:
> **[DS]** = hoja de datos o manual del fabricante · **[M]** = lo que se observa habitualmente en el mercado, **no es especificación** · **[?]** = no confirmado, va a §9 «Preguntas abiertas».
>
> Los módulos HC-05 y HC-06 se venden desde hace quince años por decenas de fabricantes distintos sin especificación común. Lo marcado **[M]** es orientación de partida para probar, **no** un dato en el que apoyarse.

**Fuentes primarias usadas en esta tabla:**
- HC-06: *Product Data Sheet*, Guangzhou HC Information Technology (Wavesen), Rev 2.2, 2011-04-06 — <https://www.electronicoscaldas.com/datasheet/HC-06_Wavesen.pdf>
- HC-05: *HC-05 Bluetooth to Serial Port Module*, ITead Studio, 2010-06-18 — <https://components101.com/sites/default/files/component_datasheet/HC-05%20Datasheet.pdf>
- SIG0109A: ficha de producto de Sigma Electrónica — <https://www.sigmaelectronica.net/producto/sig0109a/> — y `BK3231_ARM968E-S.pdf` (hoja del SoC)
- Formato ZS-040 y niveles de E/S: Martyn Currey — <https://www.martyncurrey.com/hc-05-and-hc-06-zs-040-bluetooth-modules-first-look/>

| | **HC-06** (el que funcionaba) | **HC-05** | **SIG0109A** (Sigma Electrónica) |
|---|---|---|---|
| **Chip** | «*Bases at **CSR BC04** Bluetooth technology*» **[DS]**. *(«CSR BC417» es lo que se repite en el mercado, pero **no** aparece en la hoja del fabricante — **[M]**)* | «*It uses **CSR Bluecore 04**-External single chip Bluetooth system*» **[DS]** | **Beken BK3231S** **[DS]** (ficha Sigma) |
| **Firmware** | `LinvorV1.n` (respuesta a `AT+VERSION`) **[DS]** | firmware HC-05 de ITead/Wavesen; `AT+VERSION?` → `+VERSION:2.0-20100601` **[DS]** | firmware propio de Beken, **no compatible** con el de CSR **[DS por implicación]** |
| **Versión Bluetooth** | 2.0 + EDR **[DS]** | **V2.0 + EDR** **[DS]** | **Bluetooth 3.0** **[DS]** (ficha Sigma y `BK3231_ARM968E-S.pdf` p.3) |
| **Perfil** | SPP **[DS]** | SPP **[DS]** | SPP **[DS]** — pero el SoC es de origen **HID**: «*HID v1.0, and other light profile by request*» (`BK3231_ARM968E-S.pdf`, p.3) |
| **Cristal** | 26 MHz **[M]** | 26 MHz **[M]** | **16 MHz** **[DS]** (ficha Sigma; BK3231 datasheet, Tabla 2, `FXTAL`) |
| **Rol** | **Sólo esclavo** — no puede iniciar conexiones **[DS]** (no existe comando de rol) | **Maestro/esclavo/slave-loop**, conmutable: `AT+ROLE=0/1/2` **[DS]** | **[?]** la ficha no lo dice. Si es un JDY-31 (§3.3): **sólo esclavo** **[DS del manual JDY-31]** |
| **Baudios de fábrica (modo datos)** | **9600 N81** — «*Default parameter: Baud rate:9600N81*» **[DS]** | ⚠️ **El manual oficial dice 38400**: «*Default Baud rate: 38400, Data bits:8, Stop bit:1, Parity:No parity*», y `AT+ORGL` restaura «*Baud 38400bits/s*» **[DS]**. Las placas ZS-040 del mercado suelen venir a **9600** en modo datos **[M]**. **Los dos valores circulan: hay que medirlo (Prueba 2)** | **[?]** — la ficha de Sigma **no lo dice**. Si es un JDY-31: **9600** **[DS del manual JDY-31]** |
| **Modo AT** | **No hay modo separado.** «*supply power to the module, it will enter to the AT mode if it needn't pair*» — AT funciona mientras **no** esté emparejado/conectado, a los baudios de trabajo **[DS]** | **Sí, modo separado.** «*1. Connect PIO11 to high level. 2. Power on, module into command state. 3. Using baud rate 38400*» — **PIO11 es el pin KEY/EN** del breakout **[DS]** | **[?]**. Si es un JDY-31: **no hay modo separado**, los AT van por el mismo UART sin conexión activa **[DS del manual JDY-31]** |
| **Juego de comandos AT** | `AT`, `AT+BAUDn`, `AT+NAMEx`, `AT+PINxxxx`, `AT+VERSION`, `AT+PN/PO/PE`. **Sin CR/LF**, con ~1 s entre comandos **[DS]** | `AT+ROLE=`, `AT+UART=`, `AT+NAME=`, `AT+PSWD=`, `AT+ORGL`, `AT+RESET`, `AT+VERSION?`, `AT+ADDR?`, `AT+STATE?`. **Todos terminados en CR+LF** **[DS]** | **Otro juego distinto.** Si es un JDY-31, sólo **9 comandos** y **ninguno** es `AT+ROLE` ni `AT+UART` (§3.3) **[DS del manual JDY-31]** |
| **PIN por defecto** | **`1234`** **[DS]** | ⚠️ **El manual se contradice**: la portada dice «*Auto-pairing PINCODE:"0000" as default*», pero `AT+PSWD` dice «*(Default 1234)*» y `AT+ORGL` restaura «*pin code :1234*» **[DS]**. **Probar `1234` y luego `0000`** | **[?]**. Si es un JDY-31: **`1234`** **[DS del manual JDY-31]** |
| **Nombre por defecto** | **`linvor`** — «*ID: linvor*» **[DS]**. *(Que se anuncie como «HC-06» es un reetiquetado del revendedor — **[M]**)* | `AT+NAME` indica «*(Default :HC-05)*», pero `AT+ORGL` restaura «*device name: **H-C-2010-06-01***» **[DS]** | **[?]**. Si es un JDY-31: **`JDY-31-SPP`** **[DS del manual JDY-31]** |
| **Pines de la placa** | 6, paso 2,54 mm: `STATE · RXD · TXD · GND · VCC · EN/KEY` **[M]** (formato ZS-040 / JY-MCU) | 6, paso 2,54 mm: `STATE · RXD · TXD · GND · VCC · EN/KEY` **[M]** (formato ZS-040) | **[?] — DATO CRÍTICO, y hay una CONTRADICCIÓN documentada. Ver §3.3 y §4 causa 6** |
| **Alimentación** | 3,6–6 V en la placa portadora (lleva LDO de 3,3 V); **el módulo desnudo es de 3,3 V** **[M]** | 3,6–6 V en la placa portadora ZS-040 **[M]** | **3,6–6 V** **[DS]** (ficha Sigma). El SoC BK3231 trabaja a **2,0–3,6 V** (`BK3231_ARM968E-S.pdf`, Tabla 2, `VCC`) → el módulo **lleva regulador interno** |
| **Nivel lógico de RXD** | **3,3 V — NO tolerante a 5 V** **[M]** | **3,3 V — NO tolerante a 5 V**: «*the breakout board adds 5v VCC in compatibility but the RX and TX pins are still 3.3v only*» **[M]** | **[?] oficialmente.** Si es un JDY-31, **tampoco es tolerante a 5 V** **[M]**. El SoC admite `VIH` máx `VCC+0,3 V` con `VCC ≤ 3,6 V` (`BK3231_ARM968E-S.pdf`, Tabla 2) |

### 3.1 Lo que hay que entender del SIG0109A

Sigma Electrónica lo vende literalmente como **«Módulo Bluetooth posible reemplazo del HC-05 y HC-06»** (<https://www.sigmaelectronica.net/producto/sig0109a/>). Nótese el **«posible»**: el propio vendedor no lo garantiza.

**«Reemplazo» no significa «igual».** Es un **clon con otro chip, otro firmware y otro juego de comandos AT**. Los HC-05 y HC-06 llevan un **CSR BlueCore 04**; el SIG0109A lleva un **Beken BK3231S**. La compatibilidad que promete el vendedor es a nivel de **función** (es un puente SPP-a-serie con 6 pines) y presumiblemente de **huella mecánica** — **no** a nivel de comandos AT, ni necesariamente de configuración de fábrica, **ni necesariamente de orden de pines**.

**Todo lo que la ficha de Sigma NO dice** (verificado sobre la página completa): baudios por defecto, PIN de emparejamiento, nombre por defecto, pinout, comandos AT, y **no hay manual del módulo** — el único documento enlazado es el datasheet del SoC (§3.2).

**Traducción práctica:** todo lo que se sepa de configurar un HC-05 por AT **puede no aplicar** a este módulo. Si hay que cambiarle los baudios, hace falta **su** manual, no el del HC-05.

### 3.2 El PDF que tienen NO es el que hace falta — leído y confirmado

El único documento disponible es `D:\@Proyect\Baliza\5 HW bluetooth\BK3231_ARM968E-S.pdf`.

**Qué es realmente:** «BK3231 Bluetooth HID SoC — Datasheet — Preliminary Specification», Beken Corporation, **29 páginas**, fechado **Sep-2014** (metadatos del PDF: creado 2015-07-07, título original `Microsoft Word - Technical Description.doc`).

Es la **hoja de datos del chip pelado**, escrita para quien diseña una placa alrededor del BK3231. **No es el manual del módulo SIG0109A.** Su índice lo dice todo (p. 2):

> 1 General Description · 2 Features · 3 Pin Information · 4 Memory Organization · 5 Interrupt and Clock Unit · 6 MFC · 7 GPIO · 8 ADC · 9 UART · 10 I2C-SMBus · 11 SPI · 12 PWM Timer · 13 Watch dog · 14 Electrical Specifications · 15 Package Information · 16 Application Schematic · 17 Order Information

**Lo que se buscó en él, y NO está — confirmado con búsqueda de texto sobre el PDF completo:**

| Lo que hace falta para configurar el módulo | ¿Está en el PDF? | Comprobación |
|---|---|---|
| **Baudios por defecto** | ❌ **NO** | La única mención a baudios es la fórmula del registro del periférico UART, p. 17: `Baud rate = UART_CLK/(UART_CLK_DIV+1)`, con `UART_CLK_DIV` en `0x0[20:8]`. Eso configura el periférico **desde el firmware del chip**; no dice a qué velocidad arranca un módulo comercial. No aparece «9600», ni «38400», ni «115200» en ninguna página |
| **Comandos AT** | ❌ **NO** | Cero apariciones de «AT+», «AT command» o «command set» en las 29 páginas. Es lógico: los comandos AT los implementa el **firmware del módulo**, no el silicio |
| **Pinout de la placa del módulo** | ❌ **NO** | La sección 3 «Pin Information» describe los encapsulados **QFN 7×7 de 56 pines** y **QFN 4×4 de 32 pines** del chip (pines `VDDPA`, `VDDSPI`, `VDDDSP`, `XTALN`, `RFP`, `VCCRF`…). Nada que ver con los 6 pines de una placa portadora |
| **PIN de emparejamiento** | ❌ **NO** | Cero apariciones de «pairing», «PIN code», «passkey» o «1234» |
| **Nombre Bluetooth por defecto** | ❌ **NO** | — |
| **Perfil SPP garantizado** | ⚠️ **A MEDIAS** | p. 3: «*It integrates … Bluetooth HID profile*» y «*HID v1.0, and other light profile **by request***». El SPP se menciona como posibilidad («*it is also possible for other Bluetooth application such as SPP controller*»), **no** como característica estándar del chip |
| **Alimentación del módulo** | ⚠️ **DEL CHIP, NO DEL MÓDULO** | Tabla 2: `VCC` operativo **2,0 – 3,0 – 3,6 V**. Ese es el **SoC**. La ficha de Sigma dice **3,6–6 V** para el **módulo**, luego el módulo lleva su propio regulador |
| **Tolerancia a 5 V en RXD** | ❌ **NO** | Tabla 2 da `VIH` con máximo `VCC+0,3 V` para los pines del **chip**. Sobre lo que hay en el pin RXD **de la placa** no dice nada |

> **🔴 Esta es la razón exacta por la que están atascados.** Tienen la hoja de datos de un microcontrolador ARM968E-S, y lo que necesitan es una hoja de dos páginas que diga «arranca a X baudios, el PIN es Y, se le habla con estos comandos AT y los pines van en este orden». **Ese documento no lo tienen, y sin él no se puede configurar el módulo a ciegas: hay que medirlo (Prueba 2) o pedírselo a Sigma (§9, pregunta 1).**

---

### 3.3 ⭐ La pista más útil: el SIG0109A es casi seguro un JDY-31 (o «SPP-C»)

Los módulos BK3231S vendidos como reemplazo de HC-05/HC-06 corresponden a la familia comercial **JDY-31 / JDY-30 / «SPP-C»**. La identificación chip↔modelo procede de **terceros**, no de Sigma:

- Martyn Currey: «*The JDY-31 SPP bluetooth module, otherwise known as SPP-C, is a bluetooth slave module based on **BK3231S** Bluetooth SoC by Beken*» — <https://www.martyncurrey.com/jdy-31-spp-bluetooth-module/>
- AdAstra-Soft: JDY-30 = BK3231, **JDY-31 = BK3231S** — <https://adastra-soft.com/some-information-about-the-jdy-31-bluetooth-module/>

**Coincide con el SIG0109A en las tres cosas que Sigma sí publica:** chip BK3231S, Bluetooth 3.0 y alimentación 3,6–6 V. **Pero Sigma no publica el modelo, así que la equivalencia NO está confirmada** (§9, pregunta 1b).

**Si se confirma que es un JDY-31**, existe manual del fabricante — *JDY-31 Bluetooth Backplane User Manual, V1.3, 2019-01-08*, <https://adastra-soft.com/wp-content/uploads/2021/06/JDY-31_manual_2.pdf> — y todo el problema se resuelve. Lo que dice, **[DS]**:

| Dato | Valor según el manual JDY-31 | Qué significa para la baliza |
|---|---|---|
| **Baudios de fábrica** | **9600** | ✅ **Coincide con el PIC.** Si es un JDY-31, los baudios **no son la avería** |
| `AT+BAUD` | parámetro 4–9 → 9600 / 19200 / 38400 / 57600 / 115200 / 128000 | Se puede volver a 9600 con `AT+BAUD4` |
| **PIN por defecto** | **`1234`** | ✅ Es el que hay que probar primero |
| **Nombre por defecto** | **`JDY-31-SPP`** | ⚠️ **No se llama «HC-06».** Buscar «HC-06» y no encontrarlo **no** significa que esté mal |
| **Rol** | **Sólo esclavo** | ✅ **La causa 3 (modo maestro) NO le aplica.** Sólo aplica al HC-05 |
| **Modo AT** | **No hay modo separado.** Mismo UART, con la conexión Bluetooth cerrada | ✅ **No hace falta el pin KEY** — que en esta tarjeta está al aire |
| **Comandos AT** | **Sólo 9**: `AT+VERSION`, `AT+RESET`, `AT+DISC`, `AT+LADDR`, `AT+PIN`, `AT+BAUD`, `AT+NAME`, `AT+DEFAULT`, `AT+ENLOG`. **Terminados en `\r\n`.** Respuestas `+OK` / `+NAME=...` | ❌ **No existe `AT+ROLE` ni `AT+UART`.** Los comandos del HC-05 **no funcionan** |
| `AT+VERSION` | `+VERSION=JDY-31-V1.2,Bluetooth V3.0` | Es la forma de identificarlo con certeza |
| **Alimentación** | «*SMD type: 1,8–3,6 V (3,3 V recomendado); **with backplane: 3,6–6 V (recomendado 5 V)***» | ✅ **Los +5 V del zócalo son correctos** para la placa portadora |
| **Perfil** | Bluetooth 3.0 **SPP** | ✅ Compatible con el UUID `00001101-...` de la app |

**🔴 Y aquí está la contradicción que puede haber quemado el módulo:**

| Fuente | Orden de los 6 pines |
|---|---|
| **Tabla del manual JDY-31** **[DS]** | `STATE · RXD · TXD · GND · VCC · EN` *(con `EN` marcado «Vacant», no operativo)* |
| **Martyn Currey, foto de la placa real** **[M]** | `STATE · TXD · RXD · VCC · GND · EN` |
| **Zócalo de la baliza** (`balizaSR30.kicad_pcb`) | `STATE · RXD · TXD · GND · VCC · EN` |

Las dos fuentes discrepan en **dos permutaciones a la vez**: `RXD`↔`TXD` **y `GND`↔`VCC`**. La segunda es letal: si la placa real lleva el orden que reporta Currey y se inserta en este zócalo, **los +5 V entran por el pin GND del módulo y la masa por su VCC**. Muerte instantánea.

> **🔴 NO INSERTAR EL SIG0109A HASTA HABER COMPARADO SU SERIGRAFÍA, PIN A PIN, CON EL ZÓCALO.** Es gratis, tarda un minuto, y es la diferencia entre un módulo vivo y uno muerto. Ver §4, causa 6, y §6 Prueba 0, paso 2.

---

## 4. La causa más probable, ordenada

Lista priorizada. La primera es la más probable. Cada una: **qué síntoma produce**, **cómo descartarla en menos de 5 minutos**.

---

### 🥇 Causa 1 — El módulo nuevo nunca se emparejó desde los ajustes del teléfono

**Por qué es la primera.** La app **no busca dispositivos**. Nunca llama a `startDiscovery()`. Sólo pide al sistema la lista de los que **ya están emparejados**:

```java
// MainActivity2.java:280
Set<BluetoothDevice> pairedDevices = mBluetoothAdapter.getBondedDevices();
```

Y si esa lista está vacía, el diálogo **ni siquiera se abre**: `if (pairedDevices.size() > 0)` (`MainActivity2.java:282`) — sin `else`. Se pulsa «Dispositivo» y **no pasa absolutamente nada**. Ni error, ni aviso, ni lista vacía. Exactamente lo que un usuario describe como **«no lo reconoce»**.

**Síntoma que produce:** se pulsa el botón de dispositivo en la app y no aparece ningún diálogo, o aparece uno que no incluye el módulo nuevo.

**Cómo descartarla (2 minutos):** Ajustes del teléfono → Bluetooth → buscar → emparejar el módulo → volver a la app. **El emparejamiento se hace SIEMPRE desde los ajustes de Android, nunca desde la app.**

**Agravante:** el HC-06 antiguo probablemente **sigue emparejado** en el teléfono. Aparece en la lista de la app aunque no esté enchufado a ninguna parte, y la conexión falla. Confunde el diagnóstico. **Desemparejar el HC-06 viejo.**

---

### 🥈 Causa 2 — Los baudios del módulo nuevo no son 9600

**Por qué.** El PIC está clavado a 9469,7 bd (§1). Si el módulo nuevo sale de fábrica a otra velocidad, **empareja perfectamente y no se entiende nada**.

**Y hay un motivo documental fuerte para sospechar del HC-05 en concreto:** su manual oficial (ITead Studio, 2010-06-18) dice literalmente «*Default Baud rate: **38400**, Data bits:8, Stop bit:1, Parity:No parity*», y `AT+ORGL` —el comando de valores de fábrica— restaura «*Baud **38400** bits/s*». Las placas ZS-040 que circulan por el mercado suelen venir a 9600 en modo datos **[M]**, pero **los dos valores circulan**. Con un HC-05 recién comprado, **38400 es una hipótesis de primer orden**, no una rareza.

En cambio, si el SIG0109A resulta ser un JDY-31 (§3.3), su manual da **9600** de fábrica — y entonces esta causa **no le aplica**. La ficha de Sigma, por sí sola, **no dice a qué velocidad arranca** (§3.1).

**Síntoma que produce:** empareja, la app conecta sin error, y llega **basura ilegible** (`ÿ`, `ø`, caracteres de control) o nada. El caso B2 de la tabla de §2.1.

**Cómo descartarla (5 minutos):** **Prueba 3**. Módulo en la tarjeta, dar tensión, terminal serie Bluetooth abierto. Si a los ~7 s aparece **`BALIZA ALARMA V1.0`** legible → está a 9600 y esta causa queda descartada. Si aparece basura → es esta.

---

### 🥉 Causa 3 — El HC-05 sale de fábrica en modo maestro, o esperando comandos AT

**Por qué.** El HC-05 es **maestro/esclavo/slave-loop**, conmutable con `AT+ROLE=0/1/2` **[DS, manual ITead]**. Si el que compraron viene con `ROLE=1` (maestro) — porque salió así de fábrica o porque un proveedor lo reconfiguró — **no es conectable como esclavo**: intentará él buscar y conectarse a otro dispositivo, y el teléfono no lo verá como algo a lo que emparejarse.

**El HC-06 no puede tener este problema:** su hoja de datos no contempla ningún comando de rol — es **esclavo puro**. Es una diferencia de fondo entre los dos módulos y explica muy bien «con el HC-06 funcionaba».

**Y el SIG0109A tampoco, si es un JDY-31:** el manual del JDY-31 lo describe como **sólo esclavo**, y su juego de comandos **no incluye `AT+ROLE`** (§3.3). **Esta causa apunta al HC-05, no al SIG0109A.**

**El segundo modo de fallo del HC-05:** su modo AT vive a **38400** y se entra con el pin **PIO11 (= KEY/EN del breakout) a nivel alto ANTES de alimentar** — el manual lo dice paso a paso: «*1. Connect PIO11 to high level. 2. Power on, module into command state. 3. Using baud rate 38400*». Si el módulo se quedó en modo AT (porque el pin EN quedó flotando y captó ruido, o porque alguien lo dejó así), **no habla SPP en absoluto**.

**🔴 Restricción de la tarjeta:** el pin **EN/KEY del zócalo (`U2.6`) NO ESTÁ CONECTADO A NADA** en la placa — queda al aire, sin marcador de no-conexión (`HARDWARE.md` §10 R26 y §11; `U2.1 (STATE)` y `U2.6 (EN)` figuran en la lista de nodos aislados). **Consecuencia directa: el modo AT del HC-05 NO se puede activar con el módulo montado en la baliza.** Para configurarlo hace falta sacarlo de la tarjeta y usar un adaptador USB-TTL con acceso al pin KEY. No es un defecto que haya que arreglar: es el arnés con el que hay que moverse.

**Síntoma que produce:** el teléfono **no ve** el módulo (modo maestro), o lo ve pero nunca llegan datos (modo AT).

**Cómo descartarla (5 minutos):** **Prueba 0**. Si el teléfono lo ve y lo empareja como esclavo, el rol está bien. Para lo demás, dejar el pin EN/KEY **sin tocar** (al aire) y **quitar y volver a dar tensión** al módulo: un HC-05 con EN al aire arranca en modo datos.

---

### 4️⃣ Causa 4 — El módulo está emparejado con OTRO teléfono y por eso «no aparece»

**Por qué.** Estos módulos aceptan **una sola conexión SPP a la vez**. Si un HC-05 ya está conectado al teléfono de un técnico que está a diez metros con el Bluetooth encendido, **desaparece de las búsquedas** de los demás y rechaza conexiones nuevas.

**Síntoma que produce:** el módulo se ve un rato y luego desaparece; o el emparejamiento falla sin motivo; o la app dice `Connect failed` (`MainActivity2.java:388`).

**Cómo descartarla (2 minutos):** apagar el Bluetooth de **todos** los demás teléfonos que haya cerca, quitar y dar tensión al módulo, y repetir. Si el LED estaba fijo y pasa a parpadear rápido, era esto.

---

### 5️⃣ Causa 5 — Permisos y versión de Android

Ver **§5 completo**. Resumen: la app se compiló con `targetSdkVersion 30` y **sólo** declara `BLUETOOTH` y `BLUETOOTH_ADMIN`. En un teléfono nuevo esto puede ser toda la avería. **No descartar hasta haber leído §5.**

**Cómo descartarla (5 minutos):** hacer funcionar la comunicación con un **terminal serie Bluetooth genérico** (Pruebas 1-3). Si el terminal funciona y la app no, la avería está al 100 % en la app o en sus permisos. Si el terminal tampoco funciona, la app es inocente.

---

### 6️⃣ Causa 6 — El SIG0109A tiene otro orden de pines y se enchufó girado

**Por qué.** El zócalo de la tarjeta es una fila de **6 pines a 2,54 mm** (`balizaSR30.kicad_pcb`, huella `HC06:HC06`, pads en X = 0 / 2,54 / 5,08 / 7,62 / 10,16 / 12,70 mm), cableada así:

| Pad | Señal en la placa | Va a |
|---|---|---|
| 1 | `STATE` | **al aire** |
| 2 | `RXD` | ← `MCU_TX` = `RC6`, pin 17 del PIC |
| 3 | `TXD` | → `MCU_RX` = `RC7`, pin 18 del PIC |
| 4 | `GND` | masa |
| 5 | `VCC` | **+5 V** |
| 6 | `EN` | **al aire** |

*(Fuente: `balizaSR30.kicad_sch:9578` para `U2`; nodos `MCU_TX`/`MCU_RX` verificados en `HARDWARE.md` §11.)*

Ese orden — `STATE · RXD · TXD · GND · VCC · EN` — **es exactamente el de una placa portadora ZS-040/JY-MCU**, que es lo que llevan HC-06 y HC-05 comerciales **[M]**. Encaja: **por eso el HC-06 funcionaba, y por eso un HC-05 ZS-040 debería entrar sin problema.**

**Pero con el SIG0109A hay una contradicción documentada, no una simple laguna** (§3.3):

| Fuente | Orden de los 6 pines | ¿Encaja en el zócalo? |
|---|---|---|
| Zócalo de la baliza | `STATE · RXD · TXD · GND · VCC · EN` | — (es la referencia) |
| Manual del JDY-31 **[DS]** | `STATE · RXD · TXD · GND · VCC · EN` | ✅ **Sí** |
| Martyn Currey, placa JDY-31 real **[M]** | `STATE · TXD · RXD · VCC · GND · EN` | ❌ **NO — `VCC` y `GND` intercambiados** |

**Las dos fuentes discrepan en `RXD`↔`TXD` y, sobre todo, en `VCC`↔`GND`.** Si la placa que compraron lleva el segundo orden, al insertarlo:

- **+5 V entra por donde el módulo espera GND o STATE** → el módulo se destruye en segundos, normalmente sin señal externa salvo un calentamiento.
- Y a partir de ahí el módulo está efectivamente quemado, lo cual encaja con el **«no sabemos si esto está quemado o está bueno»** del cliente.

**Síntoma que produce:** el módulo no da señales de vida y (a veces) se calienta; el LED nunca enciende. También puede haber **arrastrado el raíl de 5 V**: si el módulo hace un corto, el LM78M05 entra en limitación y **toda la tarjeta se reinicia o no arranca**.

**Cómo descartarla (3 minutos, ANTES de volver a enchufarlo):**
1. Con el módulo **fuera** de la tarjeta, mirar la serigrafía de sus 6 pines y anotar el orden.
2. Compararlo con la tabla de arriba, pad por pad.
3. Con el módulo fuera, medir con el polímetro (tarjeta alimentada) que en el pad 5 hay **+5 V** y en el pad 4 **0 V** respecto a masa.
4. Sólo entonces insertarlo, y **marcar el pin 1 con un rotulador** en la placa y en el módulo.

> **⚠️ Si el orden de pines del SIG0109A no coincide con el del zócalo, NO se puede enchufar directamente.** No es que «no se reconozca»: es que **se quema**. Con la tarjeta fija, la única salida es un adaptador de 6 hilos entre el zócalo y el módulo. Antes de fabricar nada, **pedir el pinout a Sigma** (§9, pregunta 1).

---

### 7️⃣ Causa 7 — TX/RX cruzados o sin cruzar

**Cómo está la tarjeta (dato duro, no hay que suponerlo):**

```
PIC RC6 (TX, pin 17) ──── MCU_TX ────► pad 2 del zócalo (RXD del módulo)
PIC RC7 (RX, pin 18) ◄─── MCU_RX ──── pad 3 del zócalo (TXD del módulo)
```

*(`HARDWARE.md` §5, pines 17 y 18; §11 netlist: `MCU_TX = {U1.17(RC6), U2.2(RXD)}`, `MCU_RX = {U1.18(RC7), U2.3(TXD)}`.)*

**Esto es correcto y es lo que se llama «sin cruce»**: la salida del PIC va a la **entrada** del módulo. La etiqueta `RXD` del módulo significa «la entrada del módulo», así que TX-a-RXD es lo correcto. **El HC-06 funcionaba con este cableado, luego el cableado es bueno.** No hay que tocarlo.

**Dónde está el riesgo real:** algunos módulos rotulan sus pines **desde el punto de vista de la placa que los usa** (`TX` = «conéctame al TX de tu micro»). Si el SIG0109A usa ese criterio invertido, quedarían TX contra TX y RX contra RX: **dos salidas peleándose y ninguna entrada escuchando**.

**Síntoma que produce:** el módulo empareja perfectamente y **no llega nada en ninguno de los dos sentidos**. Caso B3.

**Cómo descartarla (3 minutos):** **Prueba 3**. Si el banner llega al móvil, el sentido módulo→móvil y PIC→módulo están bien. Si no llega nada pero el LED de vida `D1` de la tarjeta parpadea (el PIC está corriendo), sospechar de esto. **Con la tarjeta fija la corrección es un adaptador de dos hilos cruzados entre el zócalo y el módulo, no una modificación de la placa.**

---

### 8️⃣ Causa 8 — Alimentación y niveles lógicos

**Lo que hay en la tarjeta, verificado en `HARDWARE.md`:**

| Punto | Situación en la placa |
|---|---|
| **VCC del módulo** | **+5 V** desde el LM78M05. `+5V → U2.5 (VCC)` (`HARDWARE.md` §4.1 y §11) |
| **Adaptación de nivel en `MCU_TX`** | ❌ **NO EXISTE.** `RC6` (salida CMOS a 5 V) llega **directamente** al pad `RXD`, **sin divisor y sin resistencia serie** (`HARDWARE.md` §10, riesgo **R7**) |
| **Adaptación en `MCU_RX`** | No hace falta y no la lleva. El módulo saca 3,3 V; el `VIH` del PIC a VDD = 5 V es `0,25·VDD + 0,8 = 2,05 V`. 3,3 V > 2,05 V → **se lee bien** (`HARDWARE.md` §10 R7) |
| **Desacoplo del módulo** | ❌ Ninguno. El módulo no tiene condensador cerámico propio; el único de la placa (`C6`, 0,1 µF) está junto al PIC (`HARDWARE.md` §4.3) |
| **Consumo previsto** | ≈ 8 mA en reposo, **≈ 40 mA en inquiry/emparejamiento** (`HARDWARE.md` §4.5) |

**Consecuencia real, dicha sin adornos:**

- **Los 5 V en VCC no son un problema** para el SIG0109A: su ficha declara **3,6–6 V** y lleva regulador interno (§3, y `BK3231_ARM968E-S.pdf` Tabla 2 confirma que el SoC es de 2,0–3,6 V, así que el módulo forzosamente regula). Tampoco lo son para un HC-05/HC-06 sobre placa ZS-040. **Sí lo serían para un módulo desnudo de 3,3 V**, que se destruiría al instante.
- **Los 5 V en RXD sí son un problema**, y es un problema **acumulativo, no instantáneo**. Un pin de entrada de 3,3 V atacado a 5 V conduce por su diodo de protección superior. El módulo suele **seguir funcionando durante semanas o meses** y luego morir. Es la causa clásica de mortalidad prematura de estos módulos y **encaja con la historia del cliente: el HC-06 funcionaba… hasta que dejó de funcionar**.
- **Qué se puede hacer con la tarjeta fija:** una **resistencia serie de 1 kΩ** intercalada en el hilo `MCU_TX`, o un divisor 1 kΩ / 2 kΩ, montados en el propio adaptador de 6 hilos del módulo o soldados en el pin del zócalo. No es una modificación de la PCB: es un componente en el cableado del módulo. **No cambia nada del diagnóstico de hoy — es seguro de vida para el módulo nuevo.**

**Cómo descartar un problema de alimentación (2 minutos):** polímetro entre pad 5 y pad 4 del zócalo, con el módulo **puesto**, la tarjeta alimentada a 12 V. Debe leer **4,75–5,25 V estables**. Si lee menos de 4,5 V, o baja al insertar el módulo, el módulo está tirando corriente = **corto = quemado** (§8).

---

### 9️⃣ Causa 9 — El firmware

**Última de la lista, y con motivo.** El firmware ya funcionaba con el HC-06 y no se ha tocado. Aun así, para cerrarlo, dos límites reales del código que hay que respetar al probar a mano (§7):

1. **La trama debe llegar en bloque.** El analizador espera **5 ms de silencio** para dar por cerrada una trama: `PERIOD_ANALIZA_UART1 = 1` ms (`Serial.h:21`), y en `Serial.c:118` `if(++anaT1.uiCnt >= 5)`. Cada byte recibido pone el contador a cero (`main.c:84`). **Tecleando carácter a carácter en un terminal, la trama se procesa después de la primera letra y se pierde.** Hay que enviarla de golpe.
2. **El buffer de recepción son 40 bytes sin control de desbordamiento.** `receiverUart1()` escribe en `serial1.bufferRx[serial1.ucCntRX++]` (`Serial.c:76`) sobre un buffer `char bufferRx[40]` (`Serial.h:24, 49`) **sin comprobar el límite**. Enviar de golpe más de 40 bytes corrompe memoria del PIC. **No pegar textos largos en el terminal.**

Ninguna de las dos cosas es la avería de hoy. Son **reglas de uso** para que las pruebas manuales de §7 salgan bien.

---

## 5. Android: puede ser toda la avería

### 5.1 Qué declara la app, exactamente

Verificado **en el código fuente y también en el APK ya compilado** que hay en `app/release/Baliza.apk` (manifiesto binario extraído y decodificado — coinciden):

| Dato | Valor | Fuente |
|---|---|---|
| `minSdkVersion` | **16** (Android 4.1) | `app/build.gradle:11` y `AndroidManifest.xml` del APK |
| `targetSdkVersion` | **30** (Android 11) | `app/build.gradle:12` y `AndroidManifest.xml` del APK |
| `compileSdkVersion` | 30 | `app/build.gradle:6` |
| Permisos declarados | `android.permission.BLUETOOTH`, `android.permission.BLUETOOTH_ADMIN` — **y ninguno más** | `app/src/main/AndroidManifest.xml:5-6` |
| Permiso de ubicación | ❌ **ninguno** | ídem |
| `BLUETOOTH_CONNECT` / `BLUETOOTH_SCAN` | ❌ **ninguno** | ídem |
| Solicitud de permisos en tiempo de ejecución | ❌ **no existe.** No hay una sola llamada a `requestPermissions()` en `MainActivity.java` ni en `MainActivity2.java` | lectura completa de ambos ficheros |
| UUID del servicio | `00001101-0000-1000-8000-00805F9B34FB` (SPP estándar) | `MainActivity2.java:42` |
| Cómo obtiene los dispositivos | `getBondedDevices()` — **sólo emparejados** | `MainActivity2.java:280` |
| ¿Busca dispositivos? | ❌ **NO.** No hay ninguna llamada a `startDiscovery()`. La única llamada al descubrimiento es `cancelDiscovery()` (`MainActivity2.java:377`) | lectura completa |

### 5.2 El modelo de permisos de Android, versión por versión

*Fuentes: Android, «Bluetooth permissions» (<https://developer.android.com/develop/connectivity/bluetooth/bt-permissions>) y «Privacy changes in Android 10» (<https://developer.android.com/about/versions/10/privacy/changes>). Las versiones concretas del teléfono de campo hay que verificarlas en el equipo — §9, pregunta 11.*

| Android | API | Qué exige para **descubrir** dispositivos Bluetooth clásicos | Qué exige para **conectar** a uno emparejado | Efecto sobre ESTA app |
|---|---|---|---|---|
| 4.1 – 5.1 | 16–22 | `BLUETOOTH_ADMIN` (concedido en la instalación) | `BLUETOOTH` | ✅ funciona |
| **6.0 – 9** | **23–28** | `BLUETOOTH_ADMIN` **+ permiso de ubicación** (`ACCESS_COARSE_LOCATION` **o** `ACCESS_FINE_LOCATION`) | `BLUETOOTH` | ✅ funciona — **porque la app no descubre**, sólo lista emparejados |
| **10 – 11** | **29–30** | `BLUETOOTH_ADMIN` **+ `ACCESS_FINE_LOCATION` obligatorio** | `BLUETOOTH` | ✅ ídem |
| **12 y posteriores** | **31+** | Para apps con `targetSdk ≥ 31`: **`BLUETOOTH_SCAN`** en tiempo de ejecución | Para apps con `targetSdk ≥ 31`: **`BLUETOOTH_CONNECT`** en tiempo de ejecución | ⚠️ **ver §5.3** |

**El corte de `COARSE` a `FINE` lo marca el `targetSdk`, no la versión del teléfono.** Android 10 lo dice literalmente: «*If your app targets Android 10 or higher, it must have the `ACCESS_FINE_LOCATION` permission in order to use several methods within the Wi-Fi, Wi-Fi Aware, or Bluetooth APIs*», y la lista incluye explícitamente `BluetoothAdapter.startDiscovery()`. Y añade: «*If your app runs on Android 10 or higher but targets Android 9 (API level 28) or lower, you can use the affected APIs … as long as your app has declared either the `ACCESS_COARSE_LOCATION` or the `ACCESS_FINE_LOCATION` permission*».

**🔴 Y el permiso no basta: el interruptor de Ubicación del teléfono tiene que estar ENCENDIDO.** No es folclore, está en el código de Android: el módulo Bluetooth de AOSP implementa `blockedByLocationOff()` → `return !context.getSystemService(LocationManager.class).isLocationEnabledForUser(userHandle);` y todos los `checkCallerHasCoarseLocation` / `…FineLocation` hacen `if (blockedByLocationOff(...)) { Log.e(TAG, "Permission denial: Location is off."); return false; }` (<https://android.googlesource.com/platform/packages/modules/Bluetooth/+/refs/heads/main/android/app/src/com/android/bluetooth/Utils.java>). **Esto afecta a la búsqueda desde los ajustes del teléfono, que es donde hay que emparejar el módulo (Prueba 0, paso 6).**

### 5.3 La respuesta concreta: ¿en qué versión de Android deja de funcionar?

**Con el APK tal como está (`targetSdkVersion 30`): en ninguna, por permisos. Confirmado en el código de Android, no supuesto.**

Android aplica los permisos nuevos de Bluetooth **en función del `targetSdkVersion` de la app, no de la versión del sistema**. El mecanismo se llama *split permissions* y está en `platform.xml` de AOSP: `BLUETOOTH` y `BLUETOOTH_ADMIN` están declarados con `targetSdk="31"` → `BLUETOOTH_SCAN`, `BLUETOOTH_CONNECT`, `BLUETOOTH_ADVERTISE` (<https://android.googlesource.com/platform/frameworks/base/+/refs/heads/main/data/etc/platform.xml>). Si el `targetSdk` de la app es **menor que 31**, esos permisos nuevos se añaden como **implícitos** y se **auto-conceden** heredando el estado del permiso de origen (`inheritPermissionStateToNewImplicitPermissionLocked()` en `PermissionManagerServiceImpl.java`). Como `BLUETOOTH`/`BLUETOOTH_ADMIN` son permisos de instalación y están siempre concedidos, los nuevos se conceden **sin diálogo**.

Lo confirma también la anotación oficial `@RequiresLegacyBluetoothPermission` de AOSP: «*For apps targeting Build.VERSION_CODES#R or lower, this requires the `Manifest.permission#BLUETOOTH` permission which can be gained with a simple `<uses-permission>` manifest tag*».

Por eso `getBondedDevices()` y `createRfcommSocketToServiceRecord()` **siguen funcionando** en Android 12, 13, 14 y 15 con este APK, y **no hay ningún aviso oficial de retirada de esa capa de compatibilidad**.

**Tampoco hay un bloqueo de instalación:** Android 14 impide instalar apps con `targetSdkVersion` menor que **23**, y Android 15 menor que **24**. Con `targetSdk 30`, **el APK se instala sin problema en Android 14 y 15** (<https://developer.android.com/about/versions/14/behavior-changes-all>, <https://developer.android.com/about/versions/15/behavior-changes-all>). *(Aparte: Google Play sí exige `targetSdk` mucho más alto para publicar, pero esta app se instala a mano.)*

**El día que rompe es el día que alguien recompile la app con `targetSdkVersion 31` o superior.** Ese día, y sin tocar una línea de lógica:

- `getBondedDevices()` lanza **`SecurityException`** por falta de `BLUETOOTH_CONNECT`.
- `createRfcommSocketToServiceRecord()` / `socket.connect()` lanzan lo mismo.
- Y como el código **no captura `SecurityException`** en `querypaired()` (`MainActivity2.java:278-323`, sin `try/catch`), la app **se cierra sola**.

Eso pasará antes o después: **Google Play exige subir el `targetSdk` cada año**, y aunque esta app se instale a mano (sideload), cualquier reconstrucción con un Android Studio moderno lo sube por defecto.

**Qué habría que cambiar el día que se recompile** (no hace falta hoy, pero conviene tenerlo escrito):

```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.BLUETOOTH"
                 android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN"
                 android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<!-- BLUETOOTH_SCAN sólo si algún día se añade búsqueda de dispositivos: -->
<!-- <uses-permission android:name="android.permission.BLUETOOTH_SCAN"
                      android:usesPermissionFlags="neverForLocation" /> -->
```

Y en el código, antes de tocar nada del adaptador:

```java
if (Build.VERSION.SDK_INT >= 31 &&
    checkSelfPermission(Manifest.permission.BLUETOOTH_CONNECT)
        != PackageManager.PERMISSION_GRANTED) {
    requestPermissions(new String[]{ Manifest.permission.BLUETOOTH_CONNECT }, 1);
    return;
}
```

Además, al pasar a `targetSdk 31+` habrá que declarar `android:exported` explícitamente en las dos `<activity>` de `AndroidManifest.xml:15-16` (hoy no lo llevan), o la app **ni siquiera instalará**.

### 5.4 Lo que SÍ está roto hoy, sin depender de la versión

Tres cosas, todas de la app, y ninguna tiene que ver con permisos:

**a) La app no empareja. Nunca.** El botón «Dispositivo» llama a `querypaired()` (`MainActivity2.java:232`), que sólo lee `getBondedDevices()`. **Si el módulo no se ha emparejado antes desde los ajustes del teléfono, no aparecerá jamás en la app, por muy bueno que esté el módulo.** Y si la lista de emparejados está vacía, **la app no dice nada**: el diálogo está dentro de `if (pairedDevices.size() > 0)` (`MainActivity2.java:282`) y no hay rama `else`. Pulsar el botón y que no pase nada **es el comportamiento previsto del código**, no un fallo del Bluetooth.

**b) La lectura es de un solo disparo, con un temporizador fijo.** Tras enviar `¿L?`, la app **duerme 6 segundos** y luego hace **una sola** llamada a `read()` (`MainActivity2.java:444-447`):

```java
TimeUnit.MILLISECONDS.sleep(6000);
mmInStream = socket.getInputStream();
numBytes  = mmInStream.read(mmBuffer);
String dato = new String(mmBuffer);
```

`read()` devuelve **lo que haya en el buffer en ese instante**, no el mensaje completo. El volcado del PIC son **nueve tramas** enviadas una tras otra (`Aplicacion.c:291-331`). Es perfectamente posible que la app muestre sólo un trozo. **Un volcado truncado no significa que el módulo esté mal.**

**c) La configuración se manda a ciegas.** El botón «Configurar» envía la hora y, 3 s después, la trama de alarma (`MainActivity2.java:425-431`), y **nunca lee la respuesta**. `mkmsg("Mensaje Enviado!!")` se imprime aunque el PIC no haya recibido nada. **«Mensaje Enviado» no es una confirmación.** El único acuse real que emite el firmware es un pitido (`oneBeep()`, `Aplicacion.c:175, 181, 188`)… y **el buzzer de esta tarjeta no suena** por dos defectos de hardware/firmware independientes (`HARDWARE.md`, hallazgos **C1** y **C2**). Es decir: **hoy no hay ninguna forma de confirmar que una configuración se ha grabado, salvo volver a pedir el volcado con `L` y mirarlo.** Hágase siempre.

**d) La app abre un socket RFCOMM SEGURO, y con estos módulos eso puede fallar.** `MainActivity2.java:358` usa `createRfcommSocketToServiceRecord()`, la variante **autenticada y cifrada**. El javadoc de AOSP advierte: «*Use this socket only if an authenticated socket link is possible. … For example, for Bluetooth 2.1 devices, if any of the devices does not have an input and output capability …, a secure socket connection is not possible. In such a case, use `createInsecureRfcommSocketToServiceRecord`*». Un HC-05/HC-06/BK3231S **no tiene ni pantalla ni teclado**, así que es exactamente el caso descrito.

Curiosamente, **la app ya tiene la variante insegura escrita** — `createInsecureRfcommSocketToServiceRecord()` en `MainActivity2.java:514` — pero está dentro de `ConnectAsyncTask`, una clase que **nunca se instancia ni se usa**. Si el `Connect failed` (`MainActivity2.java:388`) persiste con un módulo que por lo demás funciona, **cambiar la llamada de la línea 358 por la insegura es la corrección de una sola línea**.

> **Aclaración honesta:** no se ha encontrado **ninguna** documentación oficial de Android 12/13/14/15 que diga que el sistema rechace conexiones SPP a dispositivos con emparejamiento por PIN legado. Los fallos de este tipo (`java.io.IOException: read failed, socket might closed or timeout`) están reportados **sólo en foros**. Por eso esta causa va aquí y no en §4: es una hipótesis de segundo orden, barata de probar, no un hecho documentado.

**e) Una nota tranquilizadora sobre el carácter `¿`.** La app construye las tramas en Java con `'¿'` (`MainActivity2.java:182, 208, 408`) y las escribe con un `PrintWriter` sin especificar juego de caracteres, luego se codifican en **UTF-8**: el `¿` sale como **dos bytes, `0xC2 0xBF`**. El firmware busca el byte **`0xBF`** con `strstr(anaT1.bufferRx, INIT_FRAME)` (`Serial.c:148`, `Serial.h:27`). Encuentra el `0xBF`; el `0xC2` de más es inofensivo porque el analizador busca subcadenas, no posiciones fijas. **Esto funciona y no es la avería.** Se documenta porque, si algún día se cambia el juego de caracteres del `PrintWriter`, sigue funcionando igual (en Windows-1252 el `¿` es un único byte `0xBF`).

---

## 6. PROCEDIMIENTO DE PRUEBA PASO A PASO

> **Cómo usar esta sección.** Está diseñada para **separar variables**, de lo más simple a lo más complejo. **Hágase en orden.** Si la Prueba 0 falla, no tiene ningún sentido pasar a la 1. Cada prueba elimina capas enteras del problema.
>
> **Regla:** cambiar **una sola cosa** entre intento e intento, y anotar el resultado.

### Material necesario

| Qué | Para qué | ¿Imprescindible? |
|---|---|---|
| Polímetro | Medir 5 V y detectar cortos | **Sí** |
| Teléfono Android con Bluetooth | Todo | **Sí** |
| App **«Serial Bluetooth Terminal»** de Kai Morich (Play Store, gratuita) | Terminal serie sobre SPP. Permite enviar en modo texto y en **modo HEX**, y guardar macros | **Sí** |
| Fuente de 12 V para la tarjeta | Prueba 3 en adelante | **Sí** |
| Adaptador **USB-TTL** (CH340 / FT232 / CP2102) con salida de 5 V | Pruebas 0-2 sin la tarjeta, y medir los baudios reales | **Muy recomendable** |
| Cables dupont hembra-hembra | Puentes y loopback | **Sí** |
| Rotulador permanente | Marcar el pin 1 | **Sí** |

**Nota sobre el terminal:** si no se puede instalar «Serial Bluetooth Terminal», sirve cualquier terminal SPP genérico («Bluetooth Terminal», «Bluetooth Serial Terminal»). Lo que **no** sirve es la app de la baliza: es lo último que se prueba, no lo primero.

---

### PRUEBA 0 — El módulo solo, sin la tarjeta

**Qué demuestra:** que el módulo está **vivo**, que emite radio y que el teléfono puede emparejarse con él. **Si esta prueba falla, el problema no está ni en el PIC, ni en el firmware, ni en la app, ni en los baudios.**

**Pasos:**

1. **Sacar el módulo de la tarjeta.** Anotar y fotografiar la serigrafía de sus 6 pines, en orden, de un extremo al otro.
2. **Comparar** ese orden con el del zócalo: `STATE · RXD · TXD · GND · VCC · EN` (§4, causa 6). **Si no coincide, PARAR aquí**: el módulo puede haberse quemado ya al insertarlo, y volver a insertarlo lo rematará. Ir a §9, pregunta 1.
3. **Alimentar el módulo, sólo VCC y GND**, con una de estas dos opciones:
   - **Opción A (mejor):** adaptador USB-TTL, salida **5 V** a `VCC` y `GND` a `GND`.
   - **Opción B (sin comprar nada):** de la propia tarjeta, con el módulo **fuera** del zócalo. El conector ICSP `J1` tiene **`J1.2 = +5 V`** y **`J1.3 = GND`** (`HARDWARE.md` §2.2). Dos cables dupont desde ahí al `VCC` y `GND` del módulo, con la tarjeta alimentada a 12 V. **Comprobar la polaridad con el polímetro ANTES de conectar.**
4. **Medir** con el polímetro entre los pines `VCC` y `GND` **del módulo ya conectado**: debe leer **4,75 – 5,25 V**.
   - Si la tensión **se hunde** al conectar el módulo → el módulo hace un corto → **quemado**, ir a §8.
   - Si el módulo **se calienta** → **quemado**, ir a §8. Desconectar inmediatamente.
5. **Mirar el LED del módulo.** Lo que significa cada patrón *(marca [M] — observación de mercado, no especificación; los clones pueden variar)*:

   | LED | Significado habitual | Qué hacer |
   |---|---|---|
   | **Parpadeo rápido**, ~2–5 veces por segundo | **Modo datos, sin conexión establecida.** Es el estado normal y correcto de un módulo esperando que alguien se conecte | Seguir al paso 6 |
   | **Fijo encendido**, sin parpadear | **Hay una conexión SPP abierta.** Alguien está conectado — quizá otro teléfono (§4, causa 4) | Apagar el Bluetooth de los demás teléfonos y volver a alimentar |
   | **Parpadeo lento**, ~1 vez cada 2 s, o dos destellos seguidos y pausa | En un **HC-05**: **modo AT/comando** (el pin KEY quedó alto), o conexión establecida según variante | Dejar el pin EN/KEY **al aire**, quitar y dar tensión |
   | **Apagado del todo** | **Sin alimentación, o módulo muerto** | Volver al paso 4. Si hay 5 V correctos y el LED sigue apagado → §8 |

6. **Buscar el módulo desde el teléfono.** Ajustes → Bluetooth → **Buscar dispositivos**. **No desde la app de la baliza.**
   - Con la **ubicación del teléfono encendida** (Android 6 en adelante la exige para buscar Bluetooth clásico, §5.2).
   - Con **todos los demás teléfonos apagados** o con el Bluetooth desactivado.
   - Esperar **hasta 2 minutos completos**.
7. **Emparejar.** PIN a probar, en este orden: **`1234`**, luego **`0000`**.
   - Anotar **el nombre exacto** con el que aparece. **Puede no llamarse «HC-06».** Nombres de fábrica documentados:

     | Módulo | Nombre de fábrica | Fuente |
     |---|---|---|
     | HC-06 | **`linvor`** | datasheet Wavesen («*ID: linvor*») |
     | HC-05 | **`HC-05`** o **`H-C-2010-06-01`** (tras `AT+ORGL`) | manual ITead |
     | SIG0109A, si es un JDY-31 | **`JDY-31-SPP`** | manual JDY-31 |

   - **Buscar «HC-06» y no encontrarlo NO significa que el módulo esté mal.** Es, muy probablemente, todo el «no lo reconoce».
8. Anotar la **dirección MAC** que muestra el teléfono. Servirá para identificarlo entre varios.

**Resultado y qué significa:**

| Resultado | Significado | Siguiente paso |
|---|---|---|
| ✅ El teléfono lo ve y lo empareja | **El módulo está VIVO.** Queda descartado que esté quemado. La avería está en configuración, baudios, cableado o app | **Prueba 1** |
| ❌ 5 V correctos, LED apagado, nadie lo ve tras 2 min | **Módulo muerto** | **§8** |
| ❌ LED parpadea pero nadie lo ve | HC-05 en **modo maestro**, o modo AT, o ya conectado a otro teléfono | §4 causas 3 y 4. Si persiste, hace falta el manual AT (§9) |
| ❌ Lo ve pero el emparejamiento falla con los dos PIN | PIN distinto del de fábrica | §9, pregunta 2 |
| ❌ La tensión se hunde o el módulo calienta | **Quemado, probablemente por pinout girado** | **§8** y §4 causa 6 |

---

### PRUEBA 1 — Bucle (loopback): el módulo se habla a sí mismo

**Qué demuestra:** que el módulo **transmite y recibe de verdad por su UART**, sin el PIC de por medio. Es la prueba que separa «el módulo funciona» de «el módulo aparece en la lista pero no hace nada».

**Importante:** el loopback **no dice nada sobre los baudios**. El módulo recibe a su velocidad y reenvía a esa misma velocidad, así que el eco vuelve bien **sea cual sea** la velocidad configurada. Los baudios se miden en la **Prueba 2**.

**Pasos:**

1. Módulo **fuera de la tarjeta**, alimentado como en la Prueba 0, paso 3.
2. **Puentear con un cable dupont el pin `TXD` con el pin `RXD` del propio módulo.** Nada más. Ni PIC, ni adaptador, ni tarjeta.
3. En el teléfono, abrir **Serial Bluetooth Terminal** → menú → **Devices** → seleccionar el módulo emparejado → conectar.
4. Escribir `HOLA` y pulsar enviar.

**Resultado y qué significa:**

| Resultado | Significado | Siguiente paso |
|---|---|---|
| ✅ Vuelve **`HOLA`** exactamente | El módulo **transmite y recibe correctamente**. El enlace Bluetooth-a-serie está sano de punta a punta | **Prueba 2** |
| ❌ No vuelve nada | El puente está mal puesto (**probar a intercambiarlo**: el rótulo `TXD`/`RXD` puede estar invertido), o el módulo tiene la UART muerta | Repetir con el puente al revés. Si sigue sin volver nada → **§8** |
| ❌ Vuelve texto **distinto o corrupto** | Muy raro en loopback. Apunta a alimentación inestable o módulo dañado | Repasar la tensión (Prueba 0, paso 4) → si es correcta, **§8** |
| ❌ Vuelve **duplicado** (`HHOOLLAA`) | El terminal tiene activado el eco local | Desactivar el eco local en los ajustes del terminal y repetir |

5. **Quitar el puente antes de seguir.**

---

### PRUEBA 2 — Averiguar los baudios reales del módulo

**Qué demuestra:** el dato que decide todo (§1). Dos métodos; el primero es fiable siempre, el segundo sólo si el módulo acepta comandos AT.

#### Método A — Con un adaptador USB-TTL (fiable, funciona con cualquier módulo)

1. Módulo fuera de la tarjeta. Conectar al adaptador USB-TTL:

   | Módulo | Adaptador USB-TTL |
   |---|---|
   | `VCC` | `5V` |
   | `GND` | `GND` |
   | `TXD` | `RX` |
   | `RXD` | `TX` |

   *(Sí, **cruzado**: aquí el adaptador hace de micro. En la tarjeta el cruce ya está hecho en el cobre, §4 causa 7.)*
2. En el PC, abrir un terminal (**RealTerm**, **Termite** o **PuTTY**) sobre el puerto COM del adaptador, con **8 bits, sin paridad, 1 stop, sin control de flujo**.
3. En el teléfono, conectar con **Serial Bluetooth Terminal** al módulo.
4. Desde el teléfono, enviar repetidamente la letra **`U`** (`0x55` = `01010101` en binario: alterna todos los bits, es el patrón ideal para detectar baudios).
5. **Barrer las velocidades del PC** hasta que aparezcan `U` limpias: **9600 → 19200 → 38400 → 57600 → 115200**.
6. La velocidad a la que se leen `U` limpias **es la velocidad real del módulo**. **Anotarla.**

**Interpretación:**

| Velocidad hallada | Qué significa | Qué hacer |
|---|---|---|
| **9600** | ✅ Coincide con el PIC (§1). Los baudios **no son** la avería | **Prueba 3** |
| Cualquier otra | ❌ **Ésta es la avería.** El PIC no puede cambiar de velocidad sin recompilar y reprogramar el PIC | Reconfigurar el módulo a 9600 (Método B), o pedir a Sigma cómo se hace (§9, pregunta 1) |
| Ninguna funciona | Formato distinto de 8N1, o el módulo no transmite | Probar 8E1 y 8O1. Si nada, **§8** |

#### Método B — Por comandos AT (sólo si el módulo los acepta)

Con el mismo montaje del Método A, pero mandando los comandos **desde el terminal del PC** (no desde el teléfono) y **con el módulo NO conectado por Bluetooth** — casi todos estos módulos ignoran los comandos AT mientras hay una sesión SPP abierta.

**Si es un HC-06 [M]:** a los baudios de trabajo, enviar `AT` **sin CR ni LF** y esperar `OK`. Para cambiar la velocidad: `AT+BAUD4` = 9600.

**Si es un HC-05 [M]:** poner el pin **`KEY`/`EN` a nivel alto ANTES de alimentar**, abrir el terminal a **38400 8N1** y enviar, cada uno terminado en **CR+LF**:

```
AT              → responde OK  (confirma que está en modo AT)
AT+VERSION?     → identifica el firmware
AT+UART?        → devuelve la velocidad actual del modo datos
AT+ROLE?        → 0 = esclavo (correcto)  ·  1 = maestro (ES LA AVERÍA, §4 causa 3)
```

Y para dejarlo bien:

```
AT+ORGL             → valores de fábrica
AT+ROLE=0           → esclavo
AT+UART=9600,0,0    → 9600, 1 bit de stop, sin paridad
AT+PSWD=1234        → PIN
AT+NAME=BALIZA      → nombre reconocible
AT+RESET
```

> **🔴 Restricción de la tarjeta:** el pin `EN/KEY` del zócalo **no está conectado a nada** (`HARDWARE.md` §10 R26). **El modo AT del HC-05 no se puede activar con el módulo montado en la baliza.** Esta configuración hay que hacerla **fuera**, con el USB-TTL. No hay alternativa con la placa tal como está.

**Si es un SIG0109A:** empezar por los comandos del **JDY-31**, que es lo que casi seguro es (§3.3). A **9600 8N1**, sin conexión Bluetooth abierta, **terminando cada comando en `\r\n`**:

```
AT+VERSION      → +VERSION=JDY-31-V1.2,Bluetooth V3.0   ← si responde esto, ES un JDY-31
AT+BAUD         → consulta la velocidad actual
AT+PIN          → consulta el PIN
AT+NAME         → consulta el nombre
```

Y para dejarlo bien:

```
AT+BAUD4        → 9600
AT+PIN1234
AT+NAME BALIZA
AT+RESET
```

> **Ojo:** el juego del JDY-31 son **sólo 9 comandos** —`AT+VERSION`, `AT+RESET`, `AT+DISC`, `AT+LADDR`, `AT+PIN`, `AT+BAUD`, `AT+NAME`, `AT+DEFAULT`, `AT+ENLOG`— y **NO incluye `AT+ROLE` ni `AT+UART`**. Si se prueban los del HC-05 no responderán, y eso **no** significa que el módulo esté mal.
>
> Si no responde a **ninguno** de los tres juegos (HC-06, HC-05, JDY-31), entonces sí hay que pedir el manual a Sigma (§9, pregunta 1).

---

### PRUEBA 3 — El módulo montado en la tarjeta

**Qué demuestra:** que el PIC y el módulo se entienden. Es la prueba de integración, y **además vuelve a medir los baudios** de forma indirecta.

**Pasos:**

1. **Sin tensión.** Insertar el módulo en el zócalo, **respetando el pin 1** (§4, causa 6). Marcarlo con rotulador.
2. En el teléfono, abrir **Serial Bluetooth Terminal** y **conectar** al módulo.
3. **Con el terminal ya conectado**, dar tensión de 12 V a la tarjeta por `J2`.
4. **Esperar.** El banner no es inmediato:
   - `ST_ARRANQUE_AP` cuenta `TIME_ARRANQUE = 500` (`Aplicacion.h:24`) períodos de `PERIOD_APLICACION = 10` ms (`Aplicacion.h:22`) ≈ **5 s**.
   - `ST_READ_MEMO_AP` cuenta otros `200` × 10 ms ≈ **2 s** (`Aplicacion.c:90`).
   - Total: **≈ 7 s**. En un PIC recién programado (EEPROM virgen) hace una pasada extra de inicialización y tarda **≈ 9 s**.
   - **Esperar 15 s antes de dar nada por fallido.**
5. **Lo que tiene que aparecer**, exactamente (`Aplicacion.c:147`):

```
BALIZA ALARMA V1.0
```

   *(precedido y seguido de saltos de línea: la cadena real es `"\n\rBALIZA ALARMA V1.0\n\r\n\r"`).*

6. Si el banner sale bien, **pedir el volcado**: enviar `¿L?` **como un bloque** (§7). Deben llegar las nueve líneas: hora, fecha y las cinco alarmas.

**Resultado y qué significa — esta tabla es el corazón del diagnóstico:**

| Lo que sale | Significado | Siguiente paso |
|---|---|---|
| ✅ **`BALIZA ALARMA V1.0`** legible | **Todo el camino PIC → módulo → teléfono funciona, y los baudios son 9600.** Quedan descartadas las causas 2, 6, 7 y 8 de golpe | Paso 6, y luego **Prueba 4** |
| ⚠️ **Texto ilegible**, símbolos raros, `ÿ`, `ø`, cuadraditos | **Los baudios NO son 9600.** El enlace físico está bien (llegan bytes), la velocidad no. Es la causa 2 | **Prueba 2** para medir la velocidad real y reconfigurar el módulo |
| ⚠️ Sale **algo legible pero incompleto o entrecortado** | Baudios cerca pero no iguales (p. ej. 9600 contra 9615 mal ajustado), o alimentación inestable | Medir 5 V en el zócalo con el módulo puesto. Repasar **Prueba 2** |
| ❌ **Nada, pantalla en blanco**, y el **LED de vida `D1` de la tarjeta parpadea** | El PIC está corriendo pero sus bytes no llegan. Cableado `TXD` del módulo (causa 7), o pin del zócalo con mal contacto | Comprobar con el polímetro la continuidad `U2` pad 3 ↔ pin 18 del PIC. Revisar el orden de pines del módulo (causa 6) |
| ❌ **Nada, y el LED de vida `D1` NO parpadea** | **El PIC no está arrancando.** No es un problema de Bluetooth | Medir 5 V en el pin 20 del PIC. Ver `HARDWARE.md` §4 |
| ❌ **Nada, y el LED del MÓDULO tampoco enciende** | El módulo no recibe alimentación en el zócalo, o está quemado | Medir 5 V entre pads 5 y 4 del zócalo. Luego **§8** |
| ❌ **El banner sale, pero enviar `¿L?` no devuelve nada** | El sentido **teléfono → módulo → PIC** está roto: pin `RXD` del módulo, o `MCU_TX` del PIC. **O la trama se envió carácter a carácter** (§7) | Reenviar como **bloque**. Si sigue sin ir, comprobar continuidad `U2` pad 2 ↔ pin 17 del PIC |
| ❌ **La tarjeta se reinicia** al insertar el módulo | El módulo tira demasiada corriente. Corto interno | **§8** |

---

### PRUEBA 4 — Con la app de la baliza

**Sólo llegar aquí si la Prueba 3 ha salido bien.** Si un terminal serie genérico funciona y la app no, la avería está **al 100 % en la app o en sus permisos** (§5) — y ya no hay que tocar ni el módulo, ni la tarjeta, ni el firmware.

**Pasos:**

1. **Cerrar el terminal serie y DESCONECTARLO.** El módulo acepta **una sola conexión**; si el terminal sigue conectado, la app fallará con `Connect failed` y no será culpa de nadie.
2. Verificar en **Ajustes → Bluetooth → Dispositivos emparejados** que el módulo aparece ahí. **Si no está, la app no lo verá nunca** (§5.4a).
3. **Desemparejar el HC-06 viejo**, si sigue en la lista. Evita elegir el equivocado.
4. Abrir la app. Usuario **`admin`**, contraseña **`admin`** (`MainActivity.java:127-129`).
5. Pulsar **«Dispositivo»**.
   - Debe abrirse un diálogo **«Elija el Bluetooth:»** con la lista.
   - **Si no se abre ningún diálogo → la lista de emparejados está vacía → volver al paso 2.** No es un fallo del Bluetooth, es el código (`MainActivity2.java:282`).
6. Seleccionar el módulo. El botón cambia a su nombre y se habilitan «Leer» y «Configurar» (`MainActivity2.java:310-314`).
7. Pulsar **«Leer»**. Esto envía la trama `¿L?` (`MainActivity2.java:408`).
8. **Esperar 6 segundos completos.** La app duerme exactamente ese tiempo antes de leer (`MainActivity2.java:444`). No pulsar dos veces.

**Resultado y qué significa:**

| Lo que sale | Significado | Siguiente paso |
|---|---|---|
| ✅ Aparece la hora, la fecha y la tabla de las cinco alarmas | **Todo funciona.** Ya se puede configurar | Configurar los horarios (§7 o el botón «Configurar») |
| ⚠️ Aparece **parte** del volcado, cortado | **Normal, no es una avería.** La app hace **una sola** llamada a `read()` (§5.4b) | Volver a pulsar «Leer». Para el volcado completo, usar el terminal serie |
| ❌ **`Connect failed`** | Otro dispositivo tiene el módulo cogido (el terminal del paso 1, u otro teléfono), o el emparejamiento está corrupto | Paso 1. Desemparejar y volver a emparejar |
| ❌ Pulsar «Dispositivo» y **no pasa nada** | Lista de emparejados vacía (§5.4a) | Paso 2 |
| ❌ **La app se cierra sola** | `SecurityException` no capturada → **la app fue recompilada con `targetSdk ≥ 31`** (§5.3) | Reinstalar el APK original de `app/release/Baliza.apk`, o arreglar los permisos según §5.3 |
| ❌ `Esperando Mensaje ...` y nunca llega nada | La app envió pero el PIC no contestó — aunque el terminal sí funcionaba | Repetir la **Prueba 3** paso 6 con el terminal. Si el terminal va y la app no, es la app |

---

## 7. Tramas para probar a mano desde un terminal serie

Esto permite configurar la baliza **sin la app**, y es la vía de escape si la app está rota. Todo verificado contra `Serial.c` y `Serial.h`.

### 7.1 El formato

| Elemento | Valor | Fuente |
|---|---|---|
| **Delimitador de inicio** | byte **`0xBF`** — el carácter **`¿`** en Windows-1252 | `Serial.h:27` (`#define INIT_FRAME "\xBF"`, verificado leyendo el byte crudo del fichero) |
| **Delimitador de fin** | **`?`** (`0x3F`) | `Serial.h:28` |
| Separador de campos | **`,`** | `Serial.h:36` |
| Volcado | **`L`** | `Serial.h:37` |
| Hora | **`R`** | `Serial.h:34` |
| Calendario | **`C`** | `Serial.h:35` |
| Nº de alarma | **`A`** | `Serial.h:29` |
| Alarma on/off | **`E`** | `Serial.h:30` |
| Hora de inicio | **`I`** | `Serial.h:31` |
| Hora de fin | **`F`** | `Serial.h:32` |
| Días | **`D`** | `Serial.h:33` |

**Códigos de días** (`Alarma.h:21-23`): **`8` = todos los días** · `9` = lunes a viernes · `10` = fin de semana.
**Día de la semana del RTC** (`Alarma.h:13-19`): `1` = lunes … `5` = viernes, `6` = sábado, `7` = domingo.

### 7.2 Las tres reglas que hay que respetar

1. **La trama entera se manda de GOLPE.** El firmware cierra la trama tras **5 ms de silencio** (`Serial.h:21` + `Serial.c:118` + `main.c:84`). Si se teclea letra a letra, cada letra se procesa por separado y **la trama se pierde**. En «Serial Bluetooth Terminal» se escribe entera en la caja de texto y se pulsa enviar una vez; mejor todavía, se guarda como **macro** (M1…M9) y se manda con un solo toque.
2. **Máximo 40 bytes por envío.** El buffer no comprueba desbordamiento (`Serial.c:76`, `Serial.h:24`). Ninguna trama de aquí llega a 25 bytes. **No pegar texto largo.**
3. **Una trama por vez, con ≥ 1 segundo entre trama y trama.** El firmware procesa una sola configuración por ciclo, y cada alarma graba en la EEPROM (`Serial.c:281-287`).

### 7.3 Pedir el volcado

```
¿L?
```

**Qué devuelve** (`Aplicacion.c:291-331`):

```
14:35:12
21/8/26-5

No -    Ini    -   Fin    - On - Dias

 1   - 6:0   - 9:0  - ON - Dia
 2   - 11:30   - 13:30  - ON - Dia
 3   - 15:0   - 16:30  - ON - Dia
 4   - 0:0   - 0:0  - OFF - Dia
 5   - 0:0   - 0:0  - OFF - Dia
```

> **Ojo con los ceros.** El firmware imprime con `%d`, no con `%02d` (`Aplicacion.c:292, 306-330`), así que las 6:00 salen como **`6:0`**, no como `06:00`. **Está bien. No es un fallo.**

### 7.4 Poner en hora

**Formato:** `¿R` + `HHMM` + `,C` + `DDMMAA` + `-` + `W` + `?`

- `HHMM` — hora en 24 h, **cuatro dígitos con cero delante** (`Serial.c:495-518`, `extraerHora` lee posiciones fijas).
- `DDMMAA` — día, mes y año **de dos dígitos cada uno** (`Serial.c:521-560`, `extraerCalendar` lee posiciones fijas).
- `W` — día de la semana, **un dígito**: `1` = lunes … `7` = domingo.

**Ejemplo — viernes 21 de agosto de 2026, 14:35:**

```
¿R1435,C210826-5?
```

> El firmware escribe **los segundos a 0** siempre (`Serial.c:174`: `escribirRTC(hora, min, 0, ...)`).
> **El formato de posición fija es estricto:** `¿R635,...` (sin el cero) **se interpreta mal**. Siempre cuatro dígitos.

### 7.5 Programar los tres horarios de la chapa

La chapa dice **6:00–9:00 · 11:30–13:30 · 15:00–16:30**, **todos los días → código `8`**.

**Enviar estas cinco tramas, una por una, con al menos 1 segundo entre ellas:**

```
¿A1,E1,I0600,F0900,D8,?
¿A2,E1,I1130,F1330,D8,?
¿A3,E1,I1500,F1630,D8,?
¿A4,E0,?
¿A5,E0,?
```

Las dos últimas **apagan** las alarmas 4 y 5, que no se usan. Si se dejan sin tocar podrían conservar valores antiguos en la EEPROM y encender la baliza a horas equivocadas.

**Desglose de la primera trama:**

| Trozo | Qué es |
|---|---|
| `¿` | inicio (`0xBF`) |
| `A1` | alarma número **1** |
| `,E1` | **encendida** (`E0` = apagada) |
| `,I0600` | inicio **06:00** |
| `,F0900` | fin **09:00** |
| `,D8` | **todos los días** |
| `,` | **coma obligatoria antes del `?`** — ver aviso |
| `?` | fin |

> **🔴 La coma antes del `?` NO es opcional.** `extraerFrame(bufferRx, buffer2, "D", ",")` (`Serial.c:205`) recorre desde la `D` **hasta encontrar una coma**. Si la trama termina en `D8?`, la función se sale del buffer buscando una coma que no existe y lee memoria basura. La app oficial también la pone (`MainActivity2.java:208`: `...+",D"+sAlarmD+",?\n\r"`). **Siempre `D8,?`.**

**Verificación obligatoria:** después de las cinco tramas, esperar 2 s y enviar `¿L?`. **Comprobar en el volcado que los tres horarios están y marcan `ON`.** Es la **única** confirmación disponible: el pitido de acuse (`oneBeep()`, `Aplicacion.c:175-188`) no suena en esta tarjeta por los defectos **C1** y **C2** de `HARDWARE.md`.

### 7.6 El problema del byte `0xBF`, y cómo resolverlo

Muchos terminales serie **no dejan escribir directamente el byte `0xBF`**: el teclado del móvil no tiene `¿` a mano, o el terminal lo convierte a otra cosa. **Tres salidas, de más cómoda a menos:**

**Salida 1 — Escribir el `¿` normal (funciona en la mayoría de los casos).**
En un teclado Android, `¿` está en el teclado de símbolos (pulsación larga sobre `?`). Da igual si el terminal lo envía como **UTF-8** (`0xC2 0xBF`, dos bytes) o como **Windows-1252/Latin-1** (`0xBF`, un byte): el firmware busca la **subcadena** `0xBF` con `strstr` (`Serial.c:148`), y el `0xC2` sobrante no le molesta. **Es exactamente lo que hace la app oficial** (§5.4d). ✅

**Salida 2 — Modo HEX del terminal (la más segura).**
«Serial Bluetooth Terminal» tiene conmutador **TEXT / HEX**. En HEX se escriben los bytes en hexadecimal separados por espacios. Las tramas quedan:

| Trama | En HEX |
|---|---|
| `¿L?` | `BF 4C 3F` |
| `¿R1435,C210826-5?` | `BF 52 31 34 33 35 2C 43 32 31 30 38 32 36 2D 35 3F` |
| `¿A1,E1,I0600,F0900,D8,?` | `BF 41 31 2C 45 31 2C 49 30 36 30 30 2C 46 30 39 30 30 2C 44 38 2C 3F` |
| `¿A2,E1,I1130,F1330,D8,?` | `BF 41 32 2C 45 31 2C 49 31 31 33 30 2C 46 31 33 33 30 2C 44 38 2C 3F` |
| `¿A3,E1,I1500,F1630,D8,?` | `BF 41 33 2C 45 31 2C 49 31 35 30 30 2C 46 31 36 33 30 2C 44 38 2C 3F` |
| `¿A4,E0,?` | `BF 41 34 2C 45 30 2C 3F` |
| `¿A5,E0,?` | `BF 41 35 2C 45 30 2C 3F` |

En un PC, **RealTerm** (pestaña *Send* → casilla *Send Numbers*) y **Termite** (plugin *Hex View*) hacen lo mismo.

**Salida 3 — Guardarlas como macros.**
En «Serial Bluetooth Terminal», menú → **Macros**: se pegan las tramas una vez y quedan como botones. Elimina de golpe el problema del `¿`, el de teclear letra a letra (§7.2, regla 1) y el de equivocarse escribiendo en campo con guantes. **Es la forma recomendada de trabajar en la calle.**

> **Ajuste del terminal:** poner el envío en **«sin terminación»** o **«CR+LF»**, indistintamente. El firmware busca el `?` como fin de trama y **los saltos de línea sobrantes no le afectan**: la app oficial también los manda (`MainActivity2.java:408`: `"¿L?\n\r"`). Lo que **sí** importa es que salga todo en un solo envío.

---

## 8. Si el módulo está efectivamente quemado

El objetivo de esta sección es **no tirar módulos buenos** y **no perder días con uno muerto**.

### 8.1 Los tres criterios que deciden, en orden

**Criterio 1 — ¿Enciende el LED?** (Prueba 0, paso 5)
Con 4,75–5,25 V correctamente medidos en sus pines de alimentación:
- **LED enciende o parpadea → el módulo NO está quemado.** Punto. Lo que falle a partir de aquí es configuración.
- **LED apagado del todo → sospecha fuerte.** Ir al criterio 2.

**Criterio 2 — ¿Emite radio?** (Prueba 0, paso 6)
Buscarlo desde los ajustes del teléfono, con la ubicación encendida, durante **2 minutos completos**, y sin ningún otro teléfono cerca con el Bluetooth encendido.
- **Aparece en la lista → el módulo NO está quemado.** El transceptor de radio y la parte digital funcionan.
- **No aparece, y el LED tampoco enciende → muerto.**
- **No aparece, pero el LED SÍ parpadea → NO está quemado.** Está en un modo equivocado: HC-05 en modo maestro, o en modo AT, o ya conectado a otro teléfono (§4, causas 3 y 4). **No tirarlo.**

**Criterio 3 — ¿Cómo se comporta la alimentación?**
Con el polímetro en tensión continua, entre los pines `VCC` y `GND` del módulo:

| Medida | Veredicto |
|---|---|
| **≈ 5 V estables**, módulo frío | Alimentación correcta. El veredicto lo dan los criterios 1 y 2 |
| **La tensión se hunde** al conectar el módulo (< 4 V) | El módulo hace un **corto interno** → **QUEMADO**, con certeza |
| **El módulo se calienta** perceptiblemente | **QUEMADO**, con certeza. Desconectar inmediatamente |
| **0 V** | No llega alimentación. **Problema del cableado o de la tarjeta, no del módulo.** Revisar antes de acusar al módulo |

### 8.2 La tabla que evita tirar módulos buenos

| LED | ¿El teléfono lo ve? | Consumo / temperatura | **Veredicto** |
|---|---|---|---|
| Parpadea | Sí | normal, frío | ✅ **SANO.** Es configuración: baudios, rol o app |
| Parpadea | No | normal, frío | ✅ **SANO, mal configurado.** Modo maestro, modo AT, o cogido por otro teléfono. **NO TIRAR** |
| Fijo | No | normal, frío | ✅ **SANO.** Hay una conexión SPP abierta con otro dispositivo. **NO TIRAR** |
| Apagado | No | tensión se hunde o calienta | ❌ **QUEMADO** |
| Apagado | No | consumo normal, frío, 5 V correctos, 2 min de búsqueda | ❌ **QUEMADO** (o sin firmware) |
| Apagado | No | **0 V en sus pines** | ⚠️ **INDETERMINADO.** No es culpa del módulo: falta alimentación. Arreglar eso y repetir |

### 8.3 Cómo se quema uno de estos módulos, para no repetirlo

Por orden de probabilidad en este caso concreto:

1. **Insertarlo con el pinout girado o permutado** (§4, causa 6). +5 V donde debería ir GND. Muerte en segundos. **Es la hipótesis que mejor explica el «no sabemos si está quemado o está bueno» del cliente.**
2. **Alimentar a 5 V un módulo desnudo de 3,3 V** (sin placa portadora con LDO). El zócalo de esta tarjeta lleva **+5 V fijos** (`HARDWARE.md` §4.1) y eso no se puede cambiar. Cualquier módulo que se compre para esta baliza **tiene que aceptar 5 V en VCC** — el SIG0109A los acepta (3,6–6 V, ficha de Sigma).
3. **Los 5 V del PIC atacando el RXD de 3,3 V del módulo, sin adaptación** (§4, causa 8; `HARDWARE.md` riesgo R7). Mata despacio: semanas o meses. **Explica que el HC-06 funcionara y luego dejara de funcionar.**
4. **Insertarlo o sacarlo con la tarjeta alimentada.** Nunca hacerlo: hay contactos que se tocan en el orden equivocado durante la inserción.

### 8.4 Antes de declarar un módulo muerto

Comprobar los cinco puntos. Con que uno falle, el veredicto no vale:

- [ ] Tensión medida **en los pines del módulo**, no en la fuente: **4,75–5,25 V**.
- [ ] Polaridad verificada con el polímetro **antes** de conectar.
- [ ] Buscado desde los **ajustes del teléfono**, no desde la app de la baliza.
- [ ] **Ubicación del teléfono encendida** (Android 6 en adelante la exige para buscar).
- [ ] **Todos** los demás teléfonos con el Bluetooth apagado, y el módulo re-alimentado justo antes de buscar.

### 8.5 Y si hay que reponerlo

Con la tarjeta fija, el módulo de repuesto tiene que cumplir **todo** esto:

| Requisito | Por qué | Fuente |
|---|---|---|
| **SPP** con UUID `00001101-...` | Es lo que abre la app y lo que abre cualquier terminal serie | `MainActivity2.java:42` |
| **Esclavo** (o configurable como esclavo) | El teléfono es el que inicia la conexión | §4 causa 3 |
| **9600 8N1** de fábrica, o configurable a 9600 **sin el pin KEY** | El PIC está clavado a 9469,7 bd y el pin `EN` del zócalo está al aire | §1, `HARDWARE.md` §10 R26 |
| **VCC de 3,6 a 6 V** (con regulador propio) | El zócalo da **+5 V fijos** | `HARDWARE.md` §4.1 |
| **6 pines a 2,54 mm** en el orden `STATE · RXD · TXD · GND · VCC · EN` | Es la huella de la placa, y no se puede cambiar | `balizaSR30.kicad_pcb`, huella `HC06:HC06` |
| **Emparejamiento con PIN legado** (`1234`) | Es como se ha emparejado siempre | §4 causa 1 |

**Un HC-06 auténtico cumple los seis** (9600 N81 y PIN 1234 de fábrica, esclavo puro, sin modo AT separado). Es lo que ya funcionaba, y **la opción de menor riesgo mientras no se resuelvan las preguntas abiertas de §9**.

**El HC-05 cumple cinco.** Falla en «9600 de fábrica»: su manual oficial dice **38400**, y el rol hay que forzarlo a `ROLE=0`. Las dos cosas se arreglan por AT, pero **sólo fuera de la tarjeta**, porque el pin KEY del zócalo está al aire.

**El SIG0109A cumple los seis SI Y SÓLO SI es un JDY-31** (§3.3: 9600, PIN 1234, esclavo puro, sin modo AT separado, 3,6–6 V con placa portadora, SPP 3.0). Pero **la equivalencia no está confirmada y el orden de pines está en disputa** — y ese último punto es el que decide si funciona o si se quema al enchufarlo. **Confirmar el pinout antes de comprar más unidades.**

---

## 9. Preguntas abiertas

Redactadas como preguntas concretas y accionables. Ninguna es una suposición: son datos que **no están** en la documentación disponible y que hay que **pedir o medir**.

### A pedir a Sigma Electrónica (soporte técnico, sobre el SIG0109A)

1. **¿Cuál es el orden exacto de los 6 pines de la placa del SIG0109A?** Se necesita la secuencia literal de un extremo al otro. La tarjeta tiene el zócalo cableado como `STATE · RXD · TXD · GND · VCC · EN` a 2,54 mm. **Hay una contradicción documentada** (§3.3): el manual del JDY-31 da ese mismo orden, pero una fuente de terceros con foto de la placa real da `STATE · TXD · RXD · **VCC · GND** · EN`, con **VCC y GND intercambiados**. **Si es el segundo, el módulo se destruye al insertarlo.** — *Es la pregunta más urgente de todo el documento: bloquea cualquier prueba con este módulo, y se puede responder en un minuto mirando la serigrafía.*
1b. **¿El SIG0109A es un JDY-31 (alias «SPP-C») reetiquetado?** Coincide con él en chip (BK3231S), versión Bluetooth (3.0) y alimentación (3,6–6 V), pero **Sigma no publica el modelo**. Si Sigma lo confirma, **el manual del JDY-31 responde por sí solo las preguntas 2, 3, 4 y 7** (§3.3). La forma barata de comprobarlo sin preguntar a nadie: enviar `AT+VERSION\r\n` a 9600 y ver si contesta `+VERSION=JDY-31-…` (§6, Prueba 2, método B).
2. **¿A qué velocidad de UART arranca el SIG0109A de fábrica?** La ficha del producto no lo indica y el `BK3231_ARM968E-S.pdf` es la hoja del SoC, no la del módulo (§3.2). *(Si es un JDY-31: 9600 — pero eso hay que confirmarlo, no darlo por hecho.)*
3. **¿Qué juego de comandos AT acepta, y cómo se entra en modo comando?** ¿Hace falta un pin a nivel alto, como el KEY del HC-05, o se aceptan comandos en línea? ¿Terminados en CR+LF o sin terminador? Se necesita **el manual del módulo, no la hoja del chip**. *(Si es un JDY-31: 9 comandos, con `\r\n`, sin modo separado.)*
4. **¿Cuál es el PIN de emparejamiento por defecto y el nombre Bluetooth por defecto?** *(Si es un JDY-31: PIN `1234`, nombre `JDY-31-SPP`.)*
5. **¿El pin RXD del módulo tolera 5 V?** ¿Lleva la placa divisor o resistencia serie hacia el SoC? El BK3231 admite `VIH` máximo `VCC+0,3 V` con `VCC ≤ 3,6 V` (`BK3231_ARM968E-S.pdf`, Tabla 2), y para el JDY-31 las fuentes de terceros dicen explícitamente que **RX y TX siguen siendo de 3,3 V** pese a que VCC acepte 5 V. **En esta tarjeta el pin `MCU_TX` del PIC ataca ese RXD directamente a 5 V, sin adaptación** (`HARDWARE.md` riesgo R7). **Mientras no haya respuesta, asumir que NO tolera 5 V** y poner la resistencia serie de 1 kΩ (pregunta 13).
6. **¿El SIG0109A expone el perfil SPP de forma estándar?** El SoC BK3231 se describe como un chip **HID**, con SPP «*by request*» (`BK3231_ARM968E-S.pdf`, p. 3). La app abre el UUID `00001101-0000-1000-8000-00805F9B34FB` (`MainActivity2.java:42`) y **no funcionará con un módulo que sólo exponga HID**. *(El JDY-31 sí es SPP; Sigma también dice SPP en la ficha. Riesgo bajo, pero conviene cerrarlo.)*
7. **¿Es esclavo puro, o tiene rol configurable?** *(Si es un JDY-31: esclavo puro, sin `AT+ROLE` — y entonces la causa 3 de §4 no le aplica.)*

### A medir en el taller

8. **¿A qué velocidad está realmente el HC-05 que tienen?** → **Prueba 2, método A**. Es el dato que decide si el problema es de baudios o de otra cosa, y no cuesta más de 15 minutos. **Sospechar de 38400**: es lo que dice el manual oficial del HC-05 como valor de fábrica, aunque las placas del mercado suelan venir a 9600 (§3).
9. **¿Cuál es el rol del HC-05 (`AT+ROLE?`)?** → **Prueba 2, método B**, con el USB-TTL y el pin KEY a alto. Un `1` explicaría por sí solo que el teléfono no lo vea.
10. **¿El módulo HC-06 que funcionaba sigue vivo?** → **Prueba 0**. Si sigue vivo, es la referencia contra la que comparar todo lo demás, y además permite dejar la baliza operativa hoy mismo mientras se resuelve el resto.
11. **¿Qué versión de Android tiene el teléfono que se usa en campo, y qué APK tiene instalado?** El APK del repositorio (`app/release/Baliza.apk`) es `targetSdk 30` y funciona en cualquier versión (§5.3). **Si el teléfono tiene instalada una recompilación posterior con `targetSdk ≥ 31`, la app se cerrará sola.** Verificar en Ajustes → Aplicaciones → Baliza → versión, y contrastar con la `versionName 1.0` / `versionCode 1` del APK del repositorio.
12. **¿Qué variante de módulo era el HC-06 original?** ¿Placa portadora ZS-040/JY-MCU con LDO, o módulo desnudo? Determina si los 5 V del zócalo eran ya un riesgo (`HARDWARE.md` §10 R7 y §12, pregunta 5). Si queda alguno, fotografiarlo por las dos caras.

### A decidir internamente

13. **¿Se acepta intercalar una resistencia serie de 1 kΩ en el hilo `MCU_TX` del cableado del módulo?** No es una modificación de la PCB — es un componente en el conector del módulo. Protege el RXD de 3,3 V de los 5 V del PIC y elimina la causa más probable de mortalidad a medio plazo (§4, causa 8). **Sin ella, el módulo nuevo tiene la misma esperanza de vida que el que ya falló.**
14. **¿Se mantiene el HC-06 como pieza de repuesto oficial?** Es el único de los tres que cumple los seis requisitos de §8.5 **sin ninguna pregunta abierta**. Hasta que Sigma conteste las preguntas 1 a 7, es la opción de menor riesgo para dejar balizas operativas en la calle.

---

## Anexo — Resumen de una página para llevar al campo

**Regla 1:** El módulo tiene que estar a **9600 8N1**. Si no, no hay nada que hacer.
**Regla 2:** El emparejamiento se hace **desde los ajustes del teléfono**, nunca desde la app.
**Regla 3:** La app **sólo lista lo ya emparejado**. Si no está emparejado, no aparece.
**Regla 4:** Antes de enchufar un módulo nuevo, **comparar el orden de sus 6 pines** con `STATE · RXD · TXD · GND · VCC · EN`. Hay fuentes que dan `VCC` y `GND` intercambiados: si es el caso, **se quema**.
**Regla 5:** Las tramas se mandan **de golpe**, no letra a letra.
**Regla 6:** Recompilar el firmware **no arregla nada**.
**Regla 7:** El módulo **no se llama «HC-06»**. De fábrica: HC-06 → `linvor`; HC-05 → `HC-05`; SIG0109A → probablemente `JDY-31-SPP`. Buscar el nombre viejo y no encontrarlo no es una avería.
**Regla 8:** Para buscar por Bluetooth, el teléfono necesita la **Ubicación ENCENDIDA**, no sólo el permiso concedido.

**Orden de las pruebas:** 0 (módulo solo) → 1 (loopback) → 2 (baudios) → 3 (en la tarjeta) → 4 (con la app). **En ese orden, sin saltarse ninguna.**

**Lo que tiene que salir en la Prueba 3:** `BALIZA ALARMA V1.0`, a los ~7 segundos de dar tensión.
- Legible → **los baudios son 9600**, todo el enlace funciona.
- Basura → **los baudios NO son 9600**.
- Nada → cableado, alimentación o el PIC no arranca.

**Tramas para la chapa (6:00–9:00 · 11:30–13:30 · 15:00–16:30, todos los días):**

```
¿R1435,C210826-5?            ← poner en hora (HHMM, DDMMAA-díaSemana)
¿A1,E1,I0600,F0900,D8,?
¿A2,E1,I1130,F1330,D8,?
¿A3,E1,I1500,F1630,D8,?
¿A4,E0,?
¿A5,E0,?
¿L?                          ← verificar SIEMPRE al final
```

Una por vez, ≥ 1 segundo entre ellas, **cada una en un solo envío**. La coma antes del `?` es obligatoria.
