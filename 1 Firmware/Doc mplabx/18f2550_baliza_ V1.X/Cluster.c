/**
 * 
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
enum states_cluster  stateCluster;
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
                    oneBeep();
                    stateCluster = ST_HIGH_CL;
                }
                else
                {
                    OFF_CLUSTER;
                }
                break;
                
                
            case ST_HIGH_CL:
                if(++cl.uiCnt >= 5)
                {
                    cl.uiCnt = 0;
                    OFF_CLUSTER;
                    stateCluster = ST_LOW_CL;
                }
                break;
                
            case ST_LOW_CL:
                if(++cl.uiCnt >= 5)
                {
                    cl.uiCnt = 0;
                    
                    if(++cl.itera >= 5)
                    {
                        cl.itera = 0;
                        stateCluster = ST_LOW_SLOW_CL;
                    }
                    else
                    {
                        ON_CLUSTER;
                        stateCluster = ST_HIGH_CL;
                    }                    
                }
                break;
                
            case ST_LOW_SLOW_CL:
                if(++cl.uiCnt >= 50)
                {
                    cl.uiCnt = 0;
                    
                    cl.flagEvento = false;
                    stateCluster = ST_ESPERA_CL;
                }
                break;
        }//fin switch
    }//FIN WHILE
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