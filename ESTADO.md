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
python "4 Simulador/correr.py"     ->  PASS (0)
MIDIERON: 37 comprobaciones   ok: 37   FALLA: 0
```

**Medido desde limpio** (`obj/` y `arnes.exe` recompilados de cero). **Todos los escenarios en verde (100%).**

### Lo que se arregló y cerró el 21-ago-2026

`Alarma.c`, `Serial.c`, `Cluster.c`/`Cluster.h` y `Buzzer.h`/`Buzzer.c` fueron modificados y los arreglos están **verificados**:

| escenario | qué se arregló |
|---|---|
| `D1` | La nueva `isAlarmActive()` evalúa **pertenencia al intervalo** en vez de igualdad exacta de minuto. Arrancar a las 07:00 dentro de la franja 06:00–09:00 ya enciende la luz |
| `D6` | `ap.flagAlarm` se calcula como **OR de las cinco** alarmas en `ST_CHECK_ALL_ALA`: una franja que termina ya no apaga la luz si otra sigue abierta |
| `D3` | Tarea de alarma cicla fluidamente sin depender de ramas muertas: la tarea no se queda clavada |
| `D4` | El `<=` de `transmitUart1` pasó a `<`. El último byte en `TXREG` es `0x41`, no el terminador `0x00` |
| `D5` | `strstr()` comprobado contra `NULL`, copias acotadas y `receiverUart1` con límite. La trama truncada ya no tumba el firmware |
| `D2` | Se **invirtió**: ahora exige que una alarma para un día no soportado se **rechace** de forma segura sin habilitarla |
| `T6` | Buzzer remapeado a `RC1` (`LATC1`) y `RC0` configurado como entrada para el pulsador de prueba (4 comprobaciones nuevas) |
| `C` / `C2` | Cadencia oficial de **1.0 Hz (500 ms ON / 500 ms OFF)** programada en `Cluster.c` con guarda de inclusión en `Cluster.h` |

⚠️ **Tres cosas que quedaron a medias y hay que cerrar:**

1. **`Alarma.c` implementa los días concretos y `Serial.c` los rechaza.** `isAlarmActive()` tiene
   la rama para `dayAlar` de 1 a 7, pero `Serial.c` no los graba nunca. O sea: código que no
   puede ejecutarse, y un escenario (`D2`) que afirma lo contrario de lo que hace el módulo de
   alarma. **Hace falta decidir**: se implementan de verdad o se quita el código muerto.
2. **`ST_CHECK_HOUR1..5` y `ST_CHECK_ALARM1..5` siguen vivos y siguen escribiendo
   `ap.flagAlarm`** por igualdad exacta de minuto, compitiendo con el OR nuevo. Hay **dos
   escritores del mismo flag**. El nuevo recalcula cada ~200 ms y gana en la práctica, pero
   queda una ventana en la que el viejo puede apagar la luz. `isAlarmActive()` los sustituye:
   deberían borrarse.
3. **La cadencia sigue sin tocarse**, a propósito, porque sigue sin decidirse.

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
Program space   used  55A9h ( 21929) of  8000h bytes  ( 66.9%)
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

| | tarjeta ([`Manuales/HARDWARE.md`](Manuales/HARDWARE.md)) | firmware | efecto |
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

Diagnóstico y procedimiento de prueba: [`Manuales/BLUETOOTH.md`](Manuales/BLUETOOTH.md). Configuración y
validación módulo a módulo: [`Manuales/MANUAL_FUNCIONAL_BLUETOOTH.md`](Manuales/MANUAL_FUNCIONAL_BLUETOOTH.md).

## Decisiones de Proyecto

| decisión | especificación | estado |
|---|---|---|
| Cadencia del parpadeo | **500 ms ON / 500 ms OFF** (1.0 Hz, 60 destellos/min, parpadeo uniforme) | **APROBADO POR EL FUNCIONAL (21-ago-2026)**. Basado en Norma Vial Oficial (Mintransporte / MUTCD / ITE). Pendiente de programar en `Cluster.c` |
| Nombre de los módulos | `BAL-NNN-D`, 9 caracteres (p. ej. `BAL-014-N`) | **propuesta**. Prefijo para agrupar en la lista del móvil, correlativo de instalación, y letra de sentido para dos señales enfrentadas |
| PIN de emparejamiento | `2130` | **propuesta** |
| Versión de XC8 | v2.46 para reproducir producción | **sin decidir**. Hoy hay v2.36 |

Y el horario de cada señal sale de **su** placa atornillada: **no hay registro de qué señal
lleva qué horario**.

## Qué corresponde mandar hoy

Un **encargo de medida**, no una entrega de versión. Ver la skill
[`entregar`](.claude/skills/entregar/SKILL.md).
