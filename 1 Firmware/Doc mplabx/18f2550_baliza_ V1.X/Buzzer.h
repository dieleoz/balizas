/* 
 * File:   Buzzer.h
 * Author: ing. freiman Parga
 *
 * Created on November 6, 2020, 12:00 PM
 */

#ifndef BUZZER_H
#define	BUZZER_H

#ifdef	__cplusplus
extern "C" {
#endif

//*** INCLUDES ***
#include "TimeBase.h"
#include <xc.h>
#include "Rtos/pt.h"
//****************
    
//*** DEFINICIONES ***
#define PERIOD_BUZZER      10
    
#define ON_BUZZER       LATCbits.LATC0 = 1
#define OFF_BUZZER      LATCbits.LATC0 = 0
 
#define BUZZER_CANCEL_BEEP  0
#define BUZZER_ONE_BEEP     1
#define BUZZER_TWO_BEEP     2
#define BUZZER_ALARM_BEEP   3
//********************

enum States_Buzzer
{
    ST_WAIT_BUZZER,
    ST_ONE_BUZZER,
    ST_TWO_BUZZER,
    ST_ALARM_BUZZER,
    ST_WAIT_LOW_BUZZER
};

//***PROTOTIPO DE LAS FUNCIONES
void startTaskBuzzer(void);
void executeTaskBuzzer(void);


static int taskBuzzer(struct pt *pt);

void oneBeep(void);
void twoBeep(void);
void alarmBeep(void);
void cancelBeep(void);
unsigned char endBeep(void);
void pinConfBuzzer(void);
#ifdef	__cplusplus
}
#endif

#endif	/* BUZZER_H */

