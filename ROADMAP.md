# ROADMAP — Baliza

En qué orden hay que arreglar esto, y **por qué ese orden**. Un roadmap sin el porqué se
reordena a conveniencia en la primera reunión.

Estado del día y cifras vivas: [`ESTADO.md`](ESTADO.md).

---

## El método, antes que la lista

Este proyecto se ataca en tres tiempos, y no se salta ninguno:

```
1. SIMULADOR          →  2. RESTRICCIONES DEL HW  →  3. AVANZAR
   poder medir            saber contra qué se          arreglar, midiendo
   sin ir al poste        está trabajando              cada paso
```

**1. Primero el simulador.** Sin él, cada comprobación cuesta ir a la señal, coger el
programador y esperar a que den las 6:00 de la mañana. Con él, una franja horaria entera se
prueba en un segundo y **se puede hacer que sean las 6:00 cuando convenga**. Está hecho:
`4 Simulador/`, 33 comprobaciones. Nada de lo que viene después se arregla sin que antes exista
el escenario que lo mide.

**2. Después, las restricciones del hardware.** La tarjeta **ya está fabricada, montada y
puesta en un poste**. No es una variable: es el terreno. Antes de proponer nada hay que saber
qué pin va a dónde de verdad. Está hecho: [`Manuales/HARDWARE.md`](Manuales/HARDWARE.md), netlist completa. Y ya
apareció lo que tenía que aparecer — dos sitios donde el firmware y la placa no coinciden.

> **La regla que sale de ahí, y ordena todo lo demás:** cuando el firmware y la tarjeta no
> coincidan, **se cambia el firmware**. No se rediseña la placa, no se corta una pista, no se
> añade un componente. Lo que hay es lo que hay.

**3. Solo entonces, avanzar.** Cada arreglo empieza por su escenario en rojo y termina cuando
ese escenario está en verde y el resto no se movió.

---

## Fase 0 — Lo que bloquea a todo lo demás

### 0.1 · El Bluetooth, porque sin él no se puede ni configurar el equipo

**Es lo primero por una razón práctica, no por gravedad:** mientras no haya un módulo que
empareje, no se puede programar un horario, ni leer un volcado, ni comprobar en campo ninguno
de los arreglos de abajo. Bloquea la verificación de todo.

Lo que se sabe: con **HC-06 funcionaba**; con **HC-05** y con el **SIG0109A** «no lo reconoce».
El SIG0109A no es un HC-05 — es un clon con chip **Beken BK3231S**, y el único PDF disponible
es el del SoC, que no trae ni baudios de fábrica ni comandos AT.

Y hay una creencia que hay que enterrar antes de seguir: **el `.hex` no está «compilado para
otro Bluetooth»**. El firmware ve un puerto serie transparente a 9600 8N1 y no distingue
módulos.

> ### 🚨 El paso 0.0, antes de enchufar nada: comparar la serigrafía
>
> El SIG0109A es casi con seguridad un **JDY-31 / «SPP-C»**. Su pinout está **documentado de dos
> formas contradictorias**: el manual da `STATE·RXD·TXD·GND·VCC·EN`, y una fuente con foto de la
> placa real da `STATE·TXD·RXD·`**`VCC·GND`**`·EN`, **con VCC y GND intercambiados**.
>
> Si la placa comprada es la segunda y se mete en el zócalo, **los +5 V entran por su GND y el
> módulo muere al instante**. Es la explicación más probable del *«no sabemos si esto está
> quemado»*, y significa que **cada intento de probar puede estar destruyendo el módulo que se
> prueba**.
>
> Cuesta un minuto y es gratis. Va antes que todo lo demás.

- [ ] **Comparar la serigrafía del módulo con el zócalo antes de alimentarlo.**
- [ ] Correr el procedimiento de [`Manuales/BLUETOOTH.md`](Manuales/BLUETOOTH.md), que separa las variables de lo
      más simple a lo más complejo. La prueba de bucle —puentear TX con RX del módulo solo— es
      la que decide si el módulo está bien, sin el PIC ni la app de por medio.
- [ ] **Buscar el módulo por su nombre real, no por el que uno espera.** El HC-06 se anuncia
      como `linvor`; el JDY-31 como `JDY-31-SPP`. Buscar «HC-06» y no encontrarlo **no es una
      avería**, y puede ser toda la historia del «no lo reconoce».
- [ ] **No probar comandos del HC-05 en el SIG0109A.** El JDY-31 es esclavo puro, 9 comandos
      terminados en `\r\n`, sin `AT+ROLE` ni `AT+UART`. Probar los del HC-05 y no obtener
      respuesta hace creer que un módulo sano está muerto.
- [ ] **Comprobar que el módulo que se compre no sea BLE.** `BT05`, `MLT-BT05`, `AT-09` y `HC-42`
      **no sirven**: la app abre un socket SPP/RFCOMM. `BT-05` y `BT-06` se diferencian en un
      dígito y son tecnologías distintas.
- [ ] **Encender el interruptor de Ubicación del teléfono.** Sin él Android no lista
      dispositivos, por mucho permiso que tenga la app.
- [ ] **Pedir al proveedor los comandos AT del SIG0109A.** El único PDF que publica es el
      datasheet del chip Beken, y **no contiene un solo comando AT** — verificado página a
      página. Sin eso, el módulo no se puede configurar. Las preguntas concretas están en
      [`Manuales/MANUAL_FUNCIONAL_BLUETOOTH.md`](Manuales/MANUAL_FUNCIONAL_BLUETOOTH.md).
- [ ] Dejar un módulo configurado y validado con
      [`Manuales/MANUAL_FUNCIONAL_BLUETOOTH.md`](Manuales/MANUAL_FUNCIONAL_BLUETOOTH.md).
- [ ] **Acordar la convención de nombres.** Hoy todos los módulos se llaman igual de fábrica.
      Con dos señales en la misma calle, quien va a reprogramar no puede saber a cuál se
      conecta — y una señal escolar con el horario de otra es exactamente el fallo que este
      proyecto no se puede permitir. La propuesta está en el manual, **sin acordar**.

### 0.2 · Fijar cómo se compila, y anotarlo junto al binario

Ya está resuelto lo esencial: **XC8 compila el firmware, pero solo con `--std=c99`**. En C90
falla en `DS1307.c:66`. No se toca el código: se compila en C99.

Quedan dos cabos, y los dos son baratos:

- [ ] **Crear el `nbproject/` que falta** y versionarlo. Hoy MPLAB X no puede abrir la carpeta
      como proyecto, y quien lo intente pensará que tiene el IDE roto.
- [ ] **Fijar el driver del compilador y anotarlo junto al `.hex`.** Ya está identificado el
      misterio del 65 % contra el 82 %: **no eran las banderas, era el driver**. Mismo
      compilador, mismo `--std=c99`, mismos once fuentes — `xc8.exe` da **21.309 bytes (65,0 %)**
      y `xc8-cc.exe` da **26.863 (82,0 %)**. **5.554 bytes de diferencia solo por cómo se
      invoca.** Se usa `xc8.exe`, que además es el que se acerca al tamaño de producción.
      **La versión del compilador, su driver y sus banderas son parte del entregable**: hoy solo
      se saben leyendo por casualidad un fichero de mapa.
- [ ] **Decidir si se instala XC8 v2.46.** Con v2.36 se desarrolla, pero el binario **no es
      comparable** con el que está en la calle. Para grabar en campo conviene la v2.46.

---

## Fase 1 — Lo que hace que la señal mienta

Todo lo de esta fase tiene el mismo síntoma para el conductor: **la señal dice una cosa y hace
otra**. Van en este orden porque el primero es el que más veces va a pasar.

### 1.1 · La luz no enciende si el equipo arranca dentro de una franja
`Alarma.c` · escenario **D1** · 🔴

Las alarmas se comparan por **igualdad exacta**: `rtc.hor == hourInit && rtc.min == minInit`.
Si ese minuto exacto pasa mientras el equipo está apagado, no vuelve hasta el día siguiente.

Un corte de luz de un minuto a las 06:30 deja la señal **apagada toda la mañana escolar**,
mientras la chapa atornillada anuncia 30 km/h. Y un corte de luz en un poste no es un caso
raro: es lo normal.

**Cómo se arregla:** dejar de preguntar «¿es el minuto de inicio?» y preguntar «**¿estoy dentro
de la franja?**». Se evalúa en cada vuelta contra la hora actual, y el estado de la luz pasa a
ser una consecuencia de la hora, no de haber pillado un instante.

- [ ] Reescribir la comparación como pertenencia a un intervalo.
- [ ] El escenario D1 tiene que ponerse verde **y** C y C2 seguir verdes.

### 1.2 · Dos franjas que se solapan se apagan entre ellas
`Alarma.c` · escenario **D6** · 🔴

Las cinco alarmas comparten **un solo** `ap.flagAlarm`. No hay cuenta de cuántas franjas están
abiertas: la primera que llega a su hora de fin apaga la luz, aunque otra siga dentro.

**Cómo se arregla:** cae solo con el arreglo de 1.1. Si la luz es «¿hay **alguna** franja activa
ahora?», el solape deja de ser un caso especial. Por eso 1.1 va antes: hacerlos por separado es
escribir dos veces la misma lógica.

### 1.3 — El parpadeo no es el que se definió
`Cluster.c` — escenario **C** — 🟡

**Decisión Funcional Aprobada (21-ago-2026):**

| | cadencia | ciclo | destellos/min | origen | estado |
|---|---|---|---|---|---|
| Lo que hace hoy | ráfagas de 5 × 50 ms + pausa de ~500 ms | ~1 s | ~300 en ráfagas | el código, medido | A sustituir |
| Lo que se dijo en reunión | 2 s ON / 2 s OFF | 4 s | 15 | reunión informal | Descartado (muy lento) |
| **Norma Vial Oficial (1 Hz)** | **500 ms ON / 500 ms OFF** | **1 s** | **60** | **Mintransporte / MUTCD / ITE** | **APROBADO POR EL FUNCIONAL** |

> **Decisión formal fijada por el funcional:** Se adopta el estándar de **Norma Vial Oficial (1 Hz)** con **parpadeo continuo y uniforme**: **0.5 s (500 ms) encendida / 0.5 s (500 ms) apagada** (60 destellos por minuto).
>
> A 30 km/h en zona escolar, 500 ms de apagado equivalen a solo 4.1 metros recorridos, garantizando que el conductor perciba siempre la señal activa al aproximarse al colegio.
>
> *Fuente / Alineación:* Reunión técnica *"Pulsos y frecuencia — especificaciones técnicas"* (21-ago-2026, Diego Zúñiga / Funcional) confirmando 1 Hz continuo y uniforme durante el horario programado.

- [x] **Confirmar la cadencia con el funcional:** **APROBADA (1 Hz — 500 ms ON / 500 ms OFF).**
- [x] Cambiar `Cluster.c` a la cadencia aprobada de 500 ms ON / 500 ms OFF.
- [x] **Ajustar el escenario C** en `arnes.c` para verificar 500 ms ± 10% (450 ms a 550 ms). (Verificado: 500 ms ON / 500 ms OFF, PASS).

Es la única parte del equipo que ve el conductor, y va detrás de 1.1 solo porque una luz con
mala cadencia sigue avisando, y una luz apagada no avisa de nada.

---

## Fase 2 — Lo que rompe el equipo desde fuera

### 2.1 · Una trama malformada tumba el firmware
`Serial.c:449` · escenario **D5** · 🔴

`extraerValue()` llama a `strstr()` y **no comprueba si devolvió NULL**, y después copia en un
`char buffer[4]` hasta encontrar el carácter final, **sin límite**. Una trama a la que le falte
una coma recorre memoria hasta dar con un byte que coincida por casualidad.

En el simulador **el proceso se cae de verdad** — por eso ese escenario se corre en un proceso
aparte. En el PIC no hay proceso que caiga: hay un equipo que se queda en un estado que nadie
ha previsto, en un poste, hasta que alguien pase por delante y lo note.

No hace falta mala fe: basta con que el Bluetooth pierda unos bytes a mitad de trama.

- [ ] Comprobar el `NULL` de `strstr()` en `extraerValue()` y en `extraerFrame()`.
- [ ] Acotar la copia al tamaño del destino.
- [ ] Rechazar la trama entera si no está completa, en vez de interpretar lo que haya.

### 2.2 · Los días concretos: se tragan la orden, y cuelgan la tarea
`Serial.c` y `Alarma.c` · escenarios **D2** y **D3** · 🔴

Dos defectos encadenados en la misma función que no existe:

- **`Serial.c`**: una alarma pedida para un día concreto (1..7) cae en un `else` **vacío**. No se
  graba nada y no se avisa. La app dice «Mensaje Enviado!!» y la alarma no existe.
- **`Alarma.c`**: si el indicador de «día personalizado» llega a valer 1, la tarea de alarma se
  queda **clavada en `ST_CHECK_ALARM1` para siempre**. Medido. No falla una alarma: deja de
  mirar el reloj y se lleva por delante las otras cuatro.

Hoy la app no puede mandar días concretos, así que el camino está cerrado por casualidad —
pero un byte de EEPROM a medias, o un terminal serie cualquiera, lo abre.

- [ ] **Decidir primero si la función se quiere o no.** Las dos salidas son legítimas: se
      implementa, o se rechaza la trama explícitamente. Lo que no puede quedarse es la rama
      vacía, que es la única opción que cuelga el equipo.
- [ ] Sea cual sea la decisión, cerrar la rama sin salida de `Alarma.c`.

---

## Fase 3 — Reconciliar el firmware con la tarjeta

La tarjeta es fija. Estos dos se arreglan **en el firmware**.

### 3.1 · El buzzer está en el pin equivocado
`Buzzer.h:24` · 🟡

La placa tiene el buzzer en **RC1**. El firmware escribe en **RC0**, que en la tarjeta es la
línea del pulsador con su resistencia de subida. En `Buzzer.c:162` está la línea correcta
**comentada**: alguien lo supo y se deshizo.

- [ ] Pasar el buzzer a RC1.
- [ ] Escribir en el simulador un escenario que fije el pin, para que no vuelva a moverse.
- [ ] Comprobar qué pasa con RC0 y el pulsador: si el firmware lo estaba forzando como salida,
      hay que ver qué le hacía a esa entrada.

### 3.2 · La temperatura leída no es la temperatura
`main.c` y `Aplicacion.c` · 🟡

Dos fallos a la vez: el sensor entra por **AN3**, y `PCFG = 0b1011` solo habilita AN0–AN2; y la
fórmula aplica un factor **10** donde el sensor pide **100**.

Es el de menor urgencia de la lista —la temperatura no enciende ninguna luz— pero está en la
lista porque **hoy el equipo publica un número que parece una medida y no lo es**, y alguien
acabará tomando una decisión con él.

- [ ] Habilitar AN3 en `PCFG`.
- [ ] Corregir el factor de la fórmula.
- [ ] Verificar contra un termómetro de verdad, en banco. **Esto el simulador no lo puede
      medir.**

La medida de **tensión sí es correcta** y no se toca: el divisor da factor 6 y el firmware
aplica 6.

---

## Fase 4 — La app

Detalle completo y los 20 defectos en [`Manuales/APP_MOVIL.md`](Manuales/APP_MOVIL.md). Lo que sube al roadmap:

- [ ] **Falta la hora «02»** en las listas de inicio y de fin. No se puede programar nada entre
      las 2 y las 3 de la madrugada. Una entrada que falta en un array.
- [ ] **La comparación de textos con `==`.** Hoy funciona por casualidad. El día que alguien
      mueva las etiquetas a `strings.xml` o las traduzca, **todas** las alarmas caerán a «fin de
      semana» y las señales escolares dejarán de titilar de lunes a viernes. Es el defecto con
      peor relación entre lo trivial del arreglo y lo grave de la consecuencia.
- [ ] **Los bytes NUL de la trama**, y —más importante— **comentar el filtro de `Serial.c` que
      los tapa**. Hoy no tiene ni una línea de explicación: quien lo sustituya por un `memcpy`
      corrompe la fecha de todas las balizas.
- [ ] **Acuse de recibo.** La app dice «Mensaje Enviado!!» sin leer un byte. Mientras no lo
      tenga, el procedimiento de campo **obliga** a pedir el volcado con `¿L?` y comparar contra
      la chapa.
- [ ] **Permisos de Android.** `targetSdkVersion 30` y solo `BLUETOOTH`/`BLUETOOTH_ADMIN`.
      Comprobar en qué versión deja de funcionar.
- [ ] **El acceso con usuario y contraseña fijos en el código.** Decidir si se quita o se hace
      de verdad; lo que hay ahora no protege nada y da a entender que sí.

---

## Fase 5 — Deuda que hará baratos los arreglos siguientes

No urge. Pero cada uno de estos multiplica el coste de todo lo de arriba.

- [ ] **Las cinco alarmas están copiadas y pegadas cinco veces** en `Serial.c`, `Alarma.c` y
      `Aplicacion.c`. Cualquier arreglo hay que hacerlo cinco veces, y es fácil dejarse una —
      que además no se nota. Pasar a un array `srtAlarmas ala[5]` es la refactorización que
      abarata todas las demás. **Hacerla después de la fase 1**, no antes: primero se arregla
      con los escenarios en rojo vigilando, y luego se reordena con ellos en verde.
- [ ] **`Cluster.h` no tiene guarda de inclusión.** Por eso el simulador no puede compilar en
      unidad única. Tres líneas.
- [ ] **Variables globales definidas dos veces sin `extern`** (`strAplicacion ap` en
      `Aplicacion.c` y `LedLive.c`; `srtAlarmas ala1..5` en `Serial.c` y `Alarma.c`). Funciona
      porque XC8 las fusiona. Un compilador más nuevo lo rechaza.
- [ ] **`transmitUart1` manda un byte 0x00 de más** al final de cada línea (`Serial.c:59`, un
      `<=` donde va un `<`). Escenario D4.
- [ ] **`__delay_ms(4000)` dentro de una interrupción**, con dos `printf` al lado, en `main.c`.
      Cuatro segundos con el equipo parado.
- [ ] **`EEpromWrite` reactiva las interrupciones incondicionalmente** al terminar, incluso si
      estaban desactivadas al entrar.

---

## Lo que no se puede cerrar desde el escritorio

Por mucho que el simulador se ponga en verde, esto solo lo cierra alguien con el equipo
delante:

- [ ] **Prueba de banco de cada salida contra su carga.** Ningún pin se ha comprobado nunca.
- [ ] **Que el DS1307 conserve la hora sin alimentación.** Una pila agotada convierte todos los
      horarios en ruido, y el síntoma es idéntico al de un firmware mal programado.
- [ ] **Que el horario grabado en cada señal coincida con SU chapa atornillada.** No contra el
      horario que alguien recuerde, ni contra el ejemplo de un manual. Hoy no hay registro de
      qué señal lleva qué horario.

**Verde en el simulador no es entregable, y ni siquiera autoriza a grabar.** Lo que corresponde
mandar hoy es un encargo de medida, no una versión — ver la skill
[`entregar`](.claude/skills/entregar/SKILL.md).
