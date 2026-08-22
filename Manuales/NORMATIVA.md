# Base normativa — señal de 30 km/h con horario en zona escolar

**Origen de este documento:** aportado por el responsable del proyecto el **22-ago-2026**, a
partir del **Manual de Señalización Vial de Colombia** (actualización de 2024) y la **Ley 1239
de 2008**.

> ### ⚠️ El Manual no está en este repositorio
>
> Lo que sigue es el resumen que se recibió, y sirve para orientar el diseño y para saber qué
> preguntar. **No sustituye al Manual.** Antes de que una cláusula concreta gobierne un
> entregable —un horario, una cadencia, un texto de placa— se contrasta con el documento
> oficial. Este proyecto ya tuvo un requisito de cadencia mal entendido por citarlo de memoria.

---

## 1. Qué dice la norma, y qué implica para este equipo

| Punto normativo | Consecuencia para la baliza |
|---|---|
| El límite en zona escolar y residencial es **30 km/h** | Es el número de la señal. No se discute aquí. |
| El límite reducido **es temporal**: rige en entrada y salida de escolares, no 24 h | Es exactamente la razón de existir de este equipo. Fuera de la franja rige el límite general del tramo. |
| La señal se compone de **SR-30 + placa complementaria** con días y franjas | **La placa es la fuente de verdad del horario**, no el equipo. Ver regla 0 de `CLAUDE.md`. |
| Las **balizas destellantes ámbar** se activan solo en horas pico escolar | Es lo que hace `LATC2`. La luz encendida = restricción vigente. |
| Señalización preventiva previa (familia SP) y demarcación en pavimento | Fuera del alcance de este equipo, pero condiciona dónde se instala. |

## 2. La cláusula que gobierna dos defectos abiertos

> **Evitar la sobrerregulación.** Los horarios programados deben ajustarse **estrictamente a la
> realidad operativa del centro educativo**. Horarios sobredimensionados o desactualizados
> generan **acostumbramiento en los conductores**, restando autoridad y efectividad a la señal.

Esto no es una recomendación de estilo: convierte dos cosas que estaban anotadas como defectos
técnicos en **incumplimientos normativos**.

### 2.1. El botón «1-Toque» (ROADMAP, pendiente 3)

Graba tres franjas fijas en el código —las de una instalación concreta— y apaga la cuarta. En
cualquier otro colegio eso es **exactamente** un horario sobredimensionado o desajustado:
la señal titila cuando no hay exposición al riesgo, y deja de titilar cuando sí la hay.

### 2.2. Festivos y receso escolar

Ampliado con lo aportado el 22-ago-2026. La restricción rige **exclusivamente en días hábiles
lectivos**: en festivos, domingos y vacaciones **no hay exposición al riesgo**, que es lo único
que justifica bajar a 30 km/h.

**Y la consecuencia jurídica es la que resuelve el asunto:** si un lunes es festivo y la placa
dice «LUNES A VIERNES», la restricción **no tiene validez jurídica ni operativa ese día**. El
conductor puede ir al límite general del corredor. La exclusión es **automática por la propia
leyenda de la placa** — no la tiene que ejecutar el equipo.

> #### Por qué esto valida la decisión de no llevar calendario
>
> **El instrumento legal es la señal: SR-30 más su placa.** La baliza es un *aviso*, no la
> norma. Una baliza titilando un festivo **no puede hacer exigible** una restricción que ese día
> no existe: la placa ya la excluyó. Es decir, el equipo **no puede crear una infracción
> injusta** por no saber los festivos.
>
> Lo que queda es un coste de **credibilidad**: la señal avisa de algo que no rige, y eso es el
> acostumbramiento del conductor contra el que avisa el Manual. Real, pero no es exposición
> legal, y se paga unas 18 veces al año.
>
> ⚠️ **Esto se cae si alguna fotomulta o SAST se dispara con el estado de la baliza** en vez de
> con la placa. Entonces sí habría multas injustificadas y el análisis cambia entero. **Es una
> pregunta abierta y hay que hacerla** antes de instalar en un corredor con detección
> automática.

#### El receso escolar sí se puede resolver, y sin calendario

Las vacaciones no son un día suelto: son **semanas seguidas** de señal anunciando lo que no
rige — mucho más acostumbramiento que los festivos. Pero a diferencia de los festivos, las
fechas de receso **se saben, son estables por colegio, y el técnico pasa por la señal**.

Basta con **apagar las franjas antes del receso y reprogramarlas a la vuelta**. Medido el
22-ago-2026 (arnés, bloque `M`): con las franjas apagadas la luz no se enciende a ninguna hora,
y reprogramar devuelve la señal a servicio. **Funciona con el firmware de hoy, sin un cambio.**

Lo único que falta es del lado de la app: hoy hay que apagar las alarmas **una por una** desde
la configuración manual. Un botón de «receso» que mande las cuatro o cinco tramas de golpe
—y otro para restaurar— haría el procedimiento fiable en campo. Ver `ROADMAP.md`.

## 3. Preguntas abiertas para el funcional

1. **¿Qué dice literalmente la placa de cada instalación**: «lunes a viernes», «días hábiles», u
   otra cosa? Ya no cambia el diseño —los festivos están descartados—, pero sí condiciona el
   texto de los manuales de campo.
2. **¿Cuántas franjas** lleva cada colegio del corredor? Confirmado que pueden ser hasta cuatro.
3. **¿Alguna fotomulta o SAST del corredor se dispara con el estado de la baliza**, o solo con
   la placa? De esto depende que un festivo con la luz encendida sea un coste de credibilidad
   o una multa injusta. Es la pregunta más importante de esta lista.
4. **¿Quién apaga la señal en el receso escolar** y con qué procedimiento? El equipo ya lo
   permite; falta decidir de quién es la tarea y dejarlo en el manual de campo.
5. **¿La cadencia de 1,0 Hz** (500 ms ON / 500 ms OFF) está escrita en el Manual, o vino de otro
   sitio? Hoy se aplica esa por una decisión de reunión.

---

## Referencias

* Reglas del proyecto y por qué manda la placa: [`../CLAUDE.md`](../CLAUDE.md)
* Pendientes que salen de aquí: [`../ROADMAP.md`](../ROADMAP.md)
