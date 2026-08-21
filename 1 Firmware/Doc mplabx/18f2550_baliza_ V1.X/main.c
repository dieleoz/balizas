 /**
 *  PROGRAMA BALIZA
 *  ING. FREIMAN PARGA
 *  13 DE OCTUBRE DEL 2022
 */

#include "main.h"
#include <xc.h>
#include <stdio.h>
#include "UART.h"

#include "LedLive.h"
#include "Serial.h"
#include "Aplicacion.h"
#include "I2C.h"
#include "Alarma.h"

#include "Buzzer.h"
#include "Cluster.h"

#include <stdint.h>

//*** ESTRUCTURAS EXTERNAS ***
extern strSerial serial1;
extern strAnaTrama anaT1;
extern strCluster cl;
//****************************

//*** VARIABLES EXTERNAS ***
extern unsigned long ulCntPeriodLedLive;
extern unsigned long ulCntPeriodAnaUart1;
extern unsigned long ulCntPeriodAplicacion;
extern unsigned long ulCntPeriodAlarm;
extern unsigned long ulCntPeriodBuzzer;
extern unsigned long ulCntPeriodCluster;
//**************************

//*** VARIABLES ***
unsigned long ulCntTick1ms; 
//*****************

/*
 * GESTION DE INTERRUPCION
 */
void __interrupt() INT_isr(void)
{
    char ch;
        
    //interrupcion por timer0
    if(INTCONbits.T0IF)
    {
        //TMR0 = 0xb3b4;
        TMR0 = 0xFFEC;
        
        INTCONbits.T0IF = 0;
        
        //si hay un minuto de tiks!!
        if(++ulCntTick1ms >= 60000)
        {
            ulCntTick1ms = 0;

            ulCntPeriodLedLive = 0;
            ulCntPeriodAplicacion = 0;
            ulCntPeriodAlarm = 0;
    //        ulCntPeriodButtons = 0;      
            ulCntPeriodBuzzer = 0;
    //        ulCntPeriodInputs = 0;
            ulCntPeriodAnaUart1 = 0;
            ulCntPeriodCluster = 0;
    //        ulCntPeriodBattery = 0;
    //        ulCntPeriodRelay = 0;
    //        ulCntPeriodAnaUart2 = 0;
        }
    
    }
    
    if(PIR1bits.RCIF)
    {
        ch = UART_read();
        //UART_write(ch);
        
        receiverUart1(&ch);
        serial1.flagRx = true;
        anaT1.uiCnt = 0;
    }
}


/*
 * GESTION DE INTERRUPCIONES DE BAJA PRIORIDAD
 */
void __interrupt(low_priority) INT_ISR_LOW (void)
{
    if(INTCON3bits.INT1IE == 1 && INTCON3bits.INT1IF == 1)
    {
         printf("INICIO INTERRUPCION INT1\r\n");
         __delay_ms(4000);
         printf("FIN INTERRUPCION INT1\r\n");
         INTCON3bits.INT1IF = 0;
    }
}





//*** MAIN ***




void main(void) 
{
    
    ADCON1 = 0X0F;
    INT_init();
    UART_init_baud(9600);
    ADC_init();
    
    pinConfLedPin();
    I2C_Master_Init(100000);
    pinConfBuzzer();
    pinConfCluster();
    
    
    startTaskLedLive();
    startTaskAnalizaUart1();
    startTaskAplicacion();
    startTaskAlarm();
    startTaskBuzzer();
    startTaskCluster();
    while(1)
    {
        executeTaskLedLive();
        executeTaskAnalizaUart1();
        executeTaskAplicacion();        
        executeTaskAlarm();
        executeTaskBuzzer();
        executeTaskCluster();
    }
}



/*
 * CONFIGURACION DE LAS INTERRUCCIONES
 */
void INT_init(void)
{
        
    //se habilitan las interrupciones 
    RCONbits.IPEN = 1;          //habilitamos prioridad
    INTCONbits.GIEH = 1;
    INTCONbits.GIEL = 1;
    // INTCONbits.GIE = 1;   
    
    INTCONbits.TMR0IE = 1;       //flag interrupt tmr0
    INTCONbits.GIE = 1;         //enable interrupts global
    
    //recarga de timer
    //TMR0 = 0xb3b4;
    TMR0 = 0xFFEC;
    T0CON = 0x87;       //preescaler
}



/******************************************
* Inicialización del ADC
******************************************/

void ADC_init(void)
{  
    ADCON1bits.VCFG = 0b00;     //REF -> VSS, VCC
    ADCON1bits.PCFG = 0b1011;   //Entradas Analogicas a0, a1, a2
    
    ADCON2bits.ACQT = 0b010;    //TACQT > 2.45us
    ADCON2bits.ADCS = 0b100;    //TAD >  0.7us Tosc * 4 = 1us
    ADCON2bits.ADFM = 1;        //1 derecha, 0 izquierda
    
    ADCON0bits.ADON = 1;        //ADC on
}

/*****************************************
* Lectura de un canal Analogico
*****************************************/

uint16_t ADC_read(uint8_t channel)
{
    ADCON0bits.CHS = channel;                  
    ADCON0bits.GO = 1;                         
    while(ADCON0bits.GO_DONE);                 
    return ((uint16_t)((ADRESH<<8)+ADRESL));   
}
