# Contexto Operativo y Guía de Traspaso para el Siguiente Agente
**Proyecto:** Baliza Vial «30 CUANDO ACTIVADA» — IT Vial S.A.S.  
**Última Actualización:** 21 de Agosto de 2026  
**Estado General:** ✅ **FIRMWARE Y APP MÓVIL 100% OPERATIVOS Y VALIDADOS EN BANCO REAL**

---

## 1. Resumen Ejecutivo del Proyecto
El sistema controla una **señal de tránsito vial inteligente con baliza LED intermitente** instalada frente a instituciones educativas. Cuando la luz parpadea a **1.0 Hz (500 ms ON / 500 ms OFF)**, el límite legal de velocidad es de **30 km/h**. El horario oficial de activación está impreso físicamente en una placa atornillada a la señal:
```
┌──────────────────────────────────────────────┐
│  Entre  6:00 am  y  9:00 am                  │
│  Entre 11:30 am  y  1:30 pm                  │
│  Entre  3:00 pm  y  4:30 pm                  │
└──────────────────────────────────────────────┘
```

---

## 2. Hardware y Mapeo Real de Pines
* **Microcontrolador:** Microchip **PIC18F2550** a 20 MHz (`FOSC = HS`), memoria Flash 32 KB, RAM 2 KB, EEPROM 256 B.
* **Módulo Bluetooth:** **JDY-31 / HC-06** conectado a la UART del PIC (RC6 TX / RC7 RX) a **9600 baudios 8N1** fijo.
* **Reloj en Tiempo Real (RTC):** **DS1307** por bus I²C (RB0/RB1) con batería de respaldo tipo moneda.
* **Mapeo de Salidas:**
  * `LATC2` $\rightarrow$ Foco LED / Cluster de potencia de la señal (1.0 Hz).
  * `LATC1` $\rightarrow$ Buzzer acústico de confirmación.
  * `LATC0` $\rightarrow$ Entrada de pulsador de servicio.
  * `LATA0` $\rightarrow$ LED de vida / heartbeat del micro.

---

## 3. Binarios Oficiales y Estado de Versiones

| Componente | Versión Actual | Ubicación del Binario | Notas |
|---|---|---|---|
| **App Android** | **v3.3 (`IT VIAL 30`)** | [`1 Firmware/Baliza_v3.3.apk`](1%20Firmware/Baliza_v3.3.apk) | Ícono corporativo «t», branding oficial, horario escolar 1-toque, test de 2 min, tema oscuro blindado. |
| **Firmware PIC** | **v1.0 Corregido** | [`1 Firmware/BALIZA_18F2550_V1_CORREGIDO.hex`](1%20Firmware/BALIZA_18F2550_V1_CORREGIDO.hex) | Cadencia 1.0 Hz, or-alarmas corregido, parser robusto, buzzer en RC1. |
| **Manual de Usuario** | **v3.3 Oficial** | [`Manuales/MANUAL_USUARIO_APP.docx`](Manuales/MANUAL_USUARIO_APP.docx) / [`.md`](Manuales/MANUAL_USUARIO_APP.md) | Manual corporativo formal para cliente e instaladores con 18 capturas HD y guía de batería/diagnóstico. |

---

## 4. Protocolo Serie de Comunicación (ISO-8859-1)
* **Delimitadores:** Inicio `0xBF` (`¿`), fin `0x3F` (`?`), seguidos de `\r\n`.
* **Sincronización de Reloj/Calendario:**  
  `¿R[HHMM],C[DDMMAA-D]?\r\n` (Ej: `¿R1815,C210826-5?\r\n`).
* **Programación de Alarmas (1 a 5):**  
  `¿A[1-5],E[0/1],I[HHMM],F[HHMM],D[8/9/10],?\r\n`  
  * `E1` = Activada, `E0` = Desactivada.
  * `D8` = Diario, `D9` = Lunes a Viernes, `D10` = Sábados y Domingos.
* **Lectura y Volcado Completo:**  
  `¿L?\r\n` $\rightarrow$ El PIC responde con la hora RTC y los 5 registros de alarmas almacenados en la EEPROM interna.

---

## 5. Reglas Mandatorias del Usuario para el Siguiente Agente

1. **Versionado Incremental Estricto:**
   * El usuario solicitó expresamente: *"un favor cada cambio ajusta una v o me pierdo"*.
   * Cada nueva compilación de la app **DEBE incrementar la versión** (`v3.3` $\rightarrow$ `v3.4`) en:
     * `app/build.gradle` (`versionCode` y `versionName`).
     * `activity_main.xml` (texto de versión visible en login).
     * `activity_main2.xml` (texto de versión en consola).
     * Nombre del APK copiado a la raíz: `1 Firmware/Baliza_vX.X.apk`.
2. **Branding e Identidad Corporativa:**
   * **Nombre de la App:** `IT VIAL 30` (en ActionBar y launcher).
   * **Ícono:** Ícono naranja con la letra `t` y punto negro (`@drawable/logo_it_vial_icon` y en `mipmap-*`).
   * **Banner:** `@drawable/logo_it_vial_banner` en la cabecera del login.
   * **Colores de Texto:** Texto estricto en `#212121` (negro) sobre cajas `#F5F7FA` con borde `#CFD8DC`. Nunca permitir que `Theme.DayNight` vuelva las letras blancas en teléfonos con tema oscuro.
3. **Botones de Campo Principales en la App:**
   * **«🏫 Programar Horario Escolar (1 Toque)»**: Sincroniza RTC con hora celular y graba Alarma 1 (06:00-09:00 D9), Alarma 2 (11:30-13:30 D9), Alarma 3 (15:00-16:30 D9), apaga Alarma 4 y 5, y auto-verifica con `¿L?`.
   * **«💡 Activar Test Luz (2 Minutos)»**: Programa Alarma 5 para destellar a 1 Hz por los próximos 2 minutos para pruebas físicas con el foco LED.
   * **«⛔ Apagar Test»**: Envía `¿A5,E0,?` para apagar la prueba de inmediato.
4. **Sincronización Git Inmediata:**
   * Tras cualquier cambio o compilación, realizar `git add`, `git commit` y `git push` a `origin/main`.

---

## 6. Comandos de Compilación y Entorno Local

### A) Compilación del APK Android (Gradle):
```powershell
$env:JAVA_HOME = "D:\@Proyect\Baliza\7 sw apk\jdk-11\jdk-11.0.24+8"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
$env:ANDROID_HOME = "D:\@Proyect\Baliza\7 sw apk\android-sdk"
cd "D:\@Proyect\Baliza\1 Firmware\Doc Aplicativo Movil\BalizaV10"
cmd.exe /c "gradlew.bat assembleDebug"

# Copiar el binario generado
Copy-Item "app\build\outputs\apk\debug\app-debug.apk" "..\..\Baliza_vX.X.apk" -Force
```

### B) Compilación del Firmware PIC18F2550 (XC8 v2.36):
```powershell
cd "D:\@Proyect\Baliza\1 Firmware\Doc mplabx\18f2550_baliza_ V1.X"
"C:\Program Files\Microchip\xc8\v2.36\bin\xc8.exe" --chip=18f2550 --std=c99 --outdir=build main.c Alarma.c Aplicacion.c Buzzer.c Cluster.c DS1307.c EEprom.c I2C.c LedLive.c Serial.c TimeBase.c
```

### C) Banco de Pruebas y Simulador PC:
```powershell
cd "D:\@Proyect\Baliza\4 Simulador"
python correr.py
```
*(Debe pasar las 37 comprobaciones en verde: `0 PASS`).*
