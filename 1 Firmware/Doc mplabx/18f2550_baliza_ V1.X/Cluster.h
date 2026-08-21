/**
 * ING. FREIMAN PARGA
 * 24 DE NOVIEMBRE DEL 2022
 */

#ifndef CLUSTER_H
#define CLUSTER_H

#ifdef __cplusplus
extern "C" {
#endif

//*** INCLUDES ***
#include "TimeBase.h"
#include <xc.h>
#include "Rtos/pt.h"
//****************
    
//*** DEFINICIONES ***
#define PERIOD_CLUSTER          10

// Cadencia Normativa Oficial (1.0 Hz = 60 destellos/minuto)
#define CLUSTER_TIME_ON_TICKS   50  // 50 x 10 ms = 500 ms encendido
#define CLUSTER_TIME_OFF_TICKS  50  // 50 x 10 ms = 500 ms apagado

#define ON_CLUSTER       LATCbits.LATC2 = 1
#define OFF_CLUSTER      LATCbits.LATC2 = 0

typedef struct
{
    unsigned int uiCnt;
    unsigned char flagEvento;
    unsigned char itera;
}strCluster;

enum states_cluster
{
    ST_ARRANQUE_CL,
    ST_ESPERA_CL,
    ST_HIGH_CL,
    ST_LOW_CL
};

//*** PROTOTIPO DE LAS FUNCIONES ***
static int taskCluster(struct pt *pt);
void startTaskCluster(void);
void executeTaskCluster(void);
void pinConfCluster(void);

#ifdef __cplusplus
}
#endif

#endif /* CLUSTER_H */
