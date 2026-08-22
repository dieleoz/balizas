---
name: entregar
description: Prepara lo que sale del proyecto Baliza hacia el responsable, el funcional o el personal de campo — manuales, documentos, y la distincion entre pedir una medida y entregar una version de firmware. Usar al redactar o revisar un envio, al decidir si lo que toca es un encargo de medida o una entrega, o antes de dar por cerrada una pregunta.
---

# Entregar sobre la baliza

Un documento que sale de este proyecto es una autorizacion implicita: quien lo recibe asume
que puede actuar sobre lo que dice. Y lo que hay al otro lado es una **senal de trafico
delante de un colegio** que anuncia un limite de 30 km/h cuando su luz titila. Un horario mal
citado en un manual acaba en una senal que dice una cosa y hace otra.

## 1. La distincion que decide que se manda

| paquete | cuando se manda | que es |
|---|---|---|
| **Encargo de medida** | siempre que falte una medida | Una PETICION: pide que alguien ponga el equipo o la tarjeta delante y mida. No entrega nada instalable |
| **Entrega de version** | solo con el firmware verificado **y** el mapeo de pines confirmado contra la tarjeta | El `.hex` para grabar en el PIC |

**Hoy corresponde un encargo, no una entrega.** El firmware tiene defectos medidos y abiertos
(la cifra del dia esta en `ESTADO.md`), y hay un desajuste entre lo que el firmware ataca y lo
que hay en la placa: `Manuales/HARDWARE.md` situa el buzzer en **RC1** y `Buzzer.h:24` escribe en
**RC0**. Que `4 Simulador\correr.py` de verde no cambiaria eso — mide logica contra variables,
no pines contra cargas (ver la skill [`verificar`](../verificar/SKILL.md), punto 7).

Confundir las dos cosas es el error que mas cuesta: alguien graba en una senal instalada algo
que solo se probo en un PC.

## 2. La chapa manda sobre el documento

Cada senal lleva **atornillada una placa con su horario impreso**. La de referencia dice:

```
Entre 6:00 am y 9:00 am
Entre 11:30 am y 1:30 pm
Entre 3:00 pm y 4:30 pm
```

Ningun documento que salga del proyecto puede citar un horario **de memoria ni del ultimo
mensaje**. Se copia de la foto o del acta de esa instalacion. Y si un manual explica como
programar horarios, tiene que decir explicitamente que **el horario a programar es el de la
chapa de esa senal concreta**, no el del ejemplo del manual: en cuanto un ejemplo se lee como
valor por defecto, alguien lo teclea.

## 3. Las cifras se copian de donde se midieron, nunca a mano

Antes de poner un numero, un estado o un «funciona» en un documento que sale del proyecto,
**vuelve a mirar el archivo que lo contiene**: la salida de `correr.py`, el `.map` del
compilador, el esquematico, o el acta de la prueba. No se transcribe de memoria ni de un
borrador anterior.

Ejemplo de esta semana: el parpadeo. Durante la reunion se definio **2 segundos encendida y 2
segundos apagada**. Lo que hace el firmware, medido por el simulador, son **rafagas de cinco
destellos de 50 ms con medio segundo de pausa**. Cualquier documento que diga «parpadea cada 2
segundos» estaria describiendo la definicion, no el equipo.

## 4. Textual lo que dijeron, aparte lo que proponemos

Al citar al responsable o al funcional, **comillas y palabras exactas**. Lo que el proyecto
propone como opcion por defecto va marcado aparte, con `▸ Si no hay respuesta:` o equivalente,
nunca mezclado en el mismo parrafo como si fuera parte de lo acordado.

Vale igual para los manuales tecnicos: en `Manuales/MANUAL_FUNCIONAL_BLUETOOTH.md` la convencion de
nombres de los modulos es **una propuesta a confirmar**, y tiene que leerse como tal. Un
requisito que nadie reviso gobernando una senal escolar es peor que un pendiente abierto.

## 5. Un documento no abre con la cifra en verde

Si el documento reporta un resultado de verificacion, el orden es: **que hace hoy el equipo
instalado**, si paso prueba fisica o no —con esas palabras, no con una cifra que lo insinue—,
que esta pendiente o roto, y solo despues las novedades.

Abrir con «58 de 58 en verde» hace que quien lo reciba no llegue a la linea que dice que el
arnes **no mide el ADC**, y que por eso las 58 pasan con la lectura de temperatura devolviendo
basura (AN3 sin habilitar en `PCFG`). La cifra no miente; lo que engana es ponerla primero.

Y el caso limite, que es el que se cuela: **una cifra perfecta engana mas que una mala.** Un
«24 de 33» invita a preguntar por los 9. Un «58 de 58» cierra la conversacion. Cuando el
resultado sea redondo, la frase que lo acompana no es de celebracion sino de alcance: **que
quedo sin medir**.

## 6. Lo que no puede faltar en un manual de este proyecto

- **Que hacer cuando el resultado no es el esperado.** Un manual que solo describe el camino
  feliz deja a la persona de campo sin saber si lo que ve es normal. Cada paso lleva: que se
  hace, que se tiene que ver, y **que significa cada forma de fallar**.
- **Una casilla que marcar** en cada comprobacion, y sitio para firma y fecha. Si no hay donde
  anotar, no queda constancia de que se hizo.
- **Los pasos numerados**, para poder decir por telefono «vas por el 4.3».
- **Las preguntas abiertas al final**, redactadas como preguntas concretas dirigidas a quien
  pueda contestarlas. Nunca como instrucciones. **Un paso inventado en un manual de validacion
  hace que se de por bueno un equipo que no lo esta**, y este equipo acaba en un colegio.

## 7. Antes de mandar algo, cuatro comprobaciones

- [ ] Si es un encargo de medida: dice explicitamente que es una peticion, no una entrega.
- [ ] Cada cifra, horario o estado citado se volvio a mirar en su fuente, no se copio de un
      mensaje anterior.
- [ ] Si cita un horario, dice de que instalacion es y remite a la chapa de esa senal.
- [ ] Si es un envio nuevo al funcional: es un documento nuevo con solo lo que sigue abierto,
      no una reedicion del anterior — y el anterior queda accesible como historico. Una causa
      que desaparece en silencio vuelve a proponerse mas adelante como si fuera nueva.

Para interpretar si el firmware esta realmente verificado antes de citarlo, la skill
[`verificar`](../verificar/SKILL.md). Para comprobar el contrato de tramas antes de afirmar
que un horario quedo programado, la skill
[`verificar-protocolo`](../verificar-protocolo/SKILL.md).

## Al entregar un binario, di CUAL es

El equipo no sabe decir que firmware lleva: anuncia `BALIZA ALARMA V1.0` desde siempre, y esa
cadena es la misma en binarios que se comportan distinto. Delante de una senal montada no hay
forma de averiguarlo.

Asi que **la trazabilidad la pone el documento, no el equipo**. Todo envio que incluya un
`.hex` o un `.apk` lleva, sin excepcion:

* el **SHA-256** del fichero, medido sobre el fichero que se envia -- no copiado de otro sitio;
* su **tamano en bytes**;
* la **version del compilador** y sus banderas (regla 4);
* y con que **pareja** se probo, porque app y firmware se validan juntos.

El 22-ago-2026 se encontro un certificado cuyos hashes **no verificaban**: compartian los 12
primeros caracteres con los reales y divergian despues. No detectaban ni un cambio, y por eso
el binario de una carpeta de release pudo ser sobrescrito cinco veces sin que saltara nada.
**Un hash que no se ha recalculado sobre el fichero que se envia no es un hash: es adorno.**

## Un control que se ve no es un control que funciona

Antes de decir que una funcion esta entregada, comprueba que esta ENLAZADA. En esta app pasaron
cuatro veces: la casilla existia en el layout, a veces incluso el campo estaba declarado en el
Java, y nadie le hacia findViewById. Se veia en pantalla, se podia pulsar, y no hacia nada.

Lo peor es que NO DA ERROR. El tecnico marca, pulsa, y la app se comporta como si hubiera
funcionado. El del nombre OTA llego a demostrarse en reuniones -- pero era el emulador web, no la
app; en la app el acta salia siempre con "Sin Asignar".

    cd "1 Firmware/Doc Aplicativo Movil/BalizaV10" && python comprobar_ui.py

Cruza el layout contra el codigo y saca en rojo cualquier control con `id` que no aparezca en el
Java. Correlo antes de entregar un APK, y **corrigelo antes de anunciar la funcion**.

Y la regla de fondo: **una funcion no esta hecha hasta que esta en el APK.** El emulador web no
cuenta como implementacion, y las demos deberian hacerse sobre el APK.

## Regenerar el Word ha destruido las figuras dos veces

El manual de usuario lleva 22 figuras. El 22-ago-2026 se quedo sin ninguna DOS VECES en el
mismo dia, y las dos por motivos distintos:

1. **El `.md` no las referenciaba.** Vivian solo dentro del `.docx`, asi que regenerarlo --
   siguiendo la regla del proyecto -- las borraba. Se arreglo metiendo los `![](img/...)` en
   el `.md`, que es lo que la regla decia que ya pasaba.
2. **Pandoc no encontraba `img/`.** Se le invocaba desde otro directorio de trabajo. Se
   arreglo con `--resource-path` y `cwd` en `Manuales/`.

**Comprueba el resultado, no el mensaje de exito.** `generar_word.py` dice "1 de 1 generados"
igual de contento con figuras que sin ellas:

    unzip -l MANUAL_USUARIO_APP.docx | grep -c word/media/

Deben salir 22. Si sale 0 y el fichero pesa 20 KB en vez de 566 KB, las figuras se han ido.

Y un detalle de presentacion: los emoji **no se dibujan** en las ilustraciones generadas --
la fuente es Arial y no los tiene, asi que salian como cuadros vacios. `generar_capturas_app.py`
los filtra al dibujar. En pantalla un cuadrito no es nada; en un manual que va a la
interventoria parece un documento roto.
