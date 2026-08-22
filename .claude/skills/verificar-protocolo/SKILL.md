---
name: verificar-protocolo
description: Verifica byte a byte el contrato de tramas entre la app Android y el firmware del PIC — que caracteres manda cada extremo, que espera el otro, y que se rompe en silencio si no coinciden. Usar antes de tocar Serial.c o MainActivity2.java, cuando llegue una version nueva de la app, cuando un comando "no hace nada", o antes de decir que un horario quedo programado.
---

# Verificar el contrato de tramas de la baliza

El firmware busca cada campo de la trama **por su caracter exacto**, con `strstr()`. Un
caracter que no coincide **no da error**: el comando se pierde en silencio, la app dice
«Mensaje Enviado!!» igualmente, y la senal se queda con el horario viejo. Nadie se entera
hasta que alguien mira la senal a las 6 de la manana.

Por eso, cuando alguien diga «ya quedo programado», hay que comprobarlo contra el archivo.

## 1. Las dos puntas del contrato

| | donde |
|---|---|
| Quien lo **manda** | `1 Firmware\Doc Aplicativo Movil\BalizaV10\app\src\main\java\com\example\balizav10\MainActivity2.java` |
| Quien lo **lee** | `1 Firmware\Doc mplabx\18f2550_baliza_ V1.X\Serial.c` y `Serial.h` |
| Quien **contesta** | `readDevide()` en `Aplicacion.c` |

Los identificadores viven en `Serial.h`: `A` numero de alarma, `E` habilitada, `I` hora de
inicio, `F` hora de fin, `D` dias, `R` reloj, `C` calendario, `L` leer, `,` separador.

## 2. El delimitador no es un `?` al reves: es un byte

`Serial.h:27` define `INIT_FRAME` como el **byte 0xBF**. En Windows-1252 ese byte se dibuja
como `¿`, y por eso en el fuente aparece asi. **`grep` sobre el archivo no basta para
verificarlo**, porque lo que se ve en pantalla depende de con que codificacion lo abra tu
editor. Se mira el byte:

```bash
cd "1 Firmware/Doc mplabx/18f2550_baliza_ V1.X"
grep -a 'define INIT_FRAME' Serial.h | od -c    # tiene que salir 277 octal = 0xBF
grep -a 'define END_FRAME'  Serial.h | od -c    # tiene que salir '?' = 0x3F
```

Y aqui esta la trampa que hay que conocer antes de «arreglar» nada: **la app manda ese
caracter en UTF-8, o sea DOS bytes, `0xC2 0xBF`**. `PrintWriter`/`OutputStreamWriter` se
construyen sin indicar codificacion, asi que usan la del sistema, que en Android es UTF-8.

Funciona **de casualidad**: `strstr()` busca subcadena, encuentra el `0xBF` detras del `0xC2`,
y el `0xC2` sobrante se queda delante sin molestar. Se rompe en silencio si alguien:

- cambia `strstr()` por una comparacion del primer byte,
- hace que la app mande Latin-1 «para que coincida con el firmware»,
- o cambia el delimitador por un caracter ASCII solo en uno de los dos lados.

El escenario **B5** del simulador existe para que esto no se rompa sin que salte nada.

## 3. La otra trampa: la app manda ceros dentro de la trama

`MainActivity2.java:174-182` arma la hora en un `char[6]` escribiendo solo 4 posiciones, y el
calendario en un `char[10]` escribiendo 8. Los huecos quedan a `\0` y `String.valueOf()` los
manda por el aire. La trama real de poner en hora **lleva bytes nulos intercalados**.

El firmware sobrevive porque `Serial.c:120-127` los **filtra** al copiar el buffer. O sea: el
firmware tenía un parche para un defecto de la app. En la **App v2.1 (`Baliza_v2.1.apk`)**,
`MainActivity2.java` fue corregido usando `SimpleDateFormat` y `ISO-8859-1` directo, enviando
la trama limpia sin bytes nulos y con codificación exacta. El escenario
**B4** del simulador lo sujeta.

## 4. Como se comprueba una trama de verdad

No a ojo sobre el codigo Java. Se mete por el simulador, que es el mismo `Serial.c` que corre
en el PIC:

```c
sim_rx_str("\xBF" "A3,E1,I0830,F1745,D9,?\n\r");
sim_tick(200);
sim_eeprom_leer(0x12);   // hora de inicio de la alarma 3 -> tiene que ser 8
```

El mapa de direcciones de EEPROM esta en `Aplicacion.h` (`ADDRESS_*`). Comprobar **la EEPROM**
y no una variable en RAM es lo que demuestra que el dato sobrevive a un corte de luz, que es
lo unico que importa en un poste.

## 5. Que revisar cuando llegue una version nueva de la app

Lista corta, en este orden:

- [ ] **Los identificadores siguen siendo los mismos caracteres.** Compara `MainActivity2.java`
      contra `Serial.h` uno por uno. Un renombre no solicitado es el defecto mas caro del
      proyecto porque no se manifiesta hasta campo.
- [ ] **El delimitador sigue viajando como `0xC2 0xBF`** o, si cambio, el firmware cambio con el.
- [ ] **El orden de los campos** no cambio: `extraerFrame()` busca desde el identificador hasta
      el siguiente separador, asi que el orden importa.
- [ ] **Las listas de horas y minutos.** Hoy `sOptionHour` (`MainActivity2.java:101`) tiene **23**
      entradas y **le falta la `"02"`**: no se puede programar nada a las 2 de la madrugada. Si
      la lista cambia, comprueba que sigue cubriendo las horas de la chapa de las senales
      instaladas.
- [ ] **La codificacion de dias**: 8 diario, 9 lunes a viernes, 10 fin de semana. Los valores
      1..7 (dias concretos) **la app no los manda y el firmware no los implementa** — y peor:
      una trama con 1..7 hace que la tarea de alarma se cuelgue (escenarios D2 y D3 del
      simulador). Si una version nueva de la app empieza a ofrecerlos, el firmware tiene que
      arreglarse **antes**.
- [ ] Correr el simulador entero y comprobar que los escenarios `B*` siguen en verde.

## 6. Comprobar que un horario quedo grabado, en campo

La app **no espera acuse de recibo**: escribe «Mensaje Enviado!!» sin que el equipo haya
confirmado nada. Un comando perdido es indistinguible de uno aplicado.

La unica comprobacion valida es **pedir el volcado** con la trama de lectura y leer lo que
contesta el equipo, campo por campo, contra **la chapa atornillada a esa senal** — no contra
el horario que uno recuerde, ni contra lo que se acaba de teclear. El formato de la respuesta
lo genera `readDevide()` en `Aplicacion.c`.

Y avisa de un detalle del volcado: `readDevide()` imprime las horas con `%d`, sin rellenar con
ceros, asi que las 8:05 salen como `8:5`. No es un fallo de lectura: es como esta escrito.

## 7. Antes de tocar `Serial.c`

Ten presente que ese archivo es la mitad de un contrato cuyo otro extremo esta compilado
dentro de un APK que ya esta instalado en un movil, y que **no se actualiza solo**. Cambiar el
protocolo obliga a reinstalar la app en todos los telefonos que programan senales. Si el
cambio se puede hacer conservando el formato, se hace conservandolo.

Para correr el simulador y leer el resultado, la skill [`verificar`](../verificar/SKILL.md).
Para anadir un escenario nuevo, la skill [`simulador`](../simulador/SKILL.md).

## El retardo entre tramas NO es opcional

El PIC no tiene buffer de tramas. `taskAnalizaUart1` despierta cada milisegundo y, al ver
`flagRx`, espera **5 vueltas** antes de cerrar la trama y copiarla (`Serial.c:122`). Dos
tramas que entren dentro de esa ventana acaban en el **mismo buffer**, y el despachador
—que mira el caracter pegado al `0xBF`— solo atiende a la primera.

**El segundo comando se pierde sin error ni aviso.** Es el modo de fallo mas caro de este
proyecto: la app dice que programo, nadie ve nada raro, y la senal se queda con el horario
viejo hasta que alguien la mire a las 6 de la manana.

| | |
|---|---|
| Minimo medido (arnes, bloque `K`) | **25 ms** |
| Lo que usa la app (`Thread.sleep(450)`) | **450 ms** |

Los 25 ms salen del simulador, donde los bytes entran instantaneos. En el equipo real hay
que sumar el tiempo de hilo: a 9600 baudios una trama de ~25 caracteres son ya unos 26 ms.
**No bajes el retardo de la app** para que "vaya mas rapido": el margen es lo unico que
separa esto de perder comandos en campo.

Si escribes un cliente nuevo —un script, un terminal, una prueba— **espacia las tramas**.
