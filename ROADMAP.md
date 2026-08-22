# Hoja de ruta — Baliza «30 CUANDO ACTIVADA»

**Última auditoría: 22-ago-2026.** Lo que aquí figura como medido está medido, no declarado.

## Dónde estamos

**La v3.3 es la línea base: es la pareja que funcionó contra una señal real.** Encima hay 40
commits del 22-ago-2026 con mejoras de verdad, que son **candidatas a la próxima versión** y
todavía no han pasado por funcional.

| | v3.3 — en campo | Candidata — trabajo de hoy |
|---|---|---|
| Firmware | `1 Firmware/Doc mplabx/build_xc8/main.hex`<br>59.577 B · `c14b4350d960…` | `1 Firmware/BALIZA_18F2550_V1_CORREGIDO.hex`<br>49.068 B · `048856fc78e8…` |
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

### 3. Validar la pareja nueva junta contra una señal real

Como se hizo con la v3.3. Firmware nuevo + App nueva, sobre una señal, comprobando que el
horario programado coincide con la chapa atornillada. El simulador no puede sustituir esto.

---

## Defectos abiertos

### 4. La temperatura no se mide — y son dos defectos, no uno

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

### 5. La versión de XC8 del binario de la v3.3 no está registrada

`build_xc8/` conserva el `.hex` pero **no el `.map`**, así que del binario que está en la calle
no consta con qué compilador se hizo. Por la regla 4, el compilador, su driver y sus banderas
son parte del entregable. Se recupera recompilando y comparando, o se anota si alguien lo sabe.

### 6. Los 1 kΩ en serie en `MCU_TX`

El `RXD` del módulo Bluetooth es de 3,3 V y se ataca con 5 V sin adaptación. No es un fallo —el
enlace funciona— es un riesgo que mata módulos a las semanas. Va en el arnés de cables, **no en
la PCB**, que está fabricada.

### 7. Códigos de día 1..7 — no implementado

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
* Estado de la última sesión: [`ESTADO.md`](ESTADO.md)
