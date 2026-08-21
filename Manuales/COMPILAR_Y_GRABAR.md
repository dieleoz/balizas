# Compilar el firmware de la baliza y grabarlo en el PIC

**Responde a:** *«¿cómo se compilaría lo que modifiquemos?»*

**Fecha de comprobación:** 21 de agosto de 2026. Todo lo que dice este documento sobre *esta* máquina se comprobó ejecutándolo ese día. Lo que no se pudo comprobar está al final, en **§14 Preguntas abiertas**, y está marcado como pregunta, no como hecho.

---

## Respuesta corta

**Sí se puede compilar hoy, ahora mismo, desde la línea de comandos.** El compilador está instalado y el firmware compila. El comando está en **§1**, con dos banderas que **no son opcionales** (**§2** y **§3**).

Lo que **no** se puede hacer hoy:

- **Abrir el firmware como proyecto en MPLAB X**, porque falta la carpeta `nbproject\` (**§5**). Hay que recrear el proyecto una vez.
- **Comparar el binario byte a byte con el de producción**, porque lo instalado es XC8 **v2.36** y producción se hizo con **v2.46** (**§6**).

---

## 0. Estado de la máquina, comprobado

| Cosa | Estado | Cómo se comprobó |
|---|---|---|
| MPLAB X IDE v5.45 | ✅ **Instalado** | `C:\Program Files\Microchip\MPLABX\v5.45\`, con `mplab_platform\bin\mplab_ide64.exe` |
| Instalador de MPLAB X 5.45 guardado | ✅ Sí | `D:\@Proyect\Baliza\6 Sw pic\MPLABX-v5.45-windows-installer.exe` |
| **Compilador XC8 v2.36** | ✅ **Instalado** | `C:\Program Files\Microchip\xc8\v2.36\`. `pic\bin\picc18.exe --ver` contesta `Microchip MPLAB XC8 C Compiler V2.36` / `Build date: Jan 27 2022` / `Part Support Version: 2.36` |
| Drivers de XC8 | ✅ `xc8.exe`, `xc8-cc.exe`, `xc8-ar.exe` | `dir "C:\Program Files\Microchip\xc8\v2.36\bin"` |
| Soporte del PIC18F2550 en XC8 | ✅ Sí | `pic\dat\cfgdata\18f2550.cfgdata`, `pic\dat\ini\18f2550.ini`, `pic\include\proc\pic18f2550.h` |
| **¿Compila el firmware?** | ✅ **SÍ** | Ejecutado hoy: `Program space used 533Dh (21309) of 8000h (65.0%)`, `Data space used 2AFh (687) of 800h (33.5%)`, código de salida **0**, genera `main.hex` de 60 044 bytes |
| **Proyecto de MPLAB X del firmware** | ❌ **NO existe** | Búsqueda de `nbproject` / `configurations.xml` / `project.xml` en todo `D:\@Proyect\Baliza`: **cero resultados**. Ver §5 |
| Versión de producción | ⚠ **v2.46**, distinta de la instalada | `dist\default\debug\...debug.lst`: `MPLAB XC8 C Compiler v2.46 (Free license) build 20240104201356 Og1`. Ver §6 |
| Paquete de dispositivo PIC18F2550 en MPLAB X | ✅ Instalado | `...\v5.45\packs\Microchip\PIC18Fxxxx_DFP\1.2.26\edc\PIC18F2550.PIC` |
| `.hex` de producción ya compilado | ✅ Existe | `D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza__V1.X.production.hex` (61 008 bytes, 1360 líneas, 16-oct-2025) |
| Simulador de PC | ✅ Funciona | `D:\@Proyect\Baliza\4 Simulador\correr.py`, ejecutado hoy: salida **1**, 33 comprobaciones, 24 ok, 9 FALLA |
| gcc para el simulador | ✅ Existe | `D:\toolchain\mingw64\bin\gcc.exe` (ruta fija en `correr.py`) |
| Python | ✅ 3.12.10 | `python --version` |
| **Basura de compilación en la carpeta de fuentes** | ⚠ **Sí, hay que limpiarla** | `startup.lst`, `startup.o`, `startup.rlf`, `startup.s`, `test_build.cmf`, `test_build.elf`, `test_build.hxl`, `test_build.o`, `test_build.s`, `test_build.sdb`, `test_build.sym`. Ver §3 |

**Sobre la versión de MPLAB X: no la actualices.** El usuario ya dijo que las versiones nuevas no le funcionan con sus programadores, y hay una razón técnica que lo apoya: la tabla de soporte que trae esta instalación (`...\v5.45\docs\Device Support.htm`, fila `PIC18F2550`) marca en **verde** PICkit 3, ICD 3 y REAL ICE, tres herramientas que Microchip retiró de las versiones posteriores del IDE. Ver §14.

---

## 1. Compilar ahora mismo — el comando que funciona

Probado hoy en esta máquina, código de salida **0**:

```powershell
cd "D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza_ V1.X"

& "C:\Program Files\Microchip\xc8\v2.36\bin\xc8.exe" `
    --chip=18f2550 `
    --std=c99 `
    --outdir="D:\@Proyect\Baliza\_build" `
    main.c Alarma.c Aplicacion.c Buzzer.c Cluster.c DS1307.c `
    EEprom.c I2C.c LedLive.c Serial.c TimeBase.c
```

**Salida real de hoy:**

```
Memory Summary:
    Program space        used  533Dh ( 21309) of  8000h bytes   ( 65.0%)
    Data space           used   2AFh (   687) of   800h bytes   ( 33.5%)
    Configuration bits   used     7h (     7) of     7h words   (100.0%)
    EEPROM space         used     0h (     0) of   100h bytes   (  0.0%)
    ID Location space    used     0h (     0) of     8h bytes   (  0.0%)
```

El `.hex` sale como **`main.hex`** dentro de la carpeta de `--outdir` (toma el nombre del primer fuente de la lista; por eso conviene poner `main.c` el primero).

### Las tres cosas que hay que entender de ese comando

| Parte | Por qué |
|---|---|
| `xc8.exe`, no `xc8-cc.exe` | §4 |
| `--std=c99` | **Obligatoria.** Sin ella el firmware **no compila**. §2 |
| `--outdir=` fuera del árbol de fuentes | **Obligatoria en la práctica.** Sin ella XC8 deja la basura mezclada con el código. §3 |

### Los 11 fuentes, ni uno más ni uno menos

`main.c`, `Alarma.c`, `Aplicacion.c`, `Buzzer.c`, `Cluster.c`, `DS1307.c`, `EEprom.c`, `I2C.c`, `LedLive.c`, `Serial.c`, `TimeBase.c`.

Son exactamente los `.c` que hay en la carpeta, y coinciden uno a uno con los `.p1` que dejó la compilación original en `build\default\debug\`. **`UART.h` no tiene `.c`**: es sólo cabecera, se incluye desde `Serial.c`. Y en `Rtos\` sólo hay cabeceras (`pt.h`, `pt-sem.h`, `lc.h`, `lc-switch.h`, `lc-addrlabels.h`): no hay nada que compilar allí, pero tienen que estar en disco o no compila.

### Entrecomilla todas las rutas

`Program Files` tiene un espacio. `1 Firmware` tiene un espacio. `Doc mplabx` tiene un espacio. Y **`18f2550_baliza_ V1.X` tiene un espacio antes de `V1.X`**. Sin comillas, cualquiera de esas rutas se parte por la mitad y el error que sale no menciona las comillas. En PowerShell, además, hace falta el operador de llamada `&` delante de una ruta entrecomillada.

---

## 2. `--std=c99` NO ES OPCIONAL

**Sin esa bandera, `xc8.exe` compila en C90 y el firmware falla.** Comprobado hoy, ejecutando el mismo comando sin `--std=c99`: código de salida **1**.

```
DS1307.c
DS1307.c: escribirRTC()
	                               ^ (188) constant expression required
	 (188) constant expression required ^
	      (188) constant expression required ^
	           (188) constant expression required ^
	                (188) constant expression required ^
	                     (188) constant expression required ^
	                            (188) constant expression required ^
```

**La causa**, en `DS1307.c`, línea 66, dentro de `escribirRTC()`:

```c
void escribirRTC(uint8_t hor, uint8_t min, uint8_t seg, uint8_t dia, uint8_t mes, uint8_t ano, uint8_t diaSe)
{
     ...
     const uint8_t rtc_datos[7]={hor, min, seg, dia, mes, ano, diaSe};
```

Es un array `const` **local** inicializado con **los parámetros de la función**. En C99 eso es perfectamente legal: el inicializador de un objeto automático puede ser cualquier expresión. En **C90 no**: exige expresiones constantes, y `hor`, `min`, `seg`... no lo son. Siete elementos, siete errores `(188)`.

> ### El código NO está roto. `DS1307.c` no se toca. Se compila en C99.
>
> Es tentador «arreglar» ese array convirtiéndolo en siete asignaciones, o quitándole el `const`. **No lo hagas.** El firmware de producción se compiló en C99 y funciona; cambiar `DS1307.c` para complacer a un modo de compilación equivocado introduce un cambio real en el binario a cambio de nada.

Esto encaja con lo que ya se sabía: el `.lst` de la compilación original registra `XC8 C Compiler v2.46 (Free license) ... Og1`, y todo el resto del firmware —protothreads, declaraciones en mitad de bloque— es código de estilo C99. **El proyecto original ya estaba en C99.** Lo que pasa es que ese ajuste vivía en `nbproject\configurations.xml`, y esa carpeta se perdió (§5). Por eso hay que volver a ponerlo a mano.

**Quien recree el proyecto en MPLAB X tiene que poner C99 en las propiedades** (§7, paso 10) o se encontrará exactamente estos siete errores y creerá que el código está roto.

---

## 3. `--outdir` NO ES OPCIONAL

**Si compilas sin `--outdir`, XC8 deja todos los artefactos intermedios en el directorio de trabajo, que es la carpeta de los fuentes.** No es una hipótesis: **ya pasó hoy**. Estos ficheros están ahora mismo en `D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza_ V1.X\`, mezclados con el código:

```
startup.lst   startup.o   startup.rlf   startup.s
test_build.cmf   test_build.elf   test_build.hxl   test_build.o
test_build.s     test_build.sdb   test_build.sym
```

Alrededor de **1,1 MB de basura** que hubo que excluir del repositorio a mano.

Por qué importa más de lo que parece:

- Ensucia el árbol de fuentes, que es lo único que hay que conservar y versionar.
- Los `.s` y `.o` se parecen lo bastante a código como para que alguien los abra, los edite, o los meta en un ZIP creyendo que son parte del firmware.
- Si un día alguien añade un `startup.c` de verdad, chocará con el `startup.s` generado.

**Compila SIEMPRE con `--outdir` apuntando fuera del árbol de fuentes.** Por ejemplo `D:\@Proyect\Baliza\_build`, que está fuera de `1 Firmware\` y se puede borrar entero sin pensarlo.

Para limpiar lo que ya hay (revísalo antes de ejecutarlo; **no borres ningún `.c` ni `.h`**):

```powershell
cd "D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza_ V1.X"
Remove-Item startup.lst,startup.o,startup.rlf,startup.s,test_build.*
```

Y de paso, lo que **no** se versiona nunca: `build\`, `dist\`, `defmplabxtrace.log*`, y la carpeta de `--outdir`. Lo que **sí** se versiona: los `.c`, los `.h`, `Rtos\` y —cuando exista— `nbproject\`.

---

## 4. Qué driver usar: `xc8.exe`, no `xc8-cc.exe`

XC8 v2.36 trae **dos** ejecutables de línea de órdenes en `bin\`, y **no dan el mismo resultado**. Ambos compilan el firmware, pero uno produce un binario mucho mayor. Medido hoy, mismos 11 fuentes, misma versión del compilador, mismo `-std=c99`:

| Driver | Opción del dispositivo | Resultado | Programa | Datos |
|---|---|---|---|---|
| **`xc8.exe`** ✅ | `--chip=18f2550` | ✅ compila | **21 309 bytes — 65,0 %** | 687 — 33,5 % |
| `xc8-cc.exe` ⚠ | `-mcpu=18F2550` | ✅ compila | **26 863 bytes — 82,0 %** | 675 — 33,0 % |

**5 554 bytes más de flash (17 puntos porcentuales) por cambiar de driver, con el mismo código y el mismo compilador.** `xc8.exe` es el driver heredado de la v1.x y aplica por defecto un juego de opciones distinto del de `xc8-cc.exe`, que es el driver moderno con front-end de clang.

**Usa `xc8.exe --chip=18f2550`**, por dos razones: es el que da 65,0 %, muy cerca del 66,0 % de producción, y es el que deja margen. Con `xc8-cc` a 82 % quedarían menos de 6 KB libres.

Sobre el nombre del dispositivo: comprobado que **ambos drivers aceptan mayúsculas y minúsculas** (`18f2550` y `18F2550` funcionan en los dos). No es fuente de errores.

> ⚠ Se ha reportado en esta misma sesión que `xc8-cc.exe -mcpu=18F2550` fallaba con `(2043) target device was not recognized`. **No he podido reproducirlo**: en mis pruebas de hoy `xc8-cc` compiló los 11 fuentes sin ese error (código de salida 0). Ver §14.

### El tamaño depende de las banderas, y eso hay que anotarlo

Tres cifras del **mismo código** compilado en el **mismo día**:

| Cómo se compiló | Programa | % |
|---|---:|---:|
| XC8 v2.46, proyecto MPLAB X original, config `debug` | 21 640 | 66,0 % |
| XC8 v2.36, `xc8.exe --chip --std=c99` | 21 309 | 65,0 % |
| XC8 v2.36, `xc8-cc.exe -mcpu -std=c99` | 26 863 | 82,0 % |

> ### **La versión del compilador Y sus banderas son parte del entregable.**
>
> Un `.hex` sin esa información no es reproducible: nadie puede volver a generarlo, ni comparar el suyo con él, ni saber si el 82 % que le sale es un problema de su código o de su línea de órdenes.
>
> **Hoy esa información sólo se sabe porque alguien leyó por casualidad un fichero `.lst`** que sobrevivió dentro de `dist\`. Eso es suerte, no un proceso.
>
> **Junto a cada `.hex` que se entregue, deja un fichero de texto con:** versión exacta de XC8, driver usado, línea de órdenes completa (o la configuración de MPLAB X), fecha, y el resumen de memoria. Dos líneas de texto que ahorran una tarde de arqueología.

---

## 5. ⚠ El IDE sigue bloqueado: no hay proyecto de MPLAB X

Esto **no** lo arregla tener el compilador. Es un problema aparte.

La carpeta del firmware es:

```
D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza_ V1.X\
```

Dentro hay el código y los restos de una compilación antigua, pero **no hay `nbproject\`**:

```
Alarma.c/.h   Aplicacion.c/.h   Buzzer.c/.h   Cluster.c/.h   DS1307.c/.h
EEprom.c/.h   I2C.c/.h          LedLive.c/.h  Serial.c/.h    TimeBase.c/.h
UART.h        main.c/.h         Rtos\  (5 cabeceras)
build\        dist\             defmplabxtrace.log     + la basura de §3
```

Un proyecto de MPLAB X **es** la carpeta `nbproject\`: ahí viven `configurations.xml` (dispositivo, compilador, **estándar del lenguaje**, herramienta de programación, lista de ficheros) y `project.xml`. **Sin esa carpeta, MPLAB X no reconoce `18f2550_baliza_ V1.X` como proyecto y `File → Open Project` no la ofrecerá.**

Comprobado: la búsqueda de `nbproject` / `configurations.xml` / `project.xml` sobre **todo** `D:\@Proyect\Baliza` no encuentra ni un fichero.

**Consecuencias:**

- Desde línea de comandos (§1) **no importa**: se compila igual, sin proyecto.
- Para usar el IDE —editar con navegación, depurar, o grabar con `Make and Program Device`— hay que **crear el proyecto** (§7). Es media hora, una sola vez.
- **Y es lo que causó el problema de §2:** el ajuste «C99» vivía en `configurations.xml`. Al perderse la carpeta se perdió el ajuste, y con él la información de que este código necesita C99 para compilar.

### Lo que sí sobrevivió: la prueba de con qué se compiló

`build\` y `dist\` son los artefactos de la última compilación real, del **17 de septiembre de 2025 a las 18:36:11**:

| Dato | Valor | Fichero que lo prueba |
|---|---|---|
| Compilador | **MPLAB XC8 v2.46**, build `20240104201356` | `dist\default\debug\18f2550_baliza__V1.X.debug.map`, línea 1 |
| Dónde estaba instalado | `C:\Program Files\Microchip\xc8\v2.46\` | mismo `.map`, línea 6: `--edf=C:\Program Files\Microchip\xc8\v2.46\pic\dat\...` |
| Licencia | **Free** (no PRO), optimización `Og1` | `dist\default\debug\...debug.lst`, línea 4 |
| Dispositivo | `18F2550` | mismo `.map`: `-Q18F2550`, `Machine type is 18F2550` |
| Configuración | `default` / `debug` | rutas `build\default\debug\` |
| Los 11 `.c` que entraron | los mismos que hay hoy | los 11 `.p1` de `build\default\debug\` |

---

## 6. Versiones del compilador: v2.36 instalada, v2.46 en producción

| | Instalada hoy | La de producción |
|---|---|---|
| Versión | **v2.36**, build 27-ene-2022 | **v2.46**, build `20240104201356` |
| Ruta | `C:\Program Files\Microchip\xc8\v2.36\` | `C:\Program Files\Microchip\xc8\v2.46\` (ya no existe) |
| Licencia | Free (por defecto sin licencia) | **Free**, verificado en el `.lst` |
| Programa | 21 309 (65,0 %) | 21 640 (66,0 %) |
| Prueba | `picc18.exe --ver` ejecutado hoy | `...debug.map` línea 1 y `...debug.lst` línea 4 |

**Las cifras casan** —331 bytes de diferencia sobre 21 000— lo que confirma que el comando de §1 está compilando lo mismo y con opciones equivalentes. Pero **el `.hex` que sale de la v2.36 NO es comparable byte a byte** con `18f2550_baliza__V1.X.production.hex`: medidos hoy, 21 309 bytes de programa contra 21 638. Una comparación `fc` daría diferencias en casi todas las líneas, y no sabrías cuáles son tuyas.

### Cuál usar

| Si quieres... | Usa | Por qué |
|---|---|---|
| **Desarrollar, probar, ver si tu cambio cabe** | **v2.36, la que ya está** | Funciona hoy, sin instalar nada. Compila, enlaza y da un `.hex` válido y grabable. **Anota la versión junto al `.hex`** (§4) |
| **Reproducir el binario de producción, o comparar tu cambio contra él línea a línea** | **Instala la v2.46** | Es la única forma de que la única diferencia entre los dos `.hex` sea tu cambio, y no el compilador |
| **Grabar algo que sustituya al firmware de la señal** | **v2.46** | Si vas a reemplazar un binario probado en campo, compílalo con lo mismo con que se hizo el que está funcionando. No mezcles «mi cambio» con «otro compilador» en la misma grabación |

**Mantén la v2.36 instalada aunque pongas la v2.46.** XC8 permite varias versiones a la vez, cada una en su carpeta (`xc8\v2.36`, `xc8\v2.46`), y MPLAB X las ofrece las dos en la lista de compiladores. No hay que desinstalar nada.

**Y déjalo en modo Free.** El `.lst` prueba que producción se compiló con licencia Free. En ese modo XC8 aplica sólo la optimización básica (`Og1`); los niveles altos son de la licencia PRO. Si activaras PRO, el binario saldría más pequeño y **dejaría de ser comparable**. Los 11 KB libres de flash son un colchón real, no uno prestado por el optimizador.

### Dónde se descargan las versiones antiguas

En la web de Microchip, en la página del compilador (*MPLAB® XC8 Compiler*, dentro de *Tools and Resources → Develop → Compilers*), hay una pestaña de archivo de versiones (*Downloads Archive*) con todas las versiones antiguas de XC8, la v2.46 incluida. Es descarga gratuita; no hace falta licencia para el modo Free. Instálala en la ruta por defecto, `C:\Program Files\Microchip\xc8\v2.46\`, que es exactamente donde estaba. **No he podido verificar la URL exacta ni el nombre del fichero desde esta máquina** (sin red); ver §14.

Después de instalar, comprueba:

```powershell
& "C:\Program Files\Microchip\xc8\v2.46\pic\bin\picc18.exe" --ver
dir "C:\Program Files\Microchip\xc8\v2.46\bin"
```

---

## 7. Recrear el proyecto de MPLAB X

Sólo hace falta si quieres usar el IDE (editar con navegación, depurar, grabar con un clic). Para compilar basta con §1.

Abre `C:\Program Files\Microchip\MPLABX\v5.45\mplab_platform\bin\mplab_ide64.exe`.

1. **`File → New Project`** (Ctrl+Shift+N).
2. **Categoría `Microchip Embedded` → tipo `Standalone Project`** → `Next`.
   *No* elijas `Existing MPLAB IDE v8 Project` ni `Prebuilt (Hex, Loadable Image) Project`.
3. **`Select Device`**: `Family` = `Advanced 8-bit MCUs (PIC18)`, `Device` = **`PIC18F2550`** → `Next`.
4. **`Select Tool`**: elige tu programador. Para el PIC18F2550 esta instalación soporta **PICkit 3, PICkit 4, ICD 3, ICD 4, REAL ICE y PM3**. **MPLAB Snap NO sirve para este micro** (§10.1). Si aún no sabes cuál usarás, elige `Simulator` y cámbialo luego → `Next`.
5. **`Select Compiler`**: elige **`XC8 (v2.36)`** —o `XC8 (v2.46)` si la instalaste (§6)—. Si la lista sale vacía, cierra y reabre MPLAB X, o `Tools → Options → Embedded → Build Tools → Scan for Build Tools` → `Next`.
6. **`Select Project Name and Folder`**:
   - `Project Name`: **`18f2550_baliza_ V1.X`** (ya lleva el `.X`; no le añadas otro).
   - `Project Location`: **`D:\@Proyect\Baliza\1 Firmware\Doc mplabx`**
   - Comprueba abajo que `Project Folder` queda en `...\Doc mplabx\18f2550_baliza_ V1.X`, es decir, **encima de la carpeta que ya tiene el código**. Así `nbproject\` nace donde debe.
   - `Encoding`: **`windows-1252`**. Los fuentes están en Windows-1252 y el delimitador de trama del protocolo es el byte `0xBF`. En UTF-8 verás caracteres raros y un guardado puede corromper el protocolo. (El simulador compila con `-finput-charset=CP1252 -fexec-charset=CP1252` justo por esto.)
   - `Finish`.

7. **Añadir los ficheros que ya existen.** Botón derecho sobre cada carpeta virtual del árbol `Projects`:

   | Carpeta virtual | Menú | Qué añadir |
   |---|---|---|
   | `Source Files` | `Add Existing Item...` | los **11** `.c` |
   | `Header Files` | `Add Existing Item...` | los **12** `.h` de la raíz (incluido `UART.h`) |
   | `Header Files` | `Add Existing Items from Folders...` | la carpeta **`Rtos\`** (5 cabeceras) |

   > **No olvides `Rtos\`.** Todo el firmware son protothreads: `Cluster.h` hace `#include "Rtos/pt.h"`. Si no está, no compila.

8. **⚠ En el diálogo, `Store path as:` → `Auto` o `Relative`. NUNCA `Copy`.** Los fuentes ya están en su sitio. Si dejas que MPLAB X los copie, acabas con dos copias del firmware, editas una y compilas la otra, y el simulador (§11.2) seguirá midiendo la original.

9. **⚠ No añadas `build\`, `dist\`, ni los `startup.*` / `test_build.*` de §3.** Son artefactos viejos. Límpialos primero (§3) para no tener que distinguirlos.

10. ### ⚠ **Poner C99 — este paso es obligatorio**

    `File → Project Properties` → en el árbol, **`XC8 Global Options` → `XC8 Compiler`** → categoría **`Optimization`** o **`General`** según la versión → localiza **`C standard`** y ponlo en **`C99`**.

    **Si te lo saltas, la compilación fallará con los siete errores `(188) constant expression required` de `DS1307.c`** que explica §2, y parecerá que el código está roto. No lo está.

11. `Clean and Build` (Shift+F11). Debe decir `BUILD SUCCESSFUL`.

### 7.1 Guarda `nbproject\` junto al código. Siempre.

Cuando termines, dentro de `18f2550_baliza_ V1.X\` habrá una carpeta nueva `nbproject\` con `configurations.xml`, `project.xml` y `Makefile-*.mk`.

**Esa carpeta es parte del código fuente. Va con él a todas partes.** Es lo que faltaba y lo que ha costado este trabajo: alguien empaquetó el firmware quedándose los `.c` y tirando el proyecto, y con ello se perdió qué dispositivo era, qué compilador, **qué estándar de lenguaje** y qué ficheros entraban. Todo eso ha habido que deducirlo de un `.map` y un `.lst` que sobrevivieron por casualidad, y el asunto del C99 sólo salió a la luz al ver la compilación reventar.

- Guárdala en el control de versiones o en el ZIP, al lado de los `.c`.
- Lo que **no** se guarda: `build\`, `dist\`, `defmplabxtrace.log*`, la carpeta de `--outdir`, y los `startup.*`/`test_build.*` de §3.

---

## 8. Compilar desde la interfaz

| Quiero | Botón / menú | Atajo |
|---|---|---|
| Compilar sólo lo que cambió | **`Build Project`** (martillo) | F11 |
| Compilar todo desde cero | **`Clean and Build Project`** (martillo + escoba) | Shift+F11 |
| Compilar **y grabar** | `Make and Program Device` | — ⚠ **esto toca el hardware, lee §10 antes** |

Usa `Clean and Build` siempre que cambies cabeceras, opciones del proyecto o versión de compilador. Comprueba que la barra de configuración de arriba dice **`default`** y no `debug` si quieres un binario de producción (§8.2).

El resultado se imprime en la ventana **`Output`**, abajo, y termina en `BUILD SUCCESSFUL` o `BUILD FAILED`. El `.hex` queda en:

```
18f2550_baliza_ V1.X\dist\default\production\18f2550_baliza_ V1.X.production.hex
```

### 8.1 Cuánta memoria tiene el 18F2550 y cuánto queda

El PIC18F2550 tiene **32 KB de flash (32 768 bytes), 2 048 bytes de RAM y 256 bytes de EEPROM de datos**. Los dos primeros salen de `dist\default\debug\memoryfile.xml`; el de EEPROM del `.map` (`-AEEDATA=0F00000h-0F000FFh`).

Referencias medidas:

| Compilación | Programa | % | Datos | % |
|---|---:|---:|---:|---:|
| Producción, XC8 v2.46 (`memoryfile.xml`) | 21 640 | 66,0 | 564 | 27,5 |
| Hoy, XC8 v2.36 con `xc8.exe` | 21 309 | 65,0 | 687 | 33,5 |
| Hoy, XC8 v2.36 con `xc8-cc.exe` | 26 863 | 82,0 | 675 | 33,0 |

Cómo leerlo:

- **Program space** es la flash. Si pasa del 100 %, el enlazador falla con `can't find space` y no sale `.hex`. Con ~11 000 bytes libres hay sitio de sobra para cambios normales; lo que se come la flash de golpe son las cadenas de texto y las tablas grandes.
- **Data space** es la RAM, y es la que muerde antes: 2 KB repartidos en bancos, y el PIC18 direcciona un banco a la vez. Puedes agotar un banco concreto aunque el porcentaje global parezca bajo. El síntoma es un error que nombra un `psect` (`bssBANK1`, `cstackBANK0`...), no un simple «no cabe».
- **No compares debug contra production.** La compilación de referencia de producción es **debug**: el `.map` muestra `-ACODE=00h-07D3Fh`, o sea que el ejecutivo de depuración reserva de `0x7D40` a `0x7FFF` (704 bytes). Una compilación `production` dispone de los 32 768 completos.
- **No compares entre drivers ni entre versiones** sin decirlo. Ver §4.

---

## 9. Compilar desde la línea de comandos con el proyecto

§1 ya da el camino directo, que no necesita proyecto. Este otro compila **el proyecto**, con las opciones guardadas en `nbproject\configurations.xml` —incluido el C99—, así que es idéntico a pulsar `Clean and Build` pero desde un script.

**Herramientas comprobadas en disco:**

| Herramienta | Ruta exacta | Verificado |
|---|---|---|
| GNU Make 3.81 | `...\v5.45\gnuBins\GnuWin32\bin\make.exe` | ✅ |
| Generador de makefiles | `...\v5.45\mplab_platform\bin\prjMakefilesGenerator.bat` | ✅ (lanza `..\lib\PrjMakefilesGenerator.jar`) |
| IDE | `...\v5.45\mplab_platform\bin\mplab_ide64.exe` | ✅ |
| IPE gráfico | `...\v5.45\mplab_platform\bin\mplab_ipe64.exe` | ✅ |
| IPE por línea de comandos | `...\v5.45\mplab_platform\mplab_ipe\ipecmd.exe` | ✅ ayuda verificada (§10.4) |
| Utilidades | `hexmate.exe`, `checksum.jar`, `mdb.bat` en `mplab_platform\bin\` | ✅ |

```powershell
$MPLABX = "C:\Program Files\Microchip\MPLABX\v5.45"
$PROY   = "D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza_ V1.X"

# 1) Regenerar los makefiles desde nbproject\configurations.xml
&"$MPLABX\mplab_platform\bin\prjMakefilesGenerator.bat" "$PROY@default"

# 2) Compilar
cd "$PROY"
&"$MPLABX\gnuBins\GnuWin32\bin\make.exe" -f nbproject/Makefile-default.mk SUBPROJECTS= .build-conf
```

`$PROY@default` es la sintaxis `<ruta del proyecto>@<configuración>`; `default` es el nombre que usó la compilación original (por eso las rutas son `build\default\...`). **No he podido verificar esta sintaxis ejecutándola, porque todavía no hay proyecto que regenerar** (§14). El destino `.build-conf` y el nombre `Makefile-default.mk` los genera MPLAB X: mira dentro de `nbproject\` una vez creado. `make` devuelve 0 si compiló.

---

## 10. Grabar el PIC

> # ⚠⚠ NO GRABES SI NO TE LO HAN PEDIDO
>
> **Hay una señal montada al otro lado.** Grabar el PIC reinicia el equipo y sustituye el programa que está gobernando esa señal ahora mismo. Una baliza que se apaga, que se queda encendida, o que arranca con horarios distintos a los de la chapa atornillada, es un problema de seguridad, no un problema de software.
>
> **Compilar es gratis. Grabar no.** Puedes hacer todo lo de §1 a §9 y §11 sin acercarte a la tarjeta. Grabar es un acto separado, que se hace **cuando alguien lo pide**, sabiendo qué señal es y qué pasa mientras está sin programa.

### 10.1 Qué programador

La tarjeta expone una **cabecera ICSP de 5 pines, `J1`**, documentada en `D:\@Proyect\Baliza\HARDWARE.md` (§2.2 de ese documento, línea 66; mapa de netos en las líneas 853–870):

| Pin de `J1` | Señal | A dónde va en el PIC |
|---|---|---|
| **1** | `MCLR / VPP` | pin 1 (`MCLR`), con pull-up `R2` de 10 k a +5 V |
| **2** | `+5V` | raíl de 5 V de la tarjeta (salida del `LM78M05`) |
| **3** | `GND` | masa |
| **4** | `PGD` | pin 28 (`RB7`) |
| **5** | `PGC` | pin 27 (`RB6`) |

`HARDWARE.md` dice que es **compatible pin a pin con PICkit 3 / PICkit 4**. Esos programadores tienen 6 pines; el sexto (`PGM`/`AUX`) queda al aire y **no hace falta**, porque el firmware lleva `#pragma config LVP = OFF` (`main.h`, línea 37): se graba con **VPP alto sobre MCLR**, que es el modo por defecto.

**Herramientas que soportan el PIC18F2550**, según `...\v5.45\docs\Device Support.htm`, fila `PIC18F2550` (columnas `SNAP-D, SNAP-P, PK4-D, PK4-P, ICD4-D, ICD4-P, RICE-D, RICE-P, ICD3-D, ICD3-P, PK3-D, PK3-P, PM3, SIM-ISA, SIM-P, AICE-P, PIC-AS, XC8, XC16, XC32` con valores `R,R,G,G,G,G,G,G,G,G,G,G,G,G,Y,R,1.00,1.00,R,R`):

| Herramienta | Depurar | Grabar |
|---|---|---|
| **MPLAB Snap** | ❌ **NO** | ❌ **NO** |
| PICkit 4 | ✅ | ✅ |
| ICD 4 | ✅ | ✅ |
| REAL ICE | ✅ | ✅ |
| ICD 3 | ✅ | ✅ |
| PICkit 3 | ✅ | ✅ |
| PM3 | — | ✅ |

> **El Snap no vale para este micro.** Es el error más caro de esta lista: es el programador barato que se compra primero, y con el PIC18F2550 no funciona, no porque esté defectuoso, sino porque Microchip nunca lo soportó.

### 10.2 Cómo se conecta — y la decisión de la alimentación

**El PIC18F2550 de esta tarjeta funciona a 5 V** (`HARDWARE.md` §4: raíl `+5V` desde un `LM78M05`, PIC a 20 MHz en modo `HS`, que a 3,3 V no está garantizado). El programador tiene que trabajar a 5 V, no a 3,3 V.

Como `J1.2` está atado al raíl de 5 V de la tarjeta, **hay que decidir de dónde sale ese 5 V, y sólo puede salir de un sitio**:

| Opción | Cómo | Cuándo | Riesgo si te equivocas |
|---|---|---|---|
| **A — La tarjeta se alimenta sola** (recomendado) | Alimenta la tarjeta por `J2` con sus 12 V. En el programador, **NO** actives «power target from tool». En IPE deja `VDD` sin marcar; en `ipecmd`, **no** pongas `/W` | Es lo normal: la tarjeta ya está montada y alimentada | Ninguno |
| **B — El programador alimenta la tarjeta** | Sin 12 V en `J2`. Activa «power target» y **fija 5,0 V** | Sólo con la tarjeta en el banco, desconectada de la señal | El PICkit 3 entrega ~30 mA a 5 V. El consumo del raíl de +5 V de esta tarjeta es **≈21 mA típicos y hasta ≈70 mA de pico** (`HARDWARE.md` §4.5: el HC-06 tira 40 mA al emparejar). El programador no llega: la tensión cae y **la grabación se corta a mitad** |
| **A+B a la vez** ❌ | 12 V puestos **y** «power target» activado | Nunca | El programador empuja 5 V contra la salida del `LM78M05`. Es la forma habitual de matar el programador, el regulador, o los dos |

**Regla:** tarjeta en su sitio y enchufada → **opción A**. Tarjeta suelta en la mesa → **opción B**, y con el HC-06 fuera del zócalo para bajar el consumo.

**Antes de tocar nada:**

- **Masa común.** Si la tarjeta va con su fuente y el programador con el USB del PC, `J1.3` es lo único que las une.
- **Orientación de `J1`.** Es una tira de 5 pines sin polarizar: se puede enchufar del revés, y eso pone VPP (≈9 V) en `PGC`. Pin 1 = `MCLR/VPP`, el marcado con el triángulo del PICkit.
- **La salida CLUSTER.** Durante la grabación el micro está en reset, `RC2` queda como entrada y `R9` (4,7 k) mantiene la puerta del MOSFET a masa: el cluster queda **apagado**. Si la señal debe seguir dando luz mientras tanto, no puede.
- **La hora no se pierde**: el DS1307 tiene pila (`BT1`). **Las alarmas sí**, si grabas con borrado completo, que es el comportamiento por defecto (`ipecmd`: `OH  Erase All Before Programming ... Default: Selected`). Usa `/Z` para conservar la EEPROM.

### 10.3 Grabar desde MPLAB X

1. Conecta el programador al USB y a `J1` respetando el pin 1.
2. Resuelve la alimentación según §10.2.
3. `Production → Set Project Configuration → default` (no `debug`).
4. `File → Project Properties` → tu herramienta → **`Power`**: casilla `Power target circuit from <herramienta>` marcada o no, según §10.2. Revisa `Program Options` si quieres preservar la EEPROM.
5. `Clean and Build` (Shift+F11). Espera `BUILD SUCCESSFUL`.
6. `Make and Program Device`.
7. En `Output` debe verse la detección (`Device ID Revision`), el borrado, la programación y la verificación, y terminar en `Programming/Verify complete`.
8. Desconecta el programador. La tarjeta arranca sola.

### 10.4 Grabar desde MPLAB IPE

IPE graba un `.hex` sin compilar. Ejecutable: `...\v5.45\mplab_platform\bin\mplab_ipe64.exe`.

1. `Device`: `PIC18F2550`. 2. `Tool`: el programador. 3. `Connect` (debe leer el Device ID). 4. `Hex File → Browse`. 5. Pestaña `Power` según §10.2. 6. `Program`, luego `Verify`.

**Por línea de comandos.** Opciones **verificadas ejecutando `ipecmd.exe /?`** en esta máquina (v5.45):

| Opción | Qué hace | Por defecto |
|---|---|---|
| `/P<parte>` | Dispositivo. Ej. `/P18F2550` | — |
| `/TP<herramienta>` | Herramienta: `PK3`, `PK4`, `ICD3`, `ICD4`, `RICE`, `PM3`, `SNAP`, `PKOB`, `PKOB4` | — |
| `/F<fichero>` | El `.hex` | — |
| `/M` | **Programar** (sin región = todo) | No programa |
| `/Y` | Verificar | No verifica |
| `/E` | Borrar la flash | No borra |
| `/OH` | Borrar todo antes de programar | **Seleccionado** |
| `/Z` | **Preservar la EEPROM** | No preserva |
| `/W` | **Alimentar el objetivo desde la herramienta** | **Objetivo alimentado externamente** |
| `/J` | MCLR de alto voltaje | **Seleccionado** (correcto con `LVP = OFF`) |
| `/L` | Programación en bajo voltaje | No seleccionado (**déjalo así**) |
| `/OL` | Soltar el reset al terminar | Lo deja en reset |
| `/OD` | VDD antes que VPP (PICkit 3, ICD 3, ICD 4) | VPP primero |
| `/K` | Suma de comprobación del `.hex` | No |
| `/I` | Device ID | No |
| `/OK` | Sólo conectar | — |

Ejemplo, tarjeta alimentada por sí misma (sin `/W`), PICkit 3, conservando las alarmas:

```powershell
& "C:\Program Files\Microchip\MPLABX\v5.45\mplab_platform\mplab_ipe\ipecmd.exe" `
    /P18F2550 /TPPK3 `
    /F"D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza__V1.X.production.hex" `
    /M /Y /Z /OL
```

Prueba en seco, que no graba nada:

```powershell
& "C:\...\ipecmd.exe" /P18F2550 /TPPK3 /OK /I
```

`ipecmd` devuelve un código distinto de 0 si falla, así que se puede meter en un script.

---

## 11. Verificar antes de grabar

Tres controles. **Ninguno sustituye a los otros dos.**

### 11.1 El orden correcto

```
  1. SIMULADOR      python correr.py        ¿la lógica sigue haciendo lo que debe?
         ↓
  2. XC8            §1  (o Clean and Build) ¿compila? ¿cabe en el micro?
         ↓
  3. COMPARAR       memoria + hex           ¿cambió lo que yo quería, y sólo eso?
         ↓
  4. GRABAR         ...cuando lo pidan      §10
```

El simulador va **primero** porque es el único que se puede repetir cien veces en un minuto sin tocar nada. Compilar con XC8 dice si *cabe*, no si *funciona*.

### 11.2 El simulador de PC

```powershell
cd "D:\@Proyect\Baliza\4 Simulador"
python correr.py
```

**Qué es.** Un arnés que **compila los `.c` REALES del firmware con gcc** —los mismos ficheros que se graban en el PIC, sin copiarlos ni reescribirlos— contra un `<xc.h>` falso (`stubs\xc.h`) y una plataforma simulada (`sim\plataforma.c`), y luego los ejercita. Compila **7** de los 11: `TimeBase.c`, `LedLive.c`, `Buzzer.c`, `Cluster.c`, `Serial.c`, `Alarma.c`, `Aplicacion.c`. Los otros cuatro quedan fuera por razones escritas en la cabecera de `arnes.c`: `main.c` usa `__interrupt()` (sólo existe en XC8; su bucle principal y su ISR de Timer0 están reproducidos literalmente en `plataforma.c`), `EEprom.c` espera sobre un periférico inexistente, `DS1307.c` habla I²C con un chip que aquí no hay, e `I2C.c` sólo lo usa `DS1307.c`.

**Compila fichero a fichero, no en unidad única, y no por capricho:** `Cluster.h` no tiene guarda de inclusión (§12), y en unidad única el compilador vería dos veces la misma `struct` y el mismo `enum` y abortaría. El propio `arnes.c` lo explica en su cabecera.

**Códigos de salida:**

| Código | Significa | Qué hacer |
|---|---|---|
| **0** | **PASS** — compiló, corrió, y cumple | Sigue al paso 2 |
| **1** | **FALLA** — compiló, corrió, y NO cumple | Mira qué escenario está rojo |
| **2** | **ABORTADO** — no pudo medir | **Arregla el instrumento, no el firmware.** Suele ser que falta `D:\toolchain\mingw64\bin\gcc.exe`, o que renombraste un `.c` sin actualizar `FUENTES_FW` en `correr.py` |

**Estado hoy, medido:** código **1**, con **33 comprobaciones, 24 ok, 9 FALLA**. Es lo **esperado**: siete de esos rojos están marcados en el arnés como `[ROJO ESPERADO 21-ago-2026]` (escenarios D1 a D6) y documentan defectos reales del firmware aún sin arreglar; los otros dos están en el escenario C (duración del pulso de la luz).

> **En la práctica:** guarda la salida de hoy como línea base y compara. Lo que importa no es que salga verde, sino **que no aparezcan rojos nuevos**.
> ```powershell
> cd "D:\@Proyect\Baliza\4 Simulador"
> python correr.py > base.txt 2>&1        # antes de tocar nada
> # ... editas el firmware ...
> python correr.py > despues.txt 2>&1
> fc base.txt despues.txt
> ```

**Qué NO mide.** El propio arnés lo imprime al terminar, y hay que leerlo:

```
Lo que este arnes NO dice:
  - que la etapa de potencia encienda la luz de la senal
  - que el DS1307 conserve la hora sin alimentacion
  - que el modulo Bluetooth empareje
  - que el horario programado coincida con la chapa atornillada
  Verde aqui NO es entregable.
```

Y además:

- **No toca un solo pin real.** Ni temporizador, ni ADC, ni I²C, ni UART. `<xc.h>` es un stub.
- **No usa XC8.** Usa gcc. No dice nada sobre tamaño en flash, bancos de RAM, ni si cabe.
- **No mide tiempos reales.** No hay cristal de 20 MHz ni Timer0.
- **No prueba `main.c`, `DS1307.c`, `I2C.c` ni `EEprom.c`.** El arranque real, el reloj real y la EEPROM real quedan sin cubrir.

> ### ⚠ **Verde en el simulador NO autoriza a grabar.**
> Es una prueba de la **lógica**, corriendo en un PC. Que la lógica esté bien y que el equipo funcione son dos afirmaciones distintas, y esta herramienta sólo respalda la primera.

### 11.3 Comparar el `.hex` nuevo con el de producción

Referencia, medida sobre `18f2550_baliza__V1.X.production.hex`:

| Dato | Valor |
|---|---|
| Tamaño | 61 008 bytes, 1360 líneas |
| Bytes de programa con datos | **21 638** de 32 768 → **66,0 %** |
| Rango de programa | `0x0000` – `0x7FFF` (hay constantes de texto hasta arriba) |
| Configuración (`0x300000`) | `00 0C 18 1E FF 83 81 FF 0F C0 0F E0 0F 40` |
| IDLOCs (`0x200000`) | `FF FF FF FF FF FF FF FF` (sin usar) |

`CONFIG4L = 0x81` confirma lo que dice `main.h`: `STVREN = ON`, `LVP = OFF`, `XINST = OFF`, y el bit 7 a 1 = **DEBUG deshabilitado**, o sea que ese `.hex` es de **producción**.

```powershell
$VIEJO = "D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza__V1.X.production.hex"
$NUEVO = "D:\@Proyect\Baliza\_build\main.hex"

(Get-FileHash $VIEJO).Hash
(Get-FileHash $NUEVO).Hash
fc.exe "$VIEJO" "$NUEVO"
```

Cómo interpretarlo:

- ⚠ **Con XC8 v2.36 esta comparación NO es concluyente.** Producción se hizo con v2.46 y ya de partida hay 329 bytes de diferencia (21 638 contra 21 309) sin que nadie haya tocado el código. Para comparar de verdad, instala la v2.46 (§6).
- **Con la misma versión y las mismas banderas**: hashes iguales → no cambiaste nada que afecte al binario (si esperabas un cambio, revisa que editaste el fichero correcto y que compilaste desde cero). Cambian unas pocas líneas alrededor de lo que tocaste → normal y deseable. Cambia el fichero entero → cambió la versión, el driver, el modo de licencia o la configuración (§4).
- **Si cambian las palabras de configuración de `0x300000`**, tocaste un `#pragma config` de `main.h`. Asegúrate de que fue a propósito: ahí viven el oscilador, el watchdog, el brown-out y la protección de código.
- Compara siempre **production contra production**, y **mismo driver contra mismo driver**.

Y compara el **resumen de memoria** (§8.1). Un salto grande sin motivo casi siempre significa que arrastraste una función pesada de la biblioteca (un `printf` con `%f`, típicamente) o que cambiaste de driver.

---

## 12. Problemas frecuentes y su causa

| Síntoma | Causa | Solución |
|---|---|---|
| **`(188) constant expression required` × 7 en `DS1307.c: escribirRTC()`** | **Falta C99.** `DS1307.c:66` tiene un array `const` local inicializado con los parámetros de la función: legal en C99, ilegal en C90, que es el modo por defecto de `xc8.exe` | Añade **`--std=c99`** (§1) o pon `C standard = C99` en las propiedades del proyecto (§7 paso 10). **NO toques `DS1307.c`** |
| **Aparecen `startup.s`, `startup.o`, `test_build.*` entre los fuentes** | **Compilaste sin `--outdir`.** XC8 escribe los intermedios en el directorio de trabajo | Compila siempre con `--outdir` fuera del árbol de fuentes. Limpia con el comando de §3 |
| **El binario sale al 82 % en vez de al 65 %** | Usaste `xc8-cc.exe` en vez de `xc8.exe`. Mismo código, mismo compilador, **5 554 bytes más** | Usa `xc8.exe --chip=18f2550` (§4) |
| **El `.hex` no coincide con el de producción aunque no cambiaste nada** | Lo instalado es **v2.36**; producción se hizo con **v2.46** | Instala la v2.46 si necesitas comparar (§6). Si sólo desarrollas, anota la versión junto al `.hex` |
| **`File → Open Project` no ofrece la carpeta del firmware** | **No hay `nbproject\`** (verificado: no existe en ningún sitio) | Crear el proyecto desde cero, §7. No hay atajo |
| **En `Select Compiler` la lista sale vacía o sin XC8** | MPLAB X no ha detectado el compilador, o lo instalaste con el IDE abierto | Cierra y reabre MPLAB X, o `Tools → Options → Embedded → Build Tools → Scan for Build Tools` |
| **El comando falla con «no se encuentra la ruta», o se parte por la mitad** | **Espacios en las rutas.** `Program Files`, `1 Firmware`, `Doc mplabx`, y sobre todo **`18f2550_baliza_ V1.X` tiene un espacio antes de `V1.X`** | Entrecomilla **todas** las rutas. En PowerShell usa `& "C:\...\xc8.exe"` |
| **Avisos `unknown pragma` sobre los `#pragma config`** | `main.h` tiene **58 `#pragma config`** (líneas 12–73), directivas **de XC8** que ningún otro compilador entiende | Con XC8 no pasan: son suyos y deben aplicarse. El simulador ya los silencia (`-Wno-unknown-pragmas`). **Si XC8 te avisa de uno, no lo ignores**: ese bit no se está grabando y el micro arrancará con el valor por defecto (otro oscilador, watchdog activo...) |
| **Errores de «redefinición» de `strCluster`, `states_cluster`, `PERIOD_CLUSTER`...** | **`Cluster.h` no tiene guarda de inclusión.** Verificado: no empieza con `#ifndef CLUSTER_H` ni lleva `#pragma once`. La incluyen **tres** fuentes: `Cluster.c:6`, `Aplicacion.c:27`, `main.c:19`. Además declara `static int taskCluster(struct pt *pt);` en la cabecera, que es otra rareza. **`EEprom.h` y `UART.h` tampoco tienen guarda** | Hoy no da problemas porque cada `.c` se compila por separado y ninguno la incluye dos veces por caminos distintos. **Empezará a darlos** si: (a) alguien añade `#include "Cluster.h"` a otra cabecera ya incluida, creando inclusión doble indirecta; (b) alguien intenta compilación en unidad única — **el simulador no puede hacerlo por esta razón exacta y compila fichero a fichero** (§11.2); (c) alguien activa generación de código omnisciente. **Lo correcto es ponerle la guarda a las tres** |
| **`correr.py` devuelve 2** | Falta `D:\toolchain\mingw64\bin\gcc.exe`, o se renombró un `.c` sin actualizar `FUENTES_FW` | Es un fallo **del instrumento**, no del firmware. Arréglalo antes de sacar conclusiones. Nunca lo cuentes como «falla» |
| **El programador no conecta / no lee el Device ID** | Alimentación: o nadie alimenta la tarjeta, o la alimentan dos a la vez | §10.2. Decide A o B, nunca las dos |
| **La grabación se corta a mitad** | Alimentas desde el programador (`/W`): ~30 mA del PICkit 3 contra hasta 70 mA de pico de la tarjeta | Alimenta por `J2` y quita `/W`. O quita el HC-06 del zócalo |
| **El Snap no reconoce el micro** | **MPLAB Snap no soporta el PIC18F2550** (verificado en `docs\Device Support.htm`) | PICkit 3, PICkit 4, ICD 3, ICD 4, REAL ICE o PM3 |
| **Tras grabar, las alarmas están perdidas** | El borrado completo antes de programar está activado por defecto y borra la EEPROM del PIC, donde viven las alarmas | Usa `/Z` en `ipecmd`, o la opción equivalente en el proyecto / IPE. La **hora** no se pierde: el DS1307 tiene pila |
| **Caracteres raros en los `.c`** | Los fuentes están en **Windows-1252** y el delimitador del protocolo es el byte `0xBF` | Pon el proyecto en `windows-1252` (§7 paso 6). Si lo guardas en UTF-8, rompes el protocolo con la app del móvil |

---

## 13. Procedimiento resumido — una página

### Compilar hoy (no hace falta nada más)

```powershell
cd "D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza_ V1.X"
& "C:\Program Files\Microchip\xc8\v2.36\bin\xc8.exe" --chip=18f2550 --std=c99 --outdir="D:\@Proyect\Baliza\_build" main.c Alarma.c Aplicacion.c Buzzer.c Cluster.c DS1307.c EEprom.c I2C.c LedLive.c Serial.c TimeBase.c
```
`.hex` → `D:\@Proyect\Baliza\_build\main.hex` · Esperado: **65,0 % programa · 33,5 % datos**
**`--std=c99` obligatoria** (si no, 7 errores en `DS1307.c`) · **`--outdir` obligatoria** (si no, ensucia los fuentes) · **`xc8.exe`, no `xc8-cc.exe`** (82 % en vez de 65 %)

### Preparar el IDE (una sola vez, sólo si quieres usar MPLAB X)

1. Limpiar la basura de §3: `Remove-Item startup.lst,startup.o,startup.rlf,startup.s,test_build.*`
2. Abrir `C:\Program Files\Microchip\MPLABX\v5.45\mplab_platform\bin\mplab_ide64.exe`
3. `File → New Project → Microchip Embedded → Standalone Project`
4. Device **`PIC18F2550`** · Tool: el programador (**no Snap**) · Compiler **XC8 (v2.36)**
5. Name `18f2550_baliza_ V1.X` · Location `D:\@Proyect\Baliza\1 Firmware\Doc mplabx` · Encoding **`windows-1252`**
6. `Source Files → Add Existing Item`: los 11 `.c`. **`Store path as: Auto`, NUNCA `Copy`**
7. `Header Files`: los 12 `.h` + `Add Existing Items from Folders` → **`Rtos\`**
8. **`Project Properties → XC8 Compiler → C standard = C99`** ← obligatorio
9. `Clean and Build` (Shift+F11) → `BUILD SUCCESSFUL`
10. **Guardar `nbproject\` junto al código.** No guardar `build\` ni `dist\`

### Cada vez que se modifica algo

1. Editar el `.c` / `.h`.
2. `cd "D:\@Proyect\Baliza\4 Simulador"` → `python correr.py`
   `0` PASS · `1` FALLA · `2` **ABORTADO = arreglar el instrumento, no el firmware**
   Línea base de hoy: **código 1, 33 comprobaciones, 24 ok, 9 FALLA.** Que no aparezcan rojos nuevos.
3. Compilar (comando de arriba, o `Clean and Build` con configuración **`default`**).
4. Leer el resumen de memoria. Referencias: **v2.46 → 66,0 % / 27,5 %** · **v2.36 `xc8.exe` → 65,0 % / 33,5 %**.
5. **Anotar junto al `.hex`: versión de XC8, driver, línea de órdenes completa, fecha y resumen de memoria.**
6. Comparar con `18f2550_baliza__V1.X.production.hex` — **sólo concluyente si compilaste con v2.46**.
7. **PARAR AQUÍ.** No grabar.

### Grabar — sólo cuando lo pidan

1. Confirmar que lo piden. **Hay una señal montada al otro lado.**
2. Alimentación: **tarjeta por `J2` (12 V) → NO activar «power target»**. O tarjeta suelta → «power target» a 5,0 V. **Nunca las dos.**
3. Conectar a `J1` (1=`MCLR/VPP`, 2=`+5V`, 3=`GND`, 4=`PGD`, 5=`PGC`). **Respetar el pin 1.**
4. MPLAB X: `Make and Program Device`. O IPE: `PIC18F2550` → `Tool` → `Connect` → `Hex File` → `Program` → `Verify`.
5. O por línea de comandos:
   ```
   "C:\Program Files\Microchip\MPLABX\v5.45\mplab_platform\mplab_ipe\ipecmd.exe" /P18F2550 /TPPK3 /F"<ruta.hex>" /M /Y /Z /OL
   ```
6. Verificar. Desconectar. Comprobar el LED de vida (`D1`, parpadea) y el horario contra la chapa.

---

## 14. Preguntas abiertas

Lo que **no** he podido comprobar. Están como preguntas, no como suposiciones disfrazadas de hecho.

1. **¿Por qué a otro operador le falló `xc8-cc.exe` con `(2043) target device was not recognized`?** **No he podido reproducirlo.** Hoy, en esta máquina, `xc8-cc.exe -mcpu=18F2550 -std=c99` compiló los 11 fuentes con código de salida 0 (aunque produjo 26 863 bytes, 82,0 %, frente a los 21 309 de `xc8.exe`). Probé además mayúsculas y minúsculas en el nombre del dispositivo con los dos drivers: los cuatro casos funcionan. **Pregunta: ¿con qué combinación exacta de banderas salió ese error?** Mientras no se sepa, la recomendación de §4 (`xc8.exe`) se sostiene igual, por el tamaño.

2. **¿Merece la pena instalar la v2.46?** Depende de para qué (§6). **Pregunta al usuario: ¿el objetivo es reproducir/actualizar el firmware que está en la señal, o desarrollar y probar cambios?** Si es lo primero, hay que instalarla; si es lo segundo, la v2.36 sirve y basta con anotar la versión.

3. **¿Se puede reproducir bit a bit el `.hex` de producción?** No se sabrá hasta instalar la v2.46 y compilar el código **sin modificar**. Merece la pena hacerlo **antes** de tocar nada: si sale idéntico, queda demostrado que la reconstrucción del proyecto es correcta y toda diferencia posterior es tuya. Si sale distinto, hay que averiguar por qué **antes** de empezar, no después.

4. **¿Qué programador tiene el usuario exactamente?** No queda ninguna pista: `nbproject\configurations.xml`, donde se guarda la herramienta seleccionada, se perdió. El `.map` sólo prueba que fue una compilación **debug**, o sea que había una herramienta con capacidad de depuración conectada (el Snap queda descartado porque no soporta el 18F2550). **Pregunta: ¿PICkit 3, PICkit 4, o ICD 3?** De ello dependen el código `/TP...` de `ipecmd` y si se puede alimentar la tarjeta desde el programador.

5. **¿Por qué exactamente fallan las versiones nuevas de MPLAB X con sus programadores?** La hipótesis que encaja es que Microchip retiró el soporte de PICkit 3 / ICD 3 / REAL ICE en las versiones posteriores a la 5.45. **No lo he podido verificar sin acceso a las notas de versión.** Lo que sí está verificado es que **esta** instalación los soporta para el PIC18F2550. **Pregunta: ¿el programador es uno de los tres retirados?** Si lo es, queda cerrado el asunto y no hay que volver a plantear actualizar.

6. **La URL y el nombre del instalador de XC8 v2.46.** No tengo red desde aquí. Búscalo como «MPLAB XC8 Compiler → Downloads Archive → v2.46, Windows».

7. **La sintaxis exacta de `prjMakefilesGenerator.bat`.** El `.bat` existe (verificado, es un lanzador de `..\lib\PrjMakefilesGenerator.jar`), pero no imprime ayuda y no hay proyecto sobre el que probarlo. La forma `<ruta>@<configuración>` es la documentada por Microchip. **Confirmar cuando exista el proyecto**, y mirar dentro de `nbproject\` cómo se llama el makefile generado (se espera `Makefile-default.mk`).

8. **¿Qué contiene la EEPROM del PIC de la tarjeta montada?** Las alarmas programadas viven ahí. Antes de grabar convendría leerla (`ipecmd ... /GE0-FF`) y guardarla para poder restaurarla. No se puede hacer desde aquí: hace falta la tarjeta y el programador.

---

## 15. Binario Oficial de Producción Validado en Banco (21-Ago-2026) — ✅ OK

El firmware oficial para grabación en campo ha sido compilado con XC8 v2.36 (C99) y probado exitosamente en hardware real con la app móvil Android `IT VIAL 30` (v3.3):

* **Archivo HEX Oficial:** [`1 Firmware/BALIZA_18F2550_V1_CORREGIDO.hex`](../1%20Firmware/BALIZA_18F2550_V1_CORREGIDO.hex)
* **Tamaño:** 21.147 bytes de Flash (64,5 %) y 688 bytes de RAM.
* **Comando de Grabación Directa (PICkit 3):**
  ```powershell
  "C:\Program Files\Microchip\MPLABX\v5.45\mplab_platform\mplab_ipe\ipecmd.exe" /P18F2550 /TPPK3 /F"D:\@Proyect\Baliza\1 Firmware\BALIZA_18F2550_V1_CORREGIDO.hex" /M /Y /Z /OL
  ```

---

*Documento generado el 21 de agosto de 2026. Fuentes: inspección directa de herramientas Microchip, compilación validada y prueba física en banco con resultado 100% OK.*
