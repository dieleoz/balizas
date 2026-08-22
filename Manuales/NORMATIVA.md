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

### 2.2. «Días hábiles» y los festivos — planteado y DESCARTADO

La placa puede decir «días hábiles», y el equipo solo sabe **8** diario, **9** lunes a viernes
y **10** fin de semana: no tiene calendario de festivos. Con el código 9, en los ~18 festivos
del año la señal titilaría con el colegio cerrado.

**Decisión del responsable, 22-ago-2026: no aplica.** No hay forma razonable de saber los
festivos desde el equipo, y meter un calendario nacional en el PIC obliga a **mantenimiento
anual en cada señal montada** — un problema peor que el que resuelve, y que falla en silencio
en cuanto nadie lo actualiza. Ver `ROADMAP.md`, «Decisiones tomadas».

## 3. Preguntas abiertas para el funcional

1. **¿Qué dice literalmente la placa de cada instalación**: «lunes a viernes», «días hábiles», u
   otra cosa? Ya no cambia el diseño —los festivos están descartados—, pero sí condiciona el
   texto de los manuales de campo.
2. **¿Cuántas franjas** lleva cada colegio del corredor? Confirmado que pueden ser hasta cuatro.
3. **¿Qué hace la señal en vacaciones escolares?** El equipo no distingue periodo lectivo de
   vacaciones, y son varias semanas seguidas de señal anunciando lo que no rige.
4. **¿La cadencia de 1,0 Hz** (500 ms ON / 500 ms OFF) está escrita en el Manual, o vino de otro
   sitio? Hoy se aplica esa por una decisión de reunión.

---

## Referencias

* Reglas del proyecto y por qué manda la placa: [`../CLAUDE.md`](../CLAUDE.md)
* Pendientes que salen de aquí: [`../ROADMAP.md`](../ROADMAP.md)
