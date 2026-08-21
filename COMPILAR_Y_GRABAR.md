# Compilar el firmware de la baliza y grabarlo en el PIC

**Responde a:** *«¿cómo se compilaría lo que modifiquemos?»*

**Fecha de comprobación:** 21 de agosto de 2026. Todo lo que dice este documento sobre *esta* máquina se comprobó en disco ese día. Lo que no se pudo comprobar está al final, en **§10 Preguntas abiertas**, y está marcado como pregunta, no como hecho.

**Respuesta corta, actualizada el 21-ago-2026 a las 15:28:** **el firmware YA COMPILA en esta máquina.** XC8 v2.36 se instaló mientras se redactaba este documento, y la compilación se ha ejecutado y verificado con éxito. El comando exacto está en **§2.3**.

Queda **un** asunto abierto, y no impide compilar: **no existe el proyecto de MPLAB X** (`nbproject\`), así que hoy se compila **por línea de comandos**. Para trabajar desde el IDE hay que recrear el proyecto (§1 y §3).

> **Dos avisos que hay que leer antes de compilar:**
> 1. **`--std=c99` es obligatorio.** Sin esa bandera el firmware **no compila**. Ver **§2.4**, que es el hallazgo principal de este documento.
> 2. **Lo instalado es la v2.36; producción se hizo con la v2.46.** El `.hex` que salga **no es comparable byte a byte** con el de producción. Ver **§2.5**.

---

## 0. Estado de la máquina, comprobado

| Cosa | Estado | Cómo se comprobó |
|---|---|---|
| MPLAB X IDE v5.45 | ✅ **Instalado** | `C:\Program Files\Microchip\MPLABX\v5.45\` existe, con `mplab_platform\bin\mplab_ide64.exe` |
| Instalador de MPLAB X 5.45 guardado | ✅ Sí | `D:\@Proyect\Baliza\6 Sw pic\MPLABX-v5.45-windows-installer.exe` |
| Compilador XC8 | ✅ **INSTALADO — v2.36** | `C:\Program Files\Microchip\xc8\v2.36\`. `pic\bin\picc18.exe --ver` → «Microchip MPLAB XC8 C Compiler **V2.36**, Build date: Jan 27 2022, Part Support Version: 2.36». Ejecutables en `v2.36\bin\`: `xc8.exe`, `xc8-cc.exe`, `xc8-ar.exe`, `xclm.exe`, `verifyinst.exe` |
| Instalador de XC8 v2.36 guardado | ✅ Sí | `D:\@Proyect\Baliza\6 Sw pic\xc8-v2.36-full-install-windows-x64-installer.exe` (71 559 672 bytes ≈ 68,2 MiB) |
| **Compilación del firmware** | ✅ **FUNCIONA** | Ejecutada el 21-ago-2026: **código de salida 0**, genera `main.hex` (60 044 bytes). Comando y salida en §2.3 |
| Soporte del PIC18F2550 en XC8 v2.36 | ✅ Presente | Existen `pic\dat\cfgdata\18f2550.cfgdata`, `pic\dat\ini\18f2550.ini` y `pic\include\proc\pic18f2550.h` |
| Proyecto de MPLAB X del firmware | ❌ **NO existe** | `find D:\@Proyect\Baliza -iname nbproject` no devuelve nada. **Es el único bloqueo que queda**, y sólo afecta a trabajar desde el IDE. Ver §1 |
| Paquete de dispositivo PIC18F2550 | ✅ Instalado | `...\v5.45\packs\Microchip\PIC18Fxxxx_DFP\1.2.26\edc\PIC18F2550.PIC` |
| `.hex` de producción ya compilado | ✅ Existe | `D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza__V1.X.production.hex` (61 008 bytes, 1360 líneas, fecha 16-oct-2025) |
| Simulador de PC | ✅ Funciona | `D:\@Proyect\Baliza\4 Simulador\correr.py`, ejecutado el 21-ago-2026: código de salida **1**, 33 comprobaciones, 24 ok, 9 FALLA |
| gcc para el simulador | ✅ Existe | `D:\toolchain\mingw64\bin\gcc.exe` (ruta fija en `correr.py`) |
| Python | ✅ 3.12.10 | `python --version` |

**Sobre la versión de MPLAB X: no la actualices.** El usuario ya dijo que las versiones nuevas no le funcionan con sus programadores, y hay una razón técnica que apoya eso: la tabla de soporte que trae esta instalación (`C:\Program Files\Microchip\MPLABX\v5.45\docs\Device Support.htm`, fila `PIC18F2550`) marca en **verde** PICkit 3, ICD 3, REAL ICE, PICkit 4, ICD 4 y PM3. Esos tres primeros son herramientas que Microchip retiró de las versiones posteriores del IDE. Ver §10.

---

## 1. ⚠ BLOQUEO PRINCIPAL: no hay proyecto de MPLAB X

La carpeta del firmware es:

```
D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza_ V1.X\
```

(ojo: hay un **espacio** entre `18f2550_baliza_` y `V1.X`.)

Dentro hay **el código** y **los restos de una compilación antigua**, pero **no hay `nbproject\`**:

```
Alarma.c/.h   Aplicacion.c/.h   Buzzer.c/.h   Cluster.c/.h   DS1307.c/.h
EEprom.c/.h   I2C.c/.h          LedLive.c/.h  Serial.c/.h    TimeBase.c/.h
UART.h        main.c/.h         Rtos\  (5 cabeceras: pt.h, pt-sem.h, lc.h,
                                        lc-switch.h, lc-addrlabels.h)
build\        dist\             defmplabxtrace.log
```

Un proyecto de MPLAB X **es** la carpeta `nbproject\`: ahí viven `configurations.xml` (dispositivo, compilador, herramienta de programación, lista de ficheros) y `project.xml`. **Sin esa carpeta, MPLAB X no reconoce `18f2550_baliza_ V1.X` como proyecto y no la puede abrir.** `File → Open Project` simplemente no la ofrecerá.

Comprobado: la búsqueda `nbproject` / `configurations.xml` / `project.xml` sobre **todo** `D:\@Proyect\Baliza` no encuentra ni un fichero.

> **Consecuencia:** el paso 1 del procedimiento no es «abrir el proyecto». Es **crear el proyecto** (§3). Es media hora de trabajo, y hay que hacerla una sola vez si después se guarda `nbproject\` junto al código.

### 1.1 Lo que sí sobrevivió: la prueba de con qué se compiló

`build\` y `dist\` son los artefactos de la última compilación real, del **17 de septiembre de 2025 a las 18:36:11**. Ahí está la información que permite reconstruir el proyecto sin adivinar:

| Dato | Valor | Fichero que lo prueba |
|---|---|---|
| Compilador | **MPLAB XC8 v2.46**, build `20240104201356` | `dist\default\debug\18f2550_baliza__V1.X.debug.map`, línea 1: `Microchip MPLAB XC8 Compiler V2.46` |
| Dónde estaba instalado | `C:\Program Files\Microchip\xc8\v2.46\` | mismo `.map`, línea 6: `--edf=C:\Program Files\Microchip\xc8\v2.46\pic\dat\20240104201356_en.msgs` |
| Licencia | **Free** (no PRO) | `dist\default\debug\18f2550_baliza__V1.X.debug.lst`: `Microchip MPLAB XC8 C Compiler v2.46 (Free license) build 20240104201356 Og1` |
| Dispositivo | `18F2550` | mismo `.map`: `-Q18F2550`, `Machine type is 18F2550` |
| Configuración compilada | `default` / `debug` | rutas `build\default\debug\`, `dist\default\debug\` |
| Ficheros `.c` que entraron | **11**, exactamente los `.c` que hay en la carpeta | `build\default\debug\`: `Alarma, Aplicacion, Buzzer, Cluster, DS1307, EEprom, I2C, LedLive, Serial, TimeBase, main` (`.p1`) |

Nótese que **`UART.h` no tiene `.c`**: es sólo cabecera. Y que `Rtos\` son sólo cabeceras, no hay `.c` que compilar allí.

---

## 2. Qué hay que instalar, en orden

### 2.1 MPLAB X IDE v5.45 — ya está

Nada que hacer. Si algún día hay que reinstalarlo, el instalador está guardado:

```
D:\@Proyect\Baliza\6 Sw pic\MPLABX-v5.45-windows-installer.exe
```

**No lo actualices.** Ver §0 y §10.

### 2.2 MPLAB XC8 — ✅ v2.36 YA INSTALADA

**MPLAB X no trae compilador.** Es un IDE: gestiona proyectos, habla con los programadores y depura, pero el que convierte `.c` en código de PIC es XC8, que se instala **aparte** y se descarga **aparte**.

**Estado actual, comprobado el 21-ago-2026:**

```
C:\Program Files\Microchip\xc8\v2.36\
    bin\xc8.exe          ← driver clásico. ES EL QUE FUNCIONA
    bin\xc8-cc.exe       ← driver nuevo. Ver §2.6, hoy falla con este dispositivo
    bin\xc8-ar.exe
    pic\bin\picc18.exe   ← compilador de PIC18 propiamente dicho
```

Verificación:

```powershell
& "C:\Program Files\Microchip\xc8\v2.36\pic\bin\picc18.exe" --ver
# Microchip MPLAB XC8 C Compiler V2.36
# Build date: Jan 27 2022
# Part Support Version: 2.36
```

**Nada que instalar para poder compilar.** Si hiciera falta reinstalarlo, el instalador está guardado en `D:\@Proyect\Baliza\6 Sw pic\xc8-v2.36-full-install-windows-x64-installer.exe`.

> **Si alguna vez hay que reinstalarlo, dos cosas:**
> - **La instalación pide permisos de administrador.** **La tiene que lanzar el usuario a mano**, haciendo doble clic sobre el instalador. No se puede automatizar desde una sesión sin privilegios.
> - En el asistente, marca las casillas de **añadir XC8 al `PATH`** y de **integrar con MPLAB X** (*Update MPLAB X…*). Sin la primera, los comandos de §5 exigen escribir la ruta completa. Sin la segunda, XC8 no aparecerá en la lista de compiladores al crear el proyecto (§3).

---

### 2.3 ✅ El comando que compila — probado y funcionando

```powershell
cd "D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza_ V1.X"

& "C:\Program Files\Microchip\xc8\v2.36\bin\xc8.exe" `
    --chip=18f2550 `
    --std=c99 `
    --outdir=<carpeta_de_salida> `
    main.c Alarma.c Aplicacion.c Buzzer.c Cluster.c DS1307.c `
    EEprom.c I2C.c LedLive.c Serial.c TimeBase.c
```

**Resultado: código de salida 0.** Genera **`main.hex`** en la carpeta de salida (60 044 bytes en la prueba).

**Resumen de memoria real que imprime** — guárdalo como referencia para saber si un cambio futuro se pasó de sitio:

```
Memory Summary:
    Program space        used  533Dh ( 21309) of  8000h bytes   ( 65.0%)
    Data space           used   2AFh (   687) of   800h bytes   ( 33.5%)
    Configuration bits   used     7h (     7) of     7h words   (100.0%)
    EEPROM space         used     0h (     0) of   100h bytes   (  0.0%)
    ID Location space    used     0h (     0) of     8h bytes   (  0.0%)
```

**Quedan libres unos 11 000 bytes de flash y 1 361 bytes de RAM.** Si un cambio hace que «Program space» pase del 90 %, párate y revisa qué has metido.

> **Fíjate en que `UART.h` no aparece en la lista de ficheros.** Es correcto: `UART.h` **no es una cabecera normal, contiene el código de las funciones** y se incluye desde `main.c`. Si lo añades a la línea de comandos, obtendrás errores de símbolo duplicado.

#### Avisos que salen y NO son fallos

La compilación imprime bastante ruido. **Todo esto es esperado. No lo arregles.**

| Aviso | Dónde | Por qué es normal |
|---|---|---|
| `(228) illegal character (0xBF)` | `Serial.c:148` | Es el **delimitador de inicio de trama** del protocolo. Es intencionado. Ver `MANUAL_FUNCIONAL_BLUETOOTH.md` §8 |
| `(359) illegal conversion between pointer types` | `Serial.c:184` y `:189` | Conversiones entre `char*` y `unsigned char*` del código original |
| `non-reentrant function … has been duplicated by the compiler` | `_vfprintf`, `_dtoa`, `_stoa`, `_pad`, `_UART_write`, `_putch`, `_strlen`, `_fputc`… | Ver abajo |

**Sobre la duplicación de funciones**, que es la lista más larga y la más llamativa: el PIC18 no tiene pila de datos, así que XC8 asigna las variables locales en direcciones fijas. Si una función se llama **desde dos grafos de llamada distintos** —por ejemplo desde el programa principal **y desde una interrupción**— el compilador no puede compartir esas direcciones y **genera dos copias del código**.

Aquí pasa porque se usa `printf`/`sprintf` desde varios sitios, y porque `UART_write` se llama tanto desde la aplicación como desde la interrupción de `main.c`. **Esa duplicación es una de las razones de que el programa ocupe el 65 % de la flash.** Es un coste conocido y aceptado, no un error.

---

### 2.4 ⚠️ `--std=c99` NO ES OPCIONAL — el hallazgo principal

> ### Sin `--std=c99`, el firmware NO COMPILA
>
> El driver `xc8.exe` compila en **C90** por defecto. En C90 el código falla.

**Comprobado.** Ejecutando el mismo comando de §2.3 **sin** la bandera `--std=c99`:

```
DS1307.c
DS1307.c: escribirRTC()
    66:	const uint8_t rtc_datos[7]={hor, min, seg, dia, mes, ano, diaSe};
	                               ^ (188) constant expression required
	 (188) constant expression required ^
	      (188) constant expression required ^
	           (188) constant expression required ^
	                (188) constant expression required ^
	                     (188) constant expression required ^
	                            (188) constant expression required ^
(908) exit status = 1
```

**Código de salida: 1. No se genera `.hex`.**

**Qué pasa exactamente.** La línea 66 de `DS1307.c` declara un array `const` **local**, inicializado con los **parámetros de la función**:

```c
const uint8_t rtc_datos[7] = {hor, min, seg, dia, mes, ano, diaSe};
```

En **C90**, los inicializadores de un array deben ser *expresiones constantes* conocidas en tiempo de compilación. Los parámetros de una función no lo son. En **C99** esto es perfectamente legal.

> ### La conclusión, y es importante
>
> **El proyecto original estaba configurado en C99.** No es que el código esté mal: es que se está compilando con el estándar equivocado.
>
> **NO TOQUES `DS1307.c`.** La tentación de «arreglar» esa línea desmontando el array es un error: cambiaría código probado que hoy funciona en las señales instaladas, para resolver un problema que se resuelve con una bandera.
>
> **La solución es compilar en C99.** Nada más.

**Al recrear el proyecto en MPLAB X (§3), hay que ponerlo a mano:**

`Project Properties` → `XC8 Global Options` (o `XC8 Compiler`) → **`C standard` → `C99`**

**Si no lo haces, te encontrarás ese error 188 y creerás que el código está roto.** No lo está.

*Esto encaja con lo que ya decía el `.lst` de producción (§1.1): el proyecto original se compiló con XC8 v2.46 en licencia Free, y en C99.*

---

### 2.5 ⚠️ Discrepancia de versión: producción es v2.46, aquí hay v2.36

**Los dos datos, ambos verificados:**

| | Versión | Cómo se sabe |
|---|---|---|
| **Firmware de producción** | **XC8 v2.46** | El `.map` de `dist\default\debug\` dice literalmente «Microchip MPLAB XC8 Compiler **V2.46**» y todas sus rutas internas apuntan a `C:\Program Files\Microchip\xc8\v2.46\` |
| **Instalado hoy** | **XC8 v2.36** | `picc18.exe --ver` |

**Por qué se bajó la v2.36:** por compatibilidad con MPLAB X 5.45, que es la versión del IDE instalada y la que el usuario no quiere actualizar.

**Qué significa esto en la práctica:**

- ✅ **La v2.36 sirve perfectamente para compilar y para seguir desarrollando.** Está probado (§2.3).
- ❌ **Pero el `.hex` que salga NO será comparable con `18f2550_baliza__V1.X.production.hex`.** Lo generó otra versión del compilador, así que cambian el tamaño, la disposición en memoria y posiblemente los tiempos del código generado. **Una comparación byte a byte (§7.3) no tiene sentido entre versiones distintas.**

**Recomendación razonada — elige según lo que quieras hacer:**

| Si tu objetivo es… | Entonces… |
|---|---|
| **Reproducir y comparar** con lo que hay instalado en las señales | **Instala la v2.46.** Es la única forma de que una diferencia en el `.hex` signifique «lo cambié yo» y no «cambió el compilador» |
| **Sólo seguir desarrollando** y grabar firmware nuevo | **La v2.36 vale y basta.** Deja escrito en el proyecto con qué versión se compiló |

> ### 📌 La versión del compilador es un dato del entregable
>
> **Ahora mismo sólo se sabe con qué se compiló producción por casualidad, leyendo un fichero de mapa que casualmente sobrevivió.** Eso no puede volver a pasar.
>
> **A partir de ahora, junto a cada `.hex` que se entregue tiene que quedar anotado:**
> - la **versión exacta de XC8** (`picc18.exe --ver`),
> - el **tipo de licencia** (Free o PRO),
> - las **banderas de compilación** usadas (como mínimo `--chip` y `--std`),
> - la **fecha** de compilación.
>
> **Las banderas importan tanto como la versión.** Prueba de ello: para este mismo código se han medido **21 640 bytes** (66,0 %, del `memoryfile.xml` original), **21 309 bytes** (65,0 %, la compilación de hoy — cifras que casan bien) y **26 863 bytes** (82,0 %, otra compilación de esta misma sesión con banderas distintas). **El mismo código fuente, tres tamaños.** Sin anotar las banderas, ese número no significa nada.

---

### 2.6 El driver `xc8-cc.exe` hoy no funciona con este dispositivo

XC8 trae **dos** drivers. El clásico (`xc8.exe`) y el nuevo (`xc8-cc.exe`). **Usa el clásico.**

```powershell
# ✅ FUNCIONA
& "C:\Program Files\Microchip\xc8\v2.36\bin\xc8.exe" --chip=18f2550 --std=c99 ...

# ❌ FALLA
& "C:\Program Files\Microchip\xc8\v2.36\bin\xc8-cc.exe" -mcpu=18F2550 ...
# (2043) target device was not recognized
```

**Y el dispositivo sí está soportado** — existen `pic\dat\cfgdata\18f2550.cfgdata`, `pic\dat\ini\18f2550.ini` y `pic\include\proc\pic18f2550.h`. Así que el fallo es de invocación, no de soporte.

**No se ha averiguado la forma correcta de llamar a `xc8-cc` para este dispositivo.** Queda en §10 como pregunta abierta. **Mientras tanto, `xc8.exe` es el camino bueno y está probado.**

---

### 2.7 Si algún día se instala la v2.46 — por qué esa y no la última

**Tres razones:**

1. **Para poder comparar.** El `.hex` que hay hoy en producción salió de XC8 v2.46 en modo Free. Si compilas con otra versión, el binario nuevo se diferenciará del viejo por dos motivos mezclados —tus cambios y el cambio de compilador— y ya no podrás saber cuál de los dos causó qué. Con la misma versión, cualquier diferencia en el `.hex` es **tuya**.
2. **Porque cambia el tamaño y los tiempos.** Otra versión de XC8 genera otro código: otro tamaño en flash, otro número de ciclos por función, otro reparto de bancos de RAM. En un 18F2550 al 66 % de la flash (§4.2) eso importa. Y en un firmware que temporiza con Timer0 y protothreads, un cambio de ciclos puede mover comportamientos.
3. **Porque puede cambiar el comportamiento.** Este código depende de detalles que las versiones de compilador tratan distinto. El caso concreto y comprobado: `strAplicacion ap;` está definida **sin `extern`** en `Aplicacion.c` **y** otra vez en `LedLive.c`, y `srtAlarmas ala1..ala5` están definidas dos veces, en `Serial.c` y en `Alarma.c`. Son *definiciones tentativas*. XC8 las fusiona en un solo objeto y por eso el firmware funciona. Un compilador que deje de fusionarlas rompe el programa. (Esto está documentado en la cabecera de `D:\@Proyect\Baliza\4 Simulador\arnes.c`, y es la razón de que el simulador use `-fcommon`.)

**Modo Free.** El `.lst` prueba que el firmware actual se compiló con **licencia Free**. En modo Free XC8 aplica sólo el nivel de optimización básico (el `.lst` lo marca como `Og1`); los niveles altos de la optimización OCG son de la licencia PRO. Consecuencias prácticas:

- Instala XC8 y **déjalo en Free** (es lo que hace por defecto cuando no hay licencia). Si activaras PRO, el binario saldría más pequeño y **dejaría de ser comparable** con el de producción.
- El código de producción ocupa lo que ocupa **porque está sin optimizar**. Los 11 128 bytes libres (§4.2) son un colchón real, no uno que dependa del compilador.

**Dónde se descargan las versiones antiguas.** En la web de Microchip, en la página del compilador (*MPLAB® XC8 Compiler*, dentro de *Tools and Resources → Develop → Compilers*), hay una pestaña de **archivo de versiones** (*Downloads Archive*) con todas las versiones antiguas de XC8, la v2.46 incluida. Es una descarga gratuita, no hace falta licencia para el modo Free. **No he podido verificar la URL exacta ni el nombre del fichero desde esta máquina** (sin red); ver §10.

**Dónde instalarlo:** deja la ruta por defecto, `C:\Program Files\Microchip\xc8\v2.46\`, que es exactamente donde estaba antes según el `.map`. Marca la casilla que añade XC8 al `PATH` si quieres usar la línea de comandos (§5).

**Comprueba después de instalar** — usa `picc18.exe`, que es el que da la versión de forma fiable:

```powershell
dir "C:\Program Files\Microchip\xc8\v2.46\bin"
& "C:\Program Files\Microchip\xc8\v2.46\pic\bin\picc18.exe" --ver
```

**Y compila con el driver clásico y C99**, igual que en §2.3, cambiando `v2.36` por `v2.46` en la ruta. **Las dos versiones pueden convivir instaladas a la vez** en carpetas distintas; lo que decide cuál usas es la ruta que escribas en el comando.

---

## 3. Recrear el proyecto de MPLAB X

Con XC8 ya instalado (si no, XC8 no aparecerá en la lista del paso 5 y no podrás terminar).

Abre `C:\Program Files\Microchip\MPLABX\v5.45\mplab_platform\bin\mplab_ide64.exe`.

1. **`File → New Project`** (o Ctrl+Shift+N).
2. **Categoría `Microchip Embedded` → tipo `Standalone Project`** → `Next`.
   *No* elijas `Existing MPLAB IDE v8 Project` ni `Prebuilt (Hex, Loadable Image) Project`.
3. **`Select Device`**: en `Family` pon `Advanced 8-bit MCUs (PIC18)` y en `Device` escribe **`PIC18F2550`** → `Next`.
4. **`Select Tool`**: elige tu programador de la lista. Si está conectado por USB aparece con su número de serie; si no, aparece igualmente en la lista genérica. Para el PIC18F2550 esta instalación da soporte verde a **PICkit 3, PICkit 4, ICD 3, ICD 4, REAL ICE y PM3**. **MPLAB Snap NO sirve para este micro** (ver §6.1). Si aún no sabes cuál usarás, elige `Simulator` y cámbialo luego en las propiedades del proyecto → `Next`.
5. **`Select Compiler`**: elige **`XC8 (v2.46)`**. **Si la lista sale vacía o no aparece XC8, es que no lo has instalado, o lo instalaste con MPLAB X abierto.** Cierra MPLAB X, instala XC8, vuelve a abrir → `Next`.
6. **`Select Project Name and Folder`**:
   - `Project Name`: **`18f2550_baliza_ V1.X`** — sin `.X` extra: MPLAB X añade `.X` solo si no lo pones, y aquí el nombre ya lo lleva. El objetivo es que el proyecto se llame igual que la carpeta que ya existe.
   - `Project Location`: **`D:\@Proyect\Baliza\1 Firmware\Doc mplabx`**
   - Comprueba abajo que `Project Folder` queda en `D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza_ V1.X` — es decir, **el proyecto se crea encima de la carpeta que ya tiene el código**. Así `nbproject\` nace donde tiene que estar.
   - `Encoding`: **pon `windows-1252`**. Los fuentes están en Windows-1252 y el delimitador de trama del protocolo es el byte `0xBF`. Si lo dejas en UTF-8, verás caracteres raros en el editor y corres el riesgo de que un guardado te corrompa el protocolo. (El simulador compila con `-finput-charset=CP1252 -fexec-charset=CP1252` justo por esto; ver `correr.py`.)
   - `Finish`.

7. **Añadir los ficheros que ya existen.** En la ventana `Projects`, botón derecho sobre cada carpeta virtual:

   | Carpeta virtual | Menú | Qué añadir |
   |---|---|---|
   | `Source Files` | **`Add Existing Item...`** | los 11 `.c`: `Alarma.c`, `Aplicacion.c`, `Buzzer.c`, `Cluster.c`, `DS1307.c`, `EEprom.c`, `I2C.c`, `LedLive.c`, `main.c`, `Serial.c`, `TimeBase.c` |
   | `Header Files` | **`Add Existing Item...`** | los 12 `.h` de la raíz: `Alarma.h`, `Aplicacion.h`, `Buzzer.h`, `Cluster.h`, `DS1307.h`, `EEprom.h`, `I2C.h`, `LedLive.h`, `main.h`, `Serial.h`, `TimeBase.h`, `UART.h` |
   | `Header Files` | **`Add Existing Items from Folders...`** | la carpeta **`Rtos\`** (5 cabeceras: `pt.h`, `pt-sem.h`, `lc.h`, `lc-switch.h`, `lc-addrlabels.h`) |

   > **No olvides `Rtos\`.** Todo el firmware son protothreads: `Cluster.h` hace `#include "Rtos/pt.h"`. Si no está, no compila. Aunque técnicamente basta con que los ficheros estén en disco, añadirlos al proyecto es lo que hace que se vean en el árbol y que la navegación del IDE funcione.

8. **⚠ En el diálogo de añadir ficheros, elige `Auto` o `Relative` — NUNCA `Copy`.**
   El desplegable `Store path as:` del diálogo `Add Existing Item` ofrece copiar el fichero dentro del proyecto. **No lo hagas.** Los fuentes ya están en su sitio; si dejas que MPLAB X los copie, acabas con dos copias del firmware, editas una y compilas la otra, y el simulador (§7) seguirá midiendo la original. Usa `Auto` (que resuelve a ruta relativa, porque están dentro de la carpeta del proyecto).

9. **⚠ `build\` y `dist\` que ya están ahí son basura vieja, de septiembre de 2025.** No los añadas al proyecto y no te fíes de lo que contienen. En cuanto compiles, MPLAB X escribirá encima. Si quieres conservar el binario antiguo como referencia antes de que eso pase, cópialo fuera:
   ```powershell
   Copy-Item "D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza_ V1.X\dist" `
             "D:\@Proyect\Baliza\1 Firmware\Doc mplabx\dist_2025-09-17_ANTIGUO" -Recurse
   ```
   El `.hex` de producción (`Doc mplabx\18f2550_baliza__V1.X.production.hex`) está **fuera** de la carpeta del proyecto, así que ése no corre peligro.

### 3.1 Guarda `nbproject\` junto al código. Siempre.

Cuando termines, dentro de `18f2550_baliza_ V1.X\` habrá una carpeta nueva `nbproject\` con `configurations.xml`, `project.xml` y `Makefile-*.mk`.

**Esa carpeta es parte del código fuente. Va con él a todas partes.** Es exactamente lo que faltaba hoy y lo que ha obligado a hacer este trabajo: alguien empaquetó el firmware quedándose los `.c` y tirando el proyecto, y con ello se perdió qué dispositivo era, qué compilador, con qué opciones y qué ficheros entraban. Todo eso ha habido que deducirlo de un fichero de mapa que sobrevivió por casualidad.

- Guárdala en el control de versiones o en el ZIP, al lado de los `.c`.
- Lo que **no** se guarda es `build\` y `dist\`: son generados, se rehacen en cada compilación y sólo estorban.
- `defmplabxtrace.log` tampoco.

---

## 4. Compilar desde la interfaz

### 4.1 Los botones

| Quiero | Botón / menú | Atajo | Qué hace |
|---|---|---|---|
| Compilar sólo lo que cambió | **`Build Project`** (martillo) | F11 | Recompila los `.c` modificados y enlaza |
| Compilar todo desde cero | **`Clean and Build Project`** (martillo + escoba) | Shift+F11 | Borra `build\` y `dist\` y rehace todo. **Usa éste** cuando cambies cabeceras, opciones del proyecto o versión de compilador |
| Compilar **y grabar** | `Make and Program Device` (flecha hacia abajo sobre un chip) | — | **Esto ya toca el hardware. Ver §6 antes de pulsarlo** |

Asegúrate de que la barra de configuración de arriba dice **`default`** y no `debug`, si lo que quieres es un binario de producción. Ver §4.3.

### 4.2 Dónde sale el resultado y dónde queda el `.hex`

El resultado se imprime en la ventana **`Output`** (pestaña con el nombre del proyecto), abajo. Al final aparece el resumen de memoria de XC8, que tiene esta forma:

```
Memory Summary:
    Program space        used  XXXXh (  YYYYY) of  8000h bytes   ( NN.N%)
    Data space           used   XXXh (   YYY) of   800h bytes   ( NN.N%)
    EEPROM space         used     0h (     0) of   100h bytes   (  0.0%)
    ...
:: warning: (1273) Omniscient Code Generation not available in Free mode
```

y termina con `BUILD SUCCESSFUL` o `BUILD FAILED`.

El `.hex` queda en:

```
18f2550_baliza_ V1.X\dist\default\production\18f2550_baliza_ V1.X.production.hex
```

(y en `dist\default\debug\...debug.hex` si compilaste en modo debug).

### 4.3 Cuánta memoria tiene el 18F2550 y cuánto queda

MPLAB X escribe el resumen también en un XML. El de la última compilación real está en `dist\default\debug\memoryfile.xml` y dice, literalmente:

| Espacio | Total | Usado | Libre | Ocupación |
|---|---:|---:|---:|---:|
| **Program (flash)** | 32 768 bytes (32 KB) | 21 640 | 11 128 | **66,0 %** |
| **Data (RAM)** | 2 048 bytes | 564 | 1 484 | **27,5 %** |
| **EEPROM** | 256 bytes | — | — | — |

Los totales de la tabla son los del PIC18F2550: **32 KB de flash, 2 048 bytes de RAM, 256 bytes de EEPROM de datos**. Los dos primeros salen del propio `memoryfile.xml`; el de EEPROM sale del `.map` (`-AEEDATA=0F00000h-0F000FFh`, o sea `0x00`–`0xFF`).

Cómo leerlo:

- **Program space** es la flash. Si supera el 100 %, el enlazador falla con `can't find space` y no sale `.hex`. Con **11 128 bytes libres** hay sitio de sobra para cambios normales; preocúpate si empiezas a añadir cadenas de texto o tablas grandes, que es lo que se come la flash de golpe.
- **Data space** es la RAM. Es la que muerde antes en este micro: 2 KB repartidos en bancos, y el PIC18 sólo direcciona un banco a la vez. Si añades arrays grandes puedes agotar un banco concreto aunque el porcentaje global parezca bajo. El síntoma es un error de enlazado que nombra un `psect` (`bssBANK1`, `cstackBANK0`...), no un simple «no cabe».
- **Ojo con comparar debug contra production.** La compilación de arriba es **debug**: el `.map` muestra `-ACODE=00h-07D3Fh`, es decir que el ejecutivo de depuración se reserva de `0x7D40` a `0x7FFF` (704 bytes) y el programa no puede usarlos. Una compilación `production` dispone de los 32 768 completos. Compara siempre production contra production.

---

## 5. Compilar desde la línea de comandos

Dos caminos. El segundo es el bueno para automatizar, porque usa el proyecto y por tanto las mismas opciones que la interfaz.

### 5.1 Llamando a XC8 directamente

**Comprobado que no existe hoy:** `C:\Program Files\Microchip\xc8\v2.46\bin\` no está, porque XC8 no está instalado. Estos comandos son para después de instalar (§2.2).

XC8 v2.x trae **dos** ejecutables de línea de órdenes, y **usan opciones distintas**:

| Ejecutable | Qué es | Opción del dispositivo |
|---|---|---|
| `xc8-cc.exe` | El driver moderno de la v2.x, el que usa MPLAB X para proyectos v2. Es el que hay que usar. | **`-mcpu=18F2550`** |
| `xc8.exe` | El driver heredado de la v1.x, que se conserva por compatibilidad | **`--chip=18F2550`** |

**No he podido verificar cuál de los dos está presente en la v2.46 ni sus opciones exactas, porque el compilador no está instalado en esta máquina.** Lo anterior es lo que documenta Microchip para XC8 v2.x. En cuanto lo instales, confírmalo tú con `dir "C:\Program Files\Microchip\xc8\v2.46\bin"` y `xc8-cc.exe --help`. Ver §10.

Forma esperada del comando, desde la carpeta del proyecto (PowerShell, todo en una línea o con acentos graves de continuación):

```powershell
cd "D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza_ V1.X"

& "C:\Program Files\Microchip\xc8\v2.46\bin\xc8-cc.exe" `
    -mcpu=18F2550 `
    -o baliza.hex `
    Alarma.c Aplicacion.c Buzzer.c Cluster.c DS1307.c EEprom.c `
    I2C.c LedLive.c main.c Serial.c TimeBase.c
```

Notas:

- **Los 11 `.c`, ni uno más ni uno menos.** Son los que aparecen como `.p1` en `build\default\debug\`. `UART.h` no tiene `.c`, y en `Rtos\` sólo hay cabeceras.
- **No hace falta `-I`** para `Rtos\`: los `#include` son `"Rtos/pt.h"`, relativos al directorio del fuente, y compilas desde ahí.
- **Los `#pragma config` ya están en `main.h`**, así que los bits de configuración salen en el `.hex` sin que haya que pasar nada por línea de comandos.
- **Entrecomilla todo.** `Program Files` tiene un espacio, `1 Firmware` tiene un espacio, `Doc mplabx` tiene un espacio y `18f2550_baliza_ V1.X` tiene un espacio **antes** de `V1.X`. Sin comillas, cualquiera de esas rutas se parte y el error que sale no dice que el problema sean las comillas.

### 5.2 Usando el `make` de MPLAB X sobre el proyecto (recomendado para automatizar)

Esto compila **el proyecto**, con las opciones que guardaste en `nbproject\configurations.xml`. Es idéntico a pulsar `Clean and Build`, pero desde un script.

**Herramientas comprobadas en disco el 21-ago-2026:**

| Herramienta | Ruta exacta | Verificado |
|---|---|---|
| GNU Make 3.81 | `C:\Program Files\Microchip\MPLABX\v5.45\gnuBins\GnuWin32\bin\make.exe` | ✅ existe |
| Generador de makefiles | `C:\Program Files\Microchip\MPLABX\v5.45\mplab_platform\bin\prjMakefilesGenerator.bat` | ✅ existe (es un `.bat` que lanza `..\lib\PrjMakefilesGenerator.jar` con el java de MPLAB X) |
| IDE | `C:\Program Files\Microchip\MPLABX\v5.45\mplab_platform\bin\mplab_ide64.exe` | ✅ existe |
| IPE (grabador gráfico) | `C:\Program Files\Microchip\MPLABX\v5.45\mplab_platform\bin\mplab_ipe64.exe` | ✅ existe |
| IPE por línea de comandos | `C:\Program Files\Microchip\MPLABX\v5.45\mplab_platform\mplab_ipe\ipecmd.exe` | ✅ existe, ayuda verificada (§6.4) |
| Utilidades | `hexmate.exe`, `checksum.jar`, `mdb.bat` en `mplab_platform\bin\` | ✅ existen |

Secuencia:

```powershell
$MPLABX = "C:\Program Files\Microchip\MPLABX\v5.45"
$PROY   = "D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza_ V1.X"

# 1) Regenerar los makefiles a partir de nbproject\configurations.xml
#    (sólo hace falta si cambió la lista de ficheros o las opciones)
& "$MPLABX\mplab_platform\bin\prjMakefilesGenerator.bat" "$PROY@default"

# 2) Compilar
cd "$PROY"
& "$MPLABX\gnuBins\GnuWin32\bin\make.exe" -f nbproject/Makefile-default.mk SUBPROJECTS= .build-conf
```

`$PROY@default` es la sintaxis `<ruta del proyecto>@<configuración>`; `default` es el nombre de la configuración que usó la compilación original (por eso las rutas son `build\default\...`). **No he podido verificar esta sintaxis ejecutándola, porque no hay proyecto que regenerar; ver §10.** El destino `.build-conf` y el makefile `nbproject/Makefile-default.mk` los genera el propio MPLAB X al crear el proyecto: si el nombre no coincide, míralo dentro de `nbproject\` una vez creado.

El `.hex` sale en el mismo sitio que desde la interfaz (§4.2). El código de salida de `make` es 0 si compiló.

---

## 6. Grabar el PIC

> # ⚠⚠ NO GRABES SI NO TE LO HAN PEDIDO
>
> **Hay una señal montada al otro lado.** Grabar el PIC reinicia el equipo y sustituye el programa que está gobernando esa señal ahora mismo. Una baliza que se apaga, que se queda encendida, o que arranca con horarios distintos a los de la chapa atornillada, es un problema de seguridad, no un problema de software.
>
> **Compilar es gratis. Grabar no.** Puedes hacer todo lo de §3, §4, §5 y §7 sin acercarte a la tarjeta. Grabar es un acto separado, que se hace **cuando alguien lo pide**, sabiendo qué señal es y qué pasa mientras está sin programa.

### 6.1 Qué programador

La tarjeta expone una **cabecera ICSP de 5 pines, `J1`**, documentada en `D:\@Proyect\Baliza\HARDWARE.md` (§2.2 de ese documento, línea 66, y el mapa de netos de las líneas 853–870):

| Pin de `J1` | Señal | A dónde va en el PIC |
|---|---|---|
| **1** | `MCLR / VPP` | pin 1 (`MCLR`), con pull-up `R2` de 10 k a +5 V |
| **2** | `+5V` | raíl de 5 V de la tarjeta (salida del `LM78M05`) |
| **3** | `GND` | masa |
| **4** | `PGD` | pin 28 (`RB7`) |
| **5** | `PGC` | pin 27 (`RB6`) |

`HARDWARE.md` dice que es **compatible pin a pin con PICkit 3 / PICkit 4**. Esos programadores tienen 6 pines; el sexto (`PGM`/`AUX`) queda al aire, y **no hace falta**, porque el firmware lleva `#pragma config LVP = OFF` (`main.h`, línea 37): programación en bajo voltaje deshabilitada. Se graba con **VPP alto sobre MCLR**, que es el modo por defecto.

**Herramientas que soportan el PIC18F2550, según la tabla de esta instalación** (`...\v5.45\docs\Device Support.htm`, fila `PIC18F2550` — columnas en el orden `SNAP-D, SNAP-P, PK4-D, PK4-P, ICD4-D, ICD4-P, RICE-D, RICE-P, ICD3-D, ICD3-P, PK3-D, PK3-P, PM3, SIM-ISA, SIM-P, AICE-P, PIC-AS, XC8, XC16, XC32` con valores `R,R,G,G,G,G,G,G,G,G,G,G,G,G,Y,R,1.00,1.00,R,R`):

| Herramienta | Depurar | Grabar |
|---|---|---|
| **MPLAB Snap** | ❌ **NO** | ❌ **NO** |
| **PICkit 4** | ✅ | ✅ |
| **ICD 4** | ✅ | ✅ |
| **REAL ICE** | ✅ | ✅ |
| **ICD 3** | ✅ | ✅ |
| **PICkit 3** | ✅ | ✅ |
| **PM3** | — | ✅ |
| Simulador | ✅ | (preliminar) |
| XC8 | — | soportado desde v1.00 |

> **El Snap no vale para este micro.** Es el error más caro de esta lista: es el programador barato que la gente compra primero, y con el PIC18F2550 no funciona, no porque esté mal, sino porque Microchip nunca lo soportó.

### 6.2 Cómo se conecta — y la decisión de la alimentación

**El PIC18F2550 de esta tarjeta funciona a 5 V** (`HARDWARE.md` §4: raíl `+5V` desde un `LM78M05`, y el PIC a 20 MHz en modo `HS`, que a 3,3 V no está garantizado). El programador tiene que trabajar a 5 V, no a 3,3 V.

Como `J1.2` está atado al raíl de 5 V de la tarjeta, **hay que decidir de dónde sale ese 5 V, y sólo puede salir de un sitio**:

| Opción | Cómo | Cuándo | Riesgo si te equivocas |
|---|---|---|---|
| **A — La tarjeta se alimenta sola** (recomendado) | Alimenta la tarjeta por `J2` con sus 12 V. En el programador, **NO** actives «power target from tool». En IPE, deja `VDD` sin marcar; en línea de comandos, **no** pongas `/W` | Es lo normal y lo más seguro. La tarjeta ya está montada y alimentada | Ninguno |
| **B — El programador alimenta la tarjeta** | Sin 12 V en `J2`. Activa «power target» y **fija 5,0 V** | Sólo con la tarjeta en el banco, desconectada de la señal | El PICkit 3 sólo entrega ~30 mA a 5 V. El consumo del raíl de +5 V de esta tarjeta es **≈21 mA típicos pero hasta ≈70 mA de pico** (`HARDWARE.md` §4.5, con el HC-06 tirando 40 mA en emparejamiento). El programador no llega: la tensión cae y **la grabación falla a mitad**, o el micro queda a medio programar |
| **A+B a la vez** ❌ | Los 12 V puestos **y** «power target» activado | Nunca | El programador empuja 5 V contra la salida del `LM78M05`. Es la forma habitual de matar el programador, el regulador, o los dos |

**Regla:** si la tarjeta está en su sitio y enchufada → **opción A**. Si está suelta en la mesa → **opción B**, y con el HC-06 quitado del zócalo para bajar el consumo.

**Otras cosas que comprobar antes de tocar nada:**

- **Masa común.** Si la tarjeta se alimenta de su fuente y el programador del USB del PC, `J1.3` es lo único que las une. Que esté bien conectado.
- **Orientación de `J1`.** Es una tira de 5 pines sin polarizar: se puede enchufar del revés. Pin 1 (`MCLR/VPP`) es el que va marcado con el triángulo del PICkit. Enchufarlo al revés pone VPP (≈9 V) en `PGC`.
- **La salida CLUSTER.** Grabar reinicia el micro. Mientras el PIC está en reset y durante toda la grabación, `RC2` queda como entrada y la puerta del MOSFET la mantiene `R9` (4,7 k) a masa: el cluster queda **apagado**. Después del reset, el firmware arranca de cero. Si la señal debe seguir dando luz mientras tanto, no puede: planifícalo.
- **La hora.** El DS1307 tiene pila de respaldo (`BT1`) y **no** pierde la hora al grabar. Pero la EEPROM interna del PIC, donde el firmware guarda las alarmas, **sí se borra** si grabas con el borrado completo activado, que es el comportamiento por defecto (`ipecmd`: `OH  Erase All Before Programming ... Default: Selected`). Ver §6.4 si quieres conservarla.

### 6.3 Grabar desde MPLAB X

1. Conecta el programador al USB y a `J1` respetando el pin 1.
2. Resuelve la alimentación según §6.2.
3. `Production → Set Project Configuration → default` (no `debug`).
4. `File → Project Properties`, en el árbol de la izquierda selecciona tu herramienta y revisa **`Power`**: la casilla `Power target circuit from <herramienta>` marcada o no, según §6.2. Revisa también `Program Options` si quieres preservar la EEPROM.
5. Compila: **`Clean and Build`** (Shift+F11). Espera a `BUILD SUCCESSFUL`.
6. **`Make and Program Device`** (o `Run → Run Project`, que compila y graba).
7. Lee la ventana `Output`: debe aparecer la detección del dispositivo (`Device ID Revision`), el borrado, la programación y la verificación, y terminar en `Programming/Verify complete`.
8. Desconecta el programador. La tarjeta arranca sola.

### 6.4 Grabar desde MPLAB IPE

IPE es el programa de grabar sin compilar: le das un `.hex` y lo mete. Es el adecuado para grabar un binario que ya existe, por ejemplo el de producción.

**Ejecutable:** `C:\Program Files\Microchip\MPLABX\v5.45\mplab_platform\bin\mplab_ipe64.exe`

1. `Device`: escribe `PIC18F2550`.
2. `Tool`: elige el programador conectado.
3. `Connect`. Debe leer el Device ID.
4. `Hex File → Browse`: elige el `.hex`.
   - El de producción actual: `D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza__V1.X.production.hex`
   - El que acabas de compilar: `...\18f2550_baliza_ V1.X\dist\default\production\...production.hex`
5. Revisa la pestaña `Power`: la casilla de alimentar desde la herramienta, según §6.2.
6. `Program`. Luego `Verify`.

**Y por línea de comandos** (`ipecmd.exe`). Las opciones de abajo están **verificadas ejecutando `ipecmd.exe /?` en esta máquina**, versión v5.45:

| Opción | Qué hace | Por defecto |
|---|---|---|
| `/P<parte>` | Selección del dispositivo. Ej. `/P18F2550` | — |
| `/TP<herramienta>` | Selección de herramienta. Códigos: `PK3` (PICkit 3), `PK4` (PICkit 4), `ICD3`, `ICD4`, `RICE` (REAL ICE), `PM3`, `SNAP`, `PKOB`, `PKOB4` | — |
| `/F<fichero>` | El `.hex` | — |
| `/M` | **Programar el dispositivo** (sin región = todo) | No programa |
| `/Y` | Verificar | No verifica |
| `/E` | Borrar la flash | No borra |
| `/OH` | Borrar todo antes de programar | **Seleccionado** |
| `/Z` | **Preservar la EEPROM al programar** | No preserva |
| `/W` | **Alimentar el objetivo desde la herramienta** | **Objetivo alimentado externamente** |
| `/J` | MCLR de alto voltaje | **Seleccionado** (es lo correcto con `LVP = OFF`) |
| `/L` | Programación en bajo voltaje | No seleccionado (**déjalo así**: el firmware tiene `LVP = OFF`) |
| `/OL` | Soltar el reset al terminar | Lo deja en reset |
| `/OD` | VDD antes que VPP (PICkit 3, ICD 3, ICD 4) | VPP primero |
| `/K` | Mostrar la suma de comprobación del `.hex` | No |
| `/I` | Mostrar el Device ID | No |
| `/OK` | Sólo conectar (sin programar) | — |
| `/OSL<0-7><ruta>` | Registro de diagnóstico | — |

Ejemplo, **tarjeta alimentada por sí misma** (sin `/W`), PICkit 3, conservando las alarmas de la EEPROM:

```powershell
& "C:\Program Files\Microchip\MPLABX\v5.45\mplab_platform\mplab_ipe\ipecmd.exe" `
    /P18F2550 /TPPK3 `
    /F"D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza__V1.X.production.hex" `
    /M /Y /Z /OL
```

Prueba en seco antes, que no graba nada:

```powershell
& "C:\Program Files\Microchip\MPLABX\v5.45\mplab_platform\mplab_ipe\ipecmd.exe" /P18F2550 /TPPK3 /OK /I
```

`ipecmd` devuelve un código de salida distinto de 0 si falla, así que se puede meter en un script.

---

## 7. Cómo saber que lo que compilaste es lo que querías

Tres controles, y **ninguno de los tres sustituye a los otros dos**.

### 7.1 El orden correcto

```
  1. SIMULADOR      python correr.py           ¿la lógica sigue haciendo lo que debe?
         ↓
  2. XC8            Clean and Build            ¿cabe en el micro? ¿compila de verdad?
         ↓
  3. COMPARAR       resumen de memoria + hex   ¿cambió lo que yo quería y sólo eso?
         ↓
  4. GRABAR         ...cuando lo pidan         §6
```

El simulador va **primero** porque es el único de los cuatro que se puede repetir cien veces en un minuto sin tocar nada. Compilar con XC8 dice si *cabe*, no si *funciona*.

### 7.2 El simulador de PC

```powershell
cd "D:\@Proyect\Baliza\4 Simulador"
python correr.py
```

**Qué es.** Un arnés de prueba que **compila los `.c` REALES del firmware con gcc** —los mismos ficheros que MPLAB X grabaría en el PIC, sin copiarlos ni reescribirlos— contra un `<xc.h>` falso (`stubs\xc.h`) y una plataforma simulada (`sim\plataforma.c`), y luego los ejercita. Compila **7** de los 11 `.c`: `TimeBase.c`, `LedLive.c`, `Buzzer.c`, `Cluster.c`, `Serial.c`, `Alarma.c`, `Aplicacion.c`. Los otros cuatro quedan fuera y sustituidos, por razones escritas en la cabecera de `arnes.c`: `main.c` usa `__interrupt()` (sólo existe en XC8; su bucle principal y su ISR de Timer0 están reproducidos literalmente en `plataforma.c`), `EEprom.c` espera sobre un periférico inexistente, `DS1307.c` habla I²C con un chip que aquí no hay, e `I2C.c` sólo lo usa `DS1307.c`.

**Códigos de salida:**

| Código | Significa | Qué hacer |
|---|---|---|
| **0** | **PASS** — compiló, corrió, y el firmware cumple | Sigue al paso 2 |
| **1** | **FALLA** — compiló, corrió, y el firmware NO cumple | Mira qué escenario está rojo |
| **2** | **ABORTADO** — no pudo medir: falta gcc, falta un fuente, o el arnés no compila | **Arregla el instrumento, no el firmware.** Un arnés que no corre no dice nada del firmware. Suele ser que `D:\toolchain\mingw64\bin\gcc.exe` no está, o que renombraste un `.c` y no actualizaste `FUENTES_FW` en `correr.py` |

**Estado hoy, medido el 21-ago-2026:** sale **código 1**, con **33 comprobaciones, 24 ok, 9 FALLA**. Eso es lo **esperado**: siete de esos rojos están marcados en el propio arnés como `[ROJO ESPERADO 21-ago-2026]` (escenarios D1 a D6) y documentan defectos reales del firmware que aún no se han arreglado; los otros dos están en el escenario C (duración del pulso de la luz).

> **Cómo usar eso en la práctica:** guarda la salida de hoy como línea base y compara. Lo que importa no es que salga verde, sino **que no aparezcan rojos nuevos** y que los que arregles pasen a ok.
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

A eso hay que añadir lo que se deduce de cómo está construido:

- **No toca un solo pin real.** Ni un temporizador real, ni el ADC, ni el I²C, ni la UART. `<xc.h>` es un stub.
- **No usa XC8.** Usa gcc. No dice nada sobre tamaño en flash, uso de bancos de RAM, ni si el código cabe.
- **No mide tiempos reales.** El tiempo del arnés es simulado; no hay cristal de 20 MHz ni Timer0.
- **No prueba `main.c`, `DS1307.c`, `I2C.c` ni `EEprom.c`.** El arranque real, el reloj real y la EEPROM real quedan sin cubrir.

> ### ⚠ **Verde en el simulador NO autoriza a grabar.**
> Es una prueba de la **lógica**, corriendo en un PC. Que la lógica esté bien y que el equipo funcione son dos afirmaciones distintas, y esta herramienta sólo respalda la primera.

### 7.3 Comparar el `.hex` nuevo con el de producción

Referencia, medida sobre `D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza__V1.X.production.hex`:

| Dato | Valor |
|---|---|
| Tamaño del fichero | 61 008 bytes, 1360 líneas |
| Bytes de programa con datos | **21 638** de 32 768 → **66,0 %** |
| Rango de programa | `0x0000` – `0x7FFF` (hay constantes de texto arriba del todo, hasta `0x7FFF`) |
| Palabras de configuración (`0x300000`) | `00 0C 18 1E FF 83 81 FF 0F C0 0F E0 0F 40` |
| IDLOCs (`0x200000`) | `FF FF FF FF FF FF FF FF` (sin usar) |

De las palabras de configuración, `CONFIG4L = 0x81` confirma lo que dice `main.h`: `STVREN = ON` (bit 0 = 1), `LVP = OFF` (bit 2 = 0), `XINST = OFF` (bit 6 = 0), y el bit 7 a 1 = **DEBUG deshabilitado**, o sea que este `.hex` es una compilación de **producción**, no de depuración.

Comparación práctica:

```powershell
$VIEJO = "D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza__V1.X.production.hex"
$NUEVO = "D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza_ V1.X\dist\default\production\18f2550_baliza_ V1.X.production.hex"

# 1) ¿Son idénticos?
(Get-FileHash $VIEJO).Hash
(Get-FileHash $NUEVO).Hash

# 2) ¿Qué líneas cambiaron?
fc.exe "$VIEJO" "$NUEVO"
```

Cómo interpretarlo:

- **Hashes iguales** → no cambiaste nada que afecte al binario. Si esperabas un cambio, no compiló lo que crees: revisa que editaste el fichero correcto y que hiciste `Clean and Build`.
- **Cambian unas pocas líneas, alrededor de la función que tocaste** → es lo normal y lo deseable.
- **Cambia el fichero entero, o cambia mucho el tamaño** → algo más cambió: **la versión de XC8**, el modo de licencia (Free vs PRO), o la configuración (`debug` vs `production`). Vuelve a §2.2. Un `.hex` que cambia entero por un `if` que añadiste es una señal de alarma, no de éxito.
- **Cambian las palabras de configuración de `0x300000`** → tocaste un `#pragma config` de `main.h`. Asegúrate de que fue a propósito: ahí viven el oscilador, el watchdog, el brown-out y la protección de código.
- Compara siempre **production contra production**. Un `.hex` de debug lleva el ejecutivo de depuración y no se parece.

Y compara también el **resumen de memoria** (§4.3) contra los 21 640 / 564 bytes de la compilación de referencia. Un salto grande sin motivo aparente casi siempre significa que arrastraste una función pesada de la biblioteca (un `printf` con `%f`, típicamente).

---

## 8. Problemas frecuentes y su causa

| Síntoma | Causa | Solución |
|---|---|---|
| **`File → Open Project` no ofrece la carpeta del firmware; sale sin el icono de proyecto** | **No hay `nbproject\`.** Comprobado: no existe en ninguna parte de `D:\@Proyect\Baliza` | Crear el proyecto desde cero, §3. No hay atajo |
| **`(188) constant expression required` en `DS1307.c:66`** | **Falta `--std=c99`.** El driver `xc8.exe` compila en C90 por defecto, y en C90 ese array `const` local inicializado con parámetros es ilegal | **Añade `--std=c99`** al comando, o pon `C standard = C99` en las propiedades del proyecto. **NO toques `DS1307.c`.** Ver **§2.4** |
| **En `New Project → Select Compiler` la lista sale vacía o sin XC8** | XC8 **sí está instalado** (v2.36, comprobado). Si no aparece, es que lo instalaste con MPLAB X abierto y el IDE no lo ha visto, o no marcaste la integración con MPLAB X en el asistente | Cierra y reabre MPLAB X. Si aun así no sale: `Tools → Options → Embedded → Build Tools → Scan for Build Tools`, y añade a mano `C:\Program Files\Microchip\xc8\v2.36\bin` |
| **`(2043) target device was not recognized` con `xc8-cc.exe`** | El driver nuevo no acepta este dispositivo tal como se le invoca, aunque el soporte está presente en disco | **Usa el driver clásico `xc8.exe --chip=18f2550`.** Ver §2.6 |
| **Compila pero el binario sale muy distinto del de producción** | **Lo instalado es v2.36 y producción se hizo con v2.46.** También puede ser licencia PRO en vez de Free, o banderas distintas | **Es lo esperado, no un fallo.** Ver **§2.5**. Para comparar byte a byte hace falta la **v2.46 en modo Free** con las mismas banderas |
| **Avisos `(228) illegal character (0xBF)` y `non-reentrant function … duplicated`** | Son **normales**. El `0xBF` es el delimitador de trama del protocolo; la duplicación la provoca llamar a `printf`/`UART_write` desde el programa y desde una interrupción | **No los arregles.** Ver §2.3 |
| **El comando de línea de órdenes falla con «no se encuentra la ruta» o parte la orden por la mitad** | **Espacios en las rutas.** `Program Files`, `1 Firmware`, `Doc mplabx`, y sobre todo **`18f2550_baliza_ V1.X` tiene un espacio antes de `V1.X`** | Entrecomilla **todas** las rutas, siempre. En PowerShell usa el operador de llamada: `& "C:\...\xc8-cc.exe"` |
| **Avisos `unknown pragma` o `unrecognized #pragma config`** | `main.h` tiene **58 `#pragma config`** (líneas 12–73), que son directivas **de XC8**. Cualquier otro compilador —gcc, un analizador, un editor con IntelliSense— no los entiende | Con XC8 no pasa: son suyos y deben aplicarse. Con gcc, el simulador ya los silencia (`-Wno-unknown-pragmas` en `correr.py`). **Si XC8 te avisa de un `#pragma config`, no lo ignores**: significa que ese bit no se está grabando y el micro arrancará con el valor por defecto (otro oscilador, watchdog activo...) |
| **Errores de «redefinición» de `strCluster`, `states_cluster`, `PERIOD_CLUSTER`...** | **`Cluster.h` NO tiene guarda de inclusión.** Comprobado: no empieza con `#ifndef CLUSTER_H` ni lleva `#pragma once`; empieza directamente con el comentario de cabecera y los `#include` (ver el fichero). Lo incluyen **tres** fuentes: `Cluster.c:6`, `Aplicacion.c:27` y `main.c:19`. Además está `static int taskCluster(struct pt *pt);` declarada en la cabecera, que es otra rareza | Hoy **no da problemas** porque cada `.c` se compila por separado y ninguno la incluye dos veces por caminos distintos. **Empezará a darlos** en cuanto: (a) alguien añada `#include "Cluster.h"` a otra cabecera que ya se incluya, creando una inclusión doble indirecta; (b) alguien intente una compilación en unidad única (`#include` de los `.c`) — el arnés del simulador **no puede hacerlo por esta razón exacta**, y lo dice en la cabecera de `arnes.c`; (c) alguien active la generación de código omnisciente. **Lo correcto es ponerle la guarda.** `EEprom.h` y `UART.h` tampoco la tienen, y les pasa lo mismo |
| **`correr.py` devuelve 2** | Falta `D:\toolchain\mingw64\bin\gcc.exe`, o se renombró/movió un `.c` del firmware sin actualizar `FUENTES_FW` en `correr.py` | Es un fallo **del instrumento**, no del firmware. Arréglalo antes de sacar conclusiones. Nunca lo cuentes como «falla» |
| **El programador no conecta / no lee el Device ID** | Alimentación: o nadie alimenta la tarjeta, o la alimentan dos a la vez. Ver §6.2 | Decide A o B. Nunca las dos |
| **La grabación empieza y se corta a mitad** | Estás alimentando la tarjeta desde el programador (`/W`) y no llega la corriente: ~30 mA del PICkit 3 contra hasta 70 mA de pico de la tarjeta | Alimenta la tarjeta por `J2` y quita `/W`. O quita el HC-06 del zócalo |
| **El Snap no reconoce el micro** | **MPLAB Snap no soporta el PIC18F2550.** Verificado en `docs\Device Support.htm` | Usa PICkit 3, PICkit 4, ICD 3, ICD 4, REAL ICE o PM3 |
| **Después de grabar, las alarmas están perdidas** | El borrado completo antes de programar está activado por defecto y borra también la EEPROM del PIC, donde el firmware guarda las alarmas | Usa `/Z` (preservar EEPROM) en `ipecmd`, o la opción equivalente en las propiedades del proyecto / IPE. La **hora** no se pierde: el DS1307 tiene pila |
| **El editor muestra caracteres raros en los `.c`** | Los fuentes están en **Windows-1252** y el delimitador del protocolo es el byte `0xBF` | Pon el proyecto en `windows-1252` (§3, paso 6). Si lo guardas en UTF-8, rompes el protocolo con la app del móvil |

---

## 9. Procedimiento resumido — una página

### Compilar HOY, sin IDE — 30 segundos

**Esto ya funciona. No hay que instalar nada.**

```powershell
cd "D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza_ V1.X"
& "C:\Program Files\Microchip\xc8\v2.36\bin\xc8.exe" --chip=18f2550 --std=c99 --outdir=.\salida `
    main.c Alarma.c Aplicacion.c Buzzer.c Cluster.c DS1307.c EEprom.c I2C.c LedLive.c Serial.c TimeBase.c
```

Genera `salida\main.hex`. Debe terminar con `Program space used … ( 65.0%)` y **código de salida 0**.
**`--std=c99` es obligatorio** (§2.4). El `.hex` **no** es comparable con el de producción (§2.5).

### Preparar el IDE (una sola vez)

1. **XC8 ya está instalado (v2.36).** Nada que descargar. *(Sólo si quieres reproducir producción byte a byte: descarga e instala además **XC8 v2.46** del archivo de versiones de Microchip, en modo **Free**. Pueden convivir las dos. Ver §2.5 y §2.7.)*
2. Abrir `C:\Program Files\Microchip\MPLABX\v5.45\mplab_platform\bin\mplab_ide64.exe`.
3. `File → New Project → Microchip Embedded → Standalone Project`.
4. Device: **`PIC18F2550`**.
5. Tool: el programador (**no Snap**). Si no hay, `Simulator`.
6. Compiler: **`XC8 (v2.36)`** — o `v2.46` si la instalaste.
6b. **`Project Properties → XC8 Global Options → C standard → C99`.** **Sin esto no compila** (§2.4).
7. Name: `18f2550_baliza_ V1.X` · Location: `D:\@Proyect\Baliza\1 Firmware\Doc mplabx` · Encoding: **`windows-1252`**.
8. `Source Files → Add Existing Item`: los 11 `.c`. **`Store path as: Auto`, NUNCA `Copy`.**
9. `Header Files → Add Existing Item`: los 12 `.h`. Luego `Add Existing Items from Folders` → **`Rtos\`**.
10. `Clean and Build` (Shift+F11). Debe decir `BUILD SUCCESSFUL`.
11. **Guardar `nbproject\` junto al código.** No guardar `build\` ni `dist\`.

### Cada vez que se modifica algo

1. Editar el `.c` / `.h`.
2. `cd "D:\@Proyect\Baliza\4 Simulador"` → `python correr.py`
   `0` PASS · `1` FALLA · `2` **ABORTADO = arreglar el instrumento, no el firmware**.
   Hoy la línea base es **código 1, 33 comprobaciones, 24 ok, 9 FALLA**. Que no aparezcan rojos nuevos.
3. En MPLAB X: configuración **`default`**, no `debug`. `Clean and Build` (Shift+F11).
4. Leer el resumen de memoria. Referencia: **21 640 / 32 768 bytes de programa (66 %)**, **564 / 2 048 de RAM (27,5 %)**.
5. `.hex` nuevo en `...\18f2550_baliza_ V1.X\dist\default\production\`.
6. Comparar con `D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza__V1.X.production.hex`:
   `fc.exe "<viejo>" "<nuevo>"` — deben cambiar pocas líneas, y sólo donde tocaste.
7. **PARAR AQUÍ.** No grabar.

### Grabar — sólo cuando lo pidan

1. Confirmar que lo piden. **Hay una señal montada al otro lado.**
2. Decidir la alimentación: **tarjeta alimentada por `J2` (12 V) → NO activar «power target»**. O tarjeta suelta → activar «power target» a 5,0 V. **Nunca las dos.**
3. Conectar el programador a `J1` (5 pines: 1=`MCLR/VPP`, 2=`+5V`, 3=`GND`, 4=`PGD`, 5=`PGC`). **Respetar el pin 1.**
4. MPLAB X: `Make and Program Device`. O IPE: `Device: PIC18F2550` → `Tool` → `Connect` → `Hex File` → `Program` → `Verify`.
5. Línea de comandos, con la tarjeta alimentada por sí misma y conservando las alarmas:
   ```
   "C:\Program Files\Microchip\MPLABX\v5.45\mplab_platform\mplab_ipe\ipecmd.exe" /P18F2550 /TPPK3 /F"<ruta.hex>" /M /Y /Z /OL
   ```
6. Verificar. Desconectar. Comprobar el LED de vida (`D1`, parpadea) y el horario contra la chapa.

---

## 10. Preguntas abiertas

Cosas que **no** he podido comprobar en esta máquina. Están aquí como preguntas, no como suposiciones disfrazadas de hecho.

1. **¿Qué programador tiene el usuario exactamente?** No hay ninguna pista en el proyecto: no queda `nbproject\configurations.xml`, que es donde se guarda la herramienta seleccionada. El `.map` sólo prueba que fue una compilación **debug**, lo que implica que había una herramienta con capacidad de depuración conectada (Snap queda descartado porque no soporta el 18F2550). `HARDWARE.md` dice que `J1` es «compatible pin a pin con PICkit 3/4». **Pregunta: ¿es un PICkit 3, un PICkit 4, o un ICD 3?** De la respuesta depende el código `/TP...` de `ipecmd` y si se puede alimentar la tarjeta desde el programador.

2. **¿Por qué exactamente fallan las versiones nuevas de MPLAB X con sus programadores?** La hipótesis que encaja es que Microchip retiró el soporte de PICkit 3 / ICD 3 / REAL ICE en las versiones posteriores a la 5.45, y que el usuario tiene una de esas. **No lo he podido verificar sin acceso a las notas de versión de Microchip.** Lo que sí está verificado es que **esta** instalación sí los soporta para el PIC18F2550 (`docs\Device Support.htm`). **Pregunta: ¿el programador es uno de los tres retirados?** Si lo es, queda cerrado el asunto y no hay que volver a plantear actualizar.

3. ~~**¿Cómo se llama el ejecutable de XC8 y qué opción usa para el dispositivo?**~~ ✅ **RESUELTO el 21-ago-2026.** El driver que funciona es **`bin\xc8.exe` con `--chip=18f2550`**, y hace falta **`--std=c99`**. Probado, código de salida 0. Ver §2.3.
   **Queda una pregunta derivada:** **¿por qué `xc8-cc.exe -mcpu=18F2550` falla con `(2043) target device was not recognized`,** si el soporte del dispositivo está presente en disco (`pic\dat\cfgdata\18f2550.cfgdata`, `pic\dat\ini\18f2550.ini`, `pic\include\proc\pic18f2550.h`)? ¿Es cuestión de mayúsculas en el argumento, de que `xc8-cc` exija además `-mdfp=` apuntando al *device family pack*, o de que este dispositivo sólo esté soportado por el driver clásico en la v2.36? **Mientras no se aclare, usa `xc8.exe`.** Ver §2.6.

4. **La URL y el nombre del instalador de XC8 v2.46**, por si se decide instalarla para reproducir producción (§2.5). Búscalo como «MPLAB XC8 Compiler → Downloads Archive → v2.46, Windows». *(Ya no bloquea nada: con la v2.36 se compila y se desarrolla sin problema.)*

4b. **¿Con qué banderas exactas se compiló producción?** Se sabe la versión (**v2.46**) y la licencia (**Free**, `Og1`) por el `.map` y el `.lst`, pero **no las banderas completas** — en particular si llevaba `--std=c99` explícito o lo heredaba de la configuración del proyecto. **Importa:** para el mismo código se han medido 21 640, 21 309 y 26 863 bytes según versión y banderas. **Sin las banderas no se puede reproducir el binario.** Ver el recuadro de §2.5.

5. **La sintaxis exacta de `prjMakefilesGenerator.bat`.** El `.bat` existe (verificado, es un lanzador de `..\lib\PrjMakefilesGenerator.jar`), pero no imprime ayuda y no hay proyecto sobre el que probarlo. La forma `<ruta del proyecto>@<configuración>` es la documentada por Microchip. **Confirmar cuando exista el proyecto**, y de paso mirar dentro de `nbproject\` cómo se llama realmente el makefile generado (se espera `Makefile-default.mk`).

6. **¿Se puede reproducir bit a bit el `.hex` de producción?** **Con la v2.36 que hay instalada, no** — es otra versión de compilador y el binario sale necesariamente distinto (§2.5). La pregunta sigue abierta **para la v2.46**: haría falta instalarla, compilar el código sin modificar y comparar. Merece la pena hacerlo **antes** de tocar nada: si sale idéntico, queda demostrado que la reconstrucción del proyecto es correcta y que a partir de ahí toda diferencia es tuya. Si sale distinto, hay que averiguar por qué **antes** de modificar, no después. **Depende también de 4b** (las banderas).

7. **¿Qué contiene la EEPROM del PIC en la tarjeta que está montada?** Las alarmas programadas viven ahí. Antes de grabar convendría leerla (`ipecmd ... /GE0-FF`) y guardarla, para poder restaurarla si algo sale mal. No se puede hacer desde aquí: hace falta la tarjeta y el programador.

---

*Documento generado el 21 de agosto de 2026. Fuentes: inspección directa de `C:\Program Files\Microchip\MPLABX\v5.45\`, de `D:\@Proyect\Baliza\1 Firmware\Doc mplabx\`, de `D:\@Proyect\Baliza\4 Simulador\`, de `D:\@Proyect\Baliza\HARDWARE.md`, y ejecución de `ipecmd.exe /?` y `python correr.py`.*
