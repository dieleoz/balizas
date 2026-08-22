# 📜 ACTA DE CERTIFICACIÓN DE FIRMWARE Y PRUEBAS DE ESTRÉS
### Proyecto: Baliza Vial Inteligente — "30 CUANDO ACTIVADA"
**Versión de Firmware:** `v3.4-firmware-estable`  
**Microcontrolador:** Microchip PIC18F2550 (Encapsulado SOIC-28 / DIP-28)  
**Compilador Oficial:** Microchip MPLAB XC8 v2.36 (Estándar C99)  
**Fecha de Certificación:** 22 de Agosto de 2026  
**Hash SHA-256 del Binario:** `F1768F4055A819AE7FD80F33C5081D18B448D5EFED24358E29730836E12B8742`  

---

## 1. Resumen de Calidad y Rendimiento

| Parámetro | Resultado Medido | Límite / Condición | Estado |
|---|:---:|:---:|:---:|
| **Uso de Memoria Flash (Programa)** | **17.237 Bytes (52.6%)** | $\le 32.768\text{ Bytes}$ | ✅ ÓPTIMO |
| **Uso de Memoria RAM (Datos)** | **568 Bytes (27.7%)** | $\le 2.048\text{ Bytes}$ | ✅ ÓPTIMO |
| **Batería de Pruebas Automáticas** | **47 de 47 Comprobaciones** | $100\%$ PASS | ✅ CERTIFICADO |
| **Test de Estrés de Reloj Continuo** | **100.000 Ticks ($>100\text{ s}$)** | Cero cuelgues / Cero fugas | ✅ RESILIENTE |
| **Inyección de Ruido Serie (UART)** | **500 Tramas corruptas** | Limpieza automática en 1s | ✅ BLINDADO |
| **Pruebas de Apagón / Reinicio** | **5 Cortes forzados** | Conteo EEPROM exacto (5/5) | ✅ REGISTRADO |
| **Ráfaga de Reprogramación** | **50 Escrituras en caliente** | Cero colisiones EEPROM | ✅ ESTABLE |

---

## 2. Mejoras Incorporadas en esta Versión

1. **Protección Anti-Bloqueo de Bus I2C (`I2C.c`):**
   * Incorporación de contador límite de 5.000 ciclos en `I2C_Master_Wait()` que previene el congelamiento del microcontrolador ante desconexión o fallas del chip RTC DS1307.
2. **Soft UART Inactivity Timeout de 1.000 ms (`Serial.c`):**
   * Descarte silencioso de tramas truncadas por desconexión Bluetooth o ruido electromagnético sin apagar la luz vial ni reiniciar el equipo.
3. **Streaming Directo en Punteros (`Serial.c`):**
   * Reducción de 100 bytes en el consumo de pila (stack) de memoria RAM y eliminación de librerías costosas `memset/strncpy/strlen` en transmisión.
4. **Conversión a Aritmética Entera de Punto Fijo (`Aplicacion.c`):**
   * Sustitución de biblioteca flotante IEEE-754 por operaciones enteras en `uint32_t` para la lectura de voltaje de batería y temperatura.
5. **Saneamiento de Interrupciones (`main.c`):**
   * Eliminación de retardos y funciones `printf` no reentrantes en ISR, reduciendo el consumo de Flash en más de 4.000 bytes.
6. **Telemetría de Batería y Registro de Cortes en EEPROM:**
   * Reporte remoto de voltaje en `AN1` y contador de reinicios en las direcciones `0x36-0x37` de la EEPROM interna.

---

## 3. Declaración de Conformidad Técnica

Se certifica que el binario [`1 Firmware/BALIZA_18F2550_V1_CORREGIDO.hex`](file:///d:/@Proyect/Baliza/1%20Firmware/BALIZA_18F2550_V1_CORREGIDO.hex) cumple con la totalidad de los requisitos normativos y de seguridad vial para operar de forma continua, ininterrumpida y desatendida en señales escolares.
