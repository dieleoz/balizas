# Hoja de ruta — Baliza «30 CUANDO ACTIVADA»

**Última auditoría: 22-ago-2026.** Lo que aquí figura como medido está medido, no declarado.

## Dónde estamos

**La v3.3 es la línea base: es la pareja que funcionó contra una señal real.** Encima hay 40
commits del 22-ago-2026 con mejoras de verdad, que son **candidatas a la próxima versión** y
todavía no han pasado por funcional.

| | v3.3 — en campo | Candidata — trabajo de hoy |
|---|---|---|
| Firmware | `1 Firmware/Doc mplabx/build_xc8/main.hex`<br>59.577 B · `c14b4350d960…` | `1 Firmware/BALIZA_18F2550_V1_CORREGIDO.hex`<br>49.133 B · `889c0188914b…` |
| App | `1 Firmware/Baliza_v3.3.apk`<br>3.859.625 B · `9c37d599deb9…` | `7 sw apk/Baliza_IT_VIAL_30_v3.4.apk`<br>3.869.517 B · `6ecc13944c69…` |
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

### 3. El botón «1-Toque» graba el horario de OTRO colegio — BLOQUEANTE

Es el defecto más peligroso encontrado hoy, y no está en el firmware sino en la app.

El botón se llama **«Programar Horario Escolar (1 Toque)»**, como si programase *el* horario
escolar. Lo que hace en realidad (`MainActivity2.java:686-709`) es grabar **tres franjas fijas
en el código**:

```
¿A1,E1,I0600,F0900,D9,?     06:00 - 09:00  Lun-Vie
¿A2,E1,I1130,F1330,D9,?     11:30 - 13:30  Lun-Vie
¿A3,E1,I1500,F1630,D9,?     15:00 - 16:30  Lun-Vie
¿A4,E0,?                    <- APAGA la alarma 4
¿A5,E0,?                    <- APAGA la alarma 5
```


Esas son las franjas de **una instalación concreta**. Pero el horario **es distinto en cada
colegio y puede tener hasta cuatro franjas**. Así que en cualquier señal que no sea la de
referencia, pulsar 1-Toque:

1. Graba **un horario que no es el de esa chapa** — la señal pasa a decir 30 km/h a horas que
   no rigen, y a no decirlo cuando sí rigen.
2. **Borra la cuarta franja** sin avisar, porque manda `¿A4,E0,?` explícitamente.

Y lo peor es que **no hay forma de notarlo desde el teléfono**: la app confirma «¡Horario
Escolar Grabado con Éxito!» igual. El técnico se va convencido.

**El firmware no es el límite:** medido el 22-ago-2026 (arnés, bloque `L`), las cuatro franjas
se graban y la luz obedece a las cuatro. Sobra la alarma 5 para el test de foco.

Lo que hace falta es que el 1-Toque **deje de llevar un horario dentro**: que lo tome de lo que
el técnico lee en la chapa que tiene delante, con las cuatro franjas disponibles y sin apagar
nada que no se le haya pedido apagar. Eso es un cambio de app y de UI, y va por funcional.

> **Y no es solo un defecto técnico: es un incumplimiento normativo.** El Manual de
> Señalización Vial obliga a ajustar los horarios *estrictamente a la realidad operativa del
> centro educativo*, y avisa de que un horario sobredimensionado o desactualizado
> **acostumbra al conductor** y le resta autoridad a la señal. Programar el horario de otro
> colegio es exactamente eso. Ver [`Manuales/NORMATIVA.md`](Manuales/NORMATIVA.md).

### 4. Validar la pareja nueva junta contra una señal real

Como se hizo con la v3.3. Firmware nuevo + App nueva, sobre una señal, comprobando que el
horario programado coincide con la chapa atornillada. El simulador no puede sustituir esto.

---

## Defectos abiertos

### 5. La temperatura no se mide — y son dos defectos, no uno

Medido el 22-ago-2026 con el bloque `I` del arnés, que **no se podía escribir hasta ese día**:
`ADC_init()` vivía en `main.c`, el único `.c` que el arnés no compila, así que el `PCFG` era
invisible para el simulador. Se extrajo a `Adc.c` — **el binario resultante es byte a byte
idéntico**, el refactor no cambió una sola instrucción.

**4a. La lectura de temperatura es código muerto.** El estado `ST_READ_TEMP_AP` está escrito,
pero **ningún sitio transiciona a él**: `ap.uiCntTemp` se asigna una vez en el arranque y no se
incrementa ni se compara jamás, y `ap.uiTempDec` no lo lee nadie. La baliza **no mide la
temperatura** — no es que la mida mal. Nadie está viendo un número equivocado, porque no hay
número.

**4b. `AN3` no está habilitado como analógico** por el `PCFG` de `ADC_init()`, y `Aplicacion.c`
lo leería con `ADC_read(3)`. Hoy es **latente**: no hace daño porque 4a impide que esa lectura
se ejecute. Morderá el día que se implemente la transición sin arreglar esto antes — y ese es
justo el orden en que alguien lo haría.

> ⚠️ **El valor de arreglo que circula está en duda.** `Manuales/HARDWARE.md` propone
> `PCFG = 0b1010`. Según la tabla del PIC18F2455/2550/4455/4550 el número de canales analógicos
> es `(13 - PCFG)`, con lo que `0b1010` daría AN0–AN2 y **dejaría AN3 fuera igual**; haría falta
> `0b1001`. Las dos fuentes del repositorio se contradicen, y `HARDWARE.md` se apoya en el
> comentario del propio código (`//Entradas Analogicas a0, a1, a2`), que es circular.
> **No hay datasheet del PIC en el repositorio.** Aplicar `0b1010` a ciegas dejaría el defecto
> vivo con todo el mundo creyendo que se arregló, que es peor que no tocarlo.
>
> **Pregunta concreta a resolver antes de tocar nada:** en el PIC18F2550, ¿qué valor de
> `ADCON1<PCFG>` habilita AN0 a AN3 como analógicas?

Los dos rojos están en el arnés, fechados, y se quedan hasta que se resuelvan.

### 6. La versión de XC8 del binario de la v3.3 no está registrada

`build_xc8/` conserva el `.hex` pero **no el `.map`**, así que del binario que está en la calle
no consta con qué compilador se hizo. Por la regla 4, el compilador, su driver y sus banderas
son parte del entregable. Se recupera recompilando y comparando, o se anota si alguien lo sabe.

### 7. Los 1 kΩ en serie en `MCU_TX`

El `RXD` del módulo Bluetooth es de 3,3 V y se ataca con 5 V sin adaptación. No es un fallo —el
enlace funciona— es un riesgo que mata módulos a las semanas. Va en el arnés de cables, **no en
la PCB**, que está fabricada.

### 8. Códigos de día 1..7 — no implementado

Solo existen **8** (diario), **9** (lunes a viernes) y **10** (fin de semana).

---

## Corregido en esta auditoría

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

## Decisiones tomadas

### Los festivos NO se contemplan — decidido el 22-ago-2026

Se planteó que la placa puede decir «días hábiles» y que el equipo, con el código **9**
(lunes a viernes), haría titilar la señal en los ~18 festivos del año con el colegio cerrado.

**Descartado por el responsable: no aplica.** El motivo es práctico y manda: **no hay forma
razonable de saber los festivos** desde el equipo. Un calendario nacional dentro del PIC
significa memoria, y sobre todo **mantenimiento anual en cada señal montada** — que es peor
problema que el que resuelve, y falla en silencio en cuanto nadie lo actualiza.

Queda escrito para que no se vuelva a abrir. Si algún día cambia, lo que lo cambiaría es que
el funcional pida explícitamente distinguir festivos, no que a alguien se le ocurra otra vez.

### La lección que costó la mañana

**El nombre de un fichero no identifica un binario.** `BALIZA_18F2550_V1_CORREGIDO.hex` designó
dos firmwares distintos el mismo día, uno de ellos dentro de una carpeta llamada «Release».
Antes de grabar un PIC se comprueba el **SHA-256**, nunca el nombre.

---

## Referencias

* Manual de usuario: [`Manuales/MANUAL_USUARIO_APP.md`](Manuales/MANUAL_USUARIO_APP.md)
* Manual técnico: [`Manuales/MANUAL_TECNICO_FIRMWARE_C99.md`](Manuales/MANUAL_TECNICO_FIRMWARE_C99.md)
* Compilar y grabar: [`Manuales/COMPILAR_Y_GRABAR.md`](Manuales/COMPILAR_Y_GRABAR.md)
* Restricciones de la tarjeta: [`Manuales/HARDWARE.md`](Manuales/HARDWARE.md)
* Paquete de la v3.3: [`Release_v3.3/LEEME_RELEASE_v3.3.md`](Release_v3.3/LEEME_RELEASE_v3.3.md)
* Base normativa (Manual de Señalización Vial): [`Manuales/NORMATIVA.md`](Manuales/NORMATIVA.md)
* Estado de la última sesión: [`ESTADO.md`](ESTADO.md)
