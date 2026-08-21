/**
 * ING. FREIMAN PARGA
 * 24 DE NOVIEMBRE DEL 2022
 */

//*** INCLUDES ***
#include "TimeBase.h"
#include <xc.h>
#include "Rtos/pt.h"
//****************
    
//*** DEFINICIONES ***
#define PERIOD_CLUSTER      10

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
    ST_LOW_CL,
    ST_LOW_SLOW_CL
};

//*** PROTOTIPO DE LAS FUNCIONES ***
static int taskCluster(struct pt *pt);
void startTaskCluster(void);
void executeTaskCluster(void);

void pinConfCluster(void);



