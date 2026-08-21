#include "Buzzer.h"
#include "main.h"

//*** ENUM ***
enum States_Buzzer stateBuzzer;
//************

//*** VARIABLES ***
unsigned char ucTypeBeep = 0;
unsigned char ucCntTimeBuzzer = 0;
unsigned char ucIteradorBuzzer = 0;
unsigned char flagStartBuzzer = 0;
//*****************

unsigned long ulCntPeriodBuzzer;
static struct pt ptTaskBuzzer;

static int taskBuzzer(struct pt *pt)
{
    
    PT_BEGIN(pt);
    while (1) 
    {
        ulCntPeriodBuzzer = getMillis() + PERIOD_BUZZER;
        PT_WAIT_UNTIL(pt, getMillis() >= ulCntPeriodBuzzer);
        
        switch(stateBuzzer)
        {
            //========================================
            //ESTADO QUE ESPERA ALGUNA ACTIVIDAD
            //========================================
            case ST_WAIT_BUZZER:
                if(ucTypeBeep == BUZZER_ONE_BEEP)
                {
                    ON_BUZZER;
                    stateBuzzer = ST_ONE_BUZZER;
                }
                else if(ucTypeBeep == BUZZER_TWO_BEEP)
                {
                    ucIteradorBuzzer--;
                    ON_BUZZER;
                    stateBuzzer = ST_TWO_BUZZER;
                }
                else if(ucTypeBeep == BUZZER_ALARM_BEEP)
                {
                    ON_BUZZER;
                    stateBuzzer = ST_ALARM_BUZZER;
                }
                else
                {
                    ucTypeBeep = BUZZER_CANCEL_BEEP;
                    ucCntTimeBuzzer = 0;
                    flagStartBuzzer = false;
                    
                    OFF_BUZZER;
                }
                break;
              
            //========================================
            //ESTADO QUE EJECUTA UN BEEP
            //========================================
            case ST_ONE_BUZZER:
                //si el contador es mayor a 50ms
                if(++ucCntTimeBuzzer >= 5)
                {
                    ucCntTimeBuzzer = 0;
                    OFF_BUZZER;
                    ucTypeBeep = BUZZER_CANCEL_BEEP;
                    stateBuzzer = ST_WAIT_BUZZER;
                }
                break;
            //========================================
            //ESTADO QUE EJECUTA DOS BEEP
            //========================================  
            case ST_TWO_BUZZER:
         
                if(++ucCntTimeBuzzer >= 5)
                {
                    ucCntTimeBuzzer = 0;
                    //si se cumple la iteracion
                    if(!ucIteradorBuzzer)
                    {
                        OFF_BUZZER;
                        ucTypeBeep = BUZZER_CANCEL_BEEP;
                        stateBuzzer = ST_WAIT_BUZZER;
                    }
                    else
                    {
                        OFF_BUZZER;
                        stateBuzzer = ST_WAIT_LOW_BUZZER;                   
                    }               
                }              
                break;
             
            //========================================
            //ESTADO QUE EJECUTA BEEPS SUCESIVOS HASTA UNA CANCELACION
            //========================================
            case ST_ALARM_BUZZER:
                if(++ucCntTimeBuzzer >= 5)
                {
                    ucCntTimeBuzzer = 0;
                     OFF_BUZZER;
                     stateBuzzer = ST_WAIT_LOW_BUZZER;
                }
                break;
            //========================================
            //ESTADO DE ESPERA EN BAJO
            //========================================   
            case ST_WAIT_LOW_BUZZER:
                if(++ucCntTimeBuzzer >= 5)
                {
                    ucCntTimeBuzzer = 0;
                    stateBuzzer = ST_WAIT_BUZZER;
                }
                break;
        }//FIN SWITCH
    }//FIN WHILE
    PT_END(pt);
}

void startTaskBuzzer(void)
{
    PT_INIT(&ptTaskBuzzer);
}

void executeTaskBuzzer(void)
{
    taskBuzzer(&ptTaskBuzzer);
}



void oneBeep(void)
{
    ucTypeBeep = BUZZER_ONE_BEEP;
    flagStartBuzzer = true;
}
void twoBeep(void)
{
    ucTypeBeep = BUZZER_TWO_BEEP;
    ucIteradorBuzzer = 2;
    flagStartBuzzer = true;
}
void alarmBeep(void)
{
    ucTypeBeep = BUZZER_ALARM_BEEP;
    flagStartBuzzer = true;
}
void cancelBeep(void)
{
    ucTypeBeep = BUZZER_CANCEL_BEEP;
    flagStartBuzzer = true;
}

unsigned char endBeep(void)
{
    return !flagStartBuzzer;
}

void pinConfBuzzer(void)
{
    TRISCbits.TRISC1 = 0;
    TRISCbits.TRISC0 = 1;
}
