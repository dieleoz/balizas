# Manuales y documentación técnica — Baliza

Todo lo que se consulta o se sigue con el equipo delante. Lo de gobierno del proyecto
—[`README`](../README.md), [`ROADMAP`](../ROADMAP.md), [`ESTADO`](../ESTADO.md)— vive en la raíz.

Cada documento está en **`.md`** y en **`.docx`**. El `.md` es la **fuente única**; el Word se
genera. Ver «Cómo se regeneran» al final.

## Los documentos

| documento | quién lo lee | para qué |
|---|---|---|
| [`MANUAL_FUNCIONAL_BLUETOOTH.md`](MANUAL_FUNCIONAL_BLUETOOTH.md) | **el funcional** | Configurar y validar cada módulo Bluetooth: nombre, PIN, 9600 8N1, y 9 pasos de validación con casilla. Hoja de registro imprimible |
| [`BLUETOOTH.md`](BLUETOOTH.md) | quien esté peleando con el enlace | Por qué no funciona el módulo nuevo, y el procedimiento que separa las variables de lo simple a lo complejo |
| [`COMPILAR_Y_GRABAR.md`](COMPILAR_Y_GRABAR.md) | quien modifique el firmware | MPLAB X, XC8, cómo compilar y cómo grabar el PIC |
| [`FIRMWARE.md`](FIRMWARE.md) | quien mantenga el firmware | El firmware módulo a módulo, con las máquinas de estado y **45 defectos** con su `fichero:línea` |
| [`HARDWARE.md`](HARDWARE.md) | quien fabrique o modifique la tarjeta | Componentes, netlist y el mapeo real de pines contra el firmware |
| [`APP_MOVIL.md`](APP_MOVIL.md) | quien toque la app o el protocolo | La app Android y el contrato de tramas, byte a byte |

## Antes de mandar cualquiera de estos a alguien

Lee la skill [`entregar`](../.claude/skills/entregar/SKILL.md). En resumen:

- **Hoy corresponde un encargo de medida, no una entrega de versión.** Ningún pin se ha
  comprobado contra su carga.
- **Ningún horario se cita de memoria.** Se copia de la placa atornillada a esa señal concreta.
  Si un manual pone un horario de ejemplo, alguien acabará tecleándolo.
- **Un documento no abre con la cifra en verde.** Primero qué hace hoy el equipo instalado y qué
  está roto; las novedades después.

## Cómo se regeneran los Word

```bash
cd Manuales
python generar_word.py              # regenera todos
python generar_word.py FICHERO.md   # solo uno
python generar_word.py --revisar    # avisa de los .docx más viejos que su .md
```

> **La regla, y no es una formalidad:** si se edita el `.md`, se regenera el `.docx` **en el
> mismo cambio**. Al que va al campo le llega el Word, no el fuente — si nadie regenera, la
> corrección **no existe** para quien la necesita. En otro proyecto de la casa hubo dos manuales
> **85 horas** desfasados, y unas definiciones nuevas nunca llegaron al documento de campo.
>
> Y el `.docx` **no se edita a mano**: quedarían dos copias divergiendo sin que nadie lo note
> hasta que alguien las compare.

`python generar_word.py --revisar` devuelve código de salida **1** si hay alguno desfasado. Es
lo que hay que correr antes de mandar un paquete a nadie.

## Por qué los `.docx` sí se versionan

Son binarios, y el criterio general del repositorio es no versionar binarios. Estos son la
excepción, a propósito: son **lo que se le entrega a una persona**, y tener en el repositorio
exactamente el fichero que se mandó es lo único que permite, meses después, saber qué leyó quien
lo recibió. Ocupan unos 350 KB entre los seis.
