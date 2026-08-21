/**
 * 
 */


#include "EEprom.h"

void EEpromWrite(unsigned int address, unsigned char data)
{
    EEADR = address;
    EEDATA = data;
    
    EECON1bits.EEPGD = 0;         
    EECON1bits.CFGS = 0;
    EECON1bits.WREN = 1;
    INTCONbits.GIE = 0;
    
    EECON2 = 0x55;
    EECON2 = 0x0AA;
    EECON1bits.WR = 1;            
    INTCONbits.GIE = 1;
    
    while(!PIR2bits.EEIF);
    PIR2bits.EEIF = 0;
    EECON1bits.WREN = 0;           
}


unsigned char EEpromRead(unsigned int address)
{
    EEADR = address;
    
    EECON1bits.EEPGD = 0;   
    EECON1bits.CFGS = 0;
    EECON1bits.RD = 1;       
    
    return EEDATA;
}


