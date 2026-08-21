/*
 * xc.h - STUB DEL COMPILADOR XC8 PARA EL SIMULADOR DE PC
 *
 * Sustituye al <xc.h> de Microchip cuando el firmware de la baliza se compila
 * con gcc en el PC. Declara los mismos SFR del PIC18F2550 que toca el firmware,
 * pero como variables normales en RAM del PC.
 *
 * CONSECUENCIA QUE HAY QUE TENER PRESENTE: escribir LATCbits.LATC2 = 1 aqui no
 * enciende nada, solo cambia un byte que el arnes puede leer. Eso es justo lo
 * que permite MEDIR la salida del cluster desde el PC -- y tambien lo que hace
 * que este simulador NO diga nada sobre si la etapa de potencia funciona.
 *
 * Solo estan los registros que el firmware usa de verdad. Si al compilar sale
 * "undeclared identifier" de un SFR, se anade aqui; no se toca el firmware.
 */

#ifndef XC_STUB_H
#define XC_STUB_H

#include <stdint.h>

/* XC8 declara NOP() como intrinseco del compilador. En PC no hace nada. */
#ifndef NOP
#define NOP() ((void)0)
#endif

/* XC8 ofrece __delay_ms(); en PC seria un bloqueo real, asi que se anula.
   El arnes avanza el tiempo por ticks, no por reloj de pared. */
#ifndef __delay_ms
#define __delay_ms(x) ((void)0)
#endif
#ifndef __delay_us
#define __delay_us(x) ((void)0)
#endif

/* ---------------------------------------------------------------
   Patron de los SFR: cada registro es un byte accesible entero
   (LATC) o bit a bit (LATCbits.LATC2), igual que en XC8.
   --------------------------------------------------------------- */
#define SFR8(nombre, ...)                    \
    typedef union {                          \
        unsigned char reg;                   \
        struct { __VA_ARGS__ };              \
    } t_##nombre;                            \
    extern volatile t_##nombre nombre##_u;

/* PUERTO A ------------------------------------------------------ */
typedef union { unsigned char reg; struct {
    unsigned LATA0:1; unsigned LATA1:1; unsigned LATA2:1; unsigned LATA3:1;
    unsigned LATA4:1; unsigned LATA5:1; unsigned LATA6:1; unsigned LATA7:1; };
} t_LATA;
typedef union { unsigned char reg; struct {
    unsigned TRISA0:1; unsigned TRISA1:1; unsigned TRISA2:1; unsigned TRISA3:1;
    unsigned TRISA4:1; unsigned TRISA5:1; unsigned TRISA6:1; unsigned TRISA7:1; };
} t_TRISA;

/* PUERTO B ------------------------------------------------------ */
typedef union { unsigned char reg; struct {
    unsigned LATB0:1; unsigned LATB1:1; unsigned LATB2:1; unsigned LATB3:1;
    unsigned LATB4:1; unsigned LATB5:1; unsigned LATB6:1; unsigned LATB7:1; };
} t_LATB;
typedef union { unsigned char reg; struct {
    unsigned TRISB0:1; unsigned TRISB1:1; unsigned TRISB2:1; unsigned TRISB3:1;
    unsigned TRISB4:1; unsigned TRISB5:1; unsigned TRISB6:1; unsigned TRISB7:1; };
} t_TRISB;

/* PUERTO C ------------------------------------------------------ */
typedef union { unsigned char reg; struct {
    unsigned LATC0:1; unsigned LATC1:1; unsigned LATC2:1; unsigned LATC3:1;
    unsigned LATC4:1; unsigned LATC5:1; unsigned LATC6:1; unsigned LATC7:1; };
} t_LATC;
typedef union { unsigned char reg; struct {
    unsigned TRISC0:1; unsigned TRISC1:1; unsigned TRISC2:1; unsigned TRISC3:1;
    unsigned TRISC4:1; unsigned TRISC5:1; unsigned TRISC6:1; unsigned TRISC7:1; };
} t_TRISC;

/* USART --------------------------------------------------------- */
typedef union { unsigned char reg; struct {
    unsigned TX9D:1; unsigned TRMT:1; unsigned BRGH:1; unsigned SENDB:1;
    unsigned SYNC:1; unsigned TXEN:1; unsigned TX9:1;  unsigned CSRC:1; };
} t_TXSTA;
typedef union { unsigned char reg; struct {
    unsigned RX9D:1; unsigned OERR:1; unsigned FERR:1; unsigned ADDEN:1;
    unsigned CREN:1; unsigned SREN:1; unsigned RX9:1;  unsigned SPEN:1; };
} t_RCSTA;

/* INTERRUPCIONES ------------------------------------------------ */
typedef union { unsigned char reg; struct {
    unsigned RBIF:1;  unsigned INT0IF:1; unsigned T0IF:1;  unsigned RBIE:1;
    unsigned INT0IE:1;unsigned TMR0IE:1; unsigned GIEL:1;  unsigned GIEH:1; };
} t_INTCON;
/* GIE y PEIE son los mismos bits que GIEH/GIEL: XC8 ofrece los dos nombres. */
#define GIE  GIEH
#define PEIE GIEL

typedef union { unsigned char reg; struct {
    unsigned INT1IF:1; unsigned INT2IF:1; unsigned :1;      unsigned INT1IE:1;
    unsigned INT2IE:1; unsigned :1;       unsigned INT1IP:1;unsigned INT2IP:1; };
} t_INTCON3;

typedef union { unsigned char reg; struct {
    unsigned TMR1IF:1; unsigned TMR2IF:1; unsigned CCP1IF:1; unsigned SSPIF:1;
    unsigned TXIF:1;   unsigned RCIF:1;   unsigned ADIF:1;   unsigned SPPIF:1; };
} t_PIR1;
typedef union { unsigned char reg; struct {
    unsigned TMR1IE:1; unsigned TMR2IE:1; unsigned CCP1IE:1; unsigned SSPIE:1;
    unsigned TXIE:1;   unsigned RCIE:1;   unsigned ADIE:1;   unsigned SPPIE:1; };
} t_PIE1;
typedef union { unsigned char reg; struct {
    unsigned CCP2IF:1; unsigned TMR3IF:1; unsigned HLVDIF:1; unsigned BCLIF:1;
    unsigned EEIF:1;   unsigned :1;       unsigned CMIF:1;   unsigned OSCFIF:1; };
} t_PIR2;
typedef union { unsigned char reg; struct {
    unsigned BOR:1; unsigned POR:1; unsigned PD:1;  unsigned TO:1;
    unsigned RI:1;  unsigned :1;    unsigned SBOREN:1; unsigned IPEN:1; };
} t_RCON;

/* EEPROM DE DATOS ----------------------------------------------- */
typedef union { unsigned char reg; struct {
    unsigned RD:1;   unsigned WR:1;    unsigned WREN:1; unsigned WRERR:1;
    unsigned FREE:1; unsigned CFGS:1;  unsigned :1;     unsigned EEPGD:1; };
} t_EECON1;

/* CONVERSOR A/D ------------------------------------------------- */
typedef union { unsigned char reg; struct {
    unsigned ADON:1; unsigned GO_DONE:1; unsigned CHS:4; unsigned :2; };
} t_ADCON0;
/* XC8 expone GO como alias de GO_DONE. */
#define GO GO_DONE
typedef union { unsigned char reg; struct {
    unsigned PCFG:4; unsigned VCFG:2; unsigned :2; };
} t_ADCON1;
typedef union { unsigned char reg; struct {
    unsigned ADCS:3; unsigned ACQT:3; unsigned :1; unsigned ADFM:1; };
} t_ADCON2;

/* MSSP (I2C) ---------------------------------------------------- */
typedef union { unsigned char reg; struct {
    unsigned SEN:1; unsigned RSEN:1; unsigned PEN:1;  unsigned RCEN:1;
    unsigned ACKEN:1;unsigned ACKDT:1;unsigned ACKSTAT:1; unsigned GCEN:1; };
} t_SSPCON2;
typedef union { unsigned char reg; struct {
    unsigned SSPM:4; unsigned CKP:1; unsigned SSPEN:1; unsigned SSPOV:1; unsigned WCOL:1; };
} t_SSPCON1;
typedef union { unsigned char reg; struct {
    unsigned BF:1; unsigned UA:1; unsigned R_W:1; unsigned S:1;
    unsigned P:1;  unsigned D_A:1;unsigned CKE:1; unsigned SMP:1; };
} t_SSPSTAT;

/* ---------------------------------------------------------------
   Instancias. Definidas en sim/plataforma.c.
   --------------------------------------------------------------- */
extern volatile t_LATA    LATAbits;
extern volatile t_TRISA   TRISAbits;
extern volatile t_LATB    LATBbits;
extern volatile t_TRISB   TRISBbits;
extern volatile t_LATC    LATCbits;
extern volatile t_TRISC   TRISCbits;
extern volatile t_TXSTA   TXSTAbits;
extern volatile t_RCSTA   RCSTAbits;
extern volatile t_INTCON  INTCONbits;
extern volatile t_INTCON3 INTCON3bits;
extern volatile t_PIR1    PIR1bits;
extern volatile t_PIE1    PIE1bits;
extern volatile t_PIR2    PIR2bits;
extern volatile t_RCON    RCONbits;
extern volatile t_EECON1  EECON1bits;
extern volatile t_ADCON0  ADCON0bits;
extern volatile t_ADCON1  ADCON1bits;
extern volatile t_ADCON2  ADCON2bits;
extern volatile t_SSPCON1 SSPCON1bits;
extern volatile t_SSPCON2 SSPCON2bits;
extern volatile t_SSPSTAT SSPSTATbits;

/* Registros que el firmware usa como byte entero. */
extern volatile unsigned char  ADCON1;
extern volatile unsigned char  TXREG;
extern volatile unsigned char  RCREG;
extern volatile unsigned char  SPBRG;
extern volatile unsigned char  EEADR;
extern volatile unsigned char  EEDATA;
extern volatile unsigned char  EECON2;
extern volatile unsigned char  ADRESH;
extern volatile unsigned char  ADRESL;
extern volatile unsigned char  T0CON;
extern volatile unsigned int   TMR0;
extern volatile unsigned char  SSPBUF;
extern volatile unsigned char  SSPADD;

#endif /* XC_STUB_H */
