/* 
 * File:   LedLive.h
 * Author: Ing. freiman parga
 *
 * Created: 3 de enero del 2021
 */

#ifndef LEDLIVE_H
#define	LEDLIVE_H

#ifdef	__cplusplus
extern "C" {
#endif

//*** INCLUDES ***
#include "TimeBase.h"
    
#include <xc.h>
#include "Rtos/pt.h"
//****************
    
//*** DEFINICIONES ***
#define PERIOD_LEDLIVE      10
   
#define TOOGLE_LED_LIVE     LATAbits.LATA0 = LATAbits.LATA0 ^ 1    
#define ON_LED_LIVE         LATAbits.LATA0 = 0
#define OFF_LED_LIVE        LATAbits.LATA0 = 1
    
#define TIME_HIGH_LED       5
#define TIME_LOW_LED        195
    
   
//********************

//*** ENUM ***
enum states_ledLive
{
    ST_ARRANQUE_LED,
    ST_HIGH_LED,
    ST_LOW_LED,
};
//************
    
//***PROTOTIPO DE LAS FUNCIONES
void startTaskLedLive(void);
void executeTaskLedLive(void);

void pinConfLedPin(void);


static int protoTheadLedLive(struct pt *pt);


#ifdef	__cplusplus
}
#endif

#endif	/* LEDLIVE_H */

