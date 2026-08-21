/**
 * ING FREIMAN PARGA 
 * UART1
 * 6 DE AGOSTO DEL 2021
 */

#include "Serial.h"
#include "main.h"

#include "Aplicacion.h"

#include <stdlib.h>
#include "Alarma.h"
#include "DS1307.h"
#include "EEprom.h"


//*** ESTRUCTURAS EXTERNAS ***
extern strAplicacion ap;
//extern strMemory memo;

srtAlarmas ala1;
srtAlarmas ala2;
srtAlarmas ala3;
srtAlarmas ala4;
srtAlarmas ala5;
//****************************

//*** ESTRUCTURAS ***
strSerial serial1;
strAnaTrama anaT1;
//*******************

//*** ENUM ***
enum states_anaTrama1 stateAnaTrama1;
//************

//*** VARIABLES EXTERNAS ***
extern unsigned char flagRx1;
extern unsigned char ucCntAnalisisUart1;
//**************************

//**** VARIABLES ***
//******************


//=================================================================
//NAME: transmitUart1

//=================================================================
void transmitUart1(char* ptr)
{
    char bufferTx1[SIZE_BUFFER_TX1];
    int ucCntTx1 = 0;
    
    if(ptr == NULL) return;
    
    memset(bufferTx1, 0x00, sizeof(bufferTx1));
    strncpy(bufferTx1, ptr, sizeof(bufferTx1) - 1);
    
    ucCntTx1 = (int)strlen(bufferTx1);
    
    for(int x = 0; x < ucCntTx1 ; x++)
    {
        TXREG = bufferTx1[x];
        while(TXSTAbits.TRMT == 0);                
    }//fin for
}


//=================================================================
//NAME: receiverUart1

//=================================================================
void receiverUart1(char* dest)
{
    if(dest == NULL) return;
    if(serial1.ucCntRX < sizeof(serial1.bufferRx) - 1)
    {
        serial1.bufferRx[serial1.ucCntRX++] = *dest;
    }
}



// CREACION DE LA TAREA
unsigned long ulCntPeriodAnaUart1;

static struct pt ptTaskAnalizaUart1;

//=================================================================
//NAME:     taskAnalizaUart1

//=================================================================
static int taskAnalizaUart1(struct pt *pt)
{
    
    PT_BEGIN(pt);
    while (1) 
    {
        ulCntPeriodAnaUart1 = getMillis() + PERIOD_ANALIZA_UART1;

        PT_WAIT_UNTIL(pt, getMillis() >= ulCntPeriodAnaUart1);
        
        switch(stateAnaTrama1)
        {
            case ST_ARRANQUE_ANA1:
            if(ap.flagArranque)
            {
                memset(serial1.bufferRx, 0x00, sizeof(serial1.bufferRx));
                serial1.ucCntRX = RST;
                serial1.flagRx = false;                                        

                stateAnaTrama1 = ST_ESPERA_ANA1;
            }
            break; 
                
                
            case ST_ESPERA_ANA1:
                if(serial1.flagRx)
                {
                    
                    if(++ anaT1.uiCnt >= 5)
                    {
                        serial1.flagRx = false;
                        
                        memset(anaT1.bufferRx, 0x00, sizeof(anaT1.bufferRx));
                        
                        char x = 0;
                        for(char i = 0; i < SIZE_BUFFER_RX1; i++)
                        {
                            if(serial1.bufferRx[i] != '\0' && x < (char)(sizeof(anaT1.bufferRx) - 1))
                            {
                                anaT1.bufferRx[x++] = serial1.bufferRx[i];
                            }
                        }
                        
                        memset(serial1.bufferRx, 0x00, sizeof(serial1.bufferRx));
                        serial1.ucCntRX = 0;
                        
                        stateAnaTrama1 = ST_INIT_FRAME_ANA1;
                    }
                }                
                break;
  
                
            case ST_INIT_FRAME_ANA1:
                if(strstr(anaT1.bufferRx, (char*)INIT_FRAME))
                {                    
                    stateAnaTrama1 = ST_ANALYSIS_ANA1;
                }
                else
                {
                    stateAnaTrama1 = ST_ESPERA_ANA1;
                }
                break;
                
            case ST_ANALYSIS_ANA1:
                if(strstr(anaT1.bufferRx, (char*)ID_READ_DEV))
                {
                    serial1.flagEventoRead = true;
                    stateAnaTrama1 = ST_ESPERA_ANA1;
                }
                //si actualiza la Hora-calendario
                else if(strstr(anaT1.bufferRx, (char*)ID_RELOJ))
                {
                    extraerFrame(anaT1.bufferRx, anaT1.buffer2, (char*) ID_RELOJ, (char*) ID_COMA);
                    extraerHora(anaT1.buffer2, (char*)&anaT1.hora, (char*)&anaT1.min);
                    
                    extraerFrame(anaT1.bufferRx, anaT1.buffer2, (char*) ID_CALENDAR, (char*) END_FRAME);
                    extraerCalendar(anaT1.buffer2, (char*)&anaT1.dia, (char*)&anaT1.mes, (char*)&anaT1.ano, (char*)&anaT1.diaSem);
                    
                    escribirRTC(anaT1.hora, anaT1.min, 0, anaT1.dia, anaT1.mes, anaT1.ano, anaT1.diaSem);
                    
                    serial1.flagEventReloj = true;
                    
                    stateAnaTrama1 = ST_ESPERA_ANA1;
                }
                //si hay configuracion de la alarma
                else if(strstr(anaT1.bufferRx, (char*)ID_NUM_ALARM))
                {                    
                    //extraer el num alarm
                    anaT1.ucNumAlarm = extraerValue(anaT1.bufferRx, ID_NUM_ALARM, ID_COMA);
                    
                    if(strstr(anaT1.bufferRx, (char*)ID_ENC_ALARM))
                    {
                        //extraer si la alarma esta on - off
                        anaT1.ucEncAlarm = extraerValue(anaT1.bufferRx, ID_ENC_ALARM, ID_COMA);
                        
                        //si la alarma esta apagada
                        if(!anaT1.ucEncAlarm)
                        {
                            stateAnaTrama1 = ST_WAIT_ANA1;
                        }
                        else
                        {
                            //si la alarma esta encendida
                            extraerFrame(anaT1.bufferRx, anaT1.buffer2, (char*)ID_INIT_ALARM, (char*)ID_COMA);
                            extraerHora(anaT1.buffer2, (char*)&anaT1.horaInit, (char*)&anaT1.minInit);
                            
                            extraerFrame(anaT1.bufferRx, anaT1.buffer2, (char*)ID_END_ALARM, (char*)ID_COMA);
                            extraerHora(anaT1.buffer2, (char*)&anaT1.horaEnd, (char*)&anaT1.minEnd);
                            
                            extraerFrame(anaT1.bufferRx, anaT1.buffer2, (char*)ID_DAY_ALARM, (char*)ID_COMA);
                            
                            anaT1.ulDayAlarm = (unsigned long)atoi(anaT1.buffer2);
                            
                            stateAnaTrama1 = ST_WAIT_ANA1;
                        }
                    }
                    else
                    {
                        stateAnaTrama1 = ST_ESPERA_ANA1;
                    }
                }
                else
                {
                    stateAnaTrama1 = ST_ESPERA_ANA1;
                }
                break;
                
                
            case ST_WAIT_ANA1:
                //si la alarma esta apagada
                if(!anaT1.ucEncAlarm)
                {
                    if(anaT1.ucNumAlarm == 1)
                    {
                        ala1.flagAlarm = false;
                        EEpromWrite(ADDRESS_EN_ALA1, 0);
                    }
                    else if(anaT1.ucNumAlarm == 2)
                    {
                        ala2.flagAlarm = false;
                        EEpromWrite(ADDRESS_EN_ALA2, 0);
                    }
                    else if(anaT1.ucNumAlarm == 3)
                    {                        
                        ala3.flagAlarm = false;
                        EEpromWrite(ADDRESS_EN_ALA3, 0);
                    }
                    else if(anaT1.ucNumAlarm == 4)
                    {                   
                        ala4.flagAlarm = false;
                        EEpromWrite(ADDRESS_EN_ALA4, 0);
                    }
                    else if(anaT1.ucNumAlarm == 5)
                    {
                        ala5.flagAlarm = false;
                        EEpromWrite(ADDRESS_EN_ALA5, 0);                        
                    }
                }
                else
                {
                    //si esta encendida!!
                    
                    //si es la alarma numero 1
                    if(anaT1.ucNumAlarm == 1)
                    {
                       if((anaT1.ulDayAlarm >= 8) && (anaT1.ulDayAlarm <= 10))
                       {
                           ala1.flagAlarm = true;
                           ala1.hourInit = anaT1.horaInit;
                           ala1.minInit = anaT1.minInit;
                           ala1.hourEnd = anaT1.horaEnd;
                           ala1.minEnd = anaT1.minEnd;
                           ala1.flagDayAlar = false;    //no personalizada
                           ala1.dayAlar = (unsigned char)anaT1.ulDayAlarm;
                           
                            EEpromWrite(ADDRESS_EN_ALA1, 1);
                            EEpromWrite(ADDRESS_FLAGDAYALA1, 0);
                            EEpromWrite(ADDRESS_DAYWEEK1, (char)anaT1.ulDayAlarm);
                            EEpromWrite(ADDRESS_INIT_HOUR1, anaT1.horaInit);
                            EEpromWrite(ADDRESS_INIT_MIN1, anaT1.minInit);
                            EEpromWrite(ADDRESS_END_HOUR1, anaT1.horaEnd);
                            EEpromWrite(ADDRESS_END_MIN1, anaT1.minEnd);
                       }
                    }
                    else if(anaT1.ucNumAlarm == 2)
                    {
                        if((anaT1.ulDayAlarm >= 8) && (anaT1.ulDayAlarm <= 10))
                        {
                            ala2.flagAlarm = true;
                            ala2.hourInit = anaT1.horaInit;
                            ala2.minInit = anaT1.minInit;
                            ala2.hourEnd = anaT1.horaEnd;
                            ala2.minEnd = anaT1.minEnd;
                            ala2.flagDayAlar = false;    //no personalizada
                            ala2.dayAlar = (unsigned char)anaT1.ulDayAlarm;

                             EEpromWrite(ADDRESS_EN_ALA2, 1);
                             EEpromWrite(ADDRESS_FLAGDAYALA2, 0);
                             EEpromWrite(ADDRESS_DAYWEEK2, (char)anaT1.ulDayAlarm);
                             EEpromWrite(ADDRESS_INIT_HOUR2, anaT1.horaInit);
                             EEpromWrite(ADDRESS_INIT_MIN2, anaT1.minInit);
                             EEpromWrite(ADDRESS_END_HOUR2, anaT1.horaEnd);
                             EEpromWrite(ADDRESS_END_MIN2, anaT1.minEnd);
                        }
                    }
                    else if(anaT1.ucNumAlarm == 3)
                    {
                       if((anaT1.ulDayAlarm >= 8) && (anaT1.ulDayAlarm <= 10))
                       {
                           ala3.flagAlarm = true;
                           ala3.hourInit = anaT1.horaInit;
                           ala3.minInit = anaT1.minInit;
                           ala3.hourEnd = anaT1.horaEnd;
                           ala3.minEnd = anaT1.minEnd;
                           ala3.flagDayAlar = false;    //no personalizada
                           ala3.dayAlar = (unsigned char)anaT1.ulDayAlarm;
                           
                            EEpromWrite(ADDRESS_EN_ALA3, 1);
                            EEpromWrite(ADDRESS_FLAGDAYALA3, 0);
                            EEpromWrite(ADDRESS_DAYWEEK3, (char)anaT1.ulDayAlarm);
                            EEpromWrite(ADDRESS_INIT_HOUR3, anaT1.horaInit);
                            EEpromWrite(ADDRESS_INIT_MIN3, anaT1.minInit);
                            EEpromWrite(ADDRESS_END_HOUR3, anaT1.horaEnd);
                            EEpromWrite(ADDRESS_END_MIN3, anaT1.minEnd);
                       }
                    }
                    else if(anaT1.ucNumAlarm == 4)
                    {
                       if((anaT1.ulDayAlarm >= 8) && (anaT1.ulDayAlarm <= 10))
                       {
                           ala4.flagAlarm = true;
                           ala4.hourInit = anaT1.horaInit;
                           ala4.minInit = anaT1.minInit;
                           ala4.hourEnd = anaT1.horaEnd;
                           ala4.minEnd = anaT1.minEnd;
                           ala4.flagDayAlar = false;    //no personalizada
                           ala4.dayAlar = (unsigned char)anaT1.ulDayAlarm;
                           
                            EEpromWrite(ADDRESS_EN_ALA4, 1);
                            EEpromWrite(ADDRESS_FLAGDAYALA4, 0);
                            EEpromWrite(ADDRESS_DAYWEEK4, (char)anaT1.ulDayAlarm);
                            EEpromWrite(ADDRESS_INIT_HOUR4, anaT1.horaInit);
                            EEpromWrite(ADDRESS_INIT_MIN4, anaT1.minInit);
                            EEpromWrite(ADDRESS_END_HOUR4, anaT1.horaEnd);
                            EEpromWrite(ADDRESS_END_MIN4, anaT1.minEnd);
                       }
                    }
                    else if(anaT1.ucNumAlarm == 5)
                    {
                        if((anaT1.ulDayAlarm >= 8) && (anaT1.ulDayAlarm <= 10))
                        {
                            ala5.flagAlarm = true;
                            ala5.hourInit = anaT1.horaInit;
                            ala5.minInit = anaT1.minInit;
                            ala5.hourEnd = anaT1.horaEnd;
                            ala5.minEnd = anaT1.minEnd;
                            ala5.flagDayAlar = false;    //no personalizada
                            ala5.dayAlar = (unsigned char)anaT1.ulDayAlarm;
                            
                            EEpromWrite(ADDRESS_EN_ALA5, 1);
                            EEpromWrite(ADDRESS_FLAGDAYALA5, 0);
                            EEpromWrite(ADDRESS_DAYWEEK5, (char)anaT1.ulDayAlarm);
                            EEpromWrite(ADDRESS_INIT_HOUR5, anaT1.horaInit);
                            EEpromWrite(ADDRESS_INIT_MIN5, anaT1.minInit);
                            EEpromWrite(ADDRESS_END_HOUR5, anaT1.horaEnd);
                            EEpromWrite(ADDRESS_END_MIN5, anaT1.minEnd);
                        }
                    }
                }
                serial1.flagEventalarm = true;
                stateAnaTrama1 = ST_ESPERA_ANA1;
                break;
                
        }//FIN SWITCH                
    }//FIN WHILE
    PT_END(pt);
}

//=================================================================
//NAME:     startTaskAnalizaUart1

//=================================================================
void startTaskAnalizaUart1(void)
{
    PT_INIT(&ptTaskAnalizaUart1);
}




//=================================================================
//NAME:  executeTaskAnalizaUart1

//=================================================================
void executeTaskAnalizaUart1(void)
{
     taskAnalizaUart1(&ptTaskAnalizaUart1);
}




unsigned char extraerValue(char* orig, char* init, char* end)
{
    unsigned char value = 0;
    char* ptrData;
    char buffer[10];
    char cnt = 0;
    
    if(orig == NULL || init == NULL || end == NULL) return 0;
    
    memset(buffer, 0x00, sizeof(buffer));
    
    ptrData = strstr(orig, init);
    if(ptrData == NULL) return 0;
    
    ptrData = ptrData + strlen(init);
    
    while(*ptrData != '\0' && *ptrData != *end && cnt < (char)(sizeof(buffer) - 1))
    {
        buffer[(unsigned char)cnt++] = *ptrData++;
    }
    
    value = (unsigned char)atoi(buffer);
    return value;
}

void extraerFrame(char* orig, char*dest, char* init, char* end)
{
   char* ptrData; 
   char cnt = 0;
   char buffer[16];
   
   if(dest == NULL) return;
   dest[0] = '\0';
   if(orig == NULL || init == NULL || end == NULL) return;
   
   memset(buffer, 0x00, sizeof(buffer));
   
   ptrData = strstr(orig, init);
   if(ptrData == NULL) return;
   
   ptrData = ptrData + strlen(init);
   
   while(*ptrData != '\0' && *ptrData != *end && cnt < (char)(sizeof(buffer) - 1))
   {
       buffer[(unsigned char)cnt++] = *ptrData++;
   }
   buffer[(unsigned char)cnt] = '\0';
   
   strcpy(dest, buffer);
}

void extraerHora(char*orig, char* hor, char* min)
{
    char buffer[4];  
    char hora = 0;
    char minuto = 0;
    
    if(orig == NULL || hor == NULL || min == NULL) return;
    if(strlen(orig) < 4) return;
    
    memset(buffer, 0x00, sizeof(buffer));
    
    buffer[0] = *orig++;
    buffer[1] = *orig++;
    hora = (char)atoi(buffer);
    
    buffer[0] = *orig++;
    buffer[1] = *orig;
    minuto = (char)atoi(buffer);
    
    *hor = hora;
    *min = minuto;
}


void extraerCalendar(char*orig, char* dia, char* mes, char* ano, char* diaSema)
{
    char buffer[4];
    char day = 0;
    char month = 0;
    char year = 0;
    char dayWeek = 0;
    
    if(orig == NULL || dia == NULL || mes == NULL || ano == NULL || diaSema == NULL) return;
    if(strlen(orig) < 8) return;
    
    memset(buffer, 0x00, sizeof(buffer));
    
    buffer[0] = *orig++;
    buffer[1] = *orig++;
    day = (char)atoi(buffer);
    
    buffer[0] = *orig++;
    buffer[1] = *orig++;
    month = (char)atoi(buffer);
    
    buffer[0] = *orig++;
    buffer[1] = *orig++;
    year = (char)atoi(buffer);
    
    orig++; // salta guion '-'
    
    buffer[0] = *orig;
    buffer[1] = '\0';
    dayWeek = (char)atoi(buffer);
    
    *dia = day;
    *mes = month;
    *ano = year;
    *diaSema = dayWeek;
}
