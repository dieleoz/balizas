/**
 * ING. FREIMAN PARGA
 * 24 DE NOVIEMBRE DEL 2022
 * Modificado: 21-ago-2026 - Cadencia 1.0 Hz (500 ms ON / 500 ms OFF)
 */

#include "Cluster.h"
#include "Aplicacion.h"
#include "main.h"
#include "Buzzer.h"

//*** ESTRUCTURAS EXTERNAS ***
extern strAplicacion ap;
//****************************

//*** ESTRUCTURAS ***
strCluster cl;
//*******************

//*** ENUM ***
enum states_cluster stateCluster;
//************

unsigned long ulCntPeriodCluster;
static struct pt ptTaskCluster;

static int taskCluster(struct pt *pt)
{   
    PT_BEGIN(pt);
    while (1) 
    {
        ulCntPeriodCluster = getMillis() + PERIOD_CLUSTER;
        PT_WAIT_UNTIL(pt, getMillis() >= ulCntPeriodCluster);
        switch(stateCluster)
        {
            case ST_ARRANQUE_CL:
                if(ap.flagArranque)
                {
                    stateCluster = ST_ESPERA_CL;
                }
                break;
                
            case ST_ESPERA_CL:
                if(cl.flagEvento)
                {
                    ON_CLUSTER;
                    cl.uiCnt = 0;
                    stateCluster = ST_HIGH_CL;
                }
                else
                {
                    OFF_CLUSTER;
                }
                break;
                
            case ST_HIGH_CL:
                if(++cl.uiCnt >= CLUSTER_TIME_ON_TICKS)
                {
                    cl.uiCnt = 0;
                    OFF_CLUSTER;
                    stateCluster = ST_LOW_CL;
                }
                break;
                
            case ST_LOW_CL:
                if(++cl.uiCnt >= CLUSTER_TIME_OFF_TICKS)
                {
                    cl.uiCnt = 0;
                    if(cl.flagEvento)
                    {
                        ON_CLUSTER;
                        stateCluster = ST_HIGH_CL;
                    }
                    else
                    {
                        stateCluster = ST_ESPERA_CL;
                    }                    
                }
                break;
        }
    }
    PT_END(pt);
}

void startTaskCluster(void)
{
    PT_INIT(&ptTaskCluster);
}

void executeTaskCluster(void)
{
    taskCluster(&ptTaskCluster);
}

void pinConfCluster(void)
{
    TRISCbits.TRISC2 = 0;
}
