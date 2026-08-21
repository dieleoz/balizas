/* 
 * File:   Alarma.h
 * Author: ING. FREIMAN PARGA
 */

#ifndef ALARMA_H
#define ALARMA_H

#ifdef __cplusplus
extern "C" {
#endif

//*** DEFINICIONES DE DIAS ***
#define LUNE    1
#define MART    2
#define MIER    3
#define JUEV    4
#define VIER    5
#define SABA    6
#define DOMI    7

#define DIAR    8   // diariamente
#define SEMA    9   // lunes - viernes
#define FINS    10  // fin de semana

//*** INCLUDES ***
#include "TimeBase.h"
#include <xc.h>
#include "Rtos/pt.h"

#define PERIOD_ALARM    10

typedef struct
{
    unsigned int uiCnt;
    unsigned int uiCnt2;
    unsigned char ucCntCheck;
    unsigned char flagUpdate    :1;
}strAlarm;

typedef struct 
{
    unsigned char flagAlarm     :1;     // si es 0, no hay alarma programada
    unsigned char flagDayAlar   :1;     // flag reservado
    unsigned char dayAlar;              // 8=DIAR, 9=SEMA, 10=FINS
    unsigned char bufferDayAlar[8];
    
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
    ST_UPDATE_VALUE_ALA
};

//*** PROTOTIPO DE LAS FUNCIONES ***
static int taskAlarm(struct pt *pt);
void startTaskAlarm(void);
void executeTaskAlarm(void);

#ifdef __cplusplus
}
#endif

#endif /* ALARMA_H */
