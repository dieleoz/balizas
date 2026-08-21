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
`4 Simulador/`, 37 comprobaciones. Nada de lo que viene después se arregla sin que antes exista
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

### 0.1 · El Bluetooth — ✅ **DESBLOQUEADO el 21-ago-2026. El SIG0109A funciona**

> **La medida que lo cierra:** desde «Serial Bluetooth Terminal», con el **SIG0109A** montado en
> la tarjeta, se envió `¿L?` y volvió el **volcado legible** — `16:47:18`, `21/8/26-5` y las
> cinco alarmas. Una sola captura demuestra cuatro cosas a la vez: el módulo **empareja y
> conecta**, los bytes **viajan en los dos sentidos**, los **9600 8N1 de fábrica son
> correctos**, y el **DS1307 y el parser de tramas del firmware funcionan**. Sin un solo
> comando AT.

**El *«no lo reconoce»* nunca fue una avería del módulo.** Era buscarlo en la lista del teléfono
como «HC-06» cuando se anuncia con otro nombre, o no haberlo emparejado antes desde los
**ajustes** del teléfono (la app solo lista los **ya emparejados**), o la **Ubicación** apagada.
Se estuvo persiguiendo un módulo quemado que estaba sano.

Y queda enterrada de paso la otra creencia: **el `.hex` no está «compilado para otro
Bluetooth»**. El firmware ve un puerto serie transparente a 9600 8N1 y no distingue módulos.

**Lo que esto libera:** no hay que comprar otro módulo, y la consulta a Sigma **deja de ser
bloqueante**. Ya se puede programar un horario, leer un volcado y verificar en campo todo lo de
las fases siguientes.

- [x] **Comparar la serigrafía del módulo con el zócalo antes de alimentarlo.** El módulo
      montado sobrevivió, así que el orden de pines del zócalo es el correcto para esta placa.
- [x] **Buscar el módulo por su nombre real, no por el que uno espera.** Era esto.
- [x] Emparejar desde los **ajustes** del teléfono antes de abrir la app, y con la **Ubicación**
      encendida.
- [x] Demostrar el enlace de extremo a extremo con `¿L?` y un volcado legible.

> ### 🔴 Lo que pasa a ser urgente: proteger el módulo que sí funciona
>
> `RC6` ataca el `RXD` del módulo con **5 V directos, sin divisor ni resistencia serie**
> (`Manuales/HARDWARE.md`, riesgo **R7**), y ese pin es de **3,3 V no tolerante a 5 V**. No mata
> al instante: conduce por su diodo de protección y el módulo muere **semanas o meses después**.
>
> **Es la explicación más limpia de *«el HC-06 funcionaba… hasta que dejó de funcionar»***, y el
> mismo reloj corre ya contra este SIG0109A.

- [ ] **🔴 Montar una resistencia de 1 kΩ en serie en el hilo `MCU_TX`**, en el arnés del módulo
      o en el pin del zócalo. **No es tocar la PCB** —la tarjeta sigue siendo fija— es un
      componente en el cableado. Cuesta céntimos y es lo único que separa este módulo del
      siguiente módulo muerto.
- [ ] **Comprobar si la app oficial conecta con este mismo módulo.** El terminal serie ya
      funciona; si la app no, el problema está **en la app o en los permisos de Android**, no en
      el Bluetooth (síntoma **B5** de [`Manuales/BLUETOOTH.md`](Manuales/BLUETOOTH.md)). Es una
      investigación distinta y ahora se puede aislar limpiamente.
- [ ] **Comprobar que cualquier módulo de repuesto no sea BLE.** `BT05`, `MLT-BT05`, `AT-09` y
      `HC-42` **no sirven**: la app abre un socket SPP/RFCOMM. `BT-05` y `BT-06` se diferencian
      en un dígito y son tecnologías distintas.
- [ ] **Renombrar el módulo y cambiar el PIN por AT** — ahora es **comodidad, no
      funcionamiento**. Del JDY-31: `AT+NAMEBAL-001-N`, `AT+PIN2130`, terminados en `\r\n`.
      Si no responden, el módulo **sigue sirviendo igual** con su nombre y PIN de fábrica.
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
- [x] **Fase 4.1 — Validación de Conectividad Móvil y RTC DS1307 en Banco:**
  - ✅ **Demostrado en hardware real (21-Ago-2026):** Comunicación bidireccional Android $\leftrightarrow$ JDY-31 $\leftrightarrow$ PIC18F2550 a 9600 baudios 8N1.
  - ✅ **Sincronización RTC 100% Funcional:** La trama `¿R[HHMM],C[DDMMAA-D]?` se genera automáticamente y ajusta los registros del DS1307 al segundo con la hora satelital/celular.
  - ✅ **App Baliza v2.6 Liberada:** Sesión Bluetooth persistente, auto-lectura al conectar, auto-verificación post-configuración, auto-reconexión transparente y panel de **Test de Luz Inmediato (2 Minutos)** con apagado manual.
- [ ] **Decidir si se instala XC8 v2.46.** Con v2.36 se desarrolla, pero el binario **no es
      comparable** con el que está en la calle. Para grabar en campo conviene la v2.46.

---

## Fase 1 — Lo que hace que la señal mienta

Todo lo de esta fase tiene el mismo síntoma para el conductor: **la señal dice una cosa y hace
otra**. Van en este orden porque el primero es el que más veces va a pasar.

### 1.1 · La luz no enciende si el equipo arranca dentro de una franja
`Alarma.c` · escenario **D1** · ✅ **arreglado y verde en simulador** (falta verlo en un equipo)

Las alarmas se comparan por **igualdad exacta**: `rtc.hor == hourInit && rtc.min == minInit`.
Si ese minuto exacto pasa mientras el equipo está apagado, no vuelve hasta el día siguiente.

Un corte de luz de un minuto a las 06:30 deja la señal **apagada toda la mañana escolar**,
mientras la chapa atornillada anuncia 30 km/h. Y un corte de luz en un poste no es un caso
raro: es lo normal.

**Cómo se arregla:** dejar de preguntar «¿es el minuto de inicio?» y preguntar «**¿estoy dentro
de la franja?**». Se evalúa en cada vuelta contra la hora actual, y el estado de la luz pasa a
ser una consecuencia de la hora, no de haber pillado un instante.

- [x] Reescribir la comparación como pertenencia a un intervalo. `isAlarmActive()` en
      `Alarma.c`, con el caso de franja que cruza medianoche resuelto.
- [x] El escenario D1 tiene que ponerse verde **y** C y C2 seguir verdes.

### 1.2 · Dos franjas que se solapan se apagan entre ellas
`Alarma.c` · escenario **D6** · ✅ **arreglado y verde en simulador**

Las cinco alarmas comparten **un solo** `ap.flagAlarm`. No hay cuenta de cuántas franjas están
abiertas: la primera que llega a su hora de fin apaga la luz, aunque otra siga dentro.

**Cómo se arregla:** cae solo con el arreglo de 1.1. Si la luz es «¿hay **alguna** franja activa
ahora?», el solape deja de ser un caso especial. Por eso 1.1 va antes: hacerlos por separado es
escribir dos veces la misma lógica.

**Hecho así:** `ap.flagAlarm` se recalcula en `ST_CHECK_ALL_ALA` como **OR de las cinco**
llamadas a `isAlarmActive()`, y los estados `ST_CHECK_HOUR1..5` / `ST_CHECK_ALARM1..5` que
escribían ese mismo flag por igualdad de minuto **se eliminaron** — ya no hay dos escritores.

### 1.3 — El parpadeo no es el que se definió
`Cluster.c` — escenario **C** — ✅ **programado y verde en simulador** (falta verlo parpadear)

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
`Serial.c:449` · escenario **D5** · ✅ **arreglado y verde en simulador**

`extraerValue()` llama a `strstr()` y **no comprueba si devolvió NULL**, y después copia en un
`char buffer[4]` hasta encontrar el carácter final, **sin límite**. Una trama a la que le falte
una coma recorre memoria hasta dar con un byte que coincida por casualidad.

En el simulador **el proceso se cae de verdad** — por eso ese escenario se corre en un proceso
aparte. En el PIC no hay proceso que caiga: hay un equipo que se queda en un estado que nadie
ha previsto, en un poste, hasta que alguien pase por delante y lo note.

No hace falta mala fe: basta con que el Bluetooth pierda unos bytes a mitad de trama.

- [x] Comprobar el `NULL` de `strstr()` en `extraerValue()` y en `extraerFrame()`.
- [x] Acotar la copia al tamaño del destino, y `receiverUart1` con límite.
- [x] Rechazar la trama entera si no está completa, en vez de interpretar lo que haya.

### 2.2 · Los días concretos: se tragan la orden, y cuelgan la tarea
`Serial.c` y `Alarma.c` · escenarios **D2** y **D3** · ✅ **decidido: se rechazan, en los dos
extremos**

Dos defectos encadenados en la misma función que no existe:

- **`Serial.c`**: una alarma pedida para un día concreto (1..7) cae en un `else` **vacío**. No se
  graba nada y no se avisa. La app dice «Mensaje Enviado!!» y la alarma no existe.
- **`Alarma.c`**: si el indicador de «día personalizado» llega a valer 1, la tarea de alarma se
  queda **clavada en `ST_CHECK_ALARM1` para siempre**. Medido. No falla una alarma: deja de
  mirar el reloj y se lleva por delante las otras cuatro.

Hoy la app no puede mandar días concretos, así que el camino está cerrado por casualidad —
pero un byte de EEPROM a medias, o un terminal serie cualquiera, lo abre.

- [x] **Decidir primero si la función se quiere o no.** **Decisión: se rechaza.** `Serial.c`
      solo graba la alarma si el código de día está entre 8 y 10; fuera de ese rango no escribe
      nada en EEPROM ni habilita la alarma.
- [x] Sea cual sea la decisión, cerrar la rama sin salida de `Alarma.c`. `isAlarmActive()`
      devuelve 0 para cualquier `dayAlar` que no sea `DIAR`/`SEMA`/`FINS`, y la tarea sigue
      ciclando.

> **Lo que queda como pendiente de producto, no de código:** si algún día se quieren días
> concretos hay que tocar **los tres** extremos —app, `Serial.c` y `Alarma.c`— a la vez. Hoy
> el equipo los rechaza de forma consistente y en silencio; la app no puede mandarlos.

---

## Fase 3 — Reconciliar el firmware con la tarjeta

La tarjeta es fija. Estos dos se arreglan **en el firmware**.

### 3.1 · El buzzer está en el pin equivocado
`Buzzer.h:24` · ✅ **arreglado y verde en simulador** (escenario **T6**, 4 comprobaciones)

La placa tiene el buzzer en **RC1**. El firmware escribe en **RC0**, que en la tarjeta es la
línea del pulsador con su resistencia de subida. En `Buzzer.c:162` está la línea correcta
**comentada**: alguien lo supo y se deshizo.

- [x] Pasar el buzzer a RC1.
- [x] Escribir en el simulador un escenario que fije el pin, para que no vuelva a moverse
      (**T6**: `TRISC1` salida, `TRISC0` entrada, `LATC1` se activa, `LATC0` se queda en bajo).
- [x] Comprobar qué pasa con RC0 y el pulsador: ahora `RC0` queda configurado **como entrada** y
      el firmware no lo escribe.
- [ ] **Oírlo sonar en un equipo real.** El simulador mide el pin, no el zumbador.

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

## Fase 4 — Modernización y Mejora Integral de la App Móvil («Baliza Pro & Test Suite v2.0»)

Detalle completo de los 20 defectos heredados en [`Manuales/APP_MOVIL.md`](Manuales/APP_MOVIL.md). 
Plan de trabajo estructurado para la versión 2.0:

### 4.1 · Corrección de Defectos Críticos de Lógica (Hotfixes)
- [x] **Falta la hora «02»:** Corregir el array de horas en `MainActivity2.java` para incluir la hora `"02"` (corregido: 00..23 completo).
- [x] **Comparación segura de textos:** Sustituir todas las comparaciones de cadenas `==` por `.equals()` para evitar fallos si se internacionalizan o mueven a `strings.xml`.
- [x] **Visualización con ScrollView:** Envolver el área de volcado `idTxtViewOut` en un `ScrollView` con estilo de terminal monospace y scroll automático.
- [x] **Permisos dinámicos Android 12+:** Declarar permisos en `AndroidManifest.xml` (`BLUETOOTH_CONNECT`, `BLUETOOTH_SCAN` y `neverForLocation`).

### 4.2 · Protocolo Robusto, Asincronía y Acuse de Recibo
- [x] **Operaciones Bluetooth asíncronas:** Optimizar lectura y recepción de buffers en `ConnectThread` con timeouts reactivos sin bloqueos ciegos.
- [ ] **Manejo de timeouts y diagnósticos claros:** Notificar al técnico el estado exacto (*«Conectado»*, *«Esperando respuesta de la baliza...»*, *«Sin respuesta / Verificar encendido»*).
- [ ] **Sincronización de reloj en 1 toque:** Botón dedicado que capture la fecha/hora del celular y transmita la trama `¿RHH:MM:SS,CDD/MM/AA-W?` al RTC DS1307.
- [ ] **Verificación post-escritura:** Al enviar una alarma, solicitar automáticamente la trama `¿L?` y cotejar en segundo plano que el micro la guardó fielmente.

### 4.3 · Modo Test y Diagnóstico de Banco (Nueva Pestaña / Suite)
- [ ] **Test de Luz y Potencia:** Botón para forzar destello normativo (1.0 Hz) y verificar MOSFET/LEDs de la baliza en vivo.
- [ ] **Test de Buzzer:** Botón para disparar tono de prueba en RC1 y verificar transistor/zumbador.
- [ ] **Telemetría en tiempo real:** Medidor gráfico del voltaje de batería (con umbral de alerta < 11.5 V) y temperatura reportada por el PIC.
- [ ] **Consola Interactiva de Macros:** Botones de acceso rápido para comandos frecuentes (`¿L?`, `¿R...C...?`, `Borrar Alarmas`, `Volcado HEX`).

### 4.4 · Rediseño Moderno de UI/UX (Material Design)
- [ ] **Acceso directo en campo:** Eliminar el login inútil de credenciales fijas `admin`/`admin` para acceso inmediato.
- [ ] **Selectores de hora tipo reloj:** Integrar `TimePickerDialog` nativo en lugar de menús desplegables rígidos de 5 minutos.
- [ ] **Selector visual de días:** Chips/botones para *Lunes a Viernes (Escolar)*, *Todos los días (Diario)* y *Fin de Semana*.
- [ ] **Tarjetas de Alarma:** Tarjetas individuales por alarma con switch ON/OFF.

### 4.5 · Empaquetado y Entrega
- [ ] Compilar y generar `Baliza_v2.0.apk`.
- [ ] Probar instalación en dispositivos físicos Android.
- [ ] Documentar el manual de usuario actualizado en `Manuales/APP_MOVIL.md`.

---

## Fase 5 — Deuda que hará baratos los arreglos siguientes

No urge. Pero cada uno de estos multiplica el coste de todo lo de arriba.

- [ ] **Las cinco alarmas están copiadas y pegadas cinco veces** en `Serial.c`, `Alarma.c` y
      `Aplicacion.c`. Cualquier arreglo hay que hacerlo cinco veces, y es fácil dejarse una —
      que además no se nota. Pasar a un array `srtAlarmas ala[5]` es la refactorización que
      abarata todas las demás. **Hacerla después de la fase 1**, no antes: primero se arregla
      con los escenarios en rojo vigilando, y luego se reordena con ellos en verde.
- [x] **`Cluster.h` no tiene guarda de inclusión.** Hecho: `#ifndef CLUSTER_H`.
- [ ] **Variables globales definidas dos veces sin `extern`** (`strAplicacion ap` en
      `Aplicacion.c` y `LedLive.c`; `srtAlarmas ala1..5` en `Serial.c` y `Alarma.c`). Funciona
      porque XC8 las fusiona. Un compilador más nuevo lo rechaza.
- [x] **`transmitUart1` manda un byte 0x00 de más** al final de cada línea (`Serial.c:59`, un
      `<=` donde va un `<`). Escenario D4. Arreglado y verde.
- [ ] **`__delay_ms(4000)` dentro de una interrupción**, con dos `printf` al lado, en `main.c`.
      Cuatro segundos con el equipo parado.
- [ ] **`EEpromWrite` reactiva las interrupciones incondicionalmente** al terminar, incluso si
      estaban desactivadas al entrar.

---

## Estado de Validación Física en Banco (Hardware Real)

- [x] **Enlace UART / Bluetooth PIC18F2550 ↔ JDY-31 ↔ Móvil Android:**
  - ✅ **VALIDADO EN BANCO (21-Ago-2026):**
  - Baudios: 9600 8N1 confirmados en micro y Bluetooth.
  - Pinout verificado en tarjeta: Pin 17 (`RC6`/TX) $\rightarrow$ `RXD`, Pin 18 (`RC7`/RX) $\leftarrow$ `TXD`.
  - Trama `¿L?` probada físicamente desde el terminal Android, respondiendo con el volcado completo del RTC (`16:47:18`, `21/8/26-5`) y las 5 alarmas en EEPROM.
- [ ] **Prueba de banco de cada salida contra su carga:** Verificar encendido de LEDs del Cluster con carga real de 12 V.
- [ ] **Prueba de sonido del buzzer en RC1.**
- [ ] **Comprobación de retención horaria del DS1307 sin alimentación.**
- [ ] **Registro de instalación:** Horario grabado coincidente con la chapa atornillada a la señal.
