/*
 * APLICACION BALIZA TEMPORIZADA
 * AUTOR: ING. FREIMAN PARGA
 * 14 DE OCTUBRE DEL 2022
 * VERSION 1.0
 */

/*
 * OBSERVACIONES:
 *              
 * PENDIENTES:
 *              
 */

#include "Aplicacion.h"
#include "main.h"
#include "DS1307.h"

#include "string.h"

#include "Serial.h"

#include "stdio.h"
#include "Buzzer.h"
#include "EEprom.h"
#include "Alarma.h"
#include "Cluster.h"


//*** ENUM ***
enum states_aplicacion stateAp;
//************

//*** ESTRUCTURAS EXTERNAS ***
//extern strButtons button;
extern strAnaTrama anaT1;
extern strRtc rtc;
extern strSerial serial1;
//extern strRelay rly;
extern strAlarm ala;
extern strCluster cl;
//****************************

//*** ESTRUCTURAS ***
strAplicacion ap;
strMemory memo;
//*******************
 

char hor,min,seg,dia,mes,ano,diaSe;   

unsigned long ulCntPeriodAplicacion = 0;

static struct pt ptTaskAplicacion;

static int taskAplicacion(struct pt *pt)
{
    
    PT_BEGIN(pt);
    while (1) 
    {
        ulCntPeriodAplicacion = getMillis() + PERIOD_APLICACION;
        PT_WAIT_UNTIL(pt, getMillis() >= ulCntPeriodAplicacion); 
       
        switch(stateAp)
        {
            //ESTADO QUE ESPERA ESTABILIZACION DEL SISTEMA
            case ST_ARRANQUE_AP:                
                if(++ap.uiCntAplicacion >= TIME_ARRANQUE)
                {  
                    

                    ap.flagArranque = true;
                    reiniciarTemporizador(&ap.uiCntAplicacion);
                    
                    
                    
                    twoBeep();
                    cambiarEstado(ST_READ_MEMO_AP);
                }                
                break;
                
            case ST_READ_MEMO_AP:
                if(inicioEstado(ST_READ_MEMO_AP))
                {
                    reiniciarTemporizador(&ap.uiCntAplicacion);
                }
                else
                {
                    if(++ap.uiCntAplicacion >= 200)
                    {
                        memo.ucInitMemory = EEpromRead(ADDRESS_INIT_EEPROM);
                        
                        if(memo.ucInitMemory != INIT_VALUE_EEPROM)
                        {
                            EEpromWrite(ADDRESS_INIT_EEPROM, INIT_VALUE_EEPROM);
                            twoBeep();    
                            
                            EEpromWrite(ADDRESS_EN_ALA1, 0);
                            EEpromWrite(ADDRESS_FLAGDAYALA1, 0);
                            EEpromWrite(ADDRESS_DAYWEEK1, 8);
                            EEpromWrite(ADDRESS_INIT_HOUR1, 0);
                            EEpromWrite(ADDRESS_INIT_MIN1, 0);
                            EEpromWrite(ADDRESS_END_HOUR1, 0);
                            EEpromWrite(ADDRESS_END_MIN1, 0);
                            
                            EEpromWrite(ADDRESS_EN_ALA2, 0);
                            EEpromWrite(ADDRESS_FLAGDAYALA2, 0);
                            EEpromWrite(ADDRESS_DAYWEEK2, 8);
                            EEpromWrite(ADDRESS_INIT_HOUR2, 0);
                            EEpromWrite(ADDRESS_INIT_MIN2, 0);
                            EEpromWrite(ADDRESS_END_HOUR2, 0);
                            EEpromWrite(ADDRESS_END_MIN2, 0);
                            
                            EEpromWrite(ADDRESS_EN_ALA3, 0);
                            EEpromWrite(ADDRESS_FLAGDAYALA3, 0);
                            EEpromWrite(ADDRESS_DAYWEEK3, 8);
                            EEpromWrite(ADDRESS_INIT_HOUR3, 0);
                            EEpromWrite(ADDRESS_INIT_MIN3, 0);
                            EEpromWrite(ADDRESS_END_HOUR3, 0);
                            EEpromWrite(ADDRESS_END_MIN3, 0);
                            
                            EEpromWrite(ADDRESS_EN_ALA4, 0);
                            EEpromWrite(ADDRESS_FLAGDAYALA4, 0);
                            EEpromWrite(ADDRESS_DAYWEEK4, 8);
                            EEpromWrite(ADDRESS_INIT_HOUR4, 0);
                            EEpromWrite(ADDRESS_INIT_MIN4, 0);
                            EEpromWrite(ADDRESS_END_HOUR4, 0);
                            EEpromWrite(ADDRESS_END_MIN4, 0);
                            
                            EEpromWrite(ADDRESS_EN_ALA5, 0);
                            EEpromWrite(ADDRESS_FLAGDAYALA5, 0);
                            EEpromWrite(ADDRESS_DAYWEEK5, 8);
                            EEpromWrite(ADDRESS_INIT_HOUR5, 0);
                            EEpromWrite(ADDRESS_INIT_MIN5, 0);
                            EEpromWrite(ADDRESS_END_HOUR5, 0);
                            EEpromWrite(ADDRESS_END_MIN5, 0);
                            
                            cambiarEstado(ST_READ_MEMO_AP);
                        }
                        else
                        {                            
                            //aca se deben leer los valores que se encuentran en la memoria
                            readMemoriaValues();
                            ala.flagUpdate = true;      //actualizar los valores  
                            
                            transmitUart1((char*)"\n\rBALIZA ALARMA V1.0\n\r\n\r");
                            
                            
                            ap.uiCntVolt = TIME_READ_VOLT;
                            ap.uiCntTemp = TIME_READ_TEMP;
                            cambiarEstado(ST_ESPERA_AP);
                        }
                        
                    }                    
                }
                break;
                
            case ST_PRUEBA_AP:
                
               
                break;
                
            
            case ST_ESPERA_AP:
                if(inicioEstado(ST_ESPERA_AP))
                {
                    reiniciarTemporizador(&ap.uiCntAplicacion);
                }
                else
                {
                    if(serial1.flagEventoRead)
                    {
                        serial1.flagEventoRead = false;
                        oneBeep();
                        readDevide();
                    }
                    else if(serial1.flagEventReloj)
                    {
                        serial1.flagEventReloj = false;                        
                        oneBeep();
                    }
                    else if(serial1.flagEventalarm)
                    {
                        serial1.flagEventalarm = false;
                        readMemoriaValues();
                        ala.flagUpdate = true;
                        oneBeep();
                    }
                    else if(++ap.uiCntVolt >= TIME_READ_VOLT)
                    {
                        ap.uiCntVolt = RST;
                        cambiarEstado(ST_READ_VOLT_AP);
                    }
                   
                    
                    else if(ap.flagAlarm)
                    {
                        cl.flagEvento = true;
                    }
                    else
                    {
                        cl.flagEvento = false;
                    }                                                                
                }
                break;
                
            case ST_READ_VOLT_AP:
                if(inicioEstado(ST_READ_VOLT_AP))
                {
                    ap.fVolt = ADC_read(1);
                    ap.fVolt = (5.0/1024) * ap.fVolt;
                    ap.fVolt = (ap.fVolt * 6) + 0.3;
                    ap.fVolt = ap.fVolt * 10;
                    
                }
                else
                {
                    
                    cambiarEstado(ST_ESPERA_AP);
                }
                break;
                
            case ST_READ_TEMP_AP:
                if(inicioEstado(ST_READ_TEMP_AP))
                {
                    ap.fTemp = ADC_read(3);
                    ap.fTemp = (5.0/1024) * ap.fTemp;
                    ap.fTemp = ap.fTemp * 10;
                }
                else
                {
                    
                    cambiarEstado(ST_ESPERA_AP);
                }
                break;
        }//FIN SWITCH
    }//FIN WHILE
    PT_END(pt);
}

void startTaskAplicacion(void)
{
        PT_INIT(&ptTaskAplicacion);
}
void executeTaskAplicacion(void)
{
    taskAplicacion(&ptTaskAplicacion);
}
 



//FUNCION QUE VERIFICA EL INICIO DE LOS ESTADOS
unsigned char inicioEstado(int state)
{
    if (ap.uiStatePrevious != state)
    {
        ap.uiStatePrevious = state;
        return true;
    }
    return false;
}

//FUNCION DESTINADA A CAMBIAR LOS ESTADOS
void cambiarEstado(int state)
{
    ap.uiStatePrevious = 0xffff;
    stateAp = state;
}


//RESET CONTADORES
void reiniciarTemporizador(unsigned int* time)
{
    *time = 0;
}

//LIMPIEZA DE BUFFERS
void cleanBuffer(char* orig)
{
    memset(orig, 0x00, strlen(orig));
}

 void readDevide(void)
 {   
     char bufferHorario[5];
     char bufferEnable[5];
    
     
    cleanBuffer(ap.bufferTx);
    sprintf(ap.bufferTx, "%d:%d:%d\n\r",rtc.hor,rtc.min,rtc.seg);
    transmitUart1(ap.bufferTx);
    
    cleanBuffer(ap.bufferTx);
    sprintf(ap.bufferTx, "%d/%d/%d-%d\n\r\n\r\n\r",rtc.day, rtc.month, rtc.year, rtc.dayWeek);
    transmitUart1(ap.bufferTx);
    
    cleanBuffer(ap.bufferTx);
    sprintf(ap.bufferTx, "No -    Ini    -   Fin    - On - Dias \n\r\n\r");
    transmitUart1(ap.bufferTx);
 
    convOnOff(bufferEnable, memo.ucEnaAla1);
    convStringDayWeek(bufferHorario, memo.ucDayWeek1);
    cleanBuffer(ap.bufferTx);
    sprintf(ap.bufferTx, " 1   - %d:%d   - %d:%d  - %s - %s\n\r", memo.ucInitHour1, memo.ucInitMin1, memo.ucEndHour1, memo.ucEndMin1, bufferEnable, bufferHorario);
    transmitUart1(ap.bufferTx);

    convOnOff(bufferEnable, memo.ucEnaAla2);
    convStringDayWeek(bufferHorario, memo.ucDayWeek2);
    cleanBuffer(ap.bufferTx);
    sprintf(ap.bufferTx, " 2   - %d:%d   - %d:%d  - %s - %s\n\r", memo.ucInitHour2, memo.ucInitMin2, memo.ucEndHour2, memo.ucEndMin2, bufferEnable, bufferHorario);
    transmitUart1(ap.bufferTx);

    convOnOff(bufferEnable, memo.ucEnaAla3);
    convStringDayWeek(bufferHorario, memo.ucDayWeek3);
    cleanBuffer(ap.bufferTx);
    sprintf(ap.bufferTx, " 3   - %d:%d   - %d:%d  - %s - %s\n\r", memo.ucInitHour3, memo.ucInitMin3, memo.ucEndHour3, memo.ucEndMin3, bufferEnable, bufferHorario);
    transmitUart1(ap.bufferTx);

    convOnOff(bufferEnable, memo.ucEnaAla4);
    convStringDayWeek(bufferHorario, memo.ucDayWeek4);
    cleanBuffer(ap.bufferTx);
    sprintf(ap.bufferTx, " 4   - %d:%d   - %d:%d  - %s - %s\n\r", memo.ucInitHour4, memo.ucInitMin4, memo.ucEndHour4, memo.ucEndMin4, bufferEnable, bufferHorario);
    transmitUart1(ap.bufferTx);

    convOnOff(bufferEnable, memo.ucEnaAla5);
    convStringDayWeek(bufferHorario, memo.ucDayWeek5);
    cleanBuffer(ap.bufferTx);
    sprintf(ap.bufferTx, " 5   - %d:%d   - %d:%d  - %s - %s\n\r\n\r", memo.ucInitHour5, memo.ucInitMin5, memo.ucEndHour5, memo.ucEndMin5, bufferEnable, bufferHorario);
    transmitUart1(ap.bufferTx);
    
   
 }
 
 void convStringDayWeek(char* dest,char dayWeek)
 {
     memset(dest, 0x00, strlen(dest));
     
     if(dayWeek == 8) sprintf(dest,"Dia");
     else if(dayWeek == 9)sprintf(dest,"LV");
     else sprintf(dest,"SD");
 }
 
 void convOnOff(char* dest, char enable)
 {
     memset(dest, 0x00, strlen(dest));
     
     if(enable) sprintf(dest,"ON");
     else sprintf(dest, "OFF");
 }
 
 void readMemoriaValues(void)
 {
   memo.ucEnaAla1 = EEpromRead(ADDRESS_EN_ALA1);
    memo.ucflagDayAla1 = EEpromRead(ADDRESS_FLAGDAYALA1);
    memo.ucDayWeek1 = EEpromRead(ADDRESS_DAYWEEK1);

    memo.ucInitHour1 = EEpromRead(ADDRESS_INIT_HOUR1);
    memo.ucInitMin1 = EEpromRead(ADDRESS_INIT_MIN1);

    memo.ucEndHour1 = EEpromRead(ADDRESS_END_HOUR1);
    memo.ucEndMin1 = EEpromRead(ADDRESS_END_MIN1);


    memo.ucEnaAla2 = EEpromRead(ADDRESS_EN_ALA2);
    memo.ucflagDayAla2 = EEpromRead(ADDRESS_FLAGDAYALA2);
    memo.ucDayWeek2 = EEpromRead(ADDRESS_DAYWEEK2);

    memo.ucInitHour2 = EEpromRead(ADDRESS_INIT_HOUR2);
    memo.ucInitMin2 = EEpromRead(ADDRESS_INIT_MIN2);

    memo.ucEndHour2 = EEpromRead(ADDRESS_END_HOUR2);
    memo.ucEndMin2 = EEpromRead(ADDRESS_END_MIN2);


    memo.ucEnaAla3 = EEpromRead(ADDRESS_EN_ALA3);
    memo.ucflagDayAla3 = EEpromRead(ADDRESS_FLAGDAYALA3);
    memo.ucDayWeek3 = EEpromRead(ADDRESS_DAYWEEK3);

    memo.ucInitHour3 = EEpromRead(ADDRESS_INIT_HOUR3);
    memo.ucInitMin3 = EEpromRead(ADDRESS_INIT_MIN3);

    memo.ucEndHour3 = EEpromRead(ADDRESS_END_HOUR3);
    memo.ucEndMin3 = EEpromRead(ADDRESS_END_MIN3);


    memo.ucEnaAla4 = EEpromRead(ADDRESS_EN_ALA4);
    memo.ucflagDayAla4 = EEpromRead(ADDRESS_FLAGDAYALA4);
    memo.ucDayWeek4 = EEpromRead(ADDRESS_DAYWEEK4);

    memo.ucInitHour4 = EEpromRead(ADDRESS_INIT_HOUR4);
    memo.ucInitMin4 = EEpromRead(ADDRESS_INIT_MIN4);

    memo.ucEndHour4 = EEpromRead(ADDRESS_END_HOUR4);
    memo.ucEndMin4 = EEpromRead(ADDRESS_END_MIN4);


    memo.ucEnaAla5 = EEpromRead(ADDRESS_EN_ALA5);
    memo.ucflagDayAla5 = EEpromRead(ADDRESS_FLAGDAYALA5);
    memo.ucDayWeek5 = EEpromRead(ADDRESS_DAYWEEK5);

    memo.ucInitHour5 = EEpromRead(ADDRESS_INIT_HOUR5);
    memo.ucInitMin5 = EEpromRead(ADDRESS_INIT_MIN5);

    memo.ucEndHour5 = EEpromRead(ADDRESS_END_HOUR5);
    memo.ucEndMin5 = EEpromRead(ADDRESS_END_MIN5);
                            
 }
