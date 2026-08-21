---
name: verificar
description: Verifica el firmware de la baliza con el simulador de PC e interpreta el resultado sin tragarse falsos verdes. Usar antes o despues de tocar codigo, cuando el simulador lleve un rato sin correrse, al anadir un escenario nuevo, o antes de decir que algo esta listo para grabar o para campo. Incluye los tres estados de una comprobacion, los falsos verdes medidos en esta maquina, y por que verde no autoriza a grabar mientras el mapeo de pines no coincida con la tarjeta.
---

# Verificar el firmware de la baliza

Esta baliza es la luz de una senal de trafico que dice **«30 CUANDO ACTIVADA»** delante de
un colegio. Cuando titila, el limite de 30 km/h esta vigente para todo el que pasa. Y el
horario no lo lee nadie de una pantalla: va **impreso en una chapa atornillada a la senal**
(6:00-9:00, 11:30-13:30, 15:00-16:30). Si el equipo hace algo distinto de lo que dice la
chapa, la senal miente a los conductores y nadie se entera desde el escritorio.

Verificar aqui no es un tramite. Es la unica defensa que hay.

## 1. El comando

```bash
cd "D:/@Proyect/Baliza/4 Simulador" && python correr.py
```

Compila los `.c` **reales** del firmware con gcc contra los stubs de `<xc.h>` y los corre.
Codigos de salida: **`0` PASS · `1` FALLA · `2` ABORTADO**.

**La cifra vigente NO vive en esta skill: vive en `ESTADO.md`**, que se reescribe cada
sesion. Aqui se congelaria y mentiria en dias. Corre el comando y compara contra `ESTADO.md`.
Si lo que te sale no coincide, alguien toco algo: averigua que **antes** de seguir.

Los rojos deben ser **esperados y llevar fecha en el nombre del escenario** —
`[ROJO ESPERADO 21-ago-2026]`. Un rojo sin fecha es un defecto del arnes, no del firmware.

> Y el reverso, que es el que nadie mira: **un rojo esperado que ya se arreglo y sigue
> anunciado**. Al poner un escenario en verde, se le quita la marca de rojo esperado y se
> le limpia el comentario en el mismo cambio. Un escenario que sigue diciendo «nace en rojo
> por X» con X ya arreglado miente igual que uno que oculta un defecto vivo.

## 2. Los tres estados, y ABORTADO no es PASS

| | significa |
|---|---|
| `PASS` | corrio y el firmware cumple |
| `FALLA` | corrio y el firmware **no** cumple |
| `ABORTADO` | **no pudo correr** — no dice *nada* del firmware |

`ABORTADO` sale cuando falta el compilador, cuando un `.c` del firmware no compila, o cuando
el arnes se muere a mitad. `correr.py` lo devuelve **con prioridad sobre FALLA** a proposito:
si el instrumento no midio, no puede acusar al firmware. Tratar un abortado como un fallo mas
invita a tocar el firmware cuando lo roto es la regla de medir.

Si cambias el comportamiento a proposito y el arnes deja de compilar, eso es `ABORTADO` y
esta bien: **actualizar el instrumento es parte del cambio, no un paso posterior.**

## 3. El compilador va por ruta absoluta

`correr.py` usa `D:\toolchain\mingw64\bin\gcc.exe` y **aborta si no esta**. No cae al `gcc`
del PATH a proposito: en esta maquina el del PATH vive bajo una carpeta con `ñ` y su
enlazador no encuentra `crt2.o`. **Un compilador que existe no es un compilador que mide.**
Un instrumento que se busca un compilador de repuesto mide con el equivocado y acusa de un
fallo que no existe.

Y ojo con dos banderas que no son decorativas:

- **`-fcommon`.** El firmware define `strAplicacion ap;` **sin `extern`** en `Aplicacion.c` y
  otra vez en `LedLive.c:17`, y `srtAlarmas ala1..ala5` dos veces, en `Serial.c:22-26` y en
  `Alarma.c:24-28`. XC8 las fusiona en un solo objeto y el firmware funciona **por eso**.
  gcc desde la version 10 las rechaza. Se compila con `-fcommon` para reproducir lo que hace
  XC8 — no para tapar el problema, que sigue anotado como defecto.
- **`-finput-charset=CP1252 -fexec-charset=CP1252`.** El delimitador de trama es el byte
  **0xBF** (`Serial.h:27`). Leido como UTF-8 se convertiria en otra cosa y el protocolo del
  simulador dejaria de coincidir con el del equipo, midiendo un protocolo que no existe.

## 4. Los dos falsos verdes que ya nos comio esta maquina

Los dos aparecieron el **21-ago-2026**, el mismo dia que nacio el arnes. Los dos daban
**verde estando el defecto vivo**. Merece la pena conocerlos porque los dos patrones se
repiten.

**a) Estado que se arrastra de un escenario al siguiente.** `sim_reset()` prometia dejar el
equipo «como recien alimentado» y solo borraba los puertos y el contador de ticks: las
maquinas de estado, `ap`, `cl`, `ala1..5` y los protothreads **seguian como los dejo el
escenario anterior**. El resultado es lo peor que puede pasarle a un arnes: el escenario de
la luz daba **verde corriendo solo y rojo dentro de la tanda completa**. Un resultado que
depende del ORDEN de las pruebas no es un resultado.
Ya esta corregido: `sim_reset()` pone a cero todas las globales del firmware y vuelve a
llamar a los seis `startTaskX()`, igual que `main()`. **Si anades una global al firmware,
anadela ahi en el mismo cambio.**

**b) Medir antes de que el defecto tenga tiempo de aparecer.** El escenario de los dias
personalizados miraba la maquina de estados a los 3000 ticks. La tarea tarda **unos 8000** en
llegar al estado donde se cuelga. Daba verde por llegar pronto, no por estar bien.
La regla: cuando un escenario compruebe que algo **no** pasa, deja escrito **por que ese
plazo es suficiente**. Un plazo elegido a ojo es un verde a ojo.

## 5. Un arnes que nadie ha visto fallar es un adorno

Antes de fiarte del arnes —nuevo, o uno que llevaba tiempo sin tocarse— **inyectale un
defecto real y comprueba que la cuenta se mueve**. El bloque `E. Control negativo` ya vive
dentro del arnes y comprueba que rechaza lo que tiene que rechazar, pero eso no sustituye a
probarlo contra el firmware.

Ejemplo que funciona: en `Cluster.c`, cambiar el `5` de `if(++cl.uiCnt >= 5)` por otro
numero. El escenario C mide la duracion del pulso y **tiene que moverse**. Si la cuenta de
fallos no cambia con el defecto puesto, el arnes no mide eso.

> **Como leerlo cuando el arnes NO parte de verde.** El criterio *«verde -> falla»* solo vale
> si el punto de partida son 0 fallos. Con el arnes en rojo —que es lo normal mientras hay
> defectos en cola— lo que hay que mirar es que **el numero de fallos cambie** al inyectar el
> defecto y **vuelva exactamente al valor de partida** al restaurar. Anota ese valor antes de
> tocar nada.

Despues, restaura y confirma comparando el archivo, no la impresion de haber restaurado.

## 6. Pruebas que exigen el defecto: no se reescriben en bloque

Un banco maduro acumula escenarios que **exigen el comportamiento defectuoso**, escritos
cuando el defecto se creia inevitable. Al arreglar la causa, esos escenarios fallan — y eso
es correcto, no una senal de que el arreglo este mal.

Cada uno acaba en uno de tres sitios, uno por uno, **nunca en bloque**: **se borra** (solo
documentaba el defecto), **se invierte** (pasa a exigir el comportamiento nuevo) o **se
conserva** (medía otra cosa y el cambio no la toca).

Reescribir en bloque hasta que todo pase es ajustar el instrumento hasta que de verde.

## 7. Lo que este arnes NO verifica

`correr.py` mide logica: maquinas de estado, protocolo, EEPROM, alarmas y la cadencia del
bit que va a `LATC2`. **No toca un solo pin real.** En concreto no dice nada de:

- **El mapeo de pines contra la tarjeta.** Y ahi hay un problema medido: `HARDWARE.md` dice
  que el buzzer de la placa va a **RC1**, y el firmware ataca **RC0** (`Buzzer.h:24`) — que en
  la tarjeta es la linea del pulsador. El simulador enciende «el buzzer» tan contento porque
  escribe en una variable. La tarjeta no suena. **La tarjeta ya esta fabricada y es fija: se
  cambia el firmware, no la placa.**
- **El ADC.** El firmware pone `PCFG = 0b1011`, que segun `HARDWARE.md` solo habilita AN0-AN2,
  y el sensor de temperatura entra por **AN3**. El simulador devuelve el valor que le pidas y
  nunca se entera.
- **El I2C y el DS1307.** El reloj simulado siempre responde y siempre corre. Una pila
  agotada, unas pull-ups mal o el bit de reloj parado no existen aqui.
- **El Bluetooth.** El simulador le mete las tramas directamente. Que el modulo empareje es
  otro asunto entero: `BLUETOOTH.md` y `MANUAL_FUNCIONAL_BLUETOOTH.md`.
- **Que el horario grabado coincida con la chapa atornillada de esa senal.** Eso lo mira una
  persona, con la senal delante, y esta en el manual de pruebas de campo.

**Verde aqui NO es entregable, y ni siquiera autoriza a grabar.** Para entender como esta
hecho el simulador y como se le anade un escenario, la skill [`simulador`](../simulador/SKILL.md).
Para comprobar el contrato de tramas antes de tocar `Serial.c`, la skill
[`verificar-protocolo`](../verificar-protocolo/SKILL.md). Para decidir que sale del proyecto,
la skill [`entregar`](../entregar/SKILL.md).
