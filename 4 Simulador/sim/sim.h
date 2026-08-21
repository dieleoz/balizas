/*
 * sim.h - API DEL SIMULADOR DE LA BALIZA
 *
 * Lo que el arnes puede hacerle al firmware desde el PC: avanzar el tiempo,
 * meterle tramas por el puerto serie, mover el reloj y mirar las salidas.
 *
 * El firmware NO ve nada de esto. Compila contra los mismos .c que se graban
 * en el PIC; lo unico que cambia debajo son <xc.h>, la EEPROM y el DS1307.
 */

#ifndef SIM_H
#define SIM_H

/* --- ciclo de vida ------------------------------------------------------ */

/* Deja el simulador como un equipo recien alimentado: RAM a cero, maquinas de
   estado en su estado inicial, EEPROM conservada (como la del PIC, que no se
   borra al quitar la corriente). Usar sim_eeprom_borrar() para simular un
   micro virgen. */
void sim_reset(void);

/* Borra la EEPROM a 0xFF, que es como sale un PIC de fabrica. Con esto el
   firmware entra por la rama de "memoria sin inicializar" de Aplicacion.c. */
void sim_eeprom_borrar(void);

/* Avanza n ticks de 1 ms: por cada tick reproduce la ISR de Timer0 de main.c
   y ejecuta una vuelta del while(1) con las 6 tareas. */
void sim_tick(unsigned long n);

/* Ticks transcurridos desde el ultimo sim_reset(). No es getMillis(): este no
   se reinicia cada 60000, para poder medir duraciones largas. */
unsigned long sim_ms(void);

/* Avanza hasta que el firmware termina el arranque (ap.flagArranque y la
   lectura de memoria). Devuelve los ticks que hizo falta, o 0 si no arranco. */
unsigned long sim_arrancar(void);

/* --- puerto serie ------------------------------------------------------- */

/* Inyecta una trama byte a byte, un byte por tick, como llegaria a 9600 baudios.
   Reproduce la ISR de recepcion de main.c: receiverUart1() + flagRx + uiCnt=0. */
void sim_rx(const char *bytes, int len);
void sim_rx_str(const char *s);   /* igual, hasta el '\0' */

/* Todo lo que el firmware ha escrito en TXREG desde el ultimo sim_tx_limpiar(). */
const char *sim_tx(void);
int         sim_tx_len(void);
void        sim_tx_limpiar(void);

/* --- reloj -------------------------------------------------------------- */

/* Pone el DS1307 virtual en hora. diaSem: 1=lunes .. 7=domingo. */
void sim_rtc_set(int hora, int min, int seg, int dia, int mes, int ano, int diaSem);

/* Lee el DS1307 virtual (lo que leeria leerRTC()). */
void sim_rtc_get(int *hora, int *min, int *seg, int *dia, int *mes, int *ano, int *diaSem);

/* Salta el reloj hacia delante SIN avanzar los ticks del firmware. Sirve para
   colocarse en una hora concreta sin simular las horas intermedias. */
void sim_rtc_saltar(long segundos);

/* --- salidas ------------------------------------------------------------ */

int sim_cluster(void);   /* LATC2: la luz de la senal. 1 = encendida */
int sim_buzzer(void);    /* LATC1 */
int sim_led_live(void);  /* LATA0 (ojo: en este firmware 0 = LED encendido) */

/* --- EEPROM ------------------------------------------------------------- */

unsigned char sim_eeprom_leer(unsigned int addr);
void          sim_eeprom_escribir(unsigned int addr, unsigned char dato);

/* --- ADC ---------------------------------------------------------------- */

/* Fija el valor crudo (0..1023) que devolvera ADC_read() para ese canal. */
void sim_adc_set(int canal, int valor);

/* --- medida de la cadencia del cluster ---------------------------------- */

/* Corre n ticks vigilando LATC2 y devuelve, por referencia, la duracion en ms
   del primer pulso ENCENDIDO completo y del primer pulso APAGADO completo que
   observe. Devuelve 0 si no llego a ver un ciclo completo. */
int sim_medir_cluster(unsigned long ticks, unsigned long *ms_on, unsigned long *ms_off);

#endif /* SIM_H */
