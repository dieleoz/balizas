/* 
 * File:   Serial.h
 * Author: ING.FREIMAN PARGA
 */

#ifndef SERIAL_H
#define	SERIAL_H

#ifdef	__cplusplus
extern "C" {
#endif

//*** INCLUDES ***
#include "TimeBase.h"
#include <xc.h>

#include "Rtos/pt.h"
#include <string.h>
//****************

#define PERIOD_ANALIZA_UART1    1
#define TIME_ANALISIS_UART1     5
  
#define SIZE_BUFFER_RX1         40
#define SIZE_BUFFER_TX1         45
    
#define INIT_FRAME      "\xbf"
#define END_FRAME       "?"
#define ID_NUM_ALARM    "A"
#define ID_ENC_ALARM    "E"
#define ID_INIT_ALARM   "I"
#define ID_END_ALARM    "F"
#define ID_DAY_ALARM    "D"
#define ID_RELOJ        "R"
#define ID_CALENDAR     "C"
#define ID_COMA         ","
#define ID_READ_DEV     "L"

typedef struct
{
    unsigned char flagRx            :1;
    unsigned char flagEnableRx      :1;
    char bufferRx [SIZE_BUFFER_RX1];
    unsigned char ucCntRX;
    unsigned long ulLastRxTick;

    unsigned char flagEventoRead    :1;
    unsigned char flagEventReloj    :1;
    unsigned char flagEventalarm    :1;
    
}strSerial;

typedef struct
{
   char bufferRx [SIZE_BUFFER_RX1];        //cpy buffer  recep
   unsigned char flagData   :1;             //attention data!!
   unsigned int uiCnt;
   
   unsigned char ucNumAlarm;
   unsigned char ucEncAlarm;
   
   char buffer2[10];
   unsigned char hora;
   unsigned char min;
   
   unsigned char dia;
   unsigned char mes;
   unsigned char ano;
   
   unsigned char diaSem;
   
   unsigned char horaInit;
   unsigned char minInit;
   
   unsigned char horaEnd;
   unsigned char minEnd;
   
   unsigned long ulDayAlarm;
}strAnaTrama;

enum states_anaTrama1
{
    ST_ARRANQUE_ANA1,
    ST_ESPERA_ANA1,
    ST_INIT_FRAME_ANA1,
    ST_ANALYSIS_ANA1,
    ST_WAIT_ANA1
};
//*** PROTOTIPO DE LAS FUNCIONES ***
    
void transmitUart1(const char* ptr);
void receiverUart1(char* dest);

static int taskAnalizaUart1(struct pt *pt);
void startTaskAnalizaUart1(void);
void executeTaskAnalizaUart1(void);

unsigned char extraerValue(char* orig, char* init, char* end);
void extraerFrame(char* orig, char*dest, char* init, char* end);
void extraerHora(char*orig, char* hor, char* min);
void extraerCalendar(char*orig, char* dia, char* mes, char* ano, char* diaSema);

#ifdef	__cplusplus
}
#endif

#endif	/* SERIAL_H */
