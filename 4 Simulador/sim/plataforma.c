/*
 * plataforma.c - LO QUE EN EL EQUIPO REAL ES SILICIO
 *
 * Aqui viven: los SFR del PIC como variables, el tick de Timer0, la ISR de
 * recepcion de la UART, el ADC, la EEPROM y el DS1307. Todo lo que el firmware
 * llama y que en el PC no existe.
 *
 * REGLA: este archivo puede mentirle al firmware sobre el HARDWARE, nunca sobre
 * la LOGICA. Si un dia hace falta tocar un .c del firmware para que el
 * simulador pase, el simulador deja de medir el firmware y pasa a medirse a si
 * mismo. Se arregla aqui, no alli.
 *
 * Este archivo NO se incluye desde el arnes: lo incluye el propio arnes.c junto
 * con los .c del firmware, en unidad unica de compilacion.
 */

#include <string.h>
#include "../../1 Firmware/Doc mplabx/18f2550_baliza_ V1.X/Adc.h"
#include <stdint.h>
#include <xc.h>
#include "DS1307.h"
#include "Serial.h"
#include "Alarma.h"
#include "Aplicacion.h"
#include "Cluster.h"
#include "LedLive.h"
#include "Buzzer.h"
#include "sim.h"

/* Estructuras del firmware que la ISR simulada tiene que tocar, igual que la
   ISR real de main.c. */
extern strSerial   serial1;
extern strAnaTrama anaT1;

/* En el equipo real esta estructura vive en DS1307.c, que aqui esta sustituido. */
strRtc rtc;

/* ---------------------------------------------------------------
   1. LOS SFR
   --------------------------------------------------------------- */
volatile t_LATA    LATAbits;
volatile t_TRISA   TRISAbits;
volatile t_LATB    LATBbits;
volatile t_TRISB   TRISBbits;
volatile t_LATC    LATCbits;
volatile t_TRISC   TRISCbits;
volatile t_TXSTA   TXSTAbits;
volatile t_RCSTA   RCSTAbits;
volatile t_INTCON  INTCONbits;
volatile t_INTCON3 INTCON3bits;
volatile t_PIR1    PIR1bits;
volatile t_PIE1    PIE1bits;
volatile t_PIR2    PIR2bits;
volatile t_RCON    RCONbits;
volatile t_EECON1  EECON1bits;
volatile t_ADCON0  ADCON0bits;
volatile t_ADCON1  ADCON1bits;
volatile t_ADCON2  ADCON2bits;
volatile t_SSPCON1 SSPCON1bits;
volatile t_SSPCON2 SSPCON2bits;
volatile t_SSPSTAT SSPSTATbits;

volatile unsigned char ADCON1;
volatile unsigned char RCREG;
volatile unsigned char SPBRG;
volatile unsigned char EEADR;
volatile unsigned char EEDATA;
volatile unsigned char EECON2;
volatile unsigned char ADRESH;
volatile unsigned char ADRESL;
volatile unsigned char T0CON;
volatile unsigned int  TMR0;
volatile unsigned char SSPBUF;
volatile unsigned char SSPADD;

/* TXREG no es una variable pasiva: escribir en el es transmitir. Se declara
   aqui como byte y transmitUart1() escribe en el; el enganche esta abajo, en
   sim_tx_capturar(), que el arnes llama despues de cada tick. Para no perder
   bytes, TXSTAbits.TRMT se deja siempre a 1 (transmisor libre): si valiera 0,
   el bucle `while(TXSTAbits.TRMT == 0)` de transmitUart1() colgaria el
   simulador para siempre. */
volatile unsigned char TXREG;

/* ---------------------------------------------------------------
   2. CAPTURA DE LO QUE EL FIRMWARE TRANSMITE

   transmitUart1() escribe byte a byte en TXREG y espera a TRMT. Como TRMT
   esta siempre a 1, el bucle no bloquea, pero entre escritura y escritura
   nadie leeria TXREG. Por eso se intercepta con una macro: el arnes compila
   el firmware con -DTXREG=sim_txreg, y sim_txreg es un "registro" que al
   asignarsele un valor lo apunta en el buffer.

   En C no hay propiedades, asi que se hace con una funcion y una macro de
   asignacion. Ver TX_ESCRIBIR abajo y el #define en arnes.c.
   --------------------------------------------------------------- */
#define SIM_TX_MAX 8192
static char          txbuf[SIM_TX_MAX + 1];
static int           txlen;

void sim_tx_byte(unsigned char b)
{
    if (txlen < SIM_TX_MAX) txbuf[txlen++] = (char)b;
    txbuf[txlen] = '\0';
}

const char *sim_tx(void)      { return txbuf; }
int         sim_tx_len(void)  { return txlen; }
void        sim_tx_limpiar(void) { txlen = 0; txbuf[0] = '\0'; }

/* ---------------------------------------------------------------
   3. EEPROM DE DATOS

   Sustituye a EEprom.c entero. El original hace `while(!PIR2bits.EEIF);`
   esperando a un periferico que en el PC no existe: colgaria el simulador en
   la primera escritura. La secuencia de desbloqueo (0x55/0xAA) tampoco se
   reproduce porque no protege nada aqui.

   LO QUE ESTO IMPLICA: el simulador NO puede detectar un fallo en la secuencia
   de escritura de la EEPROM, ni un WRERR, ni el tiempo de escritura (~4 ms en
   el PIC, durante los cuales el firmware real esta parado). Eso solo se ve en
   la tarjeta.
   --------------------------------------------------------------- */
#define SIM_EEPROM_TAM 256
static unsigned char eeprom[SIM_EEPROM_TAM];

void EEpromWrite(unsigned int address, unsigned char data)
{
    if (address < SIM_EEPROM_TAM) eeprom[address] = data;
}

unsigned char EEpromRead(unsigned int address)
{
    return (address < SIM_EEPROM_TAM) ? eeprom[address] : 0xFF;
}

unsigned char sim_eeprom_leer(unsigned int addr)
{
    return (addr < SIM_EEPROM_TAM) ? eeprom[addr] : 0xFF;
}

void sim_eeprom_escribir(unsigned int addr, unsigned char dato)
{
    if (addr < SIM_EEPROM_TAM) eeprom[addr] = dato;
}

void sim_eeprom_borrar(void)
{
    memset(eeprom, 0xFF, sizeof(eeprom));
}

/* ---------------------------------------------------------------
   4. DS1307 VIRTUAL

   Sustituye a DS1307.c y a I2C.c. El reloj se lleva en segundos absolutos
   desde una fecha base y se convierte a campos al leerlo, de forma que avanza
   solo con el tiempo simulado y los cambios de minuto, hora y dia de la semana
   salen bien sin codigo de calendario duplicado.

   LO QUE ESTO IMPLICA: el simulador NO mide el bus I2C. Un DS1307 sin pull-ups,
   con la bateria agotada, o con el bit CH (Clock Halt) puesto -- que es la causa
   clasica de "el reloj se quedo parado" -- aqui nunca aparece: este reloj
   siempre responde y siempre corre.
   --------------------------------------------------------------- */

/* Dias acumulados por mes en un ano no bisiesto. */
static const int dias_mes[12] = {31,28,31,30,31,30,31,31,30,31,30,31};

static long rtc_seg_abs;   /* segundos desde el 01/01/2000 00:00:00 */
static int  rtc_dow_base;  /* dia de la semana del 01/01/2000, ajustable */

static int es_bisiesto(int ano_2dig)
{
    int a = 2000 + ano_2dig;
    return (a % 4 == 0 && a % 100 != 0) || (a % 400 == 0);
}

static long a_segundos(int h, int m, int s, int dia, int mes, int ano)
{
    long dias = 0;
    int i;
    for (i = 0; i < ano; i++) dias += es_bisiesto(i) ? 366 : 365;
    for (i = 0; i < mes - 1 && i < 12; i++) {
        dias += dias_mes[i];
        if (i == 1 && es_bisiesto(ano)) dias += 1;
    }
    dias += (dia - 1);
    return dias * 86400L + h * 3600L + m * 60L + s;
}

static void de_segundos(long t, int *h, int *m, int *s,
                        int *dia, int *mes, int *ano, int *dow)
{
    long dias = t / 86400L;
    long resto = t % 86400L;
    int a = 0, i;

    *h = (int)(resto / 3600);
    *m = (int)((resto % 3600) / 60);
    *s = (int)(resto % 60);

    /* Dia de la semana: cuenta corrida desde la base, 1..7. */
    *dow = (int)(((dias + rtc_dow_base - 1) % 7 + 7) % 7) + 1;

    while (1) {
        long en_ano = es_bisiesto(a) ? 366 : 365;
        if (dias < en_ano) break;
        dias -= en_ano;
        a++;
    }
    *ano = a;
    for (i = 0; i < 12; i++) {
        long en_mes = dias_mes[i] + ((i == 1 && es_bisiesto(a)) ? 1 : 0);
        if (dias < en_mes) break;
        dias -= en_mes;
    }
    *mes = i + 1;
    *dia = (int)dias + 1;
}

/* --- las funciones que el firmware llama --- */

uint8_t BCD_a_Decimal(uint8_t numero) { return (uint8_t)((numero >> 4) * 10 + (numero & 0x0F)); }
uint8_t Decimal_a_BCD(uint8_t numero) { return (uint8_t)(((numero / 10) << 4) + (numero % 10)); }

void leerRtcSeg(uint8_t *segundos)
{
    int h, m, s, d, mo, a, dw;
    de_segundos(rtc_seg_abs, &h, &m, &s, &d, &mo, &a, &dw);
    *segundos = (uint8_t)s;
}

void leerRTC(uint8_t *hora, uint8_t *minutos, uint8_t *segundos,
             uint8_t *dia, uint8_t *mes, uint8_t *ano, uint8_t *diaSe)
{
    int h, m, s, d, mo, a, dw;
    de_segundos(rtc_seg_abs, &h, &m, &s, &d, &mo, &a, &dw);
    *hora = (uint8_t)h; *minutos = (uint8_t)m; *segundos = (uint8_t)s;
    *dia = (uint8_t)d;  *mes = (uint8_t)mo;    *ano = (uint8_t)a;
    *diaSe = (uint8_t)dw;
}

void escribirRTC(uint8_t hor, uint8_t min, uint8_t seg,
                 uint8_t dia, uint8_t mes, uint8_t ano, uint8_t diaSe)
{
    long t = a_segundos(hor, min, seg, dia, mes, ano);
    long dias = t / 86400L;
    /* Ajusta la base para que el dia de la semana quede como lo pide quien
       escribe: el DS1307 real guarda el dia de la semana como un contador
       independiente del calendario, y el firmware se lo cree. */
    rtc_dow_base = (int)(((diaSe - 1 - dias) % 7 + 7) % 7) + 1;
    rtc_seg_abs = t;
}

void sim_rtc_set(int hora, int min, int seg, int dia, int mes, int ano, int diaSem)
{
    escribirRTC((uint8_t)hora, (uint8_t)min, (uint8_t)seg,
                (uint8_t)dia, (uint8_t)mes, (uint8_t)ano, (uint8_t)diaSem);
}

void sim_rtc_get(int *hora, int *min, int *seg, int *dia, int *mes, int *ano, int *diaSem)
{
    de_segundos(rtc_seg_abs, hora, min, seg, dia, mes, ano, diaSem);
}

void sim_rtc_saltar(long segundos) { rtc_seg_abs += segundos; }

/* Stubs de I2C: el firmware los llama solo desde DS1307.c, que aqui esta
   sustituido, pero se dejan por si alguien anade un periferico I2C. */
void I2C_Master_Init(uint32_t clock) { (void)clock; }
void I2C_Master_Wait(void) {}
void I2C_Start(void) {}
void I2C_Stop(void) {}
void I2C_Repeated_Start(void) {}
void I2C_Master_Write(uint8_t dato) { (void)dato; }
uint8_t I2C_Master_Read(uint8_t ACK) { (void)ACK; return 0; }

/* ---------------------------------------------------------------
   5. ADC

   El firmware llama ADC_read(1) para la tension de bateria y ADC_read(3) para
   la temperatura. Aqui devuelve el valor crudo que le haya puesto el arnes.

   LO QUE ESTO IMPLICA: el simulador NO comprueba que el canal este habilitado
   como analogico en ADCON1. Si PCFG deja AN3 como digital, en la tarjeta
   ADC_read(3) devolveria basura y aqui devolvera lo que le pongamos. Eso se
   mide en banco, no aqui.
   --------------------------------------------------------------- */
static int adc_val[16];
static int adc_leido_deshabilitado = 0;
static int adc_lecturas[16];

/* ADC_init() YA NO SE FALSEA AQUI: lo compila el arnes desde Adc.c, que es
   firmware real. Antes era un stub vacio y por eso el PCFG no existia para el
   simulador -- el canal de temperatura pasaba en verde leyendo un pin digital. */
void INT_init(void) {}

/* Cuantos canales AN quedan analogicos segun PCFG, en el PIC18F2455/2550/4455/4550.
   La tabla del datasheet asigna (13 - PCFG) canales analogicos contiguos desde AN0,
   y ninguno a partir de PCFG >= 0b1101.

   PENDIENTE DE CONFIRMAR CONTRA EL DATASHEET (22-ago-2026). Es la pieza que
   decide si el arreglo de AN3 es 0b1001 o 0b1010, y las dos fuentes que hay en el
   repositorio se contradicen -- ver Adc.c. Mientras no se confirme, este escenario
   nace en ROJO a proposito. */
static int adc_canales_analogicos(void)
{
    int pcfg = ADCON1bits.PCFG & 0x0F;
    if (pcfg >= 13) return 0;
    return 13 - pcfg;
}

int sim_adc_canal_habilitado(int canal)
{
    return canal >= 0 && canal < adc_canales_analogicos();
}

int sim_adc_hubo_lectura_de_canal_deshabilitado(void)
{
    return adc_leido_deshabilitado;
}

/* Cuantas veces pidio el firmware ese canal. Sin esto, un escenario que
   comprueba que "no se leyo nada malo" da verde tambien cuando NO SE LEYO
   NADA -- que es el falso verde que ya se comio este banco una vez. */
int sim_adc_lecturas(int canal)
{
    if (canal < 0 || canal > 15) return 0;
    return adc_lecturas[canal];
}

uint16_t ADC_read(uint8_t channel)
{
    /* En la tarjeta, leer un canal que PCFG dejo digital no devuelve el sensor:
       devuelve algo no especificado por Microchip. Aqui se anota para que el
       arnes lo pueda acusar, en vez de entregar un valor limpio que nunca
       existio. */
    adc_lecturas[channel & 0x0F]++;

    if (!sim_adc_canal_habilitado((int)(channel & 0x0F)))
        adc_leido_deshabilitado = 1;

    return (uint16_t)adc_val[channel & 0x0F];
}

void sim_adc_set(int canal, int valor)
{
    if (canal >= 0 && canal < 16) adc_val[canal] = valor;
}

/* printf() del firmware: en el PIC sale por la UART via putch(). Aqui se
   descarta, porque la ISR de baja prioridad que lo usa no se reproduce. */
void putch(char dato) { (void)dato; }

/* ---------------------------------------------------------------
   6. EL TICK Y EL BUCLE PRINCIPAL

   Reproduce literalmente la ISR de Timer0 de main.c -- incluido el reinicio de
   TODOS los ulCntPeriodX cada 60000 ticks -- y una vuelta del while(1).
   --------------------------------------------------------------- */

/* Estas viven en el firmware; se declaran aqui para poder reiniciarlas. */
extern unsigned long ulCntTick1ms;
extern unsigned long ulCntPeriodLedLive;
extern unsigned long ulCntPeriodAnaUart1;
extern unsigned long ulCntPeriodAplicacion;
extern unsigned long ulCntPeriodAlarm;
extern unsigned long ulCntPeriodBuzzer;
extern unsigned long ulCntPeriodCluster;

unsigned long ulCntTick1ms;

static unsigned long sim_ticks;      /* contador propio, no se reinicia */
static long          sim_seg_frac;   /* ms acumulados para mover el RTC */

/* Cola de bytes pendientes de entregar a la ISR de recepcion, uno por tick. */
#define SIM_RX_MAX 512
static unsigned char rxq[SIM_RX_MAX];
static int rxq_ini, rxq_fin;

void sim_rx(const char *bytes, int len)
{
    int i;
    for (i = 0; i < len; i++) {
        int sig = (rxq_fin + 1) % SIM_RX_MAX;
        if (sig == rxq_ini) break;   /* cola llena: se descarta, como un OERR */
        rxq[rxq_fin] = (unsigned char)bytes[i];
        rxq_fin = sig;
    }
}

void sim_rx_str(const char *s) { sim_rx(s, (int)strlen(s)); }

unsigned long sim_ms(void) { return sim_ticks; }

void sim_tick(unsigned long n)
{
    unsigned long i;
    for (i = 0; i < n; i++) {

        /* --- ISR de Timer0, tal cual main.c --- */
        if (++ulCntTick1ms >= 60000) {
            ulCntTick1ms = 0;
            ulCntPeriodLedLive    = 0;
            ulCntPeriodAplicacion = 0;
            ulCntPeriodAlarm      = 0;
            ulCntPeriodBuzzer     = 0;
            ulCntPeriodAnaUart1   = 0;
            ulCntPeriodCluster    = 0;
        }

        /* --- ISR de recepcion de la UART, tal cual main.c --- */
        if (rxq_ini != rxq_fin) {
            char ch = (char)rxq[rxq_ini];
            rxq_ini = (rxq_ini + 1) % SIM_RX_MAX;
            receiverUart1(&ch);
            serial1.flagRx = 1;
            anaT1.uiCnt = 0;
        }

        /* --- una vuelta del while(1) de main.c --- */
        executeTaskLedLive();
        executeTaskAnalizaUart1();
        executeTaskAplicacion();
        executeTaskAlarm();
        executeTaskBuzzer();
        executeTaskCluster();

        /* --- el reloj avanza 1 s cada 1000 ticks --- */
        if (++sim_seg_frac >= 1000) { sim_seg_frac = 0; rtc_seg_abs++; }

        sim_ticks++;
    }
}

int sim_cluster(void)  { return LATCbits.LATC2; }
int sim_buzzer(void)   { return LATCbits.LATC1; }
int sim_led_live(void) { return LATAbits.LATA0; }

unsigned long sim_arrancar(void)
{
    unsigned long t0 = sim_ticks;
    unsigned long limite = 60000;   /* 60 s simulados de margen */
    while (sim_ticks - t0 < limite) {
        sim_tick(1);
        /* Aplicacion.c anuncia el fin del arranque transmitiendo el banner y
           pasando a ST_ESPERA_AP. Se detecta por el banner, que es un hecho
           observable desde fuera, no por una variable interna. */
        if (strstr(sim_tx(), "BALIZA")) return sim_ticks - t0;
    }
    return 0;
}

int sim_medir_cluster(unsigned long ticks, unsigned long *ms_on, unsigned long *ms_off)
{
    unsigned long i, marca = 0;
    int previo = sim_cluster();
    int visto_on = 0, visto_off = 0;
    *ms_on = 0; *ms_off = 0;

    for (i = 0; i < ticks; i++) {
        int actual;
        sim_tick(1);
        actual = sim_cluster();
        if (actual != previo) {
            unsigned long dur = sim_ticks - marca;
            if (marca != 0) {
                /* el tramo que acaba de cerrarse tenia el valor 'previo' */
                if (previo && !visto_on)  { *ms_on = dur;  visto_on = 1; }
                if (!previo && !visto_off){ *ms_off = dur; visto_off = 1; }
            }
            marca = sim_ticks;
            previo = actual;
            if (visto_on && visto_off) return 1;
        }
    }
    return (visto_on && visto_off);
}

/* Globales del firmware. Un corte de alimentacion los pone todos a cero: eso es
   lo que sim_reset() tiene que reproducir. Si aqui falta uno, el simulador
   arrastra estado de un escenario al siguiente y da resultados que dependen del
   ORDEN de las pruebas -- que es la forma mas silenciosa de que un arnes mienta.
   Paso de verdad el 21-ago-2026: el escenario de la luz daba verde suelto y rojo
   dentro de la tanda completa. */
extern strAnaTrama anaT1;
extern strSerial   serial1;
extern srtAlarmas  ala1, ala2, ala3, ala4, ala5;
extern strAlarm    ala;
extern strAplicacion ap;
extern strMemory   memo;
extern strCluster  cl;
extern enum states_anaTrama1  stateAnaTrama1;
extern enum states_alarm      stateAlarm;
extern enum states_aplicacion stateAp;
extern enum states_cluster    stateCluster;
extern enum States_Buzzer     stateBuzzer;
extern enum states_ledLive    state_ledLive;
extern unsigned char ucTypeBeep, ucCntTimeBuzzer, ucIteradorBuzzer, flagStartBuzzer;
extern unsigned int  uiCntLedLive;
extern unsigned char flagInitStLed;

void sim_reset(void)
{
    /* El ADC vuelve al estado de arranque y se reaplica la configuracion REAL
       del firmware (Adc.c), igual que hace main(). Si esto no se hiciera, el
       PCFG quedaria a cero y todos los canales parecerian analogicos: el
       escenario del ADC daria verde por accidente. */
    memset((void *)&ADCON0bits, 0, sizeof(ADCON0bits));
    memset((void *)&ADCON1bits, 0, sizeof(ADCON1bits));
    memset((void *)&ADCON2bits, 0, sizeof(ADCON2bits));
    adc_leido_deshabilitado = 0;
    memset(adc_lecturas, 0, sizeof(adc_lecturas));
    ADC_init();

    /* --- lo que en el equipo real hace el corte de alimentacion --- */
    memset((void *)&LATAbits, 0, sizeof(LATAbits));
    memset((void *)&LATBbits, 0, sizeof(LATBbits));
    memset((void *)&LATCbits, 0, sizeof(LATCbits));

    memset(&anaT1,   0, sizeof(anaT1));
    memset(&serial1, 0, sizeof(serial1));
    memset(&ala1,    0, sizeof(ala1));
    memset(&ala2,    0, sizeof(ala2));
    memset(&ala3,    0, sizeof(ala3));
    memset(&ala4,    0, sizeof(ala4));
    memset(&ala5,    0, sizeof(ala5));
    memset(&ala,     0, sizeof(ala));
    memset(&ap,      0, sizeof(ap));
    memset(&memo,    0, sizeof(memo));
    memset(&cl,      0, sizeof(cl));

    stateAnaTrama1 = ST_ARRANQUE_ANA1;
    stateAlarm     = ST_ARRANQUE_ALA;
    stateAp        = ST_ARRANQUE_AP;
    stateCluster   = ST_ARRANQUE_CL;
    stateBuzzer    = ST_WAIT_BUZZER;
    state_ledLive  = ST_ARRANQUE_LED;

    ucTypeBeep = ucCntTimeBuzzer = ucIteradorBuzzer = flagStartBuzzer = 0;
    uiCntLedLive = 0;
    flagInitStLed = 0;

    ulCntPeriodLedLive = ulCntPeriodAnaUart1 = ulCntPeriodAplicacion = 0;
    ulCntPeriodAlarm = ulCntPeriodBuzzer = ulCntPeriodCluster = 0;

    /* NO se borra la EEPROM: el PIC tampoco la borra al quitar la corriente.
       NO se toca el reloj: el DS1307 sigue contando con su bateria. Las dos
       cosas son parte de lo que hay que poder probar. */

    txlen = 0; txbuf[0] = ' ';
    rxq_ini = rxq_fin = 0;
    ulCntTick1ms = 0;
    sim_ticks = 0;
    sim_seg_frac = 0;

    /* --- y lo que hace main() al arrancar, en el mismo orden --- */
    TXSTAbits.TRMT = 1;   /* transmisor libre: si valiera 0, transmitUart1 cuelga */
    pinConfLedPin();
    pinConfBuzzer();
    pinConfCluster();

    startTaskLedLive();
    startTaskAnalizaUart1();
    startTaskAplicacion();
    startTaskAlarm();
    startTaskBuzzer();
    startTaskCluster();
}
