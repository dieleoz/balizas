# Restricciones de Desarrollo — App Android «IT VIAL 30»

**Última actualización:** 22 de Agosto de 2026  
**Documento de observancia obligatoria para cualquier desarrollador o agente de IA.**

Este documento consolida las restricciones técnicas, de hardware, ergonomía de campo y compilación aprendidas y validadas en campo para la aplicación Android de control de la baliza vial escolar.

---

## 1. ⏱️ Restricción Crítica de Hardware: Pacing UART (450 ms)

* **El Problema:** El microcontrolador **PIC18F2550** no dispone de cola de mensajes ni buffer circular de tramas entrantes. Su rutina `taskAnalizaUart1` muestrea el puerto serie cada 1 ms y espera 5 ciclos de inactividad antes de procesar y vaciar el buffer (`Serial.c:122`).
* **La Restricción:** Al enviar múltiples tramas consecutivas (como la ráfaga de 4 franjas + sincronización de reloj), **ES OBLIGATORIO** insertar un retardo mínimo de **450 ms** entre cada trama (`RETARDO_TRAMA_MS = 450`).
* **Consecuencia de violar la regla:** Si se envían tramas continuas sin retardo, el PIC junta los comandos en un solo buffer y descarta el segundo comando silenciosamente **sin emitir ningún error**, dejando a la baliza descalibrada.

---

## 2. 📱 Restricciones de Layout y Tipografía en Pantallas Angostas (360dp)

Los técnicos en campo utilizan teléfonos Android de gama media/baja con pantallas de 360dp de ancho bajo luz solar directa:

1. **Cero saltos de línea indeseados en botones:**
   * Todos los botones con texto sensible (botones de hora, acciones principales, receso, test de foco) **DEBEN** declarar:
     ```xml
     android:maxLines="1"
     android:singleLine="true"
     android:paddingStart="2dp"
     android:paddingEnd="2dp"
     ```
   * Evita saltos de texto antiestéticos observados en campo como `06:0 \n 0` en lugar de `06:00` o `CONFIG \n G` en lugar de `CONFIG`.
2. **Tamaños de Tipografía Recomendados:**
   * Botones de hora (Inicio / Fin): `14sp` (bold).
   * Botones de acción en barras horizontales: `12sp` (bold).
   * Interruptores (`SwitchCompat`): `minWidth="44dp"`, texto `14sp`.
   * Todo tamaño de fuente **DEBE** declararse en `sp`, nunca en `dp`.
3. **Áreas táctiles mínimas (WCAG 2.5.5 / Material Design):**
   * Todos los controles interactivos deben tener `minHeight="48dp"` para facilitar el toque con una sola mano o con guantes.
4. **Contenedor Principal:**
   * La pantalla completa debe estar contenida en un `ScrollView` vertical para garantizar que ningún control quede fuera del alcance en teléfonos de pantalla corta.

---

## 3. 🛡️ Cero «Controles Muertos» (Regla de Enlace Obligatorio)

* **La Regla:** No se permite declarar ningún control interactivo (`Button`, `EditText`, `Switch`, `CheckBox`, `Spinner`) en el XML de layout con `android:id` sin que esté debidamente enlazado mediante `findViewById` y con su listener activo en el código Java (`MainActivity2.java`).
* **Validación Obligatoria:** Antes de dar por terminado cualquier cambio de interfaz, se debe ejecutar:
  ```bash
  python "1 Firmware/Doc Aplicativo Movil/BalizaV10/comprobar_ui.py"
  ```
  El resultado debe ser **PASS (100% de controles enlazados)**.

---

## 4. 🖲️ Ergonomía de Tarjetas: Botones de Acción Directa

* Cada tarjeta funcional (ej. *Programación Manual*, *Identificador de Baliza*, *Checklist de Mantenimiento*) **DEBE contener su propio botón de acción** al pie de la misma (ej. `⚡ ENVIAR Y GRABAR ESTA FRANJA`, `GUARDAR`, `COMPARTIR ACTA`).
* **Prohibido:** Obligar al usuario a configurar campos en la parte inferior de la pantalla y tener que desplazarse con scroll hacia arriba para presionar un botón genérico en la barra superior.

---

## 5. 👁️ Consola de Telemetría Siempre Visible

* La pantalla superior de telemetría / consola UART (fondo azul marino `#0F172A`, texto verde `#22C55E`) **DEBE permanecer visible en la parte superior** para que el operador tenga confirmación visual en tiempo real de los bytes transmitidos y de las respuestas del PIC (`ID:`, `Bat:`, `Cortes:`, `Al1..Al5`).
* Nunca ocultar la consola en menús colapsables ni pestañas escondidas.

---

## 6. 💾 Persistencia de Datos de Campo (`SharedPreferences`)

* **Nombre del Técnico / Inspector:** Debe persistir automáticamente en `SharedPreferences("BalizasDB")` al escribirlo. El técnico no debe tener que reescribir su nombre en cada poste de la ruta de mantenimiento.
* **Nombres de Balizas:** Se asocian a la dirección MAC del módulo Bluetooth para autocompletar la identificación al reconectar.

---

## 7. ☕ Cadena de Compilación Estricta (JDK 11)

* **Entorno Obligatorio:**
  * **JDK:** OpenJDK 11.0.24 (Ubicado en `7 sw apk/jdk-11/jdk-11.0.24+8`).
  * **Android SDK:** Ubicado en `7 sw apk/android-sdk`.
  * **Gradle:** 6.5 con Android Gradle Plugin (AGP) 4.1.0.
  * **SDK Levels:** `compileSdkVersion 30`, `minSdkVersion 16`, `targetSdkVersion 30`.
* **Prohibición:** No intentar compilar con JDK 17 o JDK 21. AGP 4.1.0 falla con excepciones de `InaccessibleObjectException` / JVM Reflection.
* **Comando de Compilación Offline:**
  ```powershell
  $env:JAVA_HOME="D:\@Proyect\Baliza\7 sw apk\jdk-11\jdk-11.0.24+8"
  $env:ANDROID_HOME="D:\@Proyect\Baliza\7 sw apk\android-sdk"
  $env:ANDROID_SDK_ROOT=$env:ANDROID_HOME
  $env:PATH="$env:JAVA_HOME\bin;$env:PATH"
  & "1 Firmware\Doc Aplicativo Movil\BalizaV10\gradlew.bat" -p "1 Firmware\Doc Aplicativo Movil\BalizaV10" assembleDebug --offline
  ```

---

## 8. 🌐 Paridad 100% entre APK y Emulador Web

* Toda función demostrada en el emulador web (`index.html`) **debe existir y funcionar idénticamente en el APK Android**.
* Ninguna funcionalidad se considera completada si solo existe en la demo web sin respaldo en el binario nativo de Android.
