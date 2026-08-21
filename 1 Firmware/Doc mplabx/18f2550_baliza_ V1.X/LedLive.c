/*
 * DATE: 3 DE MAYO DEL 2021
 * AUTOR: ING. FREIMAN PARGA
 * 
 * 
 */

#include "LedLive.h"
#include "main.h"
#include "Aplicacion.h"



//*** ENUM ***
enum states_ledLive state_ledLive;
//************

//*** ESTRUCTURAS EXTERNAS ***
strAplicacion ap;
//****************************

//*** VARIABLES EXTERNAS ***

//**************************

//*** VARIABLES ***
unsigned int uiCntLedLive = 0;
unsigned char flagInitStLed = 0;
//*****************

unsigned long ulCntPeriodLedLive = 0;

static struct pt ptTaskLedLive;

static int taskLedLive(struct pt *pt)
{
    PT_BEGIN(pt);
    while (1) 
    {
        ulCntPeriodLedLive = getMillis() + PERIOD_LEDLIVE;
        PT_WAIT_UNTIL(pt, getMillis() >= ulCntPeriodLedLive);
         
        switch(state_ledLive)
        {
            case ST_ARRANQUE_LED:
                ON_LED_LIVE;
                if(ap.flagArranque)
                {
                    state_ledLive = ST_HIGH_LED;
                }                                    
                break;
                
            case ST_HIGH_LED:                              
                if(!flagInitStLed)
                {
                    flagInitStLed = true;
                    ON_LED_LIVE; 
                }
                else
                {
                    if(++uiCntLedLive >= TIME_HIGH_LED)
                    {
                        uiCntLedLive = 0;
                        flagInitStLed = false;
                        state_ledLive = ST_LOW_LED;
                    }
                }                                               
                break;
                
            case ST_LOW_LED:
                if(!flagInitStLed)
                {
                    flagInitStLed = true;
                    OFF_LED_LIVE; 
                }
                else
                {
                    if(++uiCntLedLive >= TIME_LOW_LED)
                    {
                        uiCntLedLive = 0;
                        flagInitStLed = false;
                        state_ledLive = ST_HIGH_LED;
                    }
                }                                                
                break;
        }//FIN SWITCH
    }//FIN WHILE
    PT_END(pt);
}

void executeTaskLedLive(void) {
    taskLedLive(&ptTaskLedLive);
}

void startTaskLedLive(void) {
    PT_INIT(&ptTaskLedLive);
}

void pinConfLedPin(void)
{
    TRISAbits.TRISA0 = 0;

    LATAbits.LATA0 = 1;
    LATAbits.LATA0 = 0;

}