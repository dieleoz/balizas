# CLAUDE.md — Baliza

Instrucciones para trabajar en este repositorio. Lo que sigue son reglas del proyecto, no
sugerencias.

## Qué es esto

La **luz intermitente de una señal de tránsito** que dice «30 CUANDO ACTIVADA», instalada
frente a un colegio. Un **PIC18F2550** enciende el cluster de LED por `LATC2` durante unas
franjas horarias, y las franjas se le programan por **Bluetooth serie** desde una app Android.
Un **DS1307** con pila le da la hora, y las cinco alarmas viven en la EEPROM interna.

Cuando la luz titila, el límite de **30 km/h está vigente** para todo el que pasa. El resto del
día no rige.

> ### ⚠️ El horario no vive en el equipo: vive atornillado a la señal
>
> Cada señal lleva una **placa con su horario impreso**. La de referencia (foto en
> `3 Imagen/Horario.jpeg`) dice: *Entre 6:00 am y 9:00 am · Entre 11:30 am y 1:30 pm · Entre
> 3:00 pm y 4:30 pm*.
>
> **La consecuencia gobierna todo el proyecto:** si lo que se programa por Bluetooth no
> coincide **exactamente** con esa chapa, la señal afirma una cosa y hace otra, delante de un
> colegio, y no hay forma de detectarlo desde el escritorio. Ningún documento de este
> repositorio puede citar un horario de memoria: se copia de la chapa de esa instalación.

| Área | Carpeta | Estado |
|---|---|---|
| Firmware PIC | `1 Firmware/Doc mplabx/18f2550_baliza_ V1.X/` | Es el que va a producción. **Sin `nbproject/`** — ver regla 4 |
| Binario instalado | `1 Firmware/Doc mplabx/*.production.hex` | Lo que corre hoy en la calle. XC8 **v2.46**, Free, `Og1` |
| App Android | `1 Firmware/Doc Aplicativo Movil/BalizaV10/` | Gradle + Java nativo. **No es App Inventor** |
| Tarjeta | `2 Hardware tarjeta/` | KiCad y gerbers. **Fabricada y montada** — ver regla 1 |
| Simulador | `4 Simulador/` | 33 comprobaciones, corre en un segundo |
| Bluetooth | `5 HW bluetooth/` | Solo el datasheet del **SoC**, no el del módulo |

Punto de entrada: **[README.md](README.md)**. Qué falta y en qué orden:
**[ROADMAP.md](ROADMAP.md)**. En qué quedó la última sesión y las cifras del día:
**[ESTADO.md](ESTADO.md)**.

**Lo primero que desbloquea todo lo demás es el Bluetooth** (ROADMAP 0.1): mientras no haya un
módulo que empareje, no se puede programar un horario, ni leer un volcado, ni verificar en
campo ninguno de los arreglos.

## Las cinco reglas que no se rompen

### 0. Primero medir, después arreglar — y el simulador es lo que permite medir

Este proyecto se ataca en tres tiempos y no se salta ninguno: **simulador → restricciones del
hardware → avanzar**. Sin simulador, cada comprobación cuesta ir al poste y esperar a que den
las 6:00 de la mañana; con él, una franja entera se prueba en un segundo y **se puede hacer que
sean las 6:00 cuando convenga**.

De ahí sale el orden de trabajo: **ningún arreglo empieza sin el escenario que lo mide en
rojo**. Proponer un cambio de firmware antes de tener el escenario es arreglar a ciegas algo
que quizá ya funciona, contra una definición que quizá nadie confirmó.

```bash
cd "D:/@Proyect/Baliza/4 Simulador" && python correr.py
```

**Apunta el número antes de tocar nada.** Si escribes una rama nueva y el total no se movió, no
la estás midiendo.

### 1. La tarjeta está fabricada y es un dato fijo. Se cambia el firmware

Hay señales montadas en la calle. Cuando el firmware y la placa no coincidan, **se cambia el
firmware**: no se rediseña el hardware, no se corta una pista, no se añade un componente. Lo
que hay es lo que hay, y está descrito en [`HARDWARE.md`](HARDWARE.md).

Hoy hay **dos desajustes medidos**:

- **El buzzer.** La placa lo tiene en `RC1`; `Buzzer.h:24` ataca `RC0`, que en la tarjeta es la
  línea del pulsador. En `Buzzer.c:162` está la línea correcta **comentada**: alguien lo supo y
  se deshizo. No lo vuelvas a deshacer.
- **La temperatura.** El sensor entra por `AN3`, y `main.c` pone `PCFG = 0b1011`, que solo
  habilita AN0–AN2. Y la fórmula usa factor 10 donde el sensor pide 100.

La medida de **tensión sí es correcta** —el divisor da factor 6 y el firmware aplica 6— y no se
toca.

🚫 Y el corolario que hace falta escribir porque tiene tirón: **no propongas mejoras de
hardware.** Ni fusibles, ni diodos de rueda libre, ni cambiar el MOSFET. Están anotados como
restricciones en `HARDWARE.md` para que el firmware trabaje alrededor, no como una lista de
compras.

### 2. El protocolo de tramas es un contrato literal con un APK que ya está instalado

El firmware busca cada campo por su **carácter exacto**, con `strstr()`. Un carácter que no
coincide **no da error**: el comando se pierde en silencio, la app dice «Mensaje Enviado!!»
igualmente, y la señal se queda con el horario viejo. Nadie se entera hasta que alguien mira la
señal a las 6 de la mañana.

Dos cosas del contrato que funcionan **por casualidad** y que hay que conocer antes de
«limpiar» nada:

- El delimitador de inicio es el **byte 0xBF**, y la app lo manda en UTF-8, o sea **dos** bytes
  (`0xC2 0xBF`). Funciona porque `strstr()` busca subcadena y encuentra el 0xBF detrás del
  0xC2. Una comparación del primer byte lo rompería.
- **La app manda bytes NUL dentro de la trama** (rellena `char[6]` con 4 caracteres y `char[10]`
  con 8). El firmware sobrevive porque `Serial.c` los **filtra** al copiar, y ese filtro **no
  tiene un solo comentario**. Quien lo sustituya por un `memcpy` corrompe la fecha de todas las
  balizas.

Cambiar el formato obliga a reinstalar la app en todos los teléfonos que programan señales. Si
el cambio se puede hacer conservándolo, se conserva. Antes de tocar `Serial.c`, la skill
**`verificar-protocolo`**.

### 3. Nada se da por bueno sin medirlo, y medir no es lo mismo que aprobar

| | significa |
|---|---|
| `PASS` | corrió y el firmware cumple |
| `FALLA` | corrió y el firmware **no** cumple |
| `ABORTADO` | **no pudo correr** — no dice *nada* del firmware |

`correr.py` devuelve `ABORTADO` **con prioridad sobre `FALLA`** a propósito: si el instrumento
no midió, no puede acusar al firmware. Tratar un abortado como aprobado es cómo se pierde la
cobertura sin enterarse.

Los rojos del simulador son **esperados y llevan fecha** en el nombre del escenario. Un rojo sin
fecha es un defecto del arnés, no del firmware. **Y al poner un escenario en verde, se le quita
la marca y se le limpia el comentario en el mismo cambio**: un escenario que sigue anunciando un
defecto ya arreglado miente igual que uno que oculta un defecto vivo.

**Verde no es entregable, y ni siquiera autoriza a grabar.** El simulador no toca un solo pin
real, ni el I²C, ni el ADC, ni el Bluetooth. La lista completa de lo que no ve está en la skill
**`verificar`**, punto 7.

### 4. Compilar tiene dos trampas, y las dos ya costaron tiempo

- **`--std=c99` no es opcional.** En C90 el firmware **no compila**: `DS1307.c:66` inicializa un
  array `const` local con los parámetros de la función. No se toca el código: se compila en C99.
- **`File > Open Project` no funciona.** La carpeta del firmware **no tiene `nbproject/`**, así
  que MPLAB X no la reconoce como proyecto. Hay que crear uno nuevo y añadir los fuentes
  existentes — y **versionar el `nbproject/` resultante**, que es justo lo que faltó.

- **Siempre con `--outdir` fuera del árbol de fuentes.** Sin él, XC8 deja los artefactos entre
  el código. Ya pasó: 1,1 MB de `test_build.*` y `startup.*` mezclados con los `.c`.
- **El driver cambia el binario.** Mismo compilador, mismas banderas, mismos fuentes:
  `xc8.exe` da **21.309 bytes (65,0 %)** y `xc8-cc.exe` da **26.863 (82,0 %)**. Se usa
  `xc8.exe`. **La versión del compilador, su driver y sus banderas son parte del entregable** y
  tienen que quedar anotadas junto al `.hex`; hoy solo se saben leyendo por casualidad un
  fichero de mapa.

Detalle completo en [`COMPILAR_Y_GRABAR.md`](COMPILAR_Y_GRABAR.md).

🚫 **No grabes el PIC sin que te lo pidan.** Hay señales montadas en la calle al otro lado.

### 5. El firmware no distingue módulos Bluetooth

Circula la idea de que el `.hex` está «compilado para otro Bluetooth». **Es falsa y está
costando tiempo.** Para el firmware el módulo es un puerto serie transparente a **9600 8N1
fijo** (`UART.h`, `SPBRG = 32`, `BRGH = 0`). No sabe ni puede saber qué chip hay al otro lado.

Cuando el Bluetooth falle, el problema está en el módulo, en su configuración, en el cableado o
en la app — nunca en que el binario sea de otra versión. Separar esas variables es lo que hace
[`BLUETOOTH.md`](BLUETOOTH.md), y la prueba que más decide es la de bucle: puentear TX con RX
del módulo **solo**, sin el PIC de por medio.

## Nomenclatura

Tres nombres para las mismas cosas, y es fuente de confusión:

| en la calle | en el firmware | en la tarjeta |
|---|---|---|
| la luz de la señal | «cluster», `LATC2` | neto `CLUSTER`, salida por MOSFET |
| el horario | «alarma», `srtAlarmas ala1..5` | — |
| la franja | hora de inicio + hora de fin | — |

Y dos avisos de lectura: `srtAlarmas` está **mal escrito** (debería ser `str`, como el resto),
así que quien busque `strAlarmas` no lo encuentra. Y `strAlarm` (sin `as`) es **otra cosa**: el
estado de la tarea, no una alarma.

Códigos de días: **8** diario · **9** lunes a viernes · **10** fin de semana. Los valores 1..7
serían días concretos y **no están implementados** — ver ROADMAP 2.2.

## Convenciones

- **Comentarios y mensajes de commit en español.** Los comentarios explican **por qué**, no qué:
  el código ya dice qué hace.
- **El código C va sin acentos.** Los fuentes están en Windows-1252 y los instrumentos los
  parsean. Los `.md` sí llevan acentos.
- **Nada bloqueante en el bucle.** Las seis tareas son cooperativas: un `__delay_ms()` en
  cualquiera para a las otras cinco, incluida la que atiende el puerto serie. Hoy hay un
  `__delay_ms(4000)` **dentro de una interrupción** en `main.c`; no lo imites.
- **Un commit = un cambio con sentido propio = un `git revert` limpio.**
- **Mover o renombrar un `.c` y actualizar el simulador van en el mismo commit.** `correr.py`
  lista los fuentes por nombre, y `sim_reset()` enumera las globales del firmware para poder
  ponerlas a cero. Si el firmware gana una global y `sim_reset()` no se entera, los resultados
  pasan a depender del **orden** de las pruebas. Ya pasó.

## Qué NO se versiona

Instaladores (`6 Sw pic/` son 1,3 GB), APK, artefactos de `build/` y `dist/`, `obj/` del
simulador, y el estado local de los IDE. El criterio y el porqué de cada bloque están escritos
en [`.gitignore`](.gitignore).

**Sí** se versionan: los `.md`, el código, los ficheros de KiCad y los gerbers sueltos, las
fotos, y el `.production.hex` — que son 60 KB de texto y la única forma de saber, dentro de seis
meses, qué estaba corriendo en la calle.

## Comandos

```bash
# El simulador. Compila los .c REALES del firmware con gcc y los ejercita.
# 0 PASS · 1 FALLA · 2 ABORTADO. Se corre ANTES de compilar y ANTES de grabar.
cd "D:/@Proyect/Baliza/4 Simulador" && python correr.py

# Compilar el firmware para el PIC. --std=c99 NO es opcional.
cd "D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza_ V1.X"
"C:\Program Files\Microchip\xc8\v2.36\bin\xc8.exe" --chip=18f2550 --std=c99 \
  --outdir=<salida> main.c Alarma.c Aplicacion.c Buzzer.c Cluster.c DS1307.c \
  EEprom.c I2C.c LedLive.c Serial.c TimeBase.c
```

## Skills

| skill | cuándo |
|---|---|
| `verificar` | correr el simulador y leer el resultado sin tragarse falsos verdes |
| `simulador` | tocar el banco de pruebas o añadirle un escenario |
| `verificar-protocolo` | tocar `Serial.c` o la app, o afirmar que un horario quedó programado |
| `entregar` | preparar lo que sale hacia el responsable, el funcional o campo |

Y el agente `firmware-pic` para los cambios en el firmware del PIC.

## Si falta una definición, no la inventes

Se pregunta. Buena parte de lo que hoy se da por sabido viene de una reunión, no de un
documento: la cadencia de 2 s / 2 s del parpadeo es un ejemplo, y merece confirmarse antes de
programarla. **Un requisito que nadie revisó gobernando una señal escolar es peor que un
pendiente abierto.**
