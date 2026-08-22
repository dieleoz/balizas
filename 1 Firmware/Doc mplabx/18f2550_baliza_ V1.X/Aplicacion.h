/* 
 * File:   Aplicacion.h
 * Author: ing. freiman parga
 *
 * Created on 14 de octubre del 2022
 */

#ifndef APLICACION_H
#define	APLICACION_H

#ifdef	__cplusplus
extern "C" {
#endif

//*** INCLUDES ***
#include "TimeBase.h"
#include <xc.h>
#include "Rtos/pt.h"
//****************
    
//*** DEFINICIONES ***
#define PERIOD_APLICACION       10
    
#define TIME_ARRANQUE           500

#define TIME_OUT_AP             50
#define TIME_READ_VOLT          6000
#define TIME_READ_TEMP          4500

//**********************************    
    
//*** DEFINICION DE COMANDOS ***
    
//*****************************
    

//**************************************
    
//*** DEFINICIONES MEMORIA ***
#define INIT_VALUE_EEPROM       0X06
#define ADDRESS_INIT_EEPROM     0X00   

 //*** ALARMA 1 ***
#define ADDRESS_EN_ALA1          0X01
#define ADDRESS_FLAGDAYALA1      0X02
#define ADDRESS_DAYWEEK1         0X03
    
#define ADDRESS_INIT_HOUR1       0X04
#define ADDRESS_INIT_MIN1        0X05    
    
#define ADDRESS_END_HOUR1        0X06
#define ADDRESS_END_MIN1         0X07
    
//*** ALARMA 2 ***
#define ADDRESS_EN_ALA2          0X08
#define ADDRESS_FLAGDAYALA2      0X09
#define ADDRESS_DAYWEEK2         0X0A
    
#define ADDRESS_INIT_HOUR2       0X0B
#define ADDRESS_INIT_MIN2        0X0C    
    
#define ADDRESS_END_HOUR2        0X0D
#define ADDRESS_END_MIN2         0X0E

//********************
    
//*** ALARMA 3 ***
#define ADDRESS_EN_ALA3          0X0F
#define ADDRESS_FLAGDAYALA3      0X10
#define ADDRESS_DAYWEEK3         0X11
    
#define ADDRESS_INIT_HOUR3       0X12
#define ADDRESS_INIT_MIN3        0X13    
    
#define ADDRESS_END_HOUR3        0X14
#define ADDRESS_END_MIN3         0X15

//********************

//*** ALARMA 4 ***
#define ADDRESS_EN_ALA4          0X16
#define ADDRESS_FLAGDAYALA4      0X17
#define ADDRESS_DAYWEEK4         0X18
    
#define ADDRESS_INIT_HOUR4       0X19
#define ADDRESS_INIT_MIN4        0X1A    
    
#define ADDRESS_END_HOUR4        0X1B
#define ADDRESS_END_MIN4         0X1C

//********************

//*** ALARMA 5 ***
#define ADDRESS_EN_ALA5          0X1D
#define ADDRESS_FLAGDAYALA5      0X1E
#define ADDRESS_DAYWEEK5         0X1F
    
#define ADDRESS_INIT_HOUR5       0X20
#define ADDRESS_INIT_MIN5        0X21    
    
#define ADDRESS_END_HOUR5        0X22
#define ADDRESS_END_MIN5         0X23

//********************

typedef struct
{
    unsigned char flagArranque          :1;
    
    unsigned int uiStatePrevious;
    unsigned int uiCntAplicacion;
    unsigned int uiCntPause;
    unsigned char ucCntitera;
    
    unsigned char flagAlarm      :1;
    
    char bufferTx[45];   
    char bufferAux [10];     //5
    
    unsigned int uiCntVolt;
    unsigned int uiCntTemp;
    uint16_t uiVoltDec;  // Voltaje en decimas de voltio (ej. 126 = 12.6V)
    uint16_t uiTempDec;  // Temperatura en decimas de grado (ej. 250 = 25.0 C)
}strAplicacion;

typedef struct
{
    unsigned char ucInitMemory;
    
    unsigned char ucEnaAla1;
    unsigned char ucflagDayAla1; //personalizada!!
    unsigned char ucDayWeek1;
    unsigned char ucInitHour1;
    unsigned char ucInitMin1;
    unsigned char ucEndHour1;
    unsigned char ucEndMin1;
    
    unsigned char ucEnaAla2;
    unsigned char ucflagDayAla2; //personalizada!!
    unsigned char ucDayWeek2;
    unsigned char ucInitHour2;
    unsigned char ucInitMin2;
    unsigned char ucEndHour2;
    unsigned char ucEndMin2;
    
    unsigned char ucEnaAla3;
    unsigned char ucflagDayAla3; //personalizada!!
    unsigned char ucDayWeek3;
    unsigned char ucInitHour3;
    unsigned char ucInitMin3;
    unsigned char ucEndHour3;
    unsigned char ucEndMin3;
    
    unsigned char ucEnaAla4;
    unsigned char ucflagDayAla4; //personalizada!!
    unsigned char ucDayWeek4;
    unsigned char ucInitHour4;
    unsigned char ucInitMin4;
    unsigned char ucEndHour4;
    unsigned char ucEndMin4;
    
    unsigned char ucEnaAla5;
    unsigned char ucflagDayAla5; //personalizada!!
    unsigned char ucDayWeek5;
    unsigned char ucInitHour5;
    unsigned char ucInitMin5;
    unsigned char ucEndHour5;
    unsigned char ucEndMin5;
    
}strMemory;

    
enum states_aplicacion
{
  ST_ARRANQUE_AP,
  ST_ESPERA_AP,
  ST_PRUEBA_AP,
  ST_READ_MEMO_AP,
  ST_READ_VOLT_AP,
  ST_READ_TEMP_AP
};

//*** PROTOTIPO DE LAS FUNCIONES ***
static int taskAplicacion(struct pt *pt);
void startTaskAplicacion(void);
void executeTaskAplicacion(void);

unsigned char inicioEstado(int state);
void cambiarEstado(int state);
void reiniciarTemporizador(unsigned int* time);

void cleanBuffer(char* orig);

void convStringDayWeek(char* dest, char dayWeek);
void convOnOff(char* dest, char enable);

void readDevide(void);
void readMemoriaValues(void);


#ifdef	__cplusplus
}
#endif

#endif	/* APLICACION_H */

