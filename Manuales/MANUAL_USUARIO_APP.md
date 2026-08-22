# MANUAL DE USUARIO
# APLICACIÓN MÓVIL IT VIAL 30 (v3.4)
### Sistema de Control, Telemetría y Diagnóstico de Baliza Escolar 30 CUANDO ACTIVADA

![IT VIAL S.A.S - Portada Oficial](img/portada_it_vial_creditos.png)

---

## 1. Introducción y Propósito

El presente manual describe de manera técnica y operativa la instalación, vinculación, configuración, telemetría energética y auditoría del sistema de baliza vial escolar mediante la aplicación móvil oficial **IT VIAL 30 (Versión v3.4)** en teléfonos inteligentes con sistema operativo Android.

La baliza vial gobierna el destello intermitente del foco ámbar de advertencia instalado frente a zonas escolares. **Cuando la luz titila, el límite reglamentario de velocidad de 30 km/h entra en vigor legal.**

![Señal Vial de Referencia](img/senal_vial.jpeg)
*Figura 1: Señal vial reglamentaria «30 CUANDO ACTIVADA» instalada en poste escolar.*

---

> ### REGLA FUNDAMENTAL DEL SISTEMA
> El horario en que debe destellar la baliza **no queda a criterio del instalador**: está grabado físicamente en la placa metálica adosada a la propia señal:
>
> * **Mañana:** 06:00 am a 09:00 am
> * **Mediodía:** 11:30 am a 01:30 pm (13:30)
> * **Tarde:** 03:00 pm (15:00) a 04:30 pm (16:30)
>
> Si la programación del equipo no coincide con la placa física, la señal no cumplirá con la función de protección a los peatones en los horarios estipulados. Todo el procedimiento descrito en este manual garantiza la sincronización exacta entre la placa y la baliza.

![Placa de Horarios](img/placa_horario.jpeg)
*Figura 2: Placa física metálica con los tres horarios oficiales de zona escolar.*

---

## 2. Novedades de la Versión v3.4

1. **Card de Diagnóstico Energético en Tiempo Real:**
   * **Voltímetro Digital de 12V:** Muestra el voltaje real de la batería y panel solar mediante un código de colores intuitivo:
     * 🟢 **Verde ($>12.4\text{ V}$):** Nivel de carga óptimo / Sistema solar en perfecto estado.
     * 🟡 **Amarillo ($11.5 - 12.4\text{ V}$):** Nivel normal de operación.
     * 🔴 **Rojo ($<11.5\text{ V}$):** Alerta preventiva de batería baja o desconexión del panel solar.
2. **Contador de Cortes de Energía y Reinicios en EEPROM:**
   * Registro histórico acumulado de apagones o falsos contactos en bornes/fusibles para mantenimiento preventivo.
3. **Generador y Exportador de Certificados de Auditoría:**
   * Botón **`COMPARTIR CERTIFICADO DE AUDITORÍA`** para enviar el acta formal sellada con fecha, hora, MAC del equipo, voltaje y horarios por **WhatsApp**, correo electrónico o archivo de texto.
4. **Trazabilidad Multidispositivo por Dirección MAC:**
   * Identificación inequívoca de cada poste y señal a lo largo de corredores viales extensos.

---

## 3. Requisitos Previos

Antes de iniciar la configuración en campo o banco de pruebas, asegúrese de contar con:

* **Teléfono Móvil Android:** Compatible con versiones desde Android 6.0 hasta Android 14+.
* **Bluetooth Activado:** Con adaptador inalámbrico en funcionamiento.
* **Instalador de la Aplicación:** Archivo instalador `Baliza_v3.4.apk` suministrado por **IT VIAL S.A.S**.
* **Baliza Energizada:** Tarjeta y equipo conectados a su fuente de energía (12 VDC / Batería / Panel solar).
* **Distancia de Trabajo:** Ubicarse a una distancia recomendada de entre 1 y 10 metros del poste para una óptima recepción.

---

## 4. Guía Paso a Paso de Instalación y Uso

---

### PASO 1: Instalación de la Aplicación (Baliza_v3.4.apk)

#### 1.1 Selección del Instalador de Paquetes
1. Reciba o descargue el archivo instalador oficial `Baliza_v3.4.apk` en su dispositivo móvil.
2. Toque el archivo `.apk` para iniciar el proceso de instalación de Android.
3. En la ventana emergente **«Abrir con»**, seleccione **«Instalador de paquetes»** y presione **«Solo una vez»** o **«Siempre»**.

![Paso 1.1 - Selección de Instalador de Paquetes](img/paso1_instalacion_apk.png)
*Figura 3: Selección del «Instalador de paquetes» de Android.*

#### 1.2 Confirmación de Instalación y Permisos
1. Toque el botón **«Instalar»** en la parte inferior derecha.
2. Android puede mostrar una advertencia de seguridad indicando que la aplicación proviene de una fuente externa. Toque **«Instalar de todos modos»** o **«Más detalles -> Instalar de todas formas»**.
3. Al finalizar, presione **«Abrir»** para iniciar la aplicación.

![Paso 1.2 - Confirmación de Instalación](img/paso1_confirmacion_instalacion.png)
*Figura 4: Diálogo de instalación de la aplicación.*

---

### PASO 2: Vinculación Bluetooth con el Módulo JDY-31

> **NOTA TÉCNICA:** La primera vez que configure un teléfono con una baliza, debe emparejar el módulo Bluetooth desde los Ajustes del sistema de Android antes de conectarse en la app.

1. Ingrese a **Ajustes** -> **Bluetooth** en su teléfono móvil.
2. Active el Bluetooth y presione **«Buscar dispositivos»**.
3. En la lista de dispositivos disponibles aparecerá el módulo con el nombre **`JDY-31-SPP`** (o el nombre corporativo asignado por IT VIAL).
4. Toque sobre **`JDY-31-SPP`**.
5. Cuando el sistema solicite el PIN de emparejamiento, ingrese el código de fábrica:
   $$\mathbf{1234}$$
6. Presione **«Aceptar»**. El dispositivo quedará registrado en la lista de «Dispositivos vinculados».

![Paso 2 - Vinculación Bluetooth](img/paso2_vinculacion_bluetooth.png)
*Figura 5: Vinculación Bluetooth del módulo JDY-31 ingresando el PIN 1234.*

---

### PASO 3: Selección y Conexión del Dispositivo en la App

1. Abra la aplicación **IT VIAL 30 (v3.4)**.
2. En la barra superior, presione el botón rojo **`DISPOSITIVO`**.
3. Se abrirá la lista de dispositivos Bluetooth emparejados.
4. Seleccione **`JDY-31-SPP`** (junto con su dirección MAC).
5. Tras unos instantes, el botón cambiará a color verde con la etiqueta:
   $$\mathbf{\checkmark\ JDY-31-SPP}$$
   indicando que el enlace inalámbrico está activo y listo para transmitir.

![Paso 3 - Selección del Dispositivo](img/paso3_seleccion_dispositivo.png)
*Figura 6: Lista de selección del dispositivo Bluetooth JDY-31.*

---

### PASO 4: Lectura de Diagnóstico y Telemetría

1. Con el dispositivo conectado, presione el botón azul **`LEER`**.
2. La aplicación consultará a la baliza y desplegará en la consola y en la tarjeta de telemetría:
   * **Voltaje de Batería 12V:** Lectura en tiempo real con barra de color de estado.
   * **Contador de Cortes:** Número acumulado de reinicios en la memoria EEPROM.
   * **Hora y Fecha del Reloj RTC:** Verifique que la hora coincida con la hora local.
   * **Estado de las 5 Alarmas:** Muestra si están en `ON` u `OFF`, hora de inicio, hora de fin y días asignados.

![Paso 4 - Lectura de Datos](img/paso4_lectura_datos.png)
*Figura 7: Despliegue de telemetría y horarios en la consola de la aplicación.*

---

### PASO 5: Programación con 1-Toque (Horario Escolar Oficial)

> **MÉTODO RECOMENDADO POR IT VIAL:** Para garantizar el cumplimiento exacto de la señal reglamentaria, utilice el botón de acceso directo de 1-Toque.

1. Presione el botón azul oscuro:
   $$\mathbf{\text{Programar Horario Escolar (1 Toque)}}$$
2. La aplicación ejecutará automáticamente la siguiente secuencia certificada:
   * **Sincronización de Reloj:** Actualiza el reloj RTC de la baliza con la hora y fecha exactas del teléfono móvil.
   * **Alarma 1 (Mañana):** Programa de `06:00` a `09:00` en modo `Lunes a Viernes`.
   * **Alarma 2 (Mediodía):** Programa de `11:30` a `13:30` en modo `Lunes a Viernes`.
   * **Alarma 3 (Tarde):** Programa de `15:00` a `16:30` en modo `Lunes a Viernes`.
   * **Alarmas 4 y 5:** Las apaga automáticamente para evitar conflictos.
3. La consola confirmará la recepción de cada parámetro en la memoria EEPROM.

![Paso 5 - Botón Horario Escolar](img/paso5_boton_horario_escolar.png)
*Figura 8: Botón de programación rápida de Horario Escolar Oficial.*

---

### PASO 6: Prueba de Destello de Luz (Mando Directo)

Para validar que los focos LED ámbar, el cableado de potencia y los relevadores/MOSFETs están funcionando físicamente en el poste sin esperar a que llegue la hora de la alarma:

1. Presione el botón amarillo:
   $$\mathbf{\text{Activar Test Luz (2 Minutos)}}$$
2. El foco ámbar de la señal vial comenzará a parpadear a la cadencia reglamentaria de **1.0 Hz** (500 ms encendido / 500 ms apagado).
3. Para finalizar la prueba antes de los 2 minutos, presione **`Apagar Test`**.

![Paso 6 - Botones de Prueba de Luz](img/paso6_botones_test_luz.png)
*Figura 9: Botones de control manual de destello para pruebas en campo.*

---

### PASO 7: Exportación del Certificado de Auditoría

1. Una vez realizada la lectura o programación, presione el botón:
   $$\mathbf{\text{COMPARTIR CERTIFICADO DE AUDITORÍA}}$$
2. La aplicación abrirá el menú de compartir de Android.
3. Seleccione **WhatsApp**, **Gmail**, **Drive** o **Guardar como archivo**.
4. Se enviará el reporte técnico formal con la siguiente estructura:

```text
========================================
   CERTIFICADO DE AUDITORÍA VIAL SR30   
   SEÑAL: 30 CUANDO ACTIVADA - IT VIAL  
========================================
Baliza Vial ID:       JDY-31-SPP (Oficial)
Dirección MAC:        98:D3:31:F8:42:0A
Fecha de Inspección:  22/08/2026 11:51:30
Voltaje Batería 12V:  12.6 V (Carga Óptima)
Cortes de Energía:    2 cortes acumulados
Estado EEPROM:        100% Íntegra
----------------------------------------
REGISTRO DE HORARIOS EN BALIZA:
 1   - 06:00 - 09:00 - ON  - Lun a Vie
 2   - 11:30 - 13:30 - ON  - Lun a Vie
 3   - 15:00 - 16:30 - ON  - Lun a Vie
 4   - 00:00 - 00:00 - OFF - Dia
 5   - 00:00 - 00:00 - OFF - Dia
========================================
Generado por: App IT VIAL 30 (v3.4 Oficial)
```

---

## 5. Tabla de Códigos de Alerta y Solución de Problemas

| Síntoma Observado | Causa Probable | Acción Correctiva |
|---|---|---|
| **Botón Dispositivo no cambia a Verde** | Bluetooth apagado o baliza sin energía. | Verifique que la baliza tenga 12V y que el módulo `JDY-31-SPP` esté vinculado con PIN `1234`. |
| **Voltaje en Rojo ($<11.5\text{ V}$)** | Batería descargada o panel solar desconectado. | Revisar fusible de panel solar, sulfatación de bornes y medir tensión de carga en bornes de batería. |
| **Contador de Cortes Elevado ($>15$)** | Falso contacto en cables de alimentación o fusible suelto. | Ajustar tornillos de borneras y revisar el portafusible aéreo. |
| **La luz no parpadea a la hora escolar** | Reloj desfasado o fecha errónea. | Conéctese a la app y presione **`Programar Horario Escolar (1 Toque)`** para sincronizar reloj y horarios. |
| **Comando Test no enciende el foco** | Foco desconectado o fusible de potencia abierto. | Revisar la conexión del foco al terminal `LATC2` / Bornera de carga de 12V. |

---

## 6. Contacto y Soporte Técnico

**IT VIAL S.A.S — Señalización y Seguridad Vial Inteligente**  
* **Soporte Técnico:** soporte@itvial.com  
* **Página Web:** [www.itvial.com](http://www.itvial.com)  
* **Versión del Documento:** v3.4 — Agosto 2026
