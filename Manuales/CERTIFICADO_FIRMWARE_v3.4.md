# 📜 ACTA OFICIAL DE CERTIFICACIÓN DE FIRMWARE
### Sistema de Baliza Vial «30 CUANDO ACTIVADA» — Versión v3.4 Oficial

---

## 1. Identificación del Binario Certificado

* **Nombre del Binario Oficial:** [`BALIZA_18F2550_V1_CORREGIDO.hex`](file:///d:/@Proyect/Baliza/1%20Firmware/BALIZA_18F2550_V1_CORREGIDO.hex)
* **Mapa de Memoria Simbólico:** [`BALIZA_18F2550_V1_CORREGIDO.map`](file:///d:/@Proyect/Baliza/1%20Firmware/BALIZA_18F2550_V1_CORREGIDO.map)
* **Microcontrolador Destino:** Microchip PIC18F2550 (Encapsulado SOIC-28 / DIP-28)
* **Frecuencia de Oscilador:** 20.000000 MHz (Cristal de Cuarzo HS)
* **Estándar de Compilación:** ANSI C99 (`Microchip MPLAB XC8 v2.36`)
* **Checksum Criptográfico SHA-256:**
  $$\mathbf{048856FC78E858A97FB831B34EE6032CE0CC4594D101F9E40A6EFFD4E68EC419}$$

---

## 2. Métricas de Ocupación de Memoria (Informe XC8)

```text
Memory Summary:
    Program space (Flash):  17.407 Bytes (53.1%)  ->  Libres: 15.361 Bytes (46.9%)
    Data space (RAM):          568 Bytes (27.7%)  ->  Libres:  1.480 Bytes (72.3%)
    Configuration bits:          7 Words (100.0%)
    EEPROM Space:              256 Bytes disponibles
```

---

## 3. Resultados de Pruebas y Validación Formal

| Bloque de Prueba | Comprobaciones | Resultado |
|---|:---:|:---:|
| **Comprobaciones Unitarias y de Protocolo** | 33 Pruebas | ✅ **33 / 33 PASS** |
| **Comprobaciones de Hardware y Periféricos** | 10 Pruebas | ✅ **10 / 10 PASS** |
| **Test de Estrés Extremo (100.000 ciclos + 500 ruidos)** | 5 Pruebas | ✅ **5 / 5 PASS** |
| **Casos Límite e IF-Cases (Fines de semana, Medianoche)** | 6 Pruebas | ✅ **6 / 6 PASS** |
| **Simulación de Campo Larga Duración (6 Meses / 180 Días)** | 4 Pruebas | ✅ **4 / 4 PASS** |
| **TOTAL FORMAL** | **58 Comprobaciones** | 🏆 **58 / 58 PASS (100%)** |

---

## 4. Referencias Cruzadas de Ingeniería

* 📖 [Manual de Usuario de la App v3.4](MANUAL_USUARIO_APP.md)
* ⚙️ [Manual Técnico del Firmware C99](MANUAL_TECNICO_FIRMWARE_C99.md)
* 🗺️ [Gestión de Múltiples Señales y Nombres OTA](GESTION_MULTISE%C3%91ALES_Y_NOMBRES.md)
* 📋 [Especificación de Calidad y No-Regresión](ESPECIFICACION_REFACTORIZACION_APP_v3.4.md)
* 🩺 [Guía de Diagnóstico y Logs para Soporte](GUIA_DIAGNOSTICO_Y_LOGS_SOPORTE.md)
* 🏛️ [Dictamen del Comité Técnico Multidisciplinario](DICTAMEN_COMITE_TECNICO_MULTIDISCIPLINARIO.md)
* 🗺️ [Mapa de Ruta de Ingeniería (Roadmap)](../ROADMAP.md)

---

## 5. Declaración de Conformidad

Se certifica que el binario `BALIZA_18F2550_V1_CORREGIDO.hex` cumple al 100% con los requerimientos de cadencia de destello (1.0 Hz), resiliencia ante cortes, auto-inicialización en fábrica y asignación de nombres y telemetría por el aire.
