/*
 * File:   Alarma.c
 * Author: ing. freimann parga
 *
 * Created on 14 de octubre de 2022, 03:01 PM
 */


#include "Alarma.h"
#include "Aplicacion.h"
#include "DS1307.h"
#include "main.h"


//*** ESTRUCTURAS EXTERNAS ***
extern strAplicacion ap;
extern strRtc rtc;
extern strMemory memo;
//****************************

//*** ESTRUCTURAS ***
strAlarm ala;

srtAlarmas ala1;
srtAlarmas ala2;
srtAlarmas ala3;
srtAlarmas ala4;
srtAlarmas ala5;
//*******************

//*** ENUM ***
enum states_alarm  stateAlarm;
//************


unsigned long ulCntPeriodAlarm;

static struct pt ptTaskAlarm;

static int taskAlarm(struct pt *pt)
{
        
    PT_BEGIN(pt);
    while (1) 
    {
        ulCntPeriodAlarm = getMillis() + PERIOD_ALARM;
        PT_WAIT_UNTIL(pt, getMillis() >= ulCntPeriodAlarm);
        
        switch(stateAlarm)
        {
            case ST_ARRANQUE_ALA:
                if(ap.flagArranque)
                {                
                    leerRTC(&rtc.hor, &rtc.min, &rtc.seg, &rtc.day, &rtc.month, &rtc.year, &rtc.dayWeek);
                    stateAlarm = ST_ESPERA_ALA;
                }
                break;
                
            case ST_UPDATE_ALA:
                ala1.flagAlarm = memo.ucEnaAla1;
                ala1.flagDayAlar = memo.ucflagDayAla1;
                ala1.dayAlar = memo.ucDayWeek1;
                ala1.hourInit = memo.ucInitHour1;
                ala1.minInit = memo.ucInitMin1;
                ala1.hourEnd = memo.ucEndHour1;
                ala1.minEnd = memo.ucEndMin1;
                
                ala2.flagAlarm = memo.ucEnaAla2;
                ala2.flagDayAlar = memo.ucflagDayAla2;
                ala2.dayAlar = memo.ucDayWeek2;
                ala2.hourInit = memo.ucInitHour2;
                ala2.minInit = memo.ucInitMin2;
                ala2.hourEnd = memo.ucEndHour2;
                ala2.minEnd = memo.ucEndMin2;
                
                ala3.flagAlarm = memo.ucEnaAla3;
                ala3.flagDayAlar = memo.ucflagDayAla3;
                ala3.dayAlar = memo.ucDayWeek3;
                ala3.hourInit = memo.ucInitHour3;
                ala3.minInit = memo.ucInitMin3;
                ala3.hourEnd = memo.ucEndHour3;
                ala3.minEnd = memo.ucEndMin3;
                
                ala4.flagAlarm = memo.ucEnaAla4;
                ala4.flagDayAlar = memo.ucflagDayAla4;
                ala4.dayAlar = memo.ucDayWeek4;
                ala4.hourInit = memo.ucInitHour4;
                ala4.minInit = memo.ucInitMin4;
                ala4.hourEnd = memo.ucEndHour4;
                ala4.minEnd = memo.ucEndMin4;
                
                ala5.flagAlarm = memo.ucEnaAla5;
                ala5.flagDayAlar = memo.ucflagDayAla5;
                ala5.dayAlar = memo.ucDayWeek5;
                ala5.hourInit = memo.ucInitHour5;
                ala5.minInit = memo.ucInitMin5;
                ala5.hourEnd = memo.ucEndHour5;
                ala5.minEnd = memo.ucEndMin5;
                
                stateAlarm = ST_ESPERA_ALA;
                
                break;
                
            case ST_ESPERA_ALA:
                if(++ala.uiCnt >= 50)
                {
                    ala.uiCnt = RST;
                    
                    if(rtc.seg != 0)
                    {
                        stateAlarm = ST_UPDATE_SEG_ALA;
                    }                    
                    else
                    {
                        stateAlarm = ST_UPDATE_VALUE_ALA;
                    }                 
                }
                else if(++ala.uiCnt2 >= 20)
                {
                    ala.uiCnt2 = RST;
                    stateAlarm = ST_CHECK_ALL_ALA;
                }
                else if(ala.flagUpdate)
                {
                    ala.flagUpdate = false;
                    stateAlarm = ST_UPDATE_ALA;
                }
                break;
                
            case ST_CHECK_ALL_ALA:
                if(++ala.ucCntCheck == 1)
                {
                    //si esta activa la alarma
                    if(ala1.flagAlarm)
                    {
                        stateAlarm = ST_CHECK_ALARM1;                           
                    }
                    else
                    {
                        stateAlarm = ST_ESPERA_ALA;
                    }
                }
                else if(ala.ucCntCheck == 2)
                {
                    if(ala2.flagAlarm)
                    {
                        stateAlarm = ST_CHECK_ALARM2; 
                    }
                    else
                    {
                        stateAlarm = ST_ESPERA_ALA;
                    }
                }
                else if(ala.ucCntCheck == 3)
                {
                    if(ala3.flagAlarm)
                    {
                        stateAlarm = ST_CHECK_ALARM3; 
                    }
                    else
                    {
                        stateAlarm = ST_ESPERA_ALA;
                    }
                }
                else if(ala.ucCntCheck == 4)
                {
                    if(ala4.flagAlarm)
                    {
                        stateAlarm = ST_CHECK_ALARM4; 
                    }
                    else
                    {
                        stateAlarm = ST_ESPERA_ALA;
                    }
                }
                else if(ala.ucCntCheck == 5)
                {
                    ala.ucCntCheck = RST;

                    if(ala5.flagAlarm)
                    {
                        stateAlarm = ST_CHECK_ALARM5; 
                    }
                    else
                    {
                        stateAlarm = ST_ESPERA_ALA;
                    }
                }
                break;
                
            case ST_UPDATE_SEG_ALA:
                leerRtcSeg(&rtc.seg);
                stateAlarm = ST_ESPERA_ALA;
                break;
                
            case ST_UPDATE_VALUE_ALA:
                leerRTC(&rtc.hor, &rtc.min, &rtc.seg, &rtc.day, &rtc.month, &rtc.year, &rtc.dayWeek);
                stateAlarm = ST_ESPERA_ALA;
                break;
                
            case ST_CHECK_ALARM1:
                //si no personalizado
                if(!ala1.flagDayAlar)
                {
                    if(ala1.dayAlar == DIAR)
                    {
                       stateAlarm = ST_CHECK_HOUR1;
                    }
                    
                    else if(ala1.dayAlar == SEMA)
                    {
                        //if el rtc se encuentra entre estos dias
                        if((rtc.dayWeek >= LUNE) && (rtc.dayWeek <= VIER))
                        {
                            stateAlarm = ST_CHECK_HOUR1;
                        }
                        else
                        {
                            stateAlarm = ST_ESPERA_ALA;
                        }
                    }
                                        
                    else if(ala1.dayAlar == FINS)
                    {
                        //si se encuentra en estos dias
                        if((rtc.dayWeek == SABA) || (rtc.dayWeek == DOMI))
                        {
                            stateAlarm = ST_CHECK_HOUR1;
                        }
                        else
                        {
                            stateAlarm = ST_ESPERA_ALA;
                        }
                    }
                    else
                    {
                        stateAlarm = ST_ESPERA_ALA;
                    }
                    
                }
                else
                {
                    //NO IMPLEMENTADO
                    //si la alarma es personalizada  
                }
                break;
                
                
            case ST_CHECK_ALARM2:
                if(!ala2.flagDayAlar)
                {
                    if(ala2.dayAlar == DIAR)
                    {
                       stateAlarm = ST_CHECK_HOUR2;
                    }
                    
                    else if(ala2.dayAlar == SEMA)
                    {
                        //if el rtc se encuentra entre estos dias
                        if((rtc.dayWeek >= LUNE) && (rtc.dayWeek <= VIER))
                        {
                            stateAlarm = ST_CHECK_HOUR2;
                        }
                        else
                        {
                            stateAlarm = ST_ESPERA_ALA;
                        }
                    }
                    else if(ala2.dayAlar == FINS)
                    {
                        //si se encuentra en estos dias
                        if((rtc.dayWeek == SABA) || (rtc.dayWeek == DOMI))
                        {
                            stateAlarm = ST_CHECK_HOUR2;
                        }
                        else
                        {
                            stateAlarm = ST_ESPERA_ALA;
                        }
                    }
                    else
                    {
                        stateAlarm = ST_ESPERA_ALA;
                    }
                }
                else
                {
                    //si la alarma es personalizada
                }
                break;
                
            case ST_CHECK_ALARM3:
                if(!ala3.flagDayAlar)
                {
                    if(ala3.dayAlar == DIAR)
                    {
                       stateAlarm = ST_CHECK_HOUR3;
                    }
                    
                    else if(ala3.dayAlar == SEMA)
                    {
                        //if el rtc se encuentra entre estos dias
                        if((rtc.dayWeek >= LUNE) && (rtc.dayWeek <= VIER))
                        {
                            stateAlarm = ST_CHECK_HOUR3;
                        }
                        else
                        {
                            stateAlarm = ST_ESPERA_ALA;
                        }
                    }
                    else if(ala3.dayAlar == FINS)
                    {
                        //si se encuentra en estos dias
                        if((rtc.dayWeek == SABA) || (rtc.dayWeek == DOMI))
                        {
                            stateAlarm = ST_CHECK_HOUR3;
                        }
                        else
                        {
                            stateAlarm = ST_ESPERA_ALA;
                        }
                    }
                    else
                    {
                        stateAlarm = ST_ESPERA_ALA;
                    }
                }
                else
                {
                    //si la alarma es personalizada
                }
                break;
                
            case ST_CHECK_ALARM4:
                if(!ala4.flagDayAlar)
                {
                    if(ala4.dayAlar == DIAR)
                    {
                       stateAlarm = ST_CHECK_HOUR4;
                    }
                    
                    else if(ala4.dayAlar == SEMA)
                    {
                        //if el rtc se encuentra entre estos dias
                        if((rtc.dayWeek >= LUNE) && (rtc.dayWeek <= VIER))
                        {
                            stateAlarm = ST_CHECK_HOUR4;
                        }
                        else
                        {
                            stateAlarm = ST_ESPERA_ALA;
                        }
                    }
                    else if(ala4.dayAlar == FINS)
                    {
                        //si se encuentra en estos dias
                        if((rtc.dayWeek == SABA) || (rtc.dayWeek == DOMI))
                        {
                            stateAlarm = ST_CHECK_HOUR4;
                        }
                        else
                        {
                            stateAlarm = ST_ESPERA_ALA;
                        }
                    }
                    else
                    {
                        stateAlarm = ST_ESPERA_ALA;
                    }
                }
                else
                {
                    //si la alarma es personalizada
                }
                break;
                
            case ST_CHECK_ALARM5:
                if(!ala5.flagDayAlar)
                {
                    if(ala5.dayAlar == DIAR)
                    {
                       stateAlarm = ST_CHECK_HOUR5;
                    }
                    
                    else if(ala5.dayAlar == SEMA)
                    {
                        //if el rtc se encuentra entre estos dias
                        if((rtc.dayWeek >= LUNE) && (rtc.dayWeek <= VIER))
                        {
                            stateAlarm = ST_CHECK_HOUR5;
                        }
                        else
                        {
                            stateAlarm = ST_ESPERA_ALA;
                        }
                    }
                    else if(ala5.dayAlar == FINS)
                    {
                        //si se encuentra en estos dias
                        if((rtc.dayWeek == SABA) || (rtc.dayWeek == DOMI))
                        {
                            stateAlarm = ST_CHECK_HOUR5;
                        }
                        else
                        {
                            stateAlarm = ST_ESPERA_ALA;
                        }
                    }
                    else
                    {
                        stateAlarm = ST_ESPERA_ALA;
                    }
                }
                else
                {
                    //si la alarma es personalizada
                }
                break;
                
            case ST_CHECK_HOUR1:
                
                //if es hora de init alarm
                if(rtc.hor == ala1.hourInit)
                {
                    if(rtc.min == ala1.minInit)
                    {
                        //iniciciar la secuencia de la alarma
                        ap.flagAlarm = true;
                                               
                    }                    
                }
                
                //if es hora de end alarm
                if(rtc.hor == ala1.hourEnd)
                {
                    if(rtc.min == ala1.minEnd)
                    {
                        //finalizar la secuencia de la alarma
                        ap.flagAlarm = false;
                                                
                    }                 
                }
                
                 stateAlarm = ST_ESPERA_ALA;
                
                break;
                
                
            case ST_CHECK_HOUR2:
                //if es hora de init alarm
                if(rtc.hor == ala2.hourInit)
                {
                    if(rtc.min == ala2.minInit)
                    {
                        //iniciciar la secuencia de la alarma
                        ap.flagAlarm = true;
                                               
                    }                    
                }
                
                //if es hora de end alarm
                if(rtc.hor == ala2.hourEnd)
                {
                    if(rtc.min == ala2.minEnd)
                    {
                        //finalizar la secuencia de la alarma
                        ap.flagAlarm = false;
                                                
                    }                 
                }
                
                 stateAlarm = ST_ESPERA_ALA;
                
                break;
                
                
            case ST_CHECK_HOUR3:
                //if es hora de init alarm
                if(rtc.hor == ala3.hourInit)
                {
                    if(rtc.min == ala3.minInit)
                    {
                        //iniciciar la secuencia de la alarma
                        ap.flagAlarm = true;
                                               
                    }                    
                }
                
                //if es hora de end alarm
                if(rtc.hor == ala3.hourEnd)
                {
                    if(rtc.min == ala3.minEnd)
                    {
                        //finalizar la secuencia de la alarma
                        ap.flagAlarm = false;
                                                
                    }                 
                }
                
                 stateAlarm = ST_ESPERA_ALA;
                
                break;
                
            case ST_CHECK_HOUR4:
                //if es hora de init alarm
                if(rtc.hor == ala4.hourInit)
                {
                    if(rtc.min == ala4.minInit)
                    {
                        //iniciciar la secuencia de la alarma
                        ap.flagAlarm = true;
                                               
                    }                    
                }
                
                //if es hora de end alarm
                if(rtc.hor == ala4.hourEnd)
                {
                    if(rtc.min == ala4.minEnd)
                    {
                        //finalizar la secuencia de la alarma
                        ap.flagAlarm = false;
                                                
                    }                 
                }
                
                 stateAlarm = ST_ESPERA_ALA;
                
                break;
                
            case ST_CHECK_HOUR5:
                //if es hora de init alarm
                if(rtc.hor == ala5.hourInit)
                {
                    if(rtc.min == ala5.minInit)
                    {
                        //iniciciar la secuencia de la alarma
                        ap.flagAlarm = true;
                                               
                    }                    
                }
                
                //if es hora de end alarm
                if(rtc.hor == ala5.hourEnd)
                {
                    if(rtc.min == ala5.minEnd)
                    {
                        //finalizar la secuencia de la alarma
                        ap.flagAlarm = false;
                                                
                    }                 
                }
                
                 stateAlarm = ST_ESPERA_ALA;
                
                break;
        }//fin switch
    }//FIN WHILE
    PT_END(pt);
}

void startTaskAlarm(void)
{
        PT_INIT(&ptTaskAlarm);
}
void executeTaskAlarm(void)
{
    taskAlarm(&ptTaskAlarm);
}



