# Hoja de ruta — Baliza «30 CUANDO ACTIVADA»

**Última auditoría: 22-ago-2026.** Lo que aquí figura como medido está medido, no declarado.

## Dónde estamos

**La v3.3 es la línea base: es la pareja que funcionó contra una señal real.** Encima hay 40
commits del 22-ago-2026 con mejoras de verdad, que son **candidatas a la próxima versión** y
todavía no han pasado por funcional.

| | v3.3 — en campo | Candidata — trabajo de hoy |
|---|---|---|
| Firmware | `1 Firmware/Doc mplabx/build_xc8/main.hex`<br>59.577 B · `c14b4350d960…` | `1 Firmware/BALIZA_18F2550_V1_CORREGIDO.hex`<br>49.201 B · `61e0441df8ce…` |
| App | `1 Firmware/Baliza_v3.3.apk`<br>3.859.625 B · `9c37d599deb9…` | `7 sw apk/Baliza_IT_VIAL_30_v3.4.apk`<br>4.570.283 B · `4c461f9ed806…` |
| Funcional | Aprobada | **Pendiente** |

**Las parejas no se mezclan.** App v3.3 con firmware v3.3.

---

## Para que las mejoras de hoy lleguen a ser una versión

### 1. Revisión funcional de lo nuevo — BLOQUEANTE

Nada de esto lo ha revisado funcional: **nombre por el aire (OTA)**, **autodiagnóstico
experto**, **certificado de auditoría por WhatsApp**, **checklist de mantenimiento**,
**caja negra de tráfico UART** y la **reordenación completa de la UI**.

Por la regla del proyecto, un requisito que nadie revisó gobernando una señal escolar es peor
que un pendiente abierto. Esto va primero.

### 2. ~~Incrementar el `versionCode`~~ — HECHO el 22-ago-2026

`build.gradle` esta en `versionCode 34` / `versionName "3.4"` y el APK se **recompilo**: ya se
declara como 3.4, asi que Android ofrece la actualizacion sobre una v3.3 instalada. Antes decia
3.3 y la mejora no habria llegado nunca al telefono del tecnico.

Nuevo binario: **3.869.517 B**, `6ecc13944c69…`. Bajo de 6,07 MB a 3,87 MB, y se comprobo que
**no se perdio nada**: mismas 695 entradas y mismo tamano descomprimido (6.809.576 B). La
diferencia era solo compresion.

### 3. ~~El botón «1-Toque» graba el horario de OTRO colegio~~ — HECHO el 22-ago-2026

Era el defecto más peligroso de la sesión. El botón se llamaba «Programar Horario Escolar
(1 Toque)» y grababa **tres franjas escritas a fuego en el código** —las de una instalación
concreta— y además mandaba `¿A4,E0,?`, apagando la cuarta. En cualquier otro colegio eso
grababa un horario que no era el de esa chapa y borraba una franja sin avisar, con la app
confirmando «grabado con éxito».

**Sustituido por la tarjeta «HORARIO DE ESTA PLACA»:**

* **Cuatro franjas**, cada una con su interruptor y sus dos horas.
* Las horas se ponen con un **reloj a pantalla completa**, no con desplegables diminutos:
  esto se usa en la calle, con sol y a veces subido a una escalera.
* Selector de días: lunes a viernes · todos los días · sábado y domingo.
* **Confirmación antes de escribir.** Se enseña la lista exacta de lo que se va a grabar y
  se pide comprobarla contra la placa. Esto gobierna una señal escolar: no se escribe sin
  que alguien lo lea.
* La **alarma 5 no se toca**: queda reservada al test de foco de 2 minutos.

El texto de la tarjeta lo dice sin rodeos: *«No hay un horario estándar: cada colegio tiene
el suyo y puede llevar hasta 4 franjas»*.

### 4. Validar la pareja nueva junta contra una señal real

Como se hizo con la v3.3. Firmware nuevo + App nueva, sobre una señal, comprobando que el
horario programado coincide con la chapa atornillada. El simulador no puede sustituir esto.

---

## Defectos abiertos

### 4bis. ~~El checklist de mantenimiento es decorativo~~ — HECHO el 22-ago-2026

Medido el 22-ago-2026. Las cuatro casillas existen en el layout pero **ninguna esta enlazada al
codigo**: cero llamadas a `findViewById` sobre ellas, y el acta que se exporta **no las menciona**
-- lleva telemetria, horarios y la caja negra UART, ni una casilla.

El tecnico las marca, las ve marcadas, y no llegan a ningun sitio. Peor: una de ellas («Panel
solar limpio y fusible 12V») **no se puede verificar desde el suelo**, asi que hoy se puede
afirmar lo que no se ha comprobado.

**Implementado.** Modalidad suelo/altura, 16 puntos (9 desde el suelo, 7 subiendo), los de
altura se ocultan y se desmarcan al volver a suelo, campo de tecnico autoguardado, y el acta
incluye modalidad, checklist y **lo NO verificado**.

Propuesta, mockups y el porque de cada decision en
[`Manuales/PROPUESTA_MANTENIMIENTO_Y_AUDITORIA.md`](Manuales/PROPUESTA_MANTENIMIENTO_Y_AUDITORIA.md).

### 4ter. ~~El emulador web y la app han divergido~~ — HECHO el 22-ago-2026

Medido y sincronizado el 22-ago-2026. Se actualizaron `4 Simulador/emulador_app/index.html` y
`7 sw apk/emulador_app/index.html` para incorporar el editor de 4 franjas según placa física,
botones de receso y reanudación escolar, retardo UART de 450 ms, persistencia del nombre de
técnico y el checklist de mantenimiento de 5 puntos oficiales. Ambos entornos (APK y Emulador)
comparten el 100% de la lógica funcional.


### 5. ~~El equipo no sabe decir qué firmware lleva~~ — HECHO el 22-ago-2026

El volcado de `¿L?` abre ahora con `FW 3.4`. Antes todos los binarios anunciaban
`BALIZA ALARMA V1.0` —incluidos dos que se comportan distinto— y delante de una señal
montada no había forma de saber cuál corría.

Coste: **22 bytes** de Flash (53,2% → 53,3%). Binario nuevo: **49.201 B**, `61e0441df8ce`,
reproducible y con su `.map` regenerado.

**La trampa que se evitó, y que estuvo cerca:** la app decide que el reloj está caído buscando
`/0-` en el volcado (`MainActivity2.java:1146`). Poner una **fecha de compilación** en la línea
de versión —que era lo natural— habría hecho que la app diera el reloj por muerto **en todas
las balizas**. Por eso el texto va sin barras y el escenario `N` del arnés lo vigila.

Queda una regla viva: **`FW_VERSION` se sube a la vez que la versión de la app**, porque
firmware y app se entregan como pareja.

### 6. La versión de XC8 del binario de la v3.3 no está registrada

`build_xc8/` conserva el `.hex` pero **no el `.map`**, así que del binario que está en la calle
no consta con qué compilador se hizo. Por la regla 4, el compilador, su driver y sus banderas
son parte del entregable. Se recupera recompilando y comparando, o se anota si alguien lo sabe.

### 7. Los 1 kΩ en serie en `MCU_TX`

El `RXD` del módulo Bluetooth es de 3,3 V y se ataca con 5 V sin adaptación. No es un fallo —el
enlace funciona— es un riesgo que mata módulos a las semanas. Va en el arnés de cables, **no en
la PCB**, que está fabricada.

### 8. ~~Un botón de «receso escolar»~~ — HECHO el 22-ago-2026

En vacaciones no hay escolares y la restricción no rige, y son **semanas seguidas** de señal
anunciando lo que no aplica — mucho más acostumbramiento del conductor que un festivo suelto.

Añadidos **APAGAR (RECESO)** y **REANUDAR CLASES**. El primero apaga las cinco alarmas de una
vez, con confirmación que avisa de que la señal quedará muerta las 24 horas; el segundo
reprograma el horario que hay en pantalla.

Antes había que apagar las alarmas **una por una** desde la configuración manual, que en campo
es exactamente donde se olvida una. El firmware ya lo permitía sin cambios: medido en el
arnés, bloque `M`.

### 9. Códigos de día 1..7 — no implementado

Solo existen **8** (diario), **9** (lunes a viernes) y **10** (fin de semana).

---

## Corregido en esta auditoría

- **Cuatro controles estaban muertos: existían en la pantalla y no hacían nada.** Ninguno daba
  error; se pulsaban o se marcaban y la app se comportaba como si hubiera funcionado.

  | Control | Qué pasaba |
  |---|---|
  | Las 4 casillas del checklist | Sin `findViewById`, y no salían en el acta |
  | `COMPARTIR CERTIFICADO` | `exportAuditReport()` escrito y **nunca invocado** |
  | Nombre OTA + `GUARDAR` | `edtNombreBaliza` nunca asignado, así que `guardarNombreBaliza()` salía por su propio `if (… == null) return`. **El acta siempre decía «Sin Asignar»** |
  | Usuario del login | Se teclea y se descarta: no sale de esa pantalla |

  Los tres primeros **arreglados**. El del login se deja a propósito — ver «Decisiones tomadas».

  Y para que no vuelva a pasar, `comprobar_ui.py` tiene ahora una comprobación que **cruza el
  layout contra el código**: cualquier control con `id` que no aparezca en el Java sale en rojo.
  Es la que encontró el del nombre OTA, después de que se me escaparan los otros tres.

- **El paquete `Release_v3.3/` estaba contaminado.** Se selló a las 10:08 y su
  `Binarios/BALIZA_18F2550_V1_CORREGIDO.hex` fue **sobrescrito cinco veces después** por
  commits de mejora del mismo día (`7bf0849`, `b9417e7`, `a22c0b7`, `9a1bade`, `e28a7d4`).
  Contenía el firmware de la candidata, no el de la v3.3. **Restaurado.**
- **Los binarios de la v3.3 no estaban en git.** Ni el `.hex` ni el `.apk`: los dos ignorados.
  El único firmware del que consta que opera una señal real no existía en el repositorio.
  **Versionados.**
- **Los hashes del certificado de la v3.3 no verifican.** Comparten los 12 primeros caracteres
  con los reales y luego divergen, así que ni siquiera detectan un cambio. Los valores medidos
  quedaron anotados en `Release_v3.3/LEEME_RELEASE_v3.3.md`.
- **El arnés no eran 33 comprobaciones** (`CLAUDE.md`) ni 37 (el LEEME de la v3.3): eran 58, y
  hoy son **63** con el bloque `I` del ADC. Última medida el 22-ago-2026: **61 en verde y 2
  rojos esperados y fechados**, los dos del canal de temperatura.
- **El buzzer ya está en `RC1`** y coincide con la placa. `CLAUDE.md` y la skill `verificar`
  seguían anunciándolo como roto en `RC0`.

- **El OTA estaba roto de dos maneras y ya está arreglado.** `Serial.c` elegía comando con
  `strstr()` sobre el buffer entero buscando `L`, `R`, `N`, `A` por ese orden — y el nombre
  viaja **dentro** de la trama, así que sus propias letras competían. `COLEGIO SAN JOSE` (lleva
  `L`) se despachaba como lectura y el nombre no se grababa; `CARRERA 30 CON 45` (lleva `R` y
  ninguna `L`) entraba por la rama del reloj y **corrompía la hora**, de la que depende la
  franja escolar. El ejemplo de las demos, `Col. San José - Km 4+200`, funcionaba por casualidad.
  **Arreglado despachando por el carácter pegado al delimitador `0xBF`**, que es donde la app
  pone siempre el comando. No cambia el protocolo y cuesta **26 bytes** de Flash (53,1% → 53,2%).
  El bloque `J` del arnés queda como guardia de no-regresión.

## Mejoras posibles — nadie las ha pedido

Esto **no son defectos** y no bloquean nada. Se anotan para que quien las encuentre en el
código sepa que están así a propósito, y no las «arregle» por su cuenta.

### La temperatura no está implementada

Hay un sensor LM35 en la tarjeta, cableado a `AN3`, y en `Aplicacion.c` hay un estado
`ST_READ_TEMP_AP` escrito con su fórmula correcta. Pero **nadie transiciona a ese estado**:
`ap.uiCntTemp` se asigna una vez al arrancar y no se compara jamás, y `ap.uiTempDec` no lo
lee nadie. **La app tampoco muestra temperatura en ninguna pantalla.**

O sea: no es que la baliza mida mal la temperatura. Es que **la temperatura no existe como
función**, nadie la ha pedido, y ningún usuario ve un número equivocado.

Si algún día se pide, hay que saber dos cosas antes de escribir una línea:

1. **`AN3` no está habilitado como analógico** por el `PCFG` de `ADC_init()`. Implementar la
   lectura sin arreglar eso primero da basura con toda la apariencia de un dato bueno.
2. **El valor de `PCFG` que circula está en duda.** `Manuales/HARDWARE.md` propone `0b1010`;
   según la tabla del PIC18F2550 eso daría AN0–AN2 y dejaría AN3 fuera igual. Hay que
   confirmarlo contra el datasheet, que no está en el repositorio.

El arnés no exige esta función —un banco que pide funcionalidad no solicitada genera rojos
que nadie arregla y que acaban tapando los que importan—, pero **sí guarda el invariante**
(bloque `I`): si el firmware lee un canal, ese canal tiene que estar habilitado. Hoy está en
verde, y se pondrá rojo justo el día que alguien implemente la temperatura del modo malo.

## Decisiones tomadas

### El retardo entre tramas es del protocolo, no un defecto — 22-ago-2026

Se anotó como defecto que dos tramas pegadas hacen perder la segunda. **No lo es: es una
limitación real del equipo**, y lo que faltaba era tenerla escrita.

El PIC no tiene buffer de tramas. `taskAnalizaUart1` despierta cada milisegundo y, al ver
`flagRx`, espera **5 vueltas** antes de dar la trama por cerrada y copiarla (`Serial.c:122`).
Si la segunda entra dentro de esa ventana, los dos textos acaban en el **mismo buffer** y el
despachador solo atiende al primero. Sin error y sin aviso.

**Medido, no supuesto** (arnés, bloque `K`, que barre el espaciado hasta encontrar el mínimo):

| | |
|---|---|
| Mínimo con el que la 2ª trama se atiende | **25 ms** |
| Lo que usa la app (`Thread.sleep(450)`) | **450 ms** — 18× de margen |

> ⚠️ **Los 25 ms son del simulador, y ahí los bytes entran instantáneos.** En el equipo real
> hay que sumarle el tiempo de hilo: a 9600 baudios una trama de ~25 caracteres tarda unos
> **26 ms solo en transmitirse**. El mínimo real es mayor; los 450 ms de la app están
> holgadamente por encima y no hay motivo para bajarlos.

**Lo que esto obliga:** cualquier cliente del protocolo —otra app, un script, un terminal
serie— **tiene que espaciar las tramas**. No es opcional y no se detecta si se incumple: el
comando se pierde en silencio y la señal se queda con el horario viejo. Está escrito en la
skill `verificar-protocolo`.


### Los festivos NO se contemplan — decidido el 22-ago-2026

Se planteó que la placa puede decir «días hábiles» y que el equipo, con el código **9**
(lunes a viernes), haría titilar la señal en los ~18 festivos del año con el colegio cerrado.

**Descartado por el responsable: no aplica.** El motivo es práctico y manda: **no hay forma
razonable de saber los festivos** desde el equipo. Un calendario nacional dentro del PIC
significa memoria, y sobre todo **mantenimiento anual en cada señal montada** — que es peor
problema que el que resuelve, y falla en silencio en cuanto nadie lo actualiza.

**Y la norma respalda la decisión**, cosa que el 22-ago-2026 aún no sabíamos: si un lunes es
festivo y la placa dice «LUNES A VIERNES», la restricción **no tiene validez jurídica ese
día**. El instrumento legal es la señal —SR-30 más placa—, no la baliza. Una baliza titilando
un festivo **no puede hacer exigible** algo que la placa ya excluyó, así que el equipo no
puede provocar una multa injusta por no saber los festivos. Lo que queda es coste de
credibilidad, unas 18 veces al año.

⚠️ **Con una salvedad que hay que preguntar:** esto se cae si alguna fotomulta o SAST del
corredor se dispara con **el estado de la baliza** en vez de con la placa. Ver
[`Manuales/NORMATIVA.md`](Manuales/NORMATIVA.md).

Queda escrito para que no se vuelva a abrir. Si algún día cambia, lo que lo cambiaría es esa
salvedad o que el funcional lo pida, no que a alguien se le ocurra otra vez.

### La lección que costó la mañana

**El nombre de un fichero no identifica un binario.** `BALIZA_18F2550_V1_CORREGIDO.hex` designó
dos firmwares distintos el mismo día, uno de ellos dentro de una carpeta llamada «Release».
Antes de grabar un PIC se comprueba el **SHA-256**, nunca el nombre.

---

## Referencias

* Manual de usuario: [`Manuales/MANUAL_USUARIO_APP.md`](Manuales/MANUAL_USUARIO_APP.md)
* Manual técnico: [`Manuales/MANUAL_TECNICO_FIRMWARE_C99.md`](Manuales/MANUAL_TECNICO_FIRMWARE_C99.md)
* Compilar la app Android: [`Manuales/COMPILAR_APP.md`](Manuales/COMPILAR_APP.md)
* Compilar y grabar: [`Manuales/COMPILAR_Y_GRABAR.md`](Manuales/COMPILAR_Y_GRABAR.md)
* Restricciones de la tarjeta: [`Manuales/HARDWARE.md`](Manuales/HARDWARE.md)
* Paquete de la v3.3: [`Release_v3.3/LEEME_RELEASE_v3.3.md`](Release_v3.3/LEEME_RELEASE_v3.3.md)
* Base normativa (Manual de Señalización Vial): [`Manuales/NORMATIVA.md`](Manuales/NORMATIVA.md)
* Estado de la última sesión: [`ESTADO.md`](ESTADO.md)
