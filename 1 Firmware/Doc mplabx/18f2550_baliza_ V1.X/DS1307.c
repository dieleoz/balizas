#include "I2C.h"
#include "main.h"
#include "DS1307.h"

#include <xc.h>


//*** ESTRUCTURAS ***
strRtc rtc;
//*******************
uint8_t BCD_a_Decimal(uint8_t numero){
  return (uint8_t)((numero >> 4) * 10 + (numero & 0x0F));  
}

uint8_t Decimal_a_BCD(uint8_t numero){
    return (uint8_t)(((numero / 10) << 4) + (numero % 10));
}

void leerRtcSeg(uint8_t *segundos)
{
    uint8_t dirSeg = 0x00;
     
    I2C_Start();                             //mandamos el bit de start para empezar la comunicacion                                                                       
    I2C_Master_Write(208);                   //mando la direccion del esclavo del RTC en 7 bits: 1101000 + bit de escritura: 0 ---> en 8 bits 11010000 o 208               
    I2C_Master_Write(dirSeg);            //mando la direccion de seg,min,hor,dia,mes,año  la cual la encontramos en el datasheet                                       
    I2C_Repeated_Start();                    //mando nuevamente el bit de start, esta funcion es equivalente a  I2C1_Stop();I2C1_Start();                                  
    I2C_Master_Write(209);                   //mando nuevamente la direccion del esclavo del RTC en 7 bits: 1101000 + bit de lectura: 1 ---> en 8 bits 11010001 o 209      
    *segundos = BCD_a_Decimal(I2C_Master_Read(0));//leemos el dato que manda el esclavo al maestro de seg,min,hor,dia,mes,año y lo convertimos de BCD a Decimal                 
    I2C_Stop();
     
}

void leerRTC(uint8_t *hora, uint8_t *minutos, uint8_t *segundos, uint8_t *dia, uint8_t *mes, uint8_t *ano, uint8_t *diaSe)
{                                                                                    
     uint8_t rtc[7],i;                                                                                                                                                   
     //creo una matriz         seg, min, hor, dia, mes, año,  diaSe                                                                                                            
     const uint8_t rtc_dir[7]={0x00,0x01,0x02,0x04,0x05,0x06, 0x03};  
     
     for(i=0; i<7; i++)
     {                                                                                                                                             
         I2C_Start();                             //mandamos el bit de start para empezar la comunicacion                                                                       
         I2C_Master_Write(208);                   //mando la direccion del esclavo del RTC en 7 bits: 1101000 + bit de escritura: 0 ---> en 8 bits 11010000 o 208               
         I2C_Master_Write(rtc_dir[i]);            //mando la direccion de seg,min,hor,dia,mes,año  la cual la encontramos en el datasheet                                       
         I2C_Repeated_Start();                    //mando nuevamente el bit de start, esta funcion es equivalente a  I2C1_Stop();I2C1_Start();                                  
         I2C_Master_Write(209);                   //mando nuevamente la direccion del esclavo del RTC en 7 bits: 1101000 + bit de lectura: 1 ---> en 8 bits 11010001 o 209      
         rtc[i]=BCD_a_Decimal(I2C_Master_Read(0));//leemos el dato que manda el esclavo al maestro de seg,min,hor,dia,mes,año y lo convertimos de BCD a Decimal                 
         I2C_Stop();
     }                             //detenemos la comunicacion
     
     //almaceno los valores de rtc[i] en los punteros
     *hora     = rtc[2];
     *minutos  = rtc[1];
     *segundos = rtc[0];
     *dia      = rtc[3];
     *mes      = rtc[4];
     *ano      = rtc[5];  
     *diaSe    = rtc[6];
}       

void escribirRTC(uint8_t hor, uint8_t min, uint8_t seg, uint8_t dia, uint8_t mes, uint8_t ano, uint8_t diaSe)
{                                                                                                                                                
     uint8_t i;              
     
     //direcciones datasheet     hor, min, seg, dia, mes, año, diaSe                                                                                                       
     const uint8_t rtc_dir[7]  ={0x02,0x01,0x00,0x04,0x05,0x06, 0x03};                                                                                                                                                                                                              //
     const uint8_t rtc_datos[7]={hor, min, seg, dia, mes, ano, diaSe};   //editar la hora y fecha   
     
     for(i=0 ; i < 7; i++)
     {                                                                                                                                             
         I2C_Start();                                  //mandamos el bit de start para empezar la comunicacion                                                                  
         I2C_Master_Write(208);                        //mando la direccion del esclavo del RTC en 7 bits: 1101000 + bit de escritura: 0 ---> en 8 bits 11010000 o 208          
         I2C_Master_Write(rtc_dir[i]);                 //mando la direccion de LA HORA 02h o 0x02 la cual la encontramos en el datasheet                                        
         I2C_Master_Write(Decimal_a_BCD(rtc_datos[i]));//mando el dato a escribir convirtiendolo de Decimal a BCD ya que el contenido de los regitros esta en formato BCD       
         I2C_Stop();
     }                                  //detenemos la comunicacion  
}                                                                                                                             