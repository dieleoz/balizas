# Estado — 22 de agosto de 2026

> Este archivo se reescribe cada sesión. Las cifras viven aquí y **no** en las skills ni en los
> manuales: allí se congelarían y mentirían en días.

## Lo primero, porque gobierna todo lo demás

**Hay dos parejas de binarios, y no se mezclan.** App y firmware se validan y se entregan juntos.

| | Firmware | App |
|---|---|---|
| **v3.3 — la que funcionó en campo** | `1 Firmware/Doc mplabx/build_xc8/main.hex`<br>59.577 B · `c14b4350d960…` | `1 Firmware/Baliza_v3.3.apk`<br>3.859.625 B · `9c37d599deb9…` |
| **Candidata — el trabajo de hoy** | `1 Firmware/BALIZA_18F2550_V1_CORREGIDO.hex`<br>49.201 B · `61e0441df8ce…` | `7 sw apk/Baliza_IT_VIAL_30_v3.4.apk`<br>4.570.283 B · `9864125aba51…` |

La candidata **no ha salido a campo** y no debe salir hasta que pase funcional.

## Cifras de hoy

| Instrumento | Resultado |
|---|---|
| Arnés del firmware (`4 Simulador/correr.py`) | **78 de 78 · PASS** |
| Contrato app↔firmware (`4 Simulador/test_suite_e2e.py`) | **PASS** — por tubería, sin HTTP ni navegador |
| Interfaz (`…/BalizaV10/comprobar_ui.py`) | **PASS** — 51 controles, todos enlazados |
| Flash del PIC | 17.455 B (53,3 %) · RAM 568 B (27,7 %) |
| Compilador | XC8 **v2.36**, `--std=c99`, driver `xc8.exe` |

## Qué se arregló hoy

- **El despachador de tramas.** `Serial.c` elegía comando con `strstr()` sobre el buffer entero:
  un nombre OTA con `L` se perdía y uno con `R` **corrompía el reloj**. Ahora despacha por el
  carácter pegado al `0xBF`. No cambia el protocolo.
- **El 1-Toque grababa el horario de otro colegio** y apagaba la cuarta franja. Sustituido por la
  tarjeta «Horario de esta placa», con cuatro franjas y confirmación previa.
- **Receso escolar**: apagar y reanudar en un toque.
- **El equipo ya dice qué firmware lleva**: `¿L?` abre con `FW 3.4`. Antes todos los binarios
  anunciaban `BALIZA ALARMA V1.0`, incluidos dos que se comportan distinto.
- **Cuatro controles muertos** en la app: se veían, se pulsaban y no hacían nada. Enlazados.
- **Los binarios de la v3.3 no estaban en git** y el paquete de release contenía otro firmware.

## Qué falta, y no depende del escritorio

1. **Revisión funcional** de lo nuevo — horario por placa, receso, OTA, autodiagnóstico,
   checklist, acta. Nada de eso lo ha revisado nadie. **Bloqueante.**
2. **Ver la app en un teléfono.** Aquí no hay emulador Android ni *system images*. Se midió
   contraste, áreas táctiles y responsive, pero **nadie la ha visto en una pantalla real**.
3. **Validar la pareja candidata contra una señal**, comprobando el horario contra la chapa.
4. **Grabar es físico**: el firmware va con PICkit, señal por señal. No llega por Bluetooth.

## Decisión pendiente

**Qué se hace con el emulador web** (`4 Simulador/emulador_app/`). Varias funciones se «vieron
funcionando» en demos sin existir en el APK porque lo que se enseñaba era él. O se mantiene
sincronizado, o se degrada a banco de pruebas del protocolo y se deja de usar para enseñar la
interfaz.

## Lo que ningún instrumento de aquí puede decir

Que la etapa de potencia encienda la luz. Que el DS1307 conserve la hora sin alimentación. Que
el módulo Bluetooth empareje. Y lo que más importa: **que el horario programado coincida con la
chapa atornillada a esa señal**. Eso lo mira una persona con la señal delante.
