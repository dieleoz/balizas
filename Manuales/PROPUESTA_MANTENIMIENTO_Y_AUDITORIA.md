# Propuesta: inspección a nivel de suelo o en altura, y auditoría de lo hecho

**Para revisión funcional. 22-ago-2026.**

Este documento no propone una mejora estética. Propone arreglar tres cosas que hoy hacen que
**una inspección no deje constancia de nada**, y una de ellas puede hacer que la constancia sea
directamente falsa.

---

## 1. Qué hay hoy, medido

Antes de proponer, lo que existe de verdad. Comprobado leyendo el código de la app, no el
emulador ni la documentación.

| Función | En la app | Estado |
|---|---|---|
| Telemetría de batería 12 V | ✅ | **Funciona.** Canal `AN1`, factor 6 correcto |
| Contador de cortes de energía | ✅ | Funciona, persiste en EEPROM |
| Diagnóstico de pila RTC `CR2032` | ✅ | Funciona, por desfase horario |
| Nombre / ubicación por el aire | ✅ | Funciona, y se guarda por MAC en el teléfono |
| Horario de la placa, 4 franjas | ✅ | Nuevo, con confirmación previa |
| Receso escolar | ✅ | Nuevo |
| Prueba de foco de 2 minutos | ✅ | Funciona |
| Exportar el acta | ✅ | Menú de compartir de Android — WhatsApp, correo, Drive |
| **Checklist de mantenimiento** | ⚠️ | **Decorativo** — ver 1.1 |
| **Selector suelo / altura** | ❌ | **No existe en la app** — ver 1.2 |
| **Historial de inspecciones** | ❌ | **No se guarda nada** — ver 1.3 |

### 1.1 El checklist no está conectado

Las cuatro casillas existen en la pantalla (`idChkPanelSolar`, `idChkPilaRTC`, `idChkBorneras`,
`idChkTestLuz`) pero **ninguna está enlazada al código**: cero llamadas a `findViewById` sobre
ellas, y no aparecen en el acta que se exporta.

El técnico las marca, ve que quedan marcadas, y **no llegan a ningún sitio**. El acta que se
envía a soporte no dice qué se revisó.

### 1.2 El selector suelo / altura solo existe en el emulador

Está en `4 Simulador/emulador_app/index.html:407`. El commit que lo anunció —`ff40a2c`, *«añadir
selector de tipo de inspección (Suelo sin subir vs Poste con escalera)»*— **tocó un único
fichero, el del emulador**. En el APK, la palabra «escalera» no aparece.

### 1.3 No hay historial

Lo único que la app guarda es el **nombre de la baliza por dirección MAC**
(`SharedPreferences("BalizasDB")`). El resto vive en la pantalla y muere al cerrar la app.

**Consecuencia para auditoría:** hoy no se puede auditar. No hay registro de quién inspeccionó,
cuándo, ni qué comprobó. La única traza es un mensaje de WhatsApp que alguien haya conservado —
y eso no se puede consultar por señal ni por fecha.

---

## 2. Por qué el tipo de inspección no es un detalle

Es lo que decide **qué se puede verificar honestamente**.

Una inspección desde el suelo se hace con el teléfono, sin tocar el equipo. Todo lo que se
comprueba llega por Bluetooth: la hora, el horario grabado, la tensión de la batería, los cortes
registrados, y el destello —que se ve desde abajo—.

Subir al poste es **otro trabajo**: escalera o canasta, normalmente dos personas, con su equipo
de protección. Ahí es donde se limpia el panel, se revisa el fusible, se aprietan las borneras y
se cambia la pila.

> **El problema del checklist actual es que mezcla los dos.** «Panel solar limpio y fusible 12V
> verificado» **no se puede hacer desde el suelo**, pero la casilla está ahí y se puede marcar.
> Un checklist que permite afirmar lo que no se ha comprobado es peor que no tener checklist:
> convierte una revisión incompleta en un documento que dice que fue completa.

---

## 3. La pantalla completa

La jerarquía de abajo viene de la propuesta de diseño en circulación, y **se acepta tal cual**:
coincide con lo que la app ya hace y con el orden en que el técnico trabaja. Lo único que cambia
es la tarjeta 6, por lo dicho en el apartado 2.

```
┌──────────────────────────────────────────────────────────────┐
│  IT VIAL 30 (v3.4)          [DISPOSITIVO]   [LEER]           │
├──────────────────────────────────────────────────────────────┤
│ 1. CONSOLA DE TELEMETRIA   (fija arriba, monoespaciada)      │
│    FW 3.4 · RTC 12:43:02 · Bat 12.6V · Cortes 2              │
├──────────────────────────────────────────────────────────────┤
│ 2. IDENTIFICADOR DE LA SEÑAL (OTA)                           │
├──────────────────────────────────────────────────────────────┤
│ 3. AUTODIAGNOSTICO Y SALUD ENERGETICA                        │
├──────────────────────────────────────────────────────────────┤
│ 4. HORARIO DE ESTA PLACA        <-- la funcion principal     │
│    4 franjas · dias · GRABAR · RECESO · REANUDAR             │
├──────────────────────────────────────────────────────────────┤
│ 5. PRUEBA DE FOCO (2 min) con cuenta atras                   │
├──────────────────────────────────────────────────────────────┤
│ 6. MANTENIMIENTO, CHECKLIST Y ACTA    <-- lo que se propone  │
├──────────────────────────────────────────────────────────────┤
│ 7. CONFIGURACION MANUAL AVANZADA (alarmas 1 a 5)             │
└──────────────────────────────────────────────────────────────┘
```

Los criterios de campo también se comparten y ya están medidos en la app
(`comprobar_ui.py`): contraste WCAG, texto de 13sp o más, áreas táctiles de 48dp o más.
**Los tres pasan.**

### 3.0 Tres afirmaciones de esa propuesta que no se sostienen

No es reproche: es que si se dan por buenas, se planifica sobre algo que no existe.

| Afirmación | Medido |
|---|---|
| *«El certificado incluye el checklist de inspección»* | ❌ **No lo incluye.** El acta lleva telemetría, horarios y la caja negra UART. Ni una casilla |
| *«Nombre del Colegio / Ubicación GPS»* | ❌ **No hay GPS.** La app declara permisos de ubicación, pero son los que Android exige para **buscar por Bluetooth**; no hay una sola línea que lea la posición |
| *«Checklist: Panel y Fusible 12V, Borneras…»* como lista única | ⚠️ Es justo el problema del apartado 2: mezcla lo que se ve desde el suelo con lo que exige subir |

Lo que sí es cierto y conviene reconocer: **`FW 3.4` ya aparece en la consola** — se añadió hoy al
firmware, y antes ninguna baliza sabía decir qué versión llevaba.

---

## 4. La propuesta

### 4.1 Lo primero que se elige, y manda sobre el resto

```
┌────────────────────────────────────────────────────┐
│  TIPO DE INSPECCIÓN                                │
│  ┌──────────────────────┬─────────────────────────┐│
│  │  A NIVEL DE SUELO    │   EN ALTURA (poste)     ││
│  │  (sin subir)         │   escalera o canasta    ││
│  └──────────────────────┴─────────────────────────┘│
└────────────────────────────────────────────────────┘
```

Un control de dos posiciones, grande, arriba de la tarjeta de mantenimiento. No es un
desplegable escondido: es lo primero que se toca y cambia lo que se ve debajo.

### 4.2 El checklist cambia con la elección

![Figura A: Inspección a nivel de suelo. Solo se muestran los seis puntos verificables sin subir, y el aviso enumera lo que queda pendiente.](img/propuesta_mant_suelo.png)

![Figura B: Inspección en altura. Aparecen además los seis puntos físicos, que en la modalidad anterior ni siquiera estaban en pantalla.](img/propuesta_mant_altura.png)



**A nivel de suelo** — el estado físico va primero, porque es lo que mira una interventoría
antes que nada, y **casi todo él se ve desde abajo**: una señal existe para leerse desde la vía.

```
ESTADO FISICO
☐ 1. Lámina reflectiva limpia, sin grafiti ni golpes
☐ 2. Placa del horario legible y bien sujeta
☐ 3. Señal sin obstrucción (ramas, vegetación, avisos)
☐ 4. Poste vertical y sin daño visible en la base

OPERACION (por Bluetooth y a la vista)
☐ 5. Hora del equipo coincide con la del teléfono
☐ 6. Horario grabado coincide con la placa atornillada
☐ 7. Tensión de batería dentro de rango        [ 12.6 V ]
☐ 8. Sin cortes de energía nuevos              [ 2 cortes ]
☐ 9. Destello verificado con la prueba de 2 minutos
```

**En altura** — los nueve anteriores, **más** lo que solo se alcanza subiendo:

```
☐ 10. Herrajes y abrazaderas apretados al poste
☐ 11. Gabinete cerrado y hermético, sin entrada de agua
☐ 12. Lente del foco limpia por dentro
☐ 13. Panel solar limpio, orientado y sin sombra
☐ 14. Fusible de 12 V verificado
☐ 15. Borneras apretadas, sin sulfatación ni juego
☐ 16. Pila CR2032 verificada o sustituida
```

> **Por qué el estado físico no es una sola casilla.** La propuesta en circulación lo mete como
> un único punto que agrupa *«lámina reflectiva + herrajes + lente + gabinete»*. Pero la lámina
> se ve desde la vía y el lente y el gabinete **están arriba**: juntarlos obliga otra vez a
> marcar desde el suelo algo que no se ha podido mirar. Repartidos, cada uno cae en la modalidad
> donde de verdad se comprueba.
>
> Y la **obstrucción por vegetación** merece su propia línea: es el fallo más común y más
> barato de arreglar de una señal escolar, y el equipo no puede detectarlo — la baliza destella
> perfectamente detrás de una rama.

**Los puntos que no aplican no se muestran en gris: no se muestran.** Si no están en pantalla,
no se pueden marcar por descuido. Y debajo, una línea que evita el malentendido:

> *Inspección a nivel de suelo. **7 puntos adicionales requieren subir al poste** y no se han
> verificado en esta visita.*

### 4.3 Esa frase entra en el acta

El acta exportada tiene que decir **qué no se comprobó**, no solo qué sí. Propuesta:

```
MODALIDAD:  Inspección a nivel de suelo (sin subir al poste)
----------------------------------------
CHECKLIST — 5 de 6 verificados
  [X] Hora del equipo coincide con la del teléfono
  [X] Horario grabado coincide con la placa
  [X] Tensión de batería dentro de rango (12.6 V)
  [X] Sin cortes de energía nuevos (2 cortes)
  [X] Destello verificado (prueba de 2 minutos)
  [ ] Señal y placa legibles          <-- NO VERIFICADO
----------------------------------------
NO APLICA EN ESTA MODALIDAD (requiere subir al poste):
  herrajes · gabinete · lente del foco · panel solar ·
  fusible 12 V · borneras · pila CR2032
----------------------------------------
INSPECCION REALIZADA POR: Cuadrilla 01 - D. Zuniga
FIRMA LO VERIFICADO Y TAMBIEN LO NO VERIFICADO.
```

Un acta que enumera lo no verificado es la diferencia entre un registro y una coartada.

### 4.4 Quién firma: el nombre del técnico

Hace falta, y el diseño propuesto es correcto en lo práctico:

* Un campo de texto en la tarjeta de auditoría.
* **Se guarda solo** en el teléfono, así que se escribe una vez al empezar la jornada y aparece
  ya puesto en las veinte señales siguientes de la ruta.
* Es un dato **del teléfono**, no de la baliza — al revés que el nombre del colegio, que sí se
  graba en la EEPROM del poste con `¿N…?`. Esa distinción está bien vista y conviene mantenerla.

Pero hay que ser honestos con lo que eso vale:

> **Un nombre escrito en una caja de texto es una atribución, no una firma.** No da «validez
> legal»: acredita lo mismo que quien sostiene el teléfono quiera escribir, y se puede cambiar
> entre una señal y la siguiente sin dejar rastro.

Y hay un detalle que cambia el planteamiento: **la app ya pide usuario y contraseña al entrar**
(`MainActivity`). Solo que hoy esa pantalla es decorativa para identificar a nadie — acepta
únicamente `admin` / `admin`, y **el nombre de usuario se descarta**: no se pasa a la pantalla
principal, no se guarda, no aparece en el acta.

Así que la decisión no es «¿añadimos un campo?» sino **de dónde sale la identidad**:

| Opción | Qué acredita | Coste |
|---|---|---|
| **A. Campo de texto libre**, autoguardado | Atribución. Suficiente si solo se quiere saber a quién preguntar | Bajo. Es lo propuesto |
| **B. Usar el login que ya existe**, con una credencial por técnico o cuadrilla | Quién entró a la app, no solo quién dice haber ido | Medio: hay que gestionar credenciales |
| **C. Las dos**: identidad del login, y el campo solo para anotar la cuadrilla | Lo mismo que B, con contexto | Medio |

> ### Decidido: opción A — 22-ago-2026
>
> **Se queda el campo de texto.** El motivo lo puso el responsable y es el que zanja la
> discusión: *si nos metemos con usuarios, acabamos dejando uno para todo.*
>
> Y tiene razón, porque eso ya pasó: hoy la app tiene login y **todo el mundo entra como
> `admin`**. Una credencial compartida no acredita a nadie — solo añade una pantalla más y la
> ilusión de control. Las credenciales por técnico degeneran en credencial compartida en cuanto
> hay prisa, una cuadrilla presta el teléfono o alguien olvida la suya.
>
> Así que se elige lo que de verdad aporta —saber a quién preguntar— y **se le llama por su
> nombre: atribución, no firma**. El acta no dirá «firmado por»; dirá «inspección realizada
> por», que es lo que un campo de texto puede sostener.
>
> Si algún día la interventoría exige acreditar identidad, eso no se arregla con un login: se
> arregla con un acta que salga del teléfono a un sitio que el técnico no controle. Eso es otro
> proyecto y hoy no está sobre la mesa.

Sea cual sea, en el acta va **al lado de lo no verificado**, no debajo de un «señal aprobada»:
quien firma, firma también lo que no pudo comprobar.

### 4.5 Dónde se guarda

Propuesta mínima que ya resuelve la auditoría, sin servidor ni conectividad:

* Cada inspección se guarda en el teléfono como un registro con **fecha, MAC, nombre de la
  señal, modalidad, checklist completo y la telemetría de ese momento**.
* Se indexan **por MAC**, que es lo único que identifica físicamente a una baliza.
* Al conectar con una señal, la app muestra **«Última inspección: 12-ago-2026, a nivel de
  suelo»**, para que el técnico sepa qué se hizo la vez anterior y si toca subir.
* El acta se sigue compartiendo por el menú de Android, y además **se puede exportar el historial
  completo** de una señal.

Con eso una auditoría puede responder: *¿cuándo se inspeccionó esta señal por última vez, quién,
qué comprobó y qué quedó sin comprobar?* Hoy no puede responder ninguna de las cuatro.

---

## 5. Lo que hace falta decidir antes de implementar

No lo decide quien programa:

1. **¿Los 16 puntos son los correctos?** Los he derivado de la tarjeta y del manual actual, pero
   quien mantiene estas señales sabrá si falta alguno o sobra.
2. **¿Cada cuánto toca subir?** Si la norma o el contrato fijan una periodicidad para el
   mantenimiento físico, la app puede avisar: *«última inspección en altura hace 8 meses»*.
4. **¿El historial se queda en el teléfono o tiene que salir?** Si el teléfono se pierde o se
   cambia, el historial se va con él. Exportarlo periódicamente resuelve el caso simple.
5. **¿Quién consulta esto?** De la respuesta depende el formato: no es lo mismo para el técnico
   en el poste que para una auditoría externa.

---

## 6. El emulador web es la causa de fondo, y hay que decidir qué se hace con él

Varias funciones se «vieron funcionando» en las demos sin existir nunca en el APK, porque lo que
se enseñaba era **el emulador web** (`4 Simulador/emulador_app/index.html`), no la aplicación. El
selector suelo/altura es el caso claro: su commit tocó ese único fichero.

Ahora la divergencia va en sentido contrario — el emulador se quedó con el 1-Toque viejo y no
tiene ni las cuatro franjas ni el receso.

Hay dos salidas y conviene elegir una a conciencia:

1. **Mantenerlo sincronizado** con la app. Da una pantalla cómoda para enseñar y para probar
   contra el firmware sin teléfono, pero **duplica el trabajo en cada cambio** y la divergencia
   volverá en cuanto alguien tenga prisa.
2. **Degradarlo a banco de pruebas del protocolo**, sin pretensión de parecerse a la app: sirve
   para ejercitar tramas contra el firmware, y se deja de usar para enseñar la interfaz.

Sea cual sea, **la regla que falta es la misma**: una función no está hecha hasta que está en el
APK. El emulador no cuenta como implementación, y las demos deberían hacerse sobre el APK.

---

## 7. Coste

Todo lo anterior es **de la aplicación**. **No requiere tocar el firmware ni volver a grabar
ningún PIC**: la baliza ya entrega la telemetría que hace falta.

---

## Referencias

* Base normativa: [`NORMATIVA.md`](NORMATIVA.md)
* Manual de campo: [`MANUAL_USUARIO_APP.md`](MANUAL_USUARIO_APP.md)
* Estado y pendientes: [`../ROADMAP.md`](../ROADMAP.md)
