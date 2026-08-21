# Encargo para el agente ejecutor — Fases 1 y 2 del ROADMAP

> Este fichero es el encargo que se le pasa a un agente para que **implemente** los arreglos del
> firmware. Está escrito para alguien que no ha visto este proyecto nunca. Copiar de aquí abajo.

---

Vas a arreglar defectos del firmware de una **señal vial de tránsito**. Trabajas en
`D:\@Proyect\Baliza`.

## 1. Qué es el equipo, y por qué importa

Es la **luz intermitente de una señal que dice «30 CUANDO ACTIVADA»**, instalada frente a un
colegio. Cuando la luz titila, el límite de **30 km/h está vigente** para todo el que pasa.

El horario en el que debe titilar va **impreso en una placa atornillada a la señal**:
*6:00–9:00 · 11:30–13:30 · 15:00–16:30*. Si el equipo hace algo distinto de lo que dice esa
placa, la señal miente a los conductores delante de un colegio, y nadie lo detecta desde el
escritorio.

Controlador: **PIC18F2550**, C con XC8, multitarea cooperativa con protothreads.
Firmware en `1 Firmware\Doc mplabx\18f2550_baliza_ V1.X\`.

## 2. Antes de escribir una línea: lee y mide

1. Lee **`CLAUDE.md`**, **`ROADMAP.md`** y **`ESTADO.md`** de la raíz. Son reglas del proyecto,
   no sugerencias.
2. Lee la skill **`.claude/skills/verificar/SKILL.md`** y la skill
   **`.claude/skills/simulador/SKILL.md`**. Explican cómo se mide aquí y cuáles son los falsos
   verdes que ya nos comió esta máquina.
3. **Corre el simulador y apunta el número de partida:**

```bash
cd "D:/@Proyect/Baliza/4 Simulador" && python correr.py
```

Debe darte **33 comprobaciones · 24 ok · 9 FALLA**, código de salida `1`. **Si no coincide,
para y averigua por qué antes de tocar nada** — alguien cambió algo.

Sin ese número de partida no hay forma de saber después si tu cambio se midió.

## 3. Las cinco reglas que no puedes romper

1. **La tarjeta está fabricada, montada y en la calle. Es un dato fijo.** Cuando el firmware y
   la placa no coincidan, **se cambia el firmware**. No propongas cambios de hardware, ni
   componentes, ni cortar pistas. `HARDWARE.md` describe lo que hay.
2. **No grabes el PIC.** Ni con MPLAB IPE, ni con `ipecmd`, ni de ninguna forma. Hay señales
   montadas en la calle al otro lado del programador. Compilar sí; grabar no.
3. **No cambies el protocolo de tramas.** Es un contrato literal con un APK ya instalado en
   móviles. Antes de tocar `Serial.c`, lee la skill
   `.claude/skills/verificar-protocolo/SKILL.md`: hay dos cosas que funcionan **por casualidad**
   (el delimitador que viaja en UTF-8, y el filtro de bytes NUL que tapa un defecto de la app) y
   que se rompen si alguien las «limpia».
4. **Un arreglo, un commit.** Mensajes en español, explicando **por qué**. Nada de un commit
   gigante con todo.
5. **El código C va sin acentos** (los fuentes están en Windows-1252 y los instrumentos los
   parsean). Los `.md` sí llevan acentos. Los comentarios explican **por qué**, no qué.

## 4. Lo que tienes que arreglar, en este orden

Cada tarea dice **qué escenario del simulador tiene que ponerse verde**. Ese es el criterio de
aceptación: no «me parece que ya está».

### T1 · La luz no enciende si el equipo arranca dentro de una franja
**Fichero:** `Alarma.c` · **escenario:** `D1` · **es el más grave**

`Alarma.c` compara por **igualdad exacta**: `rtc.hor == hourInit && rtc.min == minInit`. Si ese
minuto exacto pasa mientras el equipo está apagado, la luz no vuelve hasta el día siguiente.
**Un corte de luz de un minuto a las 06:30 deja la señal apagada toda la mañana escolar.**

**Cómo se arregla:** deja de preguntar «¿es el minuto de inicio?» y pregunta **«¿estoy dentro de
la franja?»**. El estado de la luz pasa a ser una consecuencia de la hora actual, no de haber
pillado un instante. Evalúalo en cada vuelta.

**Ojo con dos cosas:**
- Compara en minutos-del-día (`hora * 60 + minuto`), que es más simple y menos propenso a error
  que comparar hora y minuto por separado.
- **Decide y documenta qué pasa si la hora de fin es menor que la de inicio** (una franja que
  cruza la medianoche). Hoy no está contemplado. Si eliges no soportarlo, **rechaza esa
  configuración explícitamente**, no la dejes en un comportamiento indefinido.

### T2 · Dos franjas solapadas se apagan entre ellas
**Fichero:** `Alarma.c` · **escenario:** `D6`

Las cinco alarmas comparten **un solo** `ap.flagAlarm`. La primera que llega a su hora de fin
apaga la luz, aunque otra siga dentro de su franja.

**Cómo se arregla:** cae solo con T1. Si la luz es «¿hay **alguna** franja activa ahora?», el
solape deja de ser un caso especial. **Hazlo junto con T1**, no por separado: separarlos es
escribir dos veces la misma lógica.

### T3 · Una trama malformada tumba el firmware
**Fichero:** `Serial.c` (`extraerValue`, `extraerFrame`, `receiverUart1`) · **escenario:** `D5`

`extraerValue()` llama a `strstr()` y **no comprueba si devolvió NULL**, y luego copia en un
`char buffer[4]` hasta encontrar el carácter final, **sin límite**. Una trama a la que le falte
una coma recorre memoria hasta dar con un byte que coincida por casualidad. En el simulador el
proceso **se cae de verdad**; en el PIC no hay proceso que caiga, hay una señal en un poste que
se queda en un estado que nadie ha previsto.

No hace falta mala fe: basta con que el enlace Bluetooth pierda unos bytes a mitad de trama.

**Cómo se arregla:**
- Comprueba el `NULL` de `strstr()` en `extraerValue()` **y** en `extraerFrame()`.
- Acota toda copia al tamaño del destino.
- Mira también `receiverUart1()` (`Serial.c:76`): escribe en el buffer de 40 bytes **sin
  comprobar el límite**. Arréglalo en la misma tarea.
- **Rechaza la trama entera si no está completa**, en vez de interpretar lo que haya.

### T4 · Los días concretos: se tragan la orden y cuelgan la tarea
**Ficheros:** `Serial.c` y `Alarma.c` · **escenarios:** `D2` y `D3`

Dos defectos encadenados:
- En `Serial.c`, una alarma pedida para un día concreto (1..7) cae en un `else` **vacío**: no se
  graba nada y no se avisa. La app dice «Mensaje Enviado!!» y la alarma no existe.
- En `Alarma.c`, si el indicador de «día personalizado» llega a valer 1, la tarea se queda
  **clavada en `ST_CHECK_ALARM1` para siempre** (medido: estado 6 → 6). Deja de mirar el reloj y
  se lleva por delante las otras cuatro alarmas.

**Antes de programar, decide y escribe cuál de las dos salidas eliges** — las dos son legítimas:
- **(a)** implementar los días concretos de verdad, o
- **(b)** rechazar explícitamente esas tramas y no grabar nada.

Lo que **no** puede quedarse es la rama vacía, que es la única opción que cuelga el equipo.
Sea cual sea tu decisión, **cierra la rama sin salida de `Alarma.c`**: ningún estado puede
quedarse sin transición.

Si eliges (b), el escenario `D2` habrá que **invertirlo** (pasa a exigir que la trama se
rechace). Eso es correcto — pero léete el punto 6 de la skill `verificar` antes de tocar un
escenario.

### T5 · `transmitUart1` manda un byte 0x00 de más
**Fichero:** `Serial.c:59` · **escenario:** `D4` · **trivial**

El bucle usa `x <= ucCntTx1` donde debe usar `<`, así que el último byte transmitido es el `\0`
terminador. Cada línea que el equipo manda al móvil lleva un `0x00` pegado detrás.

### T6 · El buzzer está en el pin equivocado
**Ficheros:** `Buzzer.h:24-25` y `Buzzer.c:162-163` · **sin escenario todavía**

La placa tiene el buzzer en **RC1**. El firmware escribe en **RC0**, que en la tarjeta es la
línea del pulsador con su resistencia de subida. En `Buzzer.c:162` está la línea correcta
**comentada** (`//TRISCbits.TRISC1 = 0;`): alguien lo supo y se deshizo. No lo vuelvas a
deshacer.

**Cómo se arregla:**
- Pasa el buzzer a RC1.
- **Escribe un escenario nuevo en el simulador que fije el pin**, para que no vuelva a moverse.
- **Comprueba qué le estaba haciendo el firmware a RC0** y si hay que dejar de forzarlo como
  salida: es una entrada con pulsador en la tarjeta real.

## 5. Lo que NO tienes que hacer

- ❌ **No toques `Cluster.c` ni la cadencia del parpadeo.** Hay una decisión abierta y sin
  resolver: el firmware hace ráfagas de 50 ms, una reunión dijo 2 s / 2 s, y un informe cita
  norma vial pidiendo 500 ms / 500 ms. **Las tres cifras difieren y nadie ha confirmado cuál
  vale.** El escenario `C` seguirá en rojo al terminar y eso es correcto.
- ❌ **No hagas la refactorización de las cinco alarmas a un array.** Está en el ROADMAP (fase 5)
  y va **después** de estos arreglos, con los escenarios ya en verde vigilando. Hacerla ahora
  mezcla dos cambios y hace imposible saber cuál rompió qué.
- ❌ **No toques la app Android.** Está en otra fase.
- ❌ **No reescribas escenarios en bloque para que pasen.** Si un escenario falla tras tu
  arreglo, va uno por uno: **se borra** (solo documentaba el defecto), **se invierte** (pasa a
  exigir lo nuevo) o **se conserva** (medía otra cosa). Ajustar el instrumento hasta que dé
  verde es el error que este proyecto no se puede permitir.

## 6. Cómo trabajar cada arreglo

Para cada tarea, en este ciclo:

1. **Corre el simulador y apunta el número.**
2. **Localiza el escenario que mide el defecto** en `4 Simulador/arnes.c` y léelo. Está
   comentado con el `archivo:linea` del defecto.
3. **Arregla el firmware.**
4. **Corre el simulador otra vez.** El escenario tiene que pasar a verde **y el resto no puede
   moverse**. Si algo más cambió, entiende por qué antes de seguir.
5. **Quítale la marca `[ROJO ESPERADO ...]`** al escenario que acabas de poner en verde, y
   **limpia su comentario en el mismo commit**. Un escenario que sigue anunciando un defecto ya
   arreglado miente igual que uno que oculta un defecto vivo.
6. **Commit**, con el número del simulador antes y después en el mensaje.

**Y una comprobación de honestidad, al menos una vez:** cuando tengas un escenario en verde,
**reintroduce el defecto a propósito** y confirma que vuelve a rojo, y que al restaurar vuelve
**exactamente** al número anterior. Un escenario que da verde con el defecto puesto no mide
nada. La skill `verificar`, punto 5, lo explica.

## 7. Compilar de verdad para el PIC, al terminar

El simulador usa gcc; el equipo usa XC8. **Comprueba que lo que escribiste compila también para
el PIC**:

```bash
cd "D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza_ V1.X"
"C:\Program Files\Microchip\xc8\v2.36\bin\xc8.exe" --chip=18f2550 --std=c99 \
  --outdir="D:\@Proyect\Baliza\1 Firmware\Doc mplabx\build_xc8" \
  main.c Alarma.c Aplicacion.c Buzzer.c Cluster.c DS1307.c EEprom.c I2C.c \
  LedLive.c Serial.c TimeBase.c
```

- **`--std=c99` no es opcional**: en C90 falla en `DS1307.c:66`. No toques ese fichero.
- **`--outdir` siempre fuera del árbol de fuentes**: sin él XC8 deja 1,1 MB de basura entre los
  `.c`. Ya pasó.
- Partida: **21.309 de 32.768 bytes (65,0 %)** y 687 de 2.048 de datos. **Apunta cuánto ocupa
  después de tus cambios.**

## 8. Criterio de aceptación

Al terminar, el simulador tiene que dar:

| | antes | después |
|---|---|---|
| comprobaciones | 33 | 33 + las que añadas en T6 |
| ok | 24 | **31** + las nuevas |
| FALLA | 9 | **2** |

**Y los 2 rojos que queden tienen que ser exactamente los dos del escenario `C`** (duración del
pulso encendido y del apagado), que son los de la cadencia sin decidir. **Si queda en rojo
cualquier otra cosa, no has terminado.** Si el total de comprobaciones no subió al añadir el
escenario de T6, es que no lo estás midiendo.

Y `xc8.exe` tiene que compilar con **código de salida 0**.

## 9. Qué reportar al terminar

Un resumen corto, sin adornos:

1. El número del simulador antes y después, y cuántos bytes ocupa el binario antes y después.
2. **Un commit por arreglo**, listados.
3. **La decisión que tomaste en T4** (implementar los días concretos o rechazarlos) y por qué.
4. **Qué escenarios tocaste y por qué** — si invertiste alguno, dilo explícitamente y justifica
   por qué era invertirlo y no borrarlo.
5. **Lo que NO pudiste cerrar**, y qué haría falta para cerrarlo.
6. **Cualquier cosa que encontraste y que no estaba en el encargo.** No la arregles por tu
   cuenta si se sale del alcance: anótala.

## 10. Y lo último, que es lo más importante

**Verde en el simulador no es entregable, y ni siquiera autoriza a grabar.** El simulador no
toca un solo pin real, ni el I²C, ni el ADC, ni el Bluetooth. Todo lo que hagas queda pendiente
de una prueba de banco con el equipo delante.

No escribas en ningún documento que algo «funciona» o «está listo para campo». Escribe qué
mediste, con qué instrumento, y qué sigue sin medirse.
