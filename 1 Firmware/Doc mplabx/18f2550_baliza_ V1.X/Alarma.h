
/*    
 * Author: ING. FREIMAN PARGA
 * Comments:
 * Revision history: 
 */

// This is a guard condition so that contents of this file are not included
// more than once.  
#ifndef ALARMA_H
#define	ALARMA_H

#define LUNE    1
#define MART    2
#define MIER    3
#define JUEV    4
#define VIER    5
#define SABA    6
#define DOMI    7

#define DIAR    8   //diariamente
#define SEMA    9   //lunes - viernes
#define FINS    10  //fin de semana


//*** INCLUDES ***
#include "TimeBase.h"
#include <xc.h>
#include "Rtos/pt.h"
//****************


 #define PERIOD_ALARM    10




typedef struct
{
    unsigned int uiCnt;
    unsigned int uiCnt2;
    unsigned char ucCntCheck;
    
    unsigned char flagUpdate            :1;
//    unsigned char flagEnAlarm1      :1;
//    unsigned char flagEnAlarm2      :1;
//    unsigned char flagEnAlarm3      :1;
//    unsigned char flagEnAlarm4      :1;
//    unsigned char flagEnAlarm5      :1;
}strAlarm;


typedef struct 
{
    unsigned char flagAlarm         :1;     //si es 0, no hay alarma programada

    unsigned char flagDayAlar       :1;     //si es = 0 no esta personalizado el dia, si es 1 puede ser cualquier dia de la semana
    unsigned char dayAlar;                  //8,9,10
    unsigned char bufferDayAlar[8];         //1,2,3,4,5,6,7
    
    unsigned char hourInit;
    unsigned char minInit;
    
    unsigned char hourEnd;
    unsigned char minEnd;
}srtAlarmas;




enum states_alarm
{
    ST_ARRANQUE_ALA,
    ST_UPDATE_ALA,
    ST_ESPERA_ALA,
    ST_CHECK_ALL_ALA,
    ST_UPDATE_SEG_ALA,
    ST_UPDATE_VALUE_ALA,
    ST_CHECK_ALARM1,
    ST_CHECK_ALARM2,
    ST_CHECK_ALARM3,
    ST_CHECK_ALARM4,
    ST_CHECK_ALARM5,
    
    ST_CHECK_HOUR1,
    ST_CHECK_HOUR2,
    ST_CHECK_HOUR3,
    ST_CHECK_HOUR4,
    ST_CHECK_HOUR5
};


//*** PROTOTIPO DE LAS FUNCIONES ***
static int taskAlarm(struct pt *pt);
void startTaskAlarm(void);
void executeTaskAlarm(void);

//**********************************



#ifdef	__cplusplus
extern "C" {
#endif /* __cplusplus */

    // TODO If C++ is being used, regular C code needs function names to have C 
    // linkage so the functions can be used by the c code. 

#ifdef	__cplusplus
}
#endif /* __cplusplus */
#endif

