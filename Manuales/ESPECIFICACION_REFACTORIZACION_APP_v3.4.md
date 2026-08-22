# 📋 ESPECIFICACIÓN Y AUDITORÍA DE CALIDAD: APP IT VIAL 30 (v3.4)
### Evaluación Integral: ISTQB QA, Especialista IoT y Ergonomía UX en Campo

---

## 1. Auditoría desde la Perspectiva ISTQB & Especialista IoT

```mermaid
flowchart TD
    subgraph "Capas de Análisis ISTQB & IoT"
    A["Capa de Transporte (Bluetooth SPP 9600 8N1)"] --> B["Capa de Protocolo (Tramas ¿...?)"]
    B --> C["Capa de Máquina de Estados (Firmware PIC18F2550)"]
    C --> D["Capa de Persistencia (EEPROM No Volátil)"]
    D --> E["Capa de Presentación & Auditoría (App Android)"]
    end
```

### Hallazgos y Mejoras Clave (ISTQB & IoT):
1. **Validación de Parámetros en el Cliente (App-Side Validation):**
   * *Riesgo:* Si un operador configura manualmente una hora de inicio posterior a la de fin (ej. `I1500` y `F0900`), el firmware actualmente la graba en EEPROM pero nunca encenderá el foco.
   * *Mejora IoT:* La app debe validar `horaFin > horaInicio` antes de enviar la trama `¿A...` al Bluetooth, bloqueando el envío y mostrando un mensaje de advertencia.
2. **Timeout de Respuesta y Detección de Desconexión Activa:**
   * *Riesgo:* Si el teléfono se aleja del poste mientras transmite, la app no debe quedarse en estado bloqueante esperando bytes.
   * *Mejora ISTQB:* Implementar timeout reactivo de 3 segundos en cada comando. Si la baliza no responde, notificar: *"Sin respuesta de la baliza. Compruebe la distancia y el encendido"*.
3. **Idempotencia y Acuse de Recibo Automático (Read-After-Write):**
   * *Mejora IoT:* Tras pulsar **`Programar Horario Escolar (1 Toque)`**, la app enviará internamente la trama `¿L?` para contrastar en segundo plano que los valores en la EEPROM coincidan 100% con lo enviado.

---

## 2. Auditoría desde la Perspectiva de Usabilidad (UX / Ergonomía Vial)

Los técnicos e inspectores operan en la calle, **bajo luz solar intensa, con ruido de tráfico y en ocasiones usando guantes de trabajo**.

### Principios Ergonómicos Aplicados:
1. **Alto Contraste para Luz Solar Directa:**
   * Sustituir textos grises claros por tipografías oscuras (#1E293B) y fondos nítidos con tarjetas de bordes destacados.
2. **Botones de Gran Tamaño (Touch Targets $\ge 48\text{ dp}$):**
   * Botones amplios y separados para evitar pulsaciones accidentales con guantes o dedos húmedos.
3. **Feedback Háptico y Sonoro:**
   * Vibración corta al confirmar la recepción de comandos o programación exitosa.
4. **Resumen Visual de Estado en Pantalla Principal:**
   * En lugar de obligar al técnico a leer la consola de texto, un **Panel de Estado Visual** muestra los 3 horarios escolares con iconos de encendido/apagado y el nivel de batería.

---

## 3. Matriz de No-Regresión (Protección de Correcciones Históricas)

> [!IMPORTANT]
> **REGLA DE ORO:** Ningún cambio en la App puede alterar las siguientes 5 correcciones críticas ya certificadas:

| ID | Hotfix Certificado | Componente | Verificación Obligatoria |
|---|---|---|---|
| **NR-01** | **Inclusión de Hora `"02"`** | `MainActivity2.java` / Arrays | El selector de horas debe contener las 24 horas completas (`00` a `23`). |
| **NR-02** | **Delimitador `¿` (`0xBF`)** | `Serial.c` / `MainActivity2.java` | Las tramas deben iniciar obligatoriamente con el byte `0xBF` y terminar con `?`. |
| **NR-03** | **Comparación de Cadenas con `.equals()`** | Lógica de Spinners | Prohibido usar `==` para comparar textos de interfaces. |
| **NR-04** | **Permisos Android 12+ (API 31+)** | `AndroidManifest.xml` | Mantener `BLUETOOTH_CONNECT`, `BLUETOOTH_SCAN` y `neverForLocation`. |
| **NR-05** | **Consola con Auto-Scroll** | `activity_main2.xml` | `idTxtViewOut` debe estar contenido en un `ScrollView` que desplace automáticamente al final. |

---

## 4. Alcance Formal de la Refactorización App v3.4

1. **Card de Diagnóstico y Telemetría:**
   * Voltímetro 12V con código verde/amarillo/rojo.
   * Contador de cortes y badge de salud EEPROM.
2. **Validación Preventiva de Horarios:**
   * Bloqueo de rangos horarios invertidos.
3. **Exportación de Certificado de Auditoría:**
   * Generación de reporte formal con dirección MAC de la baliza y sellos de tiempo para WhatsApp/Correo.
4. **Verificación Automatizada E2E:**
   * Validación del 100% de los flujos contra el simulador del PIC en C mediante `test_suite_e2e.py`.

---

## Refactorización del 22-ago-2026 — tarjeta de mantenimiento

### Qué se corrigió

El checklist anterior eran **cuatro casillas decorativas**: existían en el layout pero **ninguna
estaba enlazada al código** (cero llamadas a findViewById sobre ellas) y **no aparecían en el acta
exportada**. El técnico las marcaba, las veía marcadas, y no llegaban a ningún sitio.

Peor: una de ellas —«Panel solar limpio y fusible 12V»— **no se puede verificar desde el suelo**,
así que la app permitía afirmar lo que no se había comprobado.

### Qué hay ahora

| | |
|---|---|
| **Modalidad** | Control de dos posiciones: *a nivel de suelo* / *en altura (poste)* |
| **Checklist** | **16 puntos**: 9 desde el suelo, 7 más subiendo |
| **Estado físico** | Encabeza la lista: lámina reflectiva, placa legible, **obstrucción por vegetación**, poste |
| **Ocultación** | Los 7 de altura **se ocultan** en modalidad de suelo, no se muestran en gris |
| **Desmarcado** | Al volver a *suelo*, los de altura **se desmarcan**: si no, el acta afirmaría algo verificado en una visita sin subir |
| **Técnico** | Campo autoguardado en SharedPreferences. Se escribe una vez por jornada |
| **Acta** | Incluye modalidad, checklist completo, **lo NO verificado**, y la atribución del técnico |

### Decisiones de diseño, con su porqué

1. **Los puntos que no aplican se ocultan, no se deshabilitan.** Si no están en pantalla no se
   marcan por descuido. Un checklist que permite afirmar lo no comprobado convierte una revisión
   incompleta en un acta que dice que fue completa.
2. **El acta enumera lo no verificado.** Es la diferencia entre un registro y una coartada.
3. **El nombre del técnico es atribución, no firma**, y el acta lo dice con esas palabras. Se
   descartaron las credenciales por técnico: degeneran en una credencial compartida, que es
   exactamente lo que ya pasa con el admin/admin del login.
4. **La obstrucción por vegetación tiene línea propia.** Es el fallo más común y más barato de
   arreglar de una señal escolar, y **el equipo no puede detectarlo**: la baliza destella
   perfectamente detrás de una rama.

### Verificación

* comprobar_ui.py: **PASS** — contraste WCAG, 31 controles con área táctil ≥ 48dp, responsive.
* Compila y los 16 puntos, la modalidad y los métodos nuevos están dentro del APK (comprobado
  sobre el binario, no sobre el fuente).
* **No se ha visto en un teléfono.** Sigue pendiente.

Propuesta completa y mockups: [PROPUESTA_MANTENIMIENTO_Y_AUDITORIA.md](PROPUESTA_MANTENIMIENTO_Y_AUDITORIA.md)
