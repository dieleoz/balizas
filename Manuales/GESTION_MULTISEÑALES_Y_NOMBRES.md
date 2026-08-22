# 🌐 ARQUITECTURA DE GESTIÓN REMOTA DE NOMBRES Y MÚLTIPLES SEÑALES
### Despliegue en Campo a Miles de Kilómetros sin Acceso de Fábrica

---

## 1. El Desafío Real en Campo

Cuando las balizas salen de fábrica y se instalan en distintas ciudades o municipios:
1. **No hay cables ni programadores:** El técnico solo tiene su teléfono móvil y la conexión Bluetooth a 10 metros.
2. **Múltiples Técnicos a lo largo del tiempo:** El técnico que instala hoy puede no ser el mismo que haga la inspección dentro de 1 año.
3. **Múltiples Señales en la misma Ciudad:** Un corredor vial puede tener 10, 20 o 50 balizas instaladas.

---

## 2. La Solución Integral: Doble Memoria (Microcontrolador + App Móvil)

```mermaid
flowchart TD
    subgraph "Técnico 1 (Instalación Inicial)"
    App1["📱 App IT VIAL (Técnico 1)"] -->|1. Escribe Nombre:<br/>'Colegio San José - Poste Norte'| App1_DB["💾 Base de Datos Local App"]
    App1 -->|2. Envía Trama por Aire:<br/>¿NCOL SAN JOSE - NORTE?| PIC["⚡ Microcontrolador PIC18F2550"]
    PIC -->|3. Graba en EEPROM (0x40..0x5F)| EEPROM["💾 EEPROM de la Baliza en el Poste"]
    end

    subgraph "Técnico 2 (Mantenimiento a los 6 Meses con OTRO Celular)"
    App2["📱 App IT VIAL (Técnico 2 Nuevo)"] -->|4. Pulsa LEER (¿L?)| PIC
    PIC -->|5. Responde con su Nombre en EEPROM:<br/>'ID: COL SAN JOSE - NORTE'| App2
    App2 -->|6. Genera Reporte Oficial con Nombre Automático| Reporte["📄 Acta de Auditoría con Nombre Exacto"]
    end
```

---

## 3. ¿Cómo Funciona Paso a Paso?

### A. Grabación por el Aire en la EEPROM del PIC (Trama `¿N...`):
* En la memoria no volátil del PIC18F2550 usamos las direcciones `0x40` a `0x5F` (32 bytes libres).
* Desde la App, el técnico toca el campo **«Nombre / Ubicación de la Señal»** y escribe el nombre del colegio o punto vial.
* La app envía la trama:
  $$\mathbf{¿N\text{COLEGIO SAN JOSE - KM 4+200}?}$$
* El PIC responde: `OK_NAME` y queda **grabado para siempre en el poste**.

### B. Lectura Universal por Cualquier Celular:
* Cuando cualquier otro inspector, interventor o técnico de la alcaldía llegue en el futuro y pulse **`LEER`**, el reporte `¿L?` incluirá automáticamente:
  ```text
  ========================================
     ORDEN DE AUDITORÍA Y MANTENIMIENTO   
     SEÑAL: 30 CUANDO ACTIVADA - IT VIAL  
  ========================================
  Ubicación/Colegio:   COLEGIO SAN JOSE - KM 4+200
  Baliza ID (MAC):     98:D3:31:F8:42:0A
  Voltaje Batería 12V: 12.6 V (Carga Óptima)
  Cortes de Energía:   2 cortes acumulados
  ...
  ```

### C. Inventario de Señales en la App (Historial de Rutas):
* La App guarda el historial de todas las balizas visitadas por el técnico:
  * 📍 **Poste 1:** *Col. San José (MAC: ...0A) — 12.6V (OK)*
  * 📍 **Poste 2:** *Col. Gimnasio (MAC: ...2B) — 11.2V (ALERTA BATERÍA)*
  * 📍 **Poste 3:** *Escuela Normal (MAC: ...8C) — 12.8V (OK)*
