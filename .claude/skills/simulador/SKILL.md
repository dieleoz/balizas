---
name: simulador
description: Como esta hecho el simulador de PC de la baliza, que puede medir y que no, y como anadirle un escenario sin que empiece a medirse a si mismo. Usar al tocar cualquier cosa de 4 Simulador, al anadir o cambiar un escenario, cuando el simulador aborte, al mover o renombrar un .c del firmware, o cuando haga falta reproducir en el PC un fallo que se vio en campo.
---

# El simulador de PC de la baliza

El firmware de la baliza corre en un PIC18F2550 que esta dentro de una senal de trafico
atornillada a un poste. Probar un cambio ahi significa: compilar, coger el programador, ir
al equipo, grabar, esperar a que den las 6:00 de la manana. El simulador convierte eso en
un segundo, y permite **hacer que sean las 6:00 cuando a uno le convenga**.

Vive en `D:\@Proyect\Baliza\4 Simulador\`. Se lanza con `python correr.py` (ver la skill
[`verificar`](../verificar/SKILL.md) para leer el resultado; aqui va como esta construido).

## 1. La idea: los `.c` de verdad, el silicio de mentira

```
                 arnes.c              <- los escenarios
                    |
   .c REALES del firmware             <- sin tocar una linea
   TimeBase LedLive Buzzer Cluster Serial Alarma Aplicacion
                    |
        stubs/xc.h + sim/plataforma.c  <- lo que en el equipo es silicio
```

`stubs/xc.h` declara los registros del PIC como variables normales del PC.
`sim/plataforma.c` pone el tick de Timer0, la interrupcion de recepcion, el ADC, la EEPROM y
un DS1307 que se puede mover a voluntad.

**La regla que sostiene todo esto:** el simulador puede mentirle al firmware sobre el
**hardware**, nunca sobre la **logica**. Si un dia hace falta tocar un `.c` del firmware para
que el simulador pase, el simulador deja de medir el firmware y pasa a medirse a si mismo.
Se arregla en `plataforma.c`, no en `Serial.c`.

## 2. Que no se compila, y por que

| fuera | motivo |
|---|---|
| `main.c` | usa `__interrupt()`, que solo existe en XC8. Su bucle `while(1)` y su ISR de Timer0 estan reproducidos **literalmente** en `plataforma.c`, incluido el reinicio de todos los `ulCntPeriodX` cada 60000 ticks |
| `EEprom.c` | hace `while(!PIR2bits.EEIF);` sobre un periferico que no existe: colgaria el proceso en la primera escritura |
| `DS1307.c` | habla I2C con un chip que no esta; y hacen falta las 6:00 a voluntad |
| `I2C.c` | solo lo usa `DS1307.c` |

Cada exclusion **se paga**: lo que no se compila, no se mide. La lista de lo que el simulador
no ve esta al final de la skill `verificar` y hay que mantenerla honesta.

## 3. Dos rarezas del montaje que hay que conocer

**a) No se puede compilar en unidad unica.** `Cluster.h` **no tiene guarda de inclusion** —
ni `#ifndef CLUSTER_H` ni `#pragma once`— y lo incluyen `Cluster.c` y `Aplicacion.c`. En una
sola unidad el compilador ve dos veces la misma `struct` y el mismo `enum` y aborta. Por eso
`correr.py` compila fichero a fichero, como hace MPLAB X.

**b) `transmitUart1` va envuelta.** El arnes necesita ver todo lo que el equipo transmite, y
en el PC `TXREG` es un byte que se sobreescribe en cada vuelta. `Serial.c` se compila con
`-DtransmitUart1=fw_transmitUart1`: la funcion **original, sin tocarle una linea**, cambia de
nombre, y la envoltura de `arnes.c` apunta la cadena y la llama. Los demas modulos siguen
llamando a `transmitUart1` sin enterarse.
Gracias a eso el escenario D4 puede medir el `<=` de `Serial.c:59` mirando que byte queda en
`TXREG` al terminar — que resulta ser el `\0` terminador.

## 4. Lo que el arnes puede hacerle al firmware

La API esta en `sim/sim.h`. Lo util:

```c
sim_reset();                 // corte de alimentacion: RAM a cero, tareas reiniciadas
sim_eeprom_borrar();         // EEPROM a 0xFF: un PIC recien salido de fabrica
sim_arrancar();              // corre hasta que el firmware transmite su banner
sim_tick(70000);             // avanza 70 s simulados
sim_rx_str("\xBF" "L?\n\r"); // mete una trama, un byte por tick, como a 9600 baudios
sim_tx();                    // todo lo que el equipo ha transmitido
sim_rtc_set(5,59,0, 21,8,26, 5);   // colocar el reloj donde interese
sim_cluster();               // LATC2: la luz de la senal
sim_medir_cluster(...);      // duracion del pulso encendido y del apagado
```

Dos cosas que `sim_reset()` **no** toca, a proposito, porque son parte de lo que hay que
poder probar: **la EEPROM** (el PIC tampoco la borra al quitar la corriente) y **el reloj**
(el DS1307 sigue contando con su pila).

## 5. Como se anade un escenario

1. **Decide que hecho mides y de donde sale la verdad.** En orden: una constante del C++/C
   real, luego el protocolo tal y como lo manda la app, y solo si no vive en ningun archivo,
   la definicion escrita del responsable. **El numero nunca se copia a mano** de un mensaje o
   de un borrador: se lee del archivo que lo contiene.
2. **Escribe primero el caso que tiene que fallar hoy** y comprueba que **falla**. Un
   escenario que nace en verde no ha demostrado que mida nada.
3. **Marca los rojos esperados** con `[ROJO ESPERADO fecha]` en el nombre y el motivo en un
   comentario encima, con `archivo:linea`. Sin fecha, dentro de un mes nadie sabe si ese rojo
   es un defecto conocido o algo que se rompio ayer.
4. **Si el escenario comprueba que algo NO pasa, justifica el plazo.** Ver el falso verde (b)
   de la skill `verificar`: 3000 ticks daban verde donde 8000 dan rojo.
5. **Corre el arnes entero antes y despues** y comprueba que **la cuenta se mueve**. Si
   anades una rama y el total no cambia, no la estas midiendo.

## 6. Un escenario que puede tumbar el proceso se corre en un hijo

El escenario D5 alimenta una trama truncada y **el firmware se cae de verdad** — que es
exactamente el defecto: `extraerValue()` en `Serial.c:449` no comprueba el `strstr()` y copia
sin limite en un `char buffer[4]`.

Medirlo dentro del proceso dejaria sin correr todos los escenarios de detras, y **un arnes
que se cae a la mitad no midio nada de lo que faltaba**. Por eso el arnes se relanza a si
mismo con un argumento (`arnes.exe --trama-truncada`) y mira el codigo de salida del hijo. Si
el hijo muere, el defecto esta vivo.

Es el patron para cualquier escenario que pueda romper el proceso. **No lo conviertas en un
escenario "suave" que no llegue a disparar el fallo**: eso lo pondria en verde sin haber
arreglado nada.

## 7. Mover un `.c` y actualizar el simulador van en el MISMO cambio

`correr.py` lista los fuentes del firmware por nombre en `FUENTES_FW`. Si alguien mueve o
renombra un `.c` y no actualiza esa lista, la compuerta **aborta** — que es lo correcto — pero
quien mire por encima lo confundira con un fallo del firmware.

Lo mismo con las globales: si el firmware gana una variable global nueva, hay que anadirla al
borrado de `sim_reset()`. Si no, se arrastra de un escenario al siguiente y los resultados
pasan a depender del orden de las pruebas. Ya paso el 21-ago-2026.

## 8. Lo que el simulador jamas va a decir

Que el equipo funcione. Verde aqui significa que un modelo de PC no encuentra nada. **Ningun
GPIO se ha comprobado contra su carga**, y hay un desajuste medido entre lo que el firmware
ataca y lo que hay en la tarjeta (`HARDWARE.md`). Antes de creerte un verde, lee el punto 7 de
la skill [`verificar`](../verificar/SKILL.md).
