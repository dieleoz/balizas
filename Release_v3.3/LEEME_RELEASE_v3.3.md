# PAQUETE OFICIAL DE ENTREGA Y PRODUCCIÓN — VERSIÓN v3.3
### Sistema de Baliza Vial Escolar «30 CUANDO ACTIVADA» (IT VIAL S.A.S)

**Fecha de Liberación:** 22 de Agosto de 2026  
**Empresa:** INFRAESTRUCTURA Y TECNOLOGÍA VIAL S.A.S (IT VIAL S.A.S)  
**Versión de Hardware:** Tarjeta `BALIZA_SR30` Rev V1.0 (PIC18F2550 @ 20 MHz + DS1307 + JDY-31 / HC-06)  
**Estado de Validación:** 100% PASS en simulador PC (37/37 comprobaciones) y validado en hardware físico en banco.

---

## 📦 Contenido del Paquete de Entrega

### 1. Binarios Oficiales (`/Binarios`)
* **`Baliza_v3.3.apk`** (3.86 MB):
  * Aplicación móvil Android oficial `IT VIAL 30` (v3.3).
  * Soporte para Android 6.0 hasta Android 14+.
  * Botón de **1-Toque para Horario Escolar Oficial de la Placa** (06:00-09:00, 11:30-13:30, 15:00-16:30 Lun-Vie).
  * Módulo de diagnóstico inmediato con **Test de Luz de 2 Minutos a 1.0 Hz** y botón de apagado rápido.
  * Interfaz con tema oscuro blindado y alto contraste para visibilidad diurna bajo sol.
* **`BALIZA_18F2550_V1_CORREGIDO.hex`** (59.5 KB):
  * Firmware de producción para microcontrolador PIC18F2550 compilado en XC8 con estándar `--std=c99`.
  * Cadencia reglamentaria oficial de **1.0 Hz (500 ms encendido / 500 ms apagado)**.
  * Mapeo de pines corregido: Buzzer en `RC1`, Foco LED en `RC2`, Entrada pulsador en `RC0`.
  * Parser serie protegido contra tramas truncadas y caracteres NUL.

---

### 2. Manuales y Documentación Oficial (`/Manuales_Word` y `/Manuales_PDF`)
* **`MANUAL_USUARIO_APP.docx` / `.pdf`**: Manual de usuario final e instaladores (guía paso a paso de 10 pasos, 18 figuras HD, diagnóstico de batería 12V y pila botón CR2032).
* **`FIRMWARE.docx`**: Documentación técnica del firmware módulo a módulo, arquitectura de protothreads y máquinas de estado.
* **`HARDWARE.docx`**: Memoria técnica de la tarjeta electrónica, componentes, esquemático y netlist.
* **`APP_MOVIL.docx`**: Manual de arquitectura de la app Android y protocolo de tramas serie.
* **`BLUETOOTH.docx`**: Guía técnica de integración y configuración de módulos JDY-31 / HC-06.
* **`MANUAL_FUNCIONAL_BLUETOOTH.docx`**: Protocolo de pruebas para el área funcional.
* **`COMPILAR_Y_GRABAR.docx`**: Guía paso a paso para compilar el firmware con XC8 y grabarlo con PICkit.

---

## 🔒 Verificación de Integridad (Hashes SHA-256)

| Archivo | Ruta | SHA-256 |
|---|---|---|
| `Baliza_v3.3.apk` | `Binarios/Baliza_v3.3.apk` | `9c37d599deb9e67efdbdd4a6a43e49be88a29a0378877bc9166014ca7e3c1a8f` |
| `BALIZA_18F2550_V1_CORREGIDO.hex` | `Binarios/BALIZA_18F2550_V1_CORREGIDO.hex` | `c14b4350d960dd6a402324f8d55c7a030026e64ec5582f3cbf845be934c9c228` |
| `MANUAL_USUARIO_APP.pdf` | `Manuales_PDF/MANUAL_USUARIO_APP.pdf` | `fde0123bdc04153096fa4f7cf6ef0d84370a2732ba1c0800ebc93a02796191ec` |
| `MANUAL_USUARIO_APP.docx` | `Manuales_Word/MANUAL_USUARIO_APP.docx` | `698507953c89ff21fa511ce20cf282bb69a842f10b5c16e7889f81648a58f4c7` |

---
*Paquete generado automáticamente y sellado para producción.*
