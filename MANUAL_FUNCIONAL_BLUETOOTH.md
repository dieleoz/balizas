# Manual funcional — Configuración y validación del módulo Bluetooth

**Equipo:** Baliza intermitente de señal vial «30 CUANDO ACTIVADA» — zona escolar
**Tarjeta:** `BALIZA_SR30` · PIC18F2550
**Documento:** hoja de trabajo de banco. Configurar y validar el módulo Bluetooth **antes** de montarlo en la señal.
**Versión:** 1.0 · 21 de agosto de 2026

---

## 🔴 PASO 0 — ANTES DE ALIMENTAR NADA: COMPARA LA SERIGRAFÍA CON EL ZÓCALO

> ### Esto va primero porque puede destruir el módulo en el instante en que le des tensión.
> **Tarda un minuto. Es gratis. Hazlo con TODOS los módulos, y muy especialmente con el SIG0109A.**

**Hay una contradicción documentada en el orden de los 6 pines del módulo SIG0109A**, y una de las dos versiones **mata el módulo al enchufarlo** en el zócalo de esta tarjeta.

| Fuente | Orden de los 6 pines |
|---|---|
| Tabla del manual del JDY-31 **[DS]** | `STATE · RXD · TXD · **GND · VCC** · EN` |
| Martyn Currey, **foto de la placa real** **[M]** | `STATE · TXD · RXD · **VCC · GND** · EN` |
| **Zócalo `U2` de la baliza** (`balizaSR30.kicad_pcb`) | `STATE · RXD · TXD · **GND · VCC** · EN` |

**Las dos fuentes discrepan en dos permutaciones a la vez: `RXD`↔`TXD` y — lo grave — `GND`↔`VCC`.**

> **Si la placa que has comprado lleva el orden de la segunda fila y la insertas en el zócalo, los +5 V entran por el pin `GND` del módulo y la masa por su `VCC`. Muerte instantánea, sin aviso y sin humo.**
>
> **Esto explicaría por sí solo un módulo que «no se sabe si está quemado».**

### Lo que tienes que hacer, con el módulo en la mano y sin alimentar

- [ ] **0.1** Coge el módulo y **lee la serigrafía de sus 6 pines**, de un extremo al otro. Anótala en un papel tal cual está escrita.
- [ ] **0.2** Compárala pin a pin con la del zócalo `U2`: `1=STATE · 2=RXD · 3=TXD · 4=GND · 5=VCC · 6=EN`.
- [ ] **0.3** **Fíjate especialmente en las posiciones 4 y 5.**

| Lo que lees en el módulo | Qué significa | Qué hacer |
|---|---|---|
| Posición 4 = `GND`, posición 5 = `VCC` | **Coincide con el zócalo** | ✅ Se puede insertar |
| Posición 4 = `VCC`, posición 5 = `GND` | **INVERTIDO. Insertarlo lo destruye** | ⛔ **NO LO INSERTES.** Aparta el módulo y avisa al responsable |
| No se lee la serigrafía | No se puede verificar | ⛔ **NO LO INSERTES.** Ver P20 en §11 |

- [ ] **0.4** **Si hay la menor duda, no lo enchufes.** Verifica primero con el multímetro en modo continuidad, con el módulo fuera y sin alimentar, a qué pin del módulo llega la masa de su propio regulador.
- [ ] **0.5** **Haz una foto de las dos caras del módulo** antes de montarlo. Si luego falla, la foto es la única prueba de qué se montó.

> **Este paso también aplica al HC-05 y al HC-06.** Su orden habitual es distinto entre sí y entre fabricantes. **Nunca supongas el pinout: léelo.**

*Fuentes: [manual JDY-31 (PDF)](https://adastra-soft.com/wp-content/uploads/2021/06/JDY-31_manual_2.pdf) · [Martyn Currey — JDY-31](https://www.martyncurrey.com/jdy-31-spp-bluetooth-module/) · `balizaSR30.kicad_pcb` · análisis completo en `BLUETOOTH.md` §3.3.*

---

## Antes de empezar — lee esto

> ### Cómo leer las marcas de procedencia
>
> Igual que en `BLUETOOTH.md`, cada dato de este manual lleva una marca:
>
> | Marca | Significa |
> |---|---|
> | **[DS]** | Hoja de datos o manual del fabricante. **Dato firme.** |
> | **[M]** | Lo que se observa habitualmente en el mercado. **NO es especificación** — es orientación para empezar a probar |
> | **[?]** | **No confirmado.** Va a §11 «Preguntas abiertas» |
>
> **Los HC-05 y HC-06 se venden desde hace quince años por decenas de fabricantes sin especificación común.** Lo marcado **[M]** hay que **comprobarlo en el ejemplar que tengas delante**, no darlo por bueno.

Este documento **no diagnostica averías**. Configura módulos y los valida. Si un módulo no pasa la validación, este documento te dice cómo apartarlo, no por qué falla.

| Si buscas… | Ve a |
|---|---|
| Cómo está cableado el módulo en la tarjeta, de qué se alimenta | `HARDWARE.md` §2.4 y §5 |
| Por qué el Bluetooth no funciona hoy, análisis de la avería | `BLUETOOTH.md` |
| Cómo se usa la app del móvil, qué tramas manda | `APP_MOVIL.md` |
| **Configurar un módulo nuevo y darlo por bueno** | **este documento** |

### Las tres reglas

1. **El módulo se adapta al equipo. Nunca al revés.** El puerto serie del PIC18F2550 está fijo a **9600 baudios, 8 bits, sin paridad, 1 bit de parada (9600 8N1)**. No se cambia sin recompilar el firmware. Un módulo a cualquier otra velocidad no habla con la baliza.
   *Fuente: `UART.h`, función `UART_init_baud()` → `TXSTAbits.BRGH = 0`, `SPBRG = 32`, `TXSTAbits.SYNC = 0`, `TXSTAbits.TX9 = 0`. Llamada en `main.c:117`. La función **ignora el parámetro que se le pasa** y escribe `SPBRG = 32` a fuego.*

2. **Cada módulo lleva el nombre de su señal.** Es el motivo por el que existe este manual. Ver §4.

3. **Todo se configura en la mesa, antes de montar.** Una vez soldado en la tarjeta **no puedes entrar en modo AT**: el pin `EN`/`KEY` del zócalo `U2` está sin conectar.
   *Fuente: `HARDWARE.md` §2.4 (pin 6 = `EN`, NC) y riesgo R26.*

---

## 1. Material necesario

### 1.1 Imprescindible

- [ ] **1.1** **Adaptador USB–serie (TTL) con selector de 3,3 V / 5 V.**
  Sirve cualquiera basado en **CP2102**, **FT232RL** o **CH340G**. Debe tener jumper o interruptor de nivel.
  **Ponlo en 3,3 V.** El módulo Bluetooth es de 3,3 V en sus patillas de datos.
  Necesitas que saque: `VCC`, `GND`, `TX`, `RX`.

- [ ] **1.2** **Cables Dupont hembra–hembra**, mínimo 5. Colores distintos.

- [ ] **1.3** **Una resistencia de 1 kΩ** (o dos, de 1 kΩ y 2 kΩ, para hacer divisor).
  Va en serie entre el `TX` del adaptador y el `RXD` del módulo. Protege la entrada de 3,3 V del módulo.
  *Motivo: `HARDWARE.md` riesgo R7 — atacar el `RXD` del módulo con 5 V directos es la causa típica de mortalidad prematura.*

- [ ] **1.4** **PC con Windows** y un terminal serie. Recomendado: **Termite** (gratuito, [CompuPhase](https://www.compuphase.com/software_termite.htm)) o **PuTTY**.
  Termite es preferible: muestra lo que llega en crudo y deja elegir si envía `CR`/`LF` o no, que es justo lo que distingue al HC-06 del HC-05.

- [ ] **1.5** **Un móvil Android** con Bluetooth.

- [ ] **1.6** **App de terminal Bluetooth en el móvil: «Serial Bluetooth Terminal» de Kai Morich** (Play Store, gratuita).
  **Esta app concreta, no otra.** Es la que permite enviar **bytes en hexadecimal**, y lo vas a necesitar para mandar el byte `0xBF` de las tramas (§8). Un terminal que sólo envíe texto no sirve.

- [ ] **1.7** **La app de la baliza** (`BalizaV10`) instalada en el móvil, para la prueba final.

### 1.2 Para la validación final (paso 6.7 en adelante)

- [ ] **1.8** Una **tarjeta `BALIZA_SR30` con el PIC ya grabado**, para probar el módulo montado.
- [ ] **1.9** **Fuente de 12 V** para alimentar la tarjeta por `J2` (conector Molex KK-396 de 2 vías, serigrafiado `FUENTE / 12V / GND`).
- [ ] **1.10** **Multímetro**, para comprobar tensiones antes de conectar nada.

### 1.3 Para el registro

- [ ] **1.11** **Etiquetas adhesivas** resistentes, y rotulador permanente.
- [ ] **1.12** La **tabla de registro impresa** (§9).
- [ ] **1.13** **Una caja o bolsa marcada «RECHAZADOS»**, separada de la caja de módulos buenos (§10).

---

## 2. Identifica qué módulo tienes en la mano

**Este es el primer error posible y el más caro: tratar un HC-05 como si fuera un HC-06.** Cada familia se configura de forma distinta. Si te equivocas, el módulo no responde y lo darás por muerto sin estarlo.

### 2.1 Tabla de identificación

Mira la **placa portadora** (la placa azul o negra con los pines), no el módulo metálico soldado encima.

| Dato | **HC-06** | **HC-05** | **SIG0109A / clon BK3231S** |
|---|---|---|---|
| **Nº de pines de la tira** | **4** (lo normal) o 6 | **6** (lo normal) | Comprobar en el ejemplar — **dato no confirmado** (P1) |
| **Serigrafía de los pines** | `VCC GND TXD RXD` | `STATE RXD TXD GND VCC EN` (o `KEY` en vez de `EN`) | Comprobar en el ejemplar |
| **Botón pequeño en la placa** | **No** | **Sí, casi siempre** (botón lateral junto a la antena) | Comprobar |
| **Serigrafía de la placa portadora** | `ZS-040`, `JY-MCU`, `HC-06` | `ZS-040`, `HC-05` | `SIG0109A` o sin marca |
| **Chip / etiqueta del módulo metálico** | `HC-06`, `BC417` | `HC-05`, `BC417` | **`BK3231`** o **`BK3231S`** (Beken) |
| **Color de placa típico** | Azul | Azul | Azul o negro |
| **Nombre Bluetooth de fábrica** | **`linvor`** **[DS]** (o `HC-06` en firmware `hc01.com` **[M]**) | `HC-05` **[M]** | **`JDY-31-SPP`** si es un JDY-31 **[DS]** — **[?]** para el SIG0109A (P2) |
| **Velocidad de fábrica (datos)** | **9600 N81** **[DS]** | ⚠️ **El manual oficial dice 38400** **[DS]**; las placas ZS-040 del mercado suelen venir a **9600** **[M]**. **Hay que medirlo** | **9600** si es un JDY-31 **[DS]** — **[?]** para el SIG0109A (P2) |
| **PIN de fábrica** | `1234` **[DS]** | ⚠️ **El manual se contradice: `0000` en portada, `1234` en `AT+PSWD`** **[DS]**. **Prueba los dos** | `1234` si es un JDY-31 **[DS]** — **[?]** (P2) |

> ### ⚠️ Los nombres de fábrica NO son los que la gente espera — y eso parece una avería
>
> **Éste es probablemente el origen del «el móvil no lo reconoce».**
>
> | Módulo | Se anuncia como | **NO** se llama |
> |---|---|---|
> | **HC-06** | **`linvor`** **[DS]** | ~~`HC-06`~~ (salvo firmware `hc01.com`) |
> | **JDY-31 / SIG0109A** | **`JDY-31-SPP`** **[DS]** | ~~`HC-06`~~, ~~`HC-05`~~ |
> | HC-05 | `HC-05` **[M]** | — |
>
> **Buscar «HC-06» en la lista del móvil y no encontrarlo NO es una avería.** El módulo puede estar perfectamente y anunciarse como `linvor` o `JDY-31-SPP`.
> **Antes de dar un módulo por muerto, mira TODOS los nombres que aparezcan en la lista del móvil, no sólo el que esperabas.**
>
> *Fuentes: [Product Data Sheet HC-06, Wavesen Rev 2.2](https://www.electronicoscaldas.com/datasheet/HC-06_Wavesen.pdf) — «Bluetooth name: linvor»; [manual JDY-31 (PDF)](https://adastra-soft.com/wp-content/uploads/2021/06/JDY-31_manual_2.pdf); [Martyn Currey — HC-06 hc01.comV2.0](https://www.martyncurrey.com/hc-06-hc01-comv2-0/).*

> ### ⚠️ La velocidad de fábrica del HC-05: circulan dos valores
>
> - Su **manual oficial** dice **38400** de fábrica, y `AT+ORGL` restaura «*Baud 38400bits/s*» **[DS]**.
> - Las **placas ZS-040** que se venden hoy suelen venir a **9600** en modo datos **[M]**.
>
> **Los dos valores son creíbles. No supongas ninguno: mídelo** con el barrido de §3.4.
> *(El HC-06 y el JDY-31 sí salen a 9600 de fábrica **[DS]**, que ya es la velocidad del PIC.)*

### 2.1.1 ⛔ Módulos que NO sirven — aunque se los vendan como equivalentes

**Esto es lo más peligroso de todo el apartado.** Hay módulos de aspecto casi idéntico, precio parecido y nombre casi igual, que **son de otra tecnología y no pueden funcionar con esta baliza jamás**, por mucho que los configures bien.

La app abre el socket con el UUID `00001101-0000-1000-8000-00805F9B34FB` — **SPP sobre RFCOMM, Bluetooth clásico**. **BLE no tiene SPP.** Son dos pilas distintas y no intercambiables.
*Fuente: `MainActivity2.java`, `MY_UUID` + `createRfcommSocketToServiceRecord()`; [Infineon Community](https://community.infineon.com/t5/PSOC-4/Does-BLE-support-SPP-to-Android-device/td-p/45304) — «There is no SPP profile for BLE; it is confined to BT Classic».*

| Módulo | Chip real | Tecnología | ¿Sirve? |
|---|---|---|---|
| HC-06, HC-05 | CSR BC417 | **SPP clásico** | ✅ **SÍ** |
| JDY-30, **JDY-31**, SPP-C, **BT-06** | **Beken BK3231 / BK3231S** | **SPP clásico** | ✅ **SÍ** |
| **BT05 / BT-05**, **MLT-BT05** | **TI CC2541** | **BLE (GATT)** | ❌ **NO** |
| **AT-09**, **CC41-A** | **TI CC2541** | **BLE (GATT)** | ❌ **NO** |
| **HM-10** | TI CC2540/CC2541 | **BLE (GATT)** | ❌ **NO** |
| **HC-42** | Nordic nRF52832 | **BLE 5.0** | ❌ **NO** |

> ### ⚠️ `BT-05` y `BT-06` se diferencian en un dígito y son cosas distintas
>
> - **`BT-06`** lleva **BK3231** → **SPP clásico** → **sirve**.
> - **`BT-05`** lleva **CC2541** → **BLE** → **NO sirve**.
>
> Un dígito cambia la tecnología por completo. **Lee la serigrafía dos veces.**

**Cómo salir de dudas en 30 segundos:** enciende el módulo y búscalo desde el móvil en la pantalla **normal** de Bluetooth de Android (Ajustes → Bluetooth).
- Si **aparece ahí** → es Bluetooth clásico → puede servir.
- Si **sólo aparece en una app de escaneo BLE** (nRF Connect) y **nunca** en la lista normal → es BLE → **no sirve. Recházalo.**

*Fuentes: [JDY-30 = BK3231, JDY-31 = BK3231S (desmontaje)](https://adastra-soft.com/some-information-about-the-jdy-31-bluetooth-module/); [MLT-BT05 = CC2541 (desmontaje fotográfico)](https://blog.yavilevich.com/2017/03/mlt-bt05-ble-module-a-clone-of-a-clone/); [Martyn Currey — HM-10 es BLE y no conecta con clásico](https://www.martyncurrey.com/hm-10-bluetooth-4ble-modules/); [HC-42 datasheet oficial (nRF52832, BLE 5.0)](https://www.hc01.com/downloads/HC-42%20english%20datasheet.pdf); [Martyn Currey — Bluetooth modules (SPP-C/BT-06 = BK3231)](https://www.martyncurrey.com/bluetooth-modules/).*

> **La marca decisiva es el botón.** Si la placa tiene un **botón pequeño** y un pin marcado `EN` o `KEY`, es un **HC-05**. Si no tiene botón y sólo hay 4 pines, es un **HC-06**.

> **La segunda marca decisiva es el chip.** Si en el módulo metálico pone **`BK3231S`**, no es ni HC-05 ni HC-06 aunque se venda como reemplazo. Ve directo a §3.3 y lee la advertencia.

### 2.2 Comprobación rápida por comportamiento

Si la serigrafía no se lee, aliméntalo (§5) y mira el LED:

- Parpadeo **rápido**, unas 5 veces por segundo → HC-06 o HC-05 en modo normal, esperando conexión.
- Parpadeo **lento**, unos 2 s encendido y 2 s apagado → HC-05 **ya en modo AT** (alguien dejó `KEY` en alto).

- [ ] **2.1** Anota la familia del módulo en la tabla de registro (§9), columna «Familia».

---

## 3. Entrar en modo de configuración (modo AT)

### 3.0 Montaje común de banco

Haz esto para cualquier familia. **Con el USB desconectado.**

```
  Adaptador USB-serie              Módulo Bluetooth
  (jumper en 3,3 V)

      3V3  ──────────────────────  VCC
      GND  ──────────────────────  GND
       TX  ────[ 1 kΩ ]─────────── RXD
       RX  ──────────────────────  TXD
```

- [ ] **3.0.1** Jumper del adaptador en **3,3 V**. Verifícalo con el multímetro entre `VCC` y `GND` antes de conectar el módulo: debe leer **3,2–3,4 V**.
- [ ] **3.0.2** **`TX` del adaptador va a `RXD` del módulo. `RX` va a `TXD`.** Cruzados. Si los conectas en paralelo no responde nada.
- [ ] **3.0.3** Resistencia de 1 kΩ en serie en la línea `TX → RXD`.
- [ ] **3.0.4** Conecta el USB. El LED del módulo debe encenderse o parpadear.

---

### 3.1 HC-06 — no tiene modo AT separado

El HC-06 **acepta comandos AT siempre que no esté conectado a nadie**. No hay que hacer nada especial: si el LED parpadea rápido, está listo para recibir comandos.

**Lo que hay que saber, y es donde falla la gente:**

- Los comandos van **SIN retorno de carro y SIN salto de línea**. Nada de `\r\n`.
- Van en **MAYÚSCULAS**.
- Hay que **esperar aproximadamente 1 segundo entre comando y comando**.
- La velocidad del puerto es la **misma en datos que en comandos** (de fábrica, 9600).

*Fuente: [Martyn Currey — The Complete Guide To The HC-06](https://www.martyncurrey.com/the-complete-guide-to-the-hc-06/) («commands to be uppercase without line endings, so no `\r\n` characters»).*

**Procedimiento:**

- [ ] **3.1.1** Abre Termite. Puerto COM del adaptador. **9600 8N1**.
- [ ] **3.1.2** En Termite, en «Transmitted text», selecciona **«Append nothing»**. Esto es lo que quita el `\r\n`.
- [ ] **3.1.3** Escribe `AT` y pulsa Enter.
- [ ] **3.1.4** **Tienes que ver: `OK`**
  - Si ves `OK` → estás dentro. Sigue a §4.
  - Si no ves nada → prueba otras velocidades (§3.4).
  - Si ves caracteres raros → velocidad equivocada (§3.4).

- [ ] **3.1.5** Escribe `AT+VERSION`. Debes ver algo como `linvorV1.8` o `hc01.comV2.0`. **Anótalo en el registro.** Identifica el firmware (tabla completa en §3.5).

**Por qué no lleva terminador, dicho por el fabricante:**

> *«Please pay attention to that the command of HC-04/HC-06 **doesn't have terminator**. For example, consider the call command, **sending out AT is already enough, need not add the CRLF**.»*
> *«**Do not let the sending frequency of AT command of HC-06 exceed 1Hz, because the command of HC-06 end or not is determined by the time interval.**»*
> — [Manual oficial Wavesen](https://www.electronicoscaldas.com/datasheet/HC-Serial-Bluetooth-Products-User-Instructional-Manual_Wavesen.pdf)

**El HC-06 sabe que un comando ha terminado porque la línea se queda callada.** De ahí las dos reglas: sin `\r\n`, y ~1 s entre comandos.

> **Consecuencia práctica: no teclees los comandos letra a letra.** Si escribes despacio, el módulo parte el comando por la mitad. **Escribe el comando en un bloc de notas, cópialo y pégalo en el terminal.** Es la forma fiable.

- [ ] **3.1.6** **El HC-06 sólo acepta comandos AT si NO está conectado a nadie.** Si el LED está fijo, desconecta el móvil primero.
  *Manual Wavesen: «During the communication mode, the module can't enter to the AT mode.»*

#### 3.1.1 ⚠️ Aviso — hay HC-06 recientes que se comportan como HC-05

**Lotes recientes de HC-06 vienen con firmware versión 3.x, que NO sigue las reglas de arriba: exige `\r\n` como el HC-05.**

> *«Recent batches of HC-06 appear to have HC-05 firmware (reporting Version 3). There is no documentation of a Version 3 firmware for HC-06. **AT commands differ for HC-05 firmware, including CR+NL command terminators.**»*
> — [HC06_AT_CommandCenter](https://github.com/ndroid/HC06_AT_CommandCenter)

**Cómo saberlo, sin teoría:**

- [ ] **3.1.7** Si `AT` **sin** terminador no contesta, **prueba `AT` con `\r\n`** («Append CR-LF» en Termite) antes de dar el módulo por malo.
- [ ] **3.1.8** Otro indicio: mide cuánto tarda en contestar. **Firmware 1.x tarda ~500 ms** (termina por silencio). **Firmware 3.x contesta en ~10–25 ms** (termina por el salto de línea).
- [ ] **3.1.9** Si resulta ser firmware 3.x, **usa los comandos del HC-05** (§3.2 y chuleta §7), aunque en la placa ponga `HC-06`. **Anótalo en el registro.**

---

### 3.2 HC-05 — necesita el pin KEY en alto AL ALIMENTAR

**Este es el apartado que más confusión causa. Léelo entero antes de tocar nada.**

#### Las dos velocidades — el error más común

El HC-05 tiene **dos velocidades distintas y ambas son normales**:

| Modo | Velocidad | Cuándo |
|---|---|---|
| **Modo datos** (normal) | **9600** (de fábrica) | Uso normal, hablando con la baliza |
| **Modo AT** (configuración) | **38400** | Sólo mientras `KEY` está en alto |

> **Lo que pasa y desconcierta:** configuras el módulo a 9600 en modo datos, entras en modo AT, y de repente no responde. No está roto: en modo AT habla a **38400**, no a 9600. Tienes que **cambiar la velocidad del terminal a 38400** para hablarle en modo AT, y volver a 9600 para probarlo en modo datos.

#### Cómo entrar

Hay dos formas. La del botón es la que funciona siempre.

> ### ⚠️ El pin `KEY` hay que MANTENERLO en alto, no darle un toque
>
> El fabricante lo dice con todas las letras:
> > *«Note: **if PIN34 keep high level, all the commands in the AT command set can be in application. Otherwise, if just excite PIN34 with high level but not keep, only some command can be used.**»*
> > — [Manual oficial Wavesen](https://www.electronicoscaldas.com/datasheet/HC-Serial-Bluetooth-Products-User-Instructional-Manual_Wavesen.pdf)
>
> **Si sueltas el botón, sigues teniendo modo AT pero sólo con parte de los comandos.** `AT` responde `OK` y parece que todo va bien, pero **`AT+NAME?` falla con `FAIL`** y no puedes releer lo que has configurado — que es justo el paso 6.3 de la validación.
>
> **Por eso, para configurar: mantén el botón pulsado, o cablea `KEY` a `3V3` de forma permanente durante toda la sesión.**

**Forma A — con el botón (recomendada):**

- [ ] **3.2.1** Desconecta el USB.
- [ ] **3.2.2** **Mantén pulsado el botón pequeño** de la placa.
- [ ] **3.2.3** **Sin soltarlo**, conecta el USB.
- [ ] **3.2.4** **Tienes que ver: el LED parpadeando LENTO**, unos 2 s encendido / 2 s apagado (onda cuadrada de 1 Hz en el pin 31).
  - Si parpadea rápido (5 veces por segundo) → **no entró en modo AT**. Repite desde 3.2.1.
- [ ] **3.2.5** **Mantén el botón pulsado durante toda la configuración** (§5), o sujétalo con cinta. Si lo sueltas, `AT+NAME?` dejará de funcionar.
  *Si te resulta incómodo, usa la Forma B: deja `KEY` cableado a `3V3` y así no dependes del botón.*

> **Hay dos formas de entrar, y dan velocidades distintas.** El fabricante las describe así:
> - **Vía 1 (la buena):** alimentar **y** poner `KEY` en alto **a la vez** → modo AT a **38400**. *«Way1 is recommended.»*
> - **Vía 2:** alimentar primero y subir `KEY` después → modo AT a **9600**.
>
> **Usa siempre la Vía 1 (botón pulsado antes de alimentar) y habla a 38400.** Si por error usaste la Vía 2 y no responde a 38400, prueba a 9600 antes de dar el módulo por malo.

**Forma B — cableando KEY (si la placa no tiene botón o el botón no funciona):**

- [ ] **3.2.6** Con el USB desconectado, conecta el pin `EN` (o `KEY`) del módulo a `3V3`.
- [ ] **3.2.7** Conecta el USB. Comprueba el parpadeo lento igual que en 3.2.5.

> **Aviso:** en algunas placas `ZS-040` el pin serigrafiado `EN` **no** va al `KEY` del módulo, sino a la habilitación del regulador. Si la Forma B no funciona, usa la Forma A. **Cuál de las dos cosas hace el pin `EN` en los ejemplares que tenemos: no confirmado (P3).**

#### Hablar con él

- [ ] **3.2.8** En Termite, cambia la velocidad a **38400 8N1**.
- [ ] **3.2.9** En «Transmitted text», selecciona **«Append CR-LF»**. **El HC-05 SÍ necesita `\r\n`**, al revés que el HC-06.
- [ ] **3.2.10** Escribe `AT` y pulsa Enter.
- [ ] **3.2.11** **Tienes que ver: `OK`**
- [ ] **3.2.12** Escribe `AT+VERSION?`. Verás algo como `+VERSION:2.0-20100601` seguido de `OK`. **Anótalo.**

*Fuentes: [Last Minute Engineers — Configuring the HC-05 using AT commands](https://lastminuteengineers.com/hc05-at-commands-tutorial/); [HC-05 AT Command Set (PDF)](https://s3-sa-east-1.amazonaws.com/robocore-lojavirtual/709/HC-05_ATCommandSet.pdf); [DCC-EX — HC-05/06 Bluetooth Modules](https://dcc-ex.com/reference/hardware/bluetooth/hc-05-06.html).*

---

### 3.3 SIG0109A / BK3231S — PROCEDIMIENTO A DETERMINAR

> ## ⛔ NO CONFIGURES ESTE MÓDULO TODAVÍA
>
> **No se conoce su juego de comandos AT, y no voy a inventarlo.** Un comando inventado en este manual haría que alguien diera por bueno un módulo que no quedó configurado, y ese módulo acabaría en una señal de colegio.

**Qué se ha comprobado, y qué salió:**

1. **El único PDF que el proveedor publica es el datasheet del chip, y no trae comandos AT.**
   La ficha de producto de Sigma Electrónica enlaza a `/wp-content/uploads/2019/01/BK3231_ARM968E-S.pdf`, que es **el mismo fichero** que tenemos en `D:\@Proyect\Baliza\5 HW bluetooth\BK3231_ARM968E-S.pdf`.
   Se ha leído entero (30 páginas). Es el **«BK3231 Bluetooth HID SoC — Datasheet — Preliminary Specification»** de **Beken Corporation**, fechado *Sep-2014*.
   **Búsqueda exhaustiva de `AT+`, `AT command`, `command set`, `pincode`, `pairing`: cero coincidencias. La palabra «command» no aparece ni una sola vez en el documento.**
   Es un datasheet de silicio: documenta registros mapeados en memoria para quien programe el ARM968E-S interno. La sección de UART (§9 del datasheet) describe el periférico a nivel de registro, no un intérprete de comandos.
   *Fuente: `D:\@Proyect\Baliza\5 HW bluetooth\BK3231_ARM968E-S.pdf`, verificado página a página.*

2. **Buena noticia: casi con seguridad SÍ es Bluetooth clásico SPP, que es lo que necesitamos.**
   El BK3231 es un SoC de **Bluetooth 3.0 clásico**, no BLE. **Todos** los módulos comerciales conocidos que lo montan (**JDY-30, JDY-31, SPP-C, BT-06**) son **SPP clásico** y funcionan con apps Android de `BluetoothSocket`/RFCOMM. Además Sigma lo vende explícitamente como reemplazo de HC-05/HC-06, que son SPP.
   **Esto es inferencia sólida, no una declaración del vendedor** — Sigma no dice en ninguna parte qué perfiles expone (P5).

   *Matiz que confunde: el datasheet del chip lo describe como «single-chip Bluetooth 3.0 **HID** device» y sobre SPP sólo dice «other light profile by request» / «it is also possible for other Bluetooth application such as SPP controller». Eso describe el **silicio desnudo**; el perfil lo pone el firmware del módulo, que es justo lo que no está documentado.*

   > **Cuidado con la palabra «BLE» en los manuales de esta familia.** Los manuales del JDY-31 dicen cosas como *«Current after BLE connection: 7.3mA»* y llaman a `AT+NAME` *«BLE broadcast name»*. **Es un error de traducción del fabricante:** el mismo documento dice «Bluetooth 3.0 SPP» y «classic Bluetooth protocol». No lo tomes como que el módulo sea BLE.

3. **Lo que sí bloquea de verdad: sobre el BK3231 conviven DOS firmwares con sintaxis incompatibles entre sí.**

   | Estilo de firmware | Terminador | Ejemplo de nombre | Módulos conocidos |
   |---|---|---|---|
   | **Estilo JDY-31** | **Requiere `\r\n`** | `AT+NAMEBAL-014-N\r\n` | JDY-30, JDY-31 |
   | **Estilo Bolutek / HC-06** | **SIN terminador**, delimita por silencio | `AT+NAMEBAL-014-N` | SPP-C, BT-06 |

   **No hay forma de saber cuál monta el SIG0109A sin probarlo**, y probar a ciegas es justo lo que este manual no debe mandar hacer sin respaldo. De ahí que el procedimiento quede **a determinar**.

   *Fuentes: [manual oficial JDY-31 (PDF)](https://adastra-soft.com/wp-content/uploads/2021/06/JDY-31_manual_2.pdf) — «JDY-31 module serial port send AT command must be added `\r\n`»; [Martyn Currey — JDY-31](https://www.martyncurrey.com/jdy-31-spp-bluetooth-module/) — «it is not a direct replacement though as the AT commands are not identical»; [Martyn Currey — Bluetooth modules](https://www.martyncurrey.com/bluetooth-modules/) para SPP-C/BT-06.*

4. **La ficha de producto de Sigma no aporta los datos que faltan.**
   Confirma únicamente: chip **BK3231 de Beken Corporation**, *«Bluetooth 3.0 compilant»* [sic], **voltaje de trabajo 3,6 V – 6 V**, cristal de 16 MHz, y que es *«posible reemplazo del HC-05 y HC-06»*.
   **No indica** perfiles, pines, velocidad por defecto, nombre de fábrica, PIN de fábrica ni comandos AT.
   *Ojo: la ficha dice «BK3231» en el cuerpo del texto. Que monte la variante **`S`** no está escrito en ninguna parte — sin confirmar (P4).*
   *Fuente: <https://www.sigmaelectronica.net/producto/sig0109a/>*

   > **Pista útil:** el propio Sigma vende aparte el **JDY-31** (<https://www.sigmaelectronica.net/producto/jdy-31/>), con chip «BK3231 Beken» y «Bluetooth 2.0/3.0 SPP». El manual del JDY-31 especifica *«with backplane: 3.6-6V»*, **exactamente los mismos 3,6–6 V** que anuncia el SIG0109A, y la palabra «Proto» de la descripción sugiere placa de adaptación. **Es razonable sospechar que el SIG0109A es un JDY-31 o equivalente, pero es una sospecha, no un dato.** Confirmarlo es parte de la pregunta P4.

### 3.3.A ⭐ Si se confirma que es un JDY-31, el problema está resuelto

**Los módulos BK3231S vendidos como reemplazo de HC-05/HC-06 son la familia comercial JDY-31 / JDY-30 / «SPP-C».** El SIG0109A **coincide con el JDY-31 en las tres cosas que Sigma sí publica**: chip BK3231S, Bluetooth 3.0 y alimentación 3,6–6 V. **Pero Sigma no publica el modelo, así que la equivalencia NO está confirmada** (P4/P1b).

**Si se confirma**, hay manual de fabricante y todo lo siguiente es **[DS]**:

| Dato | Valor según el manual del JDY-31 | Qué significa aquí |
|---|---|---|
| **Baudios de fábrica** | **9600** | ✅ **Ya coincide con el PIC.** Puede que no haya ni que tocarlos |
| **PIN por defecto** | **`1234`** | ✅ Es el primero que hay que probar |
| **Nombre por defecto** | **`JDY-31-SPP`** | ⚠️ **No se llama «HC-06»** |
| **Rol** | **Sólo esclavo** | ✅ No hay modo maestro que pueda estar mal puesto |
| **Modo AT** | **No hay modo separado.** Mismo UART, con la conexión Bluetooth cerrada | ✅ **No hace falta el pin `KEY`** — que en esta tarjeta está al aire |
| **Terminador** | **`\r\n` obligatorio** | ⚠️ Al revés que el HC-06 |
| **Respuestas** | `+OK`, `+NAME=…` | — |
| `AT+VERSION` | `+VERSION=JDY-31-V1.2,Bluetooth V3.0` | **Es la forma de identificarlo con certeza** |
| **Alimentación** | *«with backplane: 3,6–6 V (recomendado 5 V)»* | ✅ Los +5 V del zócalo son correctos **para la placa portadora** |
| **Perfil** | Bluetooth 3.0 **SPP** | ✅ Compatible con el UUID `00001101-…` de la app |

**Los 9 comandos — son todos los que tiene:**

`AT+VERSION` · `AT+RESET` · `AT+DISC` · `AT+LADDR` · `AT+PIN` · `AT+BAUD` · `AT+NAME` · `AT+DEFAULT` · `AT+ENLOG`

> ### ⛔ Los comandos del HC-05 NO funcionan en este módulo
>
> **`AT+ROLE` y `AT+UART` NO EXISTEN aquí.** Tampoco `AT+PSWD`, ni `AT+ORGL`, ni `AT+NAME?` con interrogante.
>
> **Esto importa muchísimo para no tirar módulos buenos:** si alguien coge un SIG0109A, le manda los comandos del HC-05 y no obtiene respuesta, **concluirá que el módulo está muerto**. No lo está: **le está hablando en un idioma que ese módulo no tiene**.
>
> **Antes de rechazar un módulo por «no responde», comprueba que le estás mandando los comandos de SU familia.** Y prueba siempre `AT+VERSION\r\n` a 9600 primero: es el que identifica qué tienes delante.

**La velocidad se cambia con `AT+BAUD` + parámetro** (4=9600, 5=19200, 6=38400, 7=57600, 8=115200, 9=128000) **[DS]**. Para dejarlo en 9600: `AT+BAUD4\r\n`.

*Fuentes: [manual JDY-31 V1.3 (PDF)](https://adastra-soft.com/wp-content/uploads/2021/06/JDY-31_manual_2.pdf) · [Martyn Currey — JDY-31/SPP-C es BK3231S y esclavo](https://www.martyncurrey.com/jdy-31-spp-bluetooth-module/) · [AdAstra-Soft — JDY-30 = BK3231, JDY-31 = BK3231S](https://adastra-soft.com/some-information-about-the-jdy-31-bluetooth-module/). Análisis completo en `BLUETOOTH.md` §3.3.*

**Qué hacer mientras tanto:**

- [ ] **3.3.1** **Aparta los módulos SIG0109A.** No los configures. No los montes. Márcalos como «PENDIENTE PROVEEDOR» y guárdalos separados.
- [ ] **3.3.0** **Antes de nada, haz el PASO 0** (comparar serigrafía). Es el que evita quemarlo.
- [ ] **3.3.2** Usa **HC-05 o HC-06** para los equipos que haya que dejar listos ahora.
- [ ] **3.3.3** Que alguien haga a Sigma Electrónica las preguntas **P4** a **P9** de §11.

> **Si el responsable autoriza sondear un ejemplar** (no es parte del procedimiento aprobado, es trabajo de investigación), el orden razonable sería: a 9600 8N1 y sin conexión Bluetooth activa, mandar `AT+VERSION` **primero con `\r\n`** y, si no hay respuesta, **de nuevo sin terminador** respetando 1 s de silencio antes y después. La respuesta identifica el firmware según la tabla de §3.4.
> **El resultado de ese sondeo hay que traerlo a este manual y documentarlo antes de configurar ningún módulo en serie.**

---

### 3.4 Si el módulo no responde a `AT` — barrido de velocidad

Antes de dar un módulo por muerto, prueba todas las velocidades. Un módulo que alguien configuró antes puede estar a cualquiera.

- [ ] **3.4.1** Prueba, en este orden, cambiando la velocidad en Termite y mandando `AT` en cada una:
  **9600 → 38400 → 115200 → 57600 → 19200 → 4800 → 2400 → 1200**
- [ ] **3.4.2** En cada velocidad, prueba **con `\r\n` y sin `\r\n`**. Son 16 combinaciones. Tardas 5 minutos.
- [ ] **3.4.3** Si responde `OK` en alguna → anota esa velocidad y sigue con §4.
- [ ] **3.4.4** Si no responde en ninguna → el módulo va a §10 (rechazo).

### 3.5 Identificar el firmware por `AT+VERSION` — tabla de referencia

Cuando consigas respuesta, manda `AT+VERSION` (sin `\r\n`) o `AT+VERSION?` (con `\r\n`). **Lo que conteste te dice exactamente qué tienes en la mano.** Anótalo siempre en el registro.

| Respuesta | Módulo | Terminador | ¿Sirve? |
|---|---|---|---|
| `linvorV1.8` | HC-06 antiguo | **Sin terminador** | ✅ Sí |
| `hc01.comV2.0` | HC-06 moderno | **Sin terminador** | ✅ Sí |
| `+VERSION:2.0-20100601` | HC-05 firmware 2.0 | **Con `\r\n`** | ✅ Sí |
| `+VERSION:3.0-20170601` | HC-05 firmware 3.0 | **Con `\r\n`** | ✅ Sí (ver aviso §3.1.1) |
| `+VERSION=JDY-31-V1.2,Bluetooth V3.0` | JDY-31 (BK3231S) | **Con `\r\n`** | ✅ Sí, SPP clásico |
| `BOLUTEK Firmware V2.2, Bluetooth V2.1` | SPP-C / BT-06 (BK3231) | **Sin terminador** | ✅ Sí, SPP clásico |
| `MLT-BT05-V4.x` | MLT-BT05 (CC2541) | Con `\r\n` | ❌ **NO — es BLE** |
| `+VERSION=Firmware V3.0.6,Bluetooth V4.0 LE` | CC41-A (CC2541) | Con `\r\n` | ❌ **NO — es BLE** |

> **Si la respuesta contiene `LE`, `V4.0` o `BT05`, el módulo es BLE: recházalo** (§2.1.1). No pierdas tiempo configurándolo.

> **Parsea con tolerancia.** Hay revisiones de HC-06 que contestan `OKlinvorV1.5` en vez de `linvorV1.8`. Lo que importa es **reconocer la palabra clave** (`linvor`, `hc01`, `JDY`, `BOLUTEK`, `LE`), no que coincida carácter por carácter.

---

## 4. El nombre — por qué existe este manual

### 4.1 El problema

De fábrica, **todos los módulos se llaman igual**: `HC-06`, `HC-05`, `BT05`…

La app del móvil lista los equipos **emparejados** y los muestra por su nombre:

```java
items[i] = blueDev[i].getName() + ": " + blueDev[i].getAddress();
```
*Fuente: `MainActivity2.java`, método `querypaired()`.*

Con **dos señales instaladas en la misma calle**, quien va a reprogramar el horario ve dos entradas llamadas `HC-06` y **no puede saber a cuál se está conectando**. Cargar en una señal escolar el horario de otra es exactamente el fallo que este proyecto no se puede permitir.

> La app muestra también la dirección MAC detrás del nombre, pero **una MAC no se puede leer en campo**: nadie sabe qué poste es `98:D3:31:F5:2C:A1`. El nombre es la única identificación utilizable.

### 4.2 Límite de longitud — comprobado

| Módulo | Límite del nombre | Confianza | Fuente |
|---|---|---|---|
| **HC-06** | **20 caracteres** | **Confirmado** — dos fuentes independientes | [Manual oficial Wavesen](https://www.electronicoscaldas.com/datasheet/HC-Serial-Bluetooth-Products-User-Instructional-Manual_Wavesen.pdf): *«The name should be limited in **20 characters**»* · [Martyn Currey](https://www.martyncurrey.com/the-complete-guide-to-the-hc-06/): *«max 20 characters»* |
| **HC-05** | **32 bytes** documentados; **usa 31 como máximo** | **Confirmado**, con una discrepancia menor | [HC-05 AT Command Set (PDF)](https://s3-sa-east-1.amazonaws.com/robocore-lojavirtual/709/HC-05_ATCommandSet.pdf): *«Length up to **32 bytes**»* · [DCC-EX](https://dcc-ex.com/reference/hardware/bluetooth/hc-05-06.html) dice **31** (probablemente 31 útiles + terminador nulo) |
| **JDY-31 (BK3231S)** | **18 bytes** | Confirmado | [Manual oficial JDY-31](https://adastra-soft.com/wp-content/uploads/2021/06/JDY-31_manual_2.pdf): *«broadcast name is the longest: **18 bytes**»* |
| **SIG0109A** | **Desconocido** | — | (P8) |

**Conclusión operativa: el límite que manda es el más bajo conocido de la familia, 18 caracteres** (JDY-31), y **20 en el HC-06**. Como el SIG0109A no está confirmado, la convención se diseña para caber **muy holgadamente**: **9 caracteres**.

> **El límite teórico del estándar Bluetooth (248 bytes en el campo *Complete Local Name*) es irrelevante aquí.** Los firmwares de estos módulos recortan mucho antes. Y **no está documentado qué hacen al pasarse** — ¿truncan en silencio, devuelven `FAIL`, o corrompen la memoria? Nadie lo dice (P18).
> **Trátalo como límite duro y no te acerques.** Por eso la propuesta usa 9 caracteres y no 19.

**Sobre los caracteres admitidos:**

- **Guiones: confirmados.** El nombre de fábrica del propio HC-05 es `H-C-2010-06-01`, y el documento oficial dice *«Supports special characters»*.
- **Espacios: NO uses.** Ninguna fuente confirma que un espacio sobreviva a `AT+NAME`, y los parsers de estos firmwares suelen cortar ahí. En el HC-06 es peor: como delimita por silencio, cualquier cosa dentro de la ventana de 1 s se toma como parte del nombre.
- **Acentos y `Ñ`: no hay documentación** de qué juego de caracteres admite el HC-06. Evítalos.
- **Mayúsculas:** los comandos del HC-05 son **sensibles a mayúsculas** (*«AT Command is case-sensitive»*). Escríbelos siempre en mayúsculas.

### 4.3 Convención de nombres — ⚠️ PROPUESTA, PENDIENTE DE CONFIRMAR

> **Esto es una propuesta técnica, no una convención acordada.**
> Tiene que aprobarla el responsable del proyecto **antes** de configurar el primer módulo, porque una vez instaladas las señales, renombrar obliga a desmontar cada equipo.
> Ver pregunta **P11** en §11.

**Formato propuesto:**

```
BAL-NNN-D
```

| Parte | Longitud | Contenido | Ejemplo |
|---|---|---|---|
| `BAL` | 3 | Prefijo fijo, igual en todos los equipos | `BAL` |
| `-` | 1 | Separador | `-` |
| `NNN` | 3 | Nº correlativo de la señal en el registro de instalación, `001`–`999` | `014` |
| `-` | 1 | Separador | `-` |
| `D` | 1 | Sentido al que mira la señal: `N`, `S`, `E`, `O` | `N` |
| **Total** | **9** | | **`BAL-014-N`** |

**Por qué así:**

- **`BAL` fijo delante** → en la lista de emparejados del móvil todas las balizas quedan **juntas y ordenadas**, separadas de los auriculares y el coche del técnico.
- **9 caracteres** → cabe con margen en el límite de 20 del HC-06, y en cualquier límite razonable del HC-05 o del clon, que no están confirmados.
- **Número correlativo** → es el que ya identifica la señal en el registro de instalación. **Tiene que coincidir con una etiqueta física pegada en la caja del equipo y con el registro de obra.** Si no hay etiqueta física, el nombre no sirve de nada.
- **Letra de sentido** → resuelve el caso real que motiva todo esto: **dos señales enfrentadas en la misma calle**, con el mismo número de tramo. `BAL-014-N` y `BAL-014-S` se distinguen de un vistazo.
- **Sólo `A–Z`, `0–9` y guion.** Sin espacios, sin acentos, sin `Ñ`:
  - **Sin espacios:** la app concatena el nombre con `": "` para pintarlo, y algunos firmwares de HC-06 cortan el nombre en el primer espacio.
  - **Sin acentos ni `Ñ`:** el nombre viaja como bytes en el anuncio Bluetooth. Los firmwares HC son orientados a byte y pueden truncar a mitad de un carácter multibyte, dejando un nombre corrupto.
  - **Mayúsculas:** se lee mejor en la pantalla del móvil a pleno sol.

**Ejemplos:**

| Nombre | Significa |
|---|---|
| `BAL-001-N` | Baliza 001, señal que mira al norte |
| `BAL-001-S` | Baliza 001, la de enfrente, mira al sur |
| `BAL-047-E` | Baliza 047, mira al este |

**Alternativa, si el responsable prefiere identificar por colegio en vez de por número correlativo:** `BAL-XXX-D` donde `XXX` son tres letras del nombre del centro (`SJU` = San Juan). Cabe igual en 9 caracteres. **Tiene el inconveniente de que dos colegios pueden compartir iniciales**, por eso se propone el número correlativo como opción principal. Decisión del responsable (P11).

---

## 5. Los tres ajustes — en este orden

> **El orden importa.** La velocidad va **la última** porque, en cuanto la cambies, el módulo deja de hablar a la velocidad a la que tienes abierto el terminal.

### 5.1 Ajuste 1 — Nombre

| Familia | Comando | Respuesta esperada |
|---|---|---|
| **HC-06** | `AT+NAMEBAL-014-N` *(sin `\r\n`)* | `OKsetname` |
| **HC-05** | `AT+NAME=BAL-014-N` *(con `\r\n`)* | `OK` |
| **SIG0109A** | **A determinar** — §3.3 | — |

- [ ] **5.1.1** Manda el comando de tu familia, con el nombre que toque según §4.3.
- [ ] **5.1.2** Comprueba la respuesta esperada.
- [ ] **5.1.3** **No te fíes del `OK`.** La comprobación real es releer el nombre, y está en §6.4.

> **HC-06:** el comando **no lleva `=`**. Es `AT+NAMExxxx`, todo pegado.
> **HC-05:** el comando **sí lleva `=`**. Es `AT+NAME=xxxx`.
> Confundirlos es el segundo error más común después de las velocidades.

---

### 5.2 Ajuste 2 — PIN de emparejamiento

| Familia | Comando | Respuesta esperada |
|---|---|---|
| **HC-06** | `AT+PIN2130` *(sin `\r\n`)* | `OKsetPIN` |
| **HC-05** | `AT+PSWD=2130` *(con `\r\n`)* | `OK` |
| **SIG0109A** | **A determinar** — §3.3 | — |

> ### ⚠️ El PIN de fábrica del HC-05: su propio manual se contradice
>
> - La **portada** del manual dice: *«Auto-pairing PINCODE: **"0000"** as default»* **[DS]**
> - Pero la entrada de **`AT+PSWD`** dice *«(Default **1234**)»*, y **`AT+ORGL`** restaura *«pin code: **1234**»* **[DS]**
>
> **Los dos valores están en el mismo documento oficial.** Cuando emparejes un HC-05 que todavía tenga el PIN de fábrica, **prueba `1234` y, si falla, `0000`.** No es un fallo del módulo.
> *(HC-06 y JDY-31: `1234` **[DS]**, sin ambigüedad.)*

**Qué PIN poner: `2130` — ⚠️ PROPUESTA, PENDIENTE DE CONFIRMAR (P12).**

**Por qué cambiarlo del de fábrica:**
- De fábrica es `1234` o `0000`. **Los sabe todo el mundo.**
- Cualquiera con un móvil y la app puede emparejarse con una señal escolar y **cambiarle el horario de encendido**. No hay ninguna otra barrera: el firmware no valida quién manda las tramas.
- Un PIN propio del proyecto no es seguridad de verdad — el emparejamiento heredado de Bluetooth 2.x con PIN fijo es débil y no cifra nada frente a un atacante decidido — pero **elimina al curioso**, que es el riesgo realista aquí.

**Por qué uno solo para todos los equipos, y no uno por equipo:**
- Un PIN por equipo obliga al técnico a llevar una lista encima. Si la pierde, no puede reprogramar. Si la lleva, ya no es secreta.
- Un PIN único de proyecto es el equilibrio razonable. **Decisión del responsable.**

> **Restricción confirmada:** en el HC-06 el PIN debe ser de **4 caracteres numéricos**. *Fuente: [Martyn Currey](https://www.martyncurrey.com/the-complete-guide-to-the-hc-06/) — «The new PIN must be 4 numeric characters».* La propuesta lo respeta.

> **HC-05 — si `AT+PSWD=2130` devuelve `ERROR`, prueba `AT+PSWD="2130"` con comillas.** El documento oficial de comandos acepta **las dos formas** (literal: `AT+PWD=1234\r\n (or AT+PSWD="1234"\r\n)`).
> Hay reportes de módulos con firmware 3.0 en los que el cambio de PIN falla, pero **no está confirmado que la causa sean las comillas** (P17). Por eso: prueba una forma, y si falla, la otra. **Y comprueba siempre releyendo con `AT+PSWD?` (§6.4).**

- [ ] **5.2.1** Manda el comando.
- [ ] **5.2.2** Comprueba la respuesta esperada.
- [ ] **5.2.3** Anota el PIN en el registro.

> ### ⚠️ HC-06 — el PIN nuevo NO se activa hasta descargar el módulo del todo
>
> **Esto explica casi todos los casos de «le cambié el PIN y sigue pidiendo el viejo».** No es un fallo tuyo ni del módulo. Lo dice el fabricante:
>
> > *«User can set a new password for the HC-06 through AT+PINxxxx command. But **the new password will become active after discharged all the energy of the module**. If the module still has any energy, the old one is still active. (…) we can connect the power supply PIN with GND about **20 seconds** after the power is cut off. Generally, **shutting down the device for 30 minutes** also can discharge the energy.»*
> > — [Manual oficial Wavesen](https://www.electronicoscaldas.com/datasheet/HC-Serial-Bluetooth-Products-User-Instructional-Manual_Wavesen.pdf)
>
> **Qué hacer después de `AT+PIN2130` en un HC-06:**
>
> - [ ] **5.2.4** Corta la alimentación del módulo.
> - [ ] **5.2.5** **Puentea `VCC` con `GND` durante 20 segundos** con un cable. Esto descarga los condensadores.
> - [ ] **5.2.6** Quita el puente y vuelve a alimentar.
> - [ ] **5.2.7** **Sólo ahora** el PIN nuevo está activo. Compruébalo emparejando en §6.6.
>
> **Si te saltas este paso, el módulo seguirá pidiendo `1234` y creerás que el comando no funcionó.**
> *(Alternativa sin puente: dejarlo desconectado 30 minutos. El puente es mucho más rápido.)*

---

### 5.3 Ajuste 3 — Velocidad: 9600 8N1

> ### Esto no es negociable
>
> **9600 baudios, 8 bits de datos, sin paridad, 1 bit de parada.**
>
> Es la única velocidad que entiende el PIC. Está escrita a fuego en el firmware:
> `TXSTAbits.BRGH = 0` y `SPBRG = 32` en `UART.h`. Con el cristal de 20 MHz de la tarjeta, eso da
> `20 000 000 / (64 × 33) = 9469 baudios` — un **−1,4 %** frente a 9600, dentro de tolerancia.
> `TXSTAbits.SYNC = 0` (asíncrono) y `TXSTAbits.TX9 = 0` (8 bits) completan el `8N1`.
> Cambiarlo exige **recompilar y regrabar el PIC de cada baliza ya instalada**.
> *Fuentes: `UART.h` función `UART_init_baud()`; `main.c:117`; `HARDWARE.md` §5, fila del pin 17.*

| Familia | Comando | Respuesta esperada |
|---|---|---|
| **HC-06** | `AT+BAUD4` *(sin `\r\n`)* | `OK9600` |
| **HC-05** | `AT+UART=9600,0,0` *(con `\r\n`)* | `OK` |
| **SIG0109A** | **A determinar** — §3.3 | — |

**Tabla `AT+BAUDn` del HC-06** *(fuente: [Martyn Currey](https://www.martyncurrey.com/the-complete-guide-to-the-hc-06/))*:

| n | Baudios | | n | Baudios |
|---|---|---|---|---|
| 1 | 1200 | | 7 | 57600 |
| 2 | 2400 | | 8 | 115200 |
| 3 | 4800 | | 9 | 230400 |
| **4** | **9600 ← el nuestro** | | A | 460800 |
| 5 | 19200 | | B | 921600 |
| 6 | 38400 | | C | 1382400 |

**En el HC-05, `AT+UART=9600,0,0` significa:** 9600 baudios, `0` = 1 bit de parada, `0` = sin paridad. Es el `8N1` que necesitamos.

> ### ⚠️ AVISO — aquí es donde la gente cree que ha roto el módulo
>
> **En cuanto el módulo contesta `OK9600` (o `OK`), YA ESTÁ HABLANDO A LA NUEVA VELOCIDAD.**
> Tu terminal sigue a la vieja. A partir de ese instante, todo lo que escribas devolverá **basura o nada**.
>
> **El módulo no está roto. Está esperándote en la velocidad nueva.**
>
> **Qué hacer:**
> 1. Cierra el puerto en Termite.
> 2. Cambia la velocidad a **9600**.
> 3. Vuelve a abrir el puerto.
> 4. **HC-06:** manda `AT` → debe responder `OK`.
>    **HC-05:** ojo, en **modo AT** el HC-05 sigue hablando a **38400** aunque hayas puesto los datos a 9600. Los 9600 que acabas de programar son para el **modo datos**. Para comprobarlos, sal del modo AT (§6.5).

- [ ] **5.3.1** Manda el comando de velocidad.
- [ ] **5.3.2** Comprueba la respuesta esperada.
- [ ] **5.3.3** Cierra el puerto, cambia a la velocidad nueva, reabre.
- [ ] **5.3.4** Confirma que vuelve a responder.

---

## 6. VALIDACIÓN — hoja de aceptación

**Hazlo en este orden.** Va de menos a más integrado. Si falla un paso, no sigas al siguiente: apunta cuál falló y ve a §10.

Marca cada casilla **sólo cuando hayas visto en pantalla exactamente lo que dice la columna «Tienes que ver»**.

---

### 6.1 El módulo se alimenta y su LED es coherente

- [ ] **6.1.1** Conecta el módulo según §3.0 y alimenta.
- [ ] **6.1.2** Mide con el multímetro entre `VCC` y `GND` del módulo: **3,2–3,4 V**.
- [ ] **6.1.3** Observa el LED durante 10 segundos.

**Qué significa cada parpadeo:**

| Lo que ves | Qué significa | Qué hacer |
|---|---|---|
| **Parpadeo rápido**, ~5 veces por segundo | Modo normal, **sin conexión**, esperando que alguien se empareje. **Es lo correcto en este punto.** | Sigue a 6.2 |
| **Parpadeo lento**, ~2 s ON / 2 s OFF | **HC-05 en modo AT.** Correcto si acabas de entrar en modo AT a propósito. | Correcto para configurar |
| **Fijo encendido** (o doble destello cada 2 s) | **Hay alguien conectado** por Bluetooth | Desconecta el móvil. En este punto no debería haber conexión |
| **Apagado del todo** | No llega alimentación, o el módulo está muerto | Revisa cableado y tensión. Si la tensión es correcta → §10 |

> **Los patrones exactos dependen de la placa portadora.** La regla que siempre se cumple: **rápido = esperando, lento = modo AT (HC-05), fijo = conectado**.
> *Fuente del parpadeo rápido: [Martyn Currey](https://www.martyncurrey.com/the-complete-guide-to-the-hc-06/) — «the LED(s) blink quickly about 5 times a second».*

---

### 6.2 El módulo responde en modo AT

- [ ] **6.2.1** Entra en modo AT según §3.1 (HC-06) o §3.2 (HC-05).
- [ ] **6.2.2** Manda `AT`.
- [ ] **6.2.3** **Tienes que ver: `OK`** (HC-06: sin `\r\n`; HC-05: con `\r\n`, a 38400).

| Si no ves eso | Significa |
|---|---|
| Nada en absoluto | Velocidad equivocada, cables cruzados mal, o `KEY` no está en alto (HC-05). Haz el barrido §3.4 |
| Caracteres sin sentido (`ÿÿ?«`) | **La velocidad no coincide.** Estás hablando, pero en otro idioma. Barrido §3.4 |
| `ERROR` | El módulo está vivo y responde. Es un problema de sintaxis, no de módulo |

---

### 6.3 El nombre quedó cambiado — RELEERLO DEL MÓDULO

> **No te fíes de que el comando contestara `OK`.** Un `OK` sólo dice que el comando se recibió. Hay firmwares que aceptan el comando y truncan el nombre, o lo ignoran. **La única prueba es leerlo de vuelta del módulo.**

| Familia | Comando para releer | Respuesta esperada |
|---|---|---|
| **HC-06** | *No tiene comando de lectura de nombre* → verifícalo en 6.6 desde el móvil | — |
| **HC-05** | `AT+NAME?` | `+NAME:BAL-014-N` seguido de `OK` |

- [ ] **6.3.1** **HC-05:** manda `AT+NAME?`. **Tienes que ver el nombre exacto que pusiste**, carácter por carácter.
- [ ] **6.3.2** **HC-06:** este módulo no permite releer el nombre por AT. **La comprobación del nombre es obligatoriamente el paso 6.6.** No marques este paso; márcalo en 6.6.

| Si no ves eso | Significa |
|---|---|
| Un nombre **más corto** del que pusiste | Se truncó. Acorta el nombre y repite §5.1 |
| El nombre **antiguo** (`HC-05`) | El comando no se aplicó. Repite §5.1. Si vuelve a fallar → §10 |
| Nombre con caracteres raros | Usaste acentos o `Ñ`. Vuelve a §4.3 y usa sólo `A–Z 0–9 -` |

---

### 6.4 La velocidad quedó en 9600 — RELEERLA

- [ ] **6.4.1** **HC-05:** manda `AT+UART?`. **Tienes que ver: `+UART:9600,0,0`** seguido de `OK`.
- [ ] **6.4.2** **HC-05:** manda también `AT+PSWD?`. **Tienes que ver el PIN que pusiste.**
- [ ] **6.4.3** **HC-06:** no tiene comando de lectura. La prueba es indirecta: cierra el terminal, ábrelo **a 9600**, manda `AT`. **Tienes que ver `OK` a 9600.** Si responde a 9600, está a 9600.

| Si no ves eso | Significa |
|---|---|
| `+UART:38400,0,0` u otra | El comando de velocidad no se aplicó. Repite §5.3 |
| No responde a 9600 pero sí a otra | Está a esa otra. Repite §5.3 desde esa velocidad |

---

### 6.5 Prueba de bucle (loopback) — demuestra que transmite Y recibe

> **Por qué esta prueba.** Hasta aquí sólo sabes que el módulo habla con el cable. Esta prueba demuestra que **la radio funciona en los dos sentidos**: lo que escribes en el móvil sale por el `TXD` del módulo, y lo que entra por su `RXD` vuelve al móvil. Es la prueba más valiosa de la lista y la que menos gente hace.

- [ ] **6.5.1** Desconecta el USB.
- [ ] **6.5.2** **Si es HC-05: quita el `KEY` de alto** (suelta el botón / desconecta el cable de `EN`). Tiene que arrancar en **modo datos**, no en modo AT.
- [ ] **6.5.3** **Puentea `TXD` con `RXD` del módulo** con un cable corto. Deja `VCC` y `GND` conectados al adaptador (o a una fuente de 3,3 V).
- [ ] **6.5.4** Alimenta. El LED debe parpadear rápido.
- [ ] **6.5.5** En el móvil, empareja con el módulo (te pedirá el PIN de §5.2).
- [ ] **6.5.6** Abre **Serial Bluetooth Terminal**, conecta al módulo.
- [ ] **6.5.7** Escribe `PRUEBA1234` y envía.

- [ ] **6.5.8** **Tienes que ver: `PRUEBA1234` devuelto en la pantalla del móvil**, exactamente igual, sin caracteres perdidos ni cambiados.

| Lo que ves | Qué significa |
|---|---|
| **El texto vuelve idéntico** | ✅ El módulo transmite y recibe correctamente. **Pasa.** |
| **No vuelve nada** | El puente `TXD`–`RXD` no hace contacto, o el módulo no recibe. Revisa el puente y repite. Si persiste → §10 |
| **Vuelve deformado** (`PRÜB¿12`) | Pérdida de bytes o velocidad inestable. **Módulo sospechoso** → §10 |
| **Vuelve sólo una parte** | Igual que el anterior. **Sospechoso** → §10 |

- [ ] **6.5.9** **Quita el puente `TXD`–`RXD`.** No lo dejes puesto: si montas el módulo con el puente, la baliza no funcionará y perderás una hora buscando por qué.

---

### 6.6 El móvil lo encuentra, lo empareja y lo lista con el nombre nuevo

> **Éste es el paso que valida el objetivo del manual.** Todo lo demás es preparación para éste.

- [ ] **6.6.1** En el móvil, **elimina el emparejamiento anterior** con este módulo, si lo hiciste en 6.5. (Ajustes → Bluetooth → el dispositivo → «Olvidar»). Si no lo borras, Android te enseña el nombre **cacheado antiguo** y creerás que el renombrado falló.
- [ ] **6.6.2** Alimenta el módulo (sin puente, modo datos).

> ### ⚠️ ENCIENDE LA UBICACIÓN DEL MÓVIL — si no, Android no lista NADA
>
> **No basta con conceder el permiso de ubicación a la app.** El **interruptor general de Ubicación del teléfono tiene que estar ENCENDIDO**, o Android **no devuelve ningún dispositivo Bluetooth en el escaneo**, sin dar ningún error que lo explique.
>
> **Es un fallo mudo:** la búsqueda parece funcionar y simplemente no aparece nada. Se confunde con un módulo muerto.
>
> - [ ] **6.6.2b** Ajustes → **Ubicación** → **ACTIVADA**. (No «permiso de la app»: el **interruptor del sistema**.)
> - [ ] **6.6.2c** Comprueba además que la app tiene concedido su permiso de ubicación.
>
> *Confirmado en el código de AOSP. Detalle completo en `BLUETOOTH.md`.*

- [ ] **6.6.3** En el móvil, busca dispositivos Bluetooth nuevos.

- [ ] **6.6.4** **Tienes que ver: el nombre nuevo exacto, por ejemplo `BAL-014-N`.**

| Lo que ves | Qué significa |
|---|---|
| `BAL-014-N` | ✅ Correcto |
| **`linvor`** | **[DS]** Es un **HC-06 con su nombre de fábrica**. El renombrado no se aplicó. Vuelve a §5.1. **El módulo está bien** |
| **`JDY-31-SPP`** | **[DS]** Es un **JDY-31/SIG0109A de fábrica**. El renombrado no se aplicó. **El módulo está bien** |
| `HC-06` / `HC-05` | Nombre de fábrica. El renombrado no se aplicó. Vuelve a §5.1 |
| `BT05` / `MLT-BT05` / `AT-09` | ⛔ **Es un módulo BLE. NO SIRVE.** Ver §2.1.1 y recházalo |
| `BAL-014` (cortado) | Se truncó el nombre. Acorta y repite §5.1 |
| **No aparece nada** | **Comprueba PRIMERO que la Ubicación del móvil está encendida** (recuadro de arriba). Después, alimentación y LED (§6.1) |

> **Antes de dar un módulo por muerto en este paso: lee TODOS los nombres de la lista.** El módulo bueno puede estar ahí con un nombre que no esperabas.

- [ ] **6.6.5** Empareja. **Tienes que ver: te pide un PIN.** Introduce el de §5.2.
- [ ] **6.6.6** **Tienes que ver: «Vinculado» / «Emparejado».**
  - Si dice «PIN incorrecto» → el PIN no se aplicó. Vuelve a §5.2.
- [ ] **6.6.7** Abre la **app de la baliza** (`BalizaV10`), pulsa el botón de dispositivo.
- [ ] **6.6.8** **Tienes que ver: en la lista aparece `BAL-014-N: 98:D3:31:...`**, con el nombre nuevo delante de la MAC.
  - *La app lista sólo dispositivos **ya emparejados** (`getBondedDevices()`). Si no lo emparejaste en 6.6.5, aquí no sale.*

---

### 6.7 Montado en la tarjeta — el equipo tiene que saludar

> **A partir de aquí ya no pruebas el módulo solo: pruebas el conjunto.**

**Cableado del módulo en el zócalo `U2` de la tarjeta** *(fuente: `HARDWARE.md` §2.4)*:

| Pin `U2` | Señal | Va a |
|---|---|---|
| 1 | `STATE` | Sin conectar |
| 2 | `RXD` | ← `MCU_TX` (RC6, pin 17 del PIC) |
| 3 | `TXD` | → `MCU_RX` (RC7, pin 18 del PIC) |
| 4 | `GND` | Masa |
| 5 | `VCC` | ← **+5 V** |
| 6 | `EN` | Sin conectar |

> ### ⚠️ Dos avisos antes de montar
>
> **1. El zócalo alimenta el módulo a 5 V y ataca su `RXD` con 5 V directos, sin resistencia.**
> Las placas portadoras `ZS-040`/`JY-MCU` llevan regulador y aceptan 3,6–6 V en `VCC`, así que la alimentación suele ir bien. **Pero el `RXD` sigue siendo de 3,3 V.**
> *`HARDWARE.md` riesgo **R7** recomienda añadir un divisor 1k/2k en `MCU_TX`, o como mínimo una resistencia serie de 1 kΩ.* **Consúltalo con el responsable antes de montar en serie** (P13).
> El sentido contrario (`TXD` 3,3 V → RC7) sí funciona: el `VIH` del PIC a 5 V es 2,05 V.
>
> **2. Una vez montado no puedes entrar en modo AT.** El pin `EN`/`KEY` está sin conectar (`HARDWARE.md` riesgo R26). Si el módulo no quedó bien configurado, hay que desmontarlo. Por eso todo lo anterior se hace en la mesa.

- [ ] **6.7.1** Con la tarjeta **sin alimentar**, monta el módulo en `U2`. Comprueba la orientación pin a pin con la tabla.
- [ ] **6.7.2** Empareja el móvil con el módulo (si no lo está ya de 6.6).
- [ ] **6.7.3** Abre **Serial Bluetooth Terminal** en el móvil y **conéctate al módulo**.
- [ ] **6.7.4** **Ahora** alimenta la tarjeta con 12 V por `J2`.
- [ ] **6.7.5** Espera **unos 7 segundos**.

- [ ] **6.7.6** **Tienes que ver, en la pantalla del móvil:**

```

BALIZA ALARMA V1.0

```

> *Fuente: `Aplicacion.c`, estado `ST_READ_MEMO_AP`:*
> `transmitUart1((char*)"\n\rBALIZA ALARMA V1.0\n\r\n\r");`
> *El retardo son ~7 s: `TIME_ARRANQUE` = 500 ciclos × `PERIOD_APLICACION` = 10 ms → 5 s, más 200 × 10 ms = 2 s de lectura de memoria. Fuentes: `Aplicacion.h:22,24`.*

**Qué significa lo que veas:**

| Lo que ves | Qué significa | Qué hacer |
|---|---|---|
| **`BALIZA ALARMA V1.0` legible** | ✅ **Todo correcto.** El PIC arranca, transmite, el módulo lo transporta y el móvil lo recibe. Velocidad correcta en toda la cadena | Sigue a 6.8 |
| **Basura ilegible** (`ÿÍ«?â`) | **La velocidad no coincide.** Llegan bits, pero el módulo los está leyendo a otra velocidad. El módulo **no quedó a 9600** | Desmonta. Vuelve a §5.3 y §6.4 |
| **Nada en absoluto** | El PIC no transmite, el módulo no está recibiendo del PIC, o el módulo no está bien montado | Ver tabla siguiente |
| **Sólo unos pocos caracteres sueltos** | Velocidad muy próxima pero no igual, o mal contacto | Desmonta. Repite §5.3 y §6.5 |

**Si no sale nada, comprueba en este orden:**

- [ ] a) ¿El LED del módulo está **fijo** (conectado)? Si parpadea, el móvil no está conectado: reconecta desde la app de terminal **antes** de alimentar.
- [ ] b) ¿Está el módulo montado **en la orientación correcta**? `RXD` del módulo al pin 2, `TXD` al pin 3.
- [ ] c) ¿**Quitaste el puente `TXD`–`RXD`** del paso 6.5.9?
- [ ] d) ¿Llegan los 12 V a `J2` y hay 5 V en el raíl?
- [ ] e) ¿Te conectaste **antes** de alimentar? El saludo sólo se manda una vez, a los 7 s del arranque. Si te conectas después, ya se perdió. **Desconecta la alimentación, conecta el móvil, y vuelve a alimentar.**

> **No esperes ningún pitido.** El firmware llama a `twoBeep()` y `oneBeep()`, pero **el buzzer de esta tarjeta no suena**: está en `RC1` y el firmware ataca `RC0`, y además lleva una resistencia de 100 kΩ en serie que limita la corriente a 120 µA. *Fuente: `HARDWARE.md` hallazgos C1 y C2.* **La ausencia de pitido NO es un fallo del módulo Bluetooth.**

---

### 6.8 El equipo contesta al volcado

- [ ] **6.8.1** Con la tarjeta alimentada y el móvil conectado por Serial Bluetooth Terminal, envía la **trama de volcado** de §8.
- [ ] **6.8.2** Espera hasta 3 segundos.

- [ ] **6.8.3** **Tienes que ver algo con esta forma:**

```
7:5:30
21/8/26-5


No -    Ini    -   Fin    - On - Dias

 1   - 0:0   - 0:0  - OFF - Dia
 2   - 0:0   - 0:0  - OFF - Dia
 3   - 0:0   - 0:0  - OFF - Dia
 4   - 0:0   - 0:0  - OFF - Dia
 5   - 0:0   - 0:0  - OFF - Dia

```

Los números concretos dependen de la hora del reloj y de los horarios grabados. **Lo que valida el paso es que llegue la tabla, con la cabecera `No -    Ini    -   Fin    - On - Dias` legible.**

> *Fuente: `Aplicacion.c`, función `readDevide()`. Los valores se imprimen con `%d` sin relleno de ceros: verás `7:5:30`, no `07:05:30`.*

| Lo que ves | Qué significa |
|---|---|
| **La tabla completa y legible** | ✅ **El equipo recibe, interpreta y contesta.** Módulo ACEPTADO |
| **Nada** | El equipo **recibe mal o no recibe**. El camino móvil→PIC está roto. Comprueba que enviaste el byte `0xBF` correctamente (§8) — es el fallo más probable |
| **Basura** | Velocidad mal. Vuelve a §5.3 |
| **Sale el saludo otra vez** | El equipo se reinició. Problema de alimentación, no del módulo |

> **El PIC no hace eco.** No esperes ver tu propia trama devuelta: la línea que reenviaría los caracteres recibidos está comentada en el firmware (`//UART_write(ch);` en la interrupción de `main.c`). Que no haya eco es lo normal.

---

### 6.9 Cierre

- [ ] **6.9.1** Corta la alimentación.
- [ ] **6.9.2** **Pega la etiqueta física** con el nombre (`BAL-014-N`) en la caja del equipo, en sitio visible sin desmontar.
- [ ] **6.9.3** Rellena la fila del registro (§9), incluida fecha y firma.
- [ ] **6.9.4** El equipo queda **ACEPTADO**.

---

## 7. Resumen de comandos — chuleta de mesa

**Imprime esta página y tenla al lado.**

| | **HC-06** | **HC-05** |
|---|---|---|
| **Cómo entrar en modo AT** | No hace falta. Basta con que no esté conectado | Botón pulsado **al alimentar** |
| **Velocidad en modo AT** | La suya (9600 de fábrica) | **38400** ← siempre |
| **Velocidad en modo datos** | La suya (9600 de fábrica) | 9600 de fábrica |
| **¿Retorno de carro?** | **NO** (`Append nothing`) | **SÍ** (`Append CR-LF`) |
| **LED en modo AT** | Igual que siempre (rápido) | **Lento** (2 s / 2 s) |
| **Comprobar que responde** | `AT` → `OK` | `AT` → `OK` |
| **Versión de firmware** | `AT+VERSION` → `linvorV1.8` | `AT+VERSION?` → `+VERSION:...` |
| **1) Poner nombre** | `AT+NAMEBAL-014-N` → `OKsetname` | `AT+NAME=BAL-014-N` → `OK` |
| **Releer nombre** | *No se puede* → validar en §6.6 | `AT+NAME?` → `+NAME:BAL-014-N` |
| **2) Poner PIN** | `AT+PIN2130` → `OKsetPIN` | `AT+PSWD=2130` → `OK` |
| **Releer PIN** | *No se puede* | `AT+PSWD?` |
| **3) Poner 9600 8N1** | `AT+BAUD4` → `OK9600` | `AT+UART=9600,0,0` → `OK` |
| **Releer velocidad** | *No se puede* → reabrir a 9600 y mandar `AT` | `AT+UART?` → `+UART:9600,0,0` |
| **Volver a fábrica** | *No hay comando* | `AT+ORGL` → `OK` |

**Columna del SIG0109A — sólo si se confirma que es un JDY-31 [DS]. Ver §3.3.A:**

| | **JDY-31 / SIG0109A** |
|---|---|
| **Modo AT** | No hay modo separado. Basta con no estar conectado |
| **¿Retorno de carro?** | **SÍ** (`\r\n`) |
| **Comprobar que responde** | `AT+VERSION` → `+VERSION=JDY-31-V1.2,Bluetooth V3.0` |
| **Poner nombre** | `AT+NAME…` → `+OK` |
| **Poner PIN** | `AT+PIN…` → `+OK` |
| **Poner 9600** | `AT+BAUD4` → `+OK` |
| **NO EXISTEN** | ⛔ `AT+ROLE`, `AT+UART`, `AT+PSWD`, `AT+ORGL` |

**Los ocho tropiezos, en una línea cada uno:**

1. **🔴 Comprueba el pinout ANTES de alimentar.** `VCC`/`GND` invertidos matan el módulo al instante. **PASO 0.**
2. **HC-06 sin `\r\n`; HC-05 y JDY-31 con `\r\n`.** Confundirlos hace que no responda nada.
3. **HC-05 en modo AT habla a 38400**, aunque sus datos estén a 9600. No está roto.
4. **Al cambiar la velocidad, el módulo cambia al instante.** Reabre el terminal a la nueva.
5. **HC-06: el PIN nuevo no vale hasta descargar el módulo** (puentea `VCC`–`GND` 20 s). §5.2.4.
6. **El HC-06 se llama `linvor` de fábrica; el JDY-31, `JDY-31-SPP`.** No encontrar «HC-06» **no** es una avería.
7. **Enciende la Ubicación del móvil** o Android no lista ningún dispositivo, sin dar error.
8. **Los comandos del HC-05 no existen en el JDY-31.** Que no conteste **no** significa que esté muerto.

> **Después de `AT+ORGL` en un HC-05, no des por hecha ni la velocidad ni el nombre.** El documento oficial se contradice: `AT+ORGL` dice restaurar el puerto a **38400** y el nombre a `H-C-2010-06-01`, mientras que la entrada de `AT+UART` declara el defecto como **9600,0,0** y la de `AT+NAME` como `HC-05`. **Vuelve a consultarlos con `AT+UART?` y `AT+NAME?`.**

**SIG0109A / BK3231: no hay chuleta. El procedimiento está sin determinar. Ver §3.3.**

---

## 8. Las tramas de prueba

### 8.1 El delimitador — y por qué da guerra

El protocolo del equipo delimita las tramas así:

| | Byte | Carácter |
|---|---|---|
| **Inicio** | **`0xBF`** | `¿` en Windows-1252 / ISO-8859-1 |
| **Fin** | `0x3F` | `?` |

*Fuente verificada: `Serial.h` líneas 27–28.*
```c
#define INIT_FRAME      "¿"     // volcado hexadecimal del fichero: 22 BF 22 → el byte es 0xBF
#define END_FRAME       "?"
#define ID_READ_DEV     "L"
```

**El problema:** `0xBF` no es un carácter ASCII. **Muchos terminales de móvil no dejan escribirlo**, y los que lo dejan suelen mandarlo en UTF-8, que son **dos bytes** (`C2 BF`), no uno.

### 8.2 La trama de volcado

**Lo que hay que hacer llegar al equipo:**

| | Byte 1 | Byte 2 | Byte 3 |
|---|---|---|---|
| **Hex** | `BF` | `4C` | `3F` |
| **Carácter** | `¿` | `L` | `?` |

### 8.3 Cómo enviarla — tres formas, en orden de fiabilidad

#### Forma 1 — Serial Bluetooth Terminal en modo HEX ✅ RECOMENDADA

- [ ] **8.3.1** Abre **Serial Bluetooth Terminal** y conéctate al módulo.
- [ ] **8.3.2** Menú (☰) → **Settings** → **Send** → **Mode** → selecciona **`HEX`**.
- [ ] **8.3.3** En la caja de envío escribe exactamente:
  ```
  BF 4C 3F
  ```
- [ ] **8.3.4** Envía.

Esto manda **los tres bytes exactos**, sin que ningún juego de caracteres los toque. **Es la forma que no falla.**

#### Forma 2 — desde el PC con Termite

- [ ] **8.3.5** Con el módulo conectado al adaptador USB-serie a 9600, en Termite escribe `¿L?`.
  Termite envía en la codificación local de Windows (Windows-1252), donde `¿` **es** el byte `0xBF`. Funciona.
  Para teclear `¿` en Windows: mantén `Alt` y teclea `168` en el teclado numérico.

#### Forma 3 — la propia app de la baliza

- [ ] **8.3.6** Pulsa el botón «Leer» en la app `BalizaV10`. Construye la trama sola.

> **Detalle útil si comparas capturas:** la app envía en realidad **cuatro bytes**, `C2 BF 4C 3F`, no tres. El literal del código fuente es `"¿L?\n\r"`, el fichero está en UTF-8 y Java lo escribe en UTF-8, así que el `¿` sale como `C2 BF`.
> **Funciona igualmente**, porque el firmware busca el `0xBF` con `strstr()` en cualquier posición del buffer, y lo encuentra como segundo byte. *Verificado: volcado hexadecimal de `MainActivity2.java` → `22 C2 BF 4C 3F 5C 6E 5C 72 22`, y `Serial.c`, estado `ST_INIT_FRAME_ANA1`.*
> Por eso `BF 4C 3F` y `C2 BF 4C 3F` valen las dos.

### 8.4 Detalles del protocolo que conviene conocer

- **El fin de trama lo marca el silencio, no el `?`.** El firmware da la trama por terminada tras **~5 ms sin recibir nada**. Manda la trama de golpe, no carácter a carácter. *Fuente: `Serial.c`, `ST_ESPERA_ANA1`, contador `anaT1.uiCnt >= 5`, que se pone a cero en cada byte recibido (`main.c`, interrupción de `RCIF`).*
- **El buffer de recepción es de 40 bytes.** *Fuente: `Serial.h`, `SIZE_BUFFER_RX1`.* No mandes tramas largas.
- **El `\n\r` del final es opcional.** El equipo no lo necesita.
- **Las tramas de hora y de configuración de alarmas** (`¿R...,C...?` y `¿A1,E1,I...,F...,D8,?`) **no se usan en esta validación** — se documentan en `APP_MOVIL.md`. Para aceptar un módulo basta con el volcado.

---

## 9. Tabla de registro — una fila por módulo

**Imprime esta hoja.** Rellena una fila por cada módulo. Guárdala con la documentación del lote.

**Lote nº: ________  ·  Fecha: ____ / ____ / ________  ·  Operario: _______________________**

| # | Marca física / Nº serie | Familia (HC-06 / HC-05 / JDY-31) | **P0 pinout** | Nombre de FÁBRICA | Señal destino | Nombre puesto | PIN | Vel. | 6.1 LED | 6.2 AT | 6.3 Nombre | 6.4 Vel. | 6.5 Bucle | 6.6 Móvil | 6.7 Saludo | 6.8 Volcado | **Resultado** | Fecha | Firma |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | | | ☐ | | | | | 9600 | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ APTO ☐ NO | | |
| 2 | | | ☐ | | | | | 9600 | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ APTO ☐ NO | | |
| 3 | | | ☐ | | | | | 9600 | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ APTO ☐ NO | | |
| 4 | | | ☐ | | | | | 9600 | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ APTO ☐ NO | | |
| 5 | | | ☐ | | | | | 9600 | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ APTO ☐ NO | | |
| 6 | | | ☐ | | | | | 9600 | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ APTO ☐ NO | | |
| 7 | | | ☐ | | | | | 9600 | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ APTO ☐ NO | | |
| 8 | | | ☐ | | | | | 9600 | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ APTO ☐ NO | | |
| 9 | | | ☐ | | | | | 9600 | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ APTO ☐ NO | | |
| 10 | | | ☐ | | | | | 9600 | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ APTO ☐ NO | | |

**Notas / incidencias:**

```
_______________________________________________________________________

_______________________________________________________________________

_______________________________________________________________________
```

**Cómo rellenar:**
- **Paso 0 (pinout):** marca la casilla **sólo** tras comparar la serigrafía del módulo con el zócalo y confirmar que `GND` y `VCC` están en las posiciones 4 y 5. **Si no lo comprobaste, no sigas.**
- **Nombre de fábrica:** anótalo **antes** de cambiarlo (`linvor`, `JDY-31-SPP`, `HC-05`…). Identifica la familia y sirve de prueba de que el módulo se anunciaba.
- **Marca física / Nº serie:** los módulos no traen número de serie. **Pon tú una marca**: pega una etiqueta con un número correlativo del lote (`L3-07`) antes de empezar, y anótalo.
- **Familia:** de §2.
- **Vel.:** siempre `9600`. Si pone otra cosa, el módulo no está aceptado.
- **Casillas 6.x:** marca sólo si viste exactamente lo que pide el paso. **6.3 en HC-06 se marca junto con 6.6.**
- **Resultado:** `APTO` sólo si **todas** las casillas están marcadas.

---

## 10. Qué hacer con un módulo que no pasa

### 10.1 Distinguir «mal configurado» de «dañado»

| Síntoma | Diagnóstico | ¿Recuperable? |
|---|---|---|
| Responde `OK` a `AT` pero el nombre no cambia | **Mal configurado** — sintaxis equivocada o familia mal identificada | **Sí.** Revisa §2 y §5 |
| No responde a 9600 pero sí a otra velocidad | **Mal configurado** — alguien lo dejó a otra velocidad | **Sí.** §5.3 desde esa velocidad |
| Responde `ERROR` a los comandos | **Mal configurado** — sintaxis. El módulo está vivo | **Sí.** Revisa la chuleta §7 |
| **LED apagado con 3,3 V correctos en `VCC`** | **Dañado** | **No** |
| **No responde a ninguna de las 16 combinaciones de §3.4** | **Dañado** (o firmware desconocido) | **No** |
| **Falla el bucle (§6.5): no devuelve nada o devuelve deformado** | **Dañado** — la radio no funciona en los dos sentidos | **No** |
| **El móvil no lo ve nunca**, con LED parpadeando bien | **Comprueba antes: (a) que la Ubicación del móvil está ENCENDIDA, (b) que no estás buscando un nombre equivocado** — el HC-06 se anuncia como `linvor` y el JDY-31 como `JDY-31-SPP`. Sólo si las dos cosas están bien: **dañado** | **Casi siempre sí** |
| **No responde a los comandos, y es un SIG0109A / BK3231S** | **Casi seguro estás usando los comandos del HC-05, que en este módulo NO EXISTEN.** Prueba `AT+VERSION\r\n` a 9600 | **Sí.** §3.3.A |
| **Murió nada más enchufarlo en la tarjeta** | **Sospecha de `VCC`/`GND` invertidos** (PASO 0). **Revisa el pinout del resto del lote ANTES de enchufar otro** | **No, pero salva a los siguientes** |
| Se empareja pero **se desconecta solo** a los pocos segundos | **Dañado o alimentación insuficiente.** Prueba con otra fuente antes de rechazarlo | **Dudoso** |
| Funciona en la mesa pero **falla montado en la tarjeta** | **No es el módulo.** Es montaje, orientación, el puente de 6.5.9 sin quitar, o alimentación | **Sí.** Vuelve a 6.7 |

### 10.2 Cuántos intentos merece

**Regla: tres intentos y fuera.**

- [ ] **10.2.1** **Intento 1.** Repite el paso que falló, tal cual.
- [ ] **10.2.2** **Intento 2.** Repite **desde §2** (identificar la familia). La mayoría de los fallos son de familia mal identificada, no de módulo malo.
- [ ] **10.2.3** **Intento 3.** Cambia de adaptador USB-serie y de cables. Un Dupont con mal contacto imita perfectamente a un módulo muerto.
- [ ] **10.2.4** **Si falla el tercero: RECHAZADO.** No sigas. El tiempo de un operario vale más que un módulo.

> **Excepción:** si fallan **tres módulos seguidos** en el mismo paso, **para**. No son los módulos: es el banco de pruebas, el adaptador o el procedimiento. Avisa al responsable.

### 10.3 Cómo marcar un módulo rechazado

> **Que no vuelva a la caja buena.** Un módulo rechazado que se recoge por error acaba montado en una señal.

- [ ] **10.3.1** **Marca la placa con rotulador permanente: una `X` grande y bien visible en la cara de arriba.** Que se vea sin girarlo.
- [ ] **10.3.2** Pega una etiqueta con: `RECHAZADO` + fecha + el número de paso que falló (por ejemplo `RECHAZADO 21-08-26 · falla 6.5`).
- [ ] **10.3.3** Mételo en la **caja o bolsa marcada «RECHAZADOS»**. Nunca en la caja de módulos por configurar.
- [ ] **10.3.4** Anota la fila en el registro (§9) con `NO` y el motivo en «Notas».
- [ ] **10.3.5** **No los tires.** Si se rechazan muchos del mismo lote, hay que devolverlos al proveedor, y hará falta la cuenta y los motivos.

---

## 11. Preguntas abiertas

**Todo lo de aquí es lo que NO se ha podido confirmar.** Está formulado como pregunta, dirigida a quien puede contestarla, porque **inventar un dato en un manual de validación hace que se dé por bueno un equipo que no lo está**.

**Ninguna de estas preguntas es una instrucción. No las apliques como si fueran procedimiento.**

### Para el responsable del proyecto

| # | Pregunta | Por qué bloquea |
|---|---|---|
| **P11** | **¿Se aprueba la convención de nombres `BAL-NNN-D` de §4.3?** ¿El `NNN` es el correlativo del registro de instalación, o se prefieren tres letras del colegio? ¿Existe ya un registro de numeración de señales al que engancharse? | **Bloquea la configuración del primer módulo.** Renombrar después obliga a desmontar cada equipo instalado |
| **P12** | **¿Se aprueba cambiar el PIN de fábrica, y cuál se usa?** ¿Uno único de proyecto o uno por equipo? ¿Quién custodia el valor? | Bloquea §5.2. Dejar `1234` permite a cualquiera reprogramar el horario de una señal escolar |
| **P13** | **¿Se monta el módulo con la resistencia serie / divisor que recomienda `HARDWARE.md` (R7), o tal cual?** | Afecta a la vida del módulo en campo. Decide si el montaje de §6.7 lleva un componente añadido |
| **P14** | **¿Quién pega y controla las etiquetas físicas de la señal?** El nombre Bluetooth no sirve de nada si el poste no lleva el mismo código escrito | Sin esto la convención de nombres no resuelve el problema en campo |

### Para Sigma Electrónica — módulo SIG0109A

**Estas son las preguntas concretas que hay que hacerles.** Sin respuesta a **P4** y **P5**, estos módulos no se pueden usar.

| # | Pregunta |
|---|---|
| **P20** | 🔴 **¿Cuál es el orden EXACTO de los 6 pines de la placa del SIG0109A?** Se necesita la secuencia literal de un extremo al otro. El zócalo de la tarjeta es `STATE · RXD · TXD · GND · VCC · EN`. **Hay una contradicción documentada:** el manual del JDY-31 da ese mismo orden, pero una fuente con foto de la placa real da `STATE · TXD · RXD · **VCC · GND** · EN`, **con `VCC` y `GND` intercambiados**. **Si es el segundo, el módulo se destruye al insertarlo.** — **Es la pregunta más urgente del documento. Bloquea cualquier prueba, y se responde en un minuto mirando la serigrafía** |
| **P21** | **¿El SIG0109A es un JDY-31 (alias «SPP-C») reetiquetado?** Coincide en chip (BK3231S), versión Bluetooth (3.0) y alimentación (3,6–6 V), **pero Sigma no publica el modelo**. **Si lo confirman, el manual del JDY-31 responde por sí solo a P4, P6, P7 y P8.** Forma barata de comprobarlo sin preguntar: mandar `AT+VERSION\r\n` a 9600 y ver si contesta `+VERSION=JDY-31-…` |
| **P4** | **¿Cuál es el juego de comandos AT del SIG0109A, y qué firmware lleva exactamente?** ¿Pueden facilitar el manual del **módulo**? El PDF que enlazan en la ficha (`BK3231_ARM968E-S.pdf`) es el datasheet del **chip** de Beken y **no contiene ni un solo comando AT** — verificado página a página. **Concretamente: ¿es firmware estilo JDY-31 (requiere `\r\n`) o estilo Bolutek/HC-06 (sin terminador)?** Son incompatibles entre sí. **Y ¿monta BK3231 o BK3231S?** La ficha dice «BK3231», el SKU sugiere otra cosa |
| **P5** | **¿El módulo expone el perfil SPP sobre RFCOMM, con el UUID `00001101-0000-1000-8000-00805F9B34FB`?** Todo apunta a que sí (el BK3231 es Bluetooth clásico y sus módulos conocidos son SPP), **pero Sigma no lo declara en ninguna parte**. Nuestra app abre el socket con ese UUID exacto: si no expone SPP, no sirve |
| **P6** | **¿Cuáles son los valores de fábrica?** Velocidad del puerto serie, nombre Bluetooth, PIN de emparejamiento |
| **P7** | **¿Los comandos AT requieren retorno de carro (`\r\n`) o no?** ¿Hay que entrar en un modo de configuración, y cómo? ¿Hay que estar desconectado para aceptarlos? |
| **P8** | **¿Cómo se cambia el nombre y cuál es la longitud máxima admitida?** ¿Y qué hace el módulo si se supera: trunca, devuelve error, o queda en un estado inconsistente? |
| **P9** | **¿Es reemplazo directo de HC-05/HC-06 a nivel de pines y de comandos, o sólo a nivel eléctrico?** ¿Pinout exacto (número de pines y función)? Si es equivalente al JDY-31, el pin `EN` figura como *«Vacant»* (sin función) en su manual — **conviene confirmarlo** |

### Sobre los módulos que tenemos en mano

| # | Pregunta | A quién |
|---|---|---|
| **P1** | **¿Cuántos pines y qué serigrafía tienen exactamente los ejemplares del lote?** No he podido inspeccionar los módulos físicos. La tabla de §2.1 recoge las variantes habituales del mercado; **hay que contrastarla con un ejemplar real y corregirla** | Quien tenga los módulos delante |
| **P2** | **¿Qué nombre, velocidad y PIN de fábrica traen los clones BK3231S del lote?** Se venden con nombres muy variados (`BT05`, `MLT-BT05`, `AT-09`, `JDY-30`…) y **cada variante lleva firmware distinto** | Comprobación en banco, tras P4 |
| **P3** | **En las placas `ZS-040` del lote, ¿el pin serigrafiado `EN` va al `KEY` del módulo o a la habilitación del regulador?** Determina si la Forma B de §3.2 funciona | Comprobación en banco con multímetro |
| **P10** | **¿Qué firmware traen los HC-06 del lote: 1.x (sin terminador) o 3.x (con `\r\n`)?** Lotes recientes vienen con firmware tipo HC-05 y **no obedecen las reglas del HC-06**. Se resuelve con `AT+VERSION` (§3.5). **No bloquea**: el procedimiento §3.1.1 lo cubre | Comprobación en banco |
| **P17** | **En los HC-05 con firmware 3.0, ¿`AT+PSWD` exige comillas?** Hay reportes de fallo al cambiar el PIN en esa rama, **pero ninguna fuente atribuye la causa a las comillas**. **No bloquea**: §5.2 manda probar las dos formas y releer | Comprobación en banco |
| **P18** | **¿Qué hace cada firmware si el nombre excede el límite: truncar en silencio, devolver `FAIL`, o quedar inconsistente?** No está documentado en ninguna familia. **No bloquea**: la convención usa 9 caracteres, muy por debajo de cualquier límite | Comprobación en banco |
| **P19** | **¿Sobreviven los espacios en `AT+NAME`?** Ninguna fuente lo confirma. **No bloquea**: la convención propuesta no usa espacios, precisamente por esto | — |

### Sobre el equipo

| # | Pregunta | Por qué |
|---|---|---|
| **P15** | **¿El HC-06 que funcionaba antes sigue disponible?** Si hay unidades, son la opción de menor riesgo: ya se sabe que funcionan con este firmware y esta app | Evita depender de P4/P5 |
| **P16** | **¿Se va a conectar el pin `STATE` del módulo a alguna entrada libre del PIC en una revisión futura?** Hoy está sin conectar y el firmware no sabe si hay alguien conectado. *`HARDWARE.md` riesgo R26* | No afecta a esta validación |

---

## Anexo — Fuentes

**Ficheros del proyecto (verificados directamente):**

| Dato | Fichero |
|---|---|
| Velocidad 9600 8N1 fija, `BRGH=0`, `SPBRG=32` | `1 Firmware\Doc mplabx\18f2550_baliza_ V1.X\UART.h` |
| Llamada `UART_init_baud(9600)` | `…\main.c:117` |
| Ausencia de eco (`//UART_write(ch);`) | `…\main.c`, interrupción `INT_isr` |
| Delimitadores `0xBF` / `?`, `ID_READ_DEV = "L"`, buffer de 40 bytes | `…\Serial.h:27-28`, `SIZE_BUFFER_RX1` |
| Detección de fin de trama por 5 ms de silencio | `…\Serial.c`, `ST_ESPERA_ANA1` |
| Texto `BALIZA ALARMA V1.0` y volcado `readDevide()` | `…\Aplicacion.c` |
| Retardo de arranque (~7 s) | `…\Aplicacion.h:22,24` |
| UUID SPP, `getName()`, trama `¿L?` | `1 Firmware\Doc Aplicativo Movil\BalizaV10\…\MainActivity2.java` |
| Cableado de `U2`, alimentación a 5 V, riesgos R7 y R26, hallazgos C1/C2 | `HARDWARE.md` §2.4, §5, §10 |
| BK3231: BT 3.0, HID, sin comandos AT, 2,0–3,6 V | `5 HW bluetooth\BK3231_ARM968E-S.pdf` |

**Fuentes externas:**

**Fuentes primarias de fabricante (máxima confianza):**

- **[Manual oficial Wavesen — «HC Serial Bluetooth Products User Instructional Manual» (PDF)](https://www.electronicoscaldas.com/datasheet/HC-Serial-Bluetooth-Products-User-Instructional-Manual_Wavesen.pdf)** — la fuente más importante de este documento. Confirma: límite de **20 caracteres** del nombre en HC-06; comandos del HC-06 **sin terminador**; frecuencia máxima de **1 Hz** entre comandos («the command of HC-06 end or not is determined by the time interval»); **`KEY`/PIN34 hay que MANTENERLO en alto** para el juego AT completo; modo AT del HC-05 a **38400**; **el PIN nuevo del HC-06 no se activa hasta descargar el módulo**; nombre de fábrica `linvor`; `9600N81`
- **[HC-05 AT Command Set (PDF)](https://s3-sa-east-1.amazonaws.com/robocore-lojavirtual/709/HC-05_ATCommandSet.pdf)** — sintaxis y respuestas exactas; nombre hasta **32 bytes**; `AT+UART` con sus tres parámetros (`9600,0,0` = 9600 8N1); comandos **sensibles a mayúsculas**; terminador `\r\n` obligatorio
- **[Manual oficial JDY-31 (PDF)](https://adastra-soft.com/wp-content/uploads/2021/06/JDY-31_manual_2.pdf)** — «must be added `\r\n`»; nombre máximo **18 bytes**; tabla `AT+BAUD` (sólo 4–9); pin `EN` marcado como *«Vacant»*
- [HC-42 datasheet oficial (PDF)](https://www.hc01.com/downloads/HC-42%20english%20datasheet.pdf) — nRF52832, BLE 5.0

**Fuentes técnicas secundarias con pruebas en banco:**

- [Martyn Currey — The Complete Guide To The HC-06](https://www.martyncurrey.com/the-complete-guide-to-the-hc-06/) — tabla `AT+BAUDn`, respuestas literales (`OKsetname`, `OKsetPIN`, `OK9600`), PIN de 4 dígitos, parpadeo del LED
- [Martyn Currey — HC-06 hc01.comV2.0](https://www.martyncurrey.com/hc-06-hc01-comv2-0/) — nombre de fábrica `HC-06`, ventana de escucha de ~1 s
- [Martyn Currey — HC-05 con firmware 2.0-20100601](https://www.martyncurrey.com/hc-05-with-firmware-2-0-20100601/) — nombre hasta 32 caracteres verificado
- [Martyn Currey — Arduino con HC-05 en modo AT](https://www.martyncurrey.com/arduino-with-hc-05-bluetooth-module-at-mode/) — pin 34 alto al arrancar, 38400
- [Martyn Currey — JDY-31](https://www.martyncurrey.com/jdy-31-spp-bluetooth-module/) — «not a direct replacement… the AT commands are not identical»
- [Martyn Currey — Bluetooth modules](https://www.martyncurrey.com/bluetooth-modules/) — SPP-C / BT-06 = BK3231, firmware Bolutek V2.2
- [Martyn Currey — HM-10](https://www.martyncurrey.com/hm-10-bluetooth-4ble-modules/) — BLE no conecta con Bluetooth clásico
- [HC06_AT_CommandCenter (GitHub)](https://github.com/ndroid/HC06_AT_CommandCenter) — **lotes recientes de HC-06 con firmware v3 que exige `CR+NL`**; tiempos de respuesta 500 ms (v1.x) vs 10–25 ms (v3.x)
- [adastra-soft — JDY-31 / JDY-30](https://adastra-soft.com/some-information-about-the-jdy-31-bluetooth-module/) — desmontaje: JDY-30 = BK3231, JDY-31 = BK3231S
- [Yavilevich — MLT-BT05, clon de un clon](https://blog.yavilevich.com/2017/03/mlt-bt05-ble-module-a-clone-of-a-clone/) — desmontaje fotográfico: **MLT-BT05 = CC2541, BLE**
- [Infineon Community — «There is no SPP profile for BLE»](https://community.infineon.com/t5/PSOC-4/Does-BLE-support-SPP-to-Android-device/td-p/45304)
- [Last Minute Engineers — HC-05 AT commands](https://lastminuteengineers.com/hc05-at-commands-tutorial/)
- [DCC-EX — HC-05/06 Bluetooth Modules](https://dcc-ex.com/reference/hardware/bluetooth/hc-05-06.html) — pin `KEY`, botón al alimentar, 31 caracteres
- [Olimex — HC-06 datasheet (PDF)](https://www.olimex.com/Products/Components/RF/BLUETOOTH-SERIAL-HC-06/resources/hc06.pdf)
- [Sigma Electrónica — SIG0109A](https://www.sigmaelectronica.net/producto/sig0109a/) y [Sigma Electrónica — JDY-31](https://www.sigmaelectronica.net/producto/jdy-31/)
