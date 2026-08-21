/*
 * DATE: 5 DE NOVIEMBRE DE 2020
 * AUTOR: ING. FREIMAN PARGA
 * 
 * 
 */


#include "TimeBase.h"

//*** VARIABLES EXTERNAS ***
extern unsigned long ulCntTick1ms;             //cnt 1ms
//**************************

unsigned long getMillis(void)
{
    return ulCntTick1ms;
}

