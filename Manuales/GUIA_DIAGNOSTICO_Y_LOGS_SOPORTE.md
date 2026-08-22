# 🩺 GUÍA DE DIAGNÓSTICO Y LOGS PARA SOPORTE TÉCNICO
### Sistema de Baliza Vial Inteligente IT VIAL 30 (v3.4)

Cuando un cliente, técnico de campo o supervisor reporte un problema en una señal vial, solicite que presione el botón:
$$\mathbf{\text{COMPARTIR CERTIFICADO DE AUDITORÍA}}$$
en la aplicación móvil y lo envíe directamente por **WhatsApp** o correo electrónico.

---

## 📋 Estructura del Log de Soporte Oficial (Caja Negra)

```text
========================================
   LOG DE DIAGNÓSTICO Y SOPORTE IT VIAL  
   BALIZA: 30 CUANDO ACTIVADA (v3.4)    
========================================
UBICACIÓN / NOMBRE:  Col. San José - Km 4+200
DIRECCIÓN MAC:       98:D3:31:F8:42:0A
FECHA INSPECCIÓN:    22/08/2026 12:05:10
SISTEMA OPERATIVO:   Android 14 (SM-S901B)
----------------------------------------
1. TELEMETRÍA Y DIAGNÓSTICO EN CAMPO:
• Batería 12V / Panel: Batería Óptima (12.6V)
• Pila RTC CR2032:     Pila RTC OK (Reloj en Hora)
• Red / Bornes:        Alimentación Estable (2 reinicios)
• Estado EEPROM:       100% Íntegra (0x00=0x06)
----------------------------------------
2. HORARIOS PROGRAMADOS EN BALIZA:
ID: Col. San José - Km 4+200
1   - 06:00 - 09:00 - ON  - Lun a Vie
2   - 11:30 - 13:30 - ON  - Lun a Vie
3   - 15:00 - 16:30 - ON  - Lun a Vie
4   - 00:00 - 00:00 - OFF - Dia
5   - 00:00 - 00:00 - OFF - Dia
----------------------------------------
3. CAJA NEGRA UART (ÚLTIMAS TRAMAS):
[12:04:55 TX] ¿R120422082606,?
[12:04:56 TX] ¿L?
[12:04:57 RX] ID: Col. San José - Km 4+200
[12:04:57 RX] Bat: 12.6V | Cortes: 2
========================================
Generado por: App IT VIAL 30 (v3.4 Oficial)
```

---

## 🔍 Guía de Interpretación Rápida para Soporte / Inteligencia Artificial

Al pegar este log en el chat de soporte, se diagnostica inmediatamente cualquier falla:

| Línea en el Log | Diagnóstico / Significado | Causa y Solución Inmediata |
|---|---|---|
| **`Batería 12V: < 11.5V`** | Batería principal descargada. | Panel solar sucio, desconectado, o batería de 12V agotada. Revisar fusible y medir tensión en bornes. |
| **`Pila RTC: Desfasado / Año 2000`** | Reloj interno sin respaldo. | Pila de botón CR2032 (3V) agotada en la tarjeta. Reemplazar la pila CR2032 dentro del gabinete. |
| **`Red: Cortes > 15`** | Reinicios frecuentes por falso contacto. | Vibración en el poste o tornillos de bornera flojos. Apretar borneras de 12V y revisar portafusible. |
| **`EEPROM: 0x00 != 0x06`** | Memoria sin inicializar o corrupta. | Presionar **«Programar Horario Escolar (1 Toque)»** para inicializar la memoria EEPROM de fábrica. |
| **`Caja Negra TX sin RX`** | Sin respuesta del microcontrolador. | Microcontrolador sin alimentación de 5V o cableado UART (`RC6/RC7`) desconectado. |
| **`Alarma 1..3 en OFF`** | Horario escolar desactivado. | Presionar **«Programar Horario Escolar (1 Toque)»** para activar las franjas escolares reglamentarias. |
