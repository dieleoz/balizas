/*
 * Adc.c - CONFIGURACION DEL CONVERSOR ANALOGICO/DIGITAL
 *
 * POR QUE ESTE ARCHIVO EXISTE, que es lo unico que no dice el codigo:
 *
 * ADC_init() vivia dentro de main.c, y main.c es el UNICO .c del firmware que
 * el arnes de pruebas NO compila (lo sustituye sim/plataforma.c). Consecuencia:
 * el PCFG que decide que pines son analogicos quedaba fuera del alcance del
 * simulador, y por eso el canal de temperatura pudo pasar 58 comprobaciones en
 * verde estando leido de un pin configurado como digital.
 *
 * Sacandolo aqui, el arnes compila la configuracion REAL y puede comprobar que
 * cada canal que el firmware lee esta habilitado. La configuracion vive ahora
 * al lado de quien la usa, no en el arranque.
 */

#include <xc.h>
#include <stdint.h>
#include "Adc.h"

void ADC_init(void)
{
    ADCON1bits.VCFG = 0b00;     //REF -> VSS, VCC

    /* PCFG decide que pines AN quedan analogicos. La tarjeta necesita AN1
     * (divisor de tension de bateria) y AN3 (LM35 de temperatura).
     *
     * OJO -- VALOR PENDIENTE DE CONFIRMAR CONTRA EL DATASHEET (22-ago-2026):
     * el comentario original decia "Entradas Analogicas a0, a1, a2" para
     * 0b1011, y Manuales/HARDWARE.md propone 0b1010 para llegar a AN3. Segun la
     * tabla del PIC18F2455/2550/4455/4550 el numero de canales analogicos es
     * (13 - PCFG), lo que daria: 0b1011 -> AN0,AN1 solamente; 0b1010 ->
     * AN0..AN2; y AN3 exigiria 0b1001. Si esa tabla es la buena, el valor que
     * propone HARDWARE.md NO arregla el defecto y lo deja creyendo que si.
     * NO se cambia hasta confirmarlo con el datasheet en la mano.
     */
    ADCON1bits.PCFG = 0b1011;

    ADCON2bits.ACQT = 0b010;    //TACQT > 2.45us
    ADCON2bits.ADCS = 0b100;    //TAD >  0.7us Tosc * 4 = 1us
    ADCON2bits.ADFM = 1;        //1 derecha, 0 izquierda

    ADCON0bits.ADON = 1;        //ADC on
}
