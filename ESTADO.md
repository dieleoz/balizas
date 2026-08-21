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

## Compilación — resuelta y verificada

**MPLAB X 5.45** y **XC8 v2.36** instalados. El firmware **compila y genera `.hex`**, con
código de salida **0**:

```
cd "D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza_ V1.X"
"C:\Program Files\Microchip\xc8\v2.36\bin\xc8.exe" --chip=18f2550 --std=c99 \
  --outdir=<salida> main.c Alarma.c Aplicacion.c Buzzer.c Cluster.c DS1307.c \
  EEprom.c I2C.c LedLive.c Serial.c TimeBase.c
```

```
Program space   used  533Dh ( 21309) of  8000h bytes  ( 65.0%)
Data space      used   2AFh (   687) of   800h bytes  ( 33.5%)
EEPROM space    used     0h (     0) of   100h bytes  (  0.0%)
```

Tres cosas que hay que saber y ya costaron tiempo:

- **`--std=c99` no es opcional.** En C90 falla en `DS1307.c:66` con `(188) constant expression
  required`: un array `const` local inicializado con los parámetros de la función. **No se toca
  el código, se compila en C99.** Confirma que el proyecto original ya estaba en C99.
- **Compilar siempre con `--outdir` fuera del árbol de fuentes.** Sin él, XC8 deja los
  artefactos **entre el código**: el 21-ago aparecieron 1,1 MB de `test_build.*` y `startup.*`
  mezclados con los `.c`.
- ⚠️ **La carpeta del firmware no tiene `nbproject/`**: MPLAB X no la abre como proyecto. Hay
  que crear proyecto nuevo, añadir los fuentes y **versionar el `nbproject/` resultante**.

**El `.hex` generado NO es el de producción.** Comparados hoy: 60.044 bytes frente a 61.008, y
difieren en prácticamente todas las líneas. Es lo esperado — producción se compiló con **v2.46**
y aquí hay **v2.36**. Para reproducir producción hay que instalar la v2.46; para desarrollar,
v2.36 vale. **La versión del compilador y sus banderas son parte del entregable** y hoy solo se
saben leyendo por casualidad un fichero de mapa.

Otra fuente de esta misma sesión reportó **26.863 bytes (82 %)** compilando lo mismo: mientras
las banderas no estén fijadas y anotadas, la cifra de ocupación no significa nada.

## Firmware ↔ tarjeta: dos desajustes medidos

La tarjeta **ya está fabricada y es fija**. Se cambia el firmware.

| | tarjeta ([`HARDWARE.md`](HARDWARE.md)) | firmware | efecto |
|---|---|---|---|
| Buzzer | `RC1` | `RC0` (`Buzzer.h:24`) | no suena; y `RC0` es la línea del pulsador |
| Temperatura | LM35 en `AN3` | `PCFG = 0b1011` solo habilita AN0–AN2, y la fórmula usa factor 10 donde el LM35 pide 100 | la temperatura leída no es la temperatura |

La medida de **tensión sí es correcta**: el divisor de la placa da factor 6 y el firmware
aplica 6.

## Bluetooth

> ### 🚨 Antes de volver a enchufar un módulo: comparar la serigrafía
>
> El SIG0109A es casi con seguridad un **JDY-31 / «SPP-C»** (mismo BK3231S). Y hay una
> **contradicción documentada en el orden de sus 6 pines**: el manual del JDY-31 da
> `STATE·RXD·TXD·GND·VCC·EN`, mientras que otra fuente con foto de la placa real da
> `STATE·TXD·RXD·`**`VCC·GND`**`·EN` — **con VCC y GND intercambiados**.
>
> Si la placa comprada es la segunda y se mete en el zócalo, **los +5 V entran por su GND y el
> módulo muere al instante**. Es la explicación más probable del *«no sabemos si esto está
> quemado»*. Comprobarlo cuesta un minuto y es gratis.

- Con **HC-06 funcionaba**. Con **HC-05** y con el **SIG0109A** «no lo reconoce».
- **Los nombres de fábrica pueden ser toda la avería**: el HC-06 se anuncia como **`linvor`**, no
  como «HC-06»; el JDY-31 como **`JDY-31-SPP`**. Buscar «HC-06» y no encontrarlo **no es una
  avería**.
- **El SIG0109A no se puede configurar hoy.** El único PDF que publica el vendedor es el
  datasheet del chip Beken y **no contiene un solo comando AT** — verificado página a página. Y
  sobre el BK3231 conviven dos firmwares con sintaxis incompatibles. El procedimiento queda «a
  determinar», con preguntas concretas para el proveedor.
- **Los comandos AT del HC-05 no sirven aquí.** El JDY-31 es esclavo puro, 9 comandos, terminados
  en `\r\n`, y **no tiene `AT+ROLE` ni `AT+UART`**. Probar comandos del HC-05 y no obtener
  respuesta puede estar haciendo creer que un módulo sano está muerto.
- ⚠️ **`BT05`, `MLT-BT05`, `AT-09` y `HC-42` no valen**: son **BLE**, y la app abre un socket
  **SPP/RFCOMM**. `BT-05` y `BT-06` se diferencian en un dígito y son tecnologías distintas.
- El firmware **no distingue módulos**: para él es un puerto serie transparente a 9600 8N1 fijo.
  La creencia de que el `.hex` está «compilado para otro Bluetooth» es falsa y está desviando el
  trabajo.
- La app (`targetSdk 30`) **sí funciona** en Android 12–15 por la capa de compatibilidad. Rompe
  solo si alguien la recompila con `targetSdk ≥ 31`. Pero **el interruptor de Ubicación del
  teléfono tiene que estar encendido** o Android no lista dispositivos.

Diagnóstico y procedimiento de prueba: [`BLUETOOTH.md`](BLUETOOTH.md). Configuración y
validación módulo a módulo: [`MANUAL_FUNCIONAL_BLUETOOTH.md`](MANUAL_FUNCIONAL_BLUETOOTH.md).

## Lo que sigue sin estar decidido — hace falta que alguien lo apruebe

| decisión | propuesta | estado |
|---|---|---|
| Cadencia del parpadeo | 2 s encendida / 2 s apagada | de una reunión, **sin documento**. Y 2 s es lento para una baliza de tráfico: merece confirmarse antes de programarlo |
| Nombre de los módulos | `BAL-NNN-D`, 9 caracteres (p. ej. `BAL-014-N`) | **propuesta**. Prefijo para agrupar en la lista del móvil, correlativo de instalación, y letra de sentido para dos señales enfrentadas |
| PIN de emparejamiento | `2130` | **propuesta** |
| Versión de XC8 | v2.46 para reproducir producción | **sin decidir**. Hoy hay v2.36 |

Y el horario de cada señal sale de **su** placa atornillada: **no hay registro de qué señal
lleva qué horario**.

## Qué corresponde mandar hoy

Un **encargo de medida**, no una entrega de versión. Ver la skill
[`entregar`](.claude/skills/entregar/SKILL.md).
