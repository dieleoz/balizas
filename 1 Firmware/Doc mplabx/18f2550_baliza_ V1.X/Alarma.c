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

static unsigned char isAlarmActive(srtAlarmas *a, strRtc *r)
{
    unsigned int t_act, t_init, t_end;
    if(!a->flagAlarm) return 0;
    
    // Comprobar dia
    if(!a->flagDayAlar)
    {
        if(a->dayAlar == DIAR) {
            // Todos los dias
        }
        else if(a->dayAlar == SEMA) {
            if((r->dayWeek < LUNE) || (r->dayWeek > VIER)) return 0;
        }
        else if(a->dayAlar == FINS) {
            if((r->dayWeek != SABA) && (r->dayWeek != DOMI)) return 0;
        }
        else {
            return 0;
        }
    }
    else
    {
        // Personalizado
        if((a->dayAlar >= LUNE) && (a->dayAlar <= DOMI)) {
            if(r->dayWeek != a->dayAlar) return 0;
        } else {
            return 0;
        }
    }
    
    // Comprobar franja horaria
    t_act = (unsigned int)r->hor * 60 + (unsigned int)r->min;
    t_init = (unsigned int)a->hourInit * 60 + (unsigned int)a->minInit;
    t_end = (unsigned int)a->hourEnd * 60 + (unsigned int)a->minEnd;
    
    if(t_init < t_end)
    {
        if(t_act >= t_init && t_act < t_end) return 1;
    }
    else if(t_init > t_end)
    {
        // Cruce de medianoche
        if(t_act >= t_init || t_act < t_end) return 1;
    }
    
    return 0;
}

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
                ap.flagAlarm = (isAlarmActive(&ala1, &rtc) ||
                                isAlarmActive(&ala2, &rtc) ||
                                isAlarmActive(&ala3, &rtc) ||
                                isAlarmActive(&ala4, &rtc) ||
                                isAlarmActive(&ala5, &rtc));

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
                    if((ala1.dayAlar >= LUNE) && (ala1.dayAlar <= DOMI) && (rtc.dayWeek == ala1.dayAlar))
                    {
                        stateAlarm = ST_CHECK_HOUR1;
                    }
                    else
                    {
                        stateAlarm = ST_ESPERA_ALA;
                    }
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
                    if((ala2.dayAlar >= LUNE) && (ala2.dayAlar <= DOMI) && (rtc.dayWeek == ala2.dayAlar))
                    {
                        stateAlarm = ST_CHECK_HOUR2;
                    }
                    else
                    {
                        stateAlarm = ST_ESPERA_ALA;
                    }
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
                    if((ala3.dayAlar >= LUNE) && (ala3.dayAlar <= DOMI) && (rtc.dayWeek == ala3.dayAlar))
                    {
                        stateAlarm = ST_CHECK_HOUR3;
                    }
                    else
                    {
                        stateAlarm = ST_ESPERA_ALA;
                    }
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
                    if((ala4.dayAlar >= LUNE) && (ala4.dayAlar <= DOMI) && (rtc.dayWeek == ala4.dayAlar))
                    {
                        stateAlarm = ST_CHECK_HOUR4;
                    }
                    else
                    {
                        stateAlarm = ST_ESPERA_ALA;
                    }
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
                    if((ala5.dayAlar >= LUNE) && (ala5.dayAlar <= DOMI) && (rtc.dayWeek == ala5.dayAlar))
                    {
                        stateAlarm = ST_CHECK_HOUR5;
                    }
                    else
                    {
                        stateAlarm = ST_ESPERA_ALA;
                    }
                }
                break;
                
            case ST_CHECK_HOUR1:
            case ST_CHECK_HOUR2:
            case ST_CHECK_HOUR3:
            case ST_CHECK_HOUR4:
            case ST_CHECK_HOUR5:
                ap.flagAlarm = (isAlarmActive(&ala1, &rtc) ||
                                isAlarmActive(&ala2, &rtc) ||
                                isAlarmActive(&ala3, &rtc) ||
                                isAlarmActive(&ala4, &rtc) ||
                                isAlarmActive(&ala5, &rtc));
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



