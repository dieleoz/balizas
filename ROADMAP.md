# ROADMAP — Baliza Inteligente IT VIAL 30 (v3.4)

Plan de ingeniería, estado de cumplimiento técnico y registro de validaciones de hardware y software.

Estado vivo del proyecto: [`Manuales/CERTIFICADO_FIRMWARE_v3.4.md`](Manuales/CERTIFICADO_FIRMWARE_v3.4.md).

---

## 1. Resumen Ejecutivo de Cumplimiento

```
1. SIMULADOR          →  2. RESTRICCIONES HW    →  3. REFACTORIZACIÓN C99  →  4. APP v3.4 & CERTIFICACIÓN
   58/58 tests PASS         Pinout, I2C y UART        Flash: 52.6% / RAM: 27.7%   Telemetría & Auditoría
   (100% Cobertura)         Validados en Banco        Cero cuelgues (WDT/ISR)     100.000 Ciclos Estrés
```

---

## Fase 0 — Desbloqueo y Validación del Enlace Físico

- [x] **0.1 · Módulo Bluetooth SIG0109A / JDY-31:**
  * Baudios confirmados: 9600 8N1 sin necesidad de comandos AT.
  * Comunicación bidireccional probada en banco con respuesta de tramas `¿L?`.
  * Validación de PIN de fábrica: `1234`.
- [x] **0.2 · Reasignación de Pines y Periféricos:**
  * Buzzer mapeado a `LATC1` / `TRISC1 = 0`.
  * Entrada auxiliar mapeada a `TRISC0 = 1`.
  * Foco de advertencia (Cluster) gobernado por `LATC2`.

---

## Fase 1 — Arnés de Simulación Integral y Baterías de Fatiga

- [x] **1.1 · Arnés Formal en C (`4 Simulador/arnes.c`):**
  * 58 comprobaciones formales pasando al 100% en verde.
- [x] **1.2 · Batería de Fatiga y Estrés Extremo (100.000 Ciclos):**
  * 100.000 ticks continuos sin desbordamiento ni fallas de temporización.
  * Inyección masiva de 500 tramas de ruido/basura serie con recuperación silenciosa en 1.000 ms.
  * 50 ciclos de reprogramación en ráfaga sin colisión en EEPROM.
- [x] **1.3 · Simulación de Larga Duración en Campo (6 Meses / 180 Días):**
  * Recorrido de 180 días de calendario con verificación de días hábiles vs fines de semana.
  * Registro exacto de 25 cortes semanales en la dirección `0x36-0x37` de la EEPROM.

---

## Fase 2 — Refactorización y Blindaje del Firmware (C99 / XC8)

- [x] **2.1 · Protección Anti-Bloqueo I2C (`I2C.c`):**
  * Timeout de seguridad de 5.000 ciclos en `I2C_Master_Wait()` que previene cuelgues si falla el DS1307.
- [x] **2.2 · Soft UART Inactivity Timeout (`Serial.c`):**
  * Descarte silencioso de tramas truncadas tras 1.000 ms sin bloquear la máquina de estados ni apagar la luz.
- [x] **2.3 · Streaming Directo en UART (`Serial.c`):**
  * Transmisión por punteros sin búferes locales de pila, ahorrando 100 bytes de RAM y eliminando `strlen/strncpy`.
- [x] **2.4 · Aritmética de Punto Fijo en ADC (`Aplicacion.c`):**
  * Eliminación completa de librerías de punto flotante (`float`), reduciendo la Flash a **17.237 Bytes (52.6%)** y RAM a **568 Bytes (27.7%)**.
- [x] **2.5 · Saneamiento de Interrupciones y Watchdog (`main.c`):**
  * Eliminado `__delay_ms(4000)` y `printf` de la ISR. Refresco de `ClrWdt()` en el bucle principal.

---

## Fase 3 — App Móvil IT VIAL 30 (v3.4)

- [x] **3.1 · Diagnóstico Energético en Tiempo Real:**
  * Voltímetro visual dinámico de 12V con colores de alerta (Verde $>12.4\text{V}$, Amarillo $11.5-12.4\text{V}$, Rojo $<11.5\text{V}$).
- [x] **3.2 · Contador de Cortes de Energía y Salud EEPROM:**
  * Indicador de cortes acumulados reportados en la trama `¿L?` (`Bat: 12.6V | Cortes: X`).
- [x] **3.3 · Programación con 1-Toque (Horario Escolar Oficial):**
  * Sincronización automática de reloj RTC y grabación de alarmas 1, 2 y 3 en modo Lunes a Viernes.
- [x] **3.4 · Generador y Exportador de Certificados de Auditoría:**
  * Botón **`COMPARTIR CERTIFICADO DE AUDITORÍA`** con dirección MAC única y fecha/hora para entrega formal a interventorías por WhatsApp/Correo.
- [x] **3.5 · Suite Automatizada E2E Headless (`4 Simulador/test_suite_e2e.py`):**
  * Validación programática en 2 segundos de todos los flujos de la app contra el backend en C.

---

## Fase 4 — Entregables y Paquete de Producción

- [x] **Binario `.hex` Certificado:** [`1 Firmware/BALIZA_18F2550_V1_CORREGIDO.hex`](1%20Firmware/BALIZA_18F2550_V1_CORREGIDO.hex) (SHA-256: `F1768F4055A819AE7FD80F33C5081D18B448D5EFED24358E29730836E12B8742`).
- [x] **Manual de Usuario de la App:** [`Manuales/MANUAL_USUARIO_APP.md`](Manuales/MANUAL_USUARIO_APP.md) (v3.4).
- [x] **Manual Técnico de Firmware C99:** [`Manuales/MANUAL_TECNICO_FIRMWARE_C99.md`](Manuales/MANUAL_TECNICO_FIRMWARE_C99.md).
- [x] **Acta Oficial de Certificación:** [`Manuales/CERTIFICADO_FIRMWARE_v3.4.md`](Manuales/CERTIFICADO_FIRMWARE_v3.4.md).
- [x] **Tag de Release en Git:** [`v3.4-firmware-estable`](https://github.com/dieleoz/balizas/releases/tag/v3.4-firmware-estable).
