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
| **Binario de la v3.3** | `1 Firmware/Doc mplabx/build_xc8/main.hex` | **El que funcionó en campo.** 59.577 B, `c14b4350d960…` |
| **App de la v3.3** | `1 Firmware/Baliza_v3.3.apk` | La que funcionó con ese `.hex`. 3.859.625 B, `9c37d599deb9…` |
| Candidata (mejoras de hoy) | `BALIZA_18F2550_V1_CORREGIDO.hex` + `Baliza_IT_VIAL_30_v3.4.apk` | 49.068 B / 6.066.074 B. **Sin funcional** — ver ROADMAP |
| App Android | `1 Firmware/Doc Aplicativo Movil/BalizaV10/` | Gradle + Java nativo. **No es App Inventor** |
| Tarjeta | `2 Hardware tarjeta/` | KiCad y gerbers. **Fabricada y montada** — ver regla 1 |
| Simulador | `4 Simulador/` | 58 comprobaciones, corre en un segundo |
| Bluetooth | `5 HW bluetooth/` | Solo el datasheet del **SoC**, no el del módulo |

Punto de entrada: **[README.md](README.md)**. Qué falta y en qué orden:
**[ROADMAP.md](ROADMAP.md)**. En qué quedó la última sesión y las cifras del día:
**[ESTADO.md](ESTADO.md)**.

**El Bluetooth ya no bloquea**: el **SIG0109A funciona** — verificado el
21-ago-2026 con un `¿L?` que devolvió el volcado legible. El *«no lo reconoce»* era buscarlo por
el nombre equivocado, no una avería. Lo que queda vivo de ahí es un riesgo, no un fallo: el
`RXD` de 3,3 V del módulo está atacado con **5 V sin adaptación**, y eso mata módulos a las
semanas — **1 kΩ en serie en `MCU_TX`**, en el arnés, no en la PCB.

## Las cinco reglas que no se rompen

### 0 bis. Un binario se identifica por su SHA-256, nunca por su nombre

El 22-ago-2026 el nombre `BALIZA_18F2550_V1_CORREGIDO.hex` designó **dos firmwares distintos
el mismo día**, y uno de ellos vivía dentro de una carpeta llamada `Release_v3.3/Binarios/`.
El paquete se selló a las 10:08 y su binario fue **sobrescrito cinco veces después** por
commits de mejora, sin que nadie lo notara: el nombre seguía siendo el mismo.

La consecuencia es la peor posible en este proyecto: alguien coge el fichero de la carpeta de
release, lo graba, y la señal se queda con un firmware que nadie valido en campo.

**Antes de grabar un PIC o de instalar un APK se comprueba el hash**, y se comprueba contra la
cifra medida sobre el fichero, no contra la que declara un documento — los hashes del
certificado de la v3.3 **no verificaban**: compartían los 12 primeros caracteres con los
reales y luego divergían, así que ni siquiera servían para detectar el cambio.

**Y la pareja no se mezcla.** La v3.3 son dos ficheros que se probaron juntos contra una señal
real: la App v3.3 con el `.hex` de la v3.3. Un firmware nuevo con una App vieja, o al revés,
es una combinación que nadie ha visto funcionar.

> **Y git tampoco puede tocarlos.** Esta máquina tiene `core.autocrlf=true`, y un `.hex` es
> texto: hasta el 22-ago-2026 los tres `.hex` del repositorio se guardaban con los saltos de
> línea convertidos, así que el blob almacenado **no era el fichero entregado** — el de la v3.3
> pasaba de 59.577 a 58.250 bytes y su hash dejaba de ser el que publica la documentación. Aquí
> no se notaba porque el checkout deshace la conversión; quien clonara en Linux se llevaba un
> binario cuyo hash no coincidía con ningún certificado. Lo evita
> [`.gitattributes`](.gitattributes), marcando `*.hex`, `*.map` y `*.apk` como `binary`. **Si
> añades un tipo de entregable nuevo, márcalo ahí en el mismo cambio.**


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
que hay es lo que hay, y está descrito en [`Manuales/HARDWARE.md`](Manuales/HARDWARE.md).

Auditado el **22-ago-2026**: de los dos desajustes que hubo, **queda uno vivo**.

- **La temperatura — VIVO.** El sensor entra por `AN3` (`Aplicacion.c:236` llama a
  `ADC_read(3)`), y `main.c:175` pone `PCFG = 0b1011`, que solo habilita AN0–AN2. AN3 queda
  digital y la conversión devuelve basura. **La fórmula ya se arregló** y hoy es correcta
  (`(ADC * 5000) / 1024`, décimas de grado para un LM35); lo que falta es habilitar el canal.
  El simulador **no lo puede ver**: devuelve el valor que se le pida y nunca mira `PCFG`. Por
  eso sobrevivió a 58 comprobaciones en verde. Ver ROADMAP, pendiente 1.
- **El buzzer — YA ARREGLADO (verificado 22-ago-2026).** `Buzzer.h:24` ataca `LATC1` y
  `pinConfBuzzer()` pone `TRISC1 = 0` / `TRISC0 = 1`, que es lo que pide la placa. Coincide.
  **No lo "arregles" otra vez hacia `RC0`**: esa era la versión rota.

La medida de **tensión sí es correcta** —el divisor da factor 6 y el firmware aplica 6— y no se
toca.

🚫 Y el corolario que hace falta escribir porque tiene tirón: **no propongas mejoras de
hardware.** Ni fusibles, ni diodos de rueda libre, ni cambiar el MOSFET. Están anotados como
restricciones en `Manuales/HARDWARE.md` para que el firmware trabaje alrededor, no como una lista de
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

### 4. Compilar tiene cuatro trampas, y todas ya costaron tiempo

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

Detalle completo en [`Manuales/COMPILAR_Y_GRABAR.md`](Manuales/COMPILAR_Y_GRABAR.md).

🚫 **No grabes el PIC sin que te lo pidan.** Hay señales montadas en la calle al otro lado.

### 5. El firmware no distingue módulos Bluetooth

Circula la idea de que el `.hex` está «compilado para otro Bluetooth». **Es falsa y está
costando tiempo.** Para el firmware el módulo es un puerto serie transparente a **9600 8N1
fijo** (`UART.h`, `SPBRG = 32`, `BRGH = 0`). No sabe ni puede saber qué chip hay al otro lado.

Cuando el Bluetooth falle, el problema está en el módulo, en su configuración, en el cableado o
en la app — nunca en que el binario sea de otra versión. Separar esas variables es lo que hace
[`Manuales/BLUETOOTH.md`](Manuales/BLUETOOTH.md), y la prueba que más decide es la de bucle: puentear TX con RX
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
serían días concretos y **no están implementados** — ver ROADMAP, pendiente 4.

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

Instaladores (`6 Sw pic/` son 1,3 GB), el JDK y el Android SDK de `7 sw apk/` (casi 750 MB),
artefactos de `build/` y `dist/`, `obj/` del simulador, y el estado local de los IDE. El
criterio y el porqué de cada bloque están escritos en [`.gitignore`](.gitignore).

**Sí** se versionan: los `.md`, el código, los ficheros de KiCad y los gerbers sueltos, las
fotos, los dos `.hex`, el `.map` del binario que se entrega, y **el APK de campo vigente**
(`7 sw apk/Baliza_IT_VIAL_30_v3.4.apk`).

> **El corolario, que ya costó una entrega rota:** si el README o el ROADMAP **enlazan** un
> fichero, ese fichero **tiene que estar versionado**. El 22-ago-2026 los dos enlazaban el APK
> y el `.map` estando ambos en `.gitignore`: para cualquiera que clonara el repositorio, el
> entregable no existía. Añadir el enlace y añadir la excepción en `.gitignore` van en el
> mismo commit.

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
### 5. Estándar de Documentación Corporativa y Manuales de Usuario

* **Cero emojis informales:** Los manuales dirigidos al cliente final e instaladores deben mantener un tono estrictamente formal, corporativo y técnico (sin emojis decorativos en títulos, tablas ni textos).
* **Validación Obligatoria contra Copia Base (`MANUAL_USUARIO_APP - copia.docx`):**
  * Cuando se modifique o actualice la documentación, **siempre validar la estructura contra `MANUAL_USUARIO_APP - copia.docx` / `MANUAL_USUARIO_APP.docx`**.
  * **Flujo Real de 10 Pasos de la App:**
    * **Paso 1:** Instalación del APK (`Baliza_v3.X.apk`) y advertencia crítica de Play Protect (*Instalar de todas formas*).
    * **Paso 2:** Acceso e Inicio de Sesión (Login `admin` / `admin`).
    * **Paso 3:** Concesión de Permisos de Dispositivos Cercanos (Android 12+).
    * **Paso 4:** Activación de Bluetooth desde la Aplicación.
    * **Paso 5:** Emparejamiento Bluetooth en Ajustes del Teléfono (PIN `1234` / `0000`).
    * **Paso 6:** Conexión con la Baliza (Botón DISPOSITIVO -> Verde `✓ JDY-31-SPP`).
    * **Paso 7:** Función del Botón «LEER» y Consola de Datos.
    * **Paso 8:** Sincronización de Hora y Programación en «1 Toque».
    * **Paso 9:** Configuración Manual de Franjas y Selectores de Horario.
    * **Paso 10:** Módulo de Diagnóstico y Modo de Prueba (2 Minutos a 1.0 Hz).
* **Sin *Know-How* Interno para el Cliente Final:** No exponer nombres de microcontroladores (PIC18F2550), compiladores (XC8/C99), registros ni tramas internas. Indicar claramente el cambio de pila botón de litio estándar comercial **`CR2032` (3V)** para el reloj interno y la medición de voltaje para la batería principal de 12V.
* **Sincronización MD -> DOCX:** El archivo `.md` es la fuente única de verdad. Ejecutar siempre `python generar_word.py <fichero.md>` y verificar con `python generar_word.py --revisar`.

---

## Si falta una definición, no la inventes

Se pregunta. Buena parte de lo que hoy se da por sabido viene de una reunión, no de un
documento. La cadencia del parpadeo fue el caso: se dijo 2 s / 2 s en una reunion, y al
preguntar resulto ser 1 Hz -- 500 ms / 500 ms -- por norma de senalizacion. Preguntar costo una
linea; programarlo mal habria costado volver a grabar todas las senales. **Un requisito que nadie revisó gobernando una señal escolar es peor que un
pendiente abierto.**
