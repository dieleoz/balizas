# Compilar la app Android — cadena, dependencias y trampas

**La versión del compilador y sus banderas son parte del entregable** (regla 4 del proyecto).
Para el firmware eso ya estaba escrito; para la app faltaba, y esta es la pieza que faltaba.

Todo lo que sigue está **leído de los ficheros del proyecto o de la salida de las herramientas**,
no de memoria.

---

## 1. La cadena, con versiones exactas

| Pieza | Versión | De dónde sale el dato |
|---|---|---|
| **JDK** | **OpenJDK 11.0.24** (Temurin `11.0.24+8`) | `java -version` del JDK que se usa |
| **Gradle** | **6.5** | `gradle/wrapper/gradle-wrapper.properties` |
| **Android Gradle Plugin** | **4.1.0** | `build.gradle` raíz |
| **compileSdk** | **30** | `app/build.gradle` |
| **buildTools** | **30.0.3** | `app/build.gradle` |
| **minSdk** | **16** (Android 4.1) | `app/build.gradle` |
| **targetSdk** | **30** (Android 11) | `app/build.gradle` |
| **Compatibilidad de fuente** | **Java 8** | `compileOptions` |
| **versionCode / versionName** | **34 / «3.4»** | `app/build.gradle` |

> **El JDK 11 no es intercambiable.** AGP 4.1 con Gradle 6.5 **no arranca con JDK 17 o 21**: falla
> al inicializar el daemon. En `7 sw apk/` hay descargados un JDK 17 y un JDK 21 de intentos
> anteriores — **no son los buenos**. El que compila es `jdk-11`.

## 2. Dependencias

De `app/build.gradle`:

```gradle
implementation 'androidx.appcompat:appcompat:1.3.1'
implementation 'com.google.android.material:material:1.3.0'
implementation 'androidx.constraintlayout:constraintlayout:2.0.4'
testImplementation 'junit:junit:4.+'
androidTestImplementation 'androidx.test.ext:junit:1.1.2'
androidTestImplementation 'androidx.test.espresso:espresso-core:3.3.0'
```

Hay un bloque comentado justo encima con versiones más nuevas (appcompat 1.4.1, material 1.5.0,
constraintlayout 2.1.3). **Está comentado a propósito**: esas versiones piden un AGP más nuevo que
el 4.1.0 que usa este proyecto. No lo descomentes sin subir también AGP y Gradle, y sin volver a
medir.

`junit:junit:4.+` es un **rango abierto**: dos compilaciones en fechas distintas pueden traer JUnit
distinto. No afecta al APK que sale a campo (es sólo de test), pero es una fuente de
irreproducibilidad que conviene fijar si algún día se toca.

## 3. Cómo se compila

Las rutas del proyecto **llevan espacios** (`1 Firmware`, `7 sw apk`) y eso rompe a `gradlew.bat`
si se le invoca por nombre relativo. Hay que llamarlo **por ruta absoluta y entrecomillada**:

```bat
@echo off
set "JAVA_HOME=D:\@Proyect\Baliza\7 sw apk\jdk-11\jdk-11.0.24+8"
set "ANDROID_HOME=D:\@Proyect\Baliza\7 sw apk\android-sdk"
set "ANDROID_SDK_ROOT=%ANDROID_HOME%"
set "PATH=%JAVA_HOME%\bin;%PATH%"
cd /d "D:\@Proyect\Baliza\1 Firmware\Doc Aplicativo Movil\BalizaV10"
call "D:\@Proyect\Baliza\1 Firmware\Doc Aplicativo Movil\BalizaV10\gradlew.bat" assembleDebug --offline
```

El APK sale en `app/build/outputs/apk/debug/app-debug.apk` y se copia a
`7 sw apk/Baliza_IT_VIAL_30_v3.4.apk`.

### Las cuatro trampas, todas medidas

1. **`gradlew.bat` por nombre no se encuentra.** Con `cd` correcto y todo, `cmd` no lo resuelve por
   los espacios de la ruta. Se llama por ruta absoluta completa.
2. **`--offline` es obligatorio si no hay red**, y con él **`lintDebug` no corre**: las
   dependencias de test (`espresso`, `androidx.test.ext:junit`) no están en la caché. Compilar sí
   funciona; sólo lint se queda fuera.
3. **El tamaño del APK varía entre compilaciones sin que cambie el contenido.** Se han visto
   6.066.074, 3.869.517 y 6.080.041 bytes con **las mismas 695 entradas y el mismo tamaño
   descomprimido** (6.809.576 B). Es sólo compresión. **No te alarmes por el tamaño: compara el
   contenido.**
4. **`assembleDebug` firma con la clave de depuración** (`CN=Android Debug`). Los APK que hay hoy
   en campo también, así que no es una regresión — pero para una versión que se distribuye lo
   suyo sería una compilación de release firmada.

## 4. Comprobar la interfaz sin teléfono

```bash
python "1 Firmware/Doc Aplicativo Movil/BalizaV10/comprobar_ui.py"
```

Mide sobre el layout, sin renderizar nada:

* **Contraste WCAG 2.1** de cada par de colores que se usa de verdad (AA: 4,5:1 texto normal,
  3,0:1 texto grande).
* **Áreas táctiles ≥ 48dp** (Material Design y WCAG 2.5.5).
* **Responsive**: sin anchos fijos en dp, texto en `sp`, todo dentro de un `ScrollView`.

> ### Lo que esto NO dice
>
> **No sustituye a mirar la app en un teléfono.** No renderiza: no ve solapes, no ve el aspecto
> real bajo el sol, no prueba el flujo con una persona delante. En esta máquina **no hay
> *system images* de Android**, así que tampoco se puede levantar un emulador. La validación
> visual está pendiente y la tiene que hacer alguien con el teléfono en la mano.

---

## Referencias

* Arquitectura de la app y protocolo: [`APP_MOVIL.md`](APP_MOVIL.md)
* Manual de campo: [`MANUAL_USUARIO_APP.md`](MANUAL_USUARIO_APP.md)
* Compilar el firmware del PIC: [`COMPILAR_Y_GRABAR.md`](COMPILAR_Y_GRABAR.md)
* Qué falta y en qué orden: [`../ROADMAP.md`](../ROADMAP.md)
