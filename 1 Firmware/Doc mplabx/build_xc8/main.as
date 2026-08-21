subtitle "Microchip MPLAB XC8 C Compiler v2.36 (Free license) build 20220127204148 Og9 "

pagewidth 120

	opt flic

	processor	18F2550
include "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\18f2550.cgen.inc"
getbyte	macro	val,pos
	(((val) >> (8 * pos)) and 0xff)
endm
byte0	macro	val
	(getbyte(val,0))
endm
byte1	macro	val
	(getbyte(val,1))
endm
byte2	macro	val
	(getbyte(val,2))
endm
byte3	macro	val
	(getbyte(val,3))
endm
byte4	macro	val
	(getbyte(val,4))
endm
byte5	macro	val
	(getbyte(val,5))
endm
byte6	macro	val
	(getbyte(val,6))
endm
byte7	macro	val
	(getbyte(val,7))
endm
getword	macro	val,pos
	(((val) >> (8 * pos)) and 0xffff)
endm
word0	macro	val
	(getword(val,0))
endm
word1	macro	val
	(getword(val,2))
endm
word2	macro	val
	(getword(val,4))
endm
word3	macro	val
	(getword(val,6))
endm
gettword	macro	val,pos
	(((val) >> (8 * pos)) and 0xffffff)
endm
tword0	macro	val
	(gettword(val,0))
endm
tword1	macro	val
	(gettword(val,3))
endm
tword2	macro	val
	(gettword(val,6))
endm
getdword	macro	val,pos
	(((val) >> (8 * pos)) and 0xffffffff)
endm
dword0	macro	val
	(getdword(val,0))
endm
dword1	macro	val
	(getdword(val,4))
endm
clrc   macro
	bcf	status,0
endm
setc   macro
	bsf	status,0
endm
clrz   macro
	bcf	status,2
endm
setz   macro
	bsf	status,2
endm
skipnz macro
	btfsc	status,2
endm
skipz  macro
	btfss	status,2
endm
skipnc macro
	btfsc	status,0
endm
skipc  macro
	btfss	status,0
endm
pushw macro
	movwf postinc1
endm
pushf macro arg1
	movff arg1, postinc1
endm
popw macro
	movf postdec1,f
	movf indf1,w
endm
popf macro arg1
	movf postdec1,f
	movff indf1,arg1
endm
popfc macro arg1
	movff plusw1,arg1
	decfsz fsr1,f
endm
	global	__ramtop
	global	__accesstop
# 55 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRM equ 0F66h ;# 
# 62 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRML equ 0F66h ;# 
# 140 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRMH equ 0F67h ;# 
# 180 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UIR equ 0F68h ;# 
# 236 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UIE equ 0F69h ;# 
# 292 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEIR equ 0F6Ah ;# 
# 343 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEIE equ 0F6Bh ;# 
# 394 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
USTAT equ 0F6Ch ;# 
# 454 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UCON equ 0F6Dh ;# 
# 505 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UADDR equ 0F6Eh ;# 
# 569 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UCFG equ 0F6Fh ;# 
# 648 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP0 equ 0F70h ;# 
# 756 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP1 equ 0F71h ;# 
# 864 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP2 equ 0F72h ;# 
# 972 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP3 equ 0F73h ;# 
# 1080 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP4 equ 0F74h ;# 
# 1188 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP5 equ 0F75h ;# 
# 1296 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP6 equ 0F76h ;# 
# 1404 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP7 equ 0F77h ;# 
# 1512 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP8 equ 0F78h ;# 
# 1588 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP9 equ 0F79h ;# 
# 1664 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP10 equ 0F7Ah ;# 
# 1740 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP11 equ 0F7Bh ;# 
# 1816 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP12 equ 0F7Ch ;# 
# 1892 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP13 equ 0F7Dh ;# 
# 1968 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP14 equ 0F7Eh ;# 
# 2044 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP15 equ 0F7Fh ;# 
# 2120 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTA equ 0F80h ;# 
# 2259 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTB equ 0F81h ;# 
# 2369 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTC equ 0F82h ;# 
# 2511 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTE equ 0F84h ;# 
# 2550 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATA equ 0F89h ;# 
# 2650 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATB equ 0F8Ah ;# 
# 2762 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATC equ 0F8Bh ;# 
# 2840 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISA equ 0F92h ;# 
# 2845 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRA equ 0F92h ;# 
# 3038 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISB equ 0F93h ;# 
# 3043 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRB equ 0F93h ;# 
# 3260 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISC equ 0F94h ;# 
# 3265 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRC equ 0F94h ;# 
# 3414 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
OSCTUNE equ 0F9Bh ;# 
# 3473 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIE1 equ 0F9Dh ;# 
# 3544 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIR1 equ 0F9Eh ;# 
# 3615 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
IPR1 equ 0F9Fh ;# 
# 3686 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIE2 equ 0FA0h ;# 
# 3757 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIR2 equ 0FA1h ;# 
# 3828 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
IPR2 equ 0FA2h ;# 
# 3899 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EECON1 equ 0FA6h ;# 
# 3965 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EECON2 equ 0FA7h ;# 
# 3972 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EEDATA equ 0FA8h ;# 
# 3979 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EEADR equ 0FA9h ;# 
# 3986 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCSTA equ 0FABh ;# 
# 3991 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCSTA1 equ 0FABh ;# 
# 4196 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXSTA equ 0FACh ;# 
# 4201 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXSTA1 equ 0FACh ;# 
# 4452 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXREG equ 0FADh ;# 
# 4457 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXREG1 equ 0FADh ;# 
# 4464 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCREG equ 0FAEh ;# 
# 4469 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCREG1 equ 0FAEh ;# 
# 4476 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRG equ 0FAFh ;# 
# 4481 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRG1 equ 0FAFh ;# 
# 4488 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRGH equ 0FB0h ;# 
# 4495 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T3CON equ 0FB1h ;# 
# 4616 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3 equ 0FB2h ;# 
# 4623 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3L equ 0FB2h ;# 
# 4630 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3H equ 0FB3h ;# 
# 4637 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CMCON equ 0FB4h ;# 
# 4727 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CVRCON equ 0FB5h ;# 
# 4812 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ECCP1AS equ 0FB6h ;# 
# 4817 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1AS equ 0FB6h ;# 
# 4942 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ECCP1DEL equ 0FB7h ;# 
# 4947 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1DEL equ 0FB7h ;# 
# 4982 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BAUDCON equ 0FB8h ;# 
# 4987 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BAUDCTL equ 0FB8h ;# 
# 5162 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP2CON equ 0FBAh ;# 
# 5226 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2 equ 0FBBh ;# 
# 5233 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2L equ 0FBBh ;# 
# 5240 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2H equ 0FBCh ;# 
# 5247 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1CON equ 0FBDh ;# 
# 5311 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1 equ 0FBEh ;# 
# 5318 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1L equ 0FBEh ;# 
# 5325 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1H equ 0FBFh ;# 
# 5332 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON2 equ 0FC0h ;# 
# 5403 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON1 equ 0FC1h ;# 
# 5488 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON0 equ 0FC2h ;# 
# 5607 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRES equ 0FC3h ;# 
# 5614 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRESL equ 0FC3h ;# 
# 5621 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRESH equ 0FC4h ;# 
# 5628 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPCON2 equ 0FC5h ;# 
# 5690 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPCON1 equ 0FC6h ;# 
# 5760 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPSTAT equ 0FC7h ;# 
# 6008 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPADD equ 0FC8h ;# 
# 6015 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPBUF equ 0FC9h ;# 
# 6022 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T2CON equ 0FCAh ;# 
# 6120 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PR2 equ 0FCBh ;# 
# 6125 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
MEMCON equ 0FCBh ;# 
# 6230 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR2 equ 0FCCh ;# 
# 6237 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T1CON equ 0FCDh ;# 
# 6340 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1 equ 0FCEh ;# 
# 6347 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1L equ 0FCEh ;# 
# 6354 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1H equ 0FCFh ;# 
# 6361 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCON equ 0FD0h ;# 
# 6510 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
WDTCON equ 0FD1h ;# 
# 6538 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
HLVDCON equ 0FD2h ;# 
# 6543 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LVDCON equ 0FD2h ;# 
# 6808 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
OSCCON equ 0FD3h ;# 
# 6891 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T0CON equ 0FD5h ;# 
# 6961 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0 equ 0FD6h ;# 
# 6968 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0L equ 0FD6h ;# 
# 6975 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0H equ 0FD7h ;# 
# 6982 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
STATUS equ 0FD8h ;# 
# 7053 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2 equ 0FD9h ;# 
# 7060 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2L equ 0FD9h ;# 
# 7067 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2H equ 0FDAh ;# 
# 7074 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW2 equ 0FDBh ;# 
# 7081 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC2 equ 0FDCh ;# 
# 7088 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC2 equ 0FDDh ;# 
# 7095 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC2 equ 0FDEh ;# 
# 7102 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF2 equ 0FDFh ;# 
# 7109 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BSR equ 0FE0h ;# 
# 7116 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1 equ 0FE1h ;# 
# 7123 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1L equ 0FE1h ;# 
# 7130 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1H equ 0FE2h ;# 
# 7137 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW1 equ 0FE3h ;# 
# 7144 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC1 equ 0FE4h ;# 
# 7151 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC1 equ 0FE5h ;# 
# 7158 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC1 equ 0FE6h ;# 
# 7165 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF1 equ 0FE7h ;# 
# 7172 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
WREG equ 0FE8h ;# 
# 7179 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0 equ 0FE9h ;# 
# 7186 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0L equ 0FE9h ;# 
# 7193 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0H equ 0FEAh ;# 
# 7200 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW0 equ 0FEBh ;# 
# 7207 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC0 equ 0FECh ;# 
# 7214 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC0 equ 0FEDh ;# 
# 7221 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC0 equ 0FEEh ;# 
# 7228 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF0 equ 0FEFh ;# 
# 7235 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON3 equ 0FF0h ;# 
# 7327 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON2 equ 0FF1h ;# 
# 7404 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON equ 0FF2h ;# 
# 7521 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PROD equ 0FF3h ;# 
# 7528 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PRODL equ 0FF3h ;# 
# 7535 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PRODH equ 0FF4h ;# 
# 7542 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TABLAT equ 0FF5h ;# 
# 7551 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTR equ 0FF6h ;# 
# 7558 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRL equ 0FF6h ;# 
# 7565 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRH equ 0FF7h ;# 
# 7572 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRU equ 0FF8h ;# 
# 7581 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLAT equ 0FF9h ;# 
# 7588 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PC equ 0FF9h ;# 
# 7595 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCL equ 0FF9h ;# 
# 7602 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLATH equ 0FFAh ;# 
# 7609 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLATU equ 0FFBh ;# 
# 7616 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
STKPTR equ 0FFCh ;# 
# 7692 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOS equ 0FFDh ;# 
# 7699 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSL equ 0FFDh ;# 
# 7706 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSH equ 0FFEh ;# 
# 7713 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSU equ 0FFFh ;# 
# 55 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRM equ 0F66h ;# 
# 62 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRML equ 0F66h ;# 
# 140 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRMH equ 0F67h ;# 
# 180 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UIR equ 0F68h ;# 
# 236 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UIE equ 0F69h ;# 
# 292 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEIR equ 0F6Ah ;# 
# 343 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEIE equ 0F6Bh ;# 
# 394 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
USTAT equ 0F6Ch ;# 
# 454 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UCON equ 0F6Dh ;# 
# 505 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UADDR equ 0F6Eh ;# 
# 569 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UCFG equ 0F6Fh ;# 
# 648 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP0 equ 0F70h ;# 
# 756 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP1 equ 0F71h ;# 
# 864 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP2 equ 0F72h ;# 
# 972 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP3 equ 0F73h ;# 
# 1080 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP4 equ 0F74h ;# 
# 1188 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP5 equ 0F75h ;# 
# 1296 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP6 equ 0F76h ;# 
# 1404 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP7 equ 0F77h ;# 
# 1512 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP8 equ 0F78h ;# 
# 1588 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP9 equ 0F79h ;# 
# 1664 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP10 equ 0F7Ah ;# 
# 1740 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP11 equ 0F7Bh ;# 
# 1816 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP12 equ 0F7Ch ;# 
# 1892 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP13 equ 0F7Dh ;# 
# 1968 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP14 equ 0F7Eh ;# 
# 2044 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP15 equ 0F7Fh ;# 
# 2120 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTA equ 0F80h ;# 
# 2259 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTB equ 0F81h ;# 
# 2369 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTC equ 0F82h ;# 
# 2511 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTE equ 0F84h ;# 
# 2550 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATA equ 0F89h ;# 
# 2650 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATB equ 0F8Ah ;# 
# 2762 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATC equ 0F8Bh ;# 
# 2840 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISA equ 0F92h ;# 
# 2845 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRA equ 0F92h ;# 
# 3038 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISB equ 0F93h ;# 
# 3043 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRB equ 0F93h ;# 
# 3260 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISC equ 0F94h ;# 
# 3265 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRC equ 0F94h ;# 
# 3414 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
OSCTUNE equ 0F9Bh ;# 
# 3473 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIE1 equ 0F9Dh ;# 
# 3544 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIR1 equ 0F9Eh ;# 
# 3615 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
IPR1 equ 0F9Fh ;# 
# 3686 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIE2 equ 0FA0h ;# 
# 3757 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIR2 equ 0FA1h ;# 
# 3828 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
IPR2 equ 0FA2h ;# 
# 3899 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EECON1 equ 0FA6h ;# 
# 3965 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EECON2 equ 0FA7h ;# 
# 3972 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EEDATA equ 0FA8h ;# 
# 3979 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EEADR equ 0FA9h ;# 
# 3986 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCSTA equ 0FABh ;# 
# 3991 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCSTA1 equ 0FABh ;# 
# 4196 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXSTA equ 0FACh ;# 
# 4201 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXSTA1 equ 0FACh ;# 
# 4452 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXREG equ 0FADh ;# 
# 4457 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXREG1 equ 0FADh ;# 
# 4464 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCREG equ 0FAEh ;# 
# 4469 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCREG1 equ 0FAEh ;# 
# 4476 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRG equ 0FAFh ;# 
# 4481 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRG1 equ 0FAFh ;# 
# 4488 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRGH equ 0FB0h ;# 
# 4495 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T3CON equ 0FB1h ;# 
# 4616 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3 equ 0FB2h ;# 
# 4623 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3L equ 0FB2h ;# 
# 4630 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3H equ 0FB3h ;# 
# 4637 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CMCON equ 0FB4h ;# 
# 4727 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CVRCON equ 0FB5h ;# 
# 4812 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ECCP1AS equ 0FB6h ;# 
# 4817 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1AS equ 0FB6h ;# 
# 4942 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ECCP1DEL equ 0FB7h ;# 
# 4947 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1DEL equ 0FB7h ;# 
# 4982 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BAUDCON equ 0FB8h ;# 
# 4987 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BAUDCTL equ 0FB8h ;# 
# 5162 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP2CON equ 0FBAh ;# 
# 5226 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2 equ 0FBBh ;# 
# 5233 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2L equ 0FBBh ;# 
# 5240 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2H equ 0FBCh ;# 
# 5247 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1CON equ 0FBDh ;# 
# 5311 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1 equ 0FBEh ;# 
# 5318 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1L equ 0FBEh ;# 
# 5325 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1H equ 0FBFh ;# 
# 5332 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON2 equ 0FC0h ;# 
# 5403 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON1 equ 0FC1h ;# 
# 5488 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON0 equ 0FC2h ;# 
# 5607 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRES equ 0FC3h ;# 
# 5614 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRESL equ 0FC3h ;# 
# 5621 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRESH equ 0FC4h ;# 
# 5628 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPCON2 equ 0FC5h ;# 
# 5690 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPCON1 equ 0FC6h ;# 
# 5760 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPSTAT equ 0FC7h ;# 
# 6008 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPADD equ 0FC8h ;# 
# 6015 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPBUF equ 0FC9h ;# 
# 6022 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T2CON equ 0FCAh ;# 
# 6120 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PR2 equ 0FCBh ;# 
# 6125 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
MEMCON equ 0FCBh ;# 
# 6230 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR2 equ 0FCCh ;# 
# 6237 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T1CON equ 0FCDh ;# 
# 6340 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1 equ 0FCEh ;# 
# 6347 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1L equ 0FCEh ;# 
# 6354 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1H equ 0FCFh ;# 
# 6361 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCON equ 0FD0h ;# 
# 6510 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
WDTCON equ 0FD1h ;# 
# 6538 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
HLVDCON equ 0FD2h ;# 
# 6543 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LVDCON equ 0FD2h ;# 
# 6808 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
OSCCON equ 0FD3h ;# 
# 6891 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T0CON equ 0FD5h ;# 
# 6961 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0 equ 0FD6h ;# 
# 6968 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0L equ 0FD6h ;# 
# 6975 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0H equ 0FD7h ;# 
# 6982 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
STATUS equ 0FD8h ;# 
# 7053 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2 equ 0FD9h ;# 
# 7060 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2L equ 0FD9h ;# 
# 7067 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2H equ 0FDAh ;# 
# 7074 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW2 equ 0FDBh ;# 
# 7081 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC2 equ 0FDCh ;# 
# 7088 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC2 equ 0FDDh ;# 
# 7095 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC2 equ 0FDEh ;# 
# 7102 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF2 equ 0FDFh ;# 
# 7109 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BSR equ 0FE0h ;# 
# 7116 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1 equ 0FE1h ;# 
# 7123 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1L equ 0FE1h ;# 
# 7130 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1H equ 0FE2h ;# 
# 7137 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW1 equ 0FE3h ;# 
# 7144 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC1 equ 0FE4h ;# 
# 7151 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC1 equ 0FE5h ;# 
# 7158 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC1 equ 0FE6h ;# 
# 7165 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF1 equ 0FE7h ;# 
# 7172 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
WREG equ 0FE8h ;# 
# 7179 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0 equ 0FE9h ;# 
# 7186 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0L equ 0FE9h ;# 
# 7193 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0H equ 0FEAh ;# 
# 7200 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW0 equ 0FEBh ;# 
# 7207 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC0 equ 0FECh ;# 
# 7214 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC0 equ 0FEDh ;# 
# 7221 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC0 equ 0FEEh ;# 
# 7228 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF0 equ 0FEFh ;# 
# 7235 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON3 equ 0FF0h ;# 
# 7327 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON2 equ 0FF1h ;# 
# 7404 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON equ 0FF2h ;# 
# 7521 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PROD equ 0FF3h ;# 
# 7528 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PRODL equ 0FF3h ;# 
# 7535 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PRODH equ 0FF4h ;# 
# 7542 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TABLAT equ 0FF5h ;# 
# 7551 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTR equ 0FF6h ;# 
# 7558 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRL equ 0FF6h ;# 
# 7565 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRH equ 0FF7h ;# 
# 7572 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRU equ 0FF8h ;# 
# 7581 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLAT equ 0FF9h ;# 
# 7588 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PC equ 0FF9h ;# 
# 7595 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCL equ 0FF9h ;# 
# 7602 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLATH equ 0FFAh ;# 
# 7609 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLATU equ 0FFBh ;# 
# 7616 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
STKPTR equ 0FFCh ;# 
# 7692 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOS equ 0FFDh ;# 
# 7699 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSL equ 0FFDh ;# 
# 7706 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSH equ 0FFEh ;# 
# 7713 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSU equ 0FFFh ;# 
# 55 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRM equ 0F66h ;# 
# 62 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRML equ 0F66h ;# 
# 140 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRMH equ 0F67h ;# 
# 180 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UIR equ 0F68h ;# 
# 236 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UIE equ 0F69h ;# 
# 292 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEIR equ 0F6Ah ;# 
# 343 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEIE equ 0F6Bh ;# 
# 394 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
USTAT equ 0F6Ch ;# 
# 454 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UCON equ 0F6Dh ;# 
# 505 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UADDR equ 0F6Eh ;# 
# 569 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UCFG equ 0F6Fh ;# 
# 648 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP0 equ 0F70h ;# 
# 756 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP1 equ 0F71h ;# 
# 864 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP2 equ 0F72h ;# 
# 972 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP3 equ 0F73h ;# 
# 1080 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP4 equ 0F74h ;# 
# 1188 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP5 equ 0F75h ;# 
# 1296 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP6 equ 0F76h ;# 
# 1404 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP7 equ 0F77h ;# 
# 1512 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP8 equ 0F78h ;# 
# 1588 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP9 equ 0F79h ;# 
# 1664 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP10 equ 0F7Ah ;# 
# 1740 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP11 equ 0F7Bh ;# 
# 1816 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP12 equ 0F7Ch ;# 
# 1892 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP13 equ 0F7Dh ;# 
# 1968 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP14 equ 0F7Eh ;# 
# 2044 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP15 equ 0F7Fh ;# 
# 2120 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTA equ 0F80h ;# 
# 2259 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTB equ 0F81h ;# 
# 2369 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTC equ 0F82h ;# 
# 2511 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTE equ 0F84h ;# 
# 2550 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATA equ 0F89h ;# 
# 2650 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATB equ 0F8Ah ;# 
# 2762 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATC equ 0F8Bh ;# 
# 2840 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISA equ 0F92h ;# 
# 2845 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRA equ 0F92h ;# 
# 3038 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISB equ 0F93h ;# 
# 3043 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRB equ 0F93h ;# 
# 3260 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISC equ 0F94h ;# 
# 3265 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRC equ 0F94h ;# 
# 3414 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
OSCTUNE equ 0F9Bh ;# 
# 3473 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIE1 equ 0F9Dh ;# 
# 3544 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIR1 equ 0F9Eh ;# 
# 3615 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
IPR1 equ 0F9Fh ;# 
# 3686 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIE2 equ 0FA0h ;# 
# 3757 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIR2 equ 0FA1h ;# 
# 3828 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
IPR2 equ 0FA2h ;# 
# 3899 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EECON1 equ 0FA6h ;# 
# 3965 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EECON2 equ 0FA7h ;# 
# 3972 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EEDATA equ 0FA8h ;# 
# 3979 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EEADR equ 0FA9h ;# 
# 3986 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCSTA equ 0FABh ;# 
# 3991 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCSTA1 equ 0FABh ;# 
# 4196 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXSTA equ 0FACh ;# 
# 4201 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXSTA1 equ 0FACh ;# 
# 4452 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXREG equ 0FADh ;# 
# 4457 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXREG1 equ 0FADh ;# 
# 4464 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCREG equ 0FAEh ;# 
# 4469 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCREG1 equ 0FAEh ;# 
# 4476 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRG equ 0FAFh ;# 
# 4481 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRG1 equ 0FAFh ;# 
# 4488 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRGH equ 0FB0h ;# 
# 4495 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T3CON equ 0FB1h ;# 
# 4616 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3 equ 0FB2h ;# 
# 4623 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3L equ 0FB2h ;# 
# 4630 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3H equ 0FB3h ;# 
# 4637 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CMCON equ 0FB4h ;# 
# 4727 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CVRCON equ 0FB5h ;# 
# 4812 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ECCP1AS equ 0FB6h ;# 
# 4817 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1AS equ 0FB6h ;# 
# 4942 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ECCP1DEL equ 0FB7h ;# 
# 4947 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1DEL equ 0FB7h ;# 
# 4982 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BAUDCON equ 0FB8h ;# 
# 4987 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BAUDCTL equ 0FB8h ;# 
# 5162 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP2CON equ 0FBAh ;# 
# 5226 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2 equ 0FBBh ;# 
# 5233 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2L equ 0FBBh ;# 
# 5240 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2H equ 0FBCh ;# 
# 5247 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1CON equ 0FBDh ;# 
# 5311 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1 equ 0FBEh ;# 
# 5318 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1L equ 0FBEh ;# 
# 5325 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1H equ 0FBFh ;# 
# 5332 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON2 equ 0FC0h ;# 
# 5403 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON1 equ 0FC1h ;# 
# 5488 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON0 equ 0FC2h ;# 
# 5607 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRES equ 0FC3h ;# 
# 5614 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRESL equ 0FC3h ;# 
# 5621 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRESH equ 0FC4h ;# 
# 5628 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPCON2 equ 0FC5h ;# 
# 5690 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPCON1 equ 0FC6h ;# 
# 5760 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPSTAT equ 0FC7h ;# 
# 6008 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPADD equ 0FC8h ;# 
# 6015 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPBUF equ 0FC9h ;# 
# 6022 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T2CON equ 0FCAh ;# 
# 6120 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PR2 equ 0FCBh ;# 
# 6125 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
MEMCON equ 0FCBh ;# 
# 6230 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR2 equ 0FCCh ;# 
# 6237 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T1CON equ 0FCDh ;# 
# 6340 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1 equ 0FCEh ;# 
# 6347 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1L equ 0FCEh ;# 
# 6354 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1H equ 0FCFh ;# 
# 6361 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCON equ 0FD0h ;# 
# 6510 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
WDTCON equ 0FD1h ;# 
# 6538 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
HLVDCON equ 0FD2h ;# 
# 6543 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LVDCON equ 0FD2h ;# 
# 6808 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
OSCCON equ 0FD3h ;# 
# 6891 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T0CON equ 0FD5h ;# 
# 6961 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0 equ 0FD6h ;# 
# 6968 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0L equ 0FD6h ;# 
# 6975 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0H equ 0FD7h ;# 
# 6982 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
STATUS equ 0FD8h ;# 
# 7053 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2 equ 0FD9h ;# 
# 7060 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2L equ 0FD9h ;# 
# 7067 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2H equ 0FDAh ;# 
# 7074 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW2 equ 0FDBh ;# 
# 7081 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC2 equ 0FDCh ;# 
# 7088 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC2 equ 0FDDh ;# 
# 7095 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC2 equ 0FDEh ;# 
# 7102 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF2 equ 0FDFh ;# 
# 7109 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BSR equ 0FE0h ;# 
# 7116 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1 equ 0FE1h ;# 
# 7123 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1L equ 0FE1h ;# 
# 7130 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1H equ 0FE2h ;# 
# 7137 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW1 equ 0FE3h ;# 
# 7144 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC1 equ 0FE4h ;# 
# 7151 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC1 equ 0FE5h ;# 
# 7158 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC1 equ 0FE6h ;# 
# 7165 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF1 equ 0FE7h ;# 
# 7172 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
WREG equ 0FE8h ;# 
# 7179 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0 equ 0FE9h ;# 
# 7186 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0L equ 0FE9h ;# 
# 7193 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0H equ 0FEAh ;# 
# 7200 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW0 equ 0FEBh ;# 
# 7207 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC0 equ 0FECh ;# 
# 7214 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC0 equ 0FEDh ;# 
# 7221 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC0 equ 0FEEh ;# 
# 7228 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF0 equ 0FEFh ;# 
# 7235 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON3 equ 0FF0h ;# 
# 7327 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON2 equ 0FF1h ;# 
# 7404 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON equ 0FF2h ;# 
# 7521 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PROD equ 0FF3h ;# 
# 7528 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PRODL equ 0FF3h ;# 
# 7535 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PRODH equ 0FF4h ;# 
# 7542 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TABLAT equ 0FF5h ;# 
# 7551 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTR equ 0FF6h ;# 
# 7558 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRL equ 0FF6h ;# 
# 7565 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRH equ 0FF7h ;# 
# 7572 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRU equ 0FF8h ;# 
# 7581 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLAT equ 0FF9h ;# 
# 7588 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PC equ 0FF9h ;# 
# 7595 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCL equ 0FF9h ;# 
# 7602 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLATH equ 0FFAh ;# 
# 7609 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLATU equ 0FFBh ;# 
# 7616 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
STKPTR equ 0FFCh ;# 
# 7692 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOS equ 0FFDh ;# 
# 7699 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSL equ 0FFDh ;# 
# 7706 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSH equ 0FFEh ;# 
# 7713 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSU equ 0FFFh ;# 
# 55 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRM equ 0F66h ;# 
# 62 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRML equ 0F66h ;# 
# 140 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRMH equ 0F67h ;# 
# 180 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UIR equ 0F68h ;# 
# 236 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UIE equ 0F69h ;# 
# 292 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEIR equ 0F6Ah ;# 
# 343 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEIE equ 0F6Bh ;# 
# 394 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
USTAT equ 0F6Ch ;# 
# 454 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UCON equ 0F6Dh ;# 
# 505 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UADDR equ 0F6Eh ;# 
# 569 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UCFG equ 0F6Fh ;# 
# 648 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP0 equ 0F70h ;# 
# 756 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP1 equ 0F71h ;# 
# 864 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP2 equ 0F72h ;# 
# 972 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP3 equ 0F73h ;# 
# 1080 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP4 equ 0F74h ;# 
# 1188 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP5 equ 0F75h ;# 
# 1296 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP6 equ 0F76h ;# 
# 1404 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP7 equ 0F77h ;# 
# 1512 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP8 equ 0F78h ;# 
# 1588 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP9 equ 0F79h ;# 
# 1664 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP10 equ 0F7Ah ;# 
# 1740 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP11 equ 0F7Bh ;# 
# 1816 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP12 equ 0F7Ch ;# 
# 1892 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP13 equ 0F7Dh ;# 
# 1968 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP14 equ 0F7Eh ;# 
# 2044 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP15 equ 0F7Fh ;# 
# 2120 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTA equ 0F80h ;# 
# 2259 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTB equ 0F81h ;# 
# 2369 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTC equ 0F82h ;# 
# 2511 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTE equ 0F84h ;# 
# 2550 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATA equ 0F89h ;# 
# 2650 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATB equ 0F8Ah ;# 
# 2762 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATC equ 0F8Bh ;# 
# 2840 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISA equ 0F92h ;# 
# 2845 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRA equ 0F92h ;# 
# 3038 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISB equ 0F93h ;# 
# 3043 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRB equ 0F93h ;# 
# 3260 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISC equ 0F94h ;# 
# 3265 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRC equ 0F94h ;# 
# 3414 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
OSCTUNE equ 0F9Bh ;# 
# 3473 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIE1 equ 0F9Dh ;# 
# 3544 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIR1 equ 0F9Eh ;# 
# 3615 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
IPR1 equ 0F9Fh ;# 
# 3686 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIE2 equ 0FA0h ;# 
# 3757 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIR2 equ 0FA1h ;# 
# 3828 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
IPR2 equ 0FA2h ;# 
# 3899 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EECON1 equ 0FA6h ;# 
# 3965 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EECON2 equ 0FA7h ;# 
# 3972 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EEDATA equ 0FA8h ;# 
# 3979 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EEADR equ 0FA9h ;# 
# 3986 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCSTA equ 0FABh ;# 
# 3991 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCSTA1 equ 0FABh ;# 
# 4196 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXSTA equ 0FACh ;# 
# 4201 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXSTA1 equ 0FACh ;# 
# 4452 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXREG equ 0FADh ;# 
# 4457 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXREG1 equ 0FADh ;# 
# 4464 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCREG equ 0FAEh ;# 
# 4469 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCREG1 equ 0FAEh ;# 
# 4476 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRG equ 0FAFh ;# 
# 4481 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRG1 equ 0FAFh ;# 
# 4488 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRGH equ 0FB0h ;# 
# 4495 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T3CON equ 0FB1h ;# 
# 4616 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3 equ 0FB2h ;# 
# 4623 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3L equ 0FB2h ;# 
# 4630 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3H equ 0FB3h ;# 
# 4637 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CMCON equ 0FB4h ;# 
# 4727 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CVRCON equ 0FB5h ;# 
# 4812 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ECCP1AS equ 0FB6h ;# 
# 4817 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1AS equ 0FB6h ;# 
# 4942 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ECCP1DEL equ 0FB7h ;# 
# 4947 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1DEL equ 0FB7h ;# 
# 4982 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BAUDCON equ 0FB8h ;# 
# 4987 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BAUDCTL equ 0FB8h ;# 
# 5162 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP2CON equ 0FBAh ;# 
# 5226 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2 equ 0FBBh ;# 
# 5233 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2L equ 0FBBh ;# 
# 5240 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2H equ 0FBCh ;# 
# 5247 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1CON equ 0FBDh ;# 
# 5311 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1 equ 0FBEh ;# 
# 5318 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1L equ 0FBEh ;# 
# 5325 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1H equ 0FBFh ;# 
# 5332 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON2 equ 0FC0h ;# 
# 5403 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON1 equ 0FC1h ;# 
# 5488 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON0 equ 0FC2h ;# 
# 5607 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRES equ 0FC3h ;# 
# 5614 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRESL equ 0FC3h ;# 
# 5621 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRESH equ 0FC4h ;# 
# 5628 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPCON2 equ 0FC5h ;# 
# 5690 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPCON1 equ 0FC6h ;# 
# 5760 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPSTAT equ 0FC7h ;# 
# 6008 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPADD equ 0FC8h ;# 
# 6015 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPBUF equ 0FC9h ;# 
# 6022 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T2CON equ 0FCAh ;# 
# 6120 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PR2 equ 0FCBh ;# 
# 6125 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
MEMCON equ 0FCBh ;# 
# 6230 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR2 equ 0FCCh ;# 
# 6237 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T1CON equ 0FCDh ;# 
# 6340 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1 equ 0FCEh ;# 
# 6347 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1L equ 0FCEh ;# 
# 6354 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1H equ 0FCFh ;# 
# 6361 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCON equ 0FD0h ;# 
# 6510 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
WDTCON equ 0FD1h ;# 
# 6538 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
HLVDCON equ 0FD2h ;# 
# 6543 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LVDCON equ 0FD2h ;# 
# 6808 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
OSCCON equ 0FD3h ;# 
# 6891 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T0CON equ 0FD5h ;# 
# 6961 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0 equ 0FD6h ;# 
# 6968 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0L equ 0FD6h ;# 
# 6975 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0H equ 0FD7h ;# 
# 6982 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
STATUS equ 0FD8h ;# 
# 7053 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2 equ 0FD9h ;# 
# 7060 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2L equ 0FD9h ;# 
# 7067 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2H equ 0FDAh ;# 
# 7074 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW2 equ 0FDBh ;# 
# 7081 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC2 equ 0FDCh ;# 
# 7088 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC2 equ 0FDDh ;# 
# 7095 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC2 equ 0FDEh ;# 
# 7102 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF2 equ 0FDFh ;# 
# 7109 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BSR equ 0FE0h ;# 
# 7116 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1 equ 0FE1h ;# 
# 7123 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1L equ 0FE1h ;# 
# 7130 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1H equ 0FE2h ;# 
# 7137 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW1 equ 0FE3h ;# 
# 7144 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC1 equ 0FE4h ;# 
# 7151 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC1 equ 0FE5h ;# 
# 7158 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC1 equ 0FE6h ;# 
# 7165 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF1 equ 0FE7h ;# 
# 7172 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
WREG equ 0FE8h ;# 
# 7179 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0 equ 0FE9h ;# 
# 7186 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0L equ 0FE9h ;# 
# 7193 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0H equ 0FEAh ;# 
# 7200 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW0 equ 0FEBh ;# 
# 7207 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC0 equ 0FECh ;# 
# 7214 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC0 equ 0FEDh ;# 
# 7221 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC0 equ 0FEEh ;# 
# 7228 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF0 equ 0FEFh ;# 
# 7235 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON3 equ 0FF0h ;# 
# 7327 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON2 equ 0FF1h ;# 
# 7404 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON equ 0FF2h ;# 
# 7521 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PROD equ 0FF3h ;# 
# 7528 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PRODL equ 0FF3h ;# 
# 7535 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PRODH equ 0FF4h ;# 
# 7542 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TABLAT equ 0FF5h ;# 
# 7551 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTR equ 0FF6h ;# 
# 7558 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRL equ 0FF6h ;# 
# 7565 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRH equ 0FF7h ;# 
# 7572 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRU equ 0FF8h ;# 
# 7581 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLAT equ 0FF9h ;# 
# 7588 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PC equ 0FF9h ;# 
# 7595 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCL equ 0FF9h ;# 
# 7602 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLATH equ 0FFAh ;# 
# 7609 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLATU equ 0FFBh ;# 
# 7616 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
STKPTR equ 0FFCh ;# 
# 7692 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOS equ 0FFDh ;# 
# 7699 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSL equ 0FFDh ;# 
# 7706 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSH equ 0FFEh ;# 
# 7713 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSU equ 0FFFh ;# 
# 55 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRM equ 0F66h ;# 
# 62 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRML equ 0F66h ;# 
# 140 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRMH equ 0F67h ;# 
# 180 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UIR equ 0F68h ;# 
# 236 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UIE equ 0F69h ;# 
# 292 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEIR equ 0F6Ah ;# 
# 343 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEIE equ 0F6Bh ;# 
# 394 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
USTAT equ 0F6Ch ;# 
# 454 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UCON equ 0F6Dh ;# 
# 505 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UADDR equ 0F6Eh ;# 
# 569 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UCFG equ 0F6Fh ;# 
# 648 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP0 equ 0F70h ;# 
# 756 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP1 equ 0F71h ;# 
# 864 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP2 equ 0F72h ;# 
# 972 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP3 equ 0F73h ;# 
# 1080 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP4 equ 0F74h ;# 
# 1188 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP5 equ 0F75h ;# 
# 1296 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP6 equ 0F76h ;# 
# 1404 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP7 equ 0F77h ;# 
# 1512 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP8 equ 0F78h ;# 
# 1588 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP9 equ 0F79h ;# 
# 1664 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP10 equ 0F7Ah ;# 
# 1740 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP11 equ 0F7Bh ;# 
# 1816 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP12 equ 0F7Ch ;# 
# 1892 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP13 equ 0F7Dh ;# 
# 1968 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP14 equ 0F7Eh ;# 
# 2044 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP15 equ 0F7Fh ;# 
# 2120 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTA equ 0F80h ;# 
# 2259 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTB equ 0F81h ;# 
# 2369 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTC equ 0F82h ;# 
# 2511 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTE equ 0F84h ;# 
# 2550 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATA equ 0F89h ;# 
# 2650 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATB equ 0F8Ah ;# 
# 2762 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATC equ 0F8Bh ;# 
# 2840 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISA equ 0F92h ;# 
# 2845 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRA equ 0F92h ;# 
# 3038 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISB equ 0F93h ;# 
# 3043 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRB equ 0F93h ;# 
# 3260 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISC equ 0F94h ;# 
# 3265 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRC equ 0F94h ;# 
# 3414 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
OSCTUNE equ 0F9Bh ;# 
# 3473 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIE1 equ 0F9Dh ;# 
# 3544 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIR1 equ 0F9Eh ;# 
# 3615 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
IPR1 equ 0F9Fh ;# 
# 3686 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIE2 equ 0FA0h ;# 
# 3757 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIR2 equ 0FA1h ;# 
# 3828 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
IPR2 equ 0FA2h ;# 
# 3899 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EECON1 equ 0FA6h ;# 
# 3965 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EECON2 equ 0FA7h ;# 
# 3972 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EEDATA equ 0FA8h ;# 
# 3979 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EEADR equ 0FA9h ;# 
# 3986 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCSTA equ 0FABh ;# 
# 3991 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCSTA1 equ 0FABh ;# 
# 4196 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXSTA equ 0FACh ;# 
# 4201 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXSTA1 equ 0FACh ;# 
# 4452 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXREG equ 0FADh ;# 
# 4457 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXREG1 equ 0FADh ;# 
# 4464 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCREG equ 0FAEh ;# 
# 4469 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCREG1 equ 0FAEh ;# 
# 4476 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRG equ 0FAFh ;# 
# 4481 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRG1 equ 0FAFh ;# 
# 4488 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRGH equ 0FB0h ;# 
# 4495 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T3CON equ 0FB1h ;# 
# 4616 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3 equ 0FB2h ;# 
# 4623 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3L equ 0FB2h ;# 
# 4630 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3H equ 0FB3h ;# 
# 4637 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CMCON equ 0FB4h ;# 
# 4727 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CVRCON equ 0FB5h ;# 
# 4812 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ECCP1AS equ 0FB6h ;# 
# 4817 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1AS equ 0FB6h ;# 
# 4942 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ECCP1DEL equ 0FB7h ;# 
# 4947 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1DEL equ 0FB7h ;# 
# 4982 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BAUDCON equ 0FB8h ;# 
# 4987 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BAUDCTL equ 0FB8h ;# 
# 5162 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP2CON equ 0FBAh ;# 
# 5226 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2 equ 0FBBh ;# 
# 5233 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2L equ 0FBBh ;# 
# 5240 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2H equ 0FBCh ;# 
# 5247 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1CON equ 0FBDh ;# 
# 5311 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1 equ 0FBEh ;# 
# 5318 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1L equ 0FBEh ;# 
# 5325 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1H equ 0FBFh ;# 
# 5332 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON2 equ 0FC0h ;# 
# 5403 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON1 equ 0FC1h ;# 
# 5488 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON0 equ 0FC2h ;# 
# 5607 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRES equ 0FC3h ;# 
# 5614 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRESL equ 0FC3h ;# 
# 5621 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRESH equ 0FC4h ;# 
# 5628 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPCON2 equ 0FC5h ;# 
# 5690 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPCON1 equ 0FC6h ;# 
# 5760 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPSTAT equ 0FC7h ;# 
# 6008 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPADD equ 0FC8h ;# 
# 6015 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPBUF equ 0FC9h ;# 
# 6022 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T2CON equ 0FCAh ;# 
# 6120 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PR2 equ 0FCBh ;# 
# 6125 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
MEMCON equ 0FCBh ;# 
# 6230 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR2 equ 0FCCh ;# 
# 6237 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T1CON equ 0FCDh ;# 
# 6340 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1 equ 0FCEh ;# 
# 6347 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1L equ 0FCEh ;# 
# 6354 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1H equ 0FCFh ;# 
# 6361 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCON equ 0FD0h ;# 
# 6510 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
WDTCON equ 0FD1h ;# 
# 6538 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
HLVDCON equ 0FD2h ;# 
# 6543 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LVDCON equ 0FD2h ;# 
# 6808 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
OSCCON equ 0FD3h ;# 
# 6891 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T0CON equ 0FD5h ;# 
# 6961 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0 equ 0FD6h ;# 
# 6968 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0L equ 0FD6h ;# 
# 6975 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0H equ 0FD7h ;# 
# 6982 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
STATUS equ 0FD8h ;# 
# 7053 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2 equ 0FD9h ;# 
# 7060 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2L equ 0FD9h ;# 
# 7067 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2H equ 0FDAh ;# 
# 7074 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW2 equ 0FDBh ;# 
# 7081 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC2 equ 0FDCh ;# 
# 7088 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC2 equ 0FDDh ;# 
# 7095 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC2 equ 0FDEh ;# 
# 7102 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF2 equ 0FDFh ;# 
# 7109 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BSR equ 0FE0h ;# 
# 7116 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1 equ 0FE1h ;# 
# 7123 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1L equ 0FE1h ;# 
# 7130 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1H equ 0FE2h ;# 
# 7137 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW1 equ 0FE3h ;# 
# 7144 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC1 equ 0FE4h ;# 
# 7151 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC1 equ 0FE5h ;# 
# 7158 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC1 equ 0FE6h ;# 
# 7165 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF1 equ 0FE7h ;# 
# 7172 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
WREG equ 0FE8h ;# 
# 7179 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0 equ 0FE9h ;# 
# 7186 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0L equ 0FE9h ;# 
# 7193 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0H equ 0FEAh ;# 
# 7200 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW0 equ 0FEBh ;# 
# 7207 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC0 equ 0FECh ;# 
# 7214 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC0 equ 0FEDh ;# 
# 7221 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC0 equ 0FEEh ;# 
# 7228 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF0 equ 0FEFh ;# 
# 7235 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON3 equ 0FF0h ;# 
# 7327 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON2 equ 0FF1h ;# 
# 7404 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON equ 0FF2h ;# 
# 7521 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PROD equ 0FF3h ;# 
# 7528 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PRODL equ 0FF3h ;# 
# 7535 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PRODH equ 0FF4h ;# 
# 7542 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TABLAT equ 0FF5h ;# 
# 7551 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTR equ 0FF6h ;# 
# 7558 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRL equ 0FF6h ;# 
# 7565 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRH equ 0FF7h ;# 
# 7572 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRU equ 0FF8h ;# 
# 7581 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLAT equ 0FF9h ;# 
# 7588 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PC equ 0FF9h ;# 
# 7595 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCL equ 0FF9h ;# 
# 7602 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLATH equ 0FFAh ;# 
# 7609 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLATU equ 0FFBh ;# 
# 7616 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
STKPTR equ 0FFCh ;# 
# 7692 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOS equ 0FFDh ;# 
# 7699 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSL equ 0FFDh ;# 
# 7706 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSH equ 0FFEh ;# 
# 7713 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSU equ 0FFFh ;# 
# 55 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRM equ 0F66h ;# 
# 62 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRML equ 0F66h ;# 
# 140 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRMH equ 0F67h ;# 
# 180 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UIR equ 0F68h ;# 
# 236 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UIE equ 0F69h ;# 
# 292 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEIR equ 0F6Ah ;# 
# 343 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEIE equ 0F6Bh ;# 
# 394 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
USTAT equ 0F6Ch ;# 
# 454 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UCON equ 0F6Dh ;# 
# 505 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UADDR equ 0F6Eh ;# 
# 569 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UCFG equ 0F6Fh ;# 
# 648 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP0 equ 0F70h ;# 
# 756 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP1 equ 0F71h ;# 
# 864 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP2 equ 0F72h ;# 
# 972 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP3 equ 0F73h ;# 
# 1080 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP4 equ 0F74h ;# 
# 1188 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP5 equ 0F75h ;# 
# 1296 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP6 equ 0F76h ;# 
# 1404 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP7 equ 0F77h ;# 
# 1512 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP8 equ 0F78h ;# 
# 1588 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP9 equ 0F79h ;# 
# 1664 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP10 equ 0F7Ah ;# 
# 1740 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP11 equ 0F7Bh ;# 
# 1816 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP12 equ 0F7Ch ;# 
# 1892 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP13 equ 0F7Dh ;# 
# 1968 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP14 equ 0F7Eh ;# 
# 2044 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP15 equ 0F7Fh ;# 
# 2120 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTA equ 0F80h ;# 
# 2259 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTB equ 0F81h ;# 
# 2369 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTC equ 0F82h ;# 
# 2511 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTE equ 0F84h ;# 
# 2550 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATA equ 0F89h ;# 
# 2650 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATB equ 0F8Ah ;# 
# 2762 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATC equ 0F8Bh ;# 
# 2840 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISA equ 0F92h ;# 
# 2845 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRA equ 0F92h ;# 
# 3038 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISB equ 0F93h ;# 
# 3043 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRB equ 0F93h ;# 
# 3260 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISC equ 0F94h ;# 
# 3265 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRC equ 0F94h ;# 
# 3414 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
OSCTUNE equ 0F9Bh ;# 
# 3473 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIE1 equ 0F9Dh ;# 
# 3544 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIR1 equ 0F9Eh ;# 
# 3615 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
IPR1 equ 0F9Fh ;# 
# 3686 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIE2 equ 0FA0h ;# 
# 3757 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIR2 equ 0FA1h ;# 
# 3828 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
IPR2 equ 0FA2h ;# 
# 3899 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EECON1 equ 0FA6h ;# 
# 3965 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EECON2 equ 0FA7h ;# 
# 3972 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EEDATA equ 0FA8h ;# 
# 3979 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EEADR equ 0FA9h ;# 
# 3986 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCSTA equ 0FABh ;# 
# 3991 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCSTA1 equ 0FABh ;# 
# 4196 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXSTA equ 0FACh ;# 
# 4201 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXSTA1 equ 0FACh ;# 
# 4452 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXREG equ 0FADh ;# 
# 4457 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXREG1 equ 0FADh ;# 
# 4464 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCREG equ 0FAEh ;# 
# 4469 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCREG1 equ 0FAEh ;# 
# 4476 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRG equ 0FAFh ;# 
# 4481 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRG1 equ 0FAFh ;# 
# 4488 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRGH equ 0FB0h ;# 
# 4495 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T3CON equ 0FB1h ;# 
# 4616 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3 equ 0FB2h ;# 
# 4623 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3L equ 0FB2h ;# 
# 4630 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3H equ 0FB3h ;# 
# 4637 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CMCON equ 0FB4h ;# 
# 4727 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CVRCON equ 0FB5h ;# 
# 4812 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ECCP1AS equ 0FB6h ;# 
# 4817 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1AS equ 0FB6h ;# 
# 4942 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ECCP1DEL equ 0FB7h ;# 
# 4947 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1DEL equ 0FB7h ;# 
# 4982 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BAUDCON equ 0FB8h ;# 
# 4987 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BAUDCTL equ 0FB8h ;# 
# 5162 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP2CON equ 0FBAh ;# 
# 5226 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2 equ 0FBBh ;# 
# 5233 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2L equ 0FBBh ;# 
# 5240 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2H equ 0FBCh ;# 
# 5247 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1CON equ 0FBDh ;# 
# 5311 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1 equ 0FBEh ;# 
# 5318 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1L equ 0FBEh ;# 
# 5325 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1H equ 0FBFh ;# 
# 5332 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON2 equ 0FC0h ;# 
# 5403 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON1 equ 0FC1h ;# 
# 5488 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON0 equ 0FC2h ;# 
# 5607 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRES equ 0FC3h ;# 
# 5614 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRESL equ 0FC3h ;# 
# 5621 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRESH equ 0FC4h ;# 
# 5628 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPCON2 equ 0FC5h ;# 
# 5690 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPCON1 equ 0FC6h ;# 
# 5760 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPSTAT equ 0FC7h ;# 
# 6008 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPADD equ 0FC8h ;# 
# 6015 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPBUF equ 0FC9h ;# 
# 6022 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T2CON equ 0FCAh ;# 
# 6120 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PR2 equ 0FCBh ;# 
# 6125 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
MEMCON equ 0FCBh ;# 
# 6230 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR2 equ 0FCCh ;# 
# 6237 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T1CON equ 0FCDh ;# 
# 6340 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1 equ 0FCEh ;# 
# 6347 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1L equ 0FCEh ;# 
# 6354 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1H equ 0FCFh ;# 
# 6361 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCON equ 0FD0h ;# 
# 6510 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
WDTCON equ 0FD1h ;# 
# 6538 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
HLVDCON equ 0FD2h ;# 
# 6543 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LVDCON equ 0FD2h ;# 
# 6808 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
OSCCON equ 0FD3h ;# 
# 6891 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T0CON equ 0FD5h ;# 
# 6961 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0 equ 0FD6h ;# 
# 6968 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0L equ 0FD6h ;# 
# 6975 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0H equ 0FD7h ;# 
# 6982 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
STATUS equ 0FD8h ;# 
# 7053 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2 equ 0FD9h ;# 
# 7060 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2L equ 0FD9h ;# 
# 7067 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2H equ 0FDAh ;# 
# 7074 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW2 equ 0FDBh ;# 
# 7081 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC2 equ 0FDCh ;# 
# 7088 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC2 equ 0FDDh ;# 
# 7095 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC2 equ 0FDEh ;# 
# 7102 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF2 equ 0FDFh ;# 
# 7109 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BSR equ 0FE0h ;# 
# 7116 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1 equ 0FE1h ;# 
# 7123 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1L equ 0FE1h ;# 
# 7130 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1H equ 0FE2h ;# 
# 7137 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW1 equ 0FE3h ;# 
# 7144 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC1 equ 0FE4h ;# 
# 7151 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC1 equ 0FE5h ;# 
# 7158 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC1 equ 0FE6h ;# 
# 7165 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF1 equ 0FE7h ;# 
# 7172 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
WREG equ 0FE8h ;# 
# 7179 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0 equ 0FE9h ;# 
# 7186 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0L equ 0FE9h ;# 
# 7193 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0H equ 0FEAh ;# 
# 7200 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW0 equ 0FEBh ;# 
# 7207 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC0 equ 0FECh ;# 
# 7214 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC0 equ 0FEDh ;# 
# 7221 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC0 equ 0FEEh ;# 
# 7228 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF0 equ 0FEFh ;# 
# 7235 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON3 equ 0FF0h ;# 
# 7327 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON2 equ 0FF1h ;# 
# 7404 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON equ 0FF2h ;# 
# 7521 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PROD equ 0FF3h ;# 
# 7528 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PRODL equ 0FF3h ;# 
# 7535 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PRODH equ 0FF4h ;# 
# 7542 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TABLAT equ 0FF5h ;# 
# 7551 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTR equ 0FF6h ;# 
# 7558 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRL equ 0FF6h ;# 
# 7565 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRH equ 0FF7h ;# 
# 7572 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRU equ 0FF8h ;# 
# 7581 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLAT equ 0FF9h ;# 
# 7588 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PC equ 0FF9h ;# 
# 7595 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCL equ 0FF9h ;# 
# 7602 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLATH equ 0FFAh ;# 
# 7609 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLATU equ 0FFBh ;# 
# 7616 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
STKPTR equ 0FFCh ;# 
# 7692 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOS equ 0FFDh ;# 
# 7699 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSL equ 0FFDh ;# 
# 7706 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSH equ 0FFEh ;# 
# 7713 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSU equ 0FFFh ;# 
# 55 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRM equ 0F66h ;# 
# 62 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRML equ 0F66h ;# 
# 140 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRMH equ 0F67h ;# 
# 180 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UIR equ 0F68h ;# 
# 236 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UIE equ 0F69h ;# 
# 292 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEIR equ 0F6Ah ;# 
# 343 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEIE equ 0F6Bh ;# 
# 394 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
USTAT equ 0F6Ch ;# 
# 454 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UCON equ 0F6Dh ;# 
# 505 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UADDR equ 0F6Eh ;# 
# 569 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UCFG equ 0F6Fh ;# 
# 648 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP0 equ 0F70h ;# 
# 756 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP1 equ 0F71h ;# 
# 864 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP2 equ 0F72h ;# 
# 972 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP3 equ 0F73h ;# 
# 1080 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP4 equ 0F74h ;# 
# 1188 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP5 equ 0F75h ;# 
# 1296 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP6 equ 0F76h ;# 
# 1404 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP7 equ 0F77h ;# 
# 1512 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP8 equ 0F78h ;# 
# 1588 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP9 equ 0F79h ;# 
# 1664 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP10 equ 0F7Ah ;# 
# 1740 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP11 equ 0F7Bh ;# 
# 1816 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP12 equ 0F7Ch ;# 
# 1892 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP13 equ 0F7Dh ;# 
# 1968 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP14 equ 0F7Eh ;# 
# 2044 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP15 equ 0F7Fh ;# 
# 2120 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTA equ 0F80h ;# 
# 2259 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTB equ 0F81h ;# 
# 2369 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTC equ 0F82h ;# 
# 2511 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTE equ 0F84h ;# 
# 2550 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATA equ 0F89h ;# 
# 2650 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATB equ 0F8Ah ;# 
# 2762 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATC equ 0F8Bh ;# 
# 2840 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISA equ 0F92h ;# 
# 2845 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRA equ 0F92h ;# 
# 3038 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISB equ 0F93h ;# 
# 3043 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRB equ 0F93h ;# 
# 3260 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISC equ 0F94h ;# 
# 3265 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRC equ 0F94h ;# 
# 3414 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
OSCTUNE equ 0F9Bh ;# 
# 3473 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIE1 equ 0F9Dh ;# 
# 3544 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIR1 equ 0F9Eh ;# 
# 3615 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
IPR1 equ 0F9Fh ;# 
# 3686 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIE2 equ 0FA0h ;# 
# 3757 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIR2 equ 0FA1h ;# 
# 3828 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
IPR2 equ 0FA2h ;# 
# 3899 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EECON1 equ 0FA6h ;# 
# 3965 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EECON2 equ 0FA7h ;# 
# 3972 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EEDATA equ 0FA8h ;# 
# 3979 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EEADR equ 0FA9h ;# 
# 3986 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCSTA equ 0FABh ;# 
# 3991 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCSTA1 equ 0FABh ;# 
# 4196 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXSTA equ 0FACh ;# 
# 4201 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXSTA1 equ 0FACh ;# 
# 4452 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXREG equ 0FADh ;# 
# 4457 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXREG1 equ 0FADh ;# 
# 4464 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCREG equ 0FAEh ;# 
# 4469 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCREG1 equ 0FAEh ;# 
# 4476 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRG equ 0FAFh ;# 
# 4481 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRG1 equ 0FAFh ;# 
# 4488 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRGH equ 0FB0h ;# 
# 4495 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T3CON equ 0FB1h ;# 
# 4616 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3 equ 0FB2h ;# 
# 4623 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3L equ 0FB2h ;# 
# 4630 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3H equ 0FB3h ;# 
# 4637 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CMCON equ 0FB4h ;# 
# 4727 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CVRCON equ 0FB5h ;# 
# 4812 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ECCP1AS equ 0FB6h ;# 
# 4817 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1AS equ 0FB6h ;# 
# 4942 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ECCP1DEL equ 0FB7h ;# 
# 4947 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1DEL equ 0FB7h ;# 
# 4982 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BAUDCON equ 0FB8h ;# 
# 4987 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BAUDCTL equ 0FB8h ;# 
# 5162 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP2CON equ 0FBAh ;# 
# 5226 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2 equ 0FBBh ;# 
# 5233 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2L equ 0FBBh ;# 
# 5240 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2H equ 0FBCh ;# 
# 5247 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1CON equ 0FBDh ;# 
# 5311 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1 equ 0FBEh ;# 
# 5318 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1L equ 0FBEh ;# 
# 5325 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1H equ 0FBFh ;# 
# 5332 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON2 equ 0FC0h ;# 
# 5403 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON1 equ 0FC1h ;# 
# 5488 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON0 equ 0FC2h ;# 
# 5607 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRES equ 0FC3h ;# 
# 5614 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRESL equ 0FC3h ;# 
# 5621 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRESH equ 0FC4h ;# 
# 5628 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPCON2 equ 0FC5h ;# 
# 5690 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPCON1 equ 0FC6h ;# 
# 5760 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPSTAT equ 0FC7h ;# 
# 6008 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPADD equ 0FC8h ;# 
# 6015 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPBUF equ 0FC9h ;# 
# 6022 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T2CON equ 0FCAh ;# 
# 6120 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PR2 equ 0FCBh ;# 
# 6125 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
MEMCON equ 0FCBh ;# 
# 6230 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR2 equ 0FCCh ;# 
# 6237 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T1CON equ 0FCDh ;# 
# 6340 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1 equ 0FCEh ;# 
# 6347 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1L equ 0FCEh ;# 
# 6354 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1H equ 0FCFh ;# 
# 6361 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCON equ 0FD0h ;# 
# 6510 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
WDTCON equ 0FD1h ;# 
# 6538 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
HLVDCON equ 0FD2h ;# 
# 6543 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LVDCON equ 0FD2h ;# 
# 6808 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
OSCCON equ 0FD3h ;# 
# 6891 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T0CON equ 0FD5h ;# 
# 6961 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0 equ 0FD6h ;# 
# 6968 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0L equ 0FD6h ;# 
# 6975 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0H equ 0FD7h ;# 
# 6982 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
STATUS equ 0FD8h ;# 
# 7053 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2 equ 0FD9h ;# 
# 7060 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2L equ 0FD9h ;# 
# 7067 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2H equ 0FDAh ;# 
# 7074 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW2 equ 0FDBh ;# 
# 7081 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC2 equ 0FDCh ;# 
# 7088 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC2 equ 0FDDh ;# 
# 7095 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC2 equ 0FDEh ;# 
# 7102 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF2 equ 0FDFh ;# 
# 7109 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BSR equ 0FE0h ;# 
# 7116 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1 equ 0FE1h ;# 
# 7123 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1L equ 0FE1h ;# 
# 7130 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1H equ 0FE2h ;# 
# 7137 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW1 equ 0FE3h ;# 
# 7144 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC1 equ 0FE4h ;# 
# 7151 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC1 equ 0FE5h ;# 
# 7158 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC1 equ 0FE6h ;# 
# 7165 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF1 equ 0FE7h ;# 
# 7172 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
WREG equ 0FE8h ;# 
# 7179 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0 equ 0FE9h ;# 
# 7186 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0L equ 0FE9h ;# 
# 7193 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0H equ 0FEAh ;# 
# 7200 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW0 equ 0FEBh ;# 
# 7207 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC0 equ 0FECh ;# 
# 7214 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC0 equ 0FEDh ;# 
# 7221 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC0 equ 0FEEh ;# 
# 7228 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF0 equ 0FEFh ;# 
# 7235 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON3 equ 0FF0h ;# 
# 7327 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON2 equ 0FF1h ;# 
# 7404 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON equ 0FF2h ;# 
# 7521 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PROD equ 0FF3h ;# 
# 7528 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PRODL equ 0FF3h ;# 
# 7535 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PRODH equ 0FF4h ;# 
# 7542 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TABLAT equ 0FF5h ;# 
# 7551 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTR equ 0FF6h ;# 
# 7558 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRL equ 0FF6h ;# 
# 7565 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRH equ 0FF7h ;# 
# 7572 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRU equ 0FF8h ;# 
# 7581 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLAT equ 0FF9h ;# 
# 7588 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PC equ 0FF9h ;# 
# 7595 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCL equ 0FF9h ;# 
# 7602 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLATH equ 0FFAh ;# 
# 7609 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLATU equ 0FFBh ;# 
# 7616 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
STKPTR equ 0FFCh ;# 
# 7692 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOS equ 0FFDh ;# 
# 7699 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSL equ 0FFDh ;# 
# 7706 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSH equ 0FFEh ;# 
# 7713 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSU equ 0FFFh ;# 
# 55 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRM equ 0F66h ;# 
# 62 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRML equ 0F66h ;# 
# 140 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRMH equ 0F67h ;# 
# 180 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UIR equ 0F68h ;# 
# 236 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UIE equ 0F69h ;# 
# 292 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEIR equ 0F6Ah ;# 
# 343 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEIE equ 0F6Bh ;# 
# 394 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
USTAT equ 0F6Ch ;# 
# 454 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UCON equ 0F6Dh ;# 
# 505 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UADDR equ 0F6Eh ;# 
# 569 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UCFG equ 0F6Fh ;# 
# 648 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP0 equ 0F70h ;# 
# 756 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP1 equ 0F71h ;# 
# 864 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP2 equ 0F72h ;# 
# 972 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP3 equ 0F73h ;# 
# 1080 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP4 equ 0F74h ;# 
# 1188 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP5 equ 0F75h ;# 
# 1296 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP6 equ 0F76h ;# 
# 1404 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP7 equ 0F77h ;# 
# 1512 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP8 equ 0F78h ;# 
# 1588 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP9 equ 0F79h ;# 
# 1664 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP10 equ 0F7Ah ;# 
# 1740 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP11 equ 0F7Bh ;# 
# 1816 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP12 equ 0F7Ch ;# 
# 1892 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP13 equ 0F7Dh ;# 
# 1968 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP14 equ 0F7Eh ;# 
# 2044 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP15 equ 0F7Fh ;# 
# 2120 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTA equ 0F80h ;# 
# 2259 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTB equ 0F81h ;# 
# 2369 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTC equ 0F82h ;# 
# 2511 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTE equ 0F84h ;# 
# 2550 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATA equ 0F89h ;# 
# 2650 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATB equ 0F8Ah ;# 
# 2762 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATC equ 0F8Bh ;# 
# 2840 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISA equ 0F92h ;# 
# 2845 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRA equ 0F92h ;# 
# 3038 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISB equ 0F93h ;# 
# 3043 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRB equ 0F93h ;# 
# 3260 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISC equ 0F94h ;# 
# 3265 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRC equ 0F94h ;# 
# 3414 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
OSCTUNE equ 0F9Bh ;# 
# 3473 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIE1 equ 0F9Dh ;# 
# 3544 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIR1 equ 0F9Eh ;# 
# 3615 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
IPR1 equ 0F9Fh ;# 
# 3686 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIE2 equ 0FA0h ;# 
# 3757 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIR2 equ 0FA1h ;# 
# 3828 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
IPR2 equ 0FA2h ;# 
# 3899 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EECON1 equ 0FA6h ;# 
# 3965 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EECON2 equ 0FA7h ;# 
# 3972 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EEDATA equ 0FA8h ;# 
# 3979 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EEADR equ 0FA9h ;# 
# 3986 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCSTA equ 0FABh ;# 
# 3991 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCSTA1 equ 0FABh ;# 
# 4196 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXSTA equ 0FACh ;# 
# 4201 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXSTA1 equ 0FACh ;# 
# 4452 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXREG equ 0FADh ;# 
# 4457 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXREG1 equ 0FADh ;# 
# 4464 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCREG equ 0FAEh ;# 
# 4469 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCREG1 equ 0FAEh ;# 
# 4476 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRG equ 0FAFh ;# 
# 4481 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRG1 equ 0FAFh ;# 
# 4488 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRGH equ 0FB0h ;# 
# 4495 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T3CON equ 0FB1h ;# 
# 4616 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3 equ 0FB2h ;# 
# 4623 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3L equ 0FB2h ;# 
# 4630 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3H equ 0FB3h ;# 
# 4637 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CMCON equ 0FB4h ;# 
# 4727 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CVRCON equ 0FB5h ;# 
# 4812 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ECCP1AS equ 0FB6h ;# 
# 4817 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1AS equ 0FB6h ;# 
# 4942 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ECCP1DEL equ 0FB7h ;# 
# 4947 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1DEL equ 0FB7h ;# 
# 4982 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BAUDCON equ 0FB8h ;# 
# 4987 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BAUDCTL equ 0FB8h ;# 
# 5162 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP2CON equ 0FBAh ;# 
# 5226 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2 equ 0FBBh ;# 
# 5233 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2L equ 0FBBh ;# 
# 5240 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2H equ 0FBCh ;# 
# 5247 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1CON equ 0FBDh ;# 
# 5311 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1 equ 0FBEh ;# 
# 5318 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1L equ 0FBEh ;# 
# 5325 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1H equ 0FBFh ;# 
# 5332 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON2 equ 0FC0h ;# 
# 5403 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON1 equ 0FC1h ;# 
# 5488 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON0 equ 0FC2h ;# 
# 5607 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRES equ 0FC3h ;# 
# 5614 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRESL equ 0FC3h ;# 
# 5621 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRESH equ 0FC4h ;# 
# 5628 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPCON2 equ 0FC5h ;# 
# 5690 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPCON1 equ 0FC6h ;# 
# 5760 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPSTAT equ 0FC7h ;# 
# 6008 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPADD equ 0FC8h ;# 
# 6015 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPBUF equ 0FC9h ;# 
# 6022 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T2CON equ 0FCAh ;# 
# 6120 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PR2 equ 0FCBh ;# 
# 6125 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
MEMCON equ 0FCBh ;# 
# 6230 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR2 equ 0FCCh ;# 
# 6237 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T1CON equ 0FCDh ;# 
# 6340 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1 equ 0FCEh ;# 
# 6347 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1L equ 0FCEh ;# 
# 6354 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1H equ 0FCFh ;# 
# 6361 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCON equ 0FD0h ;# 
# 6510 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
WDTCON equ 0FD1h ;# 
# 6538 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
HLVDCON equ 0FD2h ;# 
# 6543 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LVDCON equ 0FD2h ;# 
# 6808 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
OSCCON equ 0FD3h ;# 
# 6891 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T0CON equ 0FD5h ;# 
# 6961 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0 equ 0FD6h ;# 
# 6968 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0L equ 0FD6h ;# 
# 6975 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0H equ 0FD7h ;# 
# 6982 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
STATUS equ 0FD8h ;# 
# 7053 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2 equ 0FD9h ;# 
# 7060 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2L equ 0FD9h ;# 
# 7067 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2H equ 0FDAh ;# 
# 7074 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW2 equ 0FDBh ;# 
# 7081 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC2 equ 0FDCh ;# 
# 7088 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC2 equ 0FDDh ;# 
# 7095 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC2 equ 0FDEh ;# 
# 7102 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF2 equ 0FDFh ;# 
# 7109 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BSR equ 0FE0h ;# 
# 7116 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1 equ 0FE1h ;# 
# 7123 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1L equ 0FE1h ;# 
# 7130 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1H equ 0FE2h ;# 
# 7137 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW1 equ 0FE3h ;# 
# 7144 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC1 equ 0FE4h ;# 
# 7151 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC1 equ 0FE5h ;# 
# 7158 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC1 equ 0FE6h ;# 
# 7165 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF1 equ 0FE7h ;# 
# 7172 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
WREG equ 0FE8h ;# 
# 7179 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0 equ 0FE9h ;# 
# 7186 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0L equ 0FE9h ;# 
# 7193 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0H equ 0FEAh ;# 
# 7200 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW0 equ 0FEBh ;# 
# 7207 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC0 equ 0FECh ;# 
# 7214 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC0 equ 0FEDh ;# 
# 7221 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC0 equ 0FEEh ;# 
# 7228 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF0 equ 0FEFh ;# 
# 7235 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON3 equ 0FF0h ;# 
# 7327 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON2 equ 0FF1h ;# 
# 7404 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON equ 0FF2h ;# 
# 7521 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PROD equ 0FF3h ;# 
# 7528 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PRODL equ 0FF3h ;# 
# 7535 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PRODH equ 0FF4h ;# 
# 7542 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TABLAT equ 0FF5h ;# 
# 7551 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTR equ 0FF6h ;# 
# 7558 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRL equ 0FF6h ;# 
# 7565 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRH equ 0FF7h ;# 
# 7572 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRU equ 0FF8h ;# 
# 7581 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLAT equ 0FF9h ;# 
# 7588 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PC equ 0FF9h ;# 
# 7595 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCL equ 0FF9h ;# 
# 7602 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLATH equ 0FFAh ;# 
# 7609 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLATU equ 0FFBh ;# 
# 7616 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
STKPTR equ 0FFCh ;# 
# 7692 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOS equ 0FFDh ;# 
# 7699 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSL equ 0FFDh ;# 
# 7706 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSH equ 0FFEh ;# 
# 7713 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSU equ 0FFFh ;# 
# 55 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRM equ 0F66h ;# 
# 62 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRML equ 0F66h ;# 
# 140 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRMH equ 0F67h ;# 
# 180 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UIR equ 0F68h ;# 
# 236 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UIE equ 0F69h ;# 
# 292 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEIR equ 0F6Ah ;# 
# 343 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEIE equ 0F6Bh ;# 
# 394 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
USTAT equ 0F6Ch ;# 
# 454 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UCON equ 0F6Dh ;# 
# 505 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UADDR equ 0F6Eh ;# 
# 569 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UCFG equ 0F6Fh ;# 
# 648 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP0 equ 0F70h ;# 
# 756 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP1 equ 0F71h ;# 
# 864 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP2 equ 0F72h ;# 
# 972 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP3 equ 0F73h ;# 
# 1080 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP4 equ 0F74h ;# 
# 1188 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP5 equ 0F75h ;# 
# 1296 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP6 equ 0F76h ;# 
# 1404 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP7 equ 0F77h ;# 
# 1512 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP8 equ 0F78h ;# 
# 1588 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP9 equ 0F79h ;# 
# 1664 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP10 equ 0F7Ah ;# 
# 1740 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP11 equ 0F7Bh ;# 
# 1816 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP12 equ 0F7Ch ;# 
# 1892 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP13 equ 0F7Dh ;# 
# 1968 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP14 equ 0F7Eh ;# 
# 2044 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP15 equ 0F7Fh ;# 
# 2120 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTA equ 0F80h ;# 
# 2259 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTB equ 0F81h ;# 
# 2369 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTC equ 0F82h ;# 
# 2511 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTE equ 0F84h ;# 
# 2550 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATA equ 0F89h ;# 
# 2650 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATB equ 0F8Ah ;# 
# 2762 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATC equ 0F8Bh ;# 
# 2840 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISA equ 0F92h ;# 
# 2845 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRA equ 0F92h ;# 
# 3038 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISB equ 0F93h ;# 
# 3043 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRB equ 0F93h ;# 
# 3260 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISC equ 0F94h ;# 
# 3265 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRC equ 0F94h ;# 
# 3414 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
OSCTUNE equ 0F9Bh ;# 
# 3473 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIE1 equ 0F9Dh ;# 
# 3544 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIR1 equ 0F9Eh ;# 
# 3615 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
IPR1 equ 0F9Fh ;# 
# 3686 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIE2 equ 0FA0h ;# 
# 3757 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIR2 equ 0FA1h ;# 
# 3828 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
IPR2 equ 0FA2h ;# 
# 3899 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EECON1 equ 0FA6h ;# 
# 3965 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EECON2 equ 0FA7h ;# 
# 3972 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EEDATA equ 0FA8h ;# 
# 3979 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EEADR equ 0FA9h ;# 
# 3986 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCSTA equ 0FABh ;# 
# 3991 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCSTA1 equ 0FABh ;# 
# 4196 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXSTA equ 0FACh ;# 
# 4201 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXSTA1 equ 0FACh ;# 
# 4452 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXREG equ 0FADh ;# 
# 4457 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXREG1 equ 0FADh ;# 
# 4464 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCREG equ 0FAEh ;# 
# 4469 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCREG1 equ 0FAEh ;# 
# 4476 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRG equ 0FAFh ;# 
# 4481 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRG1 equ 0FAFh ;# 
# 4488 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRGH equ 0FB0h ;# 
# 4495 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T3CON equ 0FB1h ;# 
# 4616 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3 equ 0FB2h ;# 
# 4623 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3L equ 0FB2h ;# 
# 4630 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3H equ 0FB3h ;# 
# 4637 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CMCON equ 0FB4h ;# 
# 4727 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CVRCON equ 0FB5h ;# 
# 4812 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ECCP1AS equ 0FB6h ;# 
# 4817 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1AS equ 0FB6h ;# 
# 4942 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ECCP1DEL equ 0FB7h ;# 
# 4947 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1DEL equ 0FB7h ;# 
# 4982 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BAUDCON equ 0FB8h ;# 
# 4987 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BAUDCTL equ 0FB8h ;# 
# 5162 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP2CON equ 0FBAh ;# 
# 5226 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2 equ 0FBBh ;# 
# 5233 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2L equ 0FBBh ;# 
# 5240 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2H equ 0FBCh ;# 
# 5247 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1CON equ 0FBDh ;# 
# 5311 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1 equ 0FBEh ;# 
# 5318 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1L equ 0FBEh ;# 
# 5325 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1H equ 0FBFh ;# 
# 5332 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON2 equ 0FC0h ;# 
# 5403 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON1 equ 0FC1h ;# 
# 5488 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON0 equ 0FC2h ;# 
# 5607 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRES equ 0FC3h ;# 
# 5614 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRESL equ 0FC3h ;# 
# 5621 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRESH equ 0FC4h ;# 
# 5628 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPCON2 equ 0FC5h ;# 
# 5690 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPCON1 equ 0FC6h ;# 
# 5760 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPSTAT equ 0FC7h ;# 
# 6008 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPADD equ 0FC8h ;# 
# 6015 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPBUF equ 0FC9h ;# 
# 6022 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T2CON equ 0FCAh ;# 
# 6120 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PR2 equ 0FCBh ;# 
# 6125 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
MEMCON equ 0FCBh ;# 
# 6230 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR2 equ 0FCCh ;# 
# 6237 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T1CON equ 0FCDh ;# 
# 6340 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1 equ 0FCEh ;# 
# 6347 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1L equ 0FCEh ;# 
# 6354 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1H equ 0FCFh ;# 
# 6361 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCON equ 0FD0h ;# 
# 6510 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
WDTCON equ 0FD1h ;# 
# 6538 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
HLVDCON equ 0FD2h ;# 
# 6543 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LVDCON equ 0FD2h ;# 
# 6808 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
OSCCON equ 0FD3h ;# 
# 6891 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T0CON equ 0FD5h ;# 
# 6961 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0 equ 0FD6h ;# 
# 6968 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0L equ 0FD6h ;# 
# 6975 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0H equ 0FD7h ;# 
# 6982 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
STATUS equ 0FD8h ;# 
# 7053 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2 equ 0FD9h ;# 
# 7060 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2L equ 0FD9h ;# 
# 7067 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2H equ 0FDAh ;# 
# 7074 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW2 equ 0FDBh ;# 
# 7081 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC2 equ 0FDCh ;# 
# 7088 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC2 equ 0FDDh ;# 
# 7095 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC2 equ 0FDEh ;# 
# 7102 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF2 equ 0FDFh ;# 
# 7109 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BSR equ 0FE0h ;# 
# 7116 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1 equ 0FE1h ;# 
# 7123 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1L equ 0FE1h ;# 
# 7130 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1H equ 0FE2h ;# 
# 7137 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW1 equ 0FE3h ;# 
# 7144 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC1 equ 0FE4h ;# 
# 7151 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC1 equ 0FE5h ;# 
# 7158 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC1 equ 0FE6h ;# 
# 7165 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF1 equ 0FE7h ;# 
# 7172 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
WREG equ 0FE8h ;# 
# 7179 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0 equ 0FE9h ;# 
# 7186 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0L equ 0FE9h ;# 
# 7193 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0H equ 0FEAh ;# 
# 7200 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW0 equ 0FEBh ;# 
# 7207 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC0 equ 0FECh ;# 
# 7214 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC0 equ 0FEDh ;# 
# 7221 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC0 equ 0FEEh ;# 
# 7228 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF0 equ 0FEFh ;# 
# 7235 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON3 equ 0FF0h ;# 
# 7327 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON2 equ 0FF1h ;# 
# 7404 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON equ 0FF2h ;# 
# 7521 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PROD equ 0FF3h ;# 
# 7528 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PRODL equ 0FF3h ;# 
# 7535 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PRODH equ 0FF4h ;# 
# 7542 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TABLAT equ 0FF5h ;# 
# 7551 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTR equ 0FF6h ;# 
# 7558 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRL equ 0FF6h ;# 
# 7565 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRH equ 0FF7h ;# 
# 7572 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRU equ 0FF8h ;# 
# 7581 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLAT equ 0FF9h ;# 
# 7588 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PC equ 0FF9h ;# 
# 7595 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCL equ 0FF9h ;# 
# 7602 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLATH equ 0FFAh ;# 
# 7609 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLATU equ 0FFBh ;# 
# 7616 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
STKPTR equ 0FFCh ;# 
# 7692 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOS equ 0FFDh ;# 
# 7699 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSL equ 0FFDh ;# 
# 7706 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSH equ 0FFEh ;# 
# 7713 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSU equ 0FFFh ;# 
# 55 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRM equ 0F66h ;# 
# 62 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRML equ 0F66h ;# 
# 140 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UFRMH equ 0F67h ;# 
# 180 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UIR equ 0F68h ;# 
# 236 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UIE equ 0F69h ;# 
# 292 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEIR equ 0F6Ah ;# 
# 343 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEIE equ 0F6Bh ;# 
# 394 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
USTAT equ 0F6Ch ;# 
# 454 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UCON equ 0F6Dh ;# 
# 505 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UADDR equ 0F6Eh ;# 
# 569 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UCFG equ 0F6Fh ;# 
# 648 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP0 equ 0F70h ;# 
# 756 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP1 equ 0F71h ;# 
# 864 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP2 equ 0F72h ;# 
# 972 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP3 equ 0F73h ;# 
# 1080 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP4 equ 0F74h ;# 
# 1188 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP5 equ 0F75h ;# 
# 1296 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP6 equ 0F76h ;# 
# 1404 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP7 equ 0F77h ;# 
# 1512 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP8 equ 0F78h ;# 
# 1588 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP9 equ 0F79h ;# 
# 1664 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP10 equ 0F7Ah ;# 
# 1740 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP11 equ 0F7Bh ;# 
# 1816 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP12 equ 0F7Ch ;# 
# 1892 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP13 equ 0F7Dh ;# 
# 1968 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP14 equ 0F7Eh ;# 
# 2044 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
UEP15 equ 0F7Fh ;# 
# 2120 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTA equ 0F80h ;# 
# 2259 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTB equ 0F81h ;# 
# 2369 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTC equ 0F82h ;# 
# 2511 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PORTE equ 0F84h ;# 
# 2550 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATA equ 0F89h ;# 
# 2650 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATB equ 0F8Ah ;# 
# 2762 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LATC equ 0F8Bh ;# 
# 2840 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISA equ 0F92h ;# 
# 2845 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRA equ 0F92h ;# 
# 3038 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISB equ 0F93h ;# 
# 3043 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRB equ 0F93h ;# 
# 3260 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TRISC equ 0F94h ;# 
# 3265 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
DDRC equ 0F94h ;# 
# 3414 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
OSCTUNE equ 0F9Bh ;# 
# 3473 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIE1 equ 0F9Dh ;# 
# 3544 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIR1 equ 0F9Eh ;# 
# 3615 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
IPR1 equ 0F9Fh ;# 
# 3686 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIE2 equ 0FA0h ;# 
# 3757 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PIR2 equ 0FA1h ;# 
# 3828 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
IPR2 equ 0FA2h ;# 
# 3899 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EECON1 equ 0FA6h ;# 
# 3965 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EECON2 equ 0FA7h ;# 
# 3972 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EEDATA equ 0FA8h ;# 
# 3979 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
EEADR equ 0FA9h ;# 
# 3986 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCSTA equ 0FABh ;# 
# 3991 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCSTA1 equ 0FABh ;# 
# 4196 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXSTA equ 0FACh ;# 
# 4201 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXSTA1 equ 0FACh ;# 
# 4452 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXREG equ 0FADh ;# 
# 4457 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TXREG1 equ 0FADh ;# 
# 4464 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCREG equ 0FAEh ;# 
# 4469 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCREG1 equ 0FAEh ;# 
# 4476 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRG equ 0FAFh ;# 
# 4481 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRG1 equ 0FAFh ;# 
# 4488 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SPBRGH equ 0FB0h ;# 
# 4495 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T3CON equ 0FB1h ;# 
# 4616 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3 equ 0FB2h ;# 
# 4623 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3L equ 0FB2h ;# 
# 4630 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR3H equ 0FB3h ;# 
# 4637 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CMCON equ 0FB4h ;# 
# 4727 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CVRCON equ 0FB5h ;# 
# 4812 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ECCP1AS equ 0FB6h ;# 
# 4817 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1AS equ 0FB6h ;# 
# 4942 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ECCP1DEL equ 0FB7h ;# 
# 4947 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1DEL equ 0FB7h ;# 
# 4982 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BAUDCON equ 0FB8h ;# 
# 4987 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BAUDCTL equ 0FB8h ;# 
# 5162 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP2CON equ 0FBAh ;# 
# 5226 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2 equ 0FBBh ;# 
# 5233 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2L equ 0FBBh ;# 
# 5240 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR2H equ 0FBCh ;# 
# 5247 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCP1CON equ 0FBDh ;# 
# 5311 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1 equ 0FBEh ;# 
# 5318 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1L equ 0FBEh ;# 
# 5325 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
CCPR1H equ 0FBFh ;# 
# 5332 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON2 equ 0FC0h ;# 
# 5403 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON1 equ 0FC1h ;# 
# 5488 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADCON0 equ 0FC2h ;# 
# 5607 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRES equ 0FC3h ;# 
# 5614 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRESL equ 0FC3h ;# 
# 5621 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
ADRESH equ 0FC4h ;# 
# 5628 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPCON2 equ 0FC5h ;# 
# 5690 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPCON1 equ 0FC6h ;# 
# 5760 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPSTAT equ 0FC7h ;# 
# 6008 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPADD equ 0FC8h ;# 
# 6015 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
SSPBUF equ 0FC9h ;# 
# 6022 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T2CON equ 0FCAh ;# 
# 6120 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PR2 equ 0FCBh ;# 
# 6125 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
MEMCON equ 0FCBh ;# 
# 6230 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR2 equ 0FCCh ;# 
# 6237 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T1CON equ 0FCDh ;# 
# 6340 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1 equ 0FCEh ;# 
# 6347 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1L equ 0FCEh ;# 
# 6354 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR1H equ 0FCFh ;# 
# 6361 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
RCON equ 0FD0h ;# 
# 6510 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
WDTCON equ 0FD1h ;# 
# 6538 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
HLVDCON equ 0FD2h ;# 
# 6543 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
LVDCON equ 0FD2h ;# 
# 6808 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
OSCCON equ 0FD3h ;# 
# 6891 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
T0CON equ 0FD5h ;# 
# 6961 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0 equ 0FD6h ;# 
# 6968 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0L equ 0FD6h ;# 
# 6975 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TMR0H equ 0FD7h ;# 
# 6982 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
STATUS equ 0FD8h ;# 
# 7053 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2 equ 0FD9h ;# 
# 7060 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2L equ 0FD9h ;# 
# 7067 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR2H equ 0FDAh ;# 
# 7074 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW2 equ 0FDBh ;# 
# 7081 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC2 equ 0FDCh ;# 
# 7088 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC2 equ 0FDDh ;# 
# 7095 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC2 equ 0FDEh ;# 
# 7102 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF2 equ 0FDFh ;# 
# 7109 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
BSR equ 0FE0h ;# 
# 7116 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1 equ 0FE1h ;# 
# 7123 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1L equ 0FE1h ;# 
# 7130 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR1H equ 0FE2h ;# 
# 7137 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW1 equ 0FE3h ;# 
# 7144 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC1 equ 0FE4h ;# 
# 7151 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC1 equ 0FE5h ;# 
# 7158 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC1 equ 0FE6h ;# 
# 7165 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF1 equ 0FE7h ;# 
# 7172 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
WREG equ 0FE8h ;# 
# 7179 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0 equ 0FE9h ;# 
# 7186 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0L equ 0FE9h ;# 
# 7193 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
FSR0H equ 0FEAh ;# 
# 7200 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PLUSW0 equ 0FEBh ;# 
# 7207 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PREINC0 equ 0FECh ;# 
# 7214 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTDEC0 equ 0FEDh ;# 
# 7221 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
POSTINC0 equ 0FEEh ;# 
# 7228 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INDF0 equ 0FEFh ;# 
# 7235 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON3 equ 0FF0h ;# 
# 7327 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON2 equ 0FF1h ;# 
# 7404 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
INTCON equ 0FF2h ;# 
# 7521 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PROD equ 0FF3h ;# 
# 7528 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PRODL equ 0FF3h ;# 
# 7535 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PRODH equ 0FF4h ;# 
# 7542 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TABLAT equ 0FF5h ;# 
# 7551 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTR equ 0FF6h ;# 
# 7558 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRL equ 0FF6h ;# 
# 7565 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRH equ 0FF7h ;# 
# 7572 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TBLPTRU equ 0FF8h ;# 
# 7581 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLAT equ 0FF9h ;# 
# 7588 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PC equ 0FF9h ;# 
# 7595 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCL equ 0FF9h ;# 
# 7602 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLATH equ 0FFAh ;# 
# 7609 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
PCLATU equ 0FFBh ;# 
# 7616 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
STKPTR equ 0FFCh ;# 
# 7692 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOS equ 0FFDh ;# 
# 7699 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSL equ 0FFDh ;# 
# 7706 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSH equ 0FFEh ;# 
# 7713 "C:\Program Files\Microchip\xc8\v2.36\pic\include\proc\pic18f2550.h"
TOSU equ 0FFFh ;# 
	debug_source C
	FNCALL	_main,_ADC_init
	FNCALL	_main,_I2C_Master_Init
	FNCALL	_main,_INT_init
	FNCALL	_main,_UART_init_baud
	FNCALL	_main,_executeTaskAlarm
	FNCALL	_main,_executeTaskAnalizaUart1
	FNCALL	_main,_executeTaskAplicacion
	FNCALL	_main,_executeTaskBuzzer
	FNCALL	_main,_executeTaskCluster
	FNCALL	_main,_executeTaskLedLive
	FNCALL	_main,_pinConfBuzzer
	FNCALL	_main,_pinConfCluster
	FNCALL	_main,_pinConfLedPin
	FNCALL	_main,_startTaskAlarm
	FNCALL	_main,_startTaskAnalizaUart1
	FNCALL	_main,_startTaskAplicacion
	FNCALL	_main,_startTaskBuzzer
	FNCALL	_main,_startTaskCluster
	FNCALL	_main,_startTaskLedLive
	FNCALL	_executeTaskLedLive,_taskLedLive
	FNCALL	_taskLedLive,_getMillis
	FNCALL	_executeTaskCluster,_taskCluster
	FNCALL	_taskCluster,_getMillis
	FNCALL	_taskCluster,_oneBeep
	FNCALL	_executeTaskBuzzer,_taskBuzzer
	FNCALL	_taskBuzzer,_getMillis
	FNCALL	_executeTaskAplicacion,_taskAplicacion
	FNCALL	_taskAplicacion,_ADC_read
	FNCALL	_taskAplicacion,_EEpromRead
	FNCALL	_taskAplicacion,_EEpromWrite
	FNCALL	_taskAplicacion,___fladd
	FNCALL	_taskAplicacion,___flmul
	FNCALL	_taskAplicacion,___xxtofl
	FNCALL	_taskAplicacion,_cambiarEstado
	FNCALL	_taskAplicacion,_getMillis
	FNCALL	_taskAplicacion,_inicioEstado
	FNCALL	_taskAplicacion,_oneBeep
	FNCALL	_taskAplicacion,_readDevide
	FNCALL	_taskAplicacion,_readMemoriaValues
	FNCALL	_taskAplicacion,_reiniciarTemporizador
	FNCALL	_taskAplicacion,_transmitUart1
	FNCALL	_taskAplicacion,_twoBeep
	FNCALL	_readMemoriaValues,_EEpromRead
	FNCALL	_readDevide,_cleanBuffer
	FNCALL	_readDevide,_convOnOff
	FNCALL	_readDevide,_convStringDayWeek
	FNCALL	_readDevide,_sprintf
	FNCALL	_readDevide,_transmitUart1
	FNCALL	_transmitUart1,_memcpy
	FNCALL	_transmitUart1,_memset
	FNCALL	_transmitUart1,_strlen
	FNCALL	_convStringDayWeek,_memset
	FNCALL	_convStringDayWeek,_sprintf
	FNCALL	_convStringDayWeek,_strlen
	FNCALL	_convOnOff,_memset
	FNCALL	_convOnOff,_sprintf
	FNCALL	_convOnOff,_strlen
	FNCALL	_sprintf,_vfprintf
	FNCALL	_vfprintf,_vfpfcnvrt
	FNCALL	_vfpfcnvrt,_dtoa
	FNCALL	_vfpfcnvrt,_fputc
	FNCALL	_vfpfcnvrt,_stoa
	FNCALL	_vfpfcnvrt,_strncmp
	FNCALL	_stoa,_fputc
	FNCALL	_stoa,_strlen
	FNCALL	_dtoa,___aodiv
	FNCALL	_dtoa,___aomod
	FNCALL	_dtoa,_abs
	FNCALL	_dtoa,_pad
	FNCALL	_pad,_fputc
	FNCALL	_pad,_fputs
	FNCALL	_pad,_strlen
	FNCALL	_fputs,_fputc
	FNCALL	_fputc,_putch
	FNCALL	_putch,_UART_write
	FNCALL	_cleanBuffer,_memset
	FNCALL	_cleanBuffer,_strlen
	FNCALL	_executeTaskAnalizaUart1,_taskAnalizaUart1
	FNCALL	_taskAnalizaUart1,_EEpromWrite
	FNCALL	_taskAnalizaUart1,_atoi
	FNCALL	_taskAnalizaUart1,_escribirRTC
	FNCALL	_taskAnalizaUart1,_extraerCalendar
	FNCALL	_taskAnalizaUart1,_extraerFrame
	FNCALL	_taskAnalizaUart1,_extraerHora
	FNCALL	_taskAnalizaUart1,_extraerValue
	FNCALL	_taskAnalizaUart1,_getMillis
	FNCALL	_taskAnalizaUart1,_memset
	FNCALL	_taskAnalizaUart1,_strstr
	FNCALL	_extraerValue,_atoi
	FNCALL	_extraerValue,_memset
	FNCALL	_extraerValue,_strstr
	FNCALL	_extraerHora,_atoi
	FNCALL	_extraerHora,_memset
	FNCALL	_extraerFrame,_memcpy
	FNCALL	_extraerFrame,_memset
	FNCALL	_extraerFrame,_strlen
	FNCALL	_extraerFrame,_strstr
	FNCALL	_strstr,_strchr
	FNCALL	_strstr,_strlen
	FNCALL	_strstr,_strncmp
	FNCALL	_extraerCalendar,_atoi
	FNCALL	_extraerCalendar,_memset
	FNCALL	_atoi,___wmul
	FNCALL	_atoi,_isdigit
	FNCALL	_atoi,_isspace
	FNCALL	_escribirRTC,_Decimal_a_BCD
	FNCALL	_escribirRTC,_I2C_Master_Write
	FNCALL	_escribirRTC,_I2C_Start
	FNCALL	_escribirRTC,_I2C_Stop
	FNCALL	_Decimal_a_BCD,___lbdiv
	FNCALL	_Decimal_a_BCD,___lbmod
	FNCALL	_executeTaskAlarm,_taskAlarm
	FNCALL	_taskAlarm,_getMillis
	FNCALL	_taskAlarm,_leerRTC
	FNCALL	_taskAlarm,_leerRtcSeg
	FNCALL	_leerRtcSeg,_BCD_a_Decimal
	FNCALL	_leerRtcSeg,_I2C_Master_Read
	FNCALL	_leerRtcSeg,_I2C_Master_Write
	FNCALL	_leerRtcSeg,_I2C_Repeated_Start
	FNCALL	_leerRtcSeg,_I2C_Start
	FNCALL	_leerRtcSeg,_I2C_Stop
	FNCALL	_leerRTC,_BCD_a_Decimal
	FNCALL	_leerRTC,_I2C_Master_Read
	FNCALL	_leerRTC,_I2C_Master_Write
	FNCALL	_leerRTC,_I2C_Repeated_Start
	FNCALL	_leerRTC,_I2C_Start
	FNCALL	_leerRTC,_I2C_Stop
	FNCALL	_I2C_Stop,_I2C_Master_Wait
	FNCALL	_I2C_Start,_I2C_Master_Wait
	FNCALL	_I2C_Repeated_Start,_I2C_Master_Wait
	FNCALL	_I2C_Master_Write,_I2C_Master_Wait
	FNCALL	_I2C_Master_Read,_I2C_Master_Wait
	FNCALL	_I2C_Master_Init,___fladd
	FNCALL	_I2C_Master_Init,___fldiv
	FNCALL	_I2C_Master_Init,___flmul
	FNCALL	_I2C_Master_Init,___fltol
	FNCALL	_I2C_Master_Init,___xxtofl
	FNROOT	_main
	FNCALL	_INT_ISR_LOW,_printf
	FNCALL	_printf,i1_vfprintf
	FNCALL	i1_vfprintf,i1_vfpfcnvrt
	FNCALL	i1_vfpfcnvrt,i1_dtoa
	FNCALL	i1_vfpfcnvrt,i1_fputc
	FNCALL	i1_vfpfcnvrt,i1_stoa
	FNCALL	i1_vfpfcnvrt,i1_strncmp
	FNCALL	i1_stoa,i1_fputc
	FNCALL	i1_stoa,i1_strlen
	FNCALL	i1_dtoa,i1___aodiv
	FNCALL	i1_dtoa,i1___aomod
	FNCALL	i1_dtoa,i1_abs
	FNCALL	i1_dtoa,i1_pad
	FNCALL	i1_pad,i1_fputc
	FNCALL	i1_pad,i1_fputs
	FNCALL	i1_pad,i1_strlen
	FNCALL	i1_fputs,i1_fputc
	FNCALL	i1_fputc,i1_putch
	FNCALL	i1_putch,i1_UART_write
	FNCALL	intlevel1,_INT_ISR_LOW
	global	intlevel1
	FNROOT	intlevel1
	FNCALL	_INT_isr,_UART_read
	FNCALL	_INT_isr,_receiverUart1
	FNCALL	intlevel2,_INT_isr
	global	intlevel2
	FNROOT	intlevel2
	global	stoa@F1150
psect	idataBANK1,class=CODE,space=0,delta=1,noexec
global __pidataBANK1
__pidataBANK1:
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
	line	570

;initializer for stoa@F1150
	db	low(028h)
	db	low(06Eh)
	db	low(075h)
	db	low(06Ch)
	db	low(06Ch)
	db	low(029h)
	db	low(0)
	global	escribirRTC@F2916
psect	mediumconst,class=MEDIUMCONST,space=0,reloc=2,noexec
global __pmediumconst
__pmediumconst:
	db	0
	file	"DS1307.c"
	line	65
escribirRTC@F2916:
	db	low(0)
	db	low(0)
	db	low(0)
	db	low(0)
	db	low(0)
	db	low(0)
	db	low(0)
	global __end_ofescribirRTC@F2916
__end_ofescribirRTC@F2916:
	global	escribirRTC@F2914
psect	mediumconst
	file	"DS1307.c"
	line	62
escribirRTC@F2914:
	db	low(02h)
	db	low(01h)
	db	low(0)
	db	low(04h)
	db	low(05h)
	db	low(06h)
	db	low(03h)
	global __end_ofescribirRTC@F2914
__end_ofescribirRTC@F2914:
	global	leerRTC@F2903
psect	mediumconst
	file	"DS1307.c"
	line	35
leerRTC@F2903:
	db	low(0)
	db	low(01h)
	db	low(02h)
	db	low(04h)
	db	low(05h)
	db	low(06h)
	db	low(03h)
	global __end_ofleerRTC@F2903
__end_ofleerRTC@F2903:
	global	escribirRTC@F2916
	global	escribirRTC@F2914
	global	leerRTC@F2903
	global	_flagStartBuzzer
	global	_width
	global	_prec
	global	_flags
	global	_stateAnaTrama1
	global	_flagInitStLed
	global	_state_ledLive
	global	_stateCluster
	global	_ucIteradorBuzzer
	global	_ucCntTimeBuzzer
	global	_ucTypeBeep
	global	_stateBuzzer
	global	_stateAp
	global	_stateAlarm
	global	_rtc
	global	_memo
	global	_ala5
	global	_ala4
	global	_ala3
	global	_ala2
	global	_ala1
	global	_ala
	global	_cl
	global	_ulCntTick1ms
	global	_ulCntPeriodCluster
	global	_ulCntPeriodAnaUart1
	global	_ulCntPeriodBuzzer
	global	_ulCntPeriodAlarm
	global	_ulCntPeriodAplicacion
	global	_ulCntPeriodLedLive
	global	_nout
	global	_uiCntLedLive
	global	_anaT1
	global	_ptTaskAnalizaUart1
	global	_ptTaskLedLive
	global	_ptTaskCluster
	global	_ptTaskBuzzer
	global	_ptTaskAplicacion
	global	_ptTaskAlarm
	global	_ap
	global	_serial1
	global	_dbuf
	global	_SSPCON2
_SSPCON2	set	0xFC5
	global	_SSPCON1bits
_SSPCON1bits	set	0xFC6
	global	_SSPSTATbits
_SSPSTATbits	set	0xFC7
	global	_EECON2
_EECON2	set	0xFA7
	global	_ADRESL
_ADRESL	set	0xFC3
	global	_ADRESH
_ADRESH	set	0xFC4
	global	_ADCON0bits
_ADCON0bits	set	0xFC2
	global	_RCONbits
_RCONbits	set	0xFD0
	global	_TXREG
_TXREG	set	0xFAD
	global	_RCREG
_RCREG	set	0xFAE
	global	_SPBRG
_SPBRG	set	0xFAF
	global	_SSPCON2bits
_SSPCON2bits	set	0xFC5
	global	_SSPSTAT
_SSPSTAT	set	0xFC7
	global	_ADCON1bits
_ADCON1bits	set	0xFC1
	global	_LATAbits
_LATAbits	set	0xF89
	global	_LATCbits
_LATCbits	set	0xF8B
	global	_TRISCbits
_TRISCbits	set	0xF94
	global	_PIE1bits
_PIE1bits	set	0xF9D
	global	_RCSTAbits
_RCSTAbits	set	0xFAB
	global	_TXSTAbits
_TXSTAbits	set	0xFAC
	global	_TMR0
_TMR0	set	0xFD6
	global	_ADCON2bits
_ADCON2bits	set	0xFC0
	global	_ADCON1
_ADCON1	set	0xFC1
	global	_INTCONbits
_INTCONbits	set	0xFF2
	global	_PIR2bits
_PIR2bits	set	0xFA1
	global	_EECON1bits
_EECON1bits	set	0xFA6
	global	_EEDATA
_EEDATA	set	0xFA8
	global	_EEADR
_EEADR	set	0xFA9
	global	_PIR1bits
_PIR1bits	set	0xF9E
	global	_INTCON3bits
_INTCON3bits	set	0xFF0
	global	_T0CON
_T0CON	set	0xFD5
	global	_TRISAbits
_TRISAbits	set	0xF92
	global	_TRISBbits
_TRISBbits	set	0xF93
	global	_SSPBUF
_SSPBUF	set	0xFC9
	global	_SSPADD
_SSPADD	set	0xFC8
	
STR_6:
	db	78	;'N'
	db	111	;'o'
	db	32
	db	45
	db	32
	db	32
	db	32
	db	32
	db	73	;'I'
	db	110	;'n'
	db	105	;'i'
	db	32
	db	32
	db	32
	db	32
	db	45
	db	32
	db	32
	db	32
	db	70	;'F'
	db	105	;'i'
	db	110	;'n'
	db	32
	db	32
	db	32
	db	32
	db	45
	db	32
	db	79	;'O'
	db	110	;'n'
	db	32
	db	45
	db	32
	db	68	;'D'
	db	105	;'i'
	db	97	;'a'
	db	115	;'s'
	db	32
	db	10
	db	13
	db	10
	db	13
	db	0
	
STR_11:
	db	32
	db	53	;'5'
	db	32
	db	32
	db	32
	db	45
	db	32
	db	37
	db	100	;'d'
	db	58	;':'
	db	37
	db	100	;'d'
	db	32
	db	32
	db	32
	db	45
	db	32
	db	37
	db	100	;'d'
	db	58	;':'
	db	37
	db	100	;'d'
	db	32
	db	32
	db	45
	db	32
	db	37
	db	115	;'s'
	db	32
	db	45
	db	32
	db	37
	db	115	;'s'
	db	10
	db	13
	db	10
	db	13
	db	0
	
STR_7:
	db	32
	db	49	;'1'
	db	32
	db	32
	db	32
	db	45
	db	32
	db	37
	db	100	;'d'
	db	58	;':'
	db	37
	db	100	;'d'
	db	32
	db	32
	db	32
	db	45
	db	32
	db	37
	db	100	;'d'
	db	58	;':'
	db	37
	db	100	;'d'
	db	32
	db	32
	db	45
	db	32
	db	37
	db	115	;'s'
	db	32
	db	45
	db	32
	db	37
	db	115	;'s'
	db	10
	db	13
	db	0
	
STR_8:
	db	32
	db	50	;'2'
	db	32
	db	32
	db	32
	db	45
	db	32
	db	37
	db	100	;'d'
	db	58	;':'
	db	37
	db	100	;'d'
	db	32
	db	32
	db	32
	db	45
	db	32
	db	37
	db	100	;'d'
	db	58	;':'
	db	37
	db	100	;'d'
	db	32
	db	32
	db	45
	db	32
	db	37
	db	115	;'s'
	db	32
	db	45
	db	32
	db	37
	db	115	;'s'
	db	10
	db	13
	db	0
	
STR_9:
	db	32
	db	51	;'3'
	db	32
	db	32
	db	32
	db	45
	db	32
	db	37
	db	100	;'d'
	db	58	;':'
	db	37
	db	100	;'d'
	db	32
	db	32
	db	32
	db	45
	db	32
	db	37
	db	100	;'d'
	db	58	;':'
	db	37
	db	100	;'d'
	db	32
	db	32
	db	45
	db	32
	db	37
	db	115	;'s'
	db	32
	db	45
	db	32
	db	37
	db	115	;'s'
	db	10
	db	13
	db	0
	
STR_10:
	db	32
	db	52	;'4'
	db	32
	db	32
	db	32
	db	45
	db	32
	db	37
	db	100	;'d'
	db	58	;':'
	db	37
	db	100	;'d'
	db	32
	db	32
	db	32
	db	45
	db	32
	db	37
	db	100	;'d'
	db	58	;':'
	db	37
	db	100	;'d'
	db	32
	db	32
	db	45
	db	32
	db	37
	db	115	;'s'
	db	32
	db	45
	db	32
	db	37
	db	115	;'s'
	db	10
	db	13
	db	0
	
STR_1:
	db	73	;'I'
	db	78	;'N'
	db	73	;'I'
	db	67	;'C'
	db	73	;'I'
	db	79	;'O'
	db	32
	db	73	;'I'
	db	78	;'N'
	db	84	;'T'
	db	69	;'E'
	db	82	;'R'
	db	82	;'R'
	db	85	;'U'
	db	80	;'P'
	db	67	;'C'
	db	73	;'I'
	db	79	;'O'
	db	78	;'N'
	db	32
	db	73	;'I'
	db	78	;'N'
	db	84	;'T'
	db	49	;'1'
	db	13
	db	10
	db	0
	
STR_3:
	db	10
	db	13
	db	66	;'B'
	db	65	;'A'
	db	76	;'L'
	db	73	;'I'
	db	90	;'Z'
	db	65	;'A'
	db	32
	db	65	;'A'
	db	76	;'L'
	db	65	;'A'
	db	82	;'R'
	db	77	;'M'
	db	65	;'A'
	db	32
	db	86	;'V'
	db	49	;'1'
	db	46
	db	48	;'0'
	db	10
	db	13
	db	10
	db	13
	db	0
	
STR_2:
	db	70	;'F'
	db	73	;'I'
	db	78	;'N'
	db	32
	db	73	;'I'
	db	78	;'N'
	db	84	;'T'
	db	69	;'E'
	db	82	;'R'
	db	82	;'R'
	db	85	;'U'
	db	80	;'P'
	db	67	;'C'
	db	73	;'I'
	db	79	;'O'
	db	78	;'N'
	db	32
	db	73	;'I'
	db	78	;'N'
	db	84	;'T'
	db	49	;'1'
	db	13
	db	10
	db	0
	
STR_5:
	db	37
	db	100	;'d'
	db	47
	db	37
	db	100	;'d'
	db	47
	db	37
	db	100	;'d'
	db	45
	db	37
	db	100	;'d'
	db	10
	db	13
	db	10
	db	13
	db	10
	db	13
	db	0
	
STR_4:
	db	37
	db	100	;'d'
	db	58	;':'
	db	37
	db	100	;'d'
	db	58	;':'
	db	37
	db	100	;'d'
	db	10
	db	13
	db	0
	
STR_41:
	db	108	;'l'
	db	108	;'l'
	db	115	;'s'
	db	0
	
STR_16:
	db	79	;'O'
	db	70	;'F'
	db	70	;'F'
	db	0
	
STR_12:
	db	68	;'D'
	db	105	;'i'
	db	97	;'a'
	db	0
	
STR_14:
	db	83	;'S'
	db	68	;'D'
	db	0
	
STR_15:
	db	79	;'O'
	db	78	;'N'
	db	0
	
STR_13:
	db	76	;'L'
	db	86	;'V'
	db	0
	
STR_17:
	db	-65
	db	0
	
STR_24:
	db	44
	db	0
	
STR_26:
	db	63	;'?'
	db	0
	
STR_27:
	db	65	;'A'
	db	0
	
STR_25:
	db	67	;'C'
	db	0
	
STR_31:
	db	69	;'E'
	db	0
	
STR_35:
	db	73	;'I'
	db	0
	
STR_19:
	db	76	;'L'
	db	0
	
STR_21:
	db	82	;'R'
	db	0
STR_42	equ	STR_41+0
STR_43	equ	STR_41+0
STR_44	equ	STR_41+0
STR_45	equ	STR_41+0
STR_22	equ	STR_21+0
STR_23	equ	STR_21+0
STR_20	equ	STR_19+0
STR_37	equ	STR_16+2
STR_32	equ	STR_31+0
STR_33	equ	STR_31+0
STR_39	equ	STR_14+1
STR_28	equ	STR_27+0
STR_29	equ	STR_27+0
STR_30	equ	STR_24+0
STR_34	equ	STR_24+0
STR_36	equ	STR_24+0
STR_38	equ	STR_24+0
STR_40	equ	STR_24+0
STR_18	equ	STR_17+0
; #config settings
	config pad_punits      = on
	config apply_mask      = off
	config ignore_cmsgs    = off
	config default_configs = off
	config default_idlocs  = off
	config PLLDIV = "1"
	config CPUDIV = "OSC1_PLL2"
	config USBDIV = "1"
	config FOSC = "HS"
	config FCMEN = "OFF"
	config IESO = "OFF"
	config PWRT = "ON"
	config BOR = "OFF"
	config BORV = "3"
	config VREGEN = "OFF"
	config WDT = "OFF"
	config WDTPS = "32768"
	config CCP2MX = "ON"
	config PBADEN = "ON"
	config LPT1OSC = "OFF"
	config MCLRE = "ON"
	config STVREN = "ON"
	config LVP = "OFF"
	config XINST = "OFF"
	config CP0 = "OFF"
	config CP1 = "OFF"
	config CP2 = "OFF"
	config CP3 = "OFF"
	config CPB = "OFF"
	config CPD = "OFF"
	config WRT0 = "OFF"
	config WRT1 = "OFF"
	config WRT2 = "OFF"
	config WRT3 = "OFF"
	config WRTC = "OFF"
	config WRTB = "OFF"
	config WRTD = "OFF"
	config EBTR0 = "OFF"
	config EBTR1 = "OFF"
	config EBTR2 = "OFF"
	config EBTR3 = "OFF"
	config EBTRB = "OFF"
	file	"D:\@Proyect\Baliza\1 Firmware\Doc mplabx\build_xc8\main.as"
	line	#
psect	cinit,class=CODE,delta=1,reloc=2
global __pcinit
__pcinit:
global start_initialization
start_initialization:

global __initialization
__initialization:
psect	bssCOMRAM,class=COMRAM,space=1,noexec,lowdata
global __pbssCOMRAM
__pbssCOMRAM:
	global	_flagStartBuzzer
_flagStartBuzzer:
       ds      1
	global	_diaSe
	global	_diaSe
_diaSe:
       ds      1
	global	_ano
	global	_ano
_ano:
       ds      1
	global	_mes
	global	_mes
_mes:
       ds      1
	global	_dia
	global	_dia
_dia:
       ds      1
	global	_seg
	global	_seg
_seg:
       ds      1
	global	_min
	global	_min
_min:
       ds      1
	global	_hor
	global	_hor
_hor:
       ds      1
psect	bssBANK0,class=BANK0,space=1,noexec,lowdata
global __pbssBANK0
__pbssBANK0:
_width:
       ds      2
_prec:
       ds      2
_flags:
       ds      2
	global	_stateAnaTrama1
_stateAnaTrama1:
       ds      1
	global	_flagInitStLed
_flagInitStLed:
       ds      1
	global	_state_ledLive
_state_ledLive:
       ds      1
	global	_stateCluster
_stateCluster:
       ds      1
	global	_ucIteradorBuzzer
_ucIteradorBuzzer:
       ds      1
	global	_ucCntTimeBuzzer
_ucCntTimeBuzzer:
       ds      1
	global	_ucTypeBeep
_ucTypeBeep:
       ds      1
	global	_stateBuzzer
_stateBuzzer:
       ds      1
	global	_stateAp
_stateAp:
       ds      1
	global	_stateAlarm
_stateAlarm:
       ds      1
	global	_rtc
_rtc:
       ds      7
psect	bssBANK1,class=BANK1,space=1,noexec,lowdata
global __pbssBANK1
__pbssBANK1:
	global	_memo
_memo:
       ds      36
	global	_ala5
_ala5:
       ds      14
	global	_ala4
_ala4:
       ds      14
	global	_ala3
_ala3:
       ds      14
	global	_ala2
_ala2:
       ds      14
	global	_ala1
_ala1:
       ds      14
	global	_ala
_ala:
       ds      6
	global	_cl
_cl:
       ds      4
	global	_ulCntTick1ms
_ulCntTick1ms:
       ds      4
	global	_ulCntPeriodCluster
_ulCntPeriodCluster:
       ds      4
	global	_ulCntPeriodAnaUart1
_ulCntPeriodAnaUart1:
       ds      4
	global	_ulCntPeriodBuzzer
_ulCntPeriodBuzzer:
       ds      4
	global	_ulCntPeriodAlarm
_ulCntPeriodAlarm:
       ds      4
	global	_ulCntPeriodAplicacion
_ulCntPeriodAplicacion:
       ds      4
	global	_ulCntPeriodLedLive
_ulCntPeriodLedLive:
       ds      4
_nout:
       ds      2
	global	_uiCntLedLive
_uiCntLedLive:
       ds      2
	global	_anaT1
_anaT1:
       ds      69
_ptTaskAnalizaUart1:
       ds      2
_ptTaskLedLive:
       ds      2
_ptTaskCluster:
       ds      2
_ptTaskBuzzer:
       ds      2
_ptTaskAplicacion:
       ds      2
_ptTaskAlarm:
       ds      2
psect	dataBANK1,class=BANK1,space=1,noexec,lowdata
global __pdataBANK1
__pdataBANK1:
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
	line	570
stoa@F1150:
       ds      7
psect	bssBANK2,class=BANK2,space=1,noexec,lowdata
global __pbssBANK2
__pbssBANK2:
	global	_ap
_ap:
       ds      76
	global	_serial1
_serial1:
       ds      43
_dbuf:
       ds      32
	file	"D:\@Proyect\Baliza\1 Firmware\Doc mplabx\build_xc8\main.as"
	line	#
psect	cinit
; Initialize objects allocated to BANK1 (7 bytes)
	global __pidataBANK1
	; load TBLPTR registers with __pidataBANK1
	movlw	low (__pidataBANK1)
	movwf	tblptrl
	movlw	high(__pidataBANK1)
	movwf	tblptrh
	movlw	low highword(__pidataBANK1)
	movwf	tblptru
	lfsr	0,__pdataBANK1
	lfsr	1,7
	copy_data0:
	tblrd	*+
	movff	tablat, postinc0
	movf	postdec1,w
	movf	fsr1l,w
	bnz	copy_data0
	line	#
; Clear objects allocated to BANK2 (151 bytes)
	global __pbssBANK2
lfsr	0,__pbssBANK2
movlw	151
clear_0:
clrf	postinc0,c
decf	wreg
bnz	clear_0
; Clear objects allocated to BANK1 (229 bytes)
	global __pbssBANK1
lfsr	0,__pbssBANK1
movlw	229
clear_1:
clrf	postinc0,c
decf	wreg
bnz	clear_1
; Clear objects allocated to BANK0 (23 bytes)
	global __pbssBANK0
lfsr	0,__pbssBANK0
movlw	23
clear_2:
clrf	postinc0,c
decf	wreg
bnz	clear_2
; Clear objects allocated to COMRAM (8 bytes)
	global __pbssCOMRAM
lfsr	0,__pbssCOMRAM
movlw	8
clear_3:
clrf	postinc0,c
decf	wreg
bnz	clear_3
psect cinit,class=CODE,delta=1
global end_of_initialization,__end_of__initialization

;End of C runtime variable initialization code

end_of_initialization:
__end_of__initialization:
	bcf int$flags,0,c ;clear compiler interrupt flag (level 1)
	bcf int$flags,1,c ;clear compiler interrupt flag (level 2)
	GLOBAL	__Lmediumconst
	movlw	low highword(__Lmediumconst)
	movwf	tblptru
movlb 0
goto _main	;jump to C main() function
psect	cstackBANK2,class=BANK2,space=1,noexec,lowdata
global __pcstackBANK2
__pcstackBANK2:
	global	?_vfpfcnvrt
?_vfpfcnvrt:	; 2 bytes @ 0x0
	global	?___fladd
?___fladd:	; 4 bytes @ 0x0
	global	vfpfcnvrt@fp
vfpfcnvrt@fp:	; 2 bytes @ 0x0
	global	___fladd@b
___fladd@b:	; 4 bytes @ 0x0
	global	transmitUart1@bufferTx1
transmitUart1@bufferTx1:	; 45 bytes @ 0x0
	ds   2
	global	vfpfcnvrt@fmt
vfpfcnvrt@fmt:	; 2 bytes @ 0x2
	ds   2
	global	vfpfcnvrt@ap
vfpfcnvrt@ap:	; 2 bytes @ 0x4
	global	___fladd@a
___fladd@a:	; 4 bytes @ 0x4
	ds   2
	global	vfpfcnvrt@ll
vfpfcnvrt@ll:	; 8 bytes @ 0x6
	ds   2
	global	?___fltol
?___fltol:	; 4 bytes @ 0x8
	global	___fltol@f1
___fltol@f1:	; 4 bytes @ 0x8
	ds   4
??___fltol:	; 1 bytes @ 0xC
	ds   2
	global	vfpfcnvrt@cp
vfpfcnvrt@cp:	; 2 bytes @ 0xE
	ds   2
?_I2C_Master_Init:	; 1 bytes @ 0x10
	global	_vfpfcnvrt$2810
_vfpfcnvrt$2810:	; 2 bytes @ 0x10
	global	I2C_Master_Init@clock
I2C_Master_Init@clock:	; 4 bytes @ 0x10
	ds   2
	global	?_vfprintf
?_vfprintf:	; 2 bytes @ 0x12
	global	vfprintf@fp
vfprintf@fp:	; 2 bytes @ 0x12
	ds   2
	global	vfprintf@fmt
vfprintf@fmt:	; 2 bytes @ 0x14
	ds   2
	global	vfprintf@ap
vfprintf@ap:	; 2 bytes @ 0x16
	ds   2
	global	?_sprintf
?_sprintf:	; 2 bytes @ 0x18
	global	sprintf@s
sprintf@s:	; 2 bytes @ 0x18
	ds   2
	global	sprintf@fmt
sprintf@fmt:	; 2 bytes @ 0x1A
	ds   14
	global	sprintf@ap
sprintf@ap:	; 2 bytes @ 0x28
	ds   2
	global	sprintf@f
sprintf@f:	; 11 bytes @ 0x2A
	ds   3
	global	transmitUart1@ucCntTx1
transmitUart1@ucCntTx1:	; 2 bytes @ 0x2D
	ds   2
	global	transmitUart1@x
transmitUart1@x:	; 2 bytes @ 0x2F
	ds   6
?_convOnOff:	; 1 bytes @ 0x35
?_convStringDayWeek:	; 1 bytes @ 0x35
	global	convStringDayWeek@dest
convStringDayWeek@dest:	; 2 bytes @ 0x35
	global	convOnOff@dest
convOnOff@dest:	; 2 bytes @ 0x35
	ds   2
	global	convStringDayWeek@dayWeek
convStringDayWeek@dayWeek:	; 1 bytes @ 0x37
	global	convOnOff@enable
convOnOff@enable:	; 1 bytes @ 0x37
	ds   1
	global	readDevide@bufferHorario
readDevide@bufferHorario:	; 5 bytes @ 0x38
	ds   5
	global	readDevide@bufferEnable
readDevide@bufferEnable:	; 5 bytes @ 0x3D
	ds   5
?_taskAplicacion:	; 2 bytes @ 0x42
	global	taskAplicacion@pt
taskAplicacion@pt:	; 2 bytes @ 0x42
	ds   2
??_taskAplicacion:	; 1 bytes @ 0x44
	ds   2
psect	cstackBANK1,class=BANK1,space=1,noexec,lowdata
global __pcstackBANK1
__pcstackBANK1:
	global	_dtoa$2781
_dtoa$2781:	; 2 bytes @ 0x0
	global	___fldiv@rem
___fldiv@rem:	; 4 bytes @ 0x0
	ds   2
	global	dtoa@p
dtoa@p:	; 2 bytes @ 0x2
	ds   2
	global	___fldiv@sign
___fldiv@sign:	; 1 bytes @ 0x4
	global	dtoa@w
dtoa@w:	; 2 bytes @ 0x4
	ds   1
	global	___fldiv@new_exp
___fldiv@new_exp:	; 2 bytes @ 0x5
	ds   1
	global	dtoa@s
dtoa@s:	; 2 bytes @ 0x6
	ds   1
	global	___fldiv@grs
___fldiv@grs:	; 4 bytes @ 0x7
	ds   1
	global	dtoa@n
dtoa@n:	; 8 bytes @ 0x8
	ds   3
	global	___fldiv@bexp
___fldiv@bexp:	; 1 bytes @ 0xB
	ds   1
	global	___fldiv@aexp
___fldiv@aexp:	; 1 bytes @ 0xC
	ds   1
	global	___fladd@signs
___fladd@signs:	; 1 bytes @ 0xD
	ds   1
	global	___fladd@aexp
___fladd@aexp:	; 1 bytes @ 0xE
	ds   1
	global	___fladd@bexp
___fladd@bexp:	; 1 bytes @ 0xF
	ds   1
	global	___fladd@grs
___fladd@grs:	; 1 bytes @ 0x10
	global	dtoa@i
dtoa@i:	; 2 bytes @ 0x10
	ds   2
	global	vfprintf@cfmt
vfprintf@cfmt:	; 2 bytes @ 0x12
	ds   2
psect	cstackBANK0,class=BANK0,space=1,noexec,lowdata
global __pcstackBANK0
__pcstackBANK0:
	global	i1vfpfcnvrt@ll
i1vfpfcnvrt@ll:	; 8 bytes @ 0x0
	ds   8
	global	i1vfpfcnvrt@cp
i1vfpfcnvrt@cp:	; 2 bytes @ 0x8
	ds   2
	global	i1_vfpfcnvrt$2810
i1_vfpfcnvrt$2810:	; 2 bytes @ 0xA
	ds   2
	global	?i1_vfprintf
?i1_vfprintf:	; 2 bytes @ 0xC
	global	i1vfprintf@fp
i1vfprintf@fp:	; 2 bytes @ 0xC
	ds   2
	global	i1vfprintf@fmt
i1vfprintf@fmt:	; 2 bytes @ 0xE
	ds   2
	global	i1vfprintf@ap
i1vfprintf@ap:	; 2 bytes @ 0x10
	ds   2
	global	i1vfprintf@cfmt
i1vfprintf@cfmt:	; 2 bytes @ 0x12
	ds   2
	global	?_printf
?_printf:	; 2 bytes @ 0x14
	global	printf@fmt
printf@fmt:	; 2 bytes @ 0x14
	ds   2
	global	printf@ap
printf@ap:	; 2 bytes @ 0x16
	ds   2
??_INT_ISR_LOW:	; 1 bytes @ 0x18
	ds   13
??_INT_init:	; 1 bytes @ 0x25
??_ADC_init:	; 1 bytes @ 0x25
??_pinConfLedPin:	; 1 bytes @ 0x25
??_pinConfBuzzer:	; 1 bytes @ 0x25
??_pinConfCluster:	; 1 bytes @ 0x25
??_startTaskLedLive:	; 1 bytes @ 0x25
??_startTaskAnalizaUart1:	; 1 bytes @ 0x25
??_startTaskAplicacion:	; 1 bytes @ 0x25
??_startTaskAlarm:	; 1 bytes @ 0x25
??_startTaskBuzzer:	; 1 bytes @ 0x25
??_startTaskCluster:	; 1 bytes @ 0x25
?_reiniciarTemporizador:	; 1 bytes @ 0x25
??_twoBeep:	; 1 bytes @ 0x25
?_cambiarEstado:	; 1 bytes @ 0x25
?_inicioEstado:	; 1 bytes @ 0x25
?_EEpromRead:	; 1 bytes @ 0x25
?_EEpromWrite:	; 1 bytes @ 0x25
??_oneBeep:	; 1 bytes @ 0x25
?_UART_init_baud:	; 1 bytes @ 0x25
??_UART_write:	; 1 bytes @ 0x25
??_BCD_a_Decimal:	; 1 bytes @ 0x25
??_I2C_Master_Wait:	; 1 bytes @ 0x25
?___lbdiv:	; 1 bytes @ 0x25
?___lbmod:	; 1 bytes @ 0x25
	global	?_strlen
?_strlen:	; 2 bytes @ 0x25
	global	?_isspace
?_isspace:	; 2 bytes @ 0x25
	global	?_isdigit
?_isdigit:	; 2 bytes @ 0x25
	global	?_strncmp
?_strncmp:	; 2 bytes @ 0x25
	global	?_strchr
?_strchr:	; 2 bytes @ 0x25
	global	?_ADC_read
?_ADC_read:	; 2 bytes @ 0x25
	global	?___wmul
?___wmul:	; 2 bytes @ 0x25
	global	?_getMillis
?_getMillis:	; 4 bytes @ 0x25
	global	?___aodiv
?___aodiv:	; 8 bytes @ 0x25
	global	?___aomod
?___aomod:	; 8 bytes @ 0x25
	global	UART_write@dato
UART_write@dato:	; 1 bytes @ 0x25
	global	___lbdiv@divisor
___lbdiv@divisor:	; 1 bytes @ 0x25
	global	___lbmod@divisor
___lbmod@divisor:	; 1 bytes @ 0x25
	global	inicioEstado@state
inicioEstado@state:	; 2 bytes @ 0x25
	global	cambiarEstado@state
cambiarEstado@state:	; 2 bytes @ 0x25
	global	reiniciarTemporizador@time
reiniciarTemporizador@time:	; 2 bytes @ 0x25
	global	EEpromWrite@address
EEpromWrite@address:	; 2 bytes @ 0x25
	global	EEpromRead@address
EEpromRead@address:	; 2 bytes @ 0x25
	global	___wmul@multiplier
___wmul@multiplier:	; 2 bytes @ 0x25
	global	isdigit@c
isdigit@c:	; 2 bytes @ 0x25
	global	isspace@c
isspace@c:	; 2 bytes @ 0x25
	global	strlen@s
strlen@s:	; 2 bytes @ 0x25
	global	strncmp@_l
strncmp@_l:	; 2 bytes @ 0x25
	global	strchr@s
strchr@s:	; 2 bytes @ 0x25
	global	UART_init_baud@baudRate
UART_init_baud@baudRate:	; 4 bytes @ 0x25
	global	___aodiv@dividend
___aodiv@dividend:	; 8 bytes @ 0x25
	global	___aomod@dividend
___aomod@dividend:	; 8 bytes @ 0x25
	ds   1
??_I2C_Start:	; 1 bytes @ 0x26
??_I2C_Master_Write:	; 1 bytes @ 0x26
??_I2C_Repeated_Start:	; 1 bytes @ 0x26
??_I2C_Master_Read:	; 1 bytes @ 0x26
??_I2C_Stop:	; 1 bytes @ 0x26
??_putch:	; 1 bytes @ 0x26
??___lbdiv:	; 1 bytes @ 0x26
??___lbmod:	; 1 bytes @ 0x26
	global	putch@dato
putch@dato:	; 1 bytes @ 0x26
	global	BCD_a_Decimal@numero
BCD_a_Decimal@numero:	; 1 bytes @ 0x26
	global	I2C_Master_Write@dato
I2C_Master_Write@dato:	; 1 bytes @ 0x26
	global	___lbdiv@dividend
___lbdiv@dividend:	; 1 bytes @ 0x26
	global	___lbmod@dividend
___lbmod@dividend:	; 1 bytes @ 0x26
	ds   1
??_reiniciarTemporizador:	; 1 bytes @ 0x27
??_cambiarEstado:	; 1 bytes @ 0x27
??_inicioEstado:	; 1 bytes @ 0x27
??_EEpromRead:	; 1 bytes @ 0x27
??_readMemoriaValues:	; 1 bytes @ 0x27
??_strlen:	; 1 bytes @ 0x27
??_isspace:	; 1 bytes @ 0x27
??_isdigit:	; 1 bytes @ 0x27
??_ADC_read:	; 1 bytes @ 0x27
?_fputc:	; 2 bytes @ 0x27
	global	EEpromWrite@data
EEpromWrite@data:	; 1 bytes @ 0x27
	global	I2C_Master_Read@ACK
I2C_Master_Read@ACK:	; 1 bytes @ 0x27
	global	___lbdiv@counter
___lbdiv@counter:	; 1 bytes @ 0x27
	global	___lbmod@counter
___lbmod@counter:	; 1 bytes @ 0x27
	global	___wmul@multiplicand
___wmul@multiplicand:	; 2 bytes @ 0x27
	global	fputc@c
fputc@c:	; 2 bytes @ 0x27
	global	strlen@a
strlen@a:	; 2 bytes @ 0x27
	global	strncmp@_r
strncmp@_r:	; 2 bytes @ 0x27
	global	strchr@c
strchr@c:	; 2 bytes @ 0x27
	ds   1
??_EEpromWrite:	; 1 bytes @ 0x28
	global	I2C_Master_Read@dato
I2C_Master_Read@dato:	; 1 bytes @ 0x28
	global	___lbdiv@quotient
___lbdiv@quotient:	; 1 bytes @ 0x28
	global	___lbmod@rem
___lbmod@rem:	; 1 bytes @ 0x28
	ds   1
??_getMillis:	; 1 bytes @ 0x29
?_leerRTC:	; 1 bytes @ 0x29
?_leerRtcSeg:	; 1 bytes @ 0x29
??_strchr:	; 1 bytes @ 0x29
??_UART_init_baud:	; 1 bytes @ 0x29
??_Decimal_a_BCD:	; 1 bytes @ 0x29
??___wmul:	; 1 bytes @ 0x29
?_memset:	; 2 bytes @ 0x29
?_memcpy:	; 2 bytes @ 0x29
?_taskBuzzer:	; 2 bytes @ 0x29
?_taskCluster:	; 2 bytes @ 0x29
?_taskLedLive:	; 2 bytes @ 0x29
	global	ADC_read@channel
ADC_read@channel:	; 1 bytes @ 0x29
	global	leerRtcSeg@segundos
leerRtcSeg@segundos:	; 1 bytes @ 0x29
	global	leerRTC@hora
leerRTC@hora:	; 1 bytes @ 0x29
	global	taskBuzzer@pt
taskBuzzer@pt:	; 2 bytes @ 0x29
	global	taskCluster@pt
taskCluster@pt:	; 2 bytes @ 0x29
	global	taskLedLive@pt
taskLedLive@pt:	; 2 bytes @ 0x29
	global	___wmul@product
___wmul@product:	; 2 bytes @ 0x29
	global	memcpy@d1
memcpy@d1:	; 2 bytes @ 0x29
	global	memset@dest
memset@dest:	; 2 bytes @ 0x29
	global	fputc@fp
fputc@fp:	; 2 bytes @ 0x29
	global	strncmp@n
strncmp@n:	; 2 bytes @ 0x29
	ds   1
??_leerRtcSeg:	; 1 bytes @ 0x2A
	global	?___xxtofl
?___xxtofl:	; 4 bytes @ 0x2A
	global	Decimal_a_BCD@numero
Decimal_a_BCD@numero:	; 1 bytes @ 0x2A
	global	leerRTC@minutos
leerRTC@minutos:	; 1 bytes @ 0x2A
	global	___xxtofl@val
___xxtofl@val:	; 4 bytes @ 0x2A
	ds   1
??_fputc:	; 1 bytes @ 0x2B
??_strncmp:	; 1 bytes @ 0x2B
??_taskBuzzer:	; 1 bytes @ 0x2B
??_taskCluster:	; 1 bytes @ 0x2B
?_escribirRTC:	; 1 bytes @ 0x2B
??_taskLedLive:	; 1 bytes @ 0x2B
	global	leerRTC@segundos
leerRTC@segundos:	; 1 bytes @ 0x2B
	global	escribirRTC@min
escribirRTC@min:	; 1 bytes @ 0x2B
	global	_isspace$2678
_isspace$2678:	; 1 bytes @ 0x2B
	global	memcpy@s1
memcpy@s1:	; 2 bytes @ 0x2B
	global	memset@c
memset@c:	; 2 bytes @ 0x2B
	ds   1
	global	?_atoi
?_atoi:	; 2 bytes @ 0x2C
	global	leerRTC@dia
leerRTC@dia:	; 1 bytes @ 0x2C
	global	escribirRTC@seg
escribirRTC@seg:	; 1 bytes @ 0x2C
	global	atoi@s
atoi@s:	; 2 bytes @ 0x2C
	global	strncmp@l
strncmp@l:	; 2 bytes @ 0x2C
	ds   1
??_executeTaskLedLive:	; 1 bytes @ 0x2D
??_executeTaskBuzzer:	; 1 bytes @ 0x2D
??_executeTaskCluster:	; 1 bytes @ 0x2D
	global	leerRTC@mes
leerRTC@mes:	; 1 bytes @ 0x2D
	global	escribirRTC@dia
escribirRTC@dia:	; 1 bytes @ 0x2D
	global	memcpy@n
memcpy@n:	; 2 bytes @ 0x2D
	global	memset@n
memset@n:	; 2 bytes @ 0x2D
	global	___aodiv@divisor
___aodiv@divisor:	; 8 bytes @ 0x2D
	global	___aomod@divisor
___aomod@divisor:	; 8 bytes @ 0x2D
	ds   1
??_atoi:	; 1 bytes @ 0x2E
??___xxtofl:	; 1 bytes @ 0x2E
	global	leerRTC@ano
leerRTC@ano:	; 1 bytes @ 0x2E
	global	escribirRTC@mes
escribirRTC@mes:	; 1 bytes @ 0x2E
	global	strncmp@r
strncmp@r:	; 2 bytes @ 0x2E
	ds   1
??_memset:	; 1 bytes @ 0x2F
??_memcpy:	; 1 bytes @ 0x2F
	global	leerRTC@diaSe
leerRTC@diaSe:	; 1 bytes @ 0x2F
	global	escribirRTC@ano
escribirRTC@ano:	; 1 bytes @ 0x2F
	global	memcpy@tmp
memcpy@tmp:	; 1 bytes @ 0x2F
	ds   1
??_leerRTC:	; 1 bytes @ 0x30
	global	?_strstr
?_strstr:	; 2 bytes @ 0x30
?_fputs:	; 2 bytes @ 0x30
	global	?_stoa
?_stoa:	; 2 bytes @ 0x30
	global	escribirRTC@diaSe
escribirRTC@diaSe:	; 1 bytes @ 0x30
	global	memcpy@d
memcpy@d:	; 2 bytes @ 0x30
	global	stoa@fp
stoa@fp:	; 2 bytes @ 0x30
	global	fputs@s
fputs@s:	; 2 bytes @ 0x30
	global	strstr@h
strstr@h:	; 2 bytes @ 0x30
	global	leerRTC@rtc_dir
leerRTC@rtc_dir:	; 7 bytes @ 0x30
	ds   1
??_escribirRTC:	; 1 bytes @ 0x31
	global	memset@k
memset@k:	; 2 bytes @ 0x31
	global	escribirRTC@rtc_dir
escribirRTC@rtc_dir:	; 7 bytes @ 0x31
	ds   1
	global	___xxtofl@sign
___xxtofl@sign:	; 1 bytes @ 0x32
	global	atoi@neg
atoi@neg:	; 2 bytes @ 0x32
	global	memcpy@s
memcpy@s:	; 2 bytes @ 0x32
	global	stoa@s
stoa@s:	; 2 bytes @ 0x32
	global	fputs@fp
fputs@fp:	; 2 bytes @ 0x32
	global	strstr@n
strstr@n:	; 2 bytes @ 0x32
	ds   1
	global	___xxtofl@exp
___xxtofl@exp:	; 1 bytes @ 0x33
	global	memset@s
memset@s:	; 2 bytes @ 0x33
	ds   1
??_strstr:	; 1 bytes @ 0x34
??_fputs:	; 1 bytes @ 0x34
??_stoa:	; 1 bytes @ 0x34
	global	fputs@c
fputs@c:	; 1 bytes @ 0x34
	global	atoi@n
atoi@n:	; 2 bytes @ 0x34
	global	strstr@nl
strstr@nl:	; 2 bytes @ 0x34
	global	___xxtofl@arg
___xxtofl@arg:	; 4 bytes @ 0x34
	ds   1
?_transmitUart1:	; 1 bytes @ 0x35
?_cleanBuffer:	; 1 bytes @ 0x35
??___aodiv:	; 1 bytes @ 0x35
??___aomod:	; 1 bytes @ 0x35
	global	___aodiv@counter
___aodiv@counter:	; 1 bytes @ 0x35
	global	___aomod@counter
___aomod@counter:	; 1 bytes @ 0x35
	global	cleanBuffer@orig
cleanBuffer@orig:	; 2 bytes @ 0x35
	global	transmitUart1@ptr
transmitUart1@ptr:	; 2 bytes @ 0x35
	global	fputs@i
fputs@i:	; 2 bytes @ 0x35
	global	stoa@nuls
stoa@nuls:	; 7 bytes @ 0x35
	ds   1
?_extraerFrame:	; 1 bytes @ 0x36
?_extraerHora:	; 1 bytes @ 0x36
?_extraerCalendar:	; 1 bytes @ 0x36
?_extraerValue:	; 1 bytes @ 0x36
	global	___aodiv@sign
___aodiv@sign:	; 1 bytes @ 0x36
	global	___aomod@sign
___aomod@sign:	; 1 bytes @ 0x36
	global	extraerValue@orig
extraerValue@orig:	; 2 bytes @ 0x36
	global	extraerFrame@orig
extraerFrame@orig:	; 2 bytes @ 0x36
	global	extraerHora@orig
extraerHora@orig:	; 2 bytes @ 0x36
	global	extraerCalendar@orig
extraerCalendar@orig:	; 2 bytes @ 0x36
	ds   1
??_transmitUart1:	; 1 bytes @ 0x37
??_cleanBuffer:	; 1 bytes @ 0x37
	global	?_abs
?_abs:	; 2 bytes @ 0x37
	global	?_pad
?_pad:	; 2 bytes @ 0x37
	global	pad@fp
pad@fp:	; 2 bytes @ 0x37
	global	abs@a
abs@a:	; 2 bytes @ 0x37
	global	leerRTC@rtc
leerRTC@rtc:	; 7 bytes @ 0x37
	global	___aodiv@quotient
___aodiv@quotient:	; 8 bytes @ 0x37
	ds   1
	global	?___flmul
?___flmul:	; 4 bytes @ 0x38
	global	escribirRTC@hor
escribirRTC@hor:	; 1 bytes @ 0x38
	global	extraerValue@init
extraerValue@init:	; 2 bytes @ 0x38
	global	extraerFrame@dest
extraerFrame@dest:	; 2 bytes @ 0x38
	global	extraerHora@hor
extraerHora@hor:	; 2 bytes @ 0x38
	global	extraerCalendar@dia
extraerCalendar@dia:	; 2 bytes @ 0x38
	global	___flmul@b
___flmul@b:	; 4 bytes @ 0x38
	ds   1
??_abs:	; 1 bytes @ 0x39
	global	pad@buf
pad@buf:	; 2 bytes @ 0x39
	global	escribirRTC@rtc_datos
escribirRTC@rtc_datos:	; 7 bytes @ 0x39
	ds   1
	global	extraerValue@end
extraerValue@end:	; 2 bytes @ 0x3A
	global	extraerFrame@init
extraerFrame@init:	; 2 bytes @ 0x3A
	global	extraerHora@min
extraerHora@min:	; 2 bytes @ 0x3A
	global	extraerCalendar@mes
extraerCalendar@mes:	; 2 bytes @ 0x3A
	ds   1
	global	pad@p
pad@p:	; 2 bytes @ 0x3B
	ds   1
??_extraerHora:	; 1 bytes @ 0x3C
??_extraerValue:	; 1 bytes @ 0x3C
	global	extraerHora@hora
extraerHora@hora:	; 1 bytes @ 0x3C
	global	extraerFrame@end
extraerFrame@end:	; 2 bytes @ 0x3C
	global	extraerCalendar@ano
extraerCalendar@ano:	; 2 bytes @ 0x3C
	global	stoa@i
stoa@i:	; 2 bytes @ 0x3C
	global	___flmul@a
___flmul@a:	; 4 bytes @ 0x3C
	ds   1
??_pad:	; 1 bytes @ 0x3D
	global	extraerValue@value
extraerValue@value:	; 1 bytes @ 0x3D
	global	extraerHora@minuto
extraerHora@minuto:	; 1 bytes @ 0x3D
	ds   1
??_extraerFrame:	; 1 bytes @ 0x3E
	global	leerRTC@i
leerRTC@i:	; 1 bytes @ 0x3E
	global	extraerValue@cnt
extraerValue@cnt:	; 1 bytes @ 0x3E
	global	extraerCalendar@diaSema
extraerCalendar@diaSema:	; 2 bytes @ 0x3E
	global	pad@i
pad@i:	; 2 bytes @ 0x3E
	global	stoa@w
stoa@w:	; 2 bytes @ 0x3E
	global	extraerHora@buffer
extraerHora@buffer:	; 4 bytes @ 0x3E
	ds   1
?_taskAlarm:	; 2 bytes @ 0x3F
	global	taskAlarm@pt
taskAlarm@pt:	; 2 bytes @ 0x3F
	global	extraerValue@buffer
extraerValue@buffer:	; 4 bytes @ 0x3F
	global	extraerFrame@buffer
extraerFrame@buffer:	; 10 bytes @ 0x3F
	ds   1
??_extraerCalendar:	; 1 bytes @ 0x40
??___flmul:	; 1 bytes @ 0x40
	global	escribirRTC@i
escribirRTC@i:	; 1 bytes @ 0x40
	global	extraerCalendar@day
extraerCalendar@day:	; 1 bytes @ 0x40
	global	pad@w
pad@w:	; 2 bytes @ 0x40
	global	stoa@cp
stoa@cp:	; 2 bytes @ 0x40
	ds   1
??_taskAlarm:	; 1 bytes @ 0x41
	global	extraerCalendar@month
extraerCalendar@month:	; 1 bytes @ 0x41
	ds   1
	global	?_dtoa
?_dtoa:	; 2 bytes @ 0x42
	global	extraerCalendar@year
extraerCalendar@year:	; 1 bytes @ 0x42
	global	dtoa@fp
dtoa@fp:	; 2 bytes @ 0x42
	global	stoa@p
stoa@p:	; 2 bytes @ 0x42
	ds   1
??_executeTaskAlarm:	; 1 bytes @ 0x43
	global	extraerCalendar@dayWeek
extraerCalendar@dayWeek:	; 1 bytes @ 0x43
	global	extraerValue@ptrData
extraerValue@ptrData:	; 2 bytes @ 0x43
	ds   1
	global	___flmul@sign
___flmul@sign:	; 1 bytes @ 0x44
	global	stoa@l
stoa@l:	; 2 bytes @ 0x44
	global	extraerCalendar@buffer
extraerCalendar@buffer:	; 4 bytes @ 0x44
	global	dtoa@d
dtoa@d:	; 8 bytes @ 0x44
	ds   1
	global	___flmul@aexp
___flmul@aexp:	; 1 bytes @ 0x45
	ds   1
	global	___flmul@grs
___flmul@grs:	; 4 bytes @ 0x46
	ds   3
	global	extraerFrame@cnt
extraerFrame@cnt:	; 1 bytes @ 0x49
	ds   1
	global	___flmul@bexp
___flmul@bexp:	; 1 bytes @ 0x4A
	global	extraerFrame@ptrData
extraerFrame@ptrData:	; 2 bytes @ 0x4A
	ds   1
	global	___flmul@prod
___flmul@prod:	; 4 bytes @ 0x4B
	ds   1
??_dtoa:	; 1 bytes @ 0x4C
?_taskAnalizaUart1:	; 2 bytes @ 0x4C
	global	taskAnalizaUart1@pt
taskAnalizaUart1@pt:	; 2 bytes @ 0x4C
	ds   2
??_taskAnalizaUart1:	; 1 bytes @ 0x4E
	ds   1
	global	___flmul@temp
___flmul@temp:	; 2 bytes @ 0x4F
	ds   1
	global	taskAnalizaUart1@x
taskAnalizaUart1@x:	; 1 bytes @ 0x50
	ds   1
	global	?___fldiv
?___fldiv:	; 4 bytes @ 0x51
	global	taskAnalizaUart1@i
taskAnalizaUart1@i:	; 1 bytes @ 0x51
	global	___fldiv@b
___fldiv@b:	; 4 bytes @ 0x51
	ds   1
??_executeTaskAnalizaUart1:	; 1 bytes @ 0x52
	ds   2
??_vfpfcnvrt:	; 1 bytes @ 0x54
	ds   1
	global	___fldiv@a
___fldiv@a:	; 4 bytes @ 0x55
	ds   1
??_readDevide:	; 1 bytes @ 0x56
??_sprintf:	; 1 bytes @ 0x56
??_convOnOff:	; 1 bytes @ 0x56
??_convStringDayWeek:	; 1 bytes @ 0x56
??_vfprintf:	; 1 bytes @ 0x56
	ds   3
??___fldiv:	; 1 bytes @ 0x59
	ds   4
??___fladd:	; 1 bytes @ 0x5D
	ds   4
??_executeTaskAplicacion:	; 1 bytes @ 0x61
	global	___fltol@sign1
___fltol@sign1:	; 1 bytes @ 0x61
	ds   1
	global	___fltol@exp1
___fltol@exp1:	; 1 bytes @ 0x62
	ds   1
??_I2C_Master_Init:	; 1 bytes @ 0x63
??_main:	; 1 bytes @ 0x63
psect	cstackCOMRAM,class=COMRAM,space=1,noexec,lowdata
global __pcstackCOMRAM
__pcstackCOMRAM:
?_receiverUart1:	; 1 bytes @ 0x0
?_INT_init:	; 1 bytes @ 0x0
?_ADC_init:	; 1 bytes @ 0x0
?_pinConfLedPin:	; 1 bytes @ 0x0
?_pinConfBuzzer:	; 1 bytes @ 0x0
?_pinConfCluster:	; 1 bytes @ 0x0
?_startTaskLedLive:	; 1 bytes @ 0x0
?_startTaskAnalizaUart1:	; 1 bytes @ 0x0
?_startTaskAplicacion:	; 1 bytes @ 0x0
?_startTaskAlarm:	; 1 bytes @ 0x0
?_startTaskBuzzer:	; 1 bytes @ 0x0
?_startTaskCluster:	; 1 bytes @ 0x0
?_executeTaskLedLive:	; 1 bytes @ 0x0
?_executeTaskAnalizaUart1:	; 1 bytes @ 0x0
?_executeTaskAplicacion:	; 1 bytes @ 0x0
?_executeTaskAlarm:	; 1 bytes @ 0x0
?_executeTaskBuzzer:	; 1 bytes @ 0x0
?_executeTaskCluster:	; 1 bytes @ 0x0
?_twoBeep:	; 1 bytes @ 0x0
?_readMemoriaValues:	; 1 bytes @ 0x0
?_oneBeep:	; 1 bytes @ 0x0
?_readDevide:	; 1 bytes @ 0x0
?_I2C_Start:	; 1 bytes @ 0x0
?_I2C_Master_Write:	; 1 bytes @ 0x0
?_I2C_Repeated_Start:	; 1 bytes @ 0x0
?_I2C_Master_Read:	; 1 bytes @ 0x0
?_I2C_Stop:	; 1 bytes @ 0x0
?_UART_read:	; 1 bytes @ 0x0
??_UART_read:	; 1 bytes @ 0x0
?_UART_write:	; 1 bytes @ 0x0
?_putch:	; 1 bytes @ 0x0
?_INT_isr:	; 1 bytes @ 0x0
?_INT_ISR_LOW:	; 1 bytes @ 0x0
?_main:	; 1 bytes @ 0x0
?_BCD_a_Decimal:	; 1 bytes @ 0x0
?_Decimal_a_BCD:	; 1 bytes @ 0x0
?_I2C_Master_Wait:	; 1 bytes @ 0x0
?i1_UART_write:	; 1 bytes @ 0x0
?i1_putch:	; 1 bytes @ 0x0
	global	receiverUart1@dest
receiverUart1@dest:	; 1 bytes @ 0x0
	ds   1
??_receiverUart1:	; 1 bytes @ 0x1
??_INT_isr:	; 1 bytes @ 0x1
	ds   4
	global	INT_isr@ch
INT_isr@ch:	; 1 bytes @ 0x5
	ds   1
??i1_UART_write:	; 1 bytes @ 0x6
	global	?i1_strlen
?i1_strlen:	; 2 bytes @ 0x6
	global	?i1_strncmp
?i1_strncmp:	; 2 bytes @ 0x6
	global	?i1___aodiv
?i1___aodiv:	; 8 bytes @ 0x6
	global	?i1___aomod
?i1___aomod:	; 8 bytes @ 0x6
	global	i1UART_write@dato
i1UART_write@dato:	; 1 bytes @ 0x6
	global	i1strlen@s
i1strlen@s:	; 2 bytes @ 0x6
	global	i1strncmp@_l
i1strncmp@_l:	; 2 bytes @ 0x6
	global	i1___aodiv@dividend
i1___aodiv@dividend:	; 8 bytes @ 0x6
	global	i1___aomod@dividend
i1___aomod@dividend:	; 8 bytes @ 0x6
	ds   1
??i1_putch:	; 1 bytes @ 0x7
	global	i1putch@dato
i1putch@dato:	; 1 bytes @ 0x7
	ds   1
??i1_strlen:	; 1 bytes @ 0x8
?i1_fputc:	; 2 bytes @ 0x8
	global	i1fputc@c
i1fputc@c:	; 2 bytes @ 0x8
	global	i1strlen@a
i1strlen@a:	; 2 bytes @ 0x8
	global	i1strncmp@_r
i1strncmp@_r:	; 2 bytes @ 0x8
	ds   2
	global	i1fputc@fp
i1fputc@fp:	; 2 bytes @ 0xA
	global	i1strncmp@n
i1strncmp@n:	; 2 bytes @ 0xA
	ds   2
??i1_fputc:	; 1 bytes @ 0xC
??i1_strncmp:	; 1 bytes @ 0xC
	ds   1
	global	i1strncmp@l
i1strncmp@l:	; 2 bytes @ 0xD
	ds   1
	global	i1___aodiv@divisor
i1___aodiv@divisor:	; 8 bytes @ 0xE
	global	i1___aomod@divisor
i1___aomod@divisor:	; 8 bytes @ 0xE
	ds   1
	global	i1strncmp@r
i1strncmp@r:	; 2 bytes @ 0xF
	ds   2
	global	?i1_stoa
?i1_stoa:	; 2 bytes @ 0x11
?i1_fputs:	; 2 bytes @ 0x11
	global	i1stoa@fp
i1stoa@fp:	; 2 bytes @ 0x11
	global	i1fputs@s
i1fputs@s:	; 2 bytes @ 0x11
	ds   2
	global	i1stoa@s
i1stoa@s:	; 2 bytes @ 0x13
	global	i1fputs@fp
i1fputs@fp:	; 2 bytes @ 0x13
	ds   2
??i1_stoa:	; 1 bytes @ 0x15
??i1_fputs:	; 1 bytes @ 0x15
	global	i1fputs@c
i1fputs@c:	; 1 bytes @ 0x15
	ds   1
??i1___aodiv:	; 1 bytes @ 0x16
??i1___aomod:	; 1 bytes @ 0x16
	global	i1___aodiv@counter
i1___aodiv@counter:	; 1 bytes @ 0x16
	global	i1___aomod@counter
i1___aomod@counter:	; 1 bytes @ 0x16
	global	i1fputs@i
i1fputs@i:	; 2 bytes @ 0x16
	global	i1stoa@nuls
i1stoa@nuls:	; 7 bytes @ 0x16
	ds   1
	global	i1___aodiv@sign
i1___aodiv@sign:	; 1 bytes @ 0x17
	global	i1___aomod@sign
i1___aomod@sign:	; 1 bytes @ 0x17
	ds   1
	global	?i1_pad
?i1_pad:	; 2 bytes @ 0x18
	global	?i1_abs
?i1_abs:	; 2 bytes @ 0x18
	global	i1pad@fp
i1pad@fp:	; 2 bytes @ 0x18
	global	i1abs@a
i1abs@a:	; 2 bytes @ 0x18
	global	i1___aodiv@quotient
i1___aodiv@quotient:	; 8 bytes @ 0x18
	ds   2
??i1_abs:	; 1 bytes @ 0x1A
	global	i1pad@buf
i1pad@buf:	; 2 bytes @ 0x1A
	ds   2
	global	i1pad@p
i1pad@p:	; 2 bytes @ 0x1C
	ds   1
	global	i1stoa@i
i1stoa@i:	; 2 bytes @ 0x1D
	ds   1
??i1_pad:	; 1 bytes @ 0x1E
	ds   1
	global	i1pad@i
i1pad@i:	; 2 bytes @ 0x1F
	global	i1stoa@w
i1stoa@w:	; 2 bytes @ 0x1F
	ds   2
	global	i1pad@w
i1pad@w:	; 2 bytes @ 0x21
	global	i1stoa@cp
i1stoa@cp:	; 2 bytes @ 0x21
	ds   2
	global	?i1_dtoa
?i1_dtoa:	; 2 bytes @ 0x23
	global	i1dtoa@fp
i1dtoa@fp:	; 2 bytes @ 0x23
	global	i1stoa@p
i1stoa@p:	; 2 bytes @ 0x23
	ds   2
	global	i1stoa@l
i1stoa@l:	; 2 bytes @ 0x25
	global	i1dtoa@d
i1dtoa@d:	; 8 bytes @ 0x25
	ds   8
??i1_dtoa:	; 1 bytes @ 0x2D
	ds   8
	global	i1_dtoa$2781
i1_dtoa$2781:	; 2 bytes @ 0x35
	ds   2
	global	i1dtoa@p
i1dtoa@p:	; 2 bytes @ 0x37
	ds   2
	global	i1dtoa@w
i1dtoa@w:	; 2 bytes @ 0x39
	ds   2
	global	i1dtoa@s
i1dtoa@s:	; 2 bytes @ 0x3B
	ds   2
	global	i1dtoa@n
i1dtoa@n:	; 8 bytes @ 0x3D
	ds   8
	global	i1dtoa@i
i1dtoa@i:	; 2 bytes @ 0x45
	ds   2
	global	?i1_vfpfcnvrt
?i1_vfpfcnvrt:	; 2 bytes @ 0x47
	global	i1vfpfcnvrt@fp
i1vfpfcnvrt@fp:	; 2 bytes @ 0x47
	ds   2
	global	i1vfpfcnvrt@fmt
i1vfpfcnvrt@fmt:	; 2 bytes @ 0x49
	ds   2
	global	i1vfpfcnvrt@ap
i1vfpfcnvrt@ap:	; 2 bytes @ 0x4B
	ds   2
??i1_vfpfcnvrt:	; 1 bytes @ 0x4D
	ds   2
??_printf:	; 1 bytes @ 0x4F
??i1_vfprintf:	; 1 bytes @ 0x4F
;!
;!Data Sizes:
;!    Strings     369
;!    Constant    21
;!    Data        7
;!    BSS         411
;!    Persistent  0
;!    Stack       0
;!
;!Auto Spaces:
;!    Space          Size  Autos    Used
;!    COMRAM           94     79      87
;!    BANK0           160     99     122
;!    BANK1           256     20     256
;!    BANK2           256     70     221
;!    BANK3           256      0       0
;!    BANK4           256      0       0
;!    BANK5           256      0       0
;!    BANK6           256      0       0
;!    BANK7           256      0       0

;!
;!Pointer List with Targets:
;!
;!    strchr@s	PTR const unsigned char  size(2) Largest target is 69
;!		 -> NULL(NULL[0]), anaT1.bufferRx(BANK1[40]), anaT1(BANK1[69]), 
;!
;!    sp__strchr	PTR unsigned char  size(2) Largest target is 69
;!		 -> NULL(NULL[0]), anaT1.bufferRx(BANK1[40]), anaT1(BANK1[69]), 
;!
;!    strstr@h	PTR const unsigned char  size(2) Largest target is 69
;!		 -> NULL(NULL[0]), anaT1.bufferRx(BANK1[40]), anaT1(BANK1[69]), 
;!
;!    strstr@n	PTR const unsigned char  size(2) Largest target is 2
;!		 -> STR_39(CODE[2]), STR_37(CODE[2]), STR_35(CODE[2]), STR_33(CODE[2]), 
;!		 -> STR_32(CODE[2]), STR_29(CODE[2]), STR_28(CODE[2]), STR_25(CODE[2]), 
;!		 -> STR_23(CODE[2]), STR_22(CODE[2]), STR_20(CODE[2]), STR_18(CODE[2]), 
;!
;!    strncmp@_r	PTR const unsigned char  size(2) Largest target is 4
;!		 -> STR_43(CODE[4]), STR_39(CODE[2]), STR_37(CODE[2]), STR_35(CODE[2]), 
;!		 -> STR_33(CODE[2]), STR_32(CODE[2]), STR_29(CODE[2]), STR_28(CODE[2]), 
;!		 -> STR_25(CODE[2]), STR_23(CODE[2]), STR_22(CODE[2]), STR_20(CODE[2]), 
;!		 -> STR_18(CODE[2]), 
;!
;!    strncmp@r	PTR const unsigned char  size(2) Largest target is 4
;!		 -> STR_43(CODE[4]), STR_39(CODE[2]), STR_37(CODE[2]), STR_35(CODE[2]), 
;!		 -> STR_33(CODE[2]), STR_32(CODE[2]), STR_29(CODE[2]), STR_28(CODE[2]), 
;!		 -> STR_25(CODE[2]), STR_23(CODE[2]), STR_22(CODE[2]), STR_20(CODE[2]), 
;!		 -> STR_18(CODE[2]), 
;!
;!    strncmp@_l	PTR const unsigned char  size(2) Largest target is 69
;!		 -> NULL(NULL[0]), anaT1.bufferRx(BANK1[40]), STR_16(CODE[4]), STR_15(CODE[3]), 
;!		 -> STR_14(CODE[3]), STR_13(CODE[3]), STR_12(CODE[4]), STR_11(CODE[38]), 
;!		 -> STR_10(CODE[36]), STR_9(CODE[36]), STR_8(CODE[36]), STR_7(CODE[36]), 
;!		 -> STR_6(CODE[43]), STR_5(CODE[18]), STR_4(CODE[11]), STR_2(CODE[24]), 
;!		 -> STR_1(CODE[27]), anaT1(BANK1[69]), 
;!
;!    strncmp@l	PTR const unsigned char  size(2) Largest target is 69
;!		 -> NULL(NULL[0]), anaT1.bufferRx(BANK1[40]), STR_16(CODE[4]), STR_15(CODE[3]), 
;!		 -> STR_14(CODE[3]), STR_13(CODE[3]), STR_12(CODE[4]), STR_11(CODE[38]), 
;!		 -> STR_10(CODE[36]), STR_9(CODE[36]), STR_8(CODE[36]), STR_7(CODE[36]), 
;!		 -> STR_6(CODE[43]), STR_5(CODE[18]), STR_4(CODE[11]), STR_2(CODE[24]), 
;!		 -> STR_1(CODE[27]), anaT1(BANK1[69]), 
;!
;!    strlen@s	PTR const unsigned char  size(2) Largest target is 76
;!		 -> ?_printf(BANK0[2]), stoa@nuls(BANK0[7]), dbuf(BANK2[32]), ?_sprintf(BANK2[2]), 
;!		 -> extraerFrame@buffer(BANK0[10]), STR_39(CODE[2]), STR_37(CODE[2]), STR_35(CODE[2]), 
;!		 -> STR_33(CODE[2]), STR_32(CODE[2]), STR_29(CODE[2]), STR_28(CODE[2]), 
;!		 -> STR_25(CODE[2]), STR_23(CODE[2]), STR_22(CODE[2]), STR_20(CODE[2]), 
;!		 -> STR_18(CODE[2]), transmitUart1@bufferTx1(BANK2[45]), readDevide@bufferHorario(BANK2[5]), readDevide@bufferEnable(BANK2[5]), 
;!		 -> STR_3(CODE[25]), ap(BANK2[76]), anaT1(BANK1[69]), 
;!
;!    strlen@a	PTR const unsigned char  size(2) Largest target is 76
;!		 -> ?_printf(BANK0[2]), stoa@nuls(BANK0[7]), dbuf(BANK2[32]), ?_sprintf(BANK2[2]), 
;!		 -> extraerFrame@buffer(BANK0[10]), STR_39(CODE[2]), STR_37(CODE[2]), STR_35(CODE[2]), 
;!		 -> STR_33(CODE[2]), STR_32(CODE[2]), STR_29(CODE[2]), STR_28(CODE[2]), 
;!		 -> STR_25(CODE[2]), STR_23(CODE[2]), STR_22(CODE[2]), STR_20(CODE[2]), 
;!		 -> STR_18(CODE[2]), transmitUart1@bufferTx1(BANK2[45]), readDevide@bufferHorario(BANK2[5]), readDevide@bufferEnable(BANK2[5]), 
;!		 -> STR_3(CODE[25]), ap(BANK2[76]), anaT1(BANK1[69]), 
;!
;!    printf@fmt	PTR const unsigned char  size(2) Largest target is 27
;!		 -> STR_2(CODE[24]), STR_1(CODE[27]), 
;!
;!    printf@ap	PTR void [1] size(2) Largest target is 2
;!		 -> ?_printf(BANK0[2]), ?_sprintf(BANK2[2]), 
;!
;!    fputs@s	PTR const unsigned char  size(2) Largest target is 32
;!		 -> dbuf(BANK2[32]), 
;!
;!    fputs@fp	PTR struct _IO_FILE size(2) Largest target is 11
;!		 -> sprintf@f(BANK2[11]), NULL(NULL[0]), 
;!
;!    fputc@fp...source	PTR const unsigned char  size(2) Largest target is 0
;!
;!    fputc@fp...buffer	PTR unsigned char  size(2) Largest target is 0
;!
;!    fputc@fp	PTR struct _IO_FILE size(2) Largest target is 11
;!		 -> sprintf@f(BANK2[11]), NULL(NULL[0]), 
;!
;!    vfprintf@ap	PTR PTR void  size(2) Largest target is 1
;!		 -> printf@ap(BANK0[2]), sprintf@ap(BANK2[2]), 
;!
;!    vfprintf@fp	PTR struct _IO_FILE size(2) Largest target is 11
;!		 -> sprintf@f(BANK2[11]), NULL(NULL[0]), 
;!
;!    vfprintf@fmt	PTR const unsigned char  size(2) Largest target is 43
;!		 -> STR_16(CODE[4]), STR_15(CODE[3]), STR_14(CODE[3]), STR_13(CODE[3]), 
;!		 -> STR_12(CODE[4]), STR_11(CODE[38]), STR_10(CODE[36]), STR_9(CODE[36]), 
;!		 -> STR_8(CODE[36]), STR_7(CODE[36]), STR_6(CODE[43]), STR_5(CODE[18]), 
;!		 -> STR_4(CODE[11]), STR_2(CODE[24]), STR_1(CODE[27]), 
;!
;!    vfprintf@cfmt	PTR unsigned char  size(2) Largest target is 43
;!		 -> STR_16(CODE[4]), STR_15(CODE[3]), STR_14(CODE[3]), STR_13(CODE[3]), 
;!		 -> STR_12(CODE[4]), STR_11(CODE[38]), STR_10(CODE[36]), STR_9(CODE[36]), 
;!		 -> STR_8(CODE[36]), STR_7(CODE[36]), STR_6(CODE[43]), STR_5(CODE[18]), 
;!		 -> STR_4(CODE[11]), STR_2(CODE[24]), STR_1(CODE[27]), 
;!
;!    vfpfcnvrt@cp	PTR unsigned char  size(2) Largest target is 2
;!		 -> ?_printf(BANK0[2]), ?_sprintf(BANK2[2]), readDevide@bufferHorario(BANK2[5]), readDevide@bufferEnable(BANK2[5]), 
;!
;!    vfpfcnvrt@fp	PTR struct _IO_FILE size(2) Largest target is 11
;!		 -> sprintf@f(BANK2[11]), NULL(NULL[0]), 
;!
;!    vfpfcnvrt@ap	PTR PTR void  size(2) Largest target is 1
;!		 -> printf@ap(BANK0[2]), sprintf@ap(BANK2[2]), 
;!
;!    vfpfcnvrt@fmt	PTR PTR unsigned char  size(2) Largest target is 2
;!		 -> vfprintf@cfmt(BANK1[2]), 
;!
;!    stoa@fp	PTR struct _IO_FILE size(2) Largest target is 11
;!		 -> sprintf@f(BANK2[11]), NULL(NULL[0]), 
;!
;!    stoa@s	PTR unsigned char  size(2) Largest target is 2
;!		 -> ?_printf(BANK0[2]), ?_sprintf(BANK2[2]), readDevide@bufferHorario(BANK2[5]), readDevide@bufferEnable(BANK2[5]), 
;!
;!    stoa@cp	PTR unsigned char  size(2) Largest target is 7
;!		 -> ?_printf(BANK0[2]), stoa@nuls(BANK0[7]), ?_sprintf(BANK2[2]), readDevide@bufferHorario(BANK2[5]), 
;!		 -> readDevide@bufferEnable(BANK2[5]), 
;!
;!    dtoa@fp	PTR struct _IO_FILE size(2) Largest target is 11
;!		 -> sprintf@f(BANK2[11]), NULL(NULL[0]), 
;!
;!    pad@fp	PTR struct _IO_FILE size(2) Largest target is 11
;!		 -> sprintf@f(BANK2[11]), NULL(NULL[0]), 
;!
;!    pad@buf	PTR unsigned char  size(2) Largest target is 32
;!		 -> dbuf(BANK2[32]), 
;!
;!    sprintf@fmt	PTR const unsigned char  size(2) Largest target is 43
;!		 -> STR_16(CODE[4]), STR_15(CODE[3]), STR_14(CODE[3]), STR_13(CODE[3]), 
;!		 -> STR_12(CODE[4]), STR_11(CODE[38]), STR_10(CODE[36]), STR_9(CODE[36]), 
;!		 -> STR_8(CODE[36]), STR_7(CODE[36]), STR_6(CODE[43]), STR_5(CODE[18]), 
;!		 -> STR_4(CODE[11]), 
;!
;!    sprintf@s	PTR unsigned char  size(2) Largest target is 76
;!		 -> readDevide@bufferHorario(BANK2[5]), readDevide@bufferEnable(BANK2[5]), ap(BANK2[76]), 
;!
;!    sprintf@ap	PTR void [1] size(2) Largest target is 2
;!		 -> ?_printf(BANK0[2]), ?_sprintf(BANK2[2]), 
;!
;!    S2696$source	PTR const unsigned char  size(2) Largest target is 0
;!
;!    f...source	PTR const unsigned char  size(2) Largest target is 0
;!
;!    S2696$buffer	PTR unsigned char  size(2) Largest target is 0
;!
;!    f...buffer	PTR unsigned char  size(2) Largest target is 0
;!
;!    memset@dest	PTR void  size(2) Largest target is 76
;!		 -> extraerCalendar@buffer(BANK0[4]), extraerHora@buffer(BANK0[4]), extraerFrame@buffer(BANK0[10]), extraerValue@buffer(BANK0[4]), 
;!		 -> transmitUart1@bufferTx1(BANK2[45]), readDevide@bufferHorario(BANK2[5]), readDevide@bufferEnable(BANK2[5]), ap(BANK2[76]), 
;!		 -> anaT1(BANK1[69]), serial1(BANK2[43]), 
;!
;!    memset@s	PTR unsigned char  size(2) Largest target is 76
;!		 -> extraerCalendar@buffer(BANK0[4]), extraerHora@buffer(BANK0[4]), extraerFrame@buffer(BANK0[10]), extraerValue@buffer(BANK0[4]), 
;!		 -> transmitUart1@bufferTx1(BANK2[45]), readDevide@bufferHorario(BANK2[5]), readDevide@bufferEnable(BANK2[5]), ap(BANK2[76]), 
;!		 -> anaT1(BANK1[69]), serial1(BANK2[43]), 
;!
;!    memcpy@d1	PTR void  size(2) Largest target is 69
;!		 -> transmitUart1@bufferTx1(BANK2[45]), anaT1(BANK1[69]), 
;!
;!    memcpy@d	PTR unsigned char  size(2) Largest target is 69
;!		 -> transmitUart1@bufferTx1(BANK2[45]), anaT1(BANK1[69]), 
;!
;!    memcpy@s1	PTR const void  size(2) Largest target is 76
;!		 -> extraerFrame@buffer(BANK0[10]), STR_3(CODE[25]), ap(BANK2[76]), 
;!
;!    memcpy@s	PTR const unsigned char  size(2) Largest target is 76
;!		 -> extraerFrame@buffer(BANK0[10]), STR_3(CODE[25]), ap(BANK2[76]), 
;!
;!    atoi@s	PTR const unsigned char  size(2) Largest target is 69
;!		 -> extraerCalendar@buffer(BANK0[4]), extraerHora@buffer(BANK0[4]), extraerValue@buffer(BANK0[4]), anaT1.buffer2(BANK1[10]), 
;!		 -> anaT1(BANK1[69]), 
;!
;!    extraerCalendar@diaSema	PTR unsigned char  size(2) Largest target is 69
;!		 -> anaT1(BANK1[69]), 
;!
;!    extraerCalendar@ano	PTR unsigned char  size(2) Largest target is 69
;!		 -> anaT1(BANK1[69]), 
;!
;!    extraerCalendar@mes	PTR unsigned char  size(2) Largest target is 69
;!		 -> anaT1(BANK1[69]), 
;!
;!    extraerCalendar@dia	PTR unsigned char  size(2) Largest target is 69
;!		 -> anaT1(BANK1[69]), 
;!
;!    extraerCalendar@orig	PTR unsigned char  size(2) Largest target is 69
;!		 -> anaT1(BANK1[69]), 
;!
;!    extraerHora@min	PTR unsigned char  size(2) Largest target is 69
;!		 -> anaT1(BANK1[69]), 
;!
;!    extraerHora@hor	PTR unsigned char  size(2) Largest target is 69
;!		 -> anaT1(BANK1[69]), 
;!
;!    extraerHora@orig	PTR unsigned char  size(2) Largest target is 69
;!		 -> anaT1(BANK1[69]), 
;!
;!    extraerFrame@end	PTR unsigned char  size(2) Largest target is 2
;!		 -> STR_40(CODE[2]), STR_38(CODE[2]), STR_36(CODE[2]), STR_26(CODE[2]), 
;!		 -> STR_24(CODE[2]), 
;!
;!    extraerFrame@init	PTR unsigned char  size(2) Largest target is 2
;!		 -> STR_39(CODE[2]), STR_37(CODE[2]), STR_35(CODE[2]), STR_25(CODE[2]), 
;!		 -> STR_23(CODE[2]), 
;!
;!    extraerFrame@orig	PTR unsigned char  size(2) Largest target is 69
;!		 -> anaT1(BANK1[69]), 
;!
;!    extraerFrame@ptrData	PTR unsigned char  size(2) Largest target is 69
;!		 -> NULL(NULL[0]), anaT1.bufferRx(BANK1[40]), anaT1(BANK1[69]), 
;!
;!    extraerFrame@dest	PTR unsigned char  size(2) Largest target is 69
;!		 -> anaT1(BANK1[69]), 
;!
;!    extraerValue@end	PTR unsigned char  size(2) Largest target is 2
;!		 -> STR_34(CODE[2]), STR_30(CODE[2]), 
;!
;!    extraerValue@init	PTR unsigned char  size(2) Largest target is 2
;!		 -> STR_33(CODE[2]), STR_29(CODE[2]), 
;!
;!    extraerValue@orig	PTR unsigned char  size(2) Largest target is 69
;!		 -> anaT1(BANK1[69]), 
;!
;!    extraerValue@ptrData	PTR unsigned char  size(2) Largest target is 69
;!		 -> NULL(NULL[0]), anaT1.bufferRx(BANK1[40]), anaT1(BANK1[69]), 
;!
;!    sp__strstr	PTR unsigned char  size(2) Largest target is 69
;!		 -> NULL(NULL[0]), anaT1.bufferRx(BANK1[40]), anaT1(BANK1[69]), 
;!
;!    taskAnalizaUart1@pt	PTR struct pt size(2) Largest target is 2
;!		 -> ptTaskAnalizaUart1(BANK1[2]), 
;!
;!    receiverUart1@dest	PTR unsigned char  size(1) Largest target is 1
;!		 -> INT_isr@ch(COMRAM[1]), 
;!
;!    sp__memcpy	PTR void  size(2) Largest target is 69
;!		 -> transmitUart1@bufferTx1(BANK2[45]), anaT1(BANK1[69]), 
;!
;!    transmitUart1@ptr	PTR unsigned char  size(2) Largest target is 76
;!		 -> STR_3(CODE[25]), ap(BANK2[76]), 
;!
;!    taskLedLive@pt	PTR struct pt size(2) Largest target is 2
;!		 -> ptTaskLedLive(BANK1[2]), 
;!
;!    leerRTC@diaSe	PTR unsigned char  size(1) Largest target is 7
;!		 -> rtc(BANK0[7]), 
;!
;!    leerRTC@ano	PTR unsigned char  size(1) Largest target is 7
;!		 -> rtc(BANK0[7]), 
;!
;!    leerRTC@mes	PTR unsigned char  size(1) Largest target is 7
;!		 -> rtc(BANK0[7]), 
;!
;!    leerRTC@dia	PTR unsigned char  size(1) Largest target is 7
;!		 -> rtc(BANK0[7]), 
;!
;!    leerRTC@segundos	PTR unsigned char  size(1) Largest target is 7
;!		 -> rtc(BANK0[7]), 
;!
;!    leerRTC@minutos	PTR unsigned char  size(1) Largest target is 7
;!		 -> rtc(BANK0[7]), 
;!
;!    leerRTC@hora	PTR unsigned char  size(1) Largest target is 7
;!		 -> rtc(BANK0[7]), 
;!
;!    leerRtcSeg@segundos	PTR unsigned char  size(1) Largest target is 7
;!		 -> rtc(BANK0[7]), 
;!
;!    taskCluster@pt	PTR struct pt size(2) Largest target is 2
;!		 -> ptTaskCluster(BANK1[2]), 
;!
;!    taskBuzzer@pt	PTR struct pt size(2) Largest target is 2
;!		 -> ptTaskBuzzer(BANK1[2]), 
;!
;!    convOnOff@dest	PTR unsigned char  size(2) Largest target is 5
;!		 -> readDevide@bufferEnable(BANK2[5]), 
;!
;!    convStringDayWeek@dest	PTR unsigned char  size(2) Largest target is 5
;!		 -> readDevide@bufferHorario(BANK2[5]), 
;!
;!    sp__memset	PTR void  size(2) Largest target is 76
;!		 -> extraerCalendar@buffer(BANK0[4]), extraerHora@buffer(BANK0[4]), extraerFrame@buffer(BANK0[10]), extraerValue@buffer(BANK0[4]), 
;!		 -> transmitUart1@bufferTx1(BANK2[45]), readDevide@bufferHorario(BANK2[5]), readDevide@bufferEnable(BANK2[5]), ap(BANK2[76]), 
;!		 -> anaT1(BANK1[69]), serial1(BANK2[43]), 
;!
;!    cleanBuffer@orig	PTR unsigned char  size(2) Largest target is 76
;!		 -> ap(BANK2[76]), 
;!
;!    reiniciarTemporizador@time	PTR unsigned int  size(2) Largest target is 76
;!		 -> ap(BANK2[76]), 
;!
;!    taskAplicacion@pt	PTR struct pt size(2) Largest target is 2
;!		 -> ptTaskAplicacion(BANK1[2]), 
;!
;!    taskAlarm@pt	PTR struct pt size(2) Largest target is 2
;!		 -> ptTaskAlarm(BANK1[2]), 
;!


;!
;!Critical Paths under _main in COMRAM
;!
;!    None.
;!
;!Critical Paths under _INT_ISR_LOW in COMRAM
;!
;!    i1_vfprintf->i1_vfpfcnvrt
;!    i1_vfpfcnvrt->i1_dtoa
;!    i1_stoa->i1_fputc
;!    i1_dtoa->i1_pad
;!    i1_pad->i1_fputs
;!    i1_fputs->i1_fputc
;!    i1_fputc->i1_putch
;!    i1_putch->i1_UART_write
;!    i1_abs->i1___aomod
;!
;!Critical Paths under _INT_isr in COMRAM
;!
;!    _INT_isr->_receiverUart1
;!
;!Critical Paths under _main in BANK0
;!
;!    _executeTaskLedLive->_taskLedLive
;!    _taskLedLive->_getMillis
;!    _executeTaskCluster->_taskCluster
;!    _taskCluster->_getMillis
;!    _executeTaskBuzzer->_taskBuzzer
;!    _taskBuzzer->_getMillis
;!    _taskAplicacion->___fladd
;!    _readMemoriaValues->_EEpromRead
;!    _transmitUart1->_memset
;!    _vfprintf->_vfpfcnvrt
;!    _vfpfcnvrt->_dtoa
;!    _stoa->_fputc
;!    _dtoa->_pad
;!    _pad->_fputs
;!    _fputs->_fputc
;!    _fputc->_putch
;!    _putch->_UART_write
;!    _abs->___aomod
;!    _cleanBuffer->_memset
;!    _executeTaskAnalizaUart1->_taskAnalizaUart1
;!    _taskAnalizaUart1->_extraerFrame
;!    _extraerValue->_atoi
;!    _extraerValue->_strstr
;!    _extraerHora->_atoi
;!    _extraerFrame->_strstr
;!    _strstr->_strncmp
;!    _memcpy->_strlen
;!    _extraerCalendar->_atoi
;!    _memset->_strlen
;!    _atoi->_isspace
;!    _escribirRTC->_Decimal_a_BCD
;!    _Decimal_a_BCD->___lbdiv
;!    _Decimal_a_BCD->___lbmod
;!    _executeTaskAlarm->_taskAlarm
;!    _taskAlarm->_leerRTC
;!    _leerRtcSeg->_I2C_Master_Read
;!    _leerRTC->_I2C_Master_Read
;!    _I2C_Stop->_I2C_Master_Wait
;!    _I2C_Start->_I2C_Master_Wait
;!    _I2C_Repeated_Start->_I2C_Master_Wait
;!    _I2C_Master_Write->_I2C_Master_Wait
;!    _I2C_Master_Read->_I2C_Master_Wait
;!    _I2C_Master_Init->___fltol
;!    ___xxtofl->_ADC_read
;!    ___fltol->___fladd
;!    ___flmul->___xxtofl
;!    ___fldiv->___flmul
;!    ___fladd->___fldiv
;!
;!Critical Paths under _INT_ISR_LOW in BANK0
;!
;!    _INT_ISR_LOW->_printf
;!    _printf->i1_vfprintf
;!    i1_vfprintf->i1_vfpfcnvrt
;!
;!Critical Paths under _INT_isr in BANK0
;!
;!    None.
;!
;!Critical Paths under _main in BANK1
;!
;!    _sprintf->_vfprintf
;!    _vfpfcnvrt->_dtoa
;!    _I2C_Master_Init->___fladd
;!    ___fltol->___fladd
;!    ___fladd->___fldiv
;!
;!Critical Paths under _INT_ISR_LOW in BANK1
;!
;!    None.
;!
;!Critical Paths under _INT_isr in BANK1
;!
;!    None.
;!
;!Critical Paths under _main in BANK2
;!
;!    _executeTaskAplicacion->_taskAplicacion
;!    _taskAplicacion->_readDevide
;!    _readDevide->_convOnOff
;!    _readDevide->_convStringDayWeek
;!    _convStringDayWeek->_sprintf
;!    _convOnOff->_sprintf
;!    _sprintf->_vfprintf
;!    _vfprintf->_vfpfcnvrt
;!    _I2C_Master_Init->___fltol
;!    ___fltol->___fladd
;!
;!Critical Paths under _INT_ISR_LOW in BANK2
;!
;!    None.
;!
;!Critical Paths under _INT_isr in BANK2
;!
;!    None.
;!
;!Critical Paths under _main in BANK3
;!
;!    None.
;!
;!Critical Paths under _INT_ISR_LOW in BANK3
;!
;!    None.
;!
;!Critical Paths under _INT_isr in BANK3
;!
;!    None.
;!
;!Critical Paths under _main in BANK4
;!
;!    None.
;!
;!Critical Paths under _INT_ISR_LOW in BANK4
;!
;!    None.
;!
;!Critical Paths under _INT_isr in BANK4
;!
;!    None.
;!
;!Critical Paths under _main in BANK5
;!
;!    None.
;!
;!Critical Paths under _INT_ISR_LOW in BANK5
;!
;!    None.
;!
;!Critical Paths under _INT_isr in BANK5
;!
;!    None.
;!
;!Critical Paths under _main in BANK6
;!
;!    None.
;!
;!Critical Paths under _INT_ISR_LOW in BANK6
;!
;!    None.
;!
;!Critical Paths under _INT_isr in BANK6
;!
;!    None.
;!
;!Critical Paths under _main in BANK7
;!
;!    None.
;!
;!Critical Paths under _INT_ISR_LOW in BANK7
;!
;!    None.
;!
;!Critical Paths under _INT_isr in BANK7
;!
;!    None.

;;
;;Main: autosize = 0, tempsize = 0, incstack = 0, save=0
;;

;!
;!Call Graph Tables:
;!
;! ---------------------------------------------------------------------------------
;! (Depth) Function   	        Calls       Base Space   Used Autos Params    Refs
;! ---------------------------------------------------------------------------------
;! (0) _main                                                 0     0      0  311642
;!                           _ADC_init
;!                    _I2C_Master_Init
;!                           _INT_init
;!                     _UART_init_baud
;!                   _executeTaskAlarm
;!            _executeTaskAnalizaUart1
;!              _executeTaskAplicacion
;!                  _executeTaskBuzzer
;!                 _executeTaskCluster
;!                 _executeTaskLedLive
;!                      _pinConfBuzzer
;!                     _pinConfCluster
;!                      _pinConfLedPin
;!                     _startTaskAlarm
;!              _startTaskAnalizaUart1
;!                _startTaskAplicacion
;!                    _startTaskBuzzer
;!                   _startTaskCluster
;!                   _startTaskLedLive
;! ---------------------------------------------------------------------------------
;! (1) _startTaskLedLive                                     0     0      0       0
;! ---------------------------------------------------------------------------------
;! (1) _startTaskCluster                                     0     0      0       0
;! ---------------------------------------------------------------------------------
;! (1) _startTaskBuzzer                                      0     0      0       0
;! ---------------------------------------------------------------------------------
;! (1) _startTaskAplicacion                                  0     0      0       0
;! ---------------------------------------------------------------------------------
;! (1) _startTaskAnalizaUart1                                0     0      0       0
;! ---------------------------------------------------------------------------------
;! (1) _startTaskAlarm                                       0     0      0       0
;! ---------------------------------------------------------------------------------
;! (1) _pinConfLedPin                                        0     0      0       0
;! ---------------------------------------------------------------------------------
;! (1) _pinConfCluster                                       0     0      0       0
;! ---------------------------------------------------------------------------------
;! (1) _pinConfBuzzer                                        0     0      0       0
;! ---------------------------------------------------------------------------------
;! (1) _executeTaskLedLive                                   0     0      0     189
;!                        _taskLedLive
;! ---------------------------------------------------------------------------------
;! (2) _taskLedLive                                          5     3      2     189
;!                                             41 BANK0      4     2      2
;!                          _getMillis
;! ---------------------------------------------------------------------------------
;! (1) _executeTaskCluster                                   0     0      0     189
;!                        _taskCluster
;! ---------------------------------------------------------------------------------
;! (2) _taskCluster                                          5     3      2     189
;!                                             41 BANK0      4     2      2
;!                          _getMillis
;!                            _oneBeep
;! ---------------------------------------------------------------------------------
;! (1) _executeTaskBuzzer                                    0     0      0     189
;!                         _taskBuzzer
;! ---------------------------------------------------------------------------------
;! (2) _taskBuzzer                                           5     3      2     189
;!                                             41 BANK0      4     2      2
;!                          _getMillis
;! ---------------------------------------------------------------------------------
;! (1) _executeTaskAplicacion                                0     0      0  207968
;!                     _taskAplicacion
;! ---------------------------------------------------------------------------------
;! (2) _taskAplicacion                                       5     3      2  207968
;!                                             66 BANK2      4     2      2
;!                           _ADC_read
;!                         _EEpromRead
;!                        _EEpromWrite
;!                            ___fladd
;!                            ___flmul
;!                           ___xxtofl
;!                      _cambiarEstado
;!                          _getMillis
;!                       _inicioEstado
;!                            _oneBeep
;!                         _readDevide
;!                  _readMemoriaValues
;!              _reiniciarTemporizador
;!                      _transmitUart1
;!                            _twoBeep
;! ---------------------------------------------------------------------------------
;! (3) _twoBeep                                              0     0      0       0
;! ---------------------------------------------------------------------------------
;! (3) _reiniciarTemporizador                                2     0      2     250
;!                                             37 BANK0      2     0      2
;! ---------------------------------------------------------------------------------
;! (3) _readMemoriaValues                                    0     0      0    2758
;!                         _EEpromRead
;! ---------------------------------------------------------------------------------
;! (4) _EEpromRead                                           2     0      2    2758
;!                                             37 BANK0      2     0      2
;! ---------------------------------------------------------------------------------
;! (3) _readDevide                                          10    10      0  164804
;!                                             56 BANK2     10    10      0
;!                        _cleanBuffer
;!                          _convOnOff
;!                  _convStringDayWeek
;!                            _sprintf
;!                      _transmitUart1
;! ---------------------------------------------------------------------------------
;! (3) _transmitUart1                                       52    50      2   10960
;!                                             53 BANK0      3     1      2
;!                                              0 BANK2     49    49      0
;!                             _memcpy
;!                             _memset
;!                             _strlen
;! ---------------------------------------------------------------------------------
;! (4) _convStringDayWeek                                    3     0      3   50659
;!                                             53 BANK2      3     0      3
;!                             _memset
;!                            _sprintf
;!                             _strlen
;! ---------------------------------------------------------------------------------
;! (4) _convOnOff                                            3     0      3   50485
;!                                             53 BANK2      3     0      3
;!                             _memset
;!                            _sprintf
;!                             _strlen
;! ---------------------------------------------------------------------------------
;! (4) _sprintf                                             31    15     16   41140
;!                                             24 BANK2     29    13     16
;!                           _vfprintf
;! ---------------------------------------------------------------------------------
;! (5) _vfprintf                                             8     2      6   35487
;!                                             18 BANK1      2     2      0
;!                                             18 BANK2      6     0      6
;!                          _vfpfcnvrt
;! ---------------------------------------------------------------------------------
;! (6) _vfpfcnvrt                                           43    37      6   33468
;!                                             84 BANK0      2     2      0
;!                                              0 BANK2     18    12      6
;!                               _dtoa
;!                              _fputc
;!                               _stoa
;!                            _strncmp
;! ---------------------------------------------------------------------------------
;! (7) _stoa                                                22    18      4    7858
;!                                             48 BANK0     22    18      4
;!                              _fputc
;!                             _strlen
;! ---------------------------------------------------------------------------------
;! (7) _dtoa                                                36    26     10   17677
;!                                             66 BANK0     18     8     10
;!                                              0 BANK1     18    18      0
;!                            ___aodiv
;!                            ___aomod
;!                                _abs
;!                                _pad
;! ---------------------------------------------------------------------------------
;! (8) _pad                                                 11     5      6   11433
;!                                             55 BANK0     11     5      6
;!                              _fputc
;!                              _fputs
;!                             _strlen
;! ---------------------------------------------------------------------------------
;! (9) _fputs                                                7     3      4    4465
;!                                             48 BANK0      7     3      4
;!                              _fputc
;! ---------------------------------------------------------------------------------
;! (8) _fputc                                                9     5      4    3379
;!                                             39 BANK0      9     5      4
;!                              _putch
;! ---------------------------------------------------------------------------------
;! (9) _putch                                                1     1      0     174
;!                                             38 BANK0      1     1      0
;!                         _UART_write
;! ---------------------------------------------------------------------------------
;! (10) _UART_write                                          1     1      0      87
;!                                             37 BANK0      1     1      0
;! ---------------------------------------------------------------------------------
;! (8) _abs                                                  4     2      2     427
;!                                             55 BANK0      4     2      2
;!                            ___aomod (ARG)
;! ---------------------------------------------------------------------------------
;! (8) ___aomod                                             18     2     16    1673
;!                                             37 BANK0     18     2     16
;! ---------------------------------------------------------------------------------
;! (8) ___aodiv                                             26    10     16    1757
;!                                             37 BANK0     26    10     16
;! ---------------------------------------------------------------------------------
;! (4) _cleanBuffer                                          2     0      2    8752
;!                                             53 BANK0      2     0      2
;!                             _memset
;!                             _strlen
;! ---------------------------------------------------------------------------------
;! (3) _oneBeep                                              0     0      0       0
;! ---------------------------------------------------------------------------------
;! (3) _inicioEstado                                         2     0      2     348
;!                                             37 BANK0      2     0      2
;! ---------------------------------------------------------------------------------
;! (3) _cambiarEstado                                        2     0      2     478
;!                                             37 BANK0      2     0      2
;! ---------------------------------------------------------------------------------
;! (3) _ADC_read                                             5     3      2      22
;!                                             37 BANK0      5     3      2
;! ---------------------------------------------------------------------------------
;! (1) _executeTaskAnalizaUart1                              0     0      0   83539
;!                   _taskAnalizaUart1
;! ---------------------------------------------------------------------------------
;! (2) _taskAnalizaUart1                                     7     5      2   83539
;!                                             76 BANK0      6     4      2
;!                        _EEpromWrite
;!                               _atoi
;!                        _escribirRTC
;!                    _extraerCalendar
;!                       _extraerFrame
;!                        _extraerHora
;!                       _extraerValue
;!                          _getMillis
;!                             _memset
;!                             _strstr
;! ---------------------------------------------------------------------------------
;! (3) _extraerValue                                        15     9      6   16960
;!                                             54 BANK0     15     9      6
;!                               _atoi
;!                             _memset
;!                             _strstr
;! ---------------------------------------------------------------------------------
;! (3) _extraerHora                                         12     6      6    8641
;!                                             54 BANK0     12     6      6
;!                               _atoi
;!                             _memset
;! ---------------------------------------------------------------------------------
;! (3) _extraerFrame                                        22    14      8   20742
;!                                             54 BANK0     22    14      8
;!                             _memcpy
;!                             _memset
;!                             _strlen
;!                             _strstr
;! ---------------------------------------------------------------------------------
;! (3) _strstr                                               6     2      4    7497
;!                                             48 BANK0      6     2      4
;!                             _strchr
;!                             _strlen
;!                            _strncmp
;! ---------------------------------------------------------------------------------
;! (7) _strncmp                                             11     5      6    1971
;!                                             37 BANK0     11     5      6
;! ---------------------------------------------------------------------------------
;! (4) _strlen                                               4     2      2    2050
;!                                             37 BANK0      4     2      2
;! ---------------------------------------------------------------------------------
;! (4) _strchr                                               5     1      4     240
;!                                             37 BANK0      5     1      4
;! ---------------------------------------------------------------------------------
;! (4) _memcpy                                              11     5      6     926
;!                                             41 BANK0     11     5      6
;!                             _strlen (ARG)
;! ---------------------------------------------------------------------------------
;! (3) _extraerCalendar                                     18     8     10    8763
;!                                             54 BANK0     18     8     10
;!                               _atoi
;!                             _memset
;! ---------------------------------------------------------------------------------
;! (4) _memset                                              12     6      6    5200
;!                                             41 BANK0     12     6      6
;!                             _strlen (ARG)
;! ---------------------------------------------------------------------------------
;! (4) _atoi                                                10     8      2    1720
;!                                             44 BANK0     10     8      2
;!                             ___wmul
;!                            _isdigit
;!                            _isspace
;! ---------------------------------------------------------------------------------
;! (5) _isspace                                              7     5      2     207
;!                                             37 BANK0      7     5      2
;! ---------------------------------------------------------------------------------
;! (5) _isdigit                                              6     4      2     161
;!                                             37 BANK0      6     4      2
;! ---------------------------------------------------------------------------------
;! (5) ___wmul                                               6     2      4     495
;!                                             37 BANK0      6     2      4
;! ---------------------------------------------------------------------------------
;! (3) _escribirRTC                                         22    16      6    1432
;!                                             43 BANK0     22    16      6
;!                      _Decimal_a_BCD
;!                   _I2C_Master_Write
;!                          _I2C_Start
;!                           _I2C_Stop
;! ---------------------------------------------------------------------------------
;! (4) _Decimal_a_BCD                                        2     2      0     517
;!                                             41 BANK0      2     2      0
;!                            ___lbdiv
;!                            ___lbmod
;! ---------------------------------------------------------------------------------
;! (5) ___lbmod                                              4     3      1     235
;!                                             37 BANK0      4     3      1
;! ---------------------------------------------------------------------------------
;! (5) ___lbdiv                                              4     3      1     238
;!                                             37 BANK0      4     3      1
;! ---------------------------------------------------------------------------------
;! (3) _EEpromWrite                                          3     0      3   11596
;!                                             37 BANK0      3     0      3
;! ---------------------------------------------------------------------------------
;! (1) _executeTaskAlarm                                     0     0      0    2482
;!                          _taskAlarm
;! ---------------------------------------------------------------------------------
;! (2) _taskAlarm                                            5     3      2    2482
;!                                             63 BANK0      4     2      2
;!                          _getMillis
;!                            _leerRTC
;!                         _leerRtcSeg
;! ---------------------------------------------------------------------------------
;! (3) _leerRtcSeg                                           2     1      1     266
;!                                             41 BANK0      1     0      1
;!                      _BCD_a_Decimal
;!                    _I2C_Master_Read
;!                   _I2C_Master_Write
;!                 _I2C_Repeated_Start
;!                          _I2C_Start
;!                           _I2C_Stop
;! ---------------------------------------------------------------------------------
;! (3) _leerRTC                                             22    15      7    2027
;!                                             41 BANK0     22    15      7
;!                      _BCD_a_Decimal
;!                    _I2C_Master_Read
;!                   _I2C_Master_Write
;!                 _I2C_Repeated_Start
;!                          _I2C_Start
;!                           _I2C_Stop
;! ---------------------------------------------------------------------------------
;! (4) _I2C_Stop                                             0     0      0       0
;!                    _I2C_Master_Wait
;! ---------------------------------------------------------------------------------
;! (4) _I2C_Start                                            0     0      0       0
;!                    _I2C_Master_Wait
;! ---------------------------------------------------------------------------------
;! (4) _I2C_Repeated_Start                                   0     0      0       0
;!                    _I2C_Master_Wait
;! ---------------------------------------------------------------------------------
;! (4) _I2C_Master_Write                                     1     1      0      22
;!                                             38 BANK0      1     1      0
;!                    _I2C_Master_Wait
;! ---------------------------------------------------------------------------------
;! (4) _I2C_Master_Read                                      3     3      0      45
;!                                             38 BANK0      3     3      0
;!                    _I2C_Master_Wait
;! ---------------------------------------------------------------------------------
;! (5) _I2C_Master_Wait                                      1     1      0       0
;!                                             37 BANK0      1     1      0
;! ---------------------------------------------------------------------------------
;! (4) _BCD_a_Decimal                                        2     2      0      44
;!                                             37 BANK0      2     2      0
;! ---------------------------------------------------------------------------------
;! (3) _getMillis                                            4     0      4       0
;!                                             37 BANK0      4     0      4
;! ---------------------------------------------------------------------------------
;! (1) _UART_init_baud                                       4     0      4      76
;!                                             37 BANK0      4     0      4
;! ---------------------------------------------------------------------------------
;! (1) _INT_init                                             0     0      0       0
;! ---------------------------------------------------------------------------------
;! (1) _I2C_Master_Init                                      4     0      4   17010
;!                                             16 BANK2      4     0      4
;!                            ___fladd
;!                            ___fldiv
;!                            ___flmul
;!                            ___fltol
;!                           ___xxtofl
;! ---------------------------------------------------------------------------------
;! (3) ___xxtofl                                            14    10      4     550
;!                                             42 BANK0     14    10      4
;!                           _ADC_read (ARG)
;! ---------------------------------------------------------------------------------
;! (2) ___fltol                                             10     6      4    1225
;!                                             97 BANK0      2     2      0
;!                                              8 BANK2      8     4      4
;!                            ___fladd (ARG)
;!                            ___fldiv (ARG)
;!                            ___flmul (ARG)
;!                           ___xxtofl (ARG)
;! ---------------------------------------------------------------------------------
;! (3) ___flmul                                             25    17      8    2505
;!                                             56 BANK0     25    17      8
;!                           ___xxtofl (ARG)
;! ---------------------------------------------------------------------------------
;! (2) ___fldiv                                             25    17      8    2007
;!                                             81 BANK0     12     4      8
;!                                              0 BANK1     13    13      0
;!                            ___flmul (ARG)
;!                           ___xxtofl (ARG)
;! ---------------------------------------------------------------------------------
;! (3) ___fladd                                             16     8      8   10470
;!                                             93 BANK0      4     4      0
;!                                             13 BANK1      4     4      0
;!                                              0 BANK2      8     0      8
;!                            ___fldiv (ARG)
;!                            ___flmul (ARG)
;!                           ___xxtofl (ARG)
;! ---------------------------------------------------------------------------------
;! (1) _ADC_init                                             0     0      0       0
;! ---------------------------------------------------------------------------------
;! Estimated maximum stack depth 10
;! ---------------------------------------------------------------------------------
;! (Depth) Function   	        Calls       Base Space   Used Autos Params    Refs
;! ---------------------------------------------------------------------------------
;! (14) _INT_ISR_LOW                                        13    13      0   25998
;!                                             24 BANK0     13    13      0
;!                             _printf
;! ---------------------------------------------------------------------------------
;! (15) _printf                                              6     4      2   25998
;!                                             20 BANK0      4     2      2
;!                         i1_vfprintf
;! ---------------------------------------------------------------------------------
;! (16) i1_vfprintf                                          8     2      6   25271
;!                                             12 BANK0      8     2      6
;!                        i1_vfpfcnvrt
;! ---------------------------------------------------------------------------------
;! (17) i1_vfpfcnvrt                                        43    37      6   24122
;!                                             71 COMRAM     8     2      6
;!                                              0 BANK0     12    12      0
;!                             i1_dtoa
;!                            i1_fputc
;!                             i1_stoa
;!                          i1_strncmp
;! ---------------------------------------------------------------------------------
;! (18) i1_strncmp                                          11     5      6    1248
;!                                              6 COMRAM    11     5      6
;! ---------------------------------------------------------------------------------
;! (18) i1_stoa                                             22    18      4    5138
;!                                             17 COMRAM    22    18      4
;!                            i1_fputc
;!                           i1_strlen
;! ---------------------------------------------------------------------------------
;! (18) i1_dtoa                                             36    26     10   13049
;!                                             35 COMRAM    36    26     10
;!                          i1___aodiv
;!                          i1___aomod
;!                              i1_abs
;!                              i1_pad
;! ---------------------------------------------------------------------------------
;! (19) i1_pad                                              11     5      6    7330
;!                                             24 COMRAM    11     5      6
;!                            i1_fputc
;!                            i1_fputs
;!                           i1_strlen
;! ---------------------------------------------------------------------------------
;! (19) i1_strlen                                            4     2      2     572
;!                                              6 COMRAM     4     2      2
;! ---------------------------------------------------------------------------------
;! (20) i1_fputs                                             7     3      4    3115
;!                                             17 COMRAM     7     3      4
;!                            i1_fputc
;! ---------------------------------------------------------------------------------
;! (19) i1_fputc                                             9     5      4    2329
;!                                              8 COMRAM     9     5      4
;!                            i1_putch
;! ---------------------------------------------------------------------------------
;! (20) i1_putch                                             1     1      0     174
;!                                              7 COMRAM     1     1      0
;!                       i1_UART_write
;! ---------------------------------------------------------------------------------
;! (21) i1_UART_write                                        1     1      0      87
;!                                              6 COMRAM     1     1      0
;! ---------------------------------------------------------------------------------
;! (19) i1_abs                                               4     2      2     352
;!                                             24 COMRAM     4     2      2
;!                          i1___aomod (ARG)
;! ---------------------------------------------------------------------------------
;! (19) i1___aomod                                          18     2     16    1523
;!                                              6 COMRAM    18     2     16
;! ---------------------------------------------------------------------------------
;! (19) i1___aodiv                                          26    10     16    1607
;!                                              6 COMRAM    26    10     16
;! ---------------------------------------------------------------------------------
;! Estimated maximum stack depth 21
;! ---------------------------------------------------------------------------------
;! (Depth) Function   	        Calls       Base Space   Used Autos Params    Refs
;! ---------------------------------------------------------------------------------
;! (24) _INT_isr                                             5     5      0     122
;!                                              1 COMRAM     5     5      0
;!                          _UART_read
;!                      _receiverUart1
;! ---------------------------------------------------------------------------------
;! (25) _receiverUart1                                       1     0      1      98
;!                                              0 COMRAM     1     0      1
;! ---------------------------------------------------------------------------------
;! (25) _UART_read                                           0     0      0       0
;! ---------------------------------------------------------------------------------
;! Estimated maximum stack depth 25
;! ---------------------------------------------------------------------------------
;!
;! Call Graph Graphs:
;!
;! _main (ROOT)
;!   _ADC_init
;!   _I2C_Master_Init
;!     ___fladd
;!       ___fldiv (ARG)
;!         ___flmul (ARG)
;!           ___xxtofl (ARG)
;!             _ADC_read (ARG)
;!         ___xxtofl (ARG)
;!       ___flmul (ARG)
;!       ___xxtofl (ARG)
;!     ___fldiv
;!     ___flmul
;!     ___fltol
;!       ___fladd (ARG)
;!       ___fldiv (ARG)
;!       ___flmul (ARG)
;!       ___xxtofl (ARG)
;!     ___xxtofl
;!   _INT_init
;!   _UART_init_baud
;!   _executeTaskAlarm
;!     _taskAlarm
;!       _getMillis
;!       _leerRTC
;!         _BCD_a_Decimal
;!         _I2C_Master_Read
;!           _I2C_Master_Wait
;!         _I2C_Master_Write
;!           _I2C_Master_Wait
;!         _I2C_Repeated_Start
;!           _I2C_Master_Wait
;!         _I2C_Start
;!           _I2C_Master_Wait
;!         _I2C_Stop
;!           _I2C_Master_Wait
;!       _leerRtcSeg
;!         _BCD_a_Decimal
;!         _I2C_Master_Read
;!         _I2C_Master_Write
;!         _I2C_Repeated_Start
;!         _I2C_Start
;!         _I2C_Stop
;!   _executeTaskAnalizaUart1
;!     _taskAnalizaUart1
;!       _EEpromWrite
;!       _atoi
;!         ___wmul
;!         _isdigit
;!         _isspace
;!       _escribirRTC
;!         _Decimal_a_BCD
;!           ___lbdiv
;!           ___lbmod
;!         _I2C_Master_Write
;!         _I2C_Start
;!         _I2C_Stop
;!       _extraerCalendar
;!         _atoi
;!         _memset
;!           _strlen (ARG)
;!       _extraerFrame
;!         _memcpy
;!           _strlen (ARG)
;!         _memset
;!         _strlen
;!         _strstr
;!           _strchr
;!           _strlen
;!           _strncmp
;!       _extraerHora
;!         _atoi
;!         _memset
;!       _extraerValue
;!         _atoi
;!         _memset
;!         _strstr
;!       _getMillis
;!       _memset
;!       _strstr
;!   _executeTaskAplicacion
;!     _taskAplicacion
;!       _ADC_read
;!       _EEpromRead
;!       _EEpromWrite
;!       ___fladd
;!       ___flmul
;!       ___xxtofl
;!       _cambiarEstado
;!       _getMillis
;!       _inicioEstado
;!       _oneBeep
;!       _readDevide
;!         _cleanBuffer
;!           _memset
;!           _strlen
;!         _convOnOff
;!           _memset
;!           _sprintf
;!             _vfprintf
;!               _vfpfcnvrt
;!                 _dtoa
;!                   ___aodiv
;!                   ___aomod
;!                   _abs
;!                     ___aomod (ARG)
;!                   _pad
;!                     _fputc
;!                       _putch
;!                         _UART_write
;!                     _fputs
;!                       _fputc
;!                     _strlen
;!                 _fputc
;!                 _stoa
;!                   _fputc
;!                   _strlen
;!                 _strncmp
;!           _strlen
;!         _convStringDayWeek
;!           _memset
;!           _sprintf
;!           _strlen
;!         _sprintf
;!         _transmitUart1
;!           _memcpy
;!           _memset
;!           _strlen
;!       _readMemoriaValues
;!         _EEpromRead
;!       _reiniciarTemporizador
;!       _transmitUart1
;!       _twoBeep
;!   _executeTaskBuzzer
;!     _taskBuzzer
;!       _getMillis
;!   _executeTaskCluster
;!     _taskCluster
;!       _getMillis
;!       _oneBeep
;!   _executeTaskLedLive
;!     _taskLedLive
;!       _getMillis
;!   _pinConfBuzzer
;!   _pinConfCluster
;!   _pinConfLedPin
;!   _startTaskAlarm
;!   _startTaskAnalizaUart1
;!   _startTaskAplicacion
;!   _startTaskBuzzer
;!   _startTaskCluster
;!   _startTaskLedLive
;!
;! _INT_ISR_LOW (ROOT)
;!   _printf
;!     i1_vfprintf
;!       i1_vfpfcnvrt
;!         i1_dtoa
;!           i1___aodiv
;!           i1___aomod
;!           i1_abs
;!             i1___aomod (ARG)
;!           i1_pad
;!             i1_fputc
;!               i1_putch
;!                 i1_UART_write
;!             i1_fputs
;!               i1_fputc
;!             i1_strlen
;!         i1_fputc
;!         i1_stoa
;!           i1_fputc
;!           i1_strlen
;!         i1_strncmp
;!
;! _INT_isr (ROOT)
;!   _UART_read
;!   _receiverUart1
;!

;! Address spaces:

;!Name               Size   Autos  Total    Cost      Usage
;!BIGRAM             7FF      0       0      34        0.0%
;!EEDATA             100      0       0       0        0.0%
;!BITBANK7           100      0       0      18        0.0%
;!BANK7              100      0       0      19        0.0%
;!BITBANK6           100      0       0      16        0.0%
;!BANK6              100      0       0      17        0.0%
;!BITBANK5           100      0       0      14        0.0%
;!BANK5              100      0       0      15        0.0%
;!BITBANK4           100      0       0      12        0.0%
;!BANK4              100      0       0      13        0.0%
;!BITBANK3           100      0       0      10        0.0%
;!BANK3              100      0       0      11        0.0%
;!BITBANK2           100      0       0       8        0.0%
;!BANK2              100     46      DD       9       86.3%
;!BITBANK1           100      0       0       6        0.0%
;!BANK1              100     14     100       7      100.0%
;!BITBANK0            A0      0       0       4        0.0%
;!BANK0               A0     63      7A       5       76.2%
;!BITCOMRAM           5E      0       0       0        0.0%
;!COMRAM              5E     4F      57       1       92.6%
;!BITBIGSFRlll        29      0       0      32        0.0%
;!BITBIGSFRhhhlhl     18      0       0      22        0.0%
;!BITBIGSFRhhhlll     10      0       0      25        0.0%
;!BITBIGSFRhhhh        D      0       0      20        0.0%
;!BITBIGSFRhll         8      0       0      29        0.0%
;!BITBIGSFRhhhllh      6      0       0      24        0.0%
;!BITBIGSFRlh          6      0       0      30        0.0%
;!BITBIGSFRhlhllh      4      0       0      27        0.0%
;!BITBIGSFRhhhllh      4      0       0      23        0.0%
;!BITBIGSFRhlhlll      2      0       0      28        0.0%
;!BITBIGSFRllh         1      0       0      31        0.0%
;!BITBIGSFRhlhh        1      0       0      26        0.0%
;!BITBIGSFRhhhlhh      1      0       0      21        0.0%
;!BIGSFR               0      0       0     200        0.0%
;!BITSFR               0      0       0     200        0.0%
;!SFR                  0      0       0     200        0.0%
;!STACK                0      0       0       2        0.0%
;!NULL                 0      0       0       0        0.0%
;!ABS                  0      0     2AE      33        0.0%
;!DATA                 0      0     2AE       3        0.0%
;!CODE                 0      0       0       0        0.0%

	global	_main

;; *************** function _main *****************
;; Defined at:
;;		line 112 in file "main.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels required when called: 25
;; This function calls:
;;		_ADC_init
;;		_I2C_Master_Init
;;		_INT_init
;;		_UART_init_baud
;;		_executeTaskAlarm
;;		_executeTaskAnalizaUart1
;;		_executeTaskAplicacion
;;		_executeTaskBuzzer
;;		_executeTaskCluster
;;		_executeTaskLedLive
;;		_pinConfBuzzer
;;		_pinConfCluster
;;		_pinConfLedPin
;;		_startTaskAlarm
;;		_startTaskAnalizaUart1
;;		_startTaskAplicacion
;;		_startTaskBuzzer
;;		_startTaskCluster
;;		_startTaskLedLive
;; This function is called by:
;;		Startup code after reset
;; This function uses a non-reentrant model
;;
psect	text0,class=CODE,space=0,reloc=2,group=0
	file	"main.c"
	line	112
global __ptext0
__ptext0:
psect	text0
	file	"main.c"
	line	112
	
_main:
;incstack = 0
	callstack 6
	line	115
	
l18229:
	movlw	low(0Fh)
	movwf	((c:4033))^0f00h,c	;volatile
	line	116
	
l18231:
	call	_INT_init	;wreg free
	line	117
	
l18233:
	movlw	low(02580h)
	movlb	0	; () banked
	movwf	((UART_init_baud@baudRate))&0ffh
	movlw	high(02580h)
	movwf	((UART_init_baud@baudRate+1))&0ffh
	movlw	low highword(02580h)
	movwf	((UART_init_baud@baudRate+2))&0ffh
	movlw	high highword(02580h)
	movwf	((UART_init_baud@baudRate+3))&0ffh
	call	_UART_init_baud	;wreg free
	line	118
	
l18235:; BSR set to: 0

	call	_ADC_init	;wreg free
	line	120
	call	_pinConfLedPin	;wreg free
	line	121
	
l18237:; BSR set to: 0

	movlw	low(0186A0h)
	movlb	2	; () banked
	movwf	((I2C_Master_Init@clock))&0ffh
	movlw	high(0186A0h)
	movwf	((I2C_Master_Init@clock+1))&0ffh
	movlw	low highword(0186A0h)
	movwf	((I2C_Master_Init@clock+2))&0ffh
	movlw	high highword(0186A0h)
	movwf	((I2C_Master_Init@clock+3))&0ffh
	call	_I2C_Master_Init	;wreg free
	line	122
	
l18239:; BSR set to: 2

	call	_pinConfBuzzer	;wreg free
	line	123
	
l18241:; BSR set to: 2

	call	_pinConfCluster	;wreg free
	line	126
	
l18243:; BSR set to: 2

	call	_startTaskLedLive	;wreg free
	line	127
	
l18245:; BSR set to: 1

	call	_startTaskAnalizaUart1	;wreg free
	line	128
	
l18247:; BSR set to: 1

	call	_startTaskAplicacion	;wreg free
	line	129
	
l18249:; BSR set to: 1

	call	_startTaskAlarm	;wreg free
	line	130
	
l18251:; BSR set to: 1

	call	_startTaskBuzzer	;wreg free
	line	131
	
l18253:; BSR set to: 1

	call	_startTaskCluster	;wreg free
	line	134
	
l18255:
	call	_executeTaskLedLive	;wreg free
	line	135
	
l18257:; BSR set to: 0

	call	_executeTaskAnalizaUart1	;wreg free
	line	136
	
l18259:; BSR set to: 0

	call	_executeTaskAplicacion	;wreg free
	line	137
	
l18261:
	call	_executeTaskAlarm	;wreg free
	line	138
	
l18263:; BSR set to: 0

	call	_executeTaskBuzzer	;wreg free
	line	139
	
l18265:; BSR set to: 0

	call	_executeTaskCluster	;wreg free
	goto	l18255
	global	start
	goto	start
	callstack 0
	line	141
GLOBAL	__end_of_main
	__end_of_main:
	signat	_main,89
	global	_startTaskLedLive

;; *************** function _startTaskLedLive *****************
;; Defined at:
;;		line 95 in file "LedLive.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2
;; Tracked objects:
;;		On entry : 3F/2
;;		On exit  : 3F/1
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text1,class=CODE,space=0,reloc=2,group=0
	file	"LedLive.c"
	line	95
global __ptext1
__ptext1:
psect	text1
	file	"LedLive.c"
	line	95
	
_startTaskLedLive:; BSR set to: 0

;incstack = 0
	callstack 18
	line	96
	
l7883:; BSR set to: 2

	movlw	high(0)
	movlb	1	; () banked
	movwf	((_ptTaskLedLive+1))&0ffh
	movlw	low(0)
	movwf	((_ptTaskLedLive))&0ffh
	line	97
	
l769:; BSR set to: 1

	return	;funcret
	callstack 0
GLOBAL	__end_of_startTaskLedLive
	__end_of_startTaskLedLive:
	signat	_startTaskLedLive,89
	global	_startTaskCluster

;; *************** function _startTaskCluster *****************
;; Defined at:
;;		line 100 in file "Cluster.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2
;; Tracked objects:
;;		On entry : 3F/1
;;		On exit  : 3F/1
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text2,class=CODE,space=0,reloc=2,group=0
	file	"Cluster.c"
	line	100
global __ptext2
__ptext2:
psect	text2
	file	"Cluster.c"
	line	100
	
_startTaskCluster:; BSR set to: 1

;incstack = 0
	callstack 18
	line	102
	
l7893:; BSR set to: 1

	movlw	high(0)
	movwf	((_ptTaskCluster+1))&0ffh
	movlw	low(0)
	movwf	((_ptTaskCluster))&0ffh
	line	103
	
l616:; BSR set to: 1

	return	;funcret
	callstack 0
GLOBAL	__end_of_startTaskCluster
	__end_of_startTaskCluster:
	signat	_startTaskCluster,89
	global	_startTaskBuzzer

;; *************** function _startTaskBuzzer *****************
;; Defined at:
;;		line 121 in file "Buzzer.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2
;; Tracked objects:
;;		On entry : 3F/1
;;		On exit  : 3F/1
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text3,class=CODE,space=0,reloc=2,group=0
	file	"Buzzer.c"
	line	121
global __ptext3
__ptext3:
psect	text3
	file	"Buzzer.c"
	line	121
	
_startTaskBuzzer:; BSR set to: 1

;incstack = 0
	callstack 18
	line	123
	
l7891:; BSR set to: 1

	movlw	high(0)
	movwf	((_ptTaskBuzzer+1))&0ffh
	movlw	low(0)
	movwf	((_ptTaskBuzzer))&0ffh
	line	124
	
l546:; BSR set to: 1

	return	;funcret
	callstack 0
GLOBAL	__end_of_startTaskBuzzer
	__end_of_startTaskBuzzer:
	signat	_startTaskBuzzer,89
	global	_startTaskAplicacion

;; *************** function _startTaskAplicacion *****************
;; Defined at:
;;		line 242 in file "Aplicacion.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2
;; Tracked objects:
;;		On entry : 3F/1
;;		On exit  : 3F/1
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text4,class=CODE,space=0,reloc=2,group=0
	file	"Aplicacion.c"
	line	242
global __ptext4
__ptext4:
psect	text4
	file	"Aplicacion.c"
	line	242
	
_startTaskAplicacion:; BSR set to: 1

;incstack = 0
	callstack 18
	line	244
	
l7887:; BSR set to: 1

	movlw	high(0)
	movwf	((_ptTaskAplicacion+1))&0ffh
	movlw	low(0)
	movwf	((_ptTaskAplicacion))&0ffh
	line	245
	
l457:; BSR set to: 1

	return	;funcret
	callstack 0
GLOBAL	__end_of_startTaskAplicacion
	__end_of_startTaskAplicacion:
	signat	_startTaskAplicacion,89
	global	_startTaskAnalizaUart1

;; *************** function _startTaskAnalizaUart1 *****************
;; Defined at:
;;		line 433 in file "Serial.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2
;; Tracked objects:
;;		On entry : 3F/1
;;		On exit  : 3F/1
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text5,class=CODE,space=0,reloc=2,group=0
	file	"Serial.c"
	line	433
global __ptext5
__ptext5:
psect	text5
	file	"Serial.c"
	line	433
	
_startTaskAnalizaUart1:; BSR set to: 1

;incstack = 0
	callstack 18
	line	435
	
l7885:; BSR set to: 1

	movlw	high(0)
	movwf	((_ptTaskAnalizaUart1+1))&0ffh
	movlw	low(0)
	movwf	((_ptTaskAnalizaUart1))&0ffh
	line	436
	
l920:; BSR set to: 1

	return	;funcret
	callstack 0
GLOBAL	__end_of_startTaskAnalizaUart1
	__end_of_startTaskAnalizaUart1:
	signat	_startTaskAnalizaUart1,89
	global	_startTaskAlarm

;; *************** function _startTaskAlarm *****************
;; Defined at:
;;		line 563 in file "Alarma.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2
;; Tracked objects:
;;		On entry : 3F/1
;;		On exit  : 3F/1
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text6,class=CODE,space=0,reloc=2,group=0
	file	"Alarma.c"
	line	563
global __ptext6
__ptext6:
psect	text6
	file	"Alarma.c"
	line	563
	
_startTaskAlarm:; BSR set to: 1

;incstack = 0
	callstack 18
	line	565
	
l7889:; BSR set to: 1

	movlw	high(0)
	movwf	((_ptTaskAlarm+1))&0ffh
	movlw	low(0)
	movwf	((_ptTaskAlarm))&0ffh
	line	566
	
l342:; BSR set to: 1

	return	;funcret
	callstack 0
GLOBAL	__end_of_startTaskAlarm
	__end_of_startTaskAlarm:
	signat	_startTaskAlarm,89
	global	_pinConfLedPin

;; *************** function _pinConfLedPin *****************
;; Defined at:
;;		line 99 in file "LedLive.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		None
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 3F/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text7,class=CODE,space=0,reloc=2,group=0
	file	"LedLive.c"
	line	99
global __ptext7
__ptext7:
psect	text7
	file	"LedLive.c"
	line	99
	
_pinConfLedPin:; BSR set to: 1

;incstack = 0
	callstack 18
	line	101
	
l7869:; BSR set to: 0

	bcf	((c:3986))^0f00h,c,0	;volatile
	line	103
	bsf	((c:3977))^0f00h,c,0	;volatile
	line	104
	bcf	((c:3977))^0f00h,c,0	;volatile
	line	106
	
l772:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_pinConfLedPin
	__end_of_pinConfLedPin:
	signat	_pinConfLedPin,89
	global	_pinConfCluster

;; *************** function _pinConfCluster *****************
;; Defined at:
;;		line 111 in file "Cluster.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		None
;; Tracked objects:
;;		On entry : 3F/2
;;		On exit  : 3F/2
;;		Unchanged: 3F/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text8,class=CODE,space=0,reloc=2,group=0
	file	"Cluster.c"
	line	111
global __ptext8
__ptext8:
psect	text8
	file	"Cluster.c"
	line	111
	
_pinConfCluster:; BSR set to: 0

;incstack = 0
	callstack 18
	line	113
	
l7881:; BSR set to: 2

	bcf	((c:3988))^0f00h,c,2	;volatile
	line	117
	
l622:; BSR set to: 2

	return	;funcret
	callstack 0
GLOBAL	__end_of_pinConfCluster
	__end_of_pinConfCluster:
	signat	_pinConfCluster,89
	global	_pinConfBuzzer

;; *************** function _pinConfBuzzer *****************
;; Defined at:
;;		line 160 in file "Buzzer.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		None
;; Tracked objects:
;;		On entry : 3F/2
;;		On exit  : 3F/2
;;		Unchanged: 3F/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text9,class=CODE,space=0,reloc=2,group=0
	file	"Buzzer.c"
	line	160
global __ptext9
__ptext9:
psect	text9
	file	"Buzzer.c"
	line	160
	
_pinConfBuzzer:; BSR set to: 2

;incstack = 0
	callstack 18
	line	163
	
l7879:; BSR set to: 2

	bcf	((c:3988))^0f00h,c,0	;volatile
	line	167
	
l567:; BSR set to: 2

	return	;funcret
	callstack 0
GLOBAL	__end_of_pinConfBuzzer
	__end_of_pinConfBuzzer:
	signat	_pinConfBuzzer,89
	global	_executeTaskLedLive

;; *************** function _executeTaskLedLive *****************
;; Defined at:
;;		line 91 in file "LedLive.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 0/1
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 14
;; This function calls:
;;		_taskLedLive
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text10,class=CODE,space=0,reloc=2,group=0
	file	"LedLive.c"
	line	91
global __ptext10
__ptext10:
psect	text10
	file	"LedLive.c"
	line	91
	
_executeTaskLedLive:; BSR set to: 2

;incstack = 0
	callstack 16
	line	92
	
l10459:
		movlw	low(_ptTaskLedLive)
	movlb	0	; () banked
	movwf	((taskLedLive@pt))&0ffh
	movlw	high(_ptTaskLedLive)
	movwf	((taskLedLive@pt+1))&0ffh

	call	_taskLedLive	;wreg free
	line	93
	
l766:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_executeTaskLedLive
	__end_of_executeTaskLedLive:
	signat	_executeTaskLedLive,89
	global	_taskLedLive

;; *************** function _taskLedLive *****************
;; Defined at:
;;		line 35 in file "LedLive.c"
;; Parameters:    Size  Location     Type
;;  pt              2   41[BANK0 ] PTR struct pt
;;		 -> ptTaskLedLive(2), 
;; Auto vars:     Size  Location     Type
;;  PT_YIELD_FLA    1    0        unsigned char 
;; Return value:  Size  Location     Type
;;                  2   41[BANK0 ] int 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       2       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       2       0       0       0       0       0       0       0
;;      Totals:         0       4       0       0       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 13
;; This function calls:
;;		_getMillis
;; This function is called by:
;;		_executeTaskLedLive
;; This function uses a non-reentrant model
;;
psect	text11,class=CODE,space=0,reloc=2,group=0
	line	35
global __ptext11
__ptext11:
psect	text11
	file	"LedLive.c"
	line	35
	
_taskLedLive:; BSR set to: 0

;incstack = 0
	callstack 16
	line	37
	
l9997:; BSR set to: 0

	goto	l10033
	
l742:; BSR set to: 1

	line	40
	
l9999:
	movlw	0Ah
	call	_getMillis	;wreg free
	movlb	0	; () banked
	addwf	(0+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	((_ulCntPeriodLedLive))&0ffh
	movlw	0
	movlb	0	; () banked
	addwfc	(1+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	1+((_ulCntPeriodLedLive))&0ffh
	
	movlw	0
	movlb	0	; () banked
	addwfc	(2+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	2+((_ulCntPeriodLedLive))&0ffh
	
	movlw	0
	movlb	0	; () banked
	addwfc	(3+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	3+((_ulCntPeriodLedLive))&0ffh
	line	41
	
l10001:; BSR set to: 1

	movff	(taskLedLive@pt),fsr2l
	movff	(taskLedLive@pt+1),fsr2h
	movlw	low(029h)
	movwf	postinc2,c
	movlw	high(029h)
	movwf	postdec2,c
	
l10003:
	call	_getMillis	;wreg free
	movlb	1	; () banked
		movf	((_ulCntPeriodLedLive))&0ffh,w
	movlb	0	; () banked
	subwf	(0+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movf	((_ulCntPeriodLedLive+1))&0ffh,w
	movlb	0	; () banked
	subwfb	(1+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movf	((_ulCntPeriodLedLive+2))&0ffh,w
	movlb	0	; () banked
	subwfb	(2+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movf	((_ulCntPeriodLedLive+3))&0ffh,w
	movlb	0	; () banked
	subwfb	(3+?_getMillis)&0ffh,w
	btfsc	status,0
	goto	u11881
	goto	u11880

u11881:
	goto	l10031
u11880:
	goto	l747
	line	45
	
l750:; BSR set to: 0

	line	46
	bcf	((c:3977))^0f00h,c,0	;volatile
	line	47
	movlb	2	; () banked
	btfss	((_ap))&0ffh,0
	goto	u11891
	goto	u11890
u11891:
	goto	l9999
u11890:
	line	49
	
l10007:; BSR set to: 2

	movlw	low(01h)
	movlb	0	; () banked
	movwf	((_state_ledLive))&0ffh
	goto	l9999
	line	54
	
l10009:; BSR set to: 0

	movf	((_flagInitStLed))&0ffh,w
	btfss	status,2
	goto	u11901
	goto	u11900
u11901:
	goto	l10015
u11900:
	line	56
	
l10011:; BSR set to: 0

	movlw	low(01h)
	movwf	((_flagInitStLed))&0ffh
	line	57
	
l10013:; BSR set to: 0

	bcf	((c:3977))^0f00h,c,0	;volatile
	line	58
	goto	l9999
	line	61
	
l10015:; BSR set to: 0

	movlb	1	; () banked
	infsnz	((_uiCntLedLive))&0ffh
	incf	((_uiCntLedLive+1))&0ffh
		movf	((_uiCntLedLive+1))&0ffh,w
	bnz	u11910
	movlw	5
	subwf	 ((_uiCntLedLive))&0ffh,w
	btfss	status,0
	goto	u11911
	goto	u11910

u11911:
	goto	l742
u11910:
	line	63
	
l10017:; BSR set to: 1

	movlw	high(0)
	movwf	((_uiCntLedLive+1))&0ffh
	movlw	low(0)
	movwf	((_uiCntLedLive))&0ffh
	line	64
	movlw	low(0)
	movlb	0	; () banked
	movwf	((_flagInitStLed))&0ffh
	line	65
	movlw	low(02h)
	movwf	((_state_ledLive))&0ffh
	goto	l9999
	line	71
	
l10019:; BSR set to: 0

	movf	((_flagInitStLed))&0ffh,w
	btfss	status,2
	goto	u11921
	goto	u11920
u11921:
	goto	l10025
u11920:
	line	73
	
l10021:; BSR set to: 0

	movlw	low(01h)
	movwf	((_flagInitStLed))&0ffh
	line	74
	
l10023:; BSR set to: 0

	bsf	((c:3977))^0f00h,c,0	;volatile
	line	75
	goto	l9999
	line	78
	
l10025:; BSR set to: 0

	movlb	1	; () banked
	infsnz	((_uiCntLedLive))&0ffh
	incf	((_uiCntLedLive+1))&0ffh
		movf	((_uiCntLedLive+1))&0ffh,w
	bnz	u11930
	movlw	195
	subwf	 ((_uiCntLedLive))&0ffh,w
	btfss	status,0
	goto	u11931
	goto	u11930

u11931:
	goto	l742
u11930:
	line	80
	
l10027:; BSR set to: 1

	movlw	high(0)
	movwf	((_uiCntLedLive+1))&0ffh
	movlw	low(0)
	movwf	((_uiCntLedLive))&0ffh
	line	81
	movlw	low(0)
	movlb	0	; () banked
	movwf	((_flagInitStLed))&0ffh
	line	82
	movlw	low(01h)
	movwf	((_state_ledLive))&0ffh
	goto	l9999
	line	86
	
l10031:; BSR set to: 0

	movf	((_state_ledLive))&0ffh,w
	movwf	(??_taskLedLive+0+0)&0ffh
	clrf	(??_taskLedLive+0+0+1)&0ffh

	; Switch on 2 bytes has been partitioned into a top level switch of size 1, and 1 sub-switches
; Switch size 1, requested type "simple"
; Number of cases is 1, Range of values is 0 to 0
; switch strategies available:
; Name         Instructions Cycles
; simple_byte            4     3 (average)
;	Chosen strategy is simple_byte

	movf ??_taskLedLive+0+1&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l18587
	goto	l9999
	
l18587:; BSR set to: 0

; Switch size 1, requested type "simple"
; Number of cases is 3, Range of values is 0 to 2
; switch strategies available:
; Name         Instructions Cycles
; simple_byte           10     6 (average)
;	Chosen strategy is simple_byte

	movf ??_taskLedLive+0+0&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l750
	xorlw	1^0	; case 1
	skipnz
	goto	l10009
	xorlw	2^1	; case 2
	skipnz
	goto	l10019
	goto	l9999

	line	88
	
l10033:; BSR set to: 0

	movff	(taskLedLive@pt),fsr2l
	movff	(taskLedLive@pt+1),fsr2h
	movff	postinc2,??_taskLedLive+0+0
	movff	postdec2,??_taskLedLive+0+0+1
	; Switch on 2 bytes has been partitioned into a top level switch of size 1, and 1 sub-switches
; Switch size 1, requested type "simple"
; Number of cases is 1, Range of values is 0 to 0
; switch strategies available:
; Name         Instructions Cycles
; simple_byte            4     3 (average)
;	Chosen strategy is simple_byte

	movf ??_taskLedLive+0+1&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l18589
	goto	l10035
	
l18589:; BSR set to: 0

; Switch size 1, requested type "simple"
; Number of cases is 2, Range of values is 0 to 41
; switch strategies available:
; Name         Instructions Cycles
; simple_byte            7     4 (average)
;	Chosen strategy is simple_byte

	movf ??_taskLedLive+0+0&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l9999
	xorlw	41^0	; case 41
	skipnz
	goto	l10003
	goto	l10035

	
l10035:; BSR set to: 0

	
l10037:; BSR set to: 0

	movff	(taskLedLive@pt),fsr2l
	movff	(taskLedLive@pt+1),fsr2h
	movlw	low(0)
	movwf	postinc2,c
	movlw	high(0)
	movwf	postdec2,c
	line	89
	
l747:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_taskLedLive
	__end_of_taskLedLive:
	signat	_taskLedLive,4218
	global	_executeTaskCluster

;; *************** function _executeTaskCluster *****************
;; Defined at:
;;		line 104 in file "Cluster.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 14
;; This function calls:
;;		_taskCluster
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text12,class=CODE,space=0,reloc=2,group=0
	file	"Cluster.c"
	line	104
global __ptext12
__ptext12:
psect	text12
	file	"Cluster.c"
	line	104
	
_executeTaskCluster:; BSR set to: 0

;incstack = 0
	callstack 16
	line	106
	
l10469:; BSR set to: 0

		movlw	low(_ptTaskCluster)
	movwf	((taskCluster@pt))&0ffh
	movlw	high(_ptTaskCluster)
	movwf	((taskCluster@pt+1))&0ffh

	call	_taskCluster	;wreg free
	line	107
	
l619:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_executeTaskCluster
	__end_of_executeTaskCluster:
	signat	_executeTaskCluster,89
	global	_taskCluster

;; *************** function _taskCluster *****************
;; Defined at:
;;		line 29 in file "Cluster.c"
;; Parameters:    Size  Location     Type
;;  pt              2   41[BANK0 ] PTR struct pt
;;		 -> ptTaskCluster(2), 
;; Auto vars:     Size  Location     Type
;;  PT_YIELD_FLA    1    0        unsigned char 
;; Return value:  Size  Location     Type
;;                  2   41[BANK0 ] int 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       2       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       2       0       0       0       0       0       0       0
;;      Totals:         0       4       0       0       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 13
;; This function calls:
;;		_getMillis
;;		_oneBeep
;; This function is called by:
;;		_executeTaskCluster
;; This function uses a non-reentrant model
;;
psect	text13,class=CODE,space=0,reloc=2,group=0
	line	29
global __ptext13
__ptext13:
psect	text13
	file	"Cluster.c"
	line	29
	
_taskCluster:; BSR set to: 0

;incstack = 0
	callstack 16
	line	31
	
l9937:; BSR set to: 0

	goto	l9981
	line	34
	
l9939:
	movlw	0Ah
	call	_getMillis	;wreg free
	movlb	0	; () banked
	addwf	(0+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	((_ulCntPeriodCluster))&0ffh
	movlw	0
	movlb	0	; () banked
	addwfc	(1+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	1+((_ulCntPeriodCluster))&0ffh
	
	movlw	0
	movlb	0	; () banked
	addwfc	(2+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	2+((_ulCntPeriodCluster))&0ffh
	
	movlw	0
	movlb	0	; () banked
	addwfc	(3+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	3+((_ulCntPeriodCluster))&0ffh
	line	35
	
l9941:; BSR set to: 1

	movff	(taskCluster@pt),fsr2l
	movff	(taskCluster@pt+1),fsr2h
	movlw	low(023h)
	movwf	postinc2,c
	movlw	high(023h)
	movwf	postdec2,c
	
l9943:
	call	_getMillis	;wreg free
	movlb	1	; () banked
		movf	((_ulCntPeriodCluster))&0ffh,w
	movlb	0	; () banked
	subwf	(0+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movf	((_ulCntPeriodCluster+1))&0ffh,w
	movlb	0	; () banked
	subwfb	(1+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movf	((_ulCntPeriodCluster+2))&0ffh,w
	movlb	0	; () banked
	subwfb	(2+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movf	((_ulCntPeriodCluster+3))&0ffh,w
	movlb	0	; () banked
	subwfb	(3+?_getMillis)&0ffh,w
	btfsc	status,0
	goto	u11811
	goto	u11810

u11811:
	goto	l9979
u11810:
	goto	l594
	line	38
	
l597:; BSR set to: 0

	line	39
	movlb	2	; () banked
	btfss	((_ap))&0ffh,0
	goto	u11821
	goto	u11820
u11821:
	goto	l9939
u11820:
	line	41
	
l9947:; BSR set to: 2

	movlw	low(01h)
	movlb	0	; () banked
	movwf	((_stateCluster))&0ffh
	goto	l9939
	line	46
	
l9949:; BSR set to: 0

	movlb	1	; () banked
	movf	(0+(_cl+02h))&0ffh,w
	btfsc	status,2
	goto	u11831
	goto	u11830
u11831:
	goto	l601
u11830:
	line	48
	
l9951:; BSR set to: 1

	bsf	((c:3979))^0f00h,c,2	;volatile
	line	49
	
l9953:; BSR set to: 1

	call	_oneBeep	;wreg free
	line	50
	
l9955:
	movlw	low(02h)
	movlb	0	; () banked
	movwf	((_stateCluster))&0ffh
	line	51
	goto	l9939
	line	52
	
l601:; BSR set to: 1

	line	54
	bcf	((c:3979))^0f00h,c,2	;volatile
	goto	l9939
	line	60
	
l9957:; BSR set to: 0

	movlb	1	; () banked
	infsnz	((_cl))&0ffh
	incf	((_cl+1))&0ffh
		movf	((_cl+1))&0ffh,w
	bnz	u11840
	movlw	5
	subwf	 ((_cl))&0ffh,w
	btfss	status,0
	goto	u11841
	goto	u11840

u11841:
	goto	l9939
u11840:
	line	62
	
l9959:; BSR set to: 1

	movlw	high(0)
	movwf	((_cl+1))&0ffh
	movlw	low(0)
	movwf	((_cl))&0ffh
	line	63
	
l9961:; BSR set to: 1

	bcf	((c:3979))^0f00h,c,2	;volatile
	line	64
	movlw	low(03h)
	movlb	0	; () banked
	movwf	((_stateCluster))&0ffh
	goto	l9939
	line	69
	
l9963:; BSR set to: 0

	movlb	1	; () banked
	infsnz	((_cl))&0ffh
	incf	((_cl+1))&0ffh
		movf	((_cl+1))&0ffh,w
	bnz	u11850
	movlw	5
	subwf	 ((_cl))&0ffh,w
	btfss	status,0
	goto	u11851
	goto	u11850

u11851:
	goto	l9939
u11850:
	line	71
	
l9965:; BSR set to: 1

	movlw	high(0)
	movwf	((_cl+1))&0ffh
	movlw	low(0)
	movwf	((_cl))&0ffh
	line	73
	
l9967:; BSR set to: 1

	incf	(0+(_cl+03h))&0ffh
		movlw	05h-1
	cpfsgt	(0+(_cl+03h))&0ffh
	goto	u11861
	goto	u11860

u11861:
	goto	l607
u11860:
	line	75
	
l9969:; BSR set to: 1

	movlw	low(0)
	movwf	(0+(_cl+03h))&0ffh
	line	76
	movlw	low(04h)
	movlb	0	; () banked
	movwf	((_stateCluster))&0ffh
	line	77
	goto	l9939
	line	78
	
l607:; BSR set to: 1

	line	80
	bsf	((c:3979))^0f00h,c,2	;volatile
	goto	l9955
	line	87
	
l9973:; BSR set to: 0

	movlb	1	; () banked
	infsnz	((_cl))&0ffh
	incf	((_cl+1))&0ffh
		movf	((_cl+1))&0ffh,w
	bnz	u11870
	movlw	50
	subwf	 ((_cl))&0ffh,w
	btfss	status,0
	goto	u11871
	goto	u11870

u11871:
	goto	l9939
u11870:
	line	89
	
l9975:; BSR set to: 1

	movlw	high(0)
	movwf	((_cl+1))&0ffh
	movlw	low(0)
	movwf	((_cl))&0ffh
	line	91
	movlw	low(0)
	movwf	(0+(_cl+02h))&0ffh
	line	92
	movlw	low(01h)
	movlb	0	; () banked
	movwf	((_stateCluster))&0ffh
	goto	l9939
	line	95
	
l9979:; BSR set to: 0

	movf	((_stateCluster))&0ffh,w
	movwf	(??_taskCluster+0+0)&0ffh
	clrf	(??_taskCluster+0+0+1)&0ffh

	; Switch on 2 bytes has been partitioned into a top level switch of size 1, and 1 sub-switches
; Switch size 1, requested type "simple"
; Number of cases is 1, Range of values is 0 to 0
; switch strategies available:
; Name         Instructions Cycles
; simple_byte            4     3 (average)
;	Chosen strategy is simple_byte

	movf ??_taskCluster+0+1&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l18591
	goto	l9939
	
l18591:; BSR set to: 0

; Switch size 1, requested type "simple"
; Number of cases is 5, Range of values is 0 to 4
; switch strategies available:
; Name         Instructions Cycles
; simple_byte           16     9 (average)
;	Chosen strategy is simple_byte

	movf ??_taskCluster+0+0&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l597
	xorlw	1^0	; case 1
	skipnz
	goto	l9949
	xorlw	2^1	; case 2
	skipnz
	goto	l9957
	xorlw	3^2	; case 3
	skipnz
	goto	l9963
	xorlw	4^3	; case 4
	skipnz
	goto	l9973
	goto	l9939

	line	97
	
l9981:; BSR set to: 0

	movff	(taskCluster@pt),fsr2l
	movff	(taskCluster@pt+1),fsr2h
	movff	postinc2,??_taskCluster+0+0
	movff	postdec2,??_taskCluster+0+0+1
	; Switch on 2 bytes has been partitioned into a top level switch of size 1, and 1 sub-switches
; Switch size 1, requested type "simple"
; Number of cases is 1, Range of values is 0 to 0
; switch strategies available:
; Name         Instructions Cycles
; simple_byte            4     3 (average)
;	Chosen strategy is simple_byte

	movf ??_taskCluster+0+1&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l18593
	goto	l9983
	
l18593:; BSR set to: 0

; Switch size 1, requested type "simple"
; Number of cases is 2, Range of values is 0 to 35
; switch strategies available:
; Name         Instructions Cycles
; simple_byte            7     4 (average)
;	Chosen strategy is simple_byte

	movf ??_taskCluster+0+0&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l9939
	xorlw	35^0	; case 35
	skipnz
	goto	l9943
	goto	l9983

	
l9983:; BSR set to: 0

	
l9985:; BSR set to: 0

	movff	(taskCluster@pt),fsr2l
	movff	(taskCluster@pt+1),fsr2h
	movlw	low(0)
	movwf	postinc2,c
	movlw	high(0)
	movwf	postdec2,c
	line	98
	
l594:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_taskCluster
	__end_of_taskCluster:
	signat	_taskCluster,4218
	global	_executeTaskBuzzer

;; *************** function _executeTaskBuzzer *****************
;; Defined at:
;;		line 126 in file "Buzzer.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 14
;; This function calls:
;;		_taskBuzzer
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text14,class=CODE,space=0,reloc=2,group=0
	file	"Buzzer.c"
	line	126
global __ptext14
__ptext14:
psect	text14
	file	"Buzzer.c"
	line	126
	
_executeTaskBuzzer:; BSR set to: 0

;incstack = 0
	callstack 16
	line	128
	
l10467:; BSR set to: 0

		movlw	low(_ptTaskBuzzer)
	movwf	((taskBuzzer@pt))&0ffh
	movlw	high(_ptTaskBuzzer)
	movwf	((taskBuzzer@pt+1))&0ffh

	call	_taskBuzzer	;wreg free
	line	129
	
l549:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_executeTaskBuzzer
	__end_of_executeTaskBuzzer:
	signat	_executeTaskBuzzer,89
	global	_taskBuzzer

;; *************** function _taskBuzzer *****************
;; Defined at:
;;		line 18 in file "Buzzer.c"
;; Parameters:    Size  Location     Type
;;  pt              2   41[BANK0 ] PTR struct pt
;;		 -> ptTaskBuzzer(2), 
;; Auto vars:     Size  Location     Type
;;  PT_YIELD_FLA    1    0        unsigned char 
;; Return value:  Size  Location     Type
;;                  2   41[BANK0 ] int 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       2       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       2       0       0       0       0       0       0       0
;;      Totals:         0       4       0       0       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 13
;; This function calls:
;;		_getMillis
;; This function is called by:
;;		_executeTaskBuzzer
;; This function uses a non-reentrant model
;;
psect	text15,class=CODE,space=0,reloc=2,group=0
	line	18
global __ptext15
__ptext15:
psect	text15
	file	"Buzzer.c"
	line	18
	
_taskBuzzer:; BSR set to: 0

;incstack = 0
	callstack 16
	line	21
	
l9857:; BSR set to: 0

	goto	l9921
	line	24
	
l9859:; BSR set to: 0

	movlw	0Ah
	call	_getMillis	;wreg free
	movlb	0	; () banked
	addwf	(0+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	((_ulCntPeriodBuzzer))&0ffh
	movlw	0
	movlb	0	; () banked
	addwfc	(1+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	1+((_ulCntPeriodBuzzer))&0ffh
	
	movlw	0
	movlb	0	; () banked
	addwfc	(2+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	2+((_ulCntPeriodBuzzer))&0ffh
	
	movlw	0
	movlb	0	; () banked
	addwfc	(3+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	3+((_ulCntPeriodBuzzer))&0ffh
	line	25
	
l9861:; BSR set to: 1

	movff	(taskBuzzer@pt),fsr2l
	movff	(taskBuzzer@pt+1),fsr2h
	movlw	low(019h)
	movwf	postinc2,c
	movlw	high(019h)
	movwf	postdec2,c
	
l9863:
	call	_getMillis	;wreg free
	movlb	1	; () banked
		movf	((_ulCntPeriodBuzzer))&0ffh,w
	movlb	0	; () banked
	subwf	(0+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movf	((_ulCntPeriodBuzzer+1))&0ffh,w
	movlb	0	; () banked
	subwfb	(1+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movf	((_ulCntPeriodBuzzer+2))&0ffh,w
	movlb	0	; () banked
	subwfb	(2+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movf	((_ulCntPeriodBuzzer+3))&0ffh,w
	movlb	0	; () banked
	subwfb	(3+?_getMillis)&0ffh,w
	btfsc	status,0
	goto	u11721
	goto	u11720

u11721:
	goto	l9919
u11720:
	goto	l520
	line	33
	
l9867:; BSR set to: 0

		decf	((_ucTypeBeep))&0ffh,w
	btfss	status,2
	goto	u11731
	goto	u11730

u11731:
	goto	l9873
u11730:
	line	35
	
l9869:; BSR set to: 0

	bsf	((c:3979))^0f00h,c,0	;volatile
	line	36
	
l9871:; BSR set to: 0

	movlw	low(01h)
	movwf	((_stateBuzzer))&0ffh
	line	37
	goto	l9859
	line	38
	
l9873:; BSR set to: 0

		movlw	2
	xorwf	((_ucTypeBeep))&0ffh,w
	btfss	status,2
	goto	u11741
	goto	u11740

u11741:
	goto	l9881
u11740:
	line	40
	
l9875:; BSR set to: 0

	decf	((_ucIteradorBuzzer))&0ffh
	line	41
	
l9877:; BSR set to: 0

	bsf	((c:3979))^0f00h,c,0	;volatile
	line	42
	
l9879:; BSR set to: 0

	movlw	low(02h)
	movwf	((_stateBuzzer))&0ffh
	line	43
	goto	l9859
	line	44
	
l9881:; BSR set to: 0

		movlw	3
	xorwf	((_ucTypeBeep))&0ffh,w
	btfss	status,2
	goto	u11751
	goto	u11750

u11751:
	goto	l9887
u11750:
	line	46
	
l9883:; BSR set to: 0

	bsf	((c:3979))^0f00h,c,0	;volatile
	line	47
	
l9885:; BSR set to: 0

	movlw	low(03h)
	movwf	((_stateBuzzer))&0ffh
	line	48
	goto	l9859
	line	51
	
l9887:; BSR set to: 0

	movlw	low(0)
	movwf	((_ucTypeBeep))&0ffh
	line	52
	movlw	low(0)
	movwf	((_ucCntTimeBuzzer))&0ffh
	line	53
	movlw	low(0)
	movwf	((c:_flagStartBuzzer))^00h,c
	line	55
	
l9889:; BSR set to: 0

	bcf	((c:3979))^0f00h,c,0	;volatile
	goto	l9859
	line	64
	
l9891:; BSR set to: 0

	incf	((_ucCntTimeBuzzer))&0ffh
		movlw	05h-1
	cpfsgt	((_ucCntTimeBuzzer))&0ffh
	goto	u11761
	goto	u11760

u11761:
	goto	l9859
u11760:
	line	66
	
l9893:; BSR set to: 0

	movlw	low(0)
	movwf	((_ucCntTimeBuzzer))&0ffh
	line	67
	
l9895:; BSR set to: 0

	bcf	((c:3979))^0f00h,c,0	;volatile
	line	68
	movlw	low(0)
	movwf	((_ucTypeBeep))&0ffh
	line	69
	movlw	low(0)
	movwf	((_stateBuzzer))&0ffh
	goto	l9859
	line	77
	
l9897:; BSR set to: 0

	incf	((_ucCntTimeBuzzer))&0ffh
		movlw	05h-1
	cpfsgt	((_ucCntTimeBuzzer))&0ffh
	goto	u11771
	goto	u11770

u11771:
	goto	l9859
u11770:
	line	79
	
l9899:; BSR set to: 0

	movlw	low(0)
	movwf	((_ucCntTimeBuzzer))&0ffh
	line	81
	movf	((_ucIteradorBuzzer))&0ffh,w
	btfss	status,2
	goto	u11781
	goto	u11780
u11781:
	goto	l535
u11780:
	line	83
	
l9901:; BSR set to: 0

	bcf	((c:3979))^0f00h,c,0	;volatile
	line	84
	
l9903:; BSR set to: 0

	movlw	low(0)
	movwf	((_ucTypeBeep))&0ffh
	line	85
	movlw	low(0)
	movwf	((_stateBuzzer))&0ffh
	line	86
	goto	l9859
	line	87
	
l535:; BSR set to: 0

	line	89
	bcf	((c:3979))^0f00h,c,0	;volatile
	line	90
	
l9905:; BSR set to: 0

	movlw	low(04h)
	movwf	((_stateBuzzer))&0ffh
	goto	l9859
	line	99
	
l9907:; BSR set to: 0

	incf	((_ucCntTimeBuzzer))&0ffh
		movlw	05h-1
	cpfsgt	((_ucCntTimeBuzzer))&0ffh
	goto	u11791
	goto	u11790

u11791:
	goto	l9859
u11790:
	line	101
	
l9909:; BSR set to: 0

	movlw	low(0)
	movwf	((_ucCntTimeBuzzer))&0ffh
	line	102
	
l9911:; BSR set to: 0

	bcf	((c:3979))^0f00h,c,0	;volatile
	line	103
	movlw	low(04h)
	movwf	((_stateBuzzer))&0ffh
	goto	l9859
	line	110
	
l9913:; BSR set to: 0

	incf	((_ucCntTimeBuzzer))&0ffh
		movlw	05h-1
	cpfsgt	((_ucCntTimeBuzzer))&0ffh
	goto	u11801
	goto	u11800

u11801:
	goto	l9859
u11800:
	line	112
	
l9915:; BSR set to: 0

	movlw	low(0)
	movwf	((_ucCntTimeBuzzer))&0ffh
	line	113
	movlw	low(0)
	movwf	((_stateBuzzer))&0ffh
	goto	l9859
	line	116
	
l9919:; BSR set to: 0

	movf	((_stateBuzzer))&0ffh,w
	movwf	(??_taskBuzzer+0+0)&0ffh
	clrf	(??_taskBuzzer+0+0+1)&0ffh

	; Switch on 2 bytes has been partitioned into a top level switch of size 1, and 1 sub-switches
; Switch size 1, requested type "simple"
; Number of cases is 1, Range of values is 0 to 0
; switch strategies available:
; Name         Instructions Cycles
; simple_byte            4     3 (average)
;	Chosen strategy is simple_byte

	movf ??_taskBuzzer+0+1&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l18595
	goto	l9859
	
l18595:; BSR set to: 0

; Switch size 1, requested type "simple"
; Number of cases is 5, Range of values is 0 to 4
; switch strategies available:
; Name         Instructions Cycles
; simple_byte           16     9 (average)
;	Chosen strategy is simple_byte

	movf ??_taskBuzzer+0+0&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l9867
	xorlw	1^0	; case 1
	skipnz
	goto	l9891
	xorlw	2^1	; case 2
	skipnz
	goto	l9897
	xorlw	3^2	; case 3
	skipnz
	goto	l9907
	xorlw	4^3	; case 4
	skipnz
	goto	l9913
	goto	l9859

	line	118
	
l9921:; BSR set to: 0

	movff	(taskBuzzer@pt),fsr2l
	movff	(taskBuzzer@pt+1),fsr2h
	movff	postinc2,??_taskBuzzer+0+0
	movff	postdec2,??_taskBuzzer+0+0+1
	; Switch on 2 bytes has been partitioned into a top level switch of size 1, and 1 sub-switches
; Switch size 1, requested type "simple"
; Number of cases is 1, Range of values is 0 to 0
; switch strategies available:
; Name         Instructions Cycles
; simple_byte            4     3 (average)
;	Chosen strategy is simple_byte

	movf ??_taskBuzzer+0+1&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l18597
	goto	l9923
	
l18597:; BSR set to: 0

; Switch size 1, requested type "simple"
; Number of cases is 2, Range of values is 0 to 25
; switch strategies available:
; Name         Instructions Cycles
; simple_byte            7     4 (average)
;	Chosen strategy is simple_byte

	movf ??_taskBuzzer+0+0&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l9859
	xorlw	25^0	; case 25
	skipnz
	goto	l9863
	goto	l9923

	
l9923:; BSR set to: 0

	
l9925:; BSR set to: 0

	movff	(taskBuzzer@pt),fsr2l
	movff	(taskBuzzer@pt+1),fsr2h
	movlw	low(0)
	movwf	postinc2,c
	movlw	high(0)
	movwf	postdec2,c
	line	119
	
l520:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_taskBuzzer
	__end_of_taskBuzzer:
	signat	_taskBuzzer,4218
	global	_executeTaskAplicacion

;; *************** function _executeTaskAplicacion *****************
;; Defined at:
;;		line 246 in file "Aplicacion.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3D/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 24
;; This function calls:
;;		_taskAplicacion
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text16,class=CODE,space=0,reloc=2,group=0
	file	"Aplicacion.c"
	line	246
global __ptext16
__ptext16:
psect	text16
	file	"Aplicacion.c"
	line	246
	
_executeTaskAplicacion:; BSR set to: 0

;incstack = 0
	callstack 6
	line	248
	
l18215:; BSR set to: 0

		movlw	low(_ptTaskAplicacion)
	movlb	2	; () banked
	movwf	((taskAplicacion@pt))&0ffh
	movlw	high(_ptTaskAplicacion)
	movwf	((taskAplicacion@pt+1))&0ffh

	call	_taskAplicacion	;wreg free
	line	249
	
l460:
	return	;funcret
	callstack 0
GLOBAL	__end_of_executeTaskAplicacion
	__end_of_executeTaskAplicacion:
	signat	_executeTaskAplicacion,89
	global	_taskAplicacion

;; *************** function _taskAplicacion *****************
;; Defined at:
;;		line 56 in file "Aplicacion.c"
;; Parameters:    Size  Location     Type
;;  pt              2   66[BANK2 ] PTR struct pt
;;		 -> ptTaskAplicacion(2), 
;; Auto vars:     Size  Location     Type
;;  PT_YIELD_FLA    1    0        unsigned char 
;; Return value:  Size  Location     Type
;;                  2   66[BANK2 ] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3F/2
;;		On exit  : 3D/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       2       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       2       0       0       0       0       0
;;      Totals:         0       0       0       4       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 23
;; This function calls:
;;		_ADC_read
;;		_EEpromRead
;;		_EEpromWrite
;;		___fladd
;;		___flmul
;;		___xxtofl
;;		_cambiarEstado
;;		_getMillis
;;		_inicioEstado
;;		_oneBeep
;;		_readDevide
;;		_readMemoriaValues
;;		_reiniciarTemporizador
;;		_transmitUart1
;;		_twoBeep
;; This function is called by:
;;		_executeTaskAplicacion
;; This function uses a non-reentrant model
;;
psect	text17,class=CODE,space=0,reloc=2,group=0
	line	56
global __ptext17
__ptext17:
psect	text17
	file	"Aplicacion.c"
	line	56
	
_taskAplicacion:
;incstack = 0
	callstack 6
	line	59
	
l17691:; BSR set to: 2

	goto	l17791
	line	62
	
l17693:
	movlw	0Ah
	call	_getMillis	;wreg free
	movlb	0	; () banked
	addwf	(0+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	((_ulCntPeriodAplicacion))&0ffh
	movlw	0
	movlb	0	; () banked
	addwfc	(1+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	1+((_ulCntPeriodAplicacion))&0ffh
	
	movlw	0
	movlb	0	; () banked
	addwfc	(2+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	2+((_ulCntPeriodAplicacion))&0ffh
	
	movlw	0
	movlb	0	; () banked
	addwfc	(3+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	3+((_ulCntPeriodAplicacion))&0ffh
	line	63
	
l17695:; BSR set to: 1

	movff	(taskAplicacion@pt),fsr2l
	movff	(taskAplicacion@pt+1),fsr2h
	movlw	low(03Fh)
	movwf	postinc2,c
	movlw	high(03Fh)
	movwf	postdec2,c
	
l17697:
	call	_getMillis	;wreg free
	movlb	1	; () banked
		movf	((_ulCntPeriodAplicacion))&0ffh,w
	movlb	0	; () banked
	subwf	(0+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movf	((_ulCntPeriodAplicacion+1))&0ffh,w
	movlb	0	; () banked
	subwfb	(1+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movf	((_ulCntPeriodAplicacion+2))&0ffh,w
	movlb	0	; () banked
	subwfb	(2+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movf	((_ulCntPeriodAplicacion+3))&0ffh,w
	movlb	0	; () banked
	subwfb	(3+?_getMillis)&0ffh,w
	btfsc	status,0
	goto	u22111
	goto	u22110

u22111:
	goto	l17789
u22110:
	goto	l420
	line	69
	
l17701:; BSR set to: 2

	infsnz	(0+(_ap+03h))&0ffh
	incf	(1+(_ap+03h))&0ffh
		movlw	244
	subwf	 (0+(_ap+03h))&0ffh,w
	movlw	1
	subwfb	(1+(_ap+03h))&0ffh,w
	btfss	status,0
	goto	u22121
	goto	u22120

u22121:
	goto	l17693
u22120:
	line	73
	
l17703:; BSR set to: 2

	bsf	((_ap))&0ffh,0
	line	74
	
l17705:; BSR set to: 2

		movlw	low(_ap+03h)
	movlb	0	; () banked
	movwf	((reiniciarTemporizador@time))&0ffh
	movlw	high(_ap+03h)
	movwf	((reiniciarTemporizador@time+1))&0ffh

	call	_reiniciarTemporizador	;wreg free
	line	78
	
l17707:; BSR set to: 0

	call	_twoBeep	;wreg free
	line	79
	
l17709:; BSR set to: 0

	movlw	high(03h)
	movwf	((cambiarEstado@state+1))&0ffh
	movlw	low(03h)
	movwf	((cambiarEstado@state))&0ffh
	call	_cambiarEstado	;wreg free
	goto	l17693
	line	84
	
l17711:; BSR set to: 2

	movlw	high(03h)
	movlb	0	; () banked
	movwf	((inicioEstado@state+1))&0ffh
	movlw	low(03h)
	movwf	((inicioEstado@state))&0ffh
	call	_inicioEstado	;wreg free
	iorlw	0
	btfsc	status,2
	goto	u22131
	goto	u22130
u22131:
	goto	l17715
u22130:
	line	86
	
l17713:; BSR set to: 2

		movlw	low(_ap+03h)
	movlb	0	; () banked
	movwf	((reiniciarTemporizador@time))&0ffh
	movlw	high(_ap+03h)
	movwf	((reiniciarTemporizador@time+1))&0ffh

	call	_reiniciarTemporizador	;wreg free
	line	87
	goto	l17693
	line	90
	
l17715:; BSR set to: 2

	infsnz	(0+(_ap+03h))&0ffh
	incf	(1+(_ap+03h))&0ffh
		movf	(1+(_ap+03h))&0ffh,w
	bnz	u22140
	movlw	200
	subwf	 (0+(_ap+03h))&0ffh,w
	btfss	status,0
	goto	u22141
	goto	u22140

u22141:
	goto	l17693
u22140:
	line	92
	
l17717:; BSR set to: 2

	movlw	high(0)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(0)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	((_memo))&0ffh
	line	94
	
l17719:; BSR set to: 1

		movlw	6
	xorwf	((_memo))&0ffh,w
	btfsc	status,2
	goto	u22151
	goto	u22150

u22151:
	goto	l17723
u22150:
	line	96
	
l17721:; BSR set to: 1

	movlw	high(0)
	movlb	0	; () banked
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(06h)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	97
	call	_twoBeep	;wreg free
	line	99
	movlw	high(01h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(01h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	100
	movlw	high(02h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(02h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	101
	movlw	high(03h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(03h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(08h)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	102
	movlw	high(04h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(04h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	103
	movlw	high(05h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(05h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	104
	movlw	high(06h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(06h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	105
	movlw	high(07h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(07h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	107
	movlw	high(08h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(08h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	108
	movlw	high(09h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(09h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	109
	movlw	high(0Ah)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(0Ah)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(08h)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	110
	movlw	high(0Bh)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(0Bh)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	111
	movlw	high(0Ch)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(0Ch)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	112
	movlw	high(0Dh)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(0Dh)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	113
	movlw	high(0Eh)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(0Eh)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	115
	movlw	high(0Fh)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(0Fh)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	116
	movlw	high(010h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(010h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	117
	movlw	high(011h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(011h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(08h)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	118
	movlw	high(012h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(012h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	119
	movlw	high(013h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(013h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	120
	movlw	high(014h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(014h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	121
	movlw	high(015h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(015h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	123
	movlw	high(016h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(016h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	124
	movlw	high(017h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(017h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	125
	movlw	high(018h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(018h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(08h)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	126
	movlw	high(019h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(019h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	127
	movlw	high(01Ah)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(01Ah)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	128
	movlw	high(01Bh)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(01Bh)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	129
	movlw	high(01Ch)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(01Ch)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	131
	movlw	high(01Dh)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(01Dh)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	132
	movlw	high(01Eh)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(01Eh)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	133
	movlw	high(01Fh)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(01Fh)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(08h)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	134
	movlw	high(020h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(020h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	135
	movlw	high(021h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(021h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	136
	movlw	high(022h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(022h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	137
	movlw	high(023h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(023h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	139
	movlw	high(03h)
	movwf	((cambiarEstado@state+1))&0ffh
	movlw	low(03h)
	movwf	((cambiarEstado@state))&0ffh
	call	_cambiarEstado	;wreg free
	line	140
	goto	l17693
	line	144
	
l17723:; BSR set to: 1

	call	_readMemoriaValues	;wreg free
	line	145
	
l17725:; BSR set to: 1

	bsf	(0+(_ala+05h))&0ffh,0
	line	147
	
l17727:; BSR set to: 1

		movlw	low(STR_3)
	movlb	0	; () banked
	movwf	((transmitUart1@ptr))&0ffh
	movlw	high(STR_3)
	movwf	((transmitUart1@ptr+1))&0ffh

	call	_transmitUart1	;wreg free
	line	150
	
l17729:; BSR set to: 0

	movlw	high(01770h)
	movlb	2	; () banked
	movwf	(1+(_ap+040h))&0ffh
	movlw	low(01770h)
	movwf	(0+(_ap+040h))&0ffh
	line	151
	
l17731:; BSR set to: 2

	movlw	high(01194h)
	movwf	(1+(_ap+042h))&0ffh
	movlw	low(01194h)
	movwf	(0+(_ap+042h))&0ffh
	line	152
	
l17733:; BSR set to: 2

	movlw	high(01h)
	movlb	0	; () banked
	movwf	((cambiarEstado@state+1))&0ffh
	movlw	low(01h)
	movwf	((cambiarEstado@state))&0ffh
	call	_cambiarEstado	;wreg free
	goto	l17693
	line	166
	
l17735:; BSR set to: 2

	movlw	high(01h)
	movlb	0	; () banked
	movwf	((inicioEstado@state+1))&0ffh
	movlw	low(01h)
	movwf	((inicioEstado@state))&0ffh
	call	_inicioEstado	;wreg free
	iorlw	0
	btfsc	status,2
	goto	u22161
	goto	u22160
u22161:
	goto	l434
u22160:
	goto	l17713
	line	170
	
l434:; BSR set to: 2

	line	172
	btfss	(0+(_serial1+02Ah))&0ffh,0
	goto	u22171
	goto	u22170
u22171:
	goto	l436
u22170:
	line	174
	
l17739:; BSR set to: 2

	bcf	(0+(_serial1+02Ah))&0ffh,0
	line	175
	
l17741:; BSR set to: 2

	call	_oneBeep	;wreg free
	line	176
	
l17743:; BSR set to: 0

	call	_readDevide	;wreg free
	line	177
	goto	l17693
	line	178
	
l436:; BSR set to: 2

	btfss	(0+(_serial1+02Ah))&0ffh,1
	goto	u22181
	goto	u22180
u22181:
	goto	l438
u22180:
	line	180
	
l17745:; BSR set to: 2

	bcf	(0+(_serial1+02Ah))&0ffh,1
	line	181
	
l17747:; BSR set to: 2

	call	_oneBeep	;wreg free
	line	182
	goto	l17693
	line	183
	
l438:; BSR set to: 2

	btfss	(0+(_serial1+02Ah))&0ffh,2
	goto	u22191
	goto	u22190
u22191:
	goto	l17755
u22190:
	line	185
	
l17749:; BSR set to: 2

	bcf	(0+(_serial1+02Ah))&0ffh,2
	line	186
	
l17751:; BSR set to: 2

	call	_readMemoriaValues	;wreg free
	line	187
	
l17753:; BSR set to: 1

	bsf	(0+(_ala+05h))&0ffh,0
	line	188
	call	_oneBeep	;wreg free
	line	189
	goto	l17693
	line	190
	
l17755:; BSR set to: 2

	infsnz	(0+(_ap+040h))&0ffh
	incf	(1+(_ap+040h))&0ffh
		movlw	112
	subwf	 (0+(_ap+040h))&0ffh,w
	movlw	23
	subwfb	(1+(_ap+040h))&0ffh,w
	btfss	status,0
	goto	u22201
	goto	u22200

u22201:
	goto	l442
u22200:
	line	192
	
l17757:; BSR set to: 2

	movlw	high(0)
	movwf	(1+(_ap+040h))&0ffh
	movlw	low(0)
	movwf	(0+(_ap+040h))&0ffh
	line	193
	
l17759:; BSR set to: 2

	movlw	high(04h)
	movlb	0	; () banked
	movwf	((cambiarEstado@state+1))&0ffh
	movlw	low(04h)
	movwf	((cambiarEstado@state))&0ffh
	call	_cambiarEstado	;wreg free
	line	194
	goto	l17693
	line	197
	
l442:; BSR set to: 2

	btfss	(0+(_ap+08h))&0ffh,0
	goto	u22211
	goto	u22210
u22211:
	goto	l17763
u22210:
	line	199
	
l17761:; BSR set to: 2

	movlw	low(01h)
	movlb	1	; () banked
	movwf	(0+(_cl+02h))&0ffh
	line	200
	goto	l17693
	line	203
	
l17763:; BSR set to: 2

	movlw	low(0)
	movlb	1	; () banked
	movwf	(0+(_cl+02h))&0ffh
	goto	l17693
	line	209
	
l17765:; BSR set to: 2

	movlw	high(04h)
	movlb	0	; () banked
	movwf	((inicioEstado@state+1))&0ffh
	movlw	low(04h)
	movwf	((inicioEstado@state))&0ffh
	call	_inicioEstado	;wreg free
	iorlw	0
	btfsc	status,2
	goto	u22221
	goto	u22220
u22221:
	goto	l17733
u22220:
	line	211
	
l17767:; BSR set to: 2

	movlw	(01h)&0ffh
	
	call	_ADC_read
	movff	0+?_ADC_read,(___xxtofl@val)
	movff	1+?_ADC_read,(___xxtofl@val+1)
	clrf	((___xxtofl@val+2))&0ffh
	clrf	((___xxtofl@val+3))&0ffh
	movlw	(0)&0ffh
	
	call	___xxtofl
	movff	0+?___xxtofl,0+(_ap+044h)
	movff	1+?___xxtofl,1+(_ap+044h)
	movff	2+?___xxtofl,2+(_ap+044h)
	movff	3+?___xxtofl,3+(_ap+044h)
	
	line	212
	
l17769:; BSR set to: 0

	movff	0+(_ap+044h),(___flmul@b)
	movff	1+(_ap+044h),(___flmul@b+1)
	movff	2+(_ap+044h),(___flmul@b+2)
	movff	3+(_ap+044h),(___flmul@b+3)
	movlw	low(normalize32(0x3ba00000))
	movwf	((___flmul@a))&0ffh
	movlw	high(normalize32(0x3ba00000))
	movwf	((___flmul@a+1))&0ffh
	movlw	low highword(normalize32(0x3ba00000))
	movwf	((___flmul@a+2))&0ffh
	movlw	high highword(normalize32(0x3ba00000))
	movwf	((___flmul@a+3))&0ffh
	call	___flmul	;wreg free
	movff	0+?___flmul,0+(_ap+044h)
	movff	1+?___flmul,1+(_ap+044h)
	movff	2+?___flmul,2+(_ap+044h)
	movff	3+?___flmul,3+(_ap+044h)
	
	line	213
	
l17771:; BSR set to: 0

	movlw	low(normalize32(0x40c00000))
	movwf	((___flmul@a))&0ffh
	movlw	high(normalize32(0x40c00000))
	movwf	((___flmul@a+1))&0ffh
	movlw	low highword(normalize32(0x40c00000))
	movwf	((___flmul@a+2))&0ffh
	movlw	high highword(normalize32(0x40c00000))
	movwf	((___flmul@a+3))&0ffh
	movff	0+(_ap+044h),(___flmul@b)
	movff	1+(_ap+044h),(___flmul@b+1)
	movff	2+(_ap+044h),(___flmul@b+2)
	movff	3+(_ap+044h),(___flmul@b+3)
	call	___flmul	;wreg free
	movff	0+?___flmul,(___fladd@b)
	movff	1+?___flmul,(___fladd@b+1)
	movff	2+?___flmul,(___fladd@b+2)
	movff	3+?___flmul,(___fladd@b+3)
	
	movlw	low(normalize32(0x3e99999a))
	movlb	2	; () banked
	movwf	((___fladd@a))&0ffh
	movlw	high(normalize32(0x3e99999a))
	movwf	((___fladd@a+1))&0ffh
	movlw	low highword(normalize32(0x3e99999a))
	movwf	((___fladd@a+2))&0ffh
	movlw	high highword(normalize32(0x3e99999a))
	movwf	((___fladd@a+3))&0ffh
	call	___fladd	;wreg free
	movff	0+?___fladd,0+(_ap+044h)
	movff	1+?___fladd,1+(_ap+044h)
	movff	2+?___fladd,2+(_ap+044h)
	movff	3+?___fladd,3+(_ap+044h)
	
	line	214
	
l17773:
	movff	0+(_ap+044h),(___flmul@b)
	movff	1+(_ap+044h),(___flmul@b+1)
	movff	2+(_ap+044h),(___flmul@b+2)
	movff	3+(_ap+044h),(___flmul@b+3)
	movlw	low(normalize32(0x41200000))
	movlb	0	; () banked
	movwf	((___flmul@a))&0ffh
	movlw	high(normalize32(0x41200000))
	movwf	((___flmul@a+1))&0ffh
	movlw	low highword(normalize32(0x41200000))
	movwf	((___flmul@a+2))&0ffh
	movlw	high highword(normalize32(0x41200000))
	movwf	((___flmul@a+3))&0ffh
	call	___flmul	;wreg free
	movff	0+?___flmul,0+(_ap+044h)
	movff	1+?___flmul,1+(_ap+044h)
	movff	2+?___flmul,2+(_ap+044h)
	movff	3+?___flmul,3+(_ap+044h)
	
	line	216
	goto	l17693
	line	225
	
l17777:; BSR set to: 2

	movlw	high(05h)
	movlb	0	; () banked
	movwf	((inicioEstado@state+1))&0ffh
	movlw	low(05h)
	movwf	((inicioEstado@state))&0ffh
	call	_inicioEstado	;wreg free
	iorlw	0
	btfsc	status,2
	goto	u22231
	goto	u22230
u22231:
	goto	l17733
u22230:
	line	227
	
l17779:; BSR set to: 2

	movlw	(03h)&0ffh
	
	call	_ADC_read
	movff	0+?_ADC_read,(___xxtofl@val)
	movff	1+?_ADC_read,(___xxtofl@val+1)
	clrf	((___xxtofl@val+2))&0ffh
	clrf	((___xxtofl@val+3))&0ffh
	movlw	(0)&0ffh
	
	call	___xxtofl
	movff	0+?___xxtofl,0+(_ap+048h)
	movff	1+?___xxtofl,1+(_ap+048h)
	movff	2+?___xxtofl,2+(_ap+048h)
	movff	3+?___xxtofl,3+(_ap+048h)
	
	line	228
	
l17781:; BSR set to: 0

	movff	0+(_ap+048h),(___flmul@b)
	movff	1+(_ap+048h),(___flmul@b+1)
	movff	2+(_ap+048h),(___flmul@b+2)
	movff	3+(_ap+048h),(___flmul@b+3)
	movlw	low(normalize32(0x3ba00000))
	movwf	((___flmul@a))&0ffh
	movlw	high(normalize32(0x3ba00000))
	movwf	((___flmul@a+1))&0ffh
	movlw	low highword(normalize32(0x3ba00000))
	movwf	((___flmul@a+2))&0ffh
	movlw	high highword(normalize32(0x3ba00000))
	movwf	((___flmul@a+3))&0ffh
	call	___flmul	;wreg free
	movff	0+?___flmul,0+(_ap+048h)
	movff	1+?___flmul,1+(_ap+048h)
	movff	2+?___flmul,2+(_ap+048h)
	movff	3+?___flmul,3+(_ap+048h)
	
	line	229
	
l17783:; BSR set to: 0

	movff	0+(_ap+048h),(___flmul@b)
	movff	1+(_ap+048h),(___flmul@b+1)
	movff	2+(_ap+048h),(___flmul@b+2)
	movff	3+(_ap+048h),(___flmul@b+3)
	movlw	low(normalize32(0x41200000))
	movwf	((___flmul@a))&0ffh
	movlw	high(normalize32(0x41200000))
	movwf	((___flmul@a+1))&0ffh
	movlw	low highword(normalize32(0x41200000))
	movwf	((___flmul@a+2))&0ffh
	movlw	high highword(normalize32(0x41200000))
	movwf	((___flmul@a+3))&0ffh
	call	___flmul	;wreg free
	movff	0+?___flmul,0+(_ap+048h)
	movff	1+?___flmul,1+(_ap+048h)
	movff	2+?___flmul,2+(_ap+048h)
	movff	3+?___flmul,3+(_ap+048h)
	
	line	230
	goto	l17693
	line	237
	
l17789:; BSR set to: 0

	movf	((_stateAp))&0ffh,w
	movlb	2	; () banked
	movwf	(??_taskAplicacion+0+0)&0ffh
	clrf	(??_taskAplicacion+0+0+1)&0ffh

	; Switch on 2 bytes has been partitioned into a top level switch of size 1, and 1 sub-switches
; Switch size 1, requested type "simple"
; Number of cases is 1, Range of values is 0 to 0
; switch strategies available:
; Name         Instructions Cycles
; simple_byte            4     3 (average)
;	Chosen strategy is simple_byte

	movf ??_taskAplicacion+0+1&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l18599
	goto	l17693
	
l18599:; BSR set to: 2

; Switch size 1, requested type "simple"
; Number of cases is 6, Range of values is 0 to 5
; switch strategies available:
; Name         Instructions Cycles
; simple_byte           19    10 (average)
;	Chosen strategy is simple_byte

	movf ??_taskAplicacion+0+0&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l17701
	xorlw	1^0	; case 1
	skipnz
	goto	l17735
	xorlw	2^1	; case 2
	skipnz
	goto	l17693
	xorlw	3^2	; case 3
	skipnz
	goto	l17711
	xorlw	4^3	; case 4
	skipnz
	goto	l17765
	xorlw	5^4	; case 5
	skipnz
	goto	l17777
	goto	l17693

	line	239
	
l17791:; BSR set to: 2

	movff	(taskAplicacion@pt),fsr2l
	movff	(taskAplicacion@pt+1),fsr2h
	movff	postinc2,??_taskAplicacion+0+0
	movff	postdec2,??_taskAplicacion+0+0+1
	; Switch on 2 bytes has been partitioned into a top level switch of size 1, and 1 sub-switches
; Switch size 1, requested type "simple"
; Number of cases is 1, Range of values is 0 to 0
; switch strategies available:
; Name         Instructions Cycles
; simple_byte            4     3 (average)
;	Chosen strategy is simple_byte

	movf ??_taskAplicacion+0+1&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l18601
	goto	l17793
	
l18601:; BSR set to: 2

; Switch size 1, requested type "simple"
; Number of cases is 2, Range of values is 0 to 63
; switch strategies available:
; Name         Instructions Cycles
; simple_byte            7     4 (average)
;	Chosen strategy is simple_byte

	movf ??_taskAplicacion+0+0&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l17693
	xorlw	63^0	; case 63
	skipnz
	goto	l17697
	goto	l17793

	
l17793:; BSR set to: 2

	
l17795:; BSR set to: 2

	movff	(taskAplicacion@pt),fsr2l
	movff	(taskAplicacion@pt+1),fsr2h
	movlw	low(0)
	movwf	postinc2,c
	movlw	high(0)
	movwf	postdec2,c
	line	240
	
l420:
	return	;funcret
	callstack 0
GLOBAL	__end_of_taskAplicacion
	__end_of_taskAplicacion:
	signat	_taskAplicacion,4218
	global	_twoBeep

;; *************** function _twoBeep *****************
;; Defined at:
;;		line 138 in file "Buzzer.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_taskAplicacion
;; This function uses a non-reentrant model
;;
psect	text18,class=CODE,space=0,reloc=2,group=0
	file	"Buzzer.c"
	line	138
global __ptext18
__ptext18:
psect	text18
	file	"Buzzer.c"
	line	138
	
_twoBeep:
;incstack = 0
	callstack 16
	line	140
	
l6051:; BSR set to: 0

	movlw	low(02h)
	movwf	((_ucTypeBeep))&0ffh
	line	141
	movlw	low(02h)
	movwf	((_ucIteradorBuzzer))&0ffh
	line	142
	movlw	low(01h)
	movwf	((c:_flagStartBuzzer))^00h,c
	line	143
	
l555:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_twoBeep
	__end_of_twoBeep:
	signat	_twoBeep,89
	global	_reiniciarTemporizador

;; *************** function _reiniciarTemporizador *****************
;; Defined at:
;;		line 274 in file "Aplicacion.c"
;; Parameters:    Size  Location     Type
;;  time            2   37[BANK0 ] PTR unsigned int 
;;		 -> ap(76), 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 3F/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       2       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       2       0       0       0       0       0       0       0
;;Total ram usage:        2 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_taskAplicacion
;; This function uses a non-reentrant model
;;
psect	text19,class=CODE,space=0,reloc=2,group=0
	file	"Aplicacion.c"
	line	274
global __ptext19
__ptext19:
psect	text19
	file	"Aplicacion.c"
	line	274
	
_reiniciarTemporizador:; BSR set to: 0

;incstack = 0
	callstack 16
	line	276
	
l6049:; BSR set to: 0

	movff	(reiniciarTemporizador@time),fsr2l
	movff	(reiniciarTemporizador@time+1),fsr2h
	movlw	low(0)
	movwf	postinc2,c
	movlw	high(0)
	movwf	postdec2,c
	line	277
	
l470:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_reiniciarTemporizador
	__end_of_reiniciarTemporizador:
	signat	_reiniciarTemporizador,4217
	global	_readMemoriaValues

;; *************** function _readMemoriaValues *****************
;; Defined at:
;;		line 353 in file "Aplicacion.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2, cstack
;; Tracked objects:
;;		On entry : 3C/1
;;		On exit  : 3F/1
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 13
;; This function calls:
;;		_EEpromRead
;; This function is called by:
;;		_taskAplicacion
;; This function uses a non-reentrant model
;;
psect	text20,class=CODE,space=0,reloc=2,group=0
	line	353
global __ptext20
__ptext20:
psect	text20
	file	"Aplicacion.c"
	line	353
	
_readMemoriaValues:; BSR set to: 0

;incstack = 0
	callstack 15
	line	355
	
l6075:
	movlw	high(01h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(01h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+01h))&0ffh
	line	356
	movlw	high(02h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(02h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+02h))&0ffh
	line	357
	movlw	high(03h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(03h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+03h))&0ffh
	line	359
	movlw	high(04h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(04h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+04h))&0ffh
	line	360
	movlw	high(05h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(05h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+05h))&0ffh
	line	362
	movlw	high(06h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(06h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+06h))&0ffh
	line	363
	movlw	high(07h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(07h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+07h))&0ffh
	line	366
	movlw	high(08h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(08h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+08h))&0ffh
	line	367
	movlw	high(09h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(09h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+09h))&0ffh
	line	368
	movlw	high(0Ah)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(0Ah)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+0Ah))&0ffh
	line	370
	movlw	high(0Bh)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(0Bh)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+0Bh))&0ffh
	line	371
	movlw	high(0Ch)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(0Ch)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+0Ch))&0ffh
	line	373
	movlw	high(0Dh)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(0Dh)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+0Dh))&0ffh
	line	374
	movlw	high(0Eh)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(0Eh)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+0Eh))&0ffh
	line	377
	movlw	high(0Fh)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(0Fh)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+0Fh))&0ffh
	line	378
	movlw	high(010h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(010h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+010h))&0ffh
	line	379
	movlw	high(011h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(011h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+011h))&0ffh
	line	381
	movlw	high(012h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(012h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+012h))&0ffh
	line	382
	movlw	high(013h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(013h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+013h))&0ffh
	line	384
	movlw	high(014h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(014h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+014h))&0ffh
	line	385
	movlw	high(015h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(015h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+015h))&0ffh
	line	388
	movlw	high(016h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(016h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+016h))&0ffh
	line	389
	movlw	high(017h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(017h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+017h))&0ffh
	line	390
	movlw	high(018h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(018h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+018h))&0ffh
	line	392
	movlw	high(019h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(019h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+019h))&0ffh
	line	393
	movlw	high(01Ah)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(01Ah)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+01Ah))&0ffh
	line	395
	movlw	high(01Bh)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(01Bh)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+01Bh))&0ffh
	line	396
	movlw	high(01Ch)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(01Ch)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+01Ch))&0ffh
	line	399
	movlw	high(01Dh)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(01Dh)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+01Dh))&0ffh
	line	400
	movlw	high(01Eh)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(01Eh)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+01Eh))&0ffh
	line	401
	movlw	high(01Fh)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(01Fh)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+01Fh))&0ffh
	line	403
	movlw	high(020h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(020h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+020h))&0ffh
	line	404
	movlw	high(021h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(021h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+021h))&0ffh
	line	406
	movlw	high(022h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(022h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+022h))&0ffh
	line	407
	movlw	high(023h)
	movlb	0	; () banked
	movwf	((EEpromRead@address+1))&0ffh
	movlw	low(023h)
	movwf	((EEpromRead@address))&0ffh
	call	_EEpromRead	;wreg free
	movlb	1	; () banked
	movwf	(0+(_memo+023h))&0ffh
	line	409
	
l491:; BSR set to: 1

	return	;funcret
	callstack 0
GLOBAL	__end_of_readMemoriaValues
	__end_of_readMemoriaValues:
	signat	_readMemoriaValues,89
	global	_EEpromRead

;; *************** function _EEpromRead *****************
;; Defined at:
;;		line 29 in file "EEprom.c"
;; Parameters:    Size  Location     Type
;;  address         2   37[BANK0 ] unsigned int 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      unsigned char 
;; Registers used:
;;		wreg, status,2
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 3F/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       2       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       2       0       0       0       0       0       0       0
;;Total ram usage:        2 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_taskAplicacion
;;		_readMemoriaValues
;; This function uses a non-reentrant model
;;
psect	text21,class=CODE,space=0,reloc=2,group=0
	file	"EEprom.c"
	line	29
global __ptext21
__ptext21:
psect	text21
	file	"EEprom.c"
	line	29
	
_EEpromRead:; BSR set to: 1

;incstack = 0
	callstack 15
	line	31
	
l5739:; BSR set to: 0

	movff	(EEpromRead@address),(c:4009)	;volatile
	line	33
	bcf	((c:4006))^0f00h,c,7	;volsfr
	line	34
	bcf	((c:4006))^0f00h,c,6	;volsfr
	line	35
	bsf	((c:4006))^0f00h,c,0	;volsfr
	line	37
	
l5741:; BSR set to: 0

	movf	((c:4008))^0f00h,c,w	;volatile
	line	38
	
l680:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_EEpromRead
	__end_of_EEpromRead:
	signat	_EEpromRead,4217
	global	_readDevide

;; *************** function _readDevide *****************
;; Defined at:
;;		line 285 in file "Aplicacion.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;  bufferEnable    5   61[BANK2 ] unsigned char [5]
;;  bufferHorari    5   56[BANK2 ] unsigned char [5]
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0      10       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0      10       0       0       0       0       0
;;Total ram usage:       10 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 22
;; This function calls:
;;		_cleanBuffer
;;		_convOnOff
;;		_convStringDayWeek
;;		_sprintf
;;		_transmitUart1
;; This function is called by:
;;		_taskAplicacion
;; This function uses a non-reentrant model
;;
psect	text22,class=CODE,space=0,reloc=2,group=0
	file	"Aplicacion.c"
	line	285
global __ptext22
__ptext22:
psect	text22
	file	"Aplicacion.c"
	line	285
	
_readDevide:; BSR set to: 0

;incstack = 0
	callstack 6
	line	291
	
l17385:; BSR set to: 0

		movlw	low(_ap+09h)
	movwf	((cleanBuffer@orig))&0ffh
	movlw	high(_ap+09h)
	movwf	((cleanBuffer@orig+1))&0ffh

	call	_cleanBuffer	;wreg free
	line	292
		movlw	low(_ap+09h)
	movlb	2	; () banked
	movwf	((sprintf@s))&0ffh
	movlw	high(_ap+09h)
	movwf	((sprintf@s+1))&0ffh

		movlw	low(STR_4)
	movwf	((sprintf@fmt))&0ffh
	movlw	high(STR_4)
	movwf	((sprintf@fmt+1))&0ffh

	movff	0+(_rtc+02h),0+(?_sprintf+04h)
	clrf	(1+(?_sprintf+04h))&0ffh
	movff	0+(_rtc+01h),0+(?_sprintf+06h)
	clrf	(1+(?_sprintf+06h))&0ffh
	movff	(_rtc),0+(?_sprintf+08h)
	clrf	(1+(?_sprintf+08h))&0ffh
	call	_sprintf	;wreg free
	line	293
		movlw	low(_ap+09h)
	movlb	0	; () banked
	movwf	((transmitUart1@ptr))&0ffh
	movlw	high(_ap+09h)
	movwf	((transmitUart1@ptr+1))&0ffh

	call	_transmitUart1	;wreg free
	line	295
		movlw	low(_ap+09h)
	movwf	((cleanBuffer@orig))&0ffh
	movlw	high(_ap+09h)
	movwf	((cleanBuffer@orig+1))&0ffh

	call	_cleanBuffer	;wreg free
	line	296
		movlw	low(_ap+09h)
	movlb	2	; () banked
	movwf	((sprintf@s))&0ffh
	movlw	high(_ap+09h)
	movwf	((sprintf@s+1))&0ffh

		movlw	low(STR_5)
	movwf	((sprintf@fmt))&0ffh
	movlw	high(STR_5)
	movwf	((sprintf@fmt+1))&0ffh

	movff	0+(_rtc+03h),0+(?_sprintf+04h)
	clrf	(1+(?_sprintf+04h))&0ffh
	movff	0+(_rtc+04h),0+(?_sprintf+06h)
	clrf	(1+(?_sprintf+06h))&0ffh
	movff	0+(_rtc+05h),0+(?_sprintf+08h)
	clrf	(1+(?_sprintf+08h))&0ffh
	movff	0+(_rtc+06h),0+(?_sprintf+0Ah)
	clrf	(1+(?_sprintf+0Ah))&0ffh
	call	_sprintf	;wreg free
	line	297
		movlw	low(_ap+09h)
	movlb	0	; () banked
	movwf	((transmitUart1@ptr))&0ffh
	movlw	high(_ap+09h)
	movwf	((transmitUart1@ptr+1))&0ffh

	call	_transmitUart1	;wreg free
	line	299
		movlw	low(_ap+09h)
	movwf	((cleanBuffer@orig))&0ffh
	movlw	high(_ap+09h)
	movwf	((cleanBuffer@orig+1))&0ffh

	call	_cleanBuffer	;wreg free
	line	300
		movlw	low(_ap+09h)
	movlb	2	; () banked
	movwf	((sprintf@s))&0ffh
	movlw	high(_ap+09h)
	movwf	((sprintf@s+1))&0ffh

		movlw	low(STR_6)
	movwf	((sprintf@fmt))&0ffh
	movlw	high(STR_6)
	movwf	((sprintf@fmt+1))&0ffh

	call	_sprintf	;wreg free
	line	301
		movlw	low(_ap+09h)
	movlb	0	; () banked
	movwf	((transmitUart1@ptr))&0ffh
	movlw	high(_ap+09h)
	movwf	((transmitUart1@ptr+1))&0ffh

	call	_transmitUart1	;wreg free
	line	303
		movlw	low(readDevide@bufferEnable)
	movlb	2	; () banked
	movwf	((convOnOff@dest))&0ffh
	movlw	high(readDevide@bufferEnable)
	movwf	((convOnOff@dest+1))&0ffh

	movff	0+(_memo+01h),(convOnOff@enable)
	call	_convOnOff	;wreg free
	line	304
		movlw	low(readDevide@bufferHorario)
	movwf	((convStringDayWeek@dest))&0ffh
	movlw	high(readDevide@bufferHorario)
	movwf	((convStringDayWeek@dest+1))&0ffh

	movff	0+(_memo+03h),(convStringDayWeek@dayWeek)
	call	_convStringDayWeek	;wreg free
	line	305
		movlw	low(_ap+09h)
	movlb	0	; () banked
	movwf	((cleanBuffer@orig))&0ffh
	movlw	high(_ap+09h)
	movwf	((cleanBuffer@orig+1))&0ffh

	call	_cleanBuffer	;wreg free
	line	306
		movlw	low(_ap+09h)
	movlb	2	; () banked
	movwf	((sprintf@s))&0ffh
	movlw	high(_ap+09h)
	movwf	((sprintf@s+1))&0ffh

		movlw	low(STR_7)
	movwf	((sprintf@fmt))&0ffh
	movlw	high(STR_7)
	movwf	((sprintf@fmt+1))&0ffh

	movff	0+(_memo+04h),0+(?_sprintf+04h)
	clrf	(1+(?_sprintf+04h))&0ffh
	movff	0+(_memo+05h),0+(?_sprintf+06h)
	clrf	(1+(?_sprintf+06h))&0ffh
	movff	0+(_memo+06h),0+(?_sprintf+08h)
	clrf	(1+(?_sprintf+08h))&0ffh
	movff	0+(_memo+07h),0+(?_sprintf+0Ah)
	clrf	(1+(?_sprintf+0Ah))&0ffh
		movlw	low(readDevide@bufferEnable)
	movwf	(0+(?_sprintf+0Ch))&0ffh
	movlw	high(readDevide@bufferEnable)
	movwf	(1+(?_sprintf+0Ch))&0ffh

		movlw	low(readDevide@bufferHorario)
	movwf	(0+(?_sprintf+0Eh))&0ffh
	movlw	high(readDevide@bufferHorario)
	movwf	(1+(?_sprintf+0Eh))&0ffh

	call	_sprintf	;wreg free
	line	307
		movlw	low(_ap+09h)
	movlb	0	; () banked
	movwf	((transmitUart1@ptr))&0ffh
	movlw	high(_ap+09h)
	movwf	((transmitUart1@ptr+1))&0ffh

	call	_transmitUart1	;wreg free
	line	309
		movlw	low(readDevide@bufferEnable)
	movlb	2	; () banked
	movwf	((convOnOff@dest))&0ffh
	movlw	high(readDevide@bufferEnable)
	movwf	((convOnOff@dest+1))&0ffh

	movff	0+(_memo+08h),(convOnOff@enable)
	call	_convOnOff	;wreg free
	line	310
		movlw	low(readDevide@bufferHorario)
	movwf	((convStringDayWeek@dest))&0ffh
	movlw	high(readDevide@bufferHorario)
	movwf	((convStringDayWeek@dest+1))&0ffh

	movff	0+(_memo+0Ah),(convStringDayWeek@dayWeek)
	call	_convStringDayWeek	;wreg free
	line	311
		movlw	low(_ap+09h)
	movlb	0	; () banked
	movwf	((cleanBuffer@orig))&0ffh
	movlw	high(_ap+09h)
	movwf	((cleanBuffer@orig+1))&0ffh

	call	_cleanBuffer	;wreg free
	line	312
		movlw	low(_ap+09h)
	movlb	2	; () banked
	movwf	((sprintf@s))&0ffh
	movlw	high(_ap+09h)
	movwf	((sprintf@s+1))&0ffh

		movlw	low(STR_8)
	movwf	((sprintf@fmt))&0ffh
	movlw	high(STR_8)
	movwf	((sprintf@fmt+1))&0ffh

	movff	0+(_memo+0Bh),0+(?_sprintf+04h)
	clrf	(1+(?_sprintf+04h))&0ffh
	movff	0+(_memo+0Ch),0+(?_sprintf+06h)
	clrf	(1+(?_sprintf+06h))&0ffh
	movff	0+(_memo+0Dh),0+(?_sprintf+08h)
	clrf	(1+(?_sprintf+08h))&0ffh
	movff	0+(_memo+0Eh),0+(?_sprintf+0Ah)
	clrf	(1+(?_sprintf+0Ah))&0ffh
		movlw	low(readDevide@bufferEnable)
	movwf	(0+(?_sprintf+0Ch))&0ffh
	movlw	high(readDevide@bufferEnable)
	movwf	(1+(?_sprintf+0Ch))&0ffh

		movlw	low(readDevide@bufferHorario)
	movwf	(0+(?_sprintf+0Eh))&0ffh
	movlw	high(readDevide@bufferHorario)
	movwf	(1+(?_sprintf+0Eh))&0ffh

	call	_sprintf	;wreg free
	line	313
		movlw	low(_ap+09h)
	movlb	0	; () banked
	movwf	((transmitUart1@ptr))&0ffh
	movlw	high(_ap+09h)
	movwf	((transmitUart1@ptr+1))&0ffh

	call	_transmitUart1	;wreg free
	line	315
		movlw	low(readDevide@bufferEnable)
	movlb	2	; () banked
	movwf	((convOnOff@dest))&0ffh
	movlw	high(readDevide@bufferEnable)
	movwf	((convOnOff@dest+1))&0ffh

	movff	0+(_memo+0Fh),(convOnOff@enable)
	call	_convOnOff	;wreg free
	line	316
		movlw	low(readDevide@bufferHorario)
	movwf	((convStringDayWeek@dest))&0ffh
	movlw	high(readDevide@bufferHorario)
	movwf	((convStringDayWeek@dest+1))&0ffh

	movff	0+(_memo+011h),(convStringDayWeek@dayWeek)
	call	_convStringDayWeek	;wreg free
	line	317
		movlw	low(_ap+09h)
	movlb	0	; () banked
	movwf	((cleanBuffer@orig))&0ffh
	movlw	high(_ap+09h)
	movwf	((cleanBuffer@orig+1))&0ffh

	call	_cleanBuffer	;wreg free
	line	318
		movlw	low(_ap+09h)
	movlb	2	; () banked
	movwf	((sprintf@s))&0ffh
	movlw	high(_ap+09h)
	movwf	((sprintf@s+1))&0ffh

		movlw	low(STR_9)
	movwf	((sprintf@fmt))&0ffh
	movlw	high(STR_9)
	movwf	((sprintf@fmt+1))&0ffh

	movff	0+(_memo+012h),0+(?_sprintf+04h)
	clrf	(1+(?_sprintf+04h))&0ffh
	movff	0+(_memo+013h),0+(?_sprintf+06h)
	clrf	(1+(?_sprintf+06h))&0ffh
	movff	0+(_memo+014h),0+(?_sprintf+08h)
	clrf	(1+(?_sprintf+08h))&0ffh
	movff	0+(_memo+015h),0+(?_sprintf+0Ah)
	clrf	(1+(?_sprintf+0Ah))&0ffh
		movlw	low(readDevide@bufferEnable)
	movwf	(0+(?_sprintf+0Ch))&0ffh
	movlw	high(readDevide@bufferEnable)
	movwf	(1+(?_sprintf+0Ch))&0ffh

		movlw	low(readDevide@bufferHorario)
	movwf	(0+(?_sprintf+0Eh))&0ffh
	movlw	high(readDevide@bufferHorario)
	movwf	(1+(?_sprintf+0Eh))&0ffh

	call	_sprintf	;wreg free
	line	319
		movlw	low(_ap+09h)
	movlb	0	; () banked
	movwf	((transmitUart1@ptr))&0ffh
	movlw	high(_ap+09h)
	movwf	((transmitUart1@ptr+1))&0ffh

	call	_transmitUart1	;wreg free
	line	321
		movlw	low(readDevide@bufferEnable)
	movlb	2	; () banked
	movwf	((convOnOff@dest))&0ffh
	movlw	high(readDevide@bufferEnable)
	movwf	((convOnOff@dest+1))&0ffh

	movff	0+(_memo+016h),(convOnOff@enable)
	call	_convOnOff	;wreg free
	line	322
		movlw	low(readDevide@bufferHorario)
	movwf	((convStringDayWeek@dest))&0ffh
	movlw	high(readDevide@bufferHorario)
	movwf	((convStringDayWeek@dest+1))&0ffh

	movff	0+(_memo+018h),(convStringDayWeek@dayWeek)
	call	_convStringDayWeek	;wreg free
	line	323
		movlw	low(_ap+09h)
	movlb	0	; () banked
	movwf	((cleanBuffer@orig))&0ffh
	movlw	high(_ap+09h)
	movwf	((cleanBuffer@orig+1))&0ffh

	call	_cleanBuffer	;wreg free
	line	324
		movlw	low(_ap+09h)
	movlb	2	; () banked
	movwf	((sprintf@s))&0ffh
	movlw	high(_ap+09h)
	movwf	((sprintf@s+1))&0ffh

		movlw	low(STR_10)
	movwf	((sprintf@fmt))&0ffh
	movlw	high(STR_10)
	movwf	((sprintf@fmt+1))&0ffh

	movff	0+(_memo+019h),0+(?_sprintf+04h)
	clrf	(1+(?_sprintf+04h))&0ffh
	movff	0+(_memo+01Ah),0+(?_sprintf+06h)
	clrf	(1+(?_sprintf+06h))&0ffh
	movff	0+(_memo+01Bh),0+(?_sprintf+08h)
	clrf	(1+(?_sprintf+08h))&0ffh
	movff	0+(_memo+01Ch),0+(?_sprintf+0Ah)
	clrf	(1+(?_sprintf+0Ah))&0ffh
		movlw	low(readDevide@bufferEnable)
	movwf	(0+(?_sprintf+0Ch))&0ffh
	movlw	high(readDevide@bufferEnable)
	movwf	(1+(?_sprintf+0Ch))&0ffh

		movlw	low(readDevide@bufferHorario)
	movwf	(0+(?_sprintf+0Eh))&0ffh
	movlw	high(readDevide@bufferHorario)
	movwf	(1+(?_sprintf+0Eh))&0ffh

	call	_sprintf	;wreg free
	line	325
		movlw	low(_ap+09h)
	movlb	0	; () banked
	movwf	((transmitUart1@ptr))&0ffh
	movlw	high(_ap+09h)
	movwf	((transmitUart1@ptr+1))&0ffh

	call	_transmitUart1	;wreg free
	line	327
		movlw	low(readDevide@bufferEnable)
	movlb	2	; () banked
	movwf	((convOnOff@dest))&0ffh
	movlw	high(readDevide@bufferEnable)
	movwf	((convOnOff@dest+1))&0ffh

	movff	0+(_memo+01Dh),(convOnOff@enable)
	call	_convOnOff	;wreg free
	line	328
		movlw	low(readDevide@bufferHorario)
	movwf	((convStringDayWeek@dest))&0ffh
	movlw	high(readDevide@bufferHorario)
	movwf	((convStringDayWeek@dest+1))&0ffh

	movff	0+(_memo+01Fh),(convStringDayWeek@dayWeek)
	call	_convStringDayWeek	;wreg free
	line	329
		movlw	low(_ap+09h)
	movlb	0	; () banked
	movwf	((cleanBuffer@orig))&0ffh
	movlw	high(_ap+09h)
	movwf	((cleanBuffer@orig+1))&0ffh

	call	_cleanBuffer	;wreg free
	line	330
		movlw	low(_ap+09h)
	movlb	2	; () banked
	movwf	((sprintf@s))&0ffh
	movlw	high(_ap+09h)
	movwf	((sprintf@s+1))&0ffh

		movlw	low(STR_11)
	movwf	((sprintf@fmt))&0ffh
	movlw	high(STR_11)
	movwf	((sprintf@fmt+1))&0ffh

	movff	0+(_memo+020h),0+(?_sprintf+04h)
	clrf	(1+(?_sprintf+04h))&0ffh
	movff	0+(_memo+021h),0+(?_sprintf+06h)
	clrf	(1+(?_sprintf+06h))&0ffh
	movff	0+(_memo+022h),0+(?_sprintf+08h)
	clrf	(1+(?_sprintf+08h))&0ffh
	movff	0+(_memo+023h),0+(?_sprintf+0Ah)
	clrf	(1+(?_sprintf+0Ah))&0ffh
		movlw	low(readDevide@bufferEnable)
	movwf	(0+(?_sprintf+0Ch))&0ffh
	movlw	high(readDevide@bufferEnable)
	movwf	(1+(?_sprintf+0Ch))&0ffh

		movlw	low(readDevide@bufferHorario)
	movwf	(0+(?_sprintf+0Eh))&0ffh
	movlw	high(readDevide@bufferHorario)
	movwf	(1+(?_sprintf+0Eh))&0ffh

	call	_sprintf	;wreg free
	line	331
		movlw	low(_ap+09h)
	movlb	0	; () banked
	movwf	((transmitUart1@ptr))&0ffh
	movlw	high(_ap+09h)
	movwf	((transmitUart1@ptr+1))&0ffh

	call	_transmitUart1	;wreg free
	line	334
	
l476:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_readDevide
	__end_of_readDevide:
	signat	_readDevide,89
	global	_transmitUart1

;; *************** function _transmitUart1 *****************
;; Defined at:
;;		line 51 in file "Serial.c"
;; Parameters:    Size  Location     Type
;;  ptr             2   53[BANK0 ] PTR unsigned char 
;;		 -> STR_3(25), ap(76), 
;; Auto vars:     Size  Location     Type
;;  x               2   47[BANK2 ] int 
;;  bufferTx1      45    0[BANK2 ] unsigned char [45]
;;  ucCntTx1        2   45[BANK2 ] int 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       2       0       0       0       0       0       0       0
;;      Locals:         0       0       0      49       0       0       0       0       0
;;      Temps:          0       1       0       0       0       0       0       0       0
;;      Totals:         0       3       0      49       0       0       0       0       0
;;Total ram usage:       52 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 13
;; This function calls:
;;		_memcpy
;;		_memset
;;		_strlen
;; This function is called by:
;;		_taskAplicacion
;;		_readDevide
;; This function uses a non-reentrant model
;;
psect	text23,class=CODE,space=0,reloc=2,group=0
	file	"Serial.c"
	line	51
global __ptext23
__ptext23:
psect	text23
	file	"Serial.c"
	line	51
	
_transmitUart1:; BSR set to: 0

;incstack = 0
	callstack 15
	line	54
	
l17203:; BSR set to: 0

	line	56
	
l17205:; BSR set to: 0

		movlw	low(transmitUart1@bufferTx1)
	movwf	((memset@dest))&0ffh
	movlw	high(transmitUart1@bufferTx1)
	movwf	((memset@dest+1))&0ffh

	movlw	high(0)
	movwf	((memset@c+1))&0ffh
	movlw	low(0)
	movwf	((memset@c))&0ffh
	movlw	high(02Dh)
	movwf	((memset@n+1))&0ffh
	movlw	low(02Dh)
	movwf	((memset@n))&0ffh
	call	_memset	;wreg free
	line	57
	
l17207:; BSR set to: 0

		movlw	low(transmitUart1@bufferTx1)
	movwf	((memcpy@d1))&0ffh
	movlw	high(transmitUart1@bufferTx1)
	movwf	((memcpy@d1+1))&0ffh

		movff	(transmitUart1@ptr),(memcpy@s1)
	movff	(transmitUart1@ptr+1),(memcpy@s1+1)

		movff	(transmitUart1@ptr),(strlen@s)
	movff	(transmitUart1@ptr+1),(strlen@s+1)

	call	_strlen	;wreg free
	movff	0+?_strlen,(memcpy@n)
	movff	1+?_strlen,(memcpy@n+1)
	call	_memcpy	;wreg free
	line	59
	
l17209:; BSR set to: 0

		movlw	low(transmitUart1@bufferTx1)
	movwf	((strlen@s))&0ffh
	movlw	high(transmitUart1@bufferTx1)
	movwf	((strlen@s+1))&0ffh

	call	_strlen	;wreg free
	movff	0+?_strlen,(transmitUart1@ucCntTx1)
	movff	1+?_strlen,(transmitUart1@ucCntTx1+1)
	line	61
	
l17211:; BSR set to: 0

	movlw	high(0)
	movlb	2	; () banked
	movwf	((transmitUart1@x+1))&0ffh
	movlw	low(0)
	movwf	((transmitUart1@x))&0ffh
	goto	l17217
	line	63
	
l17213:; BSR set to: 0

	movlw	low(transmitUart1@bufferTx1)
	movlb	2	; () banked
	addwf	((transmitUart1@x))&0ffh,w
	movwf	c:fsr2l
	movlw	high(transmitUart1@bufferTx1)
	addwfc	((transmitUart1@x+1))&0ffh,w
	movwf	1+c:fsr2l
	movf	indf2,w
	movwf	((c:4013))^0f00h,c	;volatile
	line	64
	
l823:
	btfss	((c:4012))^0f00h,c,1	;volatile
	goto	u21231
	goto	u21230
u21231:
	goto	l823
u21230:
	line	66
	
l17215:
	movlb	2	; () banked
	infsnz	((transmitUart1@x))&0ffh
	incf	((transmitUart1@x+1))&0ffh
	
l17217:; BSR set to: 2

		movf	((transmitUart1@x))&0ffh,w
	subwf	((transmitUart1@ucCntTx1))&0ffh,w
	movf	((transmitUart1@ucCntTx1+1))&0ffh,w
	xorlw	80h
	movlb	0	; () banked
	movwf	(??_transmitUart1+0+0)&0ffh
	movlb	2	; () banked
	movf	((transmitUart1@x+1))&0ffh,w
	xorlw	80h
	movlb	0	; () banked
	subwfb	(??_transmitUart1+0+0)&0ffh,w
	btfsc	status,0
	goto	u21241
	goto	u21240

u21241:
	goto	l17213
u21240:
	line	67
	
l827:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_transmitUart1
	__end_of_transmitUart1:
	signat	_transmitUart1,4217
	global	_convStringDayWeek

;; *************** function _convStringDayWeek *****************
;; Defined at:
;;		line 336 in file "Aplicacion.c"
;; Parameters:    Size  Location     Type
;;  dest            2   53[BANK2 ] PTR unsigned char 
;;		 -> readDevide@bufferHorario(5), 
;;  dayWeek         1   55[BANK2 ] unsigned char 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 3F/2
;;		On exit  : 3F/2
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       3       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       3       0       0       0       0       0
;;Total ram usage:        3 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 21
;; This function calls:
;;		_memset
;;		_sprintf
;;		_strlen
;; This function is called by:
;;		_readDevide
;; This function uses a non-reentrant model
;;
psect	text24,class=CODE,space=0,reloc=2,group=0
	file	"Aplicacion.c"
	line	336
global __ptext24
__ptext24:
psect	text24
	file	"Aplicacion.c"
	line	336
	
_convStringDayWeek:; BSR set to: 0

;incstack = 0
	callstack 6
	line	338
	
l17229:; BSR set to: 2

		movff	(convStringDayWeek@dest),(memset@dest)
	movff	(convStringDayWeek@dest+1),(memset@dest+1)

	movlw	high(0)
	movlb	0	; () banked
	movwf	((memset@c+1))&0ffh
	movlw	low(0)
	movwf	((memset@c))&0ffh
		movff	(convStringDayWeek@dest),(strlen@s)
	movff	(convStringDayWeek@dest+1),(strlen@s+1)

	call	_strlen	;wreg free
	movff	0+?_strlen,(memset@n)
	movff	1+?_strlen,(memset@n+1)
	call	_memset	;wreg free
	line	340
	
l17231:; BSR set to: 0

		movlw	8
	movlb	2	; () banked
	xorwf	((convStringDayWeek@dayWeek))&0ffh,w
	btfss	status,2
	goto	u21261
	goto	u21260

u21261:
	goto	l17235
u21260:
	
l17233:; BSR set to: 2

		movff	(convStringDayWeek@dest),(sprintf@s)
	movff	(convStringDayWeek@dest+1),(sprintf@s+1)

		movlw	low(STR_12)
	movwf	((sprintf@fmt))&0ffh
	movlw	high(STR_12)
	movwf	((sprintf@fmt+1))&0ffh

	call	_sprintf	;wreg free
	goto	l483
	line	341
	
l17235:; BSR set to: 2

		movlw	9
	xorwf	((convStringDayWeek@dayWeek))&0ffh,w
	btfss	status,2
	goto	u21271
	goto	u21270

u21271:
	goto	l17239
u21270:
	
l17237:; BSR set to: 2

		movff	(convStringDayWeek@dest),(sprintf@s)
	movff	(convStringDayWeek@dest+1),(sprintf@s+1)

		movlw	low(STR_13)
	movwf	((sprintf@fmt))&0ffh
	movlw	high(STR_13)
	movwf	((sprintf@fmt+1))&0ffh

	call	_sprintf	;wreg free
	goto	l483
	line	342
	
l17239:; BSR set to: 2

		movff	(convStringDayWeek@dest),(sprintf@s)
	movff	(convStringDayWeek@dest+1),(sprintf@s+1)

		movlw	low(STR_14)
	movwf	((sprintf@fmt))&0ffh
	movlw	high(STR_14)
	movwf	((sprintf@fmt+1))&0ffh

	call	_sprintf	;wreg free
	line	343
	
l483:; BSR set to: 2

	return	;funcret
	callstack 0
GLOBAL	__end_of_convStringDayWeek
	__end_of_convStringDayWeek:
	signat	_convStringDayWeek,8313
	global	_convOnOff

;; *************** function _convOnOff *****************
;; Defined at:
;;		line 345 in file "Aplicacion.c"
;; Parameters:    Size  Location     Type
;;  dest            2   53[BANK2 ] PTR unsigned char 
;;		 -> readDevide@bufferEnable(5), 
;;  enable          1   55[BANK2 ] unsigned char 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 3F/2
;;		On exit  : 3F/2
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       3       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       3       0       0       0       0       0
;;Total ram usage:        3 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 21
;; This function calls:
;;		_memset
;;		_sprintf
;;		_strlen
;; This function is called by:
;;		_readDevide
;; This function uses a non-reentrant model
;;
psect	text25,class=CODE,space=0,reloc=2,group=0
	line	345
global __ptext25
__ptext25:
psect	text25
	file	"Aplicacion.c"
	line	345
	
_convOnOff:; BSR set to: 2

;incstack = 0
	callstack 6
	line	347
	
l17221:; BSR set to: 2

		movff	(convOnOff@dest),(memset@dest)
	movff	(convOnOff@dest+1),(memset@dest+1)

	movlw	high(0)
	movlb	0	; () banked
	movwf	((memset@c+1))&0ffh
	movlw	low(0)
	movwf	((memset@c))&0ffh
		movff	(convOnOff@dest),(strlen@s)
	movff	(convOnOff@dest+1),(strlen@s+1)

	call	_strlen	;wreg free
	movff	0+?_strlen,(memset@n)
	movff	1+?_strlen,(memset@n+1)
	call	_memset	;wreg free
	line	349
	
l17223:; BSR set to: 0

	movlb	2	; () banked
	movf	((convOnOff@enable))&0ffh,w
	btfsc	status,2
	goto	u21251
	goto	u21250
u21251:
	goto	l17227
u21250:
	
l17225:; BSR set to: 2

		movff	(convOnOff@dest),(sprintf@s)
	movff	(convOnOff@dest+1),(sprintf@s+1)

		movlw	low(STR_15)
	movwf	((sprintf@fmt))&0ffh
	movlw	high(STR_15)
	movwf	((sprintf@fmt+1))&0ffh

	call	_sprintf	;wreg free
	goto	l488
	line	350
	
l17227:; BSR set to: 2

		movff	(convOnOff@dest),(sprintf@s)
	movff	(convOnOff@dest+1),(sprintf@s+1)

		movlw	low(STR_16)
	movwf	((sprintf@fmt))&0ffh
	movlw	high(STR_16)
	movwf	((sprintf@fmt+1))&0ffh

	call	_sprintf	;wreg free
	line	351
	
l488:; BSR set to: 2

	return	;funcret
	callstack 0
GLOBAL	__end_of_convOnOff
	__end_of_convOnOff:
	signat	_convOnOff,8313
	global	_sprintf

;; *************** function _sprintf *****************
;; Defined at:
;;		line 9 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\nf_sprintf.c"
;; Parameters:    Size  Location     Type
;;  s               2   24[BANK2 ] PTR unsigned char 
;;		 -> readDevide@bufferHorario(5), readDevide@bufferEnable(5), ap(76), 
;;  fmt             2   26[BANK2 ] PTR const unsigned char 
;;		 -> STR_16(4), STR_15(3), STR_14(3), STR_13(3), 
;;		 -> STR_12(4), STR_11(38), STR_10(36), STR_9(36), 
;;		 -> STR_8(36), STR_7(36), STR_6(43), STR_5(18), 
;;		 -> STR_4(11), 
;; Auto vars:     Size  Location     Type
;;  f              11   42[BANK2 ] struct _IO_FILE
;;  ap              2   40[BANK2 ] PTR void [1]
;;		 -> ?_printf(2), ?_sprintf(2), 
;;  ret             2    0        int 
;; Return value:  Size  Location     Type
;;                  2   24[BANK2 ] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 3F/2
;;		On exit  : 3F/2
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0      16       0       0       0       0       0
;;      Locals:         0       0       0      13       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0      29       0       0       0       0       0
;;Total ram usage:       29 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 20
;; This function calls:
;;		_vfprintf
;; This function is called by:
;;		_readDevide
;;		_convStringDayWeek
;;		_convOnOff
;; This function uses a non-reentrant model
;;
psect	text26,class=CODE,space=0,reloc=2,group=3
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\nf_sprintf.c"
	line	9
global __ptext26
__ptext26:
psect	text26
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\nf_sprintf.c"
	line	9
	
_sprintf:; BSR set to: 2

;incstack = 0
	callstack 7
	line	15
	
l17085:; BSR set to: 2

		movlw	low(?_sprintf+04h)
	movwf	((sprintf@ap))&0ffh
	movlw	high(?_sprintf+04h)
	movwf	((sprintf@ap+1))&0ffh

	line	16
		movff	(sprintf@s),(sprintf@f)
	movff	(sprintf@s+1),(sprintf@f+1)

	line	17
	
l17087:; BSR set to: 2

	movlw	high(0)
	movwf	(1+(sprintf@f+03h))&0ffh
	movlw	low(0)
	movwf	(0+(sprintf@f+03h))&0ffh
	line	18
	
l17089:; BSR set to: 2

	movlw	high(0)
	movwf	(1+(sprintf@f+09h))&0ffh
	movlw	low(0)
	movwf	(0+(sprintf@f+09h))&0ffh
	line	19
	
l17091:; BSR set to: 2

		movlw	low(sprintf@f)
	movwf	((vfprintf@fp))&0ffh
	movlw	high(sprintf@f)
	movwf	((vfprintf@fp+1))&0ffh

		movff	(sprintf@fmt),(vfprintf@fmt)
	movff	(sprintf@fmt+1),(vfprintf@fmt+1)

		movlw	low(sprintf@ap)
	movwf	((vfprintf@ap))&0ffh
	movlw	high(sprintf@ap)
	movwf	((vfprintf@ap+1))&0ffh

	call	_vfprintf	;wreg free
	line	20
	
l17093:; BSR set to: 1

	movlb	2	; () banked
	movf	(0+(sprintf@f+03h))&0ffh,w
	addwf	((sprintf@s))&0ffh,w
	movwf	c:fsr2l
	movf	(1+(sprintf@f+03h))&0ffh,w
	addwfc	((sprintf@s+1))&0ffh,w
	movwf	1+c:fsr2l
	movlw	low(0)
	movwf	indf2
	line	23
	
l1682:; BSR set to: 2

	return	;funcret
	callstack 0
GLOBAL	__end_of_sprintf
	__end_of_sprintf:
	signat	_sprintf,4698
	global	_vfprintf

;; *************** function _vfprintf *****************
;; Defined at:
;;		line 1390 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
;; Parameters:    Size  Location     Type
;;  fp              2   18[BANK2 ] PTR struct _IO_FILE
;;		 -> sprintf@f(11), NULL(0), 
;;  fmt             2   20[BANK2 ] PTR const unsigned char 
;;		 -> STR_16(4), STR_15(3), STR_14(3), STR_13(3), 
;;		 -> STR_12(4), STR_11(38), STR_10(36), STR_9(36), 
;;		 -> STR_8(36), STR_7(36), STR_6(43), STR_5(18), 
;;		 -> STR_4(11), STR_2(24), STR_1(27), 
;;  ap              2   22[BANK2 ] PTR PTR void 
;;		 -> printf@ap(2), sprintf@ap(2), 
;; Auto vars:     Size  Location     Type
;;  cfmt            2   18[BANK1 ] PTR unsigned char 
;;		 -> STR_16(4), STR_15(3), STR_14(3), STR_13(3), 
;;		 -> STR_12(4), STR_11(38), STR_10(36), STR_9(36), 
;;		 -> STR_8(36), STR_7(36), STR_6(43), STR_5(18), 
;;		 -> STR_4(11), STR_2(24), STR_1(27), 
;; Return value:  Size  Location     Type
;;                  2   18[BANK2 ] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 3F/2
;;		On exit  : 3F/1
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       6       0       0       0       0       0
;;      Locals:         0       0       2       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       2       6       0       0       0       0       0
;;Total ram usage:        8 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 19
;; This function calls:
;;		_vfpfcnvrt
;; This function is called by:
;;		_sprintf
;; This function uses a non-reentrant model
;;
psect	text27,class=CODE,space=0,reloc=2,group=1
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
	line	1390
global __ptext27
__ptext27:
psect	text27
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
	line	1390
	
_vfprintf:; BSR set to: 2

;incstack = 0
	callstack 7
	line	1395
	
l17059:; BSR set to: 2

		movff	(vfprintf@fmt),(vfprintf@cfmt)
	movff	(vfprintf@fmt+1),(vfprintf@cfmt+1)

	line	1396
	
l17061:; BSR set to: 2

	movlw	high(0)
	movlb	1	; () banked
	movwf	((_nout+1))&0ffh
	movlw	low(0)
	movwf	((_nout))&0ffh
	line	1397
	goto	l17065
	line	1398
	
l17063:; BSR set to: 1

		movff	(vfprintf@fp),(vfpfcnvrt@fp)
	movff	(vfprintf@fp+1),(vfpfcnvrt@fp+1)

		movlw	low(vfprintf@cfmt)
	movlb	2	; () banked
	movwf	((vfpfcnvrt@fmt))&0ffh
	movlw	high(vfprintf@cfmt)
	movwf	((vfpfcnvrt@fmt+1))&0ffh

		movff	(vfprintf@ap),(vfpfcnvrt@ap)
	movff	(vfprintf@ap+1),(vfpfcnvrt@ap+1)

	call	_vfpfcnvrt	;wreg free
	movlb	2	; () banked
	movf	(0+?_vfpfcnvrt)&0ffh,w
	movlb	1	; () banked
	addwf	((_nout))&0ffh
	movlb	2	; () banked
	movf	(1+?_vfpfcnvrt)&0ffh,w
	movlb	1	; () banked
	addwfc	((_nout+1))&0ffh

	line	1397
	
l17065:; BSR set to: 1

	movff	(vfprintf@cfmt),tblptrl
	movff	(vfprintf@cfmt+1),tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	iorlw	0
	btfss	status,2
	goto	u21011
	goto	u21010
u21011:
	goto	l17063
u21010:
	
l1785:; BSR set to: 1

	line	1400
	movff	(_nout),(?_vfprintf)
	movff	(_nout+1),(?_vfprintf+1)
	line	1404
	
l1786:; BSR set to: 1

	return	;funcret
	callstack 0
GLOBAL	__end_of_vfprintf
	__end_of_vfprintf:
	signat	_vfprintf,12410
	global	_vfpfcnvrt

;; *************** function _vfpfcnvrt *****************
;; Defined at:
;;		line 692 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
;; Parameters:    Size  Location     Type
;;  fp              2    0[BANK2 ] PTR struct _IO_FILE
;;		 -> sprintf@f(11), NULL(0), 
;;  fmt             2    2[BANK2 ] PTR PTR unsigned char 
;;		 -> vfprintf@cfmt(2), 
;;  ap              2    4[BANK2 ] PTR PTR void 
;;		 -> printf@ap(2), sprintf@ap(2), 
;; Auto vars:     Size  Location     Type
;;  ll              8    6[BANK2 ] long long 
;;  llu             8    0        unsigned long long 
;;  f               4    0        unsigned long long 
;;  vp              3    0        PTR void 
;;  ct              3    0        unsigned char [3]
;;  cp              2   14[BANK2 ] PTR unsigned char 
;;		 -> ?_printf(2), ?_sprintf(2), readDevide@bufferHorario(5), readDevide@bufferEnable(5), 
;;  i               2    0        int 
;;  done            2    0        int 
;;  c               1    0        unsigned char 
;; Return value:  Size  Location     Type
;;                  2    0[BANK2 ] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 3F/2
;;		On exit  : 3D/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       6       0       0       0       0       0
;;      Locals:         0       0       0      12       0       0       0       0       0
;;      Temps:          0       2       0       0       0       0       0       0       0
;;      Totals:         0       2       0      18       0       0       0       0       0
;;Total ram usage:       20 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 18
;; This function calls:
;;		_dtoa
;;		_fputc
;;		_stoa
;;		_strncmp
;; This function is called by:
;;		_vfprintf
;; This function uses a non-reentrant model
;;
psect	text28,class=CODE,space=0,reloc=2,group=1
	line	692
global __ptext28
__ptext28:
psect	text28
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
	line	692
	
_vfpfcnvrt:; BSR set to: 1

;incstack = 0
	callstack 7
	line	702
	
l16985:; BSR set to: 2

	movff	(vfpfcnvrt@fmt),fsr2l
	movff	(vfpfcnvrt@fmt+1),fsr2h
	movff	postinc2,tblptrl
	movff	postdec2,tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	xorlw	025h
	btfss	status,2
	goto	u20901
	goto	u20900
u20901:
	goto	l17037
u20900:
	line	703
	
l16987:; BSR set to: 2

	movff	(vfpfcnvrt@fmt),fsr2l
	movff	(vfpfcnvrt@fmt+1),fsr2h
	incf	postinc2
	movlw	0
	addwfc	postdec2
	line	705
	
l16989:; BSR set to: 2

	movlw	high(0)
	movlb	0	; () banked
	movwf	((_width+1))&0ffh
	movlw	low(0)
	movwf	((_width))&0ffh
	movff	(_width),(_flags)
	movff	(_width+1),(_flags+1)
	line	706
	
l16991:; BSR set to: 0

	setf	((_prec))&0ffh
	setf	((_prec+1))&0ffh
	line	847
	
l16993:; BSR set to: 0

	movff	(vfpfcnvrt@fmt),fsr2l
	movff	(vfpfcnvrt@fmt+1),fsr2h
	movff	postinc2,tblptrl
	movff	postdec2,tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	xorlw	064h
	btfsc	status,2
	goto	u20911
	goto	u20910
u20911:
	goto	l16997
u20910:
	
l16995:; BSR set to: 0

	movff	(vfpfcnvrt@fmt),fsr2l
	movff	(vfpfcnvrt@fmt+1),fsr2h
	movff	postinc2,tblptrl
	movff	postdec2,tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	xorlw	069h
	btfss	status,2
	goto	u20921
	goto	u20920
u20921:
	goto	l17003
u20920:
	line	849
	
l16997:; BSR set to: 0

	movff	(vfpfcnvrt@fmt),fsr2l
	movff	(vfpfcnvrt@fmt+1),fsr2h
	incf	postinc2
	movlw	0
	addwfc	postdec2
	line	850
	movff	(vfpfcnvrt@ap),fsr2l
	movff	(vfpfcnvrt@ap+1),fsr2h
	movff	indf2,??_vfpfcnvrt+0+0
	movlw	low(02h)
	addwf	postinc2
	movff	indf2,??_vfpfcnvrt+0+0+1
	movlw	high(02h)
	addwfc	postdec2
	movff	??_vfpfcnvrt+0+0,fsr2l
	movff	??_vfpfcnvrt+0+1,fsr2h
	movff	postinc2,(vfpfcnvrt@ll)
	movff	postdec2,(vfpfcnvrt@ll+1)
	movlb	2	; () banked
	movlw	0
	btfsc	((vfpfcnvrt@ll+1))&0ffh,7
	movlw	-1
	movwf	((vfpfcnvrt@ll+2))&0ffh
	movwf	((vfpfcnvrt@ll+3))&0ffh
	movwf	((vfpfcnvrt@ll+4))&0ffh
	movwf	((vfpfcnvrt@ll+5))&0ffh
	movwf	((vfpfcnvrt@ll+6))&0ffh
	movwf	((vfpfcnvrt@ll+7))&0ffh
	line	852
	
l16999:; BSR set to: 2

		movff	(vfpfcnvrt@fp),(dtoa@fp)
	movff	(vfpfcnvrt@fp+1),(dtoa@fp+1)

	movff	(vfpfcnvrt@ll),(dtoa@d)
	movff	(vfpfcnvrt@ll+1),(dtoa@d+1)
	movff	(vfpfcnvrt@ll+2),(dtoa@d+2)
	movff	(vfpfcnvrt@ll+3),(dtoa@d+3)
	movff	(vfpfcnvrt@ll+4),(dtoa@d+4)
	movff	(vfpfcnvrt@ll+5),(dtoa@d+5)
	movff	(vfpfcnvrt@ll+6),(dtoa@d+6)
	movff	(vfpfcnvrt@ll+7),(dtoa@d+7)
	call	_dtoa	;wreg free
	movff	0+?_dtoa,(?_vfpfcnvrt)
	movff	1+?_dtoa,(?_vfpfcnvrt+1)
	goto	l1772
	line	1171
	
l17003:; BSR set to: 0

	movff	(vfpfcnvrt@fmt),fsr2l
	movff	(vfpfcnvrt@fmt+1),fsr2h
	movff	postinc2,tblptrl
	movff	postdec2,tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	xorlw	073h
	btfsc	status,2
	goto	u20931
	goto	u20930
u20931:
	goto	l17007
u20930:
	
l17005:; BSR set to: 0

	movff	(vfpfcnvrt@fmt),fsr2l
	movff	(vfpfcnvrt@fmt+1),fsr2h
	movff	postinc2,(strncmp@_l)
	movff	postdec2,(strncmp@_l+1)
		movlw	low(STR_43)
	movwf	((strncmp@_r))&0ffh
	movlw	high(STR_43)
	movwf	((strncmp@_r+1))&0ffh

	movlw	high(03h)
	movwf	((strncmp@n+1))&0ffh
	movlw	low(03h)
	movwf	((strncmp@n))&0ffh
	call	_strncmp	;wreg free
	movf	(0+?_strncmp)&0ffh,w
iorwf	(1+?_strncmp)&0ffh,w
	btfss	status,2
	goto	u20941
	goto	u20940

u20941:
	goto	l17021
u20940:
	line	1173
	
l17007:; BSR set to: 0

	movff	(vfpfcnvrt@fmt),fsr2l
	movff	(vfpfcnvrt@fmt+1),fsr2h
	movff	postinc2,tblptrl
	movff	postdec2,tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	xorlw	073h
	btfsc	status,2
	goto	u20951
	goto	u20950
u20951:
	goto	l17011
u20950:
	
l17009:; BSR set to: 0

	movlw	high(03h)
	movlb	2	; () banked
	movwf	((_vfpfcnvrt$2810+1))&0ffh
	movlw	low(03h)
	movwf	((_vfpfcnvrt$2810))&0ffh
	goto	l17013
	
l17011:; BSR set to: 0

	movlw	high(01h)
	movlb	2	; () banked
	movwf	((_vfpfcnvrt$2810+1))&0ffh
	movlw	low(01h)
	movwf	((_vfpfcnvrt$2810))&0ffh
	
l17013:; BSR set to: 2

	movff	(vfpfcnvrt@fmt),fsr2l
	movff	(vfpfcnvrt@fmt+1),fsr2h
	movf	((_vfpfcnvrt$2810))&0ffh,w
	addwf	postinc2
	movf	((_vfpfcnvrt$2810+1))&0ffh,w
	addwfc	postdec2
	line	1174
	
l17015:; BSR set to: 2

	movff	(vfpfcnvrt@ap),fsr2l
	movff	(vfpfcnvrt@ap+1),fsr2h
	movff	indf2,??_vfpfcnvrt+0+0
	movlw	low(02h)
	addwf	postinc2
	movff	indf2,??_vfpfcnvrt+0+0+1
	movlw	high(02h)
	addwfc	postdec2
	movff	??_vfpfcnvrt+0+0,fsr2l
	movff	??_vfpfcnvrt+0+1,fsr2h
	movff	postinc2,(vfpfcnvrt@cp)
	movff	postdec2,(vfpfcnvrt@cp+1)
	line	1176
	
l17017:; BSR set to: 2

		movff	(vfpfcnvrt@fp),(stoa@fp)
	movff	(vfpfcnvrt@fp+1),(stoa@fp+1)

		movff	(vfpfcnvrt@cp),(stoa@s)
	movff	(vfpfcnvrt@cp+1),(stoa@s+1)

	call	_stoa	;wreg free
	movff	0+?_stoa,(?_vfpfcnvrt)
	movff	1+?_stoa,(?_vfpfcnvrt+1)
	goto	l1772
	line	1372
	
l17021:; BSR set to: 0

	movff	(vfpfcnvrt@fmt),fsr2l
	movff	(vfpfcnvrt@fmt+1),fsr2h
	movff	postinc2,tblptrl
	movff	postdec2,tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	xorlw	025h
	btfss	status,2
	goto	u20961
	goto	u20960
u20961:
	goto	l17031
u20960:
	line	1373
	
l17023:; BSR set to: 0

	movff	(vfpfcnvrt@fmt),fsr2l
	movff	(vfpfcnvrt@fmt+1),fsr2h
	incf	postinc2
	movlw	0
	addwfc	postdec2
	line	1374
	
l17025:; BSR set to: 0

	movlw	high(025h)
	movwf	((fputc@c+1))&0ffh
	movlw	low(025h)
	movwf	((fputc@c))&0ffh
		movff	(vfpfcnvrt@fp),(fputc@fp)
	movff	(vfpfcnvrt@fp+1),(fputc@fp+1)

	call	_fputc	;wreg free
	line	1375
	
l17027:
	movlw	high(01h)
	movlb	2	; () banked
	movwf	((?_vfpfcnvrt+1))&0ffh
	movlw	low(01h)
	movwf	((?_vfpfcnvrt))&0ffh
	goto	l1772
	line	1379
	
l17031:; BSR set to: 0

	movff	(vfpfcnvrt@fmt),fsr2l
	movff	(vfpfcnvrt@fmt+1),fsr2h
	incf	postinc2
	movlw	0
	addwfc	postdec2
	line	1380
	
l17033:; BSR set to: 0

	movlw	high(0)
	movlb	2	; () banked
	movwf	((?_vfpfcnvrt+1))&0ffh
	movlw	low(0)
	movwf	((?_vfpfcnvrt))&0ffh
	goto	l1772
	line	1384
	
l17037:; BSR set to: 2

	movff	(vfpfcnvrt@fmt),fsr2l
	movff	(vfpfcnvrt@fmt+1),fsr2h
	movff	postinc2,tblptrl
	movff	postdec2,tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w

	movlb	0	; () banked
	movwf	((fputc@c))&0ffh
	clrf	((fputc@c+1))&0ffh
		movff	(vfpfcnvrt@fp),(fputc@fp)
	movff	(vfpfcnvrt@fp+1),(fputc@fp+1)

	call	_fputc	;wreg free
	line	1385
	
l17039:
	movff	(vfpfcnvrt@fmt),fsr2l
	movff	(vfpfcnvrt@fmt+1),fsr2h
	incf	postinc2
	movlw	0
	addwfc	postdec2
	goto	l17027
	line	1387
	
l1772:
	return	;funcret
	callstack 0
GLOBAL	__end_of_vfpfcnvrt
	__end_of_vfpfcnvrt:
	signat	_vfpfcnvrt,12410
	global	_stoa

;; *************** function _stoa *****************
;; Defined at:
;;		line 568 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
;; Parameters:    Size  Location     Type
;;  fp              2   48[BANK0 ] PTR struct _IO_FILE
;;		 -> sprintf@f(11), NULL(0), 
;;  s               2   50[BANK0 ] PTR unsigned char 
;;		 -> ?_printf(2), ?_sprintf(2), readDevide@bufferHorario(5), readDevide@bufferEnable(5), 
;; Auto vars:     Size  Location     Type
;;  nuls            7   53[BANK0 ] unsigned char [7]
;;  l               2   68[BANK0 ] int 
;;  p               2   66[BANK0 ] int 
;;  cp              2   64[BANK0 ] PTR unsigned char 
;;		 -> ?_printf(2), stoa@nuls(7), ?_sprintf(2), readDevide@bufferHorario(5), 
;;		 -> readDevide@bufferEnable(5), 
;;  w               2   62[BANK0 ] int 
;;  i               2   60[BANK0 ] int 
;; Return value:  Size  Location     Type
;;                  2   48[BANK0 ] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 3F/2
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       4       0       0       0       0       0       0       0
;;      Locals:         0      17       0       0       0       0       0       0       0
;;      Temps:          0       1       0       0       0       0       0       0       0
;;      Totals:         0      22       0       0       0       0       0       0       0
;;Total ram usage:       22 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 15
;; This function calls:
;;		_fputc
;;		_strlen
;; This function is called by:
;;		_vfpfcnvrt
;; This function uses a non-reentrant model
;;
psect	text29,class=CODE,space=0,reloc=2,group=1
	line	568
global __ptext29
__ptext29:
psect	text29
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
	line	568
	
_stoa:
;incstack = 0
	callstack 9
	line	570
	
l16921:; BSR set to: 2

	lfsr	2,(stoa@F1150)
	lfsr	1,(stoa@nuls)
	movlw	7-1
u20741:
	movff	plusw2,plusw1
	decf	wreg
	bc	u20741

	line	574
	
l16923:; BSR set to: 2

		movff	(stoa@s),(stoa@cp)
	movff	(stoa@s+1),(stoa@cp+1)

	line	575
	
l16925:; BSR set to: 2

	movlb	0	; () banked
	movf	((stoa@cp))&0ffh,w
iorwf	((stoa@cp+1))&0ffh,w
	btfss	status,2
	goto	u20751
	goto	u20750

u20751:
	goto	l16929
u20750:
	line	576
	
l16927:; BSR set to: 0

		movlw	low(stoa@nuls)
	movwf	((stoa@cp))&0ffh
	clrf	((stoa@cp+1))&0ffh

	line	580
	
l16929:; BSR set to: 0

		movff	(stoa@cp),(strlen@s)
	movff	(stoa@cp+1),(strlen@s+1)

	call	_strlen	;wreg free
	movff	0+?_strlen,(stoa@l)
	movff	1+?_strlen,(stoa@l+1)
	line	581
	
l16931:; BSR set to: 0

	movff	(_prec),(stoa@p)
	movff	(_prec+1),(stoa@p+1)
	line	582
	
l16933:; BSR set to: 0

	btfsc	((stoa@p+1))&0ffh,7
	goto	u20761
	goto	u20760

u20761:
	goto	l1751
u20760:
	
l16935:; BSR set to: 0

		movf	((stoa@l))&0ffh,w
	subwf	((stoa@p))&0ffh,w
	movf	((stoa@p+1))&0ffh,w
	xorlw	80h
	movwf	(??_stoa+0+0)&0ffh
	movf	((stoa@l+1))&0ffh,w
	xorlw	80h
	subwfb	(??_stoa+0+0)&0ffh,w
	btfss	status,0
	goto	u20771
	goto	u20770

u20771:
	goto	l1749
u20770:
	goto	l1751
	
l1749:; BSR set to: 0

	movff	(stoa@p),(stoa@l)
	movff	(stoa@p+1),(stoa@l+1)
	
l1751:; BSR set to: 0

	line	583
	movff	(stoa@l),(stoa@p)
	movff	(stoa@l+1),(stoa@p+1)
	line	584
	movff	(_width),(stoa@w)
	movff	(_width+1),(stoa@w+1)
	line	587
	
	btfsc	((_flags))&0ffh,(0)&7
	goto	u20781
	goto	u20780
u20781:
	goto	l16945
u20780:
	goto	l16943
	line	589
	
l16939:; BSR set to: 0

	movlw	high(020h)
	movwf	((fputc@c+1))&0ffh
	movlw	low(020h)
	movwf	((fputc@c))&0ffh
		movff	(stoa@fp),(fputc@fp)
	movff	(stoa@fp+1),(fputc@fp+1)

	call	_fputc	;wreg free
	line	590
	
l16941:
	movlb	0	; () banked
	infsnz	((stoa@l))&0ffh
	incf	((stoa@l+1))&0ffh
	line	588
	
l16943:; BSR set to: 0

		movf	((stoa@w))&0ffh,w
	subwf	((stoa@l))&0ffh,w
	movf	((stoa@l+1))&0ffh,w
	xorlw	80h
	movwf	(??_stoa+0+0)&0ffh
	movf	((stoa@w+1))&0ffh,w
	xorlw	80h
	subwfb	(??_stoa+0+0)&0ffh,w
	btfss	status,0
	goto	u20791
	goto	u20790

u20791:
	goto	l16939
u20790:
	line	595
	
l16945:; BSR set to: 0

	movlw	high(0)
	movwf	((stoa@i+1))&0ffh
	movlw	low(0)
	movwf	((stoa@i))&0ffh
	line	596
	goto	l16953
	line	597
	
l16947:; BSR set to: 0

	movff	(stoa@cp),fsr2l
	movff	(stoa@cp+1),fsr2h
	movf	indf2,w
	movwf	(??_stoa+0+0)&0ffh
	movf	((??_stoa+0+0))&0ffh,w
	movwf	((fputc@c))&0ffh
	clrf	((fputc@c+1))&0ffh
		movff	(stoa@fp),(fputc@fp)
	movff	(stoa@fp+1),(fputc@fp+1)

	call	_fputc	;wreg free
	line	598
	
l16949:
	movlb	0	; () banked
	infsnz	((stoa@cp))&0ffh
	incf	((stoa@cp+1))&0ffh
	line	599
	
l16951:; BSR set to: 0

	infsnz	((stoa@i))&0ffh
	incf	((stoa@i+1))&0ffh
	line	596
	
l16953:; BSR set to: 0

		movf	((stoa@p))&0ffh,w
	subwf	((stoa@i))&0ffh,w
	movf	((stoa@i+1))&0ffh,w
	xorlw	80h
	movwf	(??_stoa+0+0)&0ffh
	movf	((stoa@p+1))&0ffh,w
	xorlw	80h
	subwfb	(??_stoa+0+0)&0ffh,w
	btfss	status,0
	goto	u20801
	goto	u20800

u20801:
	goto	l16947
u20800:
	
l1760:; BSR set to: 0

	line	603
	
	btfss	((_flags))&0ffh,(0)&7
	goto	u20811
	goto	u20810
u20811:
	goto	l1761
u20810:
	goto	l16961
	line	605
	
l16957:; BSR set to: 0

	movlw	high(020h)
	movwf	((fputc@c+1))&0ffh
	movlw	low(020h)
	movwf	((fputc@c))&0ffh
		movff	(stoa@fp),(fputc@fp)
	movff	(stoa@fp+1),(fputc@fp+1)

	call	_fputc	;wreg free
	line	606
	
l16959:
	movlb	0	; () banked
	infsnz	((stoa@l))&0ffh
	incf	((stoa@l+1))&0ffh
	line	604
	
l16961:; BSR set to: 0

		movf	((stoa@w))&0ffh,w
	subwf	((stoa@l))&0ffh,w
	movf	((stoa@l+1))&0ffh,w
	xorlw	80h
	movwf	(??_stoa+0+0)&0ffh
	movf	((stoa@w+1))&0ffh,w
	xorlw	80h
	subwfb	(??_stoa+0+0)&0ffh,w
	btfss	status,0
	goto	u20821
	goto	u20820

u20821:
	goto	l16957
u20820:
	line	608
	
l1761:; BSR set to: 0

	line	610
	movff	(stoa@l),(?_stoa)
	movff	(stoa@l+1),(?_stoa+1)
	line	611
	
l1765:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_stoa
	__end_of_stoa:
	signat	_stoa,8314
	global	_dtoa

;; *************** function _dtoa *****************
;; Defined at:
;;		line 287 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
;; Parameters:    Size  Location     Type
;;  fp              2   66[BANK0 ] PTR struct _IO_FILE
;;		 -> sprintf@f(11), NULL(0), 
;;  d               8   68[BANK0 ] long long 
;; Auto vars:     Size  Location     Type
;;  n               8    8[BANK1 ] long long 
;;  i               2   16[BANK1 ] int 
;;  s               2    6[BANK1 ] int 
;;  w               2    4[BANK1 ] int 
;;  p               2    2[BANK1 ] int 
;; Return value:  Size  Location     Type
;;                  2   66[BANK0 ] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 3F/2
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0      10       0       0       0       0       0       0       0
;;      Locals:         0       0      18       0       0       0       0       0       0
;;      Temps:          0       8       0       0       0       0       0       0       0
;;      Totals:         0      18      18       0       0       0       0       0       0
;;Total ram usage:       36 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 17
;; This function calls:
;;		___aodiv
;;		___aomod
;;		_abs
;;		_pad
;; This function is called by:
;;		_vfpfcnvrt
;; This function uses a non-reentrant model
;;
psect	text30,class=CODE,space=0,reloc=2,group=1
	line	287
global __ptext30
__ptext30:
psect	text30
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
	line	287
	
_dtoa:; BSR set to: 0

;incstack = 0
	callstack 7
	line	293
	
l16859:; BSR set to: 2

	movff	(dtoa@d),(dtoa@n)
	movff	(dtoa@d+1),(dtoa@n+1)
	movff	(dtoa@d+2),(dtoa@n+2)
	movff	(dtoa@d+3),(dtoa@n+3)
	movff	(dtoa@d+4),(dtoa@n+4)
	movff	(dtoa@d+5),(dtoa@n+5)
	movff	(dtoa@d+6),(dtoa@n+6)
	movff	(dtoa@d+7),(dtoa@n+7)
	line	294
	
l16861:; BSR set to: 2

	movlb	1	; () banked
	btfsc	((dtoa@n+7))&0ffh,7
	goto	u20591
	goto	u20590

u20591:
	movlw	1
	goto	u20600
u20590:
	movlw	0
u20600:
	movwf	((dtoa@s))&0ffh
	clrf	((dtoa@s+1))&0ffh
	line	295
	movf	((dtoa@s))&0ffh,w
iorwf	((dtoa@s+1))&0ffh,w
	btfsc	status,2
	goto	u20611
	goto	u20610

u20611:
	goto	l16865
u20610:
	line	296
	
l16863:; BSR set to: 1

	comf	((dtoa@n+7))&0ffh
	comf	((dtoa@n+6))&0ffh
	comf	((dtoa@n+5))&0ffh
	comf	((dtoa@n+4))&0ffh
	comf	((dtoa@n+3))&0ffh
	comf	((dtoa@n+2))&0ffh
	comf	((dtoa@n+1))&0ffh
	negf	((dtoa@n))&0ffh
	movlw	0
	addwfc	((dtoa@n+1))&0ffh
	addwfc	((dtoa@n+2))&0ffh
	addwfc	((dtoa@n+3))&0ffh
	addwfc	((dtoa@n+4))&0ffh
	addwfc	((dtoa@n+5))&0ffh
	addwfc	((dtoa@n+6))&0ffh
	addwfc	((dtoa@n+7))&0ffh
	line	300
	
l16865:; BSR set to: 1

	movlb	0	; () banked
	btfsc	((_prec+1))&0ffh,7
	goto	u20621
	goto	u20620

u20621:
	goto	l16869
u20620:
	line	301
	
l16867:; BSR set to: 0

	bcf	(0+(1/8)+(_flags))&0ffh,(1)&7
	line	303
	
l16869:; BSR set to: 0

	btfsc	((_prec+1))&0ffh,7
	goto	u20630
	movf	((_prec+1))&0ffh,w
	bnz	u20631
	decf	((_prec))&0ffh,w
	btfsc	status,0
	goto	u20631
	goto	u20630

u20631:
	goto	l1722
u20630:
	
l16871:; BSR set to: 0

	movlw	high(01h)
	movlb	1	; () banked
	movwf	((dtoa@p+1))&0ffh
	movlw	low(01h)
	movwf	((dtoa@p))&0ffh
	goto	l1724
	
l1722:; BSR set to: 0

	movff	(_prec),(dtoa@p)
	movff	(_prec+1),(dtoa@p+1)
	
l1724:
	line	304
	movff	(_width),(dtoa@w)
	movff	(_width+1),(dtoa@w+1)
	line	305
	
l16873:
	movlb	1	; () banked
	movf	((dtoa@s))&0ffh,w
iorwf	((dtoa@s+1))&0ffh,w
	btfss	status,2
	goto	u20641
	goto	u20640

u20641:
	goto	l16877
u20640:
	
l16875:; BSR set to: 1

	movlb	0	; () banked
	
	btfss	((_flags))&0ffh,(2)&7
	goto	u20651
	goto	u20650
u20651:
	goto	l16879
u20650:
	line	306
	
l16877:
	movlb	1	; () banked
	decf	((dtoa@w))&0ffh
	btfss	status,0
	decf	((dtoa@w+1))&0ffh
	line	310
	
l16879:
	movlw	high(01Fh)
	movlb	1	; () banked
	movwf	((dtoa@i+1))&0ffh
	movlw	low(01Fh)
	movwf	((dtoa@i))&0ffh
	line	311
	
l16881:; BSR set to: 1

	movlw	low(0)
	movlb	2	; () banked
	movwf	(0+(_dbuf+01Fh))&0ffh
	line	312
	goto	l16893
	line	313
	
l16883:
	movlb	1	; () banked
	decf	((dtoa@i))&0ffh
	btfss	status,0
	decf	((dtoa@i+1))&0ffh
	line	314
	
l16885:; BSR set to: 1

	movlw	low(_dbuf)
	addwf	((dtoa@i))&0ffh,w
	movwf	c:fsr2l
	movlw	high(_dbuf)
	addwfc	((dtoa@i+1))&0ffh,w
	movwf	1+c:fsr2l
	movff	(dtoa@n),(___aomod@dividend)
	movff	(dtoa@n+1),(___aomod@dividend+1)
	movff	(dtoa@n+2),(___aomod@dividend+2)
	movff	(dtoa@n+3),(___aomod@dividend+3)
	movff	(dtoa@n+4),(___aomod@dividend+4)
	movff	(dtoa@n+5),(___aomod@dividend+5)
	movff	(dtoa@n+6),(___aomod@dividend+6)
	movff	(dtoa@n+7),(___aomod@dividend+7)
	movlw	byte0(0Ah)
	movlb	0	; () banked
	movwf	((___aomod@divisor))&0ffh
	movlw	byte1(0Ah)
	movwf	((___aomod@divisor+1))&0ffh
	movlw	byte2(0Ah)
	movwf	((___aomod@divisor+2))&0ffh
	movlw	byte3(0Ah)
	movwf	((___aomod@divisor+3))&0ffh
	movlw	byte4(0Ah)
	movwf	((___aomod@divisor+4))&0ffh
	movlw	byte5(0Ah)
	movwf	((___aomod@divisor+5))&0ffh
	movlw	byte6(0Ah)
	movwf	((___aomod@divisor+6))&0ffh
	movlw	byte7(0Ah)
	movwf	((___aomod@divisor+7))&0ffh
	call	___aomod	;wreg free
	movff	0+?___aomod,??_dtoa+0+0
	movff	1+?___aomod,??_dtoa+0+0+1
	movff	2+?___aomod,??_dtoa+0+0+2
	movff	3+?___aomod,??_dtoa+0+0+3
	movff	4+?___aomod,??_dtoa+0+0+4
	movff	5+?___aomod,??_dtoa+0+0+5
	movff	6+?___aomod,??_dtoa+0+0+6
	movff	7+?___aomod,??_dtoa+0+0+7
	
	movff	??_dtoa+0+0,(abs@a)
	movff	??_dtoa+0+2,(abs@a+1)
	call	_abs	;wreg free
	movf	(0+?_abs)&0ffh,w
	addlw	low(030h)
	movwf	indf2,c

	line	315
	
l16887:; BSR set to: 0

	movlb	1	; () banked
	decf	((dtoa@p))&0ffh
	btfss	status,0
	decf	((dtoa@p+1))&0ffh
	line	316
	
l16889:; BSR set to: 1

	decf	((dtoa@w))&0ffh
	btfss	status,0
	decf	((dtoa@w+1))&0ffh
	line	317
	
l16891:; BSR set to: 1

	movff	(dtoa@n),(___aodiv@dividend)
	movff	(dtoa@n+1),(___aodiv@dividend+1)
	movff	(dtoa@n+2),(___aodiv@dividend+2)
	movff	(dtoa@n+3),(___aodiv@dividend+3)
	movff	(dtoa@n+4),(___aodiv@dividend+4)
	movff	(dtoa@n+5),(___aodiv@dividend+5)
	movff	(dtoa@n+6),(___aodiv@dividend+6)
	movff	(dtoa@n+7),(___aodiv@dividend+7)
	movlw	byte0(0Ah)
	movlb	0	; () banked
	movwf	((___aodiv@divisor))&0ffh
	movlw	byte1(0Ah)
	movwf	((___aodiv@divisor+1))&0ffh
	movlw	byte2(0Ah)
	movwf	((___aodiv@divisor+2))&0ffh
	movlw	byte3(0Ah)
	movwf	((___aodiv@divisor+3))&0ffh
	movlw	byte4(0Ah)
	movwf	((___aodiv@divisor+4))&0ffh
	movlw	byte5(0Ah)
	movwf	((___aodiv@divisor+5))&0ffh
	movlw	byte6(0Ah)
	movwf	((___aodiv@divisor+6))&0ffh
	movlw	byte7(0Ah)
	movwf	((___aodiv@divisor+7))&0ffh
	call	___aodiv	;wreg free
	movff	0+?___aodiv,(dtoa@n)
	movff	1+?___aodiv,(dtoa@n+1)
	movff	2+?___aodiv,(dtoa@n+2)
	movff	3+?___aodiv,(dtoa@n+3)
	movff	4+?___aodiv,(dtoa@n+4)
	movff	5+?___aodiv,(dtoa@n+5)
	movff	6+?___aodiv,(dtoa@n+6)
	movff	7+?___aodiv,(dtoa@n+7)
	
	line	312
	
l16893:
	movlb	1	; () banked
	btfsc	((dtoa@i+1))&0ffh,7
	goto	u20661
	movf	((dtoa@i+1))&0ffh,w
	bnz	u20660
	decf	((dtoa@i))&0ffh,w
	btfss	status,0
	goto	u20661
	goto	u20660

u20661:
	goto	l16903
u20660:
	
l16895:; BSR set to: 1

	movf	((dtoa@n))&0ffh,w
iorwf	((dtoa@n+1))&0ffh,w
iorwf	((dtoa@n+2))&0ffh,w
iorwf	((dtoa@n+3))&0ffh,w
iorwf	((dtoa@n+4))&0ffh,w
iorwf	((dtoa@n+5))&0ffh,w
iorwf	((dtoa@n+6))&0ffh,w
iorwf	((dtoa@n+7))&0ffh,w
	btfss	status,2
	goto	u20671
	goto	u20670

u20671:
	goto	l16883
u20670:
	
l16897:; BSR set to: 1

	btfsc	((dtoa@p+1))&0ffh,7
	goto	u20680
	movf	((dtoa@p+1))&0ffh,w
	bnz	u20681
	decf	((dtoa@p))&0ffh,w
	btfsc	status,0
	goto	u20681
	goto	u20680

u20681:
	goto	l16883
u20680:
	
l16899:; BSR set to: 1

	btfsc	((dtoa@w+1))&0ffh,7
	goto	u20691
	movf	((dtoa@w+1))&0ffh,w
	bnz	u20690
	decf	((dtoa@w))&0ffh,w
	btfss	status,0
	goto	u20691
	goto	u20690

u20691:
	goto	l16903
u20690:
	
l16901:; BSR set to: 1

	movlb	0	; () banked
	
	btfsc	((_flags))&0ffh,(1)&7
	goto	u20701
	goto	u20700
u20701:
	goto	l16883
u20700:
	line	321
	
l16903:
	movlb	1	; () banked
	movf	((dtoa@s))&0ffh,w
iorwf	((dtoa@s+1))&0ffh,w
	btfss	status,2
	goto	u20711
	goto	u20710

u20711:
	goto	l16907
u20710:
	
l16905:; BSR set to: 1

	movlb	0	; () banked
	
	btfss	((_flags))&0ffh,(2)&7
	goto	u20721
	goto	u20720
u20721:
	goto	l16917
u20720:
	line	322
	
l16907:
	movlb	1	; () banked
	decf	((dtoa@i))&0ffh
	btfss	status,0
	decf	((dtoa@i+1))&0ffh
	line	323
	
l16909:; BSR set to: 1

	movf	((dtoa@s))&0ffh,w
iorwf	((dtoa@s+1))&0ffh,w
	btfss	status,2
	goto	u20731
	goto	u20730

u20731:
	goto	l16913
u20730:
	
l16911:; BSR set to: 1

	movlw	high(02Bh)
	movwf	((_dtoa$2781+1))&0ffh
	movlw	low(02Bh)
	movwf	((_dtoa$2781))&0ffh
	goto	l16915
	
l16913:; BSR set to: 1

	movlw	high(02Dh)
	movwf	((_dtoa$2781+1))&0ffh
	movlw	low(02Dh)
	movwf	((_dtoa$2781))&0ffh
	
l16915:; BSR set to: 1

	movlw	low(_dbuf)
	addwf	((dtoa@i))&0ffh,w
	movwf	c:fsr2l
	movlw	high(_dbuf)
	addwfc	((dtoa@i+1))&0ffh,w
	movwf	1+c:fsr2l
	movff	(_dtoa$2781),indf2

	line	327
	
l16917:
		movff	(dtoa@fp),(pad@fp)
	movff	(dtoa@fp+1),(pad@fp+1)

	movlw	low(_dbuf)
	movlb	1	; () banked
	addwf	((dtoa@i))&0ffh,w
	movlb	0	; () banked
	movwf	((pad@buf))&0ffh
	movlw	high(_dbuf)
	movlb	1	; () banked
	addwfc	((dtoa@i+1))&0ffh,w
	movlb	0	; () banked
	movwf	1+((pad@buf))&0ffh
	movff	(dtoa@w),(pad@p)
	movff	(dtoa@w+1),(pad@p+1)
	call	_pad	;wreg free
	movff	0+?_pad,(?_dtoa)
	movff	1+?_pad,(?_dtoa+1)
	line	328
	
l1742:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_dtoa
	__end_of_dtoa:
	signat	_dtoa,8314
	global	_pad

;; *************** function _pad *****************
;; Defined at:
;;		line 72 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
;; Parameters:    Size  Location     Type
;;  fp              2   55[BANK0 ] PTR struct _IO_FILE
;;		 -> sprintf@f(11), NULL(0), 
;;  buf             2   57[BANK0 ] PTR unsigned char 
;;		 -> dbuf(32), 
;;  p               2   59[BANK0 ] int 
;; Auto vars:     Size  Location     Type
;;  w               2   64[BANK0 ] int 
;;  i               2   62[BANK0 ] int 
;; Return value:  Size  Location     Type
;;                  2   55[BANK0 ] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       6       0       0       0       0       0       0       0
;;      Locals:         0       4       0       0       0       0       0       0       0
;;      Temps:          0       1       0       0       0       0       0       0       0
;;      Totals:         0      11       0       0       0       0       0       0       0
;;Total ram usage:       11 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 16
;; This function calls:
;;		_fputc
;;		_fputs
;;		_strlen
;; This function is called by:
;;		_dtoa
;; This function uses a non-reentrant model
;;
psect	text31,class=CODE,space=0,reloc=2,group=1
	line	72
global __ptext31
__ptext31:
psect	text31
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
	line	72
	
_pad:; BSR set to: 0

;incstack = 0
	callstack 7
	line	77
	
l16831:; BSR set to: 0

	
	btfss	((_flags))&0ffh,(0)&7
	goto	u20531
	goto	u20530
u20531:
	goto	l16835
u20530:
	line	78
	
l16833:; BSR set to: 0

		movff	(pad@buf),(fputs@s)
	movff	(pad@buf+1),(fputs@s+1)

		movff	(pad@fp),(fputs@fp)
	movff	(pad@fp+1),(fputs@fp+1)

	call	_fputs	;wreg free
	line	82
	
l16835:; BSR set to: 0

	btfsc	((pad@p+1))&0ffh,7
	goto	u20541
	goto	u20540

u20541:
	goto	l16839
u20540:
	
l16837:; BSR set to: 0

	movff	(pad@p),(pad@w)
	movff	(pad@p+1),(pad@w+1)
	goto	l1711
	
l16839:; BSR set to: 0

	movlw	high(0)
	movwf	((pad@w+1))&0ffh
	movlw	low(0)
	movwf	((pad@w))&0ffh
	
l1711:; BSR set to: 0

	line	83
	movlw	high(0)
	movwf	((pad@i+1))&0ffh
	movlw	low(0)
	movwf	((pad@i))&0ffh
	line	84
	goto	l16845
	line	85
	
l16841:; BSR set to: 0

	movlw	high(020h)
	movwf	((fputc@c+1))&0ffh
	movlw	low(020h)
	movwf	((fputc@c))&0ffh
		movff	(pad@fp),(fputc@fp)
	movff	(pad@fp+1),(fputc@fp+1)

	call	_fputc	;wreg free
	line	86
	
l16843:
	movlb	0	; () banked
	infsnz	((pad@i))&0ffh
	incf	((pad@i+1))&0ffh
	line	84
	
l16845:; BSR set to: 0

		movf	((pad@w))&0ffh,w
	subwf	((pad@i))&0ffh,w
	movf	((pad@i+1))&0ffh,w
	xorlw	80h
	movwf	(??_pad+0+0)&0ffh
	movf	((pad@w+1))&0ffh,w
	xorlw	80h
	subwfb	(??_pad+0+0)&0ffh,w
	btfss	status,0
	goto	u20551
	goto	u20550

u20551:
	goto	l16841
u20550:
	
l1714:; BSR set to: 0

	line	90
	
	btfsc	((_flags))&0ffh,(0)&7
	goto	u20561
	goto	u20560
u20561:
	goto	l16849
u20560:
	line	91
	
l16847:; BSR set to: 0

		movff	(pad@buf),(fputs@s)
	movff	(pad@buf+1),(fputs@s+1)

		movff	(pad@fp),(fputs@fp)
	movff	(pad@fp+1),(fputs@fp+1)

	call	_fputs	;wreg free
	line	94
	
l16849:; BSR set to: 0

		movff	(pad@buf),(strlen@s)
	movff	(pad@buf+1),(strlen@s+1)

	call	_strlen	;wreg free
	movf	((pad@w))&0ffh,w
	addwf	(0+?_strlen)&0ffh,w
	movwf	((?_pad))&0ffh
	movf	((pad@w+1))&0ffh,w
	addwfc	(1+?_strlen)&0ffh,w
	movwf	1+((?_pad))&0ffh
	line	95
	
l1716:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_pad
	__end_of_pad:
	signat	_pad,12410
	global	_fputs

;; *************** function _fputs *****************
;; Defined at:
;;		line 8 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\nf_fputs.c"
;; Parameters:    Size  Location     Type
;;  s               2   48[BANK0 ] PTR const unsigned char 
;;		 -> dbuf(32), 
;;  fp              2   50[BANK0 ] PTR struct _IO_FILE
;;		 -> sprintf@f(11), NULL(0), 
;; Auto vars:     Size  Location     Type
;;  i               2   53[BANK0 ] int 
;;  c               1   52[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  2   48[BANK0 ] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       4       0       0       0       0       0       0       0
;;      Locals:         0       3       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       7       0       0       0       0       0       0       0
;;Total ram usage:        7 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 15
;; This function calls:
;;		_fputc
;; This function is called by:
;;		_pad
;; This function uses a non-reentrant model
;;
psect	text32,class=CODE,space=0,reloc=2,group=3
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\nf_fputs.c"
	line	8
global __ptext32
__ptext32:
psect	text32
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\nf_fputs.c"
	line	8
	
_fputs:; BSR set to: 0

;incstack = 0
	callstack 7
	line	13
	
l16743:; BSR set to: 0

	movlw	high(0)
	movwf	((fputs@i+1))&0ffh
	movlw	low(0)
	movwf	((fputs@i))&0ffh
	line	14
	goto	l16749
	line	15
	
l16745:; BSR set to: 0

	movff	(fputs@c),(fputc@c)
	clrf	((fputc@c+1))&0ffh
		movff	(fputs@fp),(fputc@fp)
	movff	(fputs@fp+1),(fputc@fp+1)

	call	_fputc	;wreg free
	line	16
	
l16747:
	movlb	0	; () banked
	infsnz	((fputs@i))&0ffh
	incf	((fputs@i+1))&0ffh
	line	14
	
l16749:; BSR set to: 0

	movf	((fputs@i))&0ffh,w
	addwf	((fputs@s))&0ffh,w
	movwf	c:fsr2l
	movf	((fputs@i+1))&0ffh,w
	addwfc	((fputs@s+1))&0ffh,w
	movwf	1+c:fsr2l
	movf	indf2,w
	movwf	((fputs@c))&0ffh
	movf	((fputs@c))&0ffh,w
	btfss	status,2
	goto	u20391
	goto	u20390
u20391:
	goto	l16745
u20390:
	line	19
	
l1813:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_fputs
	__end_of_fputs:
	signat	_fputs,8314
	global	_fputc

;; *************** function _fputc *****************
;; Defined at:
;;		line 8 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\nf_fputc.c"
;; Parameters:    Size  Location     Type
;;  c               2   39[BANK0 ] int 
;;  fp              2   41[BANK0 ] PTR struct _IO_FILE
;;		 -> sprintf@f(11), NULL(0), 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  2   39[BANK0 ] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       4       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       5       0       0       0       0       0       0       0
;;      Totals:         0       9       0       0       0       0       0       0       0
;;Total ram usage:        9 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 14
;; This function calls:
;;		_putch
;; This function is called by:
;;		_pad
;;		_stoa
;;		_vfpfcnvrt
;;		_fputs
;; This function uses a non-reentrant model
;;
psect	text33,class=CODE,space=0,reloc=2,group=3
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\nf_fputc.c"
	line	8
global __ptext33
__ptext33:
psect	text33
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\nf_fputc.c"
	line	8
	
_fputc:; BSR set to: 0

;incstack = 0
	callstack 9
	line	12
	
l16719:; BSR set to: 0

	movf	((fputc@fp))&0ffh,w
iorwf	((fputc@fp+1))&0ffh,w
	btfsc	status,2
	goto	u20331
	goto	u20330

u20331:
	goto	l16723
u20330:
	
l16721:; BSR set to: 0

	movf	((fputc@fp))&0ffh,w
iorwf	((fputc@fp+1))&0ffh,w
	btfss	status,2
	goto	u20341
	goto	u20340

u20341:
	goto	l16725
u20340:
	line	13
	
l16723:; BSR set to: 0

	movf	((fputc@c))&0ffh,w
	
	call	_putch
	line	14
	goto	l1805
	line	15
	
l16725:; BSR set to: 0

	lfsr	2,09h
	movf	((fputc@fp))&0ffh,w
	addwf	fsr2l
	movf	((fputc@fp+1))&0ffh,w
	addwfc	fsr2h
	movf	postinc2,w
iorwf	postinc2,w
	btfsc	status,2
	goto	u20351
	goto	u20350

u20351:
	goto	l16729
u20350:
	
l16727:; BSR set to: 0

	lfsr	2,09h
	movf	((fputc@fp))&0ffh,w
	addwf	fsr2l
	movf	((fputc@fp+1))&0ffh,w
	addwfc	fsr2h
	lfsr	1,03h
	movf	((fputc@fp))&0ffh,w
	addwf	fsr1l
	movf	((fputc@fp+1))&0ffh,w
	addwfc	fsr1h
		movf	postinc2,w
	subwf	postinc1,w
	movf	postinc1,w
	xorlw	80h
	movwf	(??_fputc+4+0)&0ffh
	movf	postinc2,w
	xorlw	80h
	subwfb	(??_fputc+4+0)&0ffh,w
	btfsc	status,0
	goto	u20361
	goto	u20360

u20361:
	goto	l1805
u20360:
	line	18
	
l16729:; BSR set to: 0

	lfsr	2,03h
	movf	((fputc@fp))&0ffh,w
	addwf	fsr2l
	movf	((fputc@fp+1))&0ffh,w
	addwfc	fsr2h
	movff	postinc2,??_fputc+0+0
	movff	postdec2,??_fputc+0+0+1
	movff	(fputc@fp),fsr2l
	movff	(fputc@fp+1),fsr2h
	movff	postinc2,??_fputc+2+0
	movff	postdec2,??_fputc+2+0+1
	movf	(??_fputc+0+0)&0ffh,w
	addwf	(??_fputc+2+0)&0ffh,w
	movwf	c:fsr2l
	movf	(??_fputc+0+1)&0ffh,w
	addwfc	(??_fputc+2+1)&0ffh,w
	movwf	1+c:fsr2l
	movff	(fputc@c),indf2

	line	20
	lfsr	2,03h
	movf	((fputc@fp))&0ffh,w
	addwf	fsr2l
	movf	((fputc@fp+1))&0ffh,w
	addwfc	fsr2h
	incf	postinc2
	movlw	0
	addwfc	postdec2
	line	24
	
l1805:
	return	;funcret
	callstack 0
GLOBAL	__end_of_fputc
	__end_of_fputc:
	signat	_fputc,8314
	global	_putch

;; *************** function _putch *****************
;; Defined at:
;;		line 78 in file "./UART.h"
;; Parameters:    Size  Location     Type
;;  dato            1    wreg     unsigned char 
;; Auto vars:     Size  Location     Type
;;  dato            1   38[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       1       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       1       0       0       0       0       0       0       0
;;Total ram usage:        1 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 13
;; This function calls:
;;		_UART_write
;; This function is called by:
;;		_fputc
;; This function uses a non-reentrant model
;;
psect	text34,class=CODE,space=0,reloc=2,group=0
	file	"./UART.h"
	line	78
global __ptext34
__ptext34:
psect	text34
	file	"./UART.h"
	line	78
	
_putch:
;incstack = 0
	callstack 9
	movwf	((putch@dato))&0ffh
	line	80
	
l16717:
	movlb	0	; () banked
	movf	((putch@dato))&0ffh,w
	
	call	_UART_write
	line	81
	
l125:
	return	;funcret
	callstack 0
GLOBAL	__end_of_putch
	__end_of_putch:
	signat	_putch,4217
	global	_UART_write

;; *************** function _UART_write *****************
;; Defined at:
;;		line 63 in file "./UART.h"
;; Parameters:    Size  Location     Type
;;  dato            1    wreg     unsigned char 
;; Auto vars:     Size  Location     Type
;;  dato            1   37[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       1       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       1       0       0       0       0       0       0       0
;;Total ram usage:        1 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_putch
;; This function uses a non-reentrant model
;;
psect	text35,class=CODE,space=0,reloc=2,group=0
	line	63
global __ptext35
__ptext35:
psect	text35
	file	"./UART.h"
	line	63
	
_UART_write:
;incstack = 0
	callstack 9
	movwf	((UART_write@dato))&0ffh
	line	65
	
l16715:
	movff	(UART_write@dato),(c:4013)	;volatile
	line	66
	
l113:
	btfss	((c:4012))^0f00h,c,1	;volatile
	goto	u20321
	goto	u20320
u20321:
	goto	l113
u20320:
	line	67
	
l116:
	return	;funcret
	callstack 0
GLOBAL	__end_of_UART_write
	__end_of_UART_write:
	signat	_UART_write,4217
	global	_abs

;; *************** function _abs *****************
;; Defined at:
;;		line 1 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\abs.c"
;; Parameters:    Size  Location     Type
;;  a               2   55[BANK0 ] int 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  2   55[BANK0 ] int 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       2       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       2       0       0       0       0       0       0       0
;;      Totals:         0       4       0       0       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_dtoa
;; This function uses a non-reentrant model
;;
psect	text36,class=CODE,space=0,reloc=2,group=3
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\abs.c"
	line	1
global __ptext36
__ptext36:
psect	text36
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\abs.c"
	line	1
	
_abs:
;incstack = 0
	callstack 11
	line	3
	
l16853:; BSR set to: 0

	btfsc	((abs@a+1))&0ffh,7
	goto	u20570
	movf	((abs@a+1))&0ffh,w
	bnz	u20571
	decf	((abs@a))&0ffh,w
	btfsc	status,0
	goto	u20571
	goto	u20570

u20571:
	goto	l1790
u20570:
	
l16855:; BSR set to: 0

	movff	(abs@a),??_abs+0+0
	movff	(abs@a+1),??_abs+0+0+1
	comf	(??_abs+0+0)&0ffh
	comf	(??_abs+0+1)&0ffh
	infsnz	(??_abs+0+0)&0ffh
	incf	(??_abs+0+1)&0ffh
	movff	??_abs+0+0,(?_abs)
	movff	??_abs+0+1,(?_abs+1)
	goto	l1793
	
l1790:; BSR set to: 0

	movff	(abs@a),(?_abs)
	movff	(abs@a+1),(?_abs+1)
	line	4
	
l1793:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_abs
	__end_of_abs:
	signat	_abs,4218
	global	___aomod

;; *************** function ___aomod *****************
;; Defined at:
;;		line 9 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\aomod.c"
;; Parameters:    Size  Location     Type
;;  dividend        8   37[BANK0 ] long long 
;;  divisor         8   45[BANK0 ] long long 
;; Auto vars:     Size  Location     Type
;;  sign            1   54[BANK0 ] unsigned char 
;;  counter         1   53[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  8   37[BANK0 ] long long 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0      16       0       0       0       0       0       0       0
;;      Locals:         0       2       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0      18       0       0       0       0       0       0       0
;;Total ram usage:       18 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_dtoa
;; This function uses a non-reentrant model
;;
psect	text37,class=CODE,space=0,reloc=2,group=2
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\aomod.c"
	line	9
global __ptext37
__ptext37:
psect	text37
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\aomod.c"
	line	9
	
___aomod:; BSR set to: 0

;incstack = 0
	callstack 11
	line	14
	
l16795:; BSR set to: 0

	movlw	low(0)
	movwf	((___aomod@sign))&0ffh
	line	15
	
l16797:; BSR set to: 0

	btfsc	((___aomod@dividend+7))&0ffh,7
	goto	u20470
	goto	u20471

u20471:
	goto	l16803
u20470:
	line	16
	
l16799:; BSR set to: 0

	comf	((___aomod@dividend+7))&0ffh
	comf	((___aomod@dividend+6))&0ffh
	comf	((___aomod@dividend+5))&0ffh
	comf	((___aomod@dividend+4))&0ffh
	comf	((___aomod@dividend+3))&0ffh
	comf	((___aomod@dividend+2))&0ffh
	comf	((___aomod@dividend+1))&0ffh
	negf	((___aomod@dividend))&0ffh
	movlw	0
	addwfc	((___aomod@dividend+1))&0ffh
	addwfc	((___aomod@dividend+2))&0ffh
	addwfc	((___aomod@dividend+3))&0ffh
	addwfc	((___aomod@dividend+4))&0ffh
	addwfc	((___aomod@dividend+5))&0ffh
	addwfc	((___aomod@dividend+6))&0ffh
	addwfc	((___aomod@dividend+7))&0ffh
	line	17
	
l16801:; BSR set to: 0

	movlw	low(01h)
	movwf	((___aomod@sign))&0ffh
	line	19
	
l16803:; BSR set to: 0

	btfsc	((___aomod@divisor+7))&0ffh,7
	goto	u20480
	goto	u20481

u20481:
	goto	l16807
u20480:
	line	20
	
l16805:; BSR set to: 0

	comf	((___aomod@divisor+7))&0ffh
	comf	((___aomod@divisor+6))&0ffh
	comf	((___aomod@divisor+5))&0ffh
	comf	((___aomod@divisor+4))&0ffh
	comf	((___aomod@divisor+3))&0ffh
	comf	((___aomod@divisor+2))&0ffh
	comf	((___aomod@divisor+1))&0ffh
	negf	((___aomod@divisor))&0ffh
	movlw	0
	addwfc	((___aomod@divisor+1))&0ffh
	addwfc	((___aomod@divisor+2))&0ffh
	addwfc	((___aomod@divisor+3))&0ffh
	addwfc	((___aomod@divisor+4))&0ffh
	addwfc	((___aomod@divisor+5))&0ffh
	addwfc	((___aomod@divisor+6))&0ffh
	addwfc	((___aomod@divisor+7))&0ffh
	line	21
	
l16807:; BSR set to: 0

	movf	((___aomod@divisor))&0ffh,w
iorwf	((___aomod@divisor+1))&0ffh,w
iorwf	((___aomod@divisor+2))&0ffh,w
iorwf	((___aomod@divisor+3))&0ffh,w
iorwf	((___aomod@divisor+4))&0ffh,w
iorwf	((___aomod@divisor+5))&0ffh,w
iorwf	((___aomod@divisor+6))&0ffh,w
iorwf	((___aomod@divisor+7))&0ffh,w
	btfsc	status,2
	goto	u20491
	goto	u20490

u20491:
	goto	l16823
u20490:
	line	22
	
l16809:; BSR set to: 0

	movlw	low(01h)
	movwf	((___aomod@counter))&0ffh
	line	23
	goto	l16813
	line	24
	
l16811:; BSR set to: 0

	bcf	status,0
	rlcf	((___aomod@divisor))&0ffh
	rlcf	((___aomod@divisor+1))&0ffh
	rlcf	((___aomod@divisor+2))&0ffh
	rlcf	((___aomod@divisor+3))&0ffh
	rlcf	((___aomod@divisor+4))&0ffh
	rlcf	((___aomod@divisor+5))&0ffh
	rlcf	((___aomod@divisor+6))&0ffh
	rlcf	((___aomod@divisor+7))&0ffh
	line	25
	incf	((___aomod@counter))&0ffh
	line	23
	
l16813:; BSR set to: 0

	
	btfss	((___aomod@divisor+7))&0ffh,(63)&7
	goto	u20501
	goto	u20500
u20501:
	goto	l16811
u20500:
	line	28
	
l16815:; BSR set to: 0

		movf	((___aomod@divisor))&0ffh,w
	subwf	((___aomod@dividend))&0ffh,w
	movf	((___aomod@divisor+1))&0ffh,w
	subwfb	((___aomod@dividend+1))&0ffh,w
	movf	((___aomod@divisor+2))&0ffh,w
	subwfb	((___aomod@dividend+2))&0ffh,w
	movf	((___aomod@divisor+3))&0ffh,w
	subwfb	((___aomod@dividend+3))&0ffh,w
	movf	((___aomod@divisor+4))&0ffh,w
	subwfb	((___aomod@dividend+4))&0ffh,w
	movf	((___aomod@divisor+5))&0ffh,w
	subwfb	((___aomod@dividend+5))&0ffh,w
	movf	((___aomod@divisor+6))&0ffh,w
	subwfb	((___aomod@dividend+6))&0ffh,w
	movf	((___aomod@divisor+7))&0ffh,w
	subwfb	((___aomod@dividend+7))&0ffh,w
	btfss	status,0
	goto	u20511
	goto	u20510

u20511:
	goto	l16819
u20510:
	line	29
	
l16817:; BSR set to: 0

	movf	((___aomod@divisor))&0ffh,w
	subwf	((___aomod@dividend))&0ffh
	movf	((___aomod@divisor+1))&0ffh,w
	subwfb	((___aomod@dividend+1))&0ffh
	movf	((___aomod@divisor+2))&0ffh,w
	subwfb	((___aomod@dividend+2))&0ffh
	movf	((___aomod@divisor+3))&0ffh,w
	subwfb	((___aomod@dividend+3))&0ffh
	movf	((___aomod@divisor+4))&0ffh,w
	subwfb	((___aomod@dividend+4))&0ffh
	movf	((___aomod@divisor+5))&0ffh,w
	subwfb	((___aomod@dividend+5))&0ffh
	movf	((___aomod@divisor+6))&0ffh,w
	subwfb	((___aomod@dividend+6))&0ffh
	movf	((___aomod@divisor+7))&0ffh,w
	subwfb	((___aomod@dividend+7))&0ffh
	line	30
	
l16819:; BSR set to: 0

	bcf	status,0
	rrcf	((___aomod@divisor+7))&0ffh
	rrcf	((___aomod@divisor+6))&0ffh
	rrcf	((___aomod@divisor+5))&0ffh
	rrcf	((___aomod@divisor+4))&0ffh
	rrcf	((___aomod@divisor+3))&0ffh
	rrcf	((___aomod@divisor+2))&0ffh
	rrcf	((___aomod@divisor+1))&0ffh
	rrcf	((___aomod@divisor))&0ffh
	line	31
	
l16821:; BSR set to: 0

	decfsz	((___aomod@counter))&0ffh
	
	goto	l16815
	line	33
	
l16823:; BSR set to: 0

	movf	((___aomod@sign))&0ffh,w
	btfsc	status,2
	goto	u20521
	goto	u20520
u20521:
	goto	l16827
u20520:
	line	34
	
l16825:; BSR set to: 0

	comf	((___aomod@dividend+7))&0ffh
	comf	((___aomod@dividend+6))&0ffh
	comf	((___aomod@dividend+5))&0ffh
	comf	((___aomod@dividend+4))&0ffh
	comf	((___aomod@dividend+3))&0ffh
	comf	((___aomod@dividend+2))&0ffh
	comf	((___aomod@dividend+1))&0ffh
	negf	((___aomod@dividend))&0ffh
	movlw	0
	addwfc	((___aomod@dividend+1))&0ffh
	addwfc	((___aomod@dividend+2))&0ffh
	addwfc	((___aomod@dividend+3))&0ffh
	addwfc	((___aomod@dividend+4))&0ffh
	addwfc	((___aomod@dividend+5))&0ffh
	addwfc	((___aomod@dividend+6))&0ffh
	addwfc	((___aomod@dividend+7))&0ffh
	line	35
	
l16827:; BSR set to: 0

	movff	(___aomod@dividend),(?___aomod)
	movff	(___aomod@dividend+1),(?___aomod+1)
	movff	(___aomod@dividend+2),(?___aomod+2)
	movff	(___aomod@dividend+3),(?___aomod+3)
	movff	(___aomod@dividend+4),(?___aomod+4)
	movff	(___aomod@dividend+5),(?___aomod+5)
	movff	(___aomod@dividend+6),(?___aomod+6)
	movff	(___aomod@dividend+7),(?___aomod+7)
	line	36
	
l1076:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of___aomod
	__end_of___aomod:
	signat	___aomod,8319
	global	___aodiv

;; *************** function ___aodiv *****************
;; Defined at:
;;		line 9 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\aodiv.c"
;; Parameters:    Size  Location     Type
;;  dividend        8   37[BANK0 ] long long 
;;  divisor         8   45[BANK0 ] long long 
;; Auto vars:     Size  Location     Type
;;  quotient        8   55[BANK0 ] long long 
;;  sign            1   54[BANK0 ] unsigned char 
;;  counter         1   53[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  8   37[BANK0 ] long long 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0      16       0       0       0       0       0       0       0
;;      Locals:         0      10       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0      26       0       0       0       0       0       0       0
;;Total ram usage:       26 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_dtoa
;; This function uses a non-reentrant model
;;
psect	text38,class=CODE,space=0,reloc=2,group=2
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\aodiv.c"
	line	9
global __ptext38
__ptext38:
psect	text38
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\aodiv.c"
	line	9
	
___aodiv:; BSR set to: 0

;incstack = 0
	callstack 11
	line	15
	
l16751:; BSR set to: 0

	movlw	low(0)
	movwf	((___aodiv@sign))&0ffh
	line	16
	
l16753:; BSR set to: 0

	btfsc	((___aodiv@divisor+7))&0ffh,7
	goto	u20400
	goto	u20401

u20401:
	goto	l16759
u20400:
	line	17
	
l16755:; BSR set to: 0

	comf	((___aodiv@divisor+7))&0ffh
	comf	((___aodiv@divisor+6))&0ffh
	comf	((___aodiv@divisor+5))&0ffh
	comf	((___aodiv@divisor+4))&0ffh
	comf	((___aodiv@divisor+3))&0ffh
	comf	((___aodiv@divisor+2))&0ffh
	comf	((___aodiv@divisor+1))&0ffh
	negf	((___aodiv@divisor))&0ffh
	movlw	0
	addwfc	((___aodiv@divisor+1))&0ffh
	addwfc	((___aodiv@divisor+2))&0ffh
	addwfc	((___aodiv@divisor+3))&0ffh
	addwfc	((___aodiv@divisor+4))&0ffh
	addwfc	((___aodiv@divisor+5))&0ffh
	addwfc	((___aodiv@divisor+6))&0ffh
	addwfc	((___aodiv@divisor+7))&0ffh
	line	18
	
l16757:; BSR set to: 0

	movlw	low(01h)
	movwf	((___aodiv@sign))&0ffh
	line	20
	
l16759:; BSR set to: 0

	btfsc	((___aodiv@dividend+7))&0ffh,7
	goto	u20410
	goto	u20411

u20411:
	goto	l16765
u20410:
	line	21
	
l16761:; BSR set to: 0

	comf	((___aodiv@dividend+7))&0ffh
	comf	((___aodiv@dividend+6))&0ffh
	comf	((___aodiv@dividend+5))&0ffh
	comf	((___aodiv@dividend+4))&0ffh
	comf	((___aodiv@dividend+3))&0ffh
	comf	((___aodiv@dividend+2))&0ffh
	comf	((___aodiv@dividend+1))&0ffh
	negf	((___aodiv@dividend))&0ffh
	movlw	0
	addwfc	((___aodiv@dividend+1))&0ffh
	addwfc	((___aodiv@dividend+2))&0ffh
	addwfc	((___aodiv@dividend+3))&0ffh
	addwfc	((___aodiv@dividend+4))&0ffh
	addwfc	((___aodiv@dividend+5))&0ffh
	addwfc	((___aodiv@dividend+6))&0ffh
	addwfc	((___aodiv@dividend+7))&0ffh
	line	22
	
l16763:; BSR set to: 0

	movlw	(01h)&0ffh
	xorwf	((___aodiv@sign))&0ffh
	line	24
	
l16765:; BSR set to: 0

	lfsr	2,(___aodiv@quotient)
	movlw	8-1
u20421:
	clrf	postinc2
	decf	wreg
	bc	u20421
	line	25
	
l16767:; BSR set to: 0

	movf	((___aodiv@divisor))&0ffh,w
iorwf	((___aodiv@divisor+1))&0ffh,w
iorwf	((___aodiv@divisor+2))&0ffh,w
iorwf	((___aodiv@divisor+3))&0ffh,w
iorwf	((___aodiv@divisor+4))&0ffh,w
iorwf	((___aodiv@divisor+5))&0ffh,w
iorwf	((___aodiv@divisor+6))&0ffh,w
iorwf	((___aodiv@divisor+7))&0ffh,w
	btfsc	status,2
	goto	u20431
	goto	u20430

u20431:
	goto	l16787
u20430:
	line	26
	
l16769:; BSR set to: 0

	movlw	low(01h)
	movwf	((___aodiv@counter))&0ffh
	line	27
	goto	l16773
	line	28
	
l16771:; BSR set to: 0

	bcf	status,0
	rlcf	((___aodiv@divisor))&0ffh
	rlcf	((___aodiv@divisor+1))&0ffh
	rlcf	((___aodiv@divisor+2))&0ffh
	rlcf	((___aodiv@divisor+3))&0ffh
	rlcf	((___aodiv@divisor+4))&0ffh
	rlcf	((___aodiv@divisor+5))&0ffh
	rlcf	((___aodiv@divisor+6))&0ffh
	rlcf	((___aodiv@divisor+7))&0ffh
	line	29
	incf	((___aodiv@counter))&0ffh
	line	27
	
l16773:; BSR set to: 0

	
	btfss	((___aodiv@divisor+7))&0ffh,(63)&7
	goto	u20441
	goto	u20440
u20441:
	goto	l16771
u20440:
	line	32
	
l16775:; BSR set to: 0

	bcf	status,0
	rlcf	((___aodiv@quotient))&0ffh
	rlcf	((___aodiv@quotient+1))&0ffh
	rlcf	((___aodiv@quotient+2))&0ffh
	rlcf	((___aodiv@quotient+3))&0ffh
	rlcf	((___aodiv@quotient+4))&0ffh
	rlcf	((___aodiv@quotient+5))&0ffh
	rlcf	((___aodiv@quotient+6))&0ffh
	rlcf	((___aodiv@quotient+7))&0ffh
	line	33
	
l16777:; BSR set to: 0

		movf	((___aodiv@divisor))&0ffh,w
	subwf	((___aodiv@dividend))&0ffh,w
	movf	((___aodiv@divisor+1))&0ffh,w
	subwfb	((___aodiv@dividend+1))&0ffh,w
	movf	((___aodiv@divisor+2))&0ffh,w
	subwfb	((___aodiv@dividend+2))&0ffh,w
	movf	((___aodiv@divisor+3))&0ffh,w
	subwfb	((___aodiv@dividend+3))&0ffh,w
	movf	((___aodiv@divisor+4))&0ffh,w
	subwfb	((___aodiv@dividend+4))&0ffh,w
	movf	((___aodiv@divisor+5))&0ffh,w
	subwfb	((___aodiv@dividend+5))&0ffh,w
	movf	((___aodiv@divisor+6))&0ffh,w
	subwfb	((___aodiv@dividend+6))&0ffh,w
	movf	((___aodiv@divisor+7))&0ffh,w
	subwfb	((___aodiv@dividend+7))&0ffh,w
	btfss	status,0
	goto	u20451
	goto	u20450

u20451:
	goto	l16783
u20450:
	line	34
	
l16779:; BSR set to: 0

	movf	((___aodiv@divisor))&0ffh,w
	subwf	((___aodiv@dividend))&0ffh
	movf	((___aodiv@divisor+1))&0ffh,w
	subwfb	((___aodiv@dividend+1))&0ffh
	movf	((___aodiv@divisor+2))&0ffh,w
	subwfb	((___aodiv@dividend+2))&0ffh
	movf	((___aodiv@divisor+3))&0ffh,w
	subwfb	((___aodiv@dividend+3))&0ffh
	movf	((___aodiv@divisor+4))&0ffh,w
	subwfb	((___aodiv@dividend+4))&0ffh
	movf	((___aodiv@divisor+5))&0ffh,w
	subwfb	((___aodiv@dividend+5))&0ffh
	movf	((___aodiv@divisor+6))&0ffh,w
	subwfb	((___aodiv@dividend+6))&0ffh
	movf	((___aodiv@divisor+7))&0ffh,w
	subwfb	((___aodiv@dividend+7))&0ffh
	line	35
	
l16781:; BSR set to: 0

	bsf	(0+(0/8)+(___aodiv@quotient))&0ffh,(0)&7
	line	37
	
l16783:; BSR set to: 0

	bcf	status,0
	rrcf	((___aodiv@divisor+7))&0ffh
	rrcf	((___aodiv@divisor+6))&0ffh
	rrcf	((___aodiv@divisor+5))&0ffh
	rrcf	((___aodiv@divisor+4))&0ffh
	rrcf	((___aodiv@divisor+3))&0ffh
	rrcf	((___aodiv@divisor+2))&0ffh
	rrcf	((___aodiv@divisor+1))&0ffh
	rrcf	((___aodiv@divisor))&0ffh
	line	38
	
l16785:; BSR set to: 0

	decfsz	((___aodiv@counter))&0ffh
	
	goto	l16775
	line	40
	
l16787:; BSR set to: 0

	movf	((___aodiv@sign))&0ffh,w
	btfsc	status,2
	goto	u20461
	goto	u20460
u20461:
	goto	l16791
u20460:
	line	41
	
l16789:; BSR set to: 0

	comf	((___aodiv@quotient+7))&0ffh
	comf	((___aodiv@quotient+6))&0ffh
	comf	((___aodiv@quotient+5))&0ffh
	comf	((___aodiv@quotient+4))&0ffh
	comf	((___aodiv@quotient+3))&0ffh
	comf	((___aodiv@quotient+2))&0ffh
	comf	((___aodiv@quotient+1))&0ffh
	negf	((___aodiv@quotient))&0ffh
	movlw	0
	addwfc	((___aodiv@quotient+1))&0ffh
	addwfc	((___aodiv@quotient+2))&0ffh
	addwfc	((___aodiv@quotient+3))&0ffh
	addwfc	((___aodiv@quotient+4))&0ffh
	addwfc	((___aodiv@quotient+5))&0ffh
	addwfc	((___aodiv@quotient+6))&0ffh
	addwfc	((___aodiv@quotient+7))&0ffh
	line	42
	
l16791:; BSR set to: 0

	movff	(___aodiv@quotient),(?___aodiv)
	movff	(___aodiv@quotient+1),(?___aodiv+1)
	movff	(___aodiv@quotient+2),(?___aodiv+2)
	movff	(___aodiv@quotient+3),(?___aodiv+3)
	movff	(___aodiv@quotient+4),(?___aodiv+4)
	movff	(___aodiv@quotient+5),(?___aodiv+5)
	movff	(___aodiv@quotient+6),(?___aodiv+6)
	movff	(___aodiv@quotient+7),(?___aodiv+7)
	line	43
	
l1063:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of___aodiv
	__end_of___aodiv:
	signat	___aodiv,8319
	global	_cleanBuffer

;; *************** function _cleanBuffer *****************
;; Defined at:
;;		line 280 in file "Aplicacion.c"
;; Parameters:    Size  Location     Type
;;  orig            2   53[BANK0 ] PTR unsigned char 
;;		 -> ap(76), 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       2       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       2       0       0       0       0       0       0       0
;;Total ram usage:        2 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 13
;; This function calls:
;;		_memset
;;		_strlen
;; This function is called by:
;;		_readDevide
;; This function uses a non-reentrant model
;;
psect	text39,class=CODE,space=0,reloc=2,group=0
	file	"Aplicacion.c"
	line	280
global __ptext39
__ptext39:
psect	text39
	file	"Aplicacion.c"
	line	280
	
_cleanBuffer:; BSR set to: 0

;incstack = 0
	callstack 14
	line	282
	
l17219:; BSR set to: 0

		movff	(cleanBuffer@orig),(memset@dest)
	movff	(cleanBuffer@orig+1),(memset@dest+1)

	movlw	high(0)
	movwf	((memset@c+1))&0ffh
	movlw	low(0)
	movwf	((memset@c))&0ffh
		movff	(cleanBuffer@orig),(strlen@s)
	movff	(cleanBuffer@orig+1),(strlen@s+1)

	call	_strlen	;wreg free
	movff	0+?_strlen,(memset@n)
	movff	1+?_strlen,(memset@n+1)
	call	_memset	;wreg free
	line	283
	
l473:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_cleanBuffer
	__end_of_cleanBuffer:
	signat	_cleanBuffer,4217
	global	_oneBeep

;; *************** function _oneBeep *****************
;; Defined at:
;;		line 133 in file "Buzzer.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2
;; Tracked objects:
;;		On entry : 3C/1
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_taskAplicacion
;;		_taskCluster
;; This function uses a non-reentrant model
;;
psect	text40,class=CODE,space=0,reloc=2,group=0
	file	"Buzzer.c"
	line	133
global __ptext40
__ptext40:
psect	text40
	file	"Buzzer.c"
	line	133
	
_oneBeep:; BSR set to: 0

;incstack = 0
	callstack 16
	line	135
	
l6077:
	movlw	low(01h)
	movlb	0	; () banked
	movwf	((_ucTypeBeep))&0ffh
	line	136
	movlw	low(01h)
	movwf	((c:_flagStartBuzzer))^00h,c
	line	137
	
l552:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_oneBeep
	__end_of_oneBeep:
	signat	_oneBeep,89
	global	_inicioEstado

;; *************** function _inicioEstado *****************
;; Defined at:
;;		line 255 in file "Aplicacion.c"
;; Parameters:    Size  Location     Type
;;  state           2   37[BANK0 ] int 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      unsigned char 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/2
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       2       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       2       0       0       0       0       0       0       0
;;Total ram usage:        2 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_taskAplicacion
;; This function uses a non-reentrant model
;;
psect	text41,class=CODE,space=0,reloc=2,group=0
	file	"Aplicacion.c"
	line	255
global __ptext41
__ptext41:
psect	text41
	file	"Aplicacion.c"
	line	255
	
_inicioEstado:; BSR set to: 0

;incstack = 0
	callstack 16
	line	257
	
l6055:; BSR set to: 0

	movf	((inicioEstado@state))&0ffh,w
	movlb	2	; () banked
xorwf	(0+(_ap+01h))&0ffh,w
	bnz	u5970
	movlb	0	; () banked
movf	((inicioEstado@state+1))&0ffh,w
	movlb	2	; () banked
xorwf	(1+(_ap+01h))&0ffh,w
	btfsc	status,2
	goto	u5971
	goto	u5970

u5971:
	goto	l6063
u5970:
	line	259
	
l6057:; BSR set to: 2

	movff	(inicioEstado@state),0+(_ap+01h)
	movff	(inicioEstado@state+1),1+(_ap+01h)
	line	260
	
l6059:; BSR set to: 2

	movlw	(01h)&0ffh
	goto	l464
	line	262
	
l6063:; BSR set to: 2

	movlw	(0)&0ffh
	line	263
	
l464:; BSR set to: 2

	return	;funcret
	callstack 0
GLOBAL	__end_of_inicioEstado
	__end_of_inicioEstado:
	signat	_inicioEstado,4217
	global	_cambiarEstado

;; *************** function _cambiarEstado *****************
;; Defined at:
;;		line 266 in file "Aplicacion.c"
;; Parameters:    Size  Location     Type
;;  state           2   37[BANK0 ] int 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		None
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/2
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       2       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       2       0       0       0       0       0       0       0
;;Total ram usage:        2 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_taskAplicacion
;; This function uses a non-reentrant model
;;
psect	text42,class=CODE,space=0,reloc=2,group=0
	line	266
global __ptext42
__ptext42:
psect	text42
	file	"Aplicacion.c"
	line	266
	
_cambiarEstado:; BSR set to: 2

;incstack = 0
	callstack 16
	line	268
	
l6053:; BSR set to: 0

	movlb	2	; () banked
	setf	(0+(_ap+01h))&0ffh
	setf	(1+(_ap+01h))&0ffh
	line	269
	movff	(cambiarEstado@state),(_stateAp)
	line	270
	
l467:; BSR set to: 2

	return	;funcret
	callstack 0
GLOBAL	__end_of_cambiarEstado
	__end_of_cambiarEstado:
	signat	_cambiarEstado,4217
	global	_ADC_read

;; *************** function _ADC_read *****************
;; Defined at:
;;		line 188 in file "main.c"
;; Parameters:    Size  Location     Type
;;  channel         1    wreg     unsigned char 
;; Auto vars:     Size  Location     Type
;;  channel         1   41[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  2   37[BANK0 ] unsigned short 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 3F/2
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       2       0       0       0       0       0       0       0
;;      Locals:         0       1       0       0       0       0       0       0       0
;;      Temps:          0       2       0       0       0       0       0       0       0
;;      Totals:         0       5       0       0       0       0       0       0       0
;;Total ram usage:        5 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_taskAplicacion
;; This function uses a non-reentrant model
;;
psect	text43,class=CODE,space=0,reloc=2,group=0
	file	"main.c"
	line	188
global __ptext43
__ptext43:
psect	text43
	file	"main.c"
	line	188
	
_ADC_read:; BSR set to: 2

;incstack = 0
	callstack 16
	movlb	0	; () banked
	movwf	((ADC_read@channel))&0ffh
	line	190
	
l5997:
	movff	(ADC_read@channel),??_ADC_read+0+0
	movlb	0	; () banked
	rlncf	(??_ADC_read+0+0)&0ffh
	rlncf	(??_ADC_read+0+0)&0ffh
	movf	((c:4034))^0f00h,c,w	;volatile
	xorwf	(??_ADC_read+0+0)&0ffh,w
	andlw	not (((1<<4)-1)<<2)
	xorwf	(??_ADC_read+0+0)&0ffh,w
	movwf	((c:4034))^0f00h,c	;volatile
	line	191
	
l5999:; BSR set to: 0

	bsf	((c:4034))^0f00h,c,1	;volatile
	line	192
	
l158:
	btfsc	((c:4034))^0f00h,c,1	;volatile
	goto	u5941
	goto	u5940
u5941:
	goto	l158
u5940:
	line	193
	
l6001:
	movf	((c:4036))^0f00h,c,w	;volatile
	movlb	0	; () banked
	movwf	(??_ADC_read+0+0+1)&0ffh
	clrf	(??_ADC_read+0+0)&0ffh
	movf	((c:4035))^0f00h,c,w	;volatile
	addwf	(??_ADC_read+0+0)&0ffh,w
	movwf	((?_ADC_read))&0ffh
	movlw	0
	addwfc	(??_ADC_read+0+1)&0ffh,w
	movwf	1+((?_ADC_read))&0ffh
	line	194
	
l161:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_ADC_read
	__end_of_ADC_read:
	signat	_ADC_read,4218
	global	_executeTaskAnalizaUart1

;; *************** function _executeTaskAnalizaUart1 *****************
;; Defined at:
;;		line 445 in file "Serial.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 16
;; This function calls:
;;		_taskAnalizaUart1
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text44,class=CODE,space=0,reloc=2,group=0
	file	"Serial.c"
	line	445
global __ptext44
__ptext44:
psect	text44
	file	"Serial.c"
	line	445
	
_executeTaskAnalizaUart1:; BSR set to: 0

;incstack = 0
	callstack 14
	line	447
	
l18213:; BSR set to: 0

		movlw	low(_ptTaskAnalizaUart1)
	movwf	((taskAnalizaUart1@pt))&0ffh
	movlw	high(_ptTaskAnalizaUart1)
	movwf	((taskAnalizaUart1@pt+1))&0ffh

	call	_taskAnalizaUart1	;wreg free
	line	448
	
l923:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_executeTaskAnalizaUart1
	__end_of_executeTaskAnalizaUart1:
	signat	_executeTaskAnalizaUart1,89
	global	_taskAnalizaUart1

;; *************** function _taskAnalizaUart1 *****************
;; Defined at:
;;		line 90 in file "Serial.c"
;; Parameters:    Size  Location     Type
;;  pt              2   76[BANK0 ] PTR struct pt
;;		 -> ptTaskAnalizaUart1(2), 
;; Auto vars:     Size  Location     Type
;;  i               1   81[BANK0 ] unsigned char 
;;  x               1   80[BANK0 ] unsigned char 
;;  PT_YIELD_FLA    1    0        unsigned char 
;; Return value:  Size  Location     Type
;;                  2   76[BANK0 ] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       2       0       0       0       0       0       0       0
;;      Locals:         0       2       0       0       0       0       0       0       0
;;      Temps:          0       2       0       0       0       0       0       0       0
;;      Totals:         0       6       0       0       0       0       0       0       0
;;Total ram usage:        6 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 15
;; This function calls:
;;		_EEpromWrite
;;		_atoi
;;		_escribirRTC
;;		_extraerCalendar
;;		_extraerFrame
;;		_extraerHora
;;		_extraerValue
;;		_getMillis
;;		_memset
;;		_strstr
;; This function is called by:
;;		_executeTaskAnalizaUart1
;; This function uses a non-reentrant model
;;
psect	text45,class=CODE,space=0,reloc=2,group=0
	line	90
global __ptext45
__ptext45:
psect	text45
	file	"Serial.c"
	line	90
	
_taskAnalizaUart1:; BSR set to: 0

;incstack = 0
	callstack 14
	line	93
	
l17807:; BSR set to: 0

	goto	l18127
	
l838:; BSR set to: 1

	line	96
	
l17809:
	movlw	01h
	call	_getMillis	;wreg free
	movlb	0	; () banked
	addwf	(0+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	((_ulCntPeriodAnaUart1))&0ffh
	movlw	0
	movlb	0	; () banked
	addwfc	(1+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	1+((_ulCntPeriodAnaUart1))&0ffh
	
	movlw	0
	movlb	0	; () banked
	addwfc	(2+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	2+((_ulCntPeriodAnaUart1))&0ffh
	
	movlw	0
	movlb	0	; () banked
	addwfc	(3+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	3+((_ulCntPeriodAnaUart1))&0ffh
	line	98
	
l17811:; BSR set to: 1

	movff	(taskAnalizaUart1@pt),fsr2l
	movff	(taskAnalizaUart1@pt+1),fsr2h
	movlw	low(062h)
	movwf	postinc2,c
	movlw	high(062h)
	movwf	postdec2,c
	
l17813:
	call	_getMillis	;wreg free
	movlb	1	; () banked
		movf	((_ulCntPeriodAnaUart1))&0ffh,w
	movlb	0	; () banked
	subwf	(0+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movf	((_ulCntPeriodAnaUart1+1))&0ffh,w
	movlb	0	; () banked
	subwfb	(1+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movf	((_ulCntPeriodAnaUart1+2))&0ffh,w
	movlb	0	; () banked
	subwfb	(2+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movf	((_ulCntPeriodAnaUart1+3))&0ffh,w
	movlb	0	; () banked
	subwfb	(3+?_getMillis)&0ffh,w
	btfsc	status,0
	goto	u22241
	goto	u22240

u22241:
	goto	l18125
u22240:
	goto	l843
	line	102
	
l846:; BSR set to: 0

	line	103
	movlb	2	; () banked
	btfss	((_ap))&0ffh,0
	goto	u22251
	goto	u22250
u22251:
	goto	l17809
u22250:
	line	105
	
l17817:; BSR set to: 2

		movlw	low(_serial1+01h)
	movlb	0	; () banked
	movwf	((memset@dest))&0ffh
	movlw	high(_serial1+01h)
	movwf	((memset@dest+1))&0ffh

	movlw	high(0)
	movwf	((memset@c+1))&0ffh
	movlw	low(0)
	movwf	((memset@c))&0ffh
	movlw	high(028h)
	movwf	((memset@n+1))&0ffh
	movlw	low(028h)
	movwf	((memset@n))&0ffh
	call	_memset	;wreg free
	line	106
	
l17819:; BSR set to: 0

	movlw	low(0)
	movlb	2	; () banked
	movwf	(0+(_serial1+029h))&0ffh
	line	107
	
l17821:; BSR set to: 2

	bcf	((_serial1))&0ffh,0
	line	109
	
l17823:
	movlw	low(01h)
	movlb	0	; () banked
	movwf	((_stateAnaTrama1))&0ffh
	goto	l17809
	line	114
	
l849:; BSR set to: 0

	line	115
	movlb	2	; () banked
	btfss	((_serial1))&0ffh,0
	goto	u22261
	goto	u22260
u22261:
	goto	l17809
u22260:
	line	118
	
l17825:; BSR set to: 2

	movlb	1	; () banked
	infsnz	(0+(_anaT1+029h))&0ffh
	incf	(1+(_anaT1+029h))&0ffh
		movf	(1+(_anaT1+029h))&0ffh,w
	bnz	u22270
	movlw	5
	subwf	 (0+(_anaT1+029h))&0ffh,w
	btfss	status,0
	goto	u22271
	goto	u22270

u22271:
	goto	l838
u22270:
	line	120
	
l17827:; BSR set to: 1

	movlb	2	; () banked
	bcf	((_serial1))&0ffh,0
	line	122
	
l17829:; BSR set to: 2

		movlw	low(_anaT1)
	movlb	0	; () banked
	movwf	((memset@dest))&0ffh
	movlw	high(_anaT1)
	movwf	((memset@dest+1))&0ffh

	movlw	high(0)
	movwf	((memset@c+1))&0ffh
	movlw	low(0)
	movwf	((memset@c))&0ffh
	movlw	high(028h)
	movwf	((memset@n+1))&0ffh
	movlw	low(028h)
	movwf	((memset@n))&0ffh
	call	_memset	;wreg free
	line	125
	
l17831:; BSR set to: 0

	movlw	low(0)
	movwf	((taskAnalizaUart1@x))&0ffh
	line	126
	
l17833:; BSR set to: 0

	movlw	low(0)
	movwf	((taskAnalizaUart1@i))&0ffh
	line	128
	
l17839:; BSR set to: 0

	movlw	low(_serial1+01h)
	addwf	((taskAnalizaUart1@i))&0ffh,w
	movwf	c:fsr2l
	clrf	1+c:fsr2l
	movlw	high(_serial1+01h)
	addwfc	1+c:fsr2l
	movf	indf2,w
	btfsc	status,2
	goto	u22281
	goto	u22280
u22281:
	goto	l17845
u22280:
	line	130
	
l17841:; BSR set to: 0

	movlw	low(_serial1+01h)
	addwf	((taskAnalizaUart1@i))&0ffh,w
	movwf	c:fsr2l
	clrf	1+c:fsr2l
	movlw	high(_serial1+01h)
	addwfc	1+c:fsr2l
	movlw	low(_anaT1)
	addwf	((taskAnalizaUart1@x))&0ffh,w
	movwf	c:fsr1l
	clrf	1+c:fsr1l
	movlw	high(_anaT1)
	addwfc	1+c:fsr1l
	movff	indf2,indf1
	
l17843:; BSR set to: 0

	incf	((taskAnalizaUart1@x))&0ffh
	line	132
	
l17845:; BSR set to: 0

	incf	((taskAnalizaUart1@i))&0ffh
	
l17847:; BSR set to: 0

		movlw	029h-1
	cpfsgt	((taskAnalizaUart1@i))&0ffh
	goto	u22291
	goto	u22290

u22291:
	goto	l17839
u22290:
	line	136
	
l17849:; BSR set to: 0

		movlw	low(_serial1+01h)
	movwf	((memset@dest))&0ffh
	movlw	high(_serial1+01h)
	movwf	((memset@dest+1))&0ffh

	movlw	high(0)
	movwf	((memset@c+1))&0ffh
	movlw	low(0)
	movwf	((memset@c))&0ffh
	movlw	high(028h)
	movwf	((memset@n+1))&0ffh
	movlw	low(028h)
	movwf	((memset@n))&0ffh
	call	_memset	;wreg free
	line	137
	
l17851:; BSR set to: 0

	movlw	low(0)
	movlb	2	; () banked
	movwf	(0+(_serial1+029h))&0ffh
	line	139
	
l17853:; BSR set to: 2

	movlw	low(02h)
	movlb	0	; () banked
	movwf	((_stateAnaTrama1))&0ffh
	goto	l17809
	line	148
	
l17855:; BSR set to: 0

		movlw	low(_anaT1)
	movwf	((strstr@h))&0ffh
	movlw	high(_anaT1)
	movwf	((strstr@h+1))&0ffh

		movlw	low(STR_18)
	movwf	((strstr@n))&0ffh
	movlw	high(STR_18)
	movwf	((strstr@n+1))&0ffh

	call	_strstr	;wreg free
	movf	(0+?_strstr)&0ffh,w
iorwf	(1+?_strstr)&0ffh,w
	btfsc	status,2
	goto	u22301
	goto	u22300

u22301:
	goto	l17823
u22300:
	line	150
	
l17857:; BSR set to: 0

	movlw	low(03h)
	movwf	((_stateAnaTrama1))&0ffh
	line	151
	goto	l17809
	line	160
	
l17861:; BSR set to: 0

		movlw	low(_anaT1)
	movwf	((strstr@h))&0ffh
	movlw	high(_anaT1)
	movwf	((strstr@h+1))&0ffh

		movlw	low(STR_20)
	movwf	((strstr@n))&0ffh
	movlw	high(STR_20)
	movwf	((strstr@n+1))&0ffh

	call	_strstr	;wreg free
	movf	(0+?_strstr)&0ffh,w
iorwf	(1+?_strstr)&0ffh,w
	btfsc	status,2
	goto	u22311
	goto	u22310

u22311:
	goto	l17867
u22310:
	line	162
	
l17863:; BSR set to: 0

	movlb	2	; () banked
	bsf	(0+(_serial1+02Ah))&0ffh,0
	goto	l17823
	line	166
	
l17867:; BSR set to: 0

		movlw	low(_anaT1)
	movwf	((strstr@h))&0ffh
	movlw	high(_anaT1)
	movwf	((strstr@h+1))&0ffh

		movlw	low(STR_22)
	movwf	((strstr@n))&0ffh
	movlw	high(STR_22)
	movwf	((strstr@n+1))&0ffh

	call	_strstr	;wreg free
	movf	(0+?_strstr)&0ffh,w
iorwf	(1+?_strstr)&0ffh,w
	btfsc	status,2
	goto	u22321
	goto	u22320

u22321:
	goto	l17881
u22320:
	line	168
	
l17869:; BSR set to: 0

		movlw	low(_anaT1)
	movwf	((extraerFrame@orig))&0ffh
	movlw	high(_anaT1)
	movwf	((extraerFrame@orig+1))&0ffh

		movlw	low(_anaT1+02Dh)
	movwf	((extraerFrame@dest))&0ffh
	movlw	high(_anaT1+02Dh)
	movwf	((extraerFrame@dest+1))&0ffh

		movlw	low(STR_23)
	movwf	((extraerFrame@init))&0ffh
	movlw	high(STR_23)
	movwf	((extraerFrame@init+1))&0ffh

		movlw	low(STR_24)
	movwf	((extraerFrame@end))&0ffh
	movlw	high(STR_24)
	movwf	((extraerFrame@end+1))&0ffh

	call	_extraerFrame	;wreg free
	line	169
	
l17871:; BSR set to: 0

		movlw	low(_anaT1+02Dh)
	movwf	((extraerHora@orig))&0ffh
	movlw	high(_anaT1+02Dh)
	movwf	((extraerHora@orig+1))&0ffh

		movlw	low(_anaT1+037h)
	movwf	((extraerHora@hor))&0ffh
	movlw	high(_anaT1+037h)
	movwf	((extraerHora@hor+1))&0ffh

		movlw	low(_anaT1+038h)
	movwf	((extraerHora@min))&0ffh
	movlw	high(_anaT1+038h)
	movwf	((extraerHora@min+1))&0ffh

	call	_extraerHora	;wreg free
	line	171
	
l17873:; BSR set to: 0

		movlw	low(_anaT1)
	movwf	((extraerFrame@orig))&0ffh
	movlw	high(_anaT1)
	movwf	((extraerFrame@orig+1))&0ffh

		movlw	low(_anaT1+02Dh)
	movwf	((extraerFrame@dest))&0ffh
	movlw	high(_anaT1+02Dh)
	movwf	((extraerFrame@dest+1))&0ffh

		movlw	low(STR_25)
	movwf	((extraerFrame@init))&0ffh
	movlw	high(STR_25)
	movwf	((extraerFrame@init+1))&0ffh

		movlw	low(STR_26)
	movwf	((extraerFrame@end))&0ffh
	movlw	high(STR_26)
	movwf	((extraerFrame@end+1))&0ffh

	call	_extraerFrame	;wreg free
	line	172
		movlw	low(_anaT1+02Dh)
	movwf	((extraerCalendar@orig))&0ffh
	movlw	high(_anaT1+02Dh)
	movwf	((extraerCalendar@orig+1))&0ffh

		movlw	low(_anaT1+039h)
	movwf	((extraerCalendar@dia))&0ffh
	movlw	high(_anaT1+039h)
	movwf	((extraerCalendar@dia+1))&0ffh

		movlw	low(_anaT1+03Ah)
	movwf	((extraerCalendar@mes))&0ffh
	movlw	high(_anaT1+03Ah)
	movwf	((extraerCalendar@mes+1))&0ffh

		movlw	low(_anaT1+03Bh)
	movwf	((extraerCalendar@ano))&0ffh
	movlw	high(_anaT1+03Bh)
	movwf	((extraerCalendar@ano+1))&0ffh

		movlw	low(_anaT1+03Ch)
	movwf	((extraerCalendar@diaSema))&0ffh
	movlw	high(_anaT1+03Ch)
	movwf	((extraerCalendar@diaSema+1))&0ffh

	call	_extraerCalendar	;wreg free
	line	174
	
l17875:; BSR set to: 0

	movff	0+(_anaT1+038h),(escribirRTC@min)
	movlw	low(0)
	movwf	((escribirRTC@seg))&0ffh
	movff	0+(_anaT1+039h),(escribirRTC@dia)
	movff	0+(_anaT1+03Ah),(escribirRTC@mes)
	movff	0+(_anaT1+03Bh),(escribirRTC@ano)
	movff	0+(_anaT1+03Ch),(escribirRTC@diaSe)
	movlb	1	; () banked
	movf	(0+(_anaT1+037h))&0ffh,w
	
	call	_escribirRTC
	line	176
	
l17877:; BSR set to: 0

	movlb	2	; () banked
	bsf	(0+(_serial1+02Ah))&0ffh,1
	goto	l17823
	line	181
	
l17881:; BSR set to: 0

		movlw	low(_anaT1)
	movwf	((strstr@h))&0ffh
	movlw	high(_anaT1)
	movwf	((strstr@h+1))&0ffh

		movlw	low(STR_28)
	movwf	((strstr@n))&0ffh
	movlw	high(STR_28)
	movwf	((strstr@n+1))&0ffh

	call	_strstr	;wreg free
	movf	(0+?_strstr)&0ffh,w
iorwf	(1+?_strstr)&0ffh,w
	btfsc	status,2
	goto	u22331
	goto	u22330

u22331:
	goto	l17823
u22330:
	line	184
	
l17883:; BSR set to: 0

		movlw	low(_anaT1)
	movwf	((extraerValue@orig))&0ffh
	movlw	high(_anaT1)
	movwf	((extraerValue@orig+1))&0ffh

		movlw	low(STR_29)
	movwf	((extraerValue@init))&0ffh
	movlw	high(STR_29)
	movwf	((extraerValue@init+1))&0ffh

		movlw	low(STR_30)
	movwf	((extraerValue@end))&0ffh
	movlw	high(STR_30)
	movwf	((extraerValue@end+1))&0ffh

	call	_extraerValue	;wreg free
	movlb	1	; () banked
	movwf	(0+(_anaT1+02Bh))&0ffh
	line	186
	
l17885:; BSR set to: 1

		movlw	low(_anaT1)
	movlb	0	; () banked
	movwf	((strstr@h))&0ffh
	movlw	high(_anaT1)
	movwf	((strstr@h+1))&0ffh

		movlw	low(STR_32)
	movwf	((strstr@n))&0ffh
	movlw	high(STR_32)
	movwf	((strstr@n+1))&0ffh

	call	_strstr	;wreg free
	movf	(0+?_strstr)&0ffh,w
iorwf	(1+?_strstr)&0ffh,w
	btfsc	status,2
	goto	u22341
	goto	u22340

u22341:
	goto	l17823
u22340:
	line	189
	
l17887:; BSR set to: 0

		movlw	low(_anaT1)
	movwf	((extraerValue@orig))&0ffh
	movlw	high(_anaT1)
	movwf	((extraerValue@orig+1))&0ffh

		movlw	low(STR_33)
	movwf	((extraerValue@init))&0ffh
	movlw	high(STR_33)
	movwf	((extraerValue@init+1))&0ffh

		movlw	low(STR_34)
	movwf	((extraerValue@end))&0ffh
	movlw	high(STR_34)
	movwf	((extraerValue@end+1))&0ffh

	call	_extraerValue	;wreg free
	movlb	1	; () banked
	movwf	(0+(_anaT1+02Ch))&0ffh
	line	192
	
l17889:; BSR set to: 1

	movf	(0+(_anaT1+02Ch))&0ffh,w
	btfss	status,2
	goto	u22351
	goto	u22350
u22351:
	goto	l17893
u22350:
	line	194
	
l17891:; BSR set to: 1

	movlw	low(04h)
	movlb	0	; () banked
	movwf	((_stateAnaTrama1))&0ffh
	line	195
	goto	l17809
	line	199
	
l17893:; BSR set to: 1

		movlw	low(_anaT1)
	movlb	0	; () banked
	movwf	((extraerFrame@orig))&0ffh
	movlw	high(_anaT1)
	movwf	((extraerFrame@orig+1))&0ffh

		movlw	low(_anaT1+02Dh)
	movwf	((extraerFrame@dest))&0ffh
	movlw	high(_anaT1+02Dh)
	movwf	((extraerFrame@dest+1))&0ffh

		movlw	low(STR_35)
	movwf	((extraerFrame@init))&0ffh
	movlw	high(STR_35)
	movwf	((extraerFrame@init+1))&0ffh

		movlw	low(STR_36)
	movwf	((extraerFrame@end))&0ffh
	movlw	high(STR_36)
	movwf	((extraerFrame@end+1))&0ffh

	call	_extraerFrame	;wreg free
	line	200
	
l17895:; BSR set to: 0

		movlw	low(_anaT1+02Dh)
	movwf	((extraerHora@orig))&0ffh
	movlw	high(_anaT1+02Dh)
	movwf	((extraerHora@orig+1))&0ffh

		movlw	low(_anaT1+03Dh)
	movwf	((extraerHora@hor))&0ffh
	movlw	high(_anaT1+03Dh)
	movwf	((extraerHora@hor+1))&0ffh

		movlw	low(_anaT1+03Eh)
	movwf	((extraerHora@min))&0ffh
	movlw	high(_anaT1+03Eh)
	movwf	((extraerHora@min+1))&0ffh

	call	_extraerHora	;wreg free
	line	202
	
l17897:; BSR set to: 0

		movlw	low(_anaT1)
	movwf	((extraerFrame@orig))&0ffh
	movlw	high(_anaT1)
	movwf	((extraerFrame@orig+1))&0ffh

		movlw	low(_anaT1+02Dh)
	movwf	((extraerFrame@dest))&0ffh
	movlw	high(_anaT1+02Dh)
	movwf	((extraerFrame@dest+1))&0ffh

		movlw	low(STR_37)
	movwf	((extraerFrame@init))&0ffh
	movlw	high(STR_37)
	movwf	((extraerFrame@init+1))&0ffh

		movlw	low(STR_38)
	movwf	((extraerFrame@end))&0ffh
	movlw	high(STR_38)
	movwf	((extraerFrame@end+1))&0ffh

	call	_extraerFrame	;wreg free
	line	203
		movlw	low(_anaT1+02Dh)
	movwf	((extraerHora@orig))&0ffh
	movlw	high(_anaT1+02Dh)
	movwf	((extraerHora@orig+1))&0ffh

		movlw	low(_anaT1+03Fh)
	movwf	((extraerHora@hor))&0ffh
	movlw	high(_anaT1+03Fh)
	movwf	((extraerHora@hor+1))&0ffh

		movlw	low(_anaT1+040h)
	movwf	((extraerHora@min))&0ffh
	movlw	high(_anaT1+040h)
	movwf	((extraerHora@min+1))&0ffh

	call	_extraerHora	;wreg free
	line	205
	
l17899:; BSR set to: 0

		movlw	low(_anaT1)
	movwf	((extraerFrame@orig))&0ffh
	movlw	high(_anaT1)
	movwf	((extraerFrame@orig+1))&0ffh

		movlw	low(_anaT1+02Dh)
	movwf	((extraerFrame@dest))&0ffh
	movlw	high(_anaT1+02Dh)
	movwf	((extraerFrame@dest+1))&0ffh

		movlw	low(STR_39)
	movwf	((extraerFrame@init))&0ffh
	movlw	high(STR_39)
	movwf	((extraerFrame@init+1))&0ffh

		movlw	low(STR_40)
	movwf	((extraerFrame@end))&0ffh
	movlw	high(STR_40)
	movwf	((extraerFrame@end+1))&0ffh

	call	_extraerFrame	;wreg free
	line	207
	
l17901:; BSR set to: 0

		movlw	low(_anaT1+02Dh)
	movwf	((atoi@s))&0ffh
	movlw	high(_anaT1+02Dh)
	movwf	((atoi@s+1))&0ffh

	call	_atoi	;wreg free
	movff	0+?_atoi,0+(_anaT1+041h)
	movff	1+?_atoi,1+(_anaT1+041h)
	movlb	1	; () banked
	movlw	0
	btfsc	(1+(_anaT1+041h))&0ffh,7
	movlw	-1
	movwf	(2+(_anaT1+041h))&0ffh
	movwf	(3+(_anaT1+041h))&0ffh
	goto	l17891
	line	226
	
l17909:; BSR set to: 0

	movlb	1	; () banked
	movf	(0+(_anaT1+02Ch))&0ffh,w
	btfss	status,2
	goto	u22361
	goto	u22360
u22361:
	goto	l17941
u22360:
	line	228
	
l17911:; BSR set to: 1

		decf	(0+(_anaT1+02Bh))&0ffh,w
	btfss	status,2
	goto	u22371
	goto	u22370

u22371:
	goto	l17917
u22370:
	line	230
	
l17913:; BSR set to: 1

	bcf	((_ala1))&0ffh,0
	line	231
	
l17915:; BSR set to: 1

	movlw	high(01h)
	movlb	0	; () banked
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(01h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	232
	goto	l880
	line	233
	
l17917:; BSR set to: 1

		movlw	2
	xorwf	(0+(_anaT1+02Bh))&0ffh,w
	btfss	status,2
	goto	u22381
	goto	u22380

u22381:
	goto	l17923
u22380:
	line	235
	
l17919:; BSR set to: 1

	bcf	((_ala2))&0ffh,0
	line	236
	
l17921:; BSR set to: 1

	movlw	high(08h)
	movlb	0	; () banked
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(08h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	237
	goto	l880
	line	238
	
l17923:; BSR set to: 1

		movlw	3
	xorwf	(0+(_anaT1+02Bh))&0ffh,w
	btfss	status,2
	goto	u22391
	goto	u22390

u22391:
	goto	l17929
u22390:
	line	240
	
l17925:; BSR set to: 1

	bcf	((_ala3))&0ffh,0
	line	241
	
l17927:; BSR set to: 1

	movlw	high(0Fh)
	movlb	0	; () banked
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(0Fh)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	242
	goto	l880
	line	243
	
l17929:; BSR set to: 1

		movlw	4
	xorwf	(0+(_anaT1+02Bh))&0ffh,w
	btfss	status,2
	goto	u22401
	goto	u22400

u22401:
	goto	l17935
u22400:
	line	245
	
l17931:; BSR set to: 1

	bcf	((_ala4))&0ffh,0
	line	246
	
l17933:; BSR set to: 1

	movlw	high(016h)
	movlb	0	; () banked
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(016h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	247
	goto	l880
	line	248
	
l17935:; BSR set to: 1

		movlw	5
	xorwf	(0+(_anaT1+02Bh))&0ffh,w
	btfss	status,2
	goto	u22411
	goto	u22410

u22411:
	goto	l874
u22410:
	line	250
	
l17937:; BSR set to: 1

	bcf	((_ala5))&0ffh,0
	line	251
	
l17939:; BSR set to: 1

	movlw	high(01Dh)
	movlb	0	; () banked
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(01Dh)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	goto	l880
	line	252
	
l874:; BSR set to: 1

	goto	l880
	line	262
	
l17941:; BSR set to: 1

		decf	(0+(_anaT1+02Bh))&0ffh,w
	btfss	status,2
	goto	u22421
	goto	u22420

u22421:
	goto	l17977
u22420:
	line	264
	
l17943:; BSR set to: 1

	bsf	((_ala1))&0ffh,0
	line	265
	movff	0+(_anaT1+03Dh),0+(_ala1+0Ah)
	line	266
	movff	0+(_anaT1+03Eh),0+(_ala1+0Bh)
	line	268
	movff	0+(_anaT1+03Fh),0+(_ala1+0Ch)
	line	269
	movff	0+(_anaT1+040h),0+(_ala1+0Dh)
	line	274
	
l17945:; BSR set to: 1

		movf	(3+(_anaT1+041h))&0ffh,w
	iorwf	(2+(_anaT1+041h))&0ffh,w
	iorwf	(1+(_anaT1+041h))&0ffh,w
	bnz	u22430
	movlw	8
	subwf	 (0+(_anaT1+041h))&0ffh,w
	btfss	status,0
	goto	u22431
	goto	u22430

u22431:
	goto	l880
u22430:
	
l17947:; BSR set to: 1

		movf	(3+(_anaT1+041h))&0ffh,w
	iorwf	(2+(_anaT1+041h))&0ffh,w
	iorwf	(1+(_anaT1+041h))&0ffh,w
	bnz	u22441
	movlw	11
	subwf	 (0+(_anaT1+041h))&0ffh,w
	btfsc	status,0
	goto	u22441
	goto	u22440

u22441:
	goto	l880
u22440:
	line	276
	
l17949:; BSR set to: 1

	bcf	((_ala1))&0ffh,1
	line	277
	
l17951:; BSR set to: 1

		movlw	8
	xorwf	(0+(_anaT1+041h))&0ffh,w
iorwf	(1+(_anaT1+041h))&0ffh,w
iorwf	(2+(_anaT1+041h))&0ffh,w
iorwf	(3+(_anaT1+041h))&0ffh,w
	btfss	status,2
	goto	u22451
	goto	u22450

u22451:
	goto	l17955
u22450:
	
l17953:; BSR set to: 1

	movlw	low(08h)
	movwf	(0+(_ala1+01h))&0ffh
	line	278
	
l17955:; BSR set to: 1

		movlw	9
	xorwf	(0+(_anaT1+041h))&0ffh,w
iorwf	(1+(_anaT1+041h))&0ffh,w
iorwf	(2+(_anaT1+041h))&0ffh,w
iorwf	(3+(_anaT1+041h))&0ffh,w
	btfss	status,2
	goto	u22461
	goto	u22460

u22461:
	goto	l17959
u22460:
	
l17957:; BSR set to: 1

	movlw	low(09h)
	movwf	(0+(_ala1+01h))&0ffh
	line	279
	
l17959:; BSR set to: 1

		movlw	10
	xorwf	(0+(_anaT1+041h))&0ffh,w
iorwf	(1+(_anaT1+041h))&0ffh,w
iorwf	(2+(_anaT1+041h))&0ffh,w
iorwf	(3+(_anaT1+041h))&0ffh,w
	btfss	status,2
	goto	u22471
	goto	u22470

u22471:
	goto	l17963
u22470:
	
l17961:; BSR set to: 1

	movlw	low(0Ah)
	movwf	(0+(_ala1+01h))&0ffh
	line	281
	
l17963:; BSR set to: 1

	movlw	high(01h)
	movlb	0	; () banked
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(01h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(01h)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	282
	
l17965:; BSR set to: 0

	movlw	high(02h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(02h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	283
	
l17967:; BSR set to: 0

	movlw	high(03h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(03h)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+041h),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	284
	
l17969:; BSR set to: 0

	movlw	high(04h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(04h)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+03Dh),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	285
	
l17971:; BSR set to: 0

	movlw	high(05h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(05h)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+03Eh),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	286
	
l17973:; BSR set to: 0

	movlw	high(06h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(06h)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+03Fh),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	287
	
l17975:; BSR set to: 0

	movlw	high(07h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(07h)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+040h),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	288
	goto	l880
	line	295
	
l17977:; BSR set to: 1

		movlw	2
	xorwf	(0+(_anaT1+02Bh))&0ffh,w
	btfss	status,2
	goto	u22481
	goto	u22480

u22481:
	goto	l18013
u22480:
	line	298
	
l17979:; BSR set to: 1

	bsf	((_ala2))&0ffh,0
	line	299
	movff	0+(_anaT1+03Dh),0+(_ala2+0Ah)
	line	300
	movff	0+(_anaT1+03Eh),0+(_ala2+0Bh)
	line	302
	movff	0+(_anaT1+03Fh),0+(_ala2+0Ch)
	line	303
	movff	0+(_anaT1+040h),0+(_ala2+0Dh)
	line	305
	
l17981:; BSR set to: 1

		movf	(3+(_anaT1+041h))&0ffh,w
	iorwf	(2+(_anaT1+041h))&0ffh,w
	iorwf	(1+(_anaT1+041h))&0ffh,w
	bnz	u22490
	movlw	8
	subwf	 (0+(_anaT1+041h))&0ffh,w
	btfss	status,0
	goto	u22491
	goto	u22490

u22491:
	goto	l880
u22490:
	
l17983:; BSR set to: 1

		movf	(3+(_anaT1+041h))&0ffh,w
	iorwf	(2+(_anaT1+041h))&0ffh,w
	iorwf	(1+(_anaT1+041h))&0ffh,w
	bnz	u22501
	movlw	11
	subwf	 (0+(_anaT1+041h))&0ffh,w
	btfsc	status,0
	goto	u22501
	goto	u22500

u22501:
	goto	l880
u22500:
	line	307
	
l17985:; BSR set to: 1

	bcf	((_ala2))&0ffh,1
	line	308
	
l17987:; BSR set to: 1

		movlw	8
	xorwf	(0+(_anaT1+041h))&0ffh,w
iorwf	(1+(_anaT1+041h))&0ffh,w
iorwf	(2+(_anaT1+041h))&0ffh,w
iorwf	(3+(_anaT1+041h))&0ffh,w
	btfss	status,2
	goto	u22511
	goto	u22510

u22511:
	goto	l17991
u22510:
	
l17989:; BSR set to: 1

	movlw	low(08h)
	movwf	(0+(_ala2+01h))&0ffh
	line	309
	
l17991:; BSR set to: 1

		movlw	9
	xorwf	(0+(_anaT1+041h))&0ffh,w
iorwf	(1+(_anaT1+041h))&0ffh,w
iorwf	(2+(_anaT1+041h))&0ffh,w
iorwf	(3+(_anaT1+041h))&0ffh,w
	btfss	status,2
	goto	u22521
	goto	u22520

u22521:
	goto	l17995
u22520:
	
l17993:; BSR set to: 1

	movlw	low(09h)
	movwf	(0+(_ala2+01h))&0ffh
	line	310
	
l17995:; BSR set to: 1

		movlw	10
	xorwf	(0+(_anaT1+041h))&0ffh,w
iorwf	(1+(_anaT1+041h))&0ffh,w
iorwf	(2+(_anaT1+041h))&0ffh,w
iorwf	(3+(_anaT1+041h))&0ffh,w
	btfss	status,2
	goto	u22531
	goto	u22530

u22531:
	goto	l17999
u22530:
	
l17997:; BSR set to: 1

	movlw	low(0Ah)
	movwf	(0+(_ala2+01h))&0ffh
	line	312
	
l17999:; BSR set to: 1

	movlw	high(08h)
	movlb	0	; () banked
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(08h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(01h)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	313
	
l18001:; BSR set to: 0

	movlw	high(09h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(09h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	314
	
l18003:; BSR set to: 0

	movlw	high(0Ah)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(0Ah)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+041h),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	315
	
l18005:; BSR set to: 0

	movlw	high(0Bh)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(0Bh)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+03Dh),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	316
	
l18007:; BSR set to: 0

	movlw	high(0Ch)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(0Ch)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+03Eh),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	317
	
l18009:; BSR set to: 0

	movlw	high(0Dh)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(0Dh)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+03Fh),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	318
	
l18011:; BSR set to: 0

	movlw	high(0Eh)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(0Eh)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+040h),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	319
	goto	l880
	line	326
	
l18013:; BSR set to: 1

		movlw	3
	xorwf	(0+(_anaT1+02Bh))&0ffh,w
	btfss	status,2
	goto	u22541
	goto	u22540

u22541:
	goto	l18049
u22540:
	line	328
	
l18015:; BSR set to: 1

	bsf	((_ala3))&0ffh,0
	line	329
	movff	0+(_anaT1+03Dh),0+(_ala3+0Ah)
	line	330
	movff	0+(_anaT1+03Eh),0+(_ala3+0Bh)
	line	332
	movff	0+(_anaT1+03Fh),0+(_ala3+0Ch)
	line	333
	movff	0+(_anaT1+040h),0+(_ala3+0Dh)
	line	335
	
l18017:; BSR set to: 1

		movf	(3+(_anaT1+041h))&0ffh,w
	iorwf	(2+(_anaT1+041h))&0ffh,w
	iorwf	(1+(_anaT1+041h))&0ffh,w
	bnz	u22550
	movlw	8
	subwf	 (0+(_anaT1+041h))&0ffh,w
	btfss	status,0
	goto	u22551
	goto	u22550

u22551:
	goto	l880
u22550:
	
l18019:; BSR set to: 1

		movf	(3+(_anaT1+041h))&0ffh,w
	iorwf	(2+(_anaT1+041h))&0ffh,w
	iorwf	(1+(_anaT1+041h))&0ffh,w
	bnz	u22561
	movlw	11
	subwf	 (0+(_anaT1+041h))&0ffh,w
	btfsc	status,0
	goto	u22561
	goto	u22560

u22561:
	goto	l880
u22560:
	line	337
	
l18021:; BSR set to: 1

	bcf	((_ala3))&0ffh,1
	line	338
	
l18023:; BSR set to: 1

		movlw	8
	xorwf	(0+(_anaT1+041h))&0ffh,w
iorwf	(1+(_anaT1+041h))&0ffh,w
iorwf	(2+(_anaT1+041h))&0ffh,w
iorwf	(3+(_anaT1+041h))&0ffh,w
	btfss	status,2
	goto	u22571
	goto	u22570

u22571:
	goto	l18027
u22570:
	
l18025:; BSR set to: 1

	movlw	low(08h)
	movwf	(0+(_ala3+01h))&0ffh
	line	339
	
l18027:; BSR set to: 1

		movlw	9
	xorwf	(0+(_anaT1+041h))&0ffh,w
iorwf	(1+(_anaT1+041h))&0ffh,w
iorwf	(2+(_anaT1+041h))&0ffh,w
iorwf	(3+(_anaT1+041h))&0ffh,w
	btfss	status,2
	goto	u22581
	goto	u22580

u22581:
	goto	l18031
u22580:
	
l18029:; BSR set to: 1

	movlw	low(09h)
	movwf	(0+(_ala3+01h))&0ffh
	line	340
	
l18031:; BSR set to: 1

		movlw	10
	xorwf	(0+(_anaT1+041h))&0ffh,w
iorwf	(1+(_anaT1+041h))&0ffh,w
iorwf	(2+(_anaT1+041h))&0ffh,w
iorwf	(3+(_anaT1+041h))&0ffh,w
	btfss	status,2
	goto	u22591
	goto	u22590

u22591:
	goto	l18035
u22590:
	
l18033:; BSR set to: 1

	movlw	low(0Ah)
	movwf	(0+(_ala3+01h))&0ffh
	line	342
	
l18035:; BSR set to: 1

	movlw	high(0Fh)
	movlb	0	; () banked
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(0Fh)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(01h)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	343
	
l18037:; BSR set to: 0

	movlw	high(010h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(010h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	344
	
l18039:; BSR set to: 0

	movlw	high(011h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(011h)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+041h),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	345
	
l18041:; BSR set to: 0

	movlw	high(012h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(012h)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+03Dh),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	346
	
l18043:; BSR set to: 0

	movlw	high(013h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(013h)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+03Eh),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	347
	
l18045:; BSR set to: 0

	movlw	high(014h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(014h)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+03Fh),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	348
	
l18047:; BSR set to: 0

	movlw	high(015h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(015h)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+040h),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	349
	goto	l880
	line	356
	
l18049:; BSR set to: 1

		movlw	4
	xorwf	(0+(_anaT1+02Bh))&0ffh,w
	btfss	status,2
	goto	u22601
	goto	u22600

u22601:
	goto	l18085
u22600:
	line	358
	
l18051:; BSR set to: 1

	bsf	((_ala4))&0ffh,0
	line	359
	movff	0+(_anaT1+03Dh),0+(_ala4+0Ah)
	line	360
	movff	0+(_anaT1+03Eh),0+(_ala4+0Bh)
	line	362
	movff	0+(_anaT1+03Fh),0+(_ala4+0Ch)
	line	363
	movff	0+(_anaT1+040h),0+(_ala4+0Dh)
	line	365
	
l18053:; BSR set to: 1

		movf	(3+(_anaT1+041h))&0ffh,w
	iorwf	(2+(_anaT1+041h))&0ffh,w
	iorwf	(1+(_anaT1+041h))&0ffh,w
	bnz	u22610
	movlw	8
	subwf	 (0+(_anaT1+041h))&0ffh,w
	btfss	status,0
	goto	u22611
	goto	u22610

u22611:
	goto	l880
u22610:
	
l18055:; BSR set to: 1

		movf	(3+(_anaT1+041h))&0ffh,w
	iorwf	(2+(_anaT1+041h))&0ffh,w
	iorwf	(1+(_anaT1+041h))&0ffh,w
	bnz	u22621
	movlw	11
	subwf	 (0+(_anaT1+041h))&0ffh,w
	btfsc	status,0
	goto	u22621
	goto	u22620

u22621:
	goto	l880
u22620:
	line	367
	
l18057:; BSR set to: 1

	bcf	((_ala4))&0ffh,1
	line	368
	
l18059:; BSR set to: 1

		movlw	8
	xorwf	(0+(_anaT1+041h))&0ffh,w
iorwf	(1+(_anaT1+041h))&0ffh,w
iorwf	(2+(_anaT1+041h))&0ffh,w
iorwf	(3+(_anaT1+041h))&0ffh,w
	btfss	status,2
	goto	u22631
	goto	u22630

u22631:
	goto	l18063
u22630:
	
l18061:; BSR set to: 1

	movlw	low(08h)
	movwf	(0+(_ala4+01h))&0ffh
	line	369
	
l18063:; BSR set to: 1

		movlw	9
	xorwf	(0+(_anaT1+041h))&0ffh,w
iorwf	(1+(_anaT1+041h))&0ffh,w
iorwf	(2+(_anaT1+041h))&0ffh,w
iorwf	(3+(_anaT1+041h))&0ffh,w
	btfss	status,2
	goto	u22641
	goto	u22640

u22641:
	goto	l18067
u22640:
	
l18065:; BSR set to: 1

	movlw	low(09h)
	movwf	(0+(_ala4+01h))&0ffh
	line	370
	
l18067:; BSR set to: 1

		movlw	10
	xorwf	(0+(_anaT1+041h))&0ffh,w
iorwf	(1+(_anaT1+041h))&0ffh,w
iorwf	(2+(_anaT1+041h))&0ffh,w
iorwf	(3+(_anaT1+041h))&0ffh,w
	btfss	status,2
	goto	u22651
	goto	u22650

u22651:
	goto	l18071
u22650:
	
l18069:; BSR set to: 1

	movlw	low(0Ah)
	movwf	(0+(_ala4+01h))&0ffh
	line	372
	
l18071:; BSR set to: 1

	movlw	high(016h)
	movlb	0	; () banked
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(016h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(01h)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	373
	
l18073:; BSR set to: 0

	movlw	high(017h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(017h)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	374
	
l18075:; BSR set to: 0

	movlw	high(018h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(018h)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+041h),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	375
	
l18077:; BSR set to: 0

	movlw	high(019h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(019h)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+03Dh),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	376
	
l18079:; BSR set to: 0

	movlw	high(01Ah)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(01Ah)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+03Eh),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	377
	
l18081:; BSR set to: 0

	movlw	high(01Bh)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(01Bh)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+03Fh),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	378
	
l18083:; BSR set to: 0

	movlw	high(01Ch)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(01Ch)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+040h),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	379
	goto	l880
	line	385
	
l18085:; BSR set to: 1

		movlw	5
	xorwf	(0+(_anaT1+02Bh))&0ffh,w
	btfss	status,2
	goto	u22661
	goto	u22660

u22661:
	goto	l880
u22660:
	line	387
	
l18087:; BSR set to: 1

	bsf	((_ala5))&0ffh,0
	line	388
	movff	0+(_anaT1+03Dh),0+(_ala5+0Ah)
	line	389
	movff	0+(_anaT1+03Eh),0+(_ala5+0Bh)
	line	391
	movff	0+(_anaT1+03Fh),0+(_ala5+0Ch)
	line	392
	movff	0+(_anaT1+040h),0+(_ala5+0Dh)
	line	394
	
l18089:; BSR set to: 1

		movf	(3+(_anaT1+041h))&0ffh,w
	iorwf	(2+(_anaT1+041h))&0ffh,w
	iorwf	(1+(_anaT1+041h))&0ffh,w
	bnz	u22670
	movlw	8
	subwf	 (0+(_anaT1+041h))&0ffh,w
	btfss	status,0
	goto	u22671
	goto	u22670

u22671:
	goto	l880
u22670:
	
l18091:; BSR set to: 1

		movf	(3+(_anaT1+041h))&0ffh,w
	iorwf	(2+(_anaT1+041h))&0ffh,w
	iorwf	(1+(_anaT1+041h))&0ffh,w
	bnz	u22681
	movlw	11
	subwf	 (0+(_anaT1+041h))&0ffh,w
	btfsc	status,0
	goto	u22681
	goto	u22680

u22681:
	goto	l880
u22680:
	line	396
	
l18093:; BSR set to: 1

	bcf	((_ala5))&0ffh,1
	line	397
	
l18095:; BSR set to: 1

		movlw	8
	xorwf	(0+(_anaT1+041h))&0ffh,w
iorwf	(1+(_anaT1+041h))&0ffh,w
iorwf	(2+(_anaT1+041h))&0ffh,w
iorwf	(3+(_anaT1+041h))&0ffh,w
	btfss	status,2
	goto	u22691
	goto	u22690

u22691:
	goto	l18099
u22690:
	
l18097:; BSR set to: 1

	movlw	low(08h)
	movwf	(0+(_ala5+01h))&0ffh
	line	398
	
l18099:; BSR set to: 1

		movlw	9
	xorwf	(0+(_anaT1+041h))&0ffh,w
iorwf	(1+(_anaT1+041h))&0ffh,w
iorwf	(2+(_anaT1+041h))&0ffh,w
iorwf	(3+(_anaT1+041h))&0ffh,w
	btfss	status,2
	goto	u22701
	goto	u22700

u22701:
	goto	l18103
u22700:
	
l18101:; BSR set to: 1

	movlw	low(09h)
	movwf	(0+(_ala5+01h))&0ffh
	line	399
	
l18103:; BSR set to: 1

		movlw	10
	xorwf	(0+(_anaT1+041h))&0ffh,w
iorwf	(1+(_anaT1+041h))&0ffh,w
iorwf	(2+(_anaT1+041h))&0ffh,w
iorwf	(3+(_anaT1+041h))&0ffh,w
	btfss	status,2
	goto	u22711
	goto	u22710

u22711:
	goto	l18107
u22710:
	
l18105:; BSR set to: 1

	movlw	low(0Ah)
	movwf	(0+(_ala5+01h))&0ffh
	line	401
	
l18107:; BSR set to: 1

	movlw	high(01Dh)
	movlb	0	; () banked
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(01Dh)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(01h)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	402
	
l18109:; BSR set to: 0

	movlw	high(01Eh)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(01Eh)
	movwf	((EEpromWrite@address))&0ffh
	movlw	low(0)
	movwf	((EEpromWrite@data))&0ffh
	call	_EEpromWrite	;wreg free
	line	403
	
l18111:; BSR set to: 0

	movlw	high(01Fh)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(01Fh)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+041h),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	404
	
l18113:; BSR set to: 0

	movlw	high(020h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(020h)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+03Dh),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	405
	
l18115:; BSR set to: 0

	movlw	high(021h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(021h)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+03Eh),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	406
	
l18117:; BSR set to: 0

	movlw	high(022h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(022h)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+03Fh),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	407
	
l18119:; BSR set to: 0

	movlw	high(023h)
	movwf	((EEpromWrite@address+1))&0ffh
	movlw	low(023h)
	movwf	((EEpromWrite@address))&0ffh
	movff	0+(_anaT1+040h),(EEpromWrite@data)
	call	_EEpromWrite	;wreg free
	line	416
	
l880:
	line	417
	movlb	2	; () banked
	bsf	(0+(_serial1+02Ah))&0ffh,2
	goto	l17823
	line	424
	
l18125:; BSR set to: 0

	movf	((_stateAnaTrama1))&0ffh,w
	movwf	(??_taskAnalizaUart1+0+0)&0ffh
	clrf	(??_taskAnalizaUart1+0+0+1)&0ffh

	; Switch on 2 bytes has been partitioned into a top level switch of size 1, and 1 sub-switches
; Switch size 1, requested type "simple"
; Number of cases is 1, Range of values is 0 to 0
; switch strategies available:
; Name         Instructions Cycles
; simple_byte            4     3 (average)
;	Chosen strategy is simple_byte

	movf ??_taskAnalizaUart1+0+1&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l18603
	goto	l17809
	
l18603:; BSR set to: 0

; Switch size 1, requested type "simple"
; Number of cases is 5, Range of values is 0 to 4
; switch strategies available:
; Name         Instructions Cycles
; simple_byte           16     9 (average)
;	Chosen strategy is simple_byte

	movf ??_taskAnalizaUart1+0+0&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l846
	xorlw	1^0	; case 1
	skipnz
	goto	l849
	xorlw	2^1	; case 2
	skipnz
	goto	l17855
	xorlw	3^2	; case 3
	skipnz
	goto	l17861
	xorlw	4^3	; case 4
	skipnz
	goto	l17909
	goto	l17809

	line	426
	
l18127:; BSR set to: 0

	movff	(taskAnalizaUart1@pt),fsr2l
	movff	(taskAnalizaUart1@pt+1),fsr2h
	movff	postinc2,??_taskAnalizaUart1+0+0
	movff	postdec2,??_taskAnalizaUart1+0+0+1
	; Switch on 2 bytes has been partitioned into a top level switch of size 1, and 1 sub-switches
; Switch size 1, requested type "simple"
; Number of cases is 1, Range of values is 0 to 0
; switch strategies available:
; Name         Instructions Cycles
; simple_byte            4     3 (average)
;	Chosen strategy is simple_byte

	movf ??_taskAnalizaUart1+0+1&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l18605
	goto	l18129
	
l18605:; BSR set to: 0

; Switch size 1, requested type "simple"
; Number of cases is 2, Range of values is 0 to 98
; switch strategies available:
; Name         Instructions Cycles
; simple_byte            7     4 (average)
;	Chosen strategy is simple_byte

	movf ??_taskAnalizaUart1+0+0&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l17809
	xorlw	98^0	; case 98
	skipnz
	goto	l17813
	goto	l18129

	
l18129:; BSR set to: 0

	
l18131:; BSR set to: 0

	movff	(taskAnalizaUart1@pt),fsr2l
	movff	(taskAnalizaUart1@pt+1),fsr2h
	movlw	low(0)
	movwf	postinc2,c
	movlw	high(0)
	movwf	postdec2,c
	line	427
	
l843:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_taskAnalizaUart1
	__end_of_taskAnalizaUart1:
	signat	_taskAnalizaUart1,4218
	global	_extraerValue

;; *************** function _extraerValue *****************
;; Defined at:
;;		line 453 in file "Serial.c"
;; Parameters:    Size  Location     Type
;;  orig            2   54[BANK0 ] PTR unsigned char 
;;		 -> anaT1(69), 
;;  init            2   56[BANK0 ] PTR unsigned char 
;;		 -> STR_33(2), STR_29(2), 
;;  end             2   58[BANK0 ] PTR unsigned char 
;;		 -> STR_34(2), STR_30(2), 
;; Auto vars:     Size  Location     Type
;;  buffer          4   63[BANK0 ] unsigned char [4]
;;  ptrData         2   67[BANK0 ] PTR unsigned char 
;;		 -> NULL(0), anaT1.bufferRx(40), anaT1(69), 
;;  cnt             1   62[BANK0 ] unsigned char 
;;  value           1   61[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      unsigned char 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       6       0       0       0       0       0       0       0
;;      Locals:         0       8       0       0       0       0       0       0       0
;;      Temps:          0       1       0       0       0       0       0       0       0
;;      Totals:         0      15       0       0       0       0       0       0       0
;;Total ram usage:       15 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 14
;; This function calls:
;;		_atoi
;;		_memset
;;		_strstr
;; This function is called by:
;;		_taskAnalizaUart1
;; This function uses a non-reentrant model
;;
psect	text46,class=CODE,space=0,reloc=2,group=0
	line	453
global __ptext46
__ptext46:
psect	text46
	file	"Serial.c"
	line	453
	
_extraerValue:; BSR set to: 0

;incstack = 0
	callstack 14
	line	455
	
l17407:; BSR set to: 0

	line	458
	movlw	low(0)
	movwf	((extraerValue@cnt))&0ffh
	line	460
	
l17409:; BSR set to: 0

		movlw	low(extraerValue@buffer)
	movwf	((memset@dest))&0ffh
	clrf	((memset@dest+1))&0ffh

	movlw	high(0)
	movwf	((memset@c+1))&0ffh
	movlw	low(0)
	movwf	((memset@c))&0ffh
	movlw	high(04h)
	movwf	((memset@n+1))&0ffh
	movlw	low(04h)
	movwf	((memset@n))&0ffh
	call	_memset	;wreg free
	line	462
	
l17411:; BSR set to: 0

		movff	(extraerValue@orig),(strstr@h)
	movff	(extraerValue@orig+1),(strstr@h+1)

		movff	(extraerValue@init),(strstr@n)
	movff	(extraerValue@init+1),(strstr@n+1)

	call	_strstr	;wreg free
	movff	0+?_strstr,(extraerValue@ptrData)
	movff	1+?_strstr,(extraerValue@ptrData+1)
	line	464
	
l17413:; BSR set to: 0

	movlw	low(01h)
	addwf	((extraerValue@ptrData))&0ffh,w
	movwf	((extraerValue@ptrData))&0ffh
	movlw	high(01h)
	addwfc	((extraerValue@ptrData+1))&0ffh,w
	movwf	1+((extraerValue@ptrData))&0ffh
	goto	l17421
	line	466
	
l17415:; BSR set to: 0

	movff	(extraerValue@ptrData),fsr2l
	movff	(extraerValue@ptrData+1),fsr2h
	movf	((extraerValue@cnt))&0ffh,w
	addlw	low(extraerValue@buffer)
	movwf	fsr1l
	clrf	fsr1h
	movff	indf2,indf1
	
l17417:; BSR set to: 0

	incf	((extraerValue@cnt))&0ffh
	line	467
	
l17419:; BSR set to: 0

	infsnz	((extraerValue@ptrData))&0ffh
	incf	((extraerValue@ptrData+1))&0ffh
	
l17421:; BSR set to: 0

	movff	(extraerValue@ptrData),fsr2l
	movff	(extraerValue@ptrData+1),fsr2h
	movf	indf2,w
	movwf	(??_extraerValue+0+0)&0ffh
	movff	(extraerValue@end),tblptrl
	movff	(extraerValue@end+1),tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	xorwf	((??_extraerValue+0+0))&0ffh,w

	btfss	status,2
	goto	u21641
	goto	u21640
u21641:
	goto	l17415
u21640:
	line	469
	
l17423:; BSR set to: 0

		movlw	low(extraerValue@buffer)
	movwf	((atoi@s))&0ffh
	clrf	((atoi@s+1))&0ffh

	call	_atoi	;wreg free
	movf	(0+?_atoi)&0ffh,w
	movwf	((extraerValue@value))&0ffh
	line	471
	
l17425:; BSR set to: 0

	movf	((extraerValue@value))&0ffh,w
	line	472
	
l929:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_extraerValue
	__end_of_extraerValue:
	signat	_extraerValue,12409
	global	_extraerHora

;; *************** function _extraerHora *****************
;; Defined at:
;;		line 495 in file "Serial.c"
;; Parameters:    Size  Location     Type
;;  orig            2   54[BANK0 ] PTR unsigned char 
;;		 -> anaT1(69), 
;;  hor             2   56[BANK0 ] PTR unsigned char 
;;		 -> anaT1(69), 
;;  min             2   58[BANK0 ] PTR unsigned char 
;;		 -> anaT1(69), 
;; Auto vars:     Size  Location     Type
;;  buffer          4   62[BANK0 ] unsigned char [4]
;;  minuto          1   61[BANK0 ] unsigned char 
;;  hora            1   60[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       6       0       0       0       0       0       0       0
;;      Locals:         0       6       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0      12       0       0       0       0       0       0       0
;;Total ram usage:       12 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 14
;; This function calls:
;;		_atoi
;;		_memset
;; This function is called by:
;;		_taskAnalizaUart1
;; This function uses a non-reentrant model
;;
psect	text47,class=CODE,space=0,reloc=2,group=0
	line	495
global __ptext47
__ptext47:
psect	text47
	file	"Serial.c"
	line	495
	
_extraerHora:; BSR set to: 0

;incstack = 0
	callstack 14
	line	498
	
l11577:; BSR set to: 0

	line	499
	movlw	low(0)
	movwf	((extraerHora@minuto))&0ffh
	line	502
	
l11579:; BSR set to: 0

		movlw	low(extraerHora@buffer)
	movwf	((memset@dest))&0ffh
	clrf	((memset@dest+1))&0ffh

	movlw	high(0)
	movwf	((memset@c+1))&0ffh
	movlw	low(0)
	movwf	((memset@c))&0ffh
	movlw	high(04h)
	movwf	((memset@n+1))&0ffh
	movlw	low(04h)
	movwf	((memset@n))&0ffh
	call	_memset	;wreg free
	line	504
	
l11581:; BSR set to: 0

	movff	(extraerHora@orig),fsr2l
	movff	(extraerHora@orig+1),fsr2h
	movf	indf2,w
	movwf	((extraerHora@buffer))&0ffh
	
l11583:; BSR set to: 0

	infsnz	((extraerHora@orig))&0ffh
	incf	((extraerHora@orig+1))&0ffh
	line	505
	
l11585:; BSR set to: 0

	movff	(extraerHora@orig),fsr2l
	movff	(extraerHora@orig+1),fsr2h
	movf	indf2,w
	movwf	(0+(extraerHora@buffer+01h))&0ffh
	
l11587:; BSR set to: 0

	infsnz	((extraerHora@orig))&0ffh
	incf	((extraerHora@orig+1))&0ffh
	line	509
	
l11589:; BSR set to: 0

		movlw	low(extraerHora@buffer)
	movwf	((atoi@s))&0ffh
	clrf	((atoi@s+1))&0ffh

	call	_atoi	;wreg free
	movf	(0+?_atoi)&0ffh,w
	movwf	((extraerHora@hora))&0ffh
	line	511
	
l11591:; BSR set to: 0

	movff	(extraerHora@orig),fsr2l
	movff	(extraerHora@orig+1),fsr2h
	movf	indf2,w
	movwf	((extraerHora@buffer))&0ffh
	
l11593:; BSR set to: 0

	infsnz	((extraerHora@orig))&0ffh
	incf	((extraerHora@orig+1))&0ffh
	line	512
	
l11595:; BSR set to: 0

	movff	(extraerHora@orig),fsr2l
	movff	(extraerHora@orig+1),fsr2h
	movf	indf2,w
	movwf	(0+(extraerHora@buffer+01h))&0ffh
	line	514
	
l11597:; BSR set to: 0

		movlw	low(extraerHora@buffer)
	movwf	((atoi@s))&0ffh
	clrf	((atoi@s+1))&0ffh

	call	_atoi	;wreg free
	movf	(0+?_atoi)&0ffh,w
	movwf	((extraerHora@minuto))&0ffh
	line	516
	
l11599:; BSR set to: 0

	movff	(extraerHora@hor),fsr2l
	movff	(extraerHora@hor+1),fsr2h
	movff	(extraerHora@hora),indf2

	line	517
	
l11601:; BSR set to: 0

	movff	(extraerHora@min),fsr2l
	movff	(extraerHora@min+1),fsr2h
	movff	(extraerHora@minuto),indf2

	line	518
	
l938:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_extraerHora
	__end_of_extraerHora:
	signat	_extraerHora,12409
	global	_extraerFrame

;; *************** function _extraerFrame *****************
;; Defined at:
;;		line 474 in file "Serial.c"
;; Parameters:    Size  Location     Type
;;  orig            2   54[BANK0 ] PTR unsigned char 
;;		 -> anaT1(69), 
;;  dest            2   56[BANK0 ] PTR unsigned char 
;;		 -> anaT1(69), 
;;  init            2   58[BANK0 ] PTR unsigned char 
;;		 -> STR_39(2), STR_37(2), STR_35(2), STR_25(2), 
;;		 -> STR_23(2), 
;;  end             2   60[BANK0 ] PTR unsigned char 
;;		 -> STR_40(2), STR_38(2), STR_36(2), STR_26(2), 
;;		 -> STR_24(2), 
;; Auto vars:     Size  Location     Type
;;  buffer         10   63[BANK0 ] unsigned char [10]
;;  ptrData         2   74[BANK0 ] PTR unsigned char 
;;		 -> NULL(0), anaT1.bufferRx(40), anaT1(69), 
;;  cnt             1   73[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       8       0       0       0       0       0       0       0
;;      Locals:         0      13       0       0       0       0       0       0       0
;;      Temps:          0       1       0       0       0       0       0       0       0
;;      Totals:         0      22       0       0       0       0       0       0       0
;;Total ram usage:       22 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 14
;; This function calls:
;;		_memcpy
;;		_memset
;;		_strlen
;;		_strstr
;; This function is called by:
;;		_taskAnalizaUart1
;; This function uses a non-reentrant model
;;
psect	text48,class=CODE,space=0,reloc=2,group=0
	line	474
global __ptext48
__ptext48:
psect	text48
	file	"Serial.c"
	line	474
	
_extraerFrame:; BSR set to: 0

;incstack = 0
	callstack 14
	line	477
	
l17387:; BSR set to: 0

	movlw	low(0)
	movwf	((extraerFrame@cnt))&0ffh
	line	481
	
l17389:; BSR set to: 0

		movff	(extraerFrame@dest),(memset@dest)
	movff	(extraerFrame@dest+1),(memset@dest+1)

	movlw	high(0)
	movwf	((memset@c+1))&0ffh
	movlw	low(0)
	movwf	((memset@c))&0ffh
		movff	(extraerFrame@dest),(strlen@s)
	movff	(extraerFrame@dest+1),(strlen@s+1)

	call	_strlen	;wreg free
	movff	0+?_strlen,(memset@n)
	movff	1+?_strlen,(memset@n+1)
	call	_memset	;wreg free
	line	482
	
l17391:; BSR set to: 0

		movlw	low(extraerFrame@buffer)
	movwf	((memset@dest))&0ffh
	clrf	((memset@dest+1))&0ffh

	movlw	high(0)
	movwf	((memset@c+1))&0ffh
	movlw	low(0)
	movwf	((memset@c))&0ffh
	movlw	high(0Ah)
	movwf	((memset@n+1))&0ffh
	movlw	low(0Ah)
	movwf	((memset@n))&0ffh
	call	_memset	;wreg free
	line	484
	
l17393:; BSR set to: 0

		movff	(extraerFrame@orig),(strstr@h)
	movff	(extraerFrame@orig+1),(strstr@h+1)

		movff	(extraerFrame@init),(strstr@n)
	movff	(extraerFrame@init+1),(strstr@n+1)

	call	_strstr	;wreg free
	movff	0+?_strstr,(extraerFrame@ptrData)
	movff	1+?_strstr,(extraerFrame@ptrData+1)
	line	486
	
l17395:; BSR set to: 0

	movlw	low(01h)
	addwf	((extraerFrame@ptrData))&0ffh,w
	movwf	((extraerFrame@ptrData))&0ffh
	movlw	high(01h)
	addwfc	((extraerFrame@ptrData+1))&0ffh,w
	movwf	1+((extraerFrame@ptrData))&0ffh
	goto	l17403
	line	488
	
l17397:; BSR set to: 0

	movff	(extraerFrame@ptrData),fsr2l
	movff	(extraerFrame@ptrData+1),fsr2h
	movf	((extraerFrame@cnt))&0ffh,w
	addlw	low(extraerFrame@buffer)
	movwf	fsr1l
	clrf	fsr1h
	movff	indf2,indf1
	
l17399:; BSR set to: 0

	incf	((extraerFrame@cnt))&0ffh
	line	489
	
l17401:; BSR set to: 0

	infsnz	((extraerFrame@ptrData))&0ffh
	incf	((extraerFrame@ptrData+1))&0ffh
	
l17403:; BSR set to: 0

	movff	(extraerFrame@ptrData),fsr2l
	movff	(extraerFrame@ptrData+1),fsr2h
	movf	indf2,w
	movwf	(??_extraerFrame+0+0)&0ffh
	movff	(extraerFrame@end),tblptrl
	movff	(extraerFrame@end+1),tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	xorwf	((??_extraerFrame+0+0))&0ffh,w

	btfss	status,2
	goto	u21631
	goto	u21630
u21631:
	goto	l17397
u21630:
	line	491
	
l17405:; BSR set to: 0

		movff	(extraerFrame@dest),(memcpy@d1)
	movff	(extraerFrame@dest+1),(memcpy@d1+1)

		movlw	low(extraerFrame@buffer)
	movwf	((memcpy@s1))&0ffh
	clrf	((memcpy@s1+1))&0ffh

		movlw	low(extraerFrame@buffer)
	movwf	((strlen@s))&0ffh
	clrf	((strlen@s+1))&0ffh

	call	_strlen	;wreg free
	movff	0+?_strlen,(memcpy@n)
	movff	1+?_strlen,(memcpy@n+1)
	call	_memcpy	;wreg free
	line	493
	
l935:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_extraerFrame
	__end_of_extraerFrame:
	signat	_extraerFrame,16505
	global	_strstr

;; *************** function _strstr *****************
;; Defined at:
;;		line 4 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\strstr.c"
;; Parameters:    Size  Location     Type
;;  h               2   48[BANK0 ] PTR const unsigned char 
;;		 -> NULL(0), anaT1.bufferRx(40), anaT1(69), 
;;  n               2   50[BANK0 ] PTR const unsigned char 
;;		 -> STR_39(2), STR_37(2), STR_35(2), STR_33(2), 
;;		 -> STR_32(2), STR_29(2), STR_28(2), STR_25(2), 
;;		 -> STR_23(2), STR_22(2), STR_20(2), STR_18(2), 
;; Auto vars:     Size  Location     Type
;;  nl              2   52[BANK0 ] unsigned int 
;; Return value:  Size  Location     Type
;;                  2   48[BANK0 ] PTR unsigned char 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       4       0       0       0       0       0       0       0
;;      Locals:         0       2       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       6       0       0       0       0       0       0       0
;;Total ram usage:        6 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 13
;; This function calls:
;;		_strchr
;;		_strlen
;;		_strncmp
;; This function is called by:
;;		_taskAnalizaUart1
;;		_extraerValue
;;		_extraerFrame
;; This function uses a non-reentrant model
;;
psect	text49,class=CODE,space=0,reloc=2,group=3
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\strstr.c"
	line	4
global __ptext49
__ptext49:
psect	text49
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\strstr.c"
	line	4
	
_strstr:; BSR set to: 0

;incstack = 0
	callstack 15
	line	6
	
l17241:; BSR set to: 0

	movf	((strstr@n))&0ffh,w
iorwf	((strstr@n+1))&0ffh,w
	btfsc	status,2
	goto	u21281
	goto	u21280

u21281:
	goto	l17257
u21280:
	line	7
	
l17243:; BSR set to: 0

		movff	(strstr@n),(strlen@s)
	movff	(strstr@n+1),(strlen@s+1)

	call	_strlen	;wreg free
	movff	0+?_strlen,(strstr@nl)
	movff	1+?_strlen,(strstr@nl+1)
	line	8
	goto	l17253
	line	9
	
l17245:; BSR set to: 0

		movff	(strstr@h),(strncmp@_l)
	movff	(strstr@h+1),(strncmp@_l+1)

		movff	(strstr@n),(strncmp@_r)
	movff	(strstr@n+1),(strncmp@_r+1)

	movff	(strstr@nl),(strncmp@n)
	movff	(strstr@nl+1),(strncmp@n+1)
	call	_strncmp	;wreg free
	movf	(0+?_strncmp)&0ffh,w
iorwf	(1+?_strncmp)&0ffh,w
	btfss	status,2
	goto	u21291
	goto	u21290

u21291:
	goto	l17251
u21290:
	line	10
	
l17247:; BSR set to: 0

		movff	(strstr@h),(?_strstr)
	movff	(strstr@h+1),(?_strstr+1)

	goto	l1848
	line	11
	
l17251:; BSR set to: 0

	movlw	low(01h)
	addwf	((strstr@h))&0ffh,w
	movwf	((strchr@s))&0ffh
	movlw	high(01h)
	addwfc	((strstr@h+1))&0ffh,w
	movwf	1+((strchr@s))&0ffh
	movff	(strstr@n),tblptrl
	movff	(strstr@n+1),tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w

	movwf	((strchr@c))&0ffh
	clrf	((strchr@c+1))&0ffh
	call	_strchr	;wreg free
	movff	0+?_strchr,(strstr@h)
	movff	1+?_strchr,(strstr@h+1)
	line	8
	
l17253:; BSR set to: 0

	movf	((strstr@h))&0ffh,w
iorwf	((strstr@h+1))&0ffh,w
	btfsc	status,2
	goto	u21301
	goto	u21300

u21301:
	goto	l17257
u21300:
	
l17255:; BSR set to: 0

	movff	(strstr@h),fsr2l
	movff	(strstr@h+1),fsr2h
	movf	indf2,w
	btfss	status,2
	goto	u21311
	goto	u21310
u21311:
	goto	l17245
u21310:
	line	14
	
l17257:; BSR set to: 0

		movlw	low(0)
	movwf	((?_strstr))&0ffh
	movlw	high(0)
	movwf	((?_strstr+1))&0ffh

	line	15
	
l1848:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_strstr
	__end_of_strstr:
	signat	_strstr,8314
	global	_strncmp

;; *************** function _strncmp *****************
;; Defined at:
;;		line 3 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\strncmp.c"
;; Parameters:    Size  Location     Type
;;  _l              2   37[BANK0 ] PTR const unsigned char 
;;		 -> NULL(0), anaT1.bufferRx(40), STR_16(4), STR_15(3), 
;;		 -> STR_14(3), STR_13(3), STR_12(4), STR_11(38), 
;;		 -> STR_10(36), STR_9(36), STR_8(36), STR_7(36), 
;;		 -> STR_6(43), STR_5(18), STR_4(11), STR_2(24), 
;;		 -> STR_1(27), anaT1(69), 
;;  _r              2   39[BANK0 ] PTR const unsigned char 
;;		 -> STR_43(4), STR_39(2), STR_37(2), STR_35(2), 
;;		 -> STR_33(2), STR_32(2), STR_29(2), STR_28(2), 
;;		 -> STR_25(2), STR_23(2), STR_22(2), STR_20(2), 
;;		 -> STR_18(2), 
;;  n               2   41[BANK0 ] unsigned int 
;; Auto vars:     Size  Location     Type
;;  r               2   46[BANK0 ] PTR const unsigned char 
;;		 -> STR_43(4), STR_39(2), STR_37(2), STR_35(2), 
;;		 -> STR_33(2), STR_32(2), STR_29(2), STR_28(2), 
;;		 -> STR_25(2), STR_23(2), STR_22(2), STR_20(2), 
;;		 -> STR_18(2), 
;;  l               2   44[BANK0 ] PTR const unsigned char 
;;		 -> NULL(0), anaT1.bufferRx(40), STR_16(4), STR_15(3), 
;;		 -> STR_14(3), STR_13(3), STR_12(4), STR_11(38), 
;;		 -> STR_10(36), STR_9(36), STR_8(36), STR_7(36), 
;;		 -> STR_6(43), STR_5(18), STR_4(11), STR_2(24), 
;;		 -> STR_1(27), anaT1(69), 
;; Return value:  Size  Location     Type
;;                  2   37[BANK0 ] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, status,2, status,0, tblptrl, tblptrh, tblptru
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       6       0       0       0       0       0       0       0
;;      Locals:         0       4       0       0       0       0       0       0       0
;;      Temps:          0       1       0       0       0       0       0       0       0
;;      Totals:         0      11       0       0       0       0       0       0       0
;;Total ram usage:       11 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_vfpfcnvrt
;;		_strstr
;; This function uses a non-reentrant model
;;
psect	text50,class=CODE,space=0,reloc=2,group=3
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\strncmp.c"
	line	3
global __ptext50
__ptext50:
psect	text50
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\strncmp.c"
	line	3
	
_strncmp:; BSR set to: 0

;incstack = 0
	callstack 12
	line	5
	
l16963:; BSR set to: 0

		movff	(strncmp@_l),(strncmp@l)
	movff	(strncmp@_l+1),(strncmp@l+1)

		movff	(strncmp@_r),(strncmp@r)
	movff	(strncmp@_r+1),(strncmp@r+1)

	line	6
	decf	((strncmp@n))&0ffh
	btfss	status,0
	decf	((strncmp@n+1))&0ffh
		incf	((strncmp@n))&0ffh,w
	bnz	u20831
	incf	((strncmp@n+1))&0ffh,w
	btfss	status,2
	goto	u20831
	goto	u20830

u20831:
	goto	l16971
u20830:
	
l16965:; BSR set to: 0

	movlw	high(0)
	movwf	((?_strncmp+1))&0ffh
	movlw	low(0)
	movwf	((?_strncmp))&0ffh
	goto	l1830
	line	7
	
l16969:
	movlb	0	; () banked
	infsnz	((strncmp@l))&0ffh
	incf	((strncmp@l+1))&0ffh
	infsnz	((strncmp@r))&0ffh
	incf	((strncmp@r+1))&0ffh
	decf	((strncmp@n))&0ffh
	btfss	status,0
	decf	((strncmp@n+1))&0ffh
	
l16971:; BSR set to: 0

	movff	(strncmp@l),tblptrl
	movff	(strncmp@l+1),tblptrh
	clrf	tblptru
	
	movlw	high __ramtop-1
	cpfsgt	tblptrh
	bra	u20847
	tblrd	*
	
	movf	tablat,w
	bra	u20840
u20847:
	movff	tblptrl,fsr1l
	movff	tblptrh,fsr1h
	movf	indf1,w
u20840:
	iorlw	0
	btfsc	status,2
	goto	u20851
	goto	u20850
u20851:
	goto	l16979
u20850:
	
l16973:
	movff	(strncmp@r),tblptrl
	movff	(strncmp@r+1),tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	iorlw	0
	btfsc	status,2
	goto	u20861
	goto	u20860
u20861:
	goto	l16979
u20860:
	
l16975:
	movlb	0	; () banked
	movf	((strncmp@n))&0ffh,w
iorwf	((strncmp@n+1))&0ffh,w
	btfsc	status,2
	goto	u20871
	goto	u20870

u20871:
	goto	l16979
u20870:
	
l16977:; BSR set to: 0

	movff	(strncmp@r),tblptrl
	movff	(strncmp@r+1),tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movff	tablat,??_strncmp+0+0
	movff	(strncmp@l),tblptrl
	movff	(strncmp@l+1),tblptrh
	clrf	tblptru
	
	movlw	high __ramtop-1
	cpfsgt	tblptrh
	bra	u20887
	tblrd	*
	
	movf	tablat,w
	bra	u20885
u20887:
	movff	tblptrl,fsr1l
	movff	tblptrh,fsr1h
	movf	indf1,w
u20885:
	xorwf	(??_strncmp+0+0)&0ffh,w
	btfsc	status,2
	goto	u20881
	goto	u20880
u20881:
	goto	l16969
u20880:
	line	8
	
l16979:
	movff	(strncmp@l),tblptrl
	movff	(strncmp@l+1),tblptrh
	clrf	tblptru
	
	movlw	high __ramtop-1
	cpfsgt	tblptrh
	bra	u20897
	tblrd	*
	
	movf	tablat,w
	bra	u20890
u20897:
	movff	tblptrl,fsr1l
	movff	tblptrh,fsr1h
	movf	indf1,w
u20890:
	movlb	0	; () banked
	movwf	(??_strncmp+0+0)&0ffh
	movff	(strncmp@r),tblptrl
	movff	(strncmp@r+1),tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w

	subwf	((??_strncmp+0+0))&0ffh,w
	movwf	((?_strncmp))&0ffh
	clrf	1+((?_strncmp))&0ffh
	btfss	status,0
	decf	1+((?_strncmp))&0ffh
	
	line	9
	
l1830:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_strncmp
	__end_of_strncmp:
	signat	_strncmp,12410
	global	_strlen

;; *************** function _strlen *****************
;; Defined at:
;;		line 5 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\strlen.c"
;; Parameters:    Size  Location     Type
;;  s               2   37[BANK0 ] PTR const unsigned char 
;;		 -> ?_printf(2), stoa@nuls(7), dbuf(32), ?_sprintf(2), 
;;		 -> extraerFrame@buffer(10), STR_39(2), STR_37(2), STR_35(2), 
;;		 -> STR_33(2), STR_32(2), STR_29(2), STR_28(2), 
;;		 -> STR_25(2), STR_23(2), STR_22(2), STR_20(2), 
;;		 -> STR_18(2), transmitUart1@bufferTx1(45), readDevide@bufferHorario(5), readDevide@bufferEnable(5), 
;;		 -> STR_3(25), ap(76), anaT1(69), 
;; Auto vars:     Size  Location     Type
;;  a               2   39[BANK0 ] PTR const unsigned char 
;;		 -> ?_printf(2), stoa@nuls(7), dbuf(32), ?_sprintf(2), 
;;		 -> extraerFrame@buffer(10), STR_39(2), STR_37(2), STR_35(2), 
;;		 -> STR_33(2), STR_32(2), STR_29(2), STR_28(2), 
;;		 -> STR_25(2), STR_23(2), STR_22(2), STR_20(2), 
;;		 -> STR_18(2), transmitUart1@bufferTx1(45), readDevide@bufferHorario(5), readDevide@bufferEnable(5), 
;;		 -> STR_3(25), ap(76), anaT1(69), 
;; Return value:  Size  Location     Type
;;                  2   37[BANK0 ] unsigned int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, status,2, status,0, tblptrl, tblptrh, tblptru
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       2       0       0       0       0       0       0       0
;;      Locals:         0       2       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       4       0       0       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_cleanBuffer
;;		_convStringDayWeek
;;		_convOnOff
;;		_transmitUart1
;;		_extraerFrame
;;		_pad
;;		_stoa
;;		_strstr
;; This function uses a non-reentrant model
;;
psect	text51,class=CODE,space=0,reloc=2,group=3
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\strlen.c"
	line	5
global __ptext51
__ptext51:
psect	text51
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\strlen.c"
	line	5
	
_strlen:; BSR set to: 0

;incstack = 0
	callstack 15
	line	7
	
l16733:; BSR set to: 0

		movff	(strlen@s),(strlen@a)
	movff	(strlen@s+1),(strlen@a+1)

	line	8
	goto	l16737
	line	9
	
l16735:
	movlb	0	; () banked
	infsnz	((strlen@s))&0ffh
	incf	((strlen@s+1))&0ffh
	line	8
	
l16737:; BSR set to: 0

	movff	(strlen@s),tblptrl
	movff	(strlen@s+1),tblptrh
	clrf	tblptru
	
	movlw	high __ramtop-1
	cpfsgt	tblptrh
	bra	u20377
	tblrd	*
	
	movf	tablat,w
	bra	u20370
u20377:
	movff	tblptrl,fsr1l
	movff	tblptrh,fsr1h
	movf	indf1,w
u20370:
	iorlw	0
	btfss	status,2
	goto	u20381
	goto	u20380
u20381:
	goto	l16735
u20380:
	line	11
	
l16739:
	movlb	0	; () banked
	movf	((strlen@a))&0ffh,w
	subwf	((strlen@s))&0ffh,w
	movwf	((?_strlen))&0ffh
	movf	((strlen@a+1))&0ffh,w
	subwfb	((strlen@s+1))&0ffh,w
	movwf	1+((?_strlen))&0ffh
	line	12
	
l1826:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_strlen
	__end_of_strlen:
	signat	_strlen,4218
	global	_strchr

;; *************** function _strchr *****************
;; Defined at:
;;		line 3 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\strchr.c"
;; Parameters:    Size  Location     Type
;;  s               2   37[BANK0 ] PTR const unsigned char 
;;		 -> NULL(0), anaT1.bufferRx(40), anaT1(69), 
;;  c               2   39[BANK0 ] int 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  2   37[BANK0 ] PTR unsigned char 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       4       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       1       0       0       0       0       0       0       0
;;      Totals:         0       5       0       0       0       0       0       0       0
;;Total ram usage:        5 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_strstr
;; This function uses a non-reentrant model
;;
psect	text52,class=CODE,space=0,reloc=2,group=3
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\strchr.c"
	line	3
global __ptext52
__ptext52:
psect	text52
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\strchr.c"
	line	3
	
_strchr:; BSR set to: 0

;incstack = 0
	callstack 15
	line	5
	
l1854:; BSR set to: 0

	line	6
	
l5621:; BSR set to: 0

	movff	(strchr@s),fsr2l
	movff	(strchr@s+1),fsr2h
	movf	((strchr@c))&0ffh,w
xorwf	postinc2,w
	btfss	status,2
	goto	u5281
	goto	u5280

u5281:
	goto	l5627
u5280:
	line	7
	
l5623:; BSR set to: 0

		movff	(strchr@s),(?_strchr)
	movff	(strchr@s+1),(?_strchr+1)

	goto	l1856
	line	9
	
l5627:; BSR set to: 0

	movff	(strchr@s),fsr2l
	movff	(strchr@s+1),fsr2h
	infsnz	((strchr@s))&0ffh
	incf	((strchr@s+1))&0ffh
	movf	indf2,w
	btfss	status,2
	goto	u5291
	goto	u5290
u5291:
	goto	l1854
u5290:
	line	10
	
l5629:; BSR set to: 0

		movlw	low(0)
	movwf	((?_strchr))&0ffh
	movlw	high(0)
	movwf	((?_strchr+1))&0ffh

	line	11
	
l1856:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_strchr
	__end_of_strchr:
	signat	_strchr,8314
	global	_memcpy

;; *************** function _memcpy *****************
;; Defined at:
;;		line 4 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\memcpy.c"
;; Parameters:    Size  Location     Type
;;  d1              2   41[BANK0 ] PTR void 
;;		 -> transmitUart1@bufferTx1(45), anaT1(69), 
;;  s1              2   43[BANK0 ] PTR const void 
;;		 -> extraerFrame@buffer(10), STR_3(25), ap(76), 
;;  n               2   45[BANK0 ] unsigned int 
;; Auto vars:     Size  Location     Type
;;  s               2   50[BANK0 ] PTR const unsigned char 
;;		 -> extraerFrame@buffer(10), STR_3(25), ap(76), 
;;  d               2   48[BANK0 ] PTR unsigned char 
;;		 -> transmitUart1@bufferTx1(45), anaT1(69), 
;;  tmp             1   47[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  2   41[BANK0 ] PTR void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       6       0       0       0       0       0       0       0
;;      Locals:         0       5       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0      11       0       0       0       0       0       0       0
;;Total ram usage:       11 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_transmitUart1
;;		_extraerFrame
;; This function uses a non-reentrant model
;;
psect	text53,class=CODE,space=0,reloc=2,group=3
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\memcpy.c"
	line	4
global __ptext53
__ptext53:
psect	text53
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\memcpy.c"
	line	4
	
_memcpy:; BSR set to: 0

;incstack = 0
	callstack 15
	line	11
	
l11255:; BSR set to: 0

		movff	(memcpy@s1),(memcpy@s)
	movff	(memcpy@s1+1),(memcpy@s+1)

	line	12
		movff	(memcpy@d1),(memcpy@d)
	movff	(memcpy@d1+1),(memcpy@d+1)

	line	13
	goto	l11265
	line	14
	
l11257:; BSR set to: 0

	movff	(memcpy@s),tblptrl
	movff	(memcpy@s+1),tblptrh
	clrf	tblptru
	
	movlw	high __ramtop-1
	cpfsgt	tblptrh
	bra	u13307
	tblrd	*
	
	movf	tablat,w
	bra	u13300
u13307:
	movff	tblptrl,fsr1l
	movff	tblptrh,fsr1h
	movf	indf1,w
u13300:
	movlb	0	; () banked
	movwf	((memcpy@tmp))&0ffh
	
l11259:; BSR set to: 0

	infsnz	((memcpy@s))&0ffh
	incf	((memcpy@s+1))&0ffh
	line	15
	
l11261:; BSR set to: 0

	movff	(memcpy@d),fsr2l
	movff	(memcpy@d+1),fsr2h
	movff	(memcpy@tmp),indf2

	
l11263:; BSR set to: 0

	infsnz	((memcpy@d))&0ffh
	incf	((memcpy@d+1))&0ffh
	line	13
	
l11265:; BSR set to: 0

	decf	((memcpy@n))&0ffh
	btfss	status,0
	decf	((memcpy@n+1))&0ffh
		incf	((memcpy@n))&0ffh,w
	bnz	u13311
	incf	((memcpy@n+1))&0ffh,w
	btfss	status,2
	goto	u13311
	goto	u13310

u13311:
	goto	l11257
u13310:
	line	18
	
l1665:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_memcpy
	__end_of_memcpy:
	signat	_memcpy,12410
	global	_extraerCalendar

;; *************** function _extraerCalendar *****************
;; Defined at:
;;		line 521 in file "Serial.c"
;; Parameters:    Size  Location     Type
;;  orig            2   54[BANK0 ] PTR unsigned char 
;;		 -> anaT1(69), 
;;  dia             2   56[BANK0 ] PTR unsigned char 
;;		 -> anaT1(69), 
;;  mes             2   58[BANK0 ] PTR unsigned char 
;;		 -> anaT1(69), 
;;  ano             2   60[BANK0 ] PTR unsigned char 
;;		 -> anaT1(69), 
;;  diaSema         2   62[BANK0 ] PTR unsigned char 
;;		 -> anaT1(69), 
;; Auto vars:     Size  Location     Type
;;  buffer          4   68[BANK0 ] unsigned char [4]
;;  dayWeek         1   67[BANK0 ] unsigned char 
;;  year            1   66[BANK0 ] unsigned char 
;;  month           1   65[BANK0 ] unsigned char 
;;  day             1   64[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0      10       0       0       0       0       0       0       0
;;      Locals:         0       8       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0      18       0       0       0       0       0       0       0
;;Total ram usage:       18 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 14
;; This function calls:
;;		_atoi
;;		_memset
;; This function is called by:
;;		_taskAnalizaUart1
;; This function uses a non-reentrant model
;;
psect	text54,class=CODE,space=0,reloc=2,group=0
	file	"Serial.c"
	line	521
global __ptext54
__ptext54:
psect	text54
	file	"Serial.c"
	line	521
	
_extraerCalendar:; BSR set to: 0

;incstack = 0
	callstack 14
	line	525
	
l11603:; BSR set to: 0

	line	526
	movlw	low(0)
	movwf	((extraerCalendar@month))&0ffh
	line	527
	movlw	low(0)
	movwf	((extraerCalendar@year))&0ffh
	line	528
	movlw	low(0)
	movwf	((extraerCalendar@dayWeek))&0ffh
	line	530
	
l11605:; BSR set to: 0

		movlw	low(extraerCalendar@buffer)
	movwf	((memset@dest))&0ffh
	clrf	((memset@dest+1))&0ffh

	movlw	high(0)
	movwf	((memset@c+1))&0ffh
	movlw	low(0)
	movwf	((memset@c))&0ffh
	movlw	high(04h)
	movwf	((memset@n+1))&0ffh
	movlw	low(04h)
	movwf	((memset@n))&0ffh
	call	_memset	;wreg free
	line	532
	
l11607:; BSR set to: 0

	movff	(extraerCalendar@orig),fsr2l
	movff	(extraerCalendar@orig+1),fsr2h
	movf	indf2,w
	movwf	((extraerCalendar@buffer))&0ffh
	
l11609:; BSR set to: 0

	infsnz	((extraerCalendar@orig))&0ffh
	incf	((extraerCalendar@orig+1))&0ffh
	line	533
	
l11611:; BSR set to: 0

	movff	(extraerCalendar@orig),fsr2l
	movff	(extraerCalendar@orig+1),fsr2h
	movf	indf2,w
	movwf	(0+(extraerCalendar@buffer+01h))&0ffh
	
l11613:; BSR set to: 0

	infsnz	((extraerCalendar@orig))&0ffh
	incf	((extraerCalendar@orig+1))&0ffh
	line	537
	
l11615:; BSR set to: 0

		movlw	low(extraerCalendar@buffer)
	movwf	((atoi@s))&0ffh
	clrf	((atoi@s+1))&0ffh

	call	_atoi	;wreg free
	movf	(0+?_atoi)&0ffh,w
	movwf	((extraerCalendar@day))&0ffh
	line	539
	
l11617:; BSR set to: 0

	movff	(extraerCalendar@orig),fsr2l
	movff	(extraerCalendar@orig+1),fsr2h
	movf	indf2,w
	movwf	((extraerCalendar@buffer))&0ffh
	
l11619:; BSR set to: 0

	infsnz	((extraerCalendar@orig))&0ffh
	incf	((extraerCalendar@orig+1))&0ffh
	line	540
	
l11621:; BSR set to: 0

	movff	(extraerCalendar@orig),fsr2l
	movff	(extraerCalendar@orig+1),fsr2h
	movf	indf2,w
	movwf	(0+(extraerCalendar@buffer+01h))&0ffh
	
l11623:; BSR set to: 0

	infsnz	((extraerCalendar@orig))&0ffh
	incf	((extraerCalendar@orig+1))&0ffh
	line	542
	
l11625:; BSR set to: 0

		movlw	low(extraerCalendar@buffer)
	movwf	((atoi@s))&0ffh
	clrf	((atoi@s+1))&0ffh

	call	_atoi	;wreg free
	movf	(0+?_atoi)&0ffh,w
	movwf	((extraerCalendar@month))&0ffh
	line	544
	
l11627:; BSR set to: 0

	movff	(extraerCalendar@orig),fsr2l
	movff	(extraerCalendar@orig+1),fsr2h
	movf	indf2,w
	movwf	((extraerCalendar@buffer))&0ffh
	
l11629:; BSR set to: 0

	infsnz	((extraerCalendar@orig))&0ffh
	incf	((extraerCalendar@orig+1))&0ffh
	line	545
	
l11631:; BSR set to: 0

	movff	(extraerCalendar@orig),fsr2l
	movff	(extraerCalendar@orig+1),fsr2h
	movf	indf2,w
	movwf	(0+(extraerCalendar@buffer+01h))&0ffh
	
l11633:; BSR set to: 0

	infsnz	((extraerCalendar@orig))&0ffh
	incf	((extraerCalendar@orig+1))&0ffh
	line	547
	
l11635:; BSR set to: 0

		movlw	low(extraerCalendar@buffer)
	movwf	((atoi@s))&0ffh
	clrf	((atoi@s+1))&0ffh

	call	_atoi	;wreg free
	movf	(0+?_atoi)&0ffh,w
	movwf	((extraerCalendar@year))&0ffh
	line	549
	
l11637:; BSR set to: 0

	infsnz	((extraerCalendar@orig))&0ffh
	incf	((extraerCalendar@orig+1))&0ffh
	line	551
	
l11639:; BSR set to: 0

	movff	(extraerCalendar@orig),fsr2l
	movff	(extraerCalendar@orig+1),fsr2h
	movf	indf2,w
	movwf	((extraerCalendar@buffer))&0ffh
	line	552
	
l11641:; BSR set to: 0

	movlw	low(0)
	movwf	(0+(extraerCalendar@buffer+01h))&0ffh
	line	554
	
l11643:; BSR set to: 0

		movlw	low(extraerCalendar@buffer)
	movwf	((atoi@s))&0ffh
	clrf	((atoi@s+1))&0ffh

	call	_atoi	;wreg free
	movf	(0+?_atoi)&0ffh,w
	movwf	((extraerCalendar@dayWeek))&0ffh
	line	556
	
l11645:; BSR set to: 0

	movff	(extraerCalendar@dia),fsr2l
	movff	(extraerCalendar@dia+1),fsr2h
	movff	(extraerCalendar@day),indf2

	line	557
	
l11647:; BSR set to: 0

	movff	(extraerCalendar@mes),fsr2l
	movff	(extraerCalendar@mes+1),fsr2h
	movff	(extraerCalendar@month),indf2

	line	558
	
l11649:; BSR set to: 0

	movff	(extraerCalendar@ano),fsr2l
	movff	(extraerCalendar@ano+1),fsr2h
	movff	(extraerCalendar@year),indf2

	line	559
	
l11651:; BSR set to: 0

	movff	(extraerCalendar@diaSema),fsr2l
	movff	(extraerCalendar@diaSema+1),fsr2h
	movff	(extraerCalendar@dayWeek),indf2

	line	560
	
l941:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_extraerCalendar
	__end_of_extraerCalendar:
	signat	_extraerCalendar,20601
	global	_memset

;; *************** function _memset *****************
;; Defined at:
;;		line 4 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\memset.c"
;; Parameters:    Size  Location     Type
;;  dest            2   41[BANK0 ] PTR void 
;;		 -> extraerCalendar@buffer(4), extraerHora@buffer(4), extraerFrame@buffer(10), extraerValue@buffer(4), 
;;		 -> transmitUart1@bufferTx1(45), readDevide@bufferHorario(5), readDevide@bufferEnable(5), ap(76), 
;;		 -> anaT1(69), serial1(43), 
;;  c               2   43[BANK0 ] int 
;;  n               2   45[BANK0 ] unsigned int 
;; Auto vars:     Size  Location     Type
;;  s               2   51[BANK0 ] PTR unsigned char 
;;		 -> extraerCalendar@buffer(4), extraerHora@buffer(4), extraerFrame@buffer(10), extraerValue@buffer(4), 
;;		 -> transmitUart1@bufferTx1(45), readDevide@bufferHorario(5), readDevide@bufferEnable(5), ap(76), 
;;		 -> anaT1(69), serial1(43), 
;;  k               2   49[BANK0 ] unsigned int 
;; Return value:  Size  Location     Type
;;                  2   41[BANK0 ] PTR void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       6       0       0       0       0       0       0       0
;;      Locals:         0       4       0       0       0       0       0       0       0
;;      Temps:          0       2       0       0       0       0       0       0       0
;;      Totals:         0      12       0       0       0       0       0       0       0
;;Total ram usage:       12 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_cleanBuffer
;;		_convStringDayWeek
;;		_convOnOff
;;		_transmitUart1
;;		_taskAnalizaUart1
;;		_extraerValue
;;		_extraerFrame
;;		_extraerHora
;;		_extraerCalendar
;; This function uses a non-reentrant model
;;
psect	text55,class=CODE,space=0,reloc=2,group=3
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\memset.c"
	line	4
global __ptext55
__ptext55:
psect	text55
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\memset.c"
	line	4
	
_memset:; BSR set to: 0

;incstack = 0
	callstack 15
	line	6
	
l11211:; BSR set to: 0

		movff	(memset@dest),(memset@s)
	movff	(memset@dest+1),(memset@s+1)

	line	13
	movf	((memset@n))&0ffh,w
iorwf	((memset@n+1))&0ffh,w
	btfss	status,2
	goto	u13251
	goto	u13250

u13251:
	goto	l11215
u13250:
	goto	l1669
	line	14
	
l11215:; BSR set to: 0

	movff	(memset@s),fsr2l
	movff	(memset@s+1),fsr2h
	movff	(memset@c),indf2

	line	15
	
l11217:; BSR set to: 0

	movf	((memset@n))&0ffh,w
	addwf	((memset@s))&0ffh,w
	movwf	(??_memset+0+0)&0ffh
	movf	((memset@n+1))&0ffh,w
	addwfc	((memset@s+1))&0ffh,w
	movwf	(??_memset+0+0+1)&0ffh
	movlw	low(0FFFFh)
	addwf	(??_memset+0+0)&0ffh,w
	movwf	c:fsr2l
	movlw	high(0FFFFh)
	addwfc	(??_memset+0+1)&0ffh,w
	movwf	1+c:fsr2l
	movff	(memset@c),indf2

	line	16
		movf	((memset@n+1))&0ffh,w
	bnz	u13261
	movlw	3
	subwf	 ((memset@n))&0ffh,w
	btfsc	status,0
	goto	u13261
	goto	u13260

u13261:
	goto	l11221
u13260:
	goto	l1669
	line	17
	
l11221:; BSR set to: 0

	lfsr	2,01h
	movf	((memset@s))&0ffh,w
	addwf	fsr2l
	movf	((memset@s+1))&0ffh,w
	addwfc	fsr2h
	movff	(memset@c),indf2

	line	18
	lfsr	2,02h
	movf	((memset@s))&0ffh,w
	addwf	fsr2l
	movf	((memset@s+1))&0ffh,w
	addwfc	fsr2h
	movff	(memset@c),indf2

	line	19
	movf	((memset@n))&0ffh,w
	addwf	((memset@s))&0ffh,w
	movwf	(??_memset+0+0)&0ffh
	movf	((memset@n+1))&0ffh,w
	addwfc	((memset@s+1))&0ffh,w
	movwf	(??_memset+0+0+1)&0ffh
	movlw	low(0FFFEh)
	addwf	(??_memset+0+0)&0ffh,w
	movwf	c:fsr2l
	movlw	high(0FFFEh)
	addwfc	(??_memset+0+1)&0ffh,w
	movwf	1+c:fsr2l
	movff	(memset@c),indf2

	line	20
	movf	((memset@n))&0ffh,w
	addwf	((memset@s))&0ffh,w
	movwf	(??_memset+0+0)&0ffh
	movf	((memset@n+1))&0ffh,w
	addwfc	((memset@s+1))&0ffh,w
	movwf	(??_memset+0+0+1)&0ffh
	movlw	low(0FFFDh)
	addwf	(??_memset+0+0)&0ffh,w
	movwf	c:fsr2l
	movlw	high(0FFFDh)
	addwfc	(??_memset+0+1)&0ffh,w
	movwf	1+c:fsr2l
	movff	(memset@c),indf2

	line	21
	
l11223:; BSR set to: 0

		movf	((memset@n+1))&0ffh,w
	bnz	u13271
	movlw	7
	subwf	 ((memset@n))&0ffh,w
	btfsc	status,0
	goto	u13271
	goto	u13270

u13271:
	goto	l11227
u13270:
	goto	l1669
	line	22
	
l11227:; BSR set to: 0

	lfsr	2,03h
	movf	((memset@s))&0ffh,w
	addwf	fsr2l
	movf	((memset@s+1))&0ffh,w
	addwfc	fsr2h
	movff	(memset@c),indf2

	line	23
	movf	((memset@n))&0ffh,w
	addwf	((memset@s))&0ffh,w
	movwf	(??_memset+0+0)&0ffh
	movf	((memset@n+1))&0ffh,w
	addwfc	((memset@s+1))&0ffh,w
	movwf	(??_memset+0+0+1)&0ffh
	movlw	low(0FFFCh)
	addwf	(??_memset+0+0)&0ffh,w
	movwf	c:fsr2l
	movlw	high(0FFFCh)
	addwfc	(??_memset+0+1)&0ffh,w
	movwf	1+c:fsr2l
	movff	(memset@c),indf2

	line	24
	
l11229:; BSR set to: 0

		movf	((memset@n+1))&0ffh,w
	bnz	u13281
	movlw	9
	subwf	 ((memset@n))&0ffh,w
	btfsc	status,0
	goto	u13281
	goto	u13280

u13281:
	goto	l11233
u13280:
	goto	l1669
	line	31
	
l11233:; BSR set to: 0

	movff	(memset@s),??_memset+0+0
	movff	(memset@s+1),??_memset+0+0+1
	comf	(??_memset+0+0)&0ffh
	comf	(??_memset+0+1)&0ffh
	infsnz	(??_memset+0+0)&0ffh
	incf	(??_memset+0+1)&0ffh
	movlw	03h
	andwf	(??_memset+0+0)&0ffh,w
	movwf	((memset@k))&0ffh
	clrf	1+((memset@k))&0ffh
	line	32
	movf	((memset@k))&0ffh,w
	addwf	((memset@s))&0ffh
	movf	((memset@k+1))&0ffh,w
	addwfc	((memset@s+1))&0ffh

	line	33
	movf	((memset@k))&0ffh,w
	subwf	((memset@n))&0ffh
	movf	((memset@k+1))&0ffh,w
	subwfb	((memset@n+1))&0ffh

	line	34
	movlw	low(0FFFCh)
	andwf	((memset@n))&0ffh
	movlw	high(0FFFCh)
	andwf	((memset@n+1))&0ffh
	line	86
	goto	l11241
	
l11235:; BSR set to: 0

	movff	(memset@s),fsr2l
	movff	(memset@s+1),fsr2h
	movff	(memset@c),indf2

	
l11237:; BSR set to: 0

	decf	((memset@n))&0ffh
	btfss	status,0
	decf	((memset@n+1))&0ffh
	
l11239:; BSR set to: 0

	infsnz	((memset@s))&0ffh
	incf	((memset@s+1))&0ffh
	
l11241:; BSR set to: 0

	movf	((memset@n))&0ffh,w
iorwf	((memset@n+1))&0ffh,w
	btfss	status,2
	goto	u13291
	goto	u13290

u13291:
	goto	l11235
u13290:
	line	90
	
l1669:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_memset
	__end_of_memset:
	signat	_memset,12410
	global	_atoi

;; *************** function _atoi *****************
;; Defined at:
;;		line 4 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\atoi.c"
;; Parameters:    Size  Location     Type
;;  s               2   44[BANK0 ] PTR const unsigned char 
;;		 -> extraerCalendar@buffer(4), extraerHora@buffer(4), extraerValue@buffer(4), anaT1.buffer2(10), 
;;		 -> anaT1(69), 
;; Auto vars:     Size  Location     Type
;;  n               2   52[BANK0 ] int 
;;  neg             2   50[BANK0 ] int 
;; Return value:  Size  Location     Type
;;                  2   44[BANK0 ] int 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       2       0       0       0       0       0       0       0
;;      Locals:         0       4       0       0       0       0       0       0       0
;;      Temps:          0       4       0       0       0       0       0       0       0
;;      Totals:         0      10       0       0       0       0       0       0       0
;;Total ram usage:       10 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 13
;; This function calls:
;;		___wmul
;;		_isdigit
;;		_isspace
;; This function is called by:
;;		_taskAnalizaUart1
;;		_extraerValue
;;		_extraerHora
;;		_extraerCalendar
;; This function uses a non-reentrant model
;;
psect	text56,class=CODE,space=0,reloc=2,group=3
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\atoi.c"
	line	4
global __ptext56
__ptext56:
psect	text56
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\atoi.c"
	line	4
	
_atoi:; BSR set to: 0

;incstack = 0
	callstack 14
	line	6
	
l5841:; BSR set to: 0

	movlw	high(0)
	movwf	((atoi@n+1))&0ffh
	movlw	low(0)
	movwf	((atoi@n))&0ffh
	movlw	high(0)
	movwf	((atoi@neg+1))&0ffh
	movlw	low(0)
	movwf	((atoi@neg))&0ffh
	line	7
	goto	l5847
	
l5843:; BSR set to: 0

	infsnz	((atoi@s))&0ffh
	incf	((atoi@s+1))&0ffh
	
l5847:; BSR set to: 0

	movff	(atoi@s),fsr2l
	movff	(atoi@s+1),fsr2h
	movlw	32
	xorwf	postinc2,w
	btfsc	status,2
	goto	u5591
	goto	u5590

u5591:
	goto	l5843
u5590:
	
l5849:; BSR set to: 0

	movlw	low(0FFF7h)
	movwf	(??_atoi+0+0)&0ffh
	movlw	high(0FFF7h)
	movwf	1+(??_atoi+0+0)&0ffh
	movff	(atoi@s),fsr2l
	movff	(atoi@s+1),fsr2h
	movf	indf2,w
	movwf	(??_atoi+2+0)&0ffh
	clrf	(??_atoi+2+0+1)&0ffh

	movf	(??_atoi+0+0)&0ffh,w
	addwf	(??_atoi+2+0)&0ffh
	movf	(??_atoi+0+1)&0ffh,w
	addwfc	(??_atoi+2+1)&0ffh
		movf	(??_atoi+2+1)&0ffh,w
	bnz	u5600
	movlw	5
	subwf	 (??_atoi+2+0)&0ffh,w
	btfss	status,0
	goto	u5601
	goto	u5600

u5601:
	goto	l5843
u5600:
	goto	l5855
	line	9
	
l5851:; BSR set to: 0

	movlw	high(01h)
	movwf	((atoi@neg+1))&0ffh
	movlw	low(01h)
	movwf	((atoi@neg))&0ffh
	line	10
	
l5853:; BSR set to: 0

	infsnz	((atoi@s))&0ffh
	incf	((atoi@s+1))&0ffh
	line	11
	goto	l5863
	
l5855:; BSR set to: 0

	movff	(atoi@s),fsr2l
	movff	(atoi@s+1),fsr2h
	movf	indf2,w
	movwf	(??_atoi+0+0)&0ffh
	clrf	(??_atoi+0+0+1)&0ffh

	; Switch on 2 bytes has been partitioned into a top level switch of size 1, and 1 sub-switches
; Switch size 1, requested type "simple"
; Number of cases is 1, Range of values is 0 to 0
; switch strategies available:
; Name         Instructions Cycles
; simple_byte            4     3 (average)
;	Chosen strategy is simple_byte

	movf ??_atoi+0+1&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l18607
	goto	l5863
	
l18607:; BSR set to: 0

; Switch size 1, requested type "simple"
; Number of cases is 2, Range of values is 43 to 45
; switch strategies available:
; Name         Instructions Cycles
; simple_byte            7     4 (average)
;	Chosen strategy is simple_byte

	movf ??_atoi+0+0&0ffh,w
	xorlw	43^0	; case 43
	skipnz
	goto	l5853
	xorlw	45^43	; case 45
	skipnz
	goto	l5851
	goto	l5863

	line	14
	
l5857:; BSR set to: 0

	movff	(atoi@n),(___wmul@multiplier)
	movff	(atoi@n+1),(___wmul@multiplier+1)
	movlw	high(0Ah)
	movwf	((___wmul@multiplicand+1))&0ffh
	movlw	low(0Ah)
	movwf	((___wmul@multiplicand))&0ffh
	call	___wmul	;wreg free
	movff	(atoi@s),fsr2l
	movff	(atoi@s+1),fsr2h
	movf	indf2,w
	movwf	(??_atoi+0+0)&0ffh
	movf	((??_atoi+0+0))&0ffh,w
	subwf	(0+?___wmul)&0ffh
	movlw	0
	subwfb	(1+?___wmul)&0ffh
	movlw	low(030h)
	addwf	(0+?___wmul)&0ffh,w
	movwf	((atoi@n))&0ffh
	movlw	high(030h)
	addwfc	(1+?___wmul)&0ffh,w
	movwf	1+((atoi@n))&0ffh
	goto	l5853
	line	13
	
l5863:; BSR set to: 0

	movlw	low(0FFD0h)
	movwf	(??_atoi+0+0)&0ffh
	movlw	high(0FFD0h)
	movwf	1+(??_atoi+0+0)&0ffh
	movff	(atoi@s),fsr2l
	movff	(atoi@s+1),fsr2h
	movf	indf2,w
	movwf	(??_atoi+2+0)&0ffh
	clrf	(??_atoi+2+0+1)&0ffh

	movf	(??_atoi+0+0)&0ffh,w
	addwf	(??_atoi+2+0)&0ffh
	movf	(??_atoi+0+1)&0ffh,w
	addwfc	(??_atoi+2+1)&0ffh
		movf	(??_atoi+2+1)&0ffh,w
	bnz	u5610
	movlw	10
	subwf	 (??_atoi+2+0)&0ffh,w
	btfss	status,0
	goto	u5611
	goto	u5610

u5611:
	goto	l5857
u5610:
	line	15
	
l5865:; BSR set to: 0

	movf	((atoi@neg))&0ffh,w
iorwf	((atoi@neg+1))&0ffh,w
	btfss	status,2
	goto	u5621
	goto	u5620

u5621:
	goto	l1642
u5620:
	
l5867:; BSR set to: 0

	movff	(atoi@n),??_atoi+0+0
	movff	(atoi@n+1),??_atoi+0+0+1
	comf	(??_atoi+0+0)&0ffh
	comf	(??_atoi+0+1)&0ffh
	infsnz	(??_atoi+0+0)&0ffh
	incf	(??_atoi+0+1)&0ffh
	movff	??_atoi+0+0,(?_atoi)
	movff	??_atoi+0+1,(?_atoi+1)
	goto	l1645
	
l1642:; BSR set to: 0

	movff	(atoi@n),(?_atoi)
	movff	(atoi@n+1),(?_atoi+1)
	line	16
	
l1645:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_atoi
	__end_of_atoi:
	signat	_atoi,4218
	global	_isspace

;; *************** function _isspace *****************
;; Defined at:
;;		line 5 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\isspace.c"
;; Parameters:    Size  Location     Type
;;  c               2   37[BANK0 ] int 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  2   37[BANK0 ] int 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       2       0       0       0       0       0       0       0
;;      Locals:         0       1       0       0       0       0       0       0       0
;;      Temps:          0       4       0       0       0       0       0       0       0
;;      Totals:         0       7       0       0       0       0       0       0       0
;;Total ram usage:        7 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_atoi
;; This function uses a non-reentrant model
;;
psect	text57,class=CODE,space=0,reloc=2,group=3
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\isspace.c"
	line	5
global __ptext57
__ptext57:
psect	text57
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\isspace.c"
	line	5
	
_isspace:; BSR set to: 0

;incstack = 0
	callstack 14
	line	7
	
l5605:
	movlw	low(01h)
	movlb	0	; () banked
	movwf	((_isspace$2678))&0ffh
	
l5607:; BSR set to: 0

		movlw	32
	xorwf	((isspace@c))&0ffh,w
iorwf	((isspace@c+1))&0ffh,w
	btfsc	status,2
	goto	u5241
	goto	u5240

u5241:
	goto	l5613
u5240:
	
l5609:; BSR set to: 0

	movlw	low(0FFF7h)
	movwf	(??_isspace+0+0)&0ffh
	movlw	high(0FFF7h)
	movwf	1+(??_isspace+0+0)&0ffh
	movff	(isspace@c),??_isspace+2+0
	movff	(isspace@c+1),??_isspace+2+0+1
	movf	(??_isspace+0+0)&0ffh,w
	addwf	(??_isspace+2+0)&0ffh
	movf	(??_isspace+0+1)&0ffh,w
	addwfc	(??_isspace+2+1)&0ffh
		movf	(??_isspace+2+1)&0ffh,w
	bnz	u5250
	movlw	5
	subwf	 (??_isspace+2+0)&0ffh,w
	btfss	status,0
	goto	u5251
	goto	u5250

u5251:
	goto	l5613
u5250:
	
l5611:; BSR set to: 0

	movlw	low(0)
	movwf	((_isspace$2678))&0ffh
	
l5613:; BSR set to: 0

	movff	(_isspace$2678),(?_isspace)
	clrf	((?_isspace+1))&0ffh
	line	8
	
l1656:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_isspace
	__end_of_isspace:
	signat	_isspace,4218
	global	_isdigit

;; *************** function _isdigit *****************
;; Defined at:
;;		line 5 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\isdigit.c"
;; Parameters:    Size  Location     Type
;;  c               2   37[BANK0 ] int 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  2   37[BANK0 ] int 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       2       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       4       0       0       0       0       0       0       0
;;      Totals:         0       6       0       0       0       0       0       0       0
;;Total ram usage:        6 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_atoi
;; This function uses a non-reentrant model
;;
psect	text58,class=CODE,space=0,reloc=2,group=3
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\isdigit.c"
	line	5
global __ptext58
__ptext58:
psect	text58
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\isdigit.c"
	line	5
	
_isdigit:; BSR set to: 0

;incstack = 0
	callstack 14
	line	7
	
l5617:
	movlw	low(0FFD0h)
	movlb	0	; () banked
	movwf	(??_isdigit+0+0)&0ffh
	movlw	high(0FFD0h)
	movwf	1+(??_isdigit+0+0)&0ffh
	movff	(isdigit@c),??_isdigit+2+0
	movff	(isdigit@c+1),??_isdigit+2+0+1
	movf	(??_isdigit+0+0)&0ffh,w
	addwf	(??_isdigit+2+0)&0ffh
	movf	(??_isdigit+0+1)&0ffh,w
	addwfc	(??_isdigit+2+1)&0ffh
		movf	(??_isdigit+2+1)&0ffh,w
	bnz	u5260
	movlw	10
	subwf	 (??_isdigit+2+0)&0ffh,w
	btfss	status,0
	goto	u5261
	goto	u5260

u5261:
	movlw	1
	goto	u5270
u5260:
	movlw	0
u5270:
	movwf	((?_isdigit))&0ffh
	clrf	((?_isdigit+1))&0ffh
	line	8
	
l1648:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_isdigit
	__end_of_isdigit:
	signat	_isdigit,4218
	global	___wmul

;; *************** function ___wmul *****************
;; Defined at:
;;		line 15 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\Umul16.c"
;; Parameters:    Size  Location     Type
;;  multiplier      2   37[BANK0 ] unsigned int 
;;  multiplicand    2   39[BANK0 ] unsigned int 
;; Auto vars:     Size  Location     Type
;;  product         2   41[BANK0 ] unsigned int 
;; Return value:  Size  Location     Type
;;                  2   37[BANK0 ] unsigned int 
;; Registers used:
;;		wreg, status,2, status,0, prodl, prodh
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       4       0       0       0       0       0       0       0
;;      Locals:         0       2       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       6       0       0       0       0       0       0       0
;;Total ram usage:        6 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_atoi
;; This function uses a non-reentrant model
;;
psect	text59,class=CODE,space=0,reloc=2,group=2
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\Umul16.c"
	line	15
global __ptext59
__ptext59:
psect	text59
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\Umul16.c"
	line	15
	
___wmul:; BSR set to: 0

;incstack = 0
	callstack 14
	line	37
	
l5557:; BSR set to: 0

	movf	((___wmul@multiplier))&0ffh,w
	mulwf	((___wmul@multiplicand))&0ffh
	movff	prodl,(___wmul@product)
	movff	prodh,(___wmul@product+1)
	line	38
	movf	((___wmul@multiplier))&0ffh,w
	mulwf	(0+(___wmul@multiplicand+01h))&0ffh
	movf	(prodl)^0f00h,c,w
	addwf	((___wmul@product+1))&0ffh

	line	39
	movf	(0+(___wmul@multiplier+01h))&0ffh,w
	mulwf	((___wmul@multiplicand))&0ffh
	movf	(prodl)^0f00h,c,w
	addwf	((___wmul@product+1))&0ffh

	line	52
	
l5559:; BSR set to: 0

	movff	(___wmul@product),(?___wmul)
	movff	(___wmul@product+1),(?___wmul+1)
	line	53
	
l949:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of___wmul
	__end_of___wmul:
	signat	___wmul,8314
	global	_escribirRTC

;; *************** function _escribirRTC *****************
;; Defined at:
;;		line 60 in file "DS1307.c"
;; Parameters:    Size  Location     Type
;;  hor             1    wreg     unsigned char 
;;  min             1   43[BANK0 ] unsigned char 
;;  seg             1   44[BANK0 ] unsigned char 
;;  dia             1   45[BANK0 ] unsigned char 
;;  mes             1   46[BANK0 ] unsigned char 
;;  ano             1   47[BANK0 ] unsigned char 
;;  diaSe           1   48[BANK0 ] unsigned char 
;; Auto vars:     Size  Location     Type
;;  hor             1   56[BANK0 ] unsigned char 
;;  rtc_datos       7   57[BANK0 ] const unsigned char [7]
;;  rtc_dir         7   49[BANK0 ] const unsigned char [7]
;;  i               1   64[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3F/1
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       6       0       0       0       0       0       0       0
;;      Locals:         0      16       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0      22       0       0       0       0       0       0       0
;;Total ram usage:       22 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 14
;; This function calls:
;;		_Decimal_a_BCD
;;		_I2C_Master_Write
;;		_I2C_Start
;;		_I2C_Stop
;; This function is called by:
;;		_taskAnalizaUart1
;; This function uses a non-reentrant model
;;
psect	text60,class=CODE,space=0,reloc=2,group=0
	file	"DS1307.c"
	line	60
global __ptext60
__ptext60:
psect	text60
	file	"DS1307.c"
	line	60
	
_escribirRTC:; BSR set to: 0

;incstack = 0
	callstack 14
	movlb	0	; () banked
	movwf	((escribirRTC@hor))&0ffh
	line	65
	
l6081:
	movlw	low((escribirRTC@F2914))
	movwf	tblptrl
	if	1	;There is more than 1 active tblptr byte
	movlw	high((escribirRTC@F2914))
	movwf	tblptrh
	endif
	if	0	;There are less than 3 active tblptr bytes
	movlw	low highword((escribirRTC@F2914))
	movwf	tblptru
	endif
	lfsr	2,(escribirRTC@rtc_dir)
	movlw	7-1
u5990:
	tblrd*+
	
	movff	tablat,postinc2
	decf	wreg
	bc	u5990
	line	66
	movlw	low((escribirRTC@F2916))
	movwf	tblptrl
	if	1	;There is more than 1 active tblptr byte
	movlw	high((escribirRTC@F2916))
	movwf	tblptrh
	endif
	if	0	;There are less than 3 active tblptr bytes
	movlw	low highword((escribirRTC@F2916))
	movwf	tblptru
	endif
	lfsr	2,(escribirRTC@rtc_datos)
	movlw	7-1
u6000:
	tblrd*+
	
	movff	tablat,postinc2
	decf	wreg
	bc	u6000
	
l6083:
	movff	(escribirRTC@hor),(escribirRTC@rtc_datos)
	
l6085:
	movff	(escribirRTC@min),0+(escribirRTC@rtc_datos+01h)
	
l6087:
	movff	(escribirRTC@seg),0+(escribirRTC@rtc_datos+02h)
	
l6089:
	movff	(escribirRTC@dia),0+(escribirRTC@rtc_datos+03h)
	
l6091:
	movff	(escribirRTC@mes),0+(escribirRTC@rtc_datos+04h)
	
l6093:
	movff	(escribirRTC@ano),0+(escribirRTC@rtc_datos+05h)
	
l6095:
	movff	(escribirRTC@diaSe),0+(escribirRTC@rtc_datos+06h)
	line	68
	
l6097:
	movlw	low(0)
	movlb	0	; () banked
	movwf	((escribirRTC@i))&0ffh
	line	70
	
l6103:; BSR set to: 0

	call	_I2C_Start	;wreg free
	line	71
	movlw	(0D0h)&0ffh
	
	call	_I2C_Master_Write
	line	72
	
l6105:; BSR set to: 0

	movf	((escribirRTC@i))&0ffh,w
	addlw	low(escribirRTC@rtc_dir)
	movwf	fsr2l
	clrf	fsr2h
	movf	indf2,w
	
	call	_I2C_Master_Write
	line	73
	
l6107:; BSR set to: 0

	movf	((escribirRTC@i))&0ffh,w
	addlw	low(escribirRTC@rtc_datos)
	movwf	fsr2l
	clrf	fsr2h
	movf	indf2,w
	
	call	_Decimal_a_BCD
	
	call	_I2C_Master_Write
	line	74
	
l6109:; BSR set to: 0

	call	_I2C_Stop	;wreg free
	line	75
	
l6111:; BSR set to: 0

	incf	((escribirRTC@i))&0ffh
	
l6113:; BSR set to: 0

		movlw	07h-1
	cpfsgt	((escribirRTC@i))&0ffh
	goto	u6011
	goto	u6010

u6011:
	goto	l6103
u6010:
	line	76
	
l659:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_escribirRTC
	__end_of_escribirRTC:
	signat	_escribirRTC,28793
	global	_Decimal_a_BCD

;; *************** function _Decimal_a_BCD *****************
;; Defined at:
;;		line 15 in file "DS1307.c"
;; Parameters:    Size  Location     Type
;;  numero          1    wreg     unsigned char 
;; Auto vars:     Size  Location     Type
;;  numero          1   42[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      unsigned char 
;; Registers used:
;;		wreg, status,2, status,0, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       1       0       0       0       0       0       0       0
;;      Temps:          0       1       0       0       0       0       0       0       0
;;      Totals:         0       2       0       0       0       0       0       0       0
;;Total ram usage:        2 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 13
;; This function calls:
;;		___lbdiv
;;		___lbmod
;; This function is called by:
;;		_escribirRTC
;; This function uses a non-reentrant model
;;
psect	text61,class=CODE,space=0,reloc=2,group=0
	line	15
global __ptext61
__ptext61:
psect	text61
	file	"DS1307.c"
	line	15
	
_Decimal_a_BCD:; BSR set to: 0

;incstack = 0
	callstack 14
	movwf	((Decimal_a_BCD@numero))&0ffh
	line	16
	
l5787:
	movlw	low(0Ah)
	movlb	0	; () banked
	movwf	((___lbmod@divisor))&0ffh
	movf	((Decimal_a_BCD@numero))&0ffh,w
	
	call	___lbmod
	movwf	(??_Decimal_a_BCD+0+0)&0ffh
	movlw	low(0Ah)
	movwf	((___lbdiv@divisor))&0ffh
	movf	((Decimal_a_BCD@numero))&0ffh,w
	
	call	___lbdiv
	mullw	010h
	movf	(prodl)^0f00h,c,w
	addwf	((??_Decimal_a_BCD+0+0))&0ffh,w
	line	17
	
l640:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_Decimal_a_BCD
	__end_of_Decimal_a_BCD:
	signat	_Decimal_a_BCD,4217
	global	___lbmod

;; *************** function ___lbmod *****************
;; Defined at:
;;		line 4 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\lbmod.c"
;; Parameters:    Size  Location     Type
;;  dividend        1    wreg     unsigned char 
;;  divisor         1   37[BANK0 ] unsigned char 
;; Auto vars:     Size  Location     Type
;;  dividend        1   38[BANK0 ] unsigned char 
;;  rem             1   40[BANK0 ] unsigned char 
;;  counter         1   39[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      unsigned char 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       1       0       0       0       0       0       0       0
;;      Locals:         0       3       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       4       0       0       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_Decimal_a_BCD
;; This function uses a non-reentrant model
;;
psect	text62,class=CODE,space=0,reloc=2,group=2
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\lbmod.c"
	line	4
global __ptext62
__ptext62:
psect	text62
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\lbmod.c"
	line	4
	
___lbmod:; BSR set to: 0

;incstack = 0
	callstack 14
	movwf	((___lbmod@dividend))&0ffh
	line	9
	
l5589:
	movlw	low(08h)
	movlb	0	; () banked
	movwf	((___lbmod@counter))&0ffh
	line	10
	movlw	low(0)
	movwf	((___lbmod@rem))&0ffh
	line	12
	
l5591:; BSR set to: 0

	bcf	status,0
	rlcf	((___lbmod@dividend))&0ffh,w
	rlcf	((___lbmod@rem))&0ffh,w
	movwf	((___lbmod@rem))&0ffh
	line	13
	
l5593:; BSR set to: 0

	bcf status,0
	rlcf	((___lbmod@dividend))&0ffh

	line	14
	
l5595:; BSR set to: 0

		movf	((___lbmod@divisor))&0ffh,w
	subwf	((___lbmod@rem))&0ffh,w
	btfss	status,0
	goto	u5231
	goto	u5230

u5231:
	goto	l5599
u5230:
	line	15
	
l5597:; BSR set to: 0

	movf	((___lbmod@divisor))&0ffh,w
	subwf	((___lbmod@rem))&0ffh
	line	16
	
l5599:; BSR set to: 0

	decfsz	((___lbmod@counter))&0ffh
	
	goto	l5591
	line	17
	
l5601:; BSR set to: 0

	movf	((___lbmod@rem))&0ffh,w
	line	18
	
l1361:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of___lbmod
	__end_of___lbmod:
	signat	___lbmod,8313
	global	___lbdiv

;; *************** function ___lbdiv *****************
;; Defined at:
;;		line 4 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\lbdiv.c"
;; Parameters:    Size  Location     Type
;;  dividend        1    wreg     unsigned char 
;;  divisor         1   37[BANK0 ] unsigned char 
;; Auto vars:     Size  Location     Type
;;  dividend        1   38[BANK0 ] unsigned char 
;;  quotient        1   40[BANK0 ] unsigned char 
;;  counter         1   39[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      unsigned char 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       1       0       0       0       0       0       0       0
;;      Locals:         0       3       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       4       0       0       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_Decimal_a_BCD
;; This function uses a non-reentrant model
;;
psect	text63,class=CODE,space=0,reloc=2,group=2
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\lbdiv.c"
	line	4
global __ptext63
__ptext63:
psect	text63
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\lbdiv.c"
	line	4
	
___lbdiv:; BSR set to: 0

;incstack = 0
	callstack 14
	movwf	((___lbdiv@dividend))&0ffh
	line	9
	
l5563:
	movlw	low(0)
	movlb	0	; () banked
	movwf	((___lbdiv@quotient))&0ffh
	line	10
	
l5565:; BSR set to: 0

	movf	((___lbdiv@divisor))&0ffh,w
	btfsc	status,2
	goto	u5201
	goto	u5200
u5201:
	goto	l5585
u5200:
	line	11
	
l5567:; BSR set to: 0

	movlw	low(01h)
	movwf	((___lbdiv@counter))&0ffh
	line	12
	goto	l5573
	line	13
	
l5569:; BSR set to: 0

	bcf status,0
	rlcf	((___lbdiv@divisor))&0ffh

	line	14
	
l5571:; BSR set to: 0

	incf	((___lbdiv@counter))&0ffh
	line	12
	
l5573:; BSR set to: 0

	
	btfss	((___lbdiv@divisor))&0ffh,(7)&7
	goto	u5211
	goto	u5210
u5211:
	goto	l5569
u5210:
	line	17
	
l5575:; BSR set to: 0

	bcf status,0
	rlcf	((___lbdiv@quotient))&0ffh

	line	18
		movf	((___lbdiv@divisor))&0ffh,w
	subwf	((___lbdiv@dividend))&0ffh,w
	btfss	status,0
	goto	u5221
	goto	u5220

u5221:
	goto	l5581
u5220:
	line	19
	
l5577:; BSR set to: 0

	movf	((___lbdiv@divisor))&0ffh,w
	subwf	((___lbdiv@dividend))&0ffh
	line	20
	
l5579:; BSR set to: 0

	bsf	(0+(0/8)+(___lbdiv@quotient))&0ffh,(0)&7
	line	22
	
l5581:; BSR set to: 0

	bcf status,0
	rrcf	((___lbdiv@divisor))&0ffh

	line	23
	
l5583:; BSR set to: 0

	decfsz	((___lbdiv@counter))&0ffh
	
	goto	l5575
	line	25
	
l5585:; BSR set to: 0

	movf	((___lbdiv@quotient))&0ffh,w
	line	26
	
l1355:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of___lbdiv
	__end_of___lbdiv:
	signat	___lbdiv,8313
	global	_EEpromWrite

;; *************** function _EEpromWrite *****************
;; Defined at:
;;		line 8 in file "EEprom.c"
;; Parameters:    Size  Location     Type
;;  address         2   37[BANK0 ] unsigned int 
;;  data            1   39[BANK0 ] unsigned char 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 3F/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       3       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       3       0       0       0       0       0       0       0
;;Total ram usage:        3 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_taskAplicacion
;;		_taskAnalizaUart1
;; This function uses a non-reentrant model
;;
psect	text64,class=CODE,space=0,reloc=2,group=0
	file	"EEprom.c"
	line	8
global __ptext64
__ptext64:
psect	text64
	file	"EEprom.c"
	line	8
	
_EEpromWrite:; BSR set to: 0

;incstack = 0
	callstack 16
	line	10
	
l6067:; BSR set to: 0

	movff	(EEpromWrite@address),(c:4009)	;volatile
	line	11
	movff	(EEpromWrite@data),(c:4008)	;volatile
	line	13
	bcf	((c:4006))^0f00h,c,7	;volsfr
	line	14
	bcf	((c:4006))^0f00h,c,6	;volsfr
	line	15
	bsf	((c:4006))^0f00h,c,2	;volsfr
	line	16
	bcf	((c:4082))^0f00h,c,7	;volatile
	line	18
	
l6069:; BSR set to: 0

	movlw	low(055h)
	movwf	((c:4007))^0f00h,c	;volsfr
	line	19
	movlw	low(0AAh)
	movwf	((c:4007))^0f00h,c	;volsfr
	line	20
	
l6071:; BSR set to: 0

	bsf	((c:4006))^0f00h,c,1	;volsfr
	line	21
	
l6073:; BSR set to: 0

	bsf	((c:4082))^0f00h,c,7	;volatile
	line	23
	
l674:; BSR set to: 0

	btfss	((c:4001))^0f00h,c,4	;volatile
	goto	u5981
	goto	u5980
u5981:
	goto	l674
u5980:
	
l676:; BSR set to: 0

	line	24
	bcf	((c:4001))^0f00h,c,4	;volatile
	line	25
	bcf	((c:4006))^0f00h,c,2	;volsfr
	line	26
	
l677:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_EEpromWrite
	__end_of_EEpromWrite:
	signat	_EEpromWrite,8313
	global	_executeTaskAlarm

;; *************** function _executeTaskAlarm *****************
;; Defined at:
;;		line 567 in file "Alarma.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3D/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 16
;; This function calls:
;;		_taskAlarm
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text65,class=CODE,space=0,reloc=2,group=0
	file	"Alarma.c"
	line	567
global __ptext65
__ptext65:
psect	text65
	file	"Alarma.c"
	line	567
	
_executeTaskAlarm:; BSR set to: 0

;incstack = 0
	callstack 14
	line	569
	
l10465:
		movlw	low(_ptTaskAlarm)
	movlb	0	; () banked
	movwf	((taskAlarm@pt))&0ffh
	movlw	high(_ptTaskAlarm)
	movwf	((taskAlarm@pt+1))&0ffh

	call	_taskAlarm	;wreg free
	line	570
	
l345:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_executeTaskAlarm
	__end_of_executeTaskAlarm:
	signat	_executeTaskAlarm,89
	global	_taskAlarm

;; *************** function _taskAlarm *****************
;; Defined at:
;;		line 40 in file "Alarma.c"
;; Parameters:    Size  Location     Type
;;  pt              2   63[BANK0 ] PTR struct pt
;;		 -> ptTaskAlarm(2), 
;; Auto vars:     Size  Location     Type
;;  PT_YIELD_FLA    1    0        unsigned char 
;; Return value:  Size  Location     Type
;;                  2   63[BANK0 ] int 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       2       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       2       0       0       0       0       0       0       0
;;      Totals:         0       4       0       0       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 15
;; This function calls:
;;		_getMillis
;;		_leerRTC
;;		_leerRtcSeg
;; This function is called by:
;;		_executeTaskAlarm
;; This function uses a non-reentrant model
;;
psect	text66,class=CODE,space=0,reloc=2,group=0
	line	40
global __ptext66
__ptext66:
psect	text66
	file	"Alarma.c"
	line	40
	
_taskAlarm:; BSR set to: 0

;incstack = 0
	callstack 14
	line	43
	
l9435:; BSR set to: 0

	goto	l9721
	
l195:; BSR set to: 1

	line	46
	
l9437:
	movlw	0Ah
	call	_getMillis	;wreg free
	movlb	0	; () banked
	addwf	(0+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	((_ulCntPeriodAlarm))&0ffh
	movlw	0
	movlb	0	; () banked
	addwfc	(1+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	1+((_ulCntPeriodAlarm))&0ffh
	
	movlw	0
	movlb	0	; () banked
	addwfc	(2+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	2+((_ulCntPeriodAlarm))&0ffh
	
	movlw	0
	movlb	0	; () banked
	addwfc	(3+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movwf	3+((_ulCntPeriodAlarm))&0ffh
	line	47
	
l9439:; BSR set to: 1

	movff	(taskAlarm@pt),fsr2l
	movff	(taskAlarm@pt+1),fsr2h
	movlw	low(02Fh)
	movwf	postinc2,c
	movlw	high(02Fh)
	movwf	postdec2,c
	
l9441:
	call	_getMillis	;wreg free
	movlb	1	; () banked
		movf	((_ulCntPeriodAlarm))&0ffh,w
	movlb	0	; () banked
	subwf	(0+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movf	((_ulCntPeriodAlarm+1))&0ffh,w
	movlb	0	; () banked
	subwfb	(1+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movf	((_ulCntPeriodAlarm+2))&0ffh,w
	movlb	0	; () banked
	subwfb	(2+?_getMillis)&0ffh,w
	movlb	1	; () banked
	movf	((_ulCntPeriodAlarm+3))&0ffh,w
	movlb	0	; () banked
	subwfb	(3+?_getMillis)&0ffh,w
	btfsc	status,0
	goto	u10731
	goto	u10730

u10731:
	goto	l9719
u10730:
	goto	l200
	line	51
	
l203:; BSR set to: 0

	line	52
	movlb	2	; () banked
	btfss	((_ap))&0ffh,0
	goto	u10741
	goto	u10740
u10741:
	goto	l9437
u10740:
	line	54
	
l9445:
		movlw	low(_rtc+02h)
	movlb	0	; () banked
	movwf	((leerRTC@hora))&0ffh

		movlw	low(_rtc+01h)
	movwf	((leerRTC@minutos))&0ffh

		movlw	low(_rtc)
	movwf	((leerRTC@segundos))&0ffh

		movlw	low(_rtc+03h)
	movwf	((leerRTC@dia))&0ffh

		movlw	low(_rtc+04h)
	movwf	((leerRTC@mes))&0ffh

		movlw	low(_rtc+05h)
	movwf	((leerRTC@ano))&0ffh

		movlw	low(_rtc+06h)
	movwf	((leerRTC@diaSe))&0ffh

	call	_leerRTC	;wreg free
	line	55
	
l9447:
	movlw	low(02h)
	movlb	0	; () banked
	movwf	((_stateAlarm))&0ffh
	goto	l9437
	line	59
	
l206:; BSR set to: 0

	line	60
	movlb	1	; () banked
	btfsc	0+(_memo+01h)&0ffh,0
	bra	u10755
	bcf	((_ala1))&0ffh,0
	bra	u10756
	u10755:
	movlb	1	; () banked
	bsf	((_ala1))&0ffh,0
	u10756:

	line	61
	btfsc	0+(_memo+02h)&0ffh,0
	bra	u10765
	bcf	((_ala1))&0ffh,1
	bra	u10766
	u10765:
	movlb	1	; () banked
	bsf	((_ala1))&0ffh,1
	u10766:

	line	62
	movff	0+(_memo+03h),0+(_ala1+01h)
	line	63
	movff	0+(_memo+04h),0+(_ala1+0Ah)
	line	64
	movff	0+(_memo+05h),0+(_ala1+0Bh)
	line	65
	movff	0+(_memo+06h),0+(_ala1+0Ch)
	line	66
	movff	0+(_memo+07h),0+(_ala1+0Dh)
	line	68
	btfsc	0+(_memo+08h)&0ffh,0
	bra	u10775
	bcf	((_ala2))&0ffh,0
	bra	u10776
	u10775:
	movlb	1	; () banked
	bsf	((_ala2))&0ffh,0
	u10776:

	line	69
	btfsc	0+(_memo+09h)&0ffh,0
	bra	u10785
	bcf	((_ala2))&0ffh,1
	bra	u10786
	u10785:
	movlb	1	; () banked
	bsf	((_ala2))&0ffh,1
	u10786:

	line	70
	movff	0+(_memo+0Ah),0+(_ala2+01h)
	line	71
	movff	0+(_memo+0Bh),0+(_ala2+0Ah)
	line	72
	movff	0+(_memo+0Ch),0+(_ala2+0Bh)
	line	73
	movff	0+(_memo+0Dh),0+(_ala2+0Ch)
	line	74
	movff	0+(_memo+0Eh),0+(_ala2+0Dh)
	line	76
	btfsc	0+(_memo+0Fh)&0ffh,0
	bra	u10795
	bcf	((_ala3))&0ffh,0
	bra	u10796
	u10795:
	movlb	1	; () banked
	bsf	((_ala3))&0ffh,0
	u10796:

	line	77
	btfsc	0+(_memo+010h)&0ffh,0
	bra	u10805
	bcf	((_ala3))&0ffh,1
	bra	u10806
	u10805:
	movlb	1	; () banked
	bsf	((_ala3))&0ffh,1
	u10806:

	line	78
	movff	0+(_memo+011h),0+(_ala3+01h)
	line	79
	movff	0+(_memo+012h),0+(_ala3+0Ah)
	line	80
	movff	0+(_memo+013h),0+(_ala3+0Bh)
	line	81
	movff	0+(_memo+014h),0+(_ala3+0Ch)
	line	82
	movff	0+(_memo+015h),0+(_ala3+0Dh)
	line	84
	btfsc	0+(_memo+016h)&0ffh,0
	bra	u10815
	bcf	((_ala4))&0ffh,0
	bra	u10816
	u10815:
	movlb	1	; () banked
	bsf	((_ala4))&0ffh,0
	u10816:

	line	85
	btfsc	0+(_memo+017h)&0ffh,0
	bra	u10825
	bcf	((_ala4))&0ffh,1
	bra	u10826
	u10825:
	movlb	1	; () banked
	bsf	((_ala4))&0ffh,1
	u10826:

	line	86
	movff	0+(_memo+018h),0+(_ala4+01h)
	line	87
	movff	0+(_memo+019h),0+(_ala4+0Ah)
	line	88
	movff	0+(_memo+01Ah),0+(_ala4+0Bh)
	line	89
	movff	0+(_memo+01Bh),0+(_ala4+0Ch)
	line	90
	movff	0+(_memo+01Ch),0+(_ala4+0Dh)
	line	92
	btfsc	0+(_memo+01Dh)&0ffh,0
	bra	u10835
	bcf	((_ala5))&0ffh,0
	bra	u10836
	u10835:
	movlb	1	; () banked
	bsf	((_ala5))&0ffh,0
	u10836:

	line	93
	btfsc	0+(_memo+01Eh)&0ffh,0
	bra	u10845
	bcf	((_ala5))&0ffh,1
	bra	u10846
	u10845:
	movlb	1	; () banked
	bsf	((_ala5))&0ffh,1
	u10846:

	line	94
	movff	0+(_memo+01Fh),0+(_ala5+01h)
	line	95
	movff	0+(_memo+020h),0+(_ala5+0Ah)
	line	96
	movff	0+(_memo+021h),0+(_ala5+0Bh)
	line	97
	movff	0+(_memo+022h),0+(_ala5+0Ch)
	line	98
	movff	0+(_memo+023h),0+(_ala5+0Dh)
	goto	l9447
	line	105
	
l9451:; BSR set to: 0

	movlb	1	; () banked
	infsnz	((_ala))&0ffh
	incf	((_ala+1))&0ffh
		movf	((_ala+1))&0ffh,w
	bnz	u10850
	movlw	50
	subwf	 ((_ala))&0ffh,w
	btfss	status,0
	goto	u10851
	goto	u10850

u10851:
	goto	l9459
u10850:
	line	107
	
l9453:; BSR set to: 1

	movlw	high(0)
	movwf	((_ala+1))&0ffh
	movlw	low(0)
	movwf	((_ala))&0ffh
	line	109
	movlb	0	; () banked
	movf	((_rtc))&0ffh,w
	btfsc	status,2
	goto	u10861
	goto	u10860
u10861:
	goto	l9457
u10860:
	line	111
	
l9455:; BSR set to: 0

	movlw	low(04h)
	movwf	((_stateAlarm))&0ffh
	line	112
	goto	l9437
	line	115
	
l9457:; BSR set to: 0

	movlw	low(05h)
	movwf	((_stateAlarm))&0ffh
	goto	l9437
	line	118
	
l9459:; BSR set to: 1

	infsnz	(0+(_ala+02h))&0ffh
	incf	(1+(_ala+02h))&0ffh
		movf	(1+(_ala+02h))&0ffh,w
	bnz	u10870
	movlw	20
	subwf	 (0+(_ala+02h))&0ffh,w
	btfss	status,0
	goto	u10871
	goto	u10870

u10871:
	goto	l212
u10870:
	line	120
	
l9461:; BSR set to: 1

	movlw	high(0)
	movwf	(1+(_ala+02h))&0ffh
	movlw	low(0)
	movwf	(0+(_ala+02h))&0ffh
	line	121
	movlw	low(03h)
	movlb	0	; () banked
	movwf	((_stateAlarm))&0ffh
	line	122
	goto	l9437
	line	123
	
l212:; BSR set to: 1

	btfss	(0+(_ala+05h))&0ffh,0
	goto	u10881
	goto	u10880
u10881:
	goto	l9437
u10880:
	line	125
	
l9463:; BSR set to: 1

	bcf	(0+(_ala+05h))&0ffh,0
	line	126
	
l9465:; BSR set to: 1

	movlw	low(01h)
	movlb	0	; () banked
	movwf	((_stateAlarm))&0ffh
	goto	l9437
	line	131
	
l9467:; BSR set to: 0

	movlb	1	; () banked
	incf	(0+(_ala+04h))&0ffh
		decf	(0+(_ala+04h))&0ffh,w
	btfss	status,2
	goto	u10891
	goto	u10890

u10891:
	goto	l9475
u10890:
	line	134
	
l9469:; BSR set to: 1

	btfss	((_ala1))&0ffh,0
	goto	u10901
	goto	u10900
u10901:
	goto	l9447
u10900:
	line	136
	
l9471:; BSR set to: 1

	movlw	low(06h)
	movlb	0	; () banked
	movwf	((_stateAlarm))&0ffh
	line	137
	goto	l9437
	line	143
	
l9475:; BSR set to: 1

		movlw	2
	xorwf	(0+(_ala+04h))&0ffh,w
	btfss	status,2
	goto	u10911
	goto	u10910

u10911:
	goto	l9483
u10910:
	line	145
	
l9477:; BSR set to: 1

	btfss	((_ala2))&0ffh,0
	goto	u10921
	goto	u10920
u10921:
	goto	l9447
u10920:
	line	147
	
l9479:; BSR set to: 1

	movlw	low(07h)
	movlb	0	; () banked
	movwf	((_stateAlarm))&0ffh
	line	148
	goto	l9437
	line	154
	
l9483:; BSR set to: 1

		movlw	3
	xorwf	(0+(_ala+04h))&0ffh,w
	btfss	status,2
	goto	u10931
	goto	u10930

u10931:
	goto	l9491
u10930:
	line	156
	
l9485:; BSR set to: 1

	btfss	((_ala3))&0ffh,0
	goto	u10941
	goto	u10940
u10941:
	goto	l9447
u10940:
	line	158
	
l9487:; BSR set to: 1

	movlw	low(08h)
	movlb	0	; () banked
	movwf	((_stateAlarm))&0ffh
	line	159
	goto	l9437
	line	165
	
l9491:; BSR set to: 1

		movlw	4
	xorwf	(0+(_ala+04h))&0ffh,w
	btfss	status,2
	goto	u10951
	goto	u10950

u10951:
	goto	l9499
u10950:
	line	167
	
l9493:; BSR set to: 1

	btfss	((_ala4))&0ffh,0
	goto	u10961
	goto	u10960
u10961:
	goto	l9447
u10960:
	line	169
	
l9495:; BSR set to: 1

	movlw	low(09h)
	movlb	0	; () banked
	movwf	((_stateAlarm))&0ffh
	line	170
	goto	l9437
	line	176
	
l9499:; BSR set to: 1

		movlw	5
	xorwf	(0+(_ala+04h))&0ffh,w
	btfss	status,2
	goto	u10971
	goto	u10970

u10971:
	goto	l9437
u10970:
	line	178
	
l9501:; BSR set to: 1

	movlw	low(0)
	movwf	(0+(_ala+04h))&0ffh
	line	180
	
l9503:; BSR set to: 1

	btfss	((_ala5))&0ffh,0
	goto	u10981
	goto	u10980
u10981:
	goto	l9447
u10980:
	line	182
	
l9505:; BSR set to: 1

	movlw	low(0Ah)
	movlb	0	; () banked
	movwf	((_stateAlarm))&0ffh
	line	183
	goto	l9437
	line	192
	
l9509:; BSR set to: 0

		movlw	low(_rtc)
	movwf	((leerRtcSeg@segundos))&0ffh

	call	_leerRtcSeg	;wreg free
	goto	l9447
	line	201
	
l237:; BSR set to: 0

	line	203
	movlb	1	; () banked
	btfsc	((_ala1))&0ffh,1
	goto	u10991
	goto	u10990
u10991:
	goto	l195
u10990:
	line	205
	
l9517:; BSR set to: 1

		movlw	8
	xorwf	(0+(_ala1+01h))&0ffh,w
	btfss	status,2
	goto	u11001
	goto	u11000

u11001:
	goto	l9521
u11000:
	line	207
	
l9519:
	movlw	low(0Bh)
	movlb	0	; () banked
	movwf	((_stateAlarm))&0ffh
	line	208
	goto	l9437
	line	210
	
l9521:; BSR set to: 1

		movlw	9
	xorwf	(0+(_ala1+01h))&0ffh,w
	btfss	status,2
	goto	u11011
	goto	u11010

u11011:
	goto	l9531
u11010:
	line	213
	
l9523:; BSR set to: 1

	movlb	0	; () banked
	movf	(0+(_rtc+06h))&0ffh,w
	btfsc	status,2
	goto	u11021
	goto	u11020
u11021:
	goto	l9447
u11020:
	
l9525:; BSR set to: 0

		movlw	06h-0
	cpfslt	(0+(_rtc+06h))&0ffh
	goto	u11031
	goto	u11030

u11031:
	goto	l9447
u11030:
	goto	l9519
	line	223
	
l9531:; BSR set to: 1

		movlw	10
	xorwf	(0+(_ala1+01h))&0ffh,w
	btfss	status,2
	goto	u11041
	goto	u11040

u11041:
	goto	l9447
u11040:
	line	226
	
l9533:; BSR set to: 1

		movlw	6
	movlb	0	; () banked
	xorwf	(0+(_rtc+06h))&0ffh,w
	btfsc	status,2
	goto	u11051
	goto	u11050

u11051:
	goto	l9519
u11050:
	
l9535:; BSR set to: 0

		movlw	7
	xorwf	(0+(_rtc+06h))&0ffh,w
	btfss	status,2
	goto	u11061
	goto	u11060

u11061:
	goto	l9447
u11060:
	goto	l9519
	line	249
	
l252:; BSR set to: 0

	line	250
	movlb	1	; () banked
	btfsc	((_ala2))&0ffh,1
	goto	u11071
	goto	u11070
u11071:
	goto	l195
u11070:
	line	252
	
l9543:; BSR set to: 1

		movlw	8
	xorwf	(0+(_ala2+01h))&0ffh,w
	btfss	status,2
	goto	u11081
	goto	u11080

u11081:
	goto	l9547
u11080:
	line	254
	
l9545:
	movlw	low(0Ch)
	movlb	0	; () banked
	movwf	((_stateAlarm))&0ffh
	line	255
	goto	l9437
	line	257
	
l9547:; BSR set to: 1

		movlw	9
	xorwf	(0+(_ala2+01h))&0ffh,w
	btfss	status,2
	goto	u11091
	goto	u11090

u11091:
	goto	l9557
u11090:
	line	260
	
l9549:; BSR set to: 1

	movlb	0	; () banked
	movf	(0+(_rtc+06h))&0ffh,w
	btfsc	status,2
	goto	u11101
	goto	u11100
u11101:
	goto	l9447
u11100:
	
l9551:; BSR set to: 0

		movlw	06h-0
	cpfslt	(0+(_rtc+06h))&0ffh
	goto	u11111
	goto	u11110

u11111:
	goto	l9447
u11110:
	goto	l9545
	line	269
	
l9557:; BSR set to: 1

		movlw	10
	xorwf	(0+(_ala2+01h))&0ffh,w
	btfss	status,2
	goto	u11121
	goto	u11120

u11121:
	goto	l9447
u11120:
	line	272
	
l9559:; BSR set to: 1

		movlw	6
	movlb	0	; () banked
	xorwf	(0+(_rtc+06h))&0ffh,w
	btfsc	status,2
	goto	u11131
	goto	u11130

u11131:
	goto	l9545
u11130:
	
l9561:; BSR set to: 0

		movlw	7
	xorwf	(0+(_rtc+06h))&0ffh,w
	btfss	status,2
	goto	u11141
	goto	u11140

u11141:
	goto	l9447
u11140:
	goto	l9545
	line	292
	
l267:; BSR set to: 0

	line	293
	movlb	1	; () banked
	btfsc	((_ala3))&0ffh,1
	goto	u11151
	goto	u11150
u11151:
	goto	l195
u11150:
	line	295
	
l9569:; BSR set to: 1

		movlw	8
	xorwf	(0+(_ala3+01h))&0ffh,w
	btfss	status,2
	goto	u11161
	goto	u11160

u11161:
	goto	l9573
u11160:
	line	297
	
l9571:
	movlw	low(0Dh)
	movlb	0	; () banked
	movwf	((_stateAlarm))&0ffh
	line	298
	goto	l9437
	line	300
	
l9573:; BSR set to: 1

		movlw	9
	xorwf	(0+(_ala3+01h))&0ffh,w
	btfss	status,2
	goto	u11171
	goto	u11170

u11171:
	goto	l9583
u11170:
	line	303
	
l9575:; BSR set to: 1

	movlb	0	; () banked
	movf	(0+(_rtc+06h))&0ffh,w
	btfsc	status,2
	goto	u11181
	goto	u11180
u11181:
	goto	l9447
u11180:
	
l9577:; BSR set to: 0

		movlw	06h-0
	cpfslt	(0+(_rtc+06h))&0ffh
	goto	u11191
	goto	u11190

u11191:
	goto	l9447
u11190:
	goto	l9571
	line	312
	
l9583:; BSR set to: 1

		movlw	10
	xorwf	(0+(_ala3+01h))&0ffh,w
	btfss	status,2
	goto	u11201
	goto	u11200

u11201:
	goto	l9447
u11200:
	line	315
	
l9585:; BSR set to: 1

		movlw	6
	movlb	0	; () banked
	xorwf	(0+(_rtc+06h))&0ffh,w
	btfsc	status,2
	goto	u11211
	goto	u11210

u11211:
	goto	l9571
u11210:
	
l9587:; BSR set to: 0

		movlw	7
	xorwf	(0+(_rtc+06h))&0ffh,w
	btfss	status,2
	goto	u11221
	goto	u11220

u11221:
	goto	l9447
u11220:
	goto	l9571
	line	335
	
l282:; BSR set to: 0

	line	336
	movlb	1	; () banked
	btfsc	((_ala4))&0ffh,1
	goto	u11231
	goto	u11230
u11231:
	goto	l195
u11230:
	line	338
	
l9595:; BSR set to: 1

		movlw	8
	xorwf	(0+(_ala4+01h))&0ffh,w
	btfss	status,2
	goto	u11241
	goto	u11240

u11241:
	goto	l9599
u11240:
	line	340
	
l9597:
	movlw	low(0Eh)
	movlb	0	; () banked
	movwf	((_stateAlarm))&0ffh
	line	341
	goto	l9437
	line	343
	
l9599:; BSR set to: 1

		movlw	9
	xorwf	(0+(_ala4+01h))&0ffh,w
	btfss	status,2
	goto	u11251
	goto	u11250

u11251:
	goto	l9609
u11250:
	line	346
	
l9601:; BSR set to: 1

	movlb	0	; () banked
	movf	(0+(_rtc+06h))&0ffh,w
	btfsc	status,2
	goto	u11261
	goto	u11260
u11261:
	goto	l9447
u11260:
	
l9603:; BSR set to: 0

		movlw	06h-0
	cpfslt	(0+(_rtc+06h))&0ffh
	goto	u11271
	goto	u11270

u11271:
	goto	l9447
u11270:
	goto	l9597
	line	355
	
l9609:; BSR set to: 1

		movlw	10
	xorwf	(0+(_ala4+01h))&0ffh,w
	btfss	status,2
	goto	u11281
	goto	u11280

u11281:
	goto	l9447
u11280:
	line	358
	
l9611:; BSR set to: 1

		movlw	6
	movlb	0	; () banked
	xorwf	(0+(_rtc+06h))&0ffh,w
	btfsc	status,2
	goto	u11291
	goto	u11290

u11291:
	goto	l9597
u11290:
	
l9613:; BSR set to: 0

		movlw	7
	xorwf	(0+(_rtc+06h))&0ffh,w
	btfss	status,2
	goto	u11301
	goto	u11300

u11301:
	goto	l9447
u11300:
	goto	l9597
	line	378
	
l297:; BSR set to: 0

	line	379
	movlb	1	; () banked
	btfsc	((_ala5))&0ffh,1
	goto	u11311
	goto	u11310
u11311:
	goto	l195
u11310:
	line	381
	
l9621:; BSR set to: 1

		movlw	8
	xorwf	(0+(_ala5+01h))&0ffh,w
	btfss	status,2
	goto	u11321
	goto	u11320

u11321:
	goto	l9625
u11320:
	line	383
	
l9623:
	movlw	low(0Fh)
	movlb	0	; () banked
	movwf	((_stateAlarm))&0ffh
	line	384
	goto	l9437
	line	386
	
l9625:; BSR set to: 1

		movlw	9
	xorwf	(0+(_ala5+01h))&0ffh,w
	btfss	status,2
	goto	u11331
	goto	u11330

u11331:
	goto	l9635
u11330:
	line	389
	
l9627:; BSR set to: 1

	movlb	0	; () banked
	movf	(0+(_rtc+06h))&0ffh,w
	btfsc	status,2
	goto	u11341
	goto	u11340
u11341:
	goto	l9447
u11340:
	
l9629:; BSR set to: 0

		movlw	06h-0
	cpfslt	(0+(_rtc+06h))&0ffh
	goto	u11351
	goto	u11350

u11351:
	goto	l9447
u11350:
	goto	l9623
	line	398
	
l9635:; BSR set to: 1

		movlw	10
	xorwf	(0+(_ala5+01h))&0ffh,w
	btfss	status,2
	goto	u11361
	goto	u11360

u11361:
	goto	l9447
u11360:
	line	401
	
l9637:; BSR set to: 1

		movlw	6
	movlb	0	; () banked
	xorwf	(0+(_rtc+06h))&0ffh,w
	btfsc	status,2
	goto	u11371
	goto	u11370

u11371:
	goto	l9623
u11370:
	
l9639:; BSR set to: 0

		movlw	7
	xorwf	(0+(_rtc+06h))&0ffh,w
	btfss	status,2
	goto	u11381
	goto	u11380

u11381:
	goto	l9447
u11380:
	goto	l9623
	line	424
	
l9647:; BSR set to: 0

	movlb	1	; () banked
	movf	(0+(_ala1+0Ah))&0ffh,w
	movlb	0	; () banked
xorwf	(0+(_rtc+02h))&0ffh,w
	btfss	status,2
	goto	u11391
	goto	u11390

u11391:
	goto	l9653
u11390:
	line	426
	
l9649:; BSR set to: 0

	movlb	1	; () banked
	movf	(0+(_ala1+0Bh))&0ffh,w
	movlb	0	; () banked
xorwf	(0+(_rtc+01h))&0ffh,w
	btfss	status,2
	goto	u11401
	goto	u11400

u11401:
	goto	l9653
u11400:
	line	429
	
l9651:; BSR set to: 0

	movlb	2	; () banked
	bsf	(0+(_ap+08h))&0ffh,0
	line	435
	
l9653:
	movlb	1	; () banked
	movf	(0+(_ala1+0Ch))&0ffh,w
	movlb	0	; () banked
xorwf	(0+(_rtc+02h))&0ffh,w
	btfss	status,2
	goto	u11411
	goto	u11410

u11411:
	goto	l9447
u11410:
	line	437
	
l9655:; BSR set to: 0

	movlb	1	; () banked
	movf	(0+(_ala1+0Dh))&0ffh,w
	movlb	0	; () banked
xorwf	(0+(_rtc+01h))&0ffh,w
	btfss	status,2
	goto	u11421
	goto	u11420

u11421:
	goto	l9447
u11420:
	line	440
	
l9657:; BSR set to: 0

	movlb	2	; () banked
	bcf	(0+(_ap+08h))&0ffh,0
	goto	l9447
	line	452
	
l9661:; BSR set to: 0

	movlb	1	; () banked
	movf	(0+(_ala2+0Ah))&0ffh,w
	movlb	0	; () banked
xorwf	(0+(_rtc+02h))&0ffh,w
	btfss	status,2
	goto	u11431
	goto	u11430

u11431:
	goto	l9667
u11430:
	line	454
	
l9663:; BSR set to: 0

	movlb	1	; () banked
	movf	(0+(_ala2+0Bh))&0ffh,w
	movlb	0	; () banked
xorwf	(0+(_rtc+01h))&0ffh,w
	btfss	status,2
	goto	u11441
	goto	u11440

u11441:
	goto	l9667
u11440:
	line	457
	
l9665:; BSR set to: 0

	movlb	2	; () banked
	bsf	(0+(_ap+08h))&0ffh,0
	line	463
	
l9667:
	movlb	1	; () banked
	movf	(0+(_ala2+0Ch))&0ffh,w
	movlb	0	; () banked
xorwf	(0+(_rtc+02h))&0ffh,w
	btfss	status,2
	goto	u11451
	goto	u11450

u11451:
	goto	l9447
u11450:
	line	465
	
l9669:; BSR set to: 0

	movlb	1	; () banked
	movf	(0+(_ala2+0Dh))&0ffh,w
	movlb	0	; () banked
xorwf	(0+(_rtc+01h))&0ffh,w
	btfss	status,2
	goto	u11461
	goto	u11460

u11461:
	goto	l9447
u11460:
	goto	l9657
	line	480
	
l9675:; BSR set to: 0

	movlb	1	; () banked
	movf	(0+(_ala3+0Ah))&0ffh,w
	movlb	0	; () banked
xorwf	(0+(_rtc+02h))&0ffh,w
	btfss	status,2
	goto	u11471
	goto	u11470

u11471:
	goto	l9681
u11470:
	line	482
	
l9677:; BSR set to: 0

	movlb	1	; () banked
	movf	(0+(_ala3+0Bh))&0ffh,w
	movlb	0	; () banked
xorwf	(0+(_rtc+01h))&0ffh,w
	btfss	status,2
	goto	u11481
	goto	u11480

u11481:
	goto	l9681
u11480:
	line	485
	
l9679:; BSR set to: 0

	movlb	2	; () banked
	bsf	(0+(_ap+08h))&0ffh,0
	line	491
	
l9681:
	movlb	1	; () banked
	movf	(0+(_ala3+0Ch))&0ffh,w
	movlb	0	; () banked
xorwf	(0+(_rtc+02h))&0ffh,w
	btfss	status,2
	goto	u11491
	goto	u11490

u11491:
	goto	l9447
u11490:
	line	493
	
l9683:; BSR set to: 0

	movlb	1	; () banked
	movf	(0+(_ala3+0Dh))&0ffh,w
	movlb	0	; () banked
xorwf	(0+(_rtc+01h))&0ffh,w
	btfss	status,2
	goto	u11501
	goto	u11500

u11501:
	goto	l9447
u11500:
	goto	l9657
	line	507
	
l9689:; BSR set to: 0

	movlb	1	; () banked
	movf	(0+(_ala4+0Ah))&0ffh,w
	movlb	0	; () banked
xorwf	(0+(_rtc+02h))&0ffh,w
	btfss	status,2
	goto	u11511
	goto	u11510

u11511:
	goto	l9695
u11510:
	line	509
	
l9691:; BSR set to: 0

	movlb	1	; () banked
	movf	(0+(_ala4+0Bh))&0ffh,w
	movlb	0	; () banked
xorwf	(0+(_rtc+01h))&0ffh,w
	btfss	status,2
	goto	u11521
	goto	u11520

u11521:
	goto	l9695
u11520:
	line	512
	
l9693:; BSR set to: 0

	movlb	2	; () banked
	bsf	(0+(_ap+08h))&0ffh,0
	line	518
	
l9695:
	movlb	1	; () banked
	movf	(0+(_ala4+0Ch))&0ffh,w
	movlb	0	; () banked
xorwf	(0+(_rtc+02h))&0ffh,w
	btfss	status,2
	goto	u11531
	goto	u11530

u11531:
	goto	l9447
u11530:
	line	520
	
l9697:; BSR set to: 0

	movlb	1	; () banked
	movf	(0+(_ala4+0Dh))&0ffh,w
	movlb	0	; () banked
xorwf	(0+(_rtc+01h))&0ffh,w
	btfss	status,2
	goto	u11541
	goto	u11540

u11541:
	goto	l9447
u11540:
	goto	l9657
	line	534
	
l9703:; BSR set to: 0

	movlb	1	; () banked
	movf	(0+(_ala5+0Ah))&0ffh,w
	movlb	0	; () banked
xorwf	(0+(_rtc+02h))&0ffh,w
	btfss	status,2
	goto	u11551
	goto	u11550

u11551:
	goto	l9709
u11550:
	line	536
	
l9705:; BSR set to: 0

	movlb	1	; () banked
	movf	(0+(_ala5+0Bh))&0ffh,w
	movlb	0	; () banked
xorwf	(0+(_rtc+01h))&0ffh,w
	btfss	status,2
	goto	u11561
	goto	u11560

u11561:
	goto	l9709
u11560:
	line	539
	
l9707:; BSR set to: 0

	movlb	2	; () banked
	bsf	(0+(_ap+08h))&0ffh,0
	line	545
	
l9709:
	movlb	1	; () banked
	movf	(0+(_ala5+0Ch))&0ffh,w
	movlb	0	; () banked
xorwf	(0+(_rtc+02h))&0ffh,w
	btfss	status,2
	goto	u11571
	goto	u11570

u11571:
	goto	l9447
u11570:
	line	547
	
l9711:; BSR set to: 0

	movlb	1	; () banked
	movf	(0+(_ala5+0Dh))&0ffh,w
	movlb	0	; () banked
xorwf	(0+(_rtc+01h))&0ffh,w
	btfss	status,2
	goto	u11581
	goto	u11580

u11581:
	goto	l9447
u11580:
	goto	l9657
	line	558
	
l9719:; BSR set to: 0

	movf	((_stateAlarm))&0ffh,w
	movwf	(??_taskAlarm+0+0)&0ffh
	clrf	(??_taskAlarm+0+0+1)&0ffh

	; Switch on 2 bytes has been partitioned into a top level switch of size 1, and 1 sub-switches
; Switch size 1, requested type "simple"
; Number of cases is 1, Range of values is 0 to 0
; switch strategies available:
; Name         Instructions Cycles
; simple_byte            4     3 (average)
;	Chosen strategy is simple_byte

	movf ??_taskAlarm+0+1&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l18609
	goto	l9437
	
l18609:; BSR set to: 0

; Switch size 1, requested type "simple"
; Number of cases is 16, Range of values is 0 to 15
; switch strategies available:
; Name         Instructions Cycles
; simple_byte           49    25 (average)
;	Chosen strategy is simple_byte

	movf ??_taskAlarm+0+0&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l203
	xorlw	1^0	; case 1
	skipnz
	goto	l206
	xorlw	2^1	; case 2
	skipnz
	goto	l9451
	xorlw	3^2	; case 3
	skipnz
	goto	l9467
	xorlw	4^3	; case 4
	skipnz
	goto	l9509
	xorlw	5^4	; case 5
	skipnz
	goto	l9445
	xorlw	6^5	; case 6
	skipnz
	goto	l237
	xorlw	7^6	; case 7
	skipnz
	goto	l252
	xorlw	8^7	; case 8
	skipnz
	goto	l267
	xorlw	9^8	; case 9
	skipnz
	goto	l282
	xorlw	10^9	; case 10
	skipnz
	goto	l297
	xorlw	11^10	; case 11
	skipnz
	goto	l9647
	xorlw	12^11	; case 12
	skipnz
	goto	l9661
	xorlw	13^12	; case 13
	skipnz
	goto	l9675
	xorlw	14^13	; case 14
	skipnz
	goto	l9689
	xorlw	15^14	; case 15
	skipnz
	goto	l9703
	goto	l9437

	line	560
	
l9721:; BSR set to: 0

	movff	(taskAlarm@pt),fsr2l
	movff	(taskAlarm@pt+1),fsr2h
	movff	postinc2,??_taskAlarm+0+0
	movff	postdec2,??_taskAlarm+0+0+1
	; Switch on 2 bytes has been partitioned into a top level switch of size 1, and 1 sub-switches
; Switch size 1, requested type "simple"
; Number of cases is 1, Range of values is 0 to 0
; switch strategies available:
; Name         Instructions Cycles
; simple_byte            4     3 (average)
;	Chosen strategy is simple_byte

	movf ??_taskAlarm+0+1&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l18611
	goto	l9723
	
l18611:; BSR set to: 0

; Switch size 1, requested type "simple"
; Number of cases is 2, Range of values is 0 to 47
; switch strategies available:
; Name         Instructions Cycles
; simple_byte            7     4 (average)
;	Chosen strategy is simple_byte

	movf ??_taskAlarm+0+0&0ffh,w
	xorlw	0^0	; case 0
	skipnz
	goto	l9437
	xorlw	47^0	; case 47
	skipnz
	goto	l9441
	goto	l9723

	
l9723:; BSR set to: 0

	
l9725:; BSR set to: 0

	movff	(taskAlarm@pt),fsr2l
	movff	(taskAlarm@pt+1),fsr2h
	movlw	low(0)
	movwf	postinc2,c
	movlw	high(0)
	movwf	postdec2,c
	line	561
	
l200:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_taskAlarm
	__end_of_taskAlarm:
	signat	_taskAlarm,4218
	global	_leerRtcSeg

;; *************** function _leerRtcSeg *****************
;; Defined at:
;;		line 19 in file "DS1307.c"
;; Parameters:    Size  Location     Type
;;  segundos        1   41[BANK0 ] PTR unsigned char 
;;		 -> rtc(7), 
;; Auto vars:     Size  Location     Type
;;  dirSeg          1    0        unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       1       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       1       0       0       0       0       0       0       0
;;Total ram usage:        1 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 14
;; This function calls:
;;		_BCD_a_Decimal
;;		_I2C_Master_Read
;;		_I2C_Master_Write
;;		_I2C_Repeated_Start
;;		_I2C_Start
;;		_I2C_Stop
;; This function is called by:
;;		_taskAlarm
;; This function uses a non-reentrant model
;;
psect	text67,class=CODE,space=0,reloc=2,group=0
	file	"DS1307.c"
	line	19
global __ptext67
__ptext67:
psect	text67
	file	"DS1307.c"
	line	19
	
_leerRtcSeg:; BSR set to: 0

;incstack = 0
	callstack 14
	line	21
	
l9037:; BSR set to: 0

	line	23
	
l9039:; BSR set to: 0

	call	_I2C_Start	;wreg free
	line	24
	
l9041:; BSR set to: 0

	movlw	(0D0h)&0ffh
	
	call	_I2C_Master_Write
	line	25
	
l9043:; BSR set to: 0

	movlw	(0)&0ffh
	
	call	_I2C_Master_Write
	line	26
	
l9045:; BSR set to: 0

	call	_I2C_Repeated_Start	;wreg free
	line	27
	
l9047:; BSR set to: 0

	movlw	(0D1h)&0ffh
	
	call	_I2C_Master_Write
	line	28
	
l9049:; BSR set to: 0

	movf	((leerRtcSeg@segundos))&0ffh,w
	movwf	fsr2l
	clrf	fsr2h
	movlw	(0)&0ffh
	
	call	_I2C_Master_Read
	
	call	_BCD_a_Decimal
	movwf	indf2,c

	line	29
	
l9051:; BSR set to: 0

	call	_I2C_Stop	;wreg free
	line	31
	
l643:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_leerRtcSeg
	__end_of_leerRtcSeg:
	signat	_leerRtcSeg,4217
	global	_leerRTC

;; *************** function _leerRTC *****************
;; Defined at:
;;		line 33 in file "DS1307.c"
;; Parameters:    Size  Location     Type
;;  hora            1   41[BANK0 ] PTR unsigned char 
;;		 -> rtc(7), 
;;  minutos         1   42[BANK0 ] PTR unsigned char 
;;		 -> rtc(7), 
;;  segundos        1   43[BANK0 ] PTR unsigned char 
;;		 -> rtc(7), 
;;  dia             1   44[BANK0 ] PTR unsigned char 
;;		 -> rtc(7), 
;;  mes             1   45[BANK0 ] PTR unsigned char 
;;		 -> rtc(7), 
;;  ano             1   46[BANK0 ] PTR unsigned char 
;;		 -> rtc(7), 
;;  diaSe           1   47[BANK0 ] PTR unsigned char 
;;		 -> rtc(7), 
;; Auto vars:     Size  Location     Type
;;  rtc             7   55[BANK0 ] unsigned char [7]
;;  rtc_dir         7   48[BANK0 ] const unsigned char [7]
;;  i               1   62[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       7       0       0       0       0       0       0       0
;;      Locals:         0      15       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0      22       0       0       0       0       0       0       0
;;Total ram usage:       22 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 14
;; This function calls:
;;		_BCD_a_Decimal
;;		_I2C_Master_Read
;;		_I2C_Master_Write
;;		_I2C_Repeated_Start
;;		_I2C_Start
;;		_I2C_Stop
;; This function is called by:
;;		_taskAlarm
;; This function uses a non-reentrant model
;;
psect	text68,class=CODE,space=0,reloc=2,group=0
	line	33
global __ptext68
__ptext68:
psect	text68
	file	"DS1307.c"
	line	33
	
_leerRTC:; BSR set to: 0

;incstack = 0
	callstack 14
	line	37
	
l9011:; BSR set to: 0

	movlw	low((leerRTC@F2903))
	movwf	tblptrl
	if	1	;There is more than 1 active tblptr byte
	movlw	high((leerRTC@F2903))
	movwf	tblptrh
	endif
	if	0	;There are less than 3 active tblptr bytes
	movlw	low highword((leerRTC@F2903))
	movwf	tblptru
	endif
	lfsr	2,(leerRTC@rtc_dir)
	movlw	7-1
u10230:
	tblrd*+
	
	movff	tablat,postinc2
	decf	wreg
	bc	u10230
	line	39
	
l9013:; BSR set to: 0

	movlw	low(0)
	movwf	((leerRTC@i))&0ffh
	line	41
	
l9019:; BSR set to: 0

	call	_I2C_Start	;wreg free
	line	42
	movlw	(0D0h)&0ffh
	
	call	_I2C_Master_Write
	line	43
	
l9021:; BSR set to: 0

	movf	((leerRTC@i))&0ffh,w
	addlw	low(leerRTC@rtc_dir)
	movwf	fsr2l
	clrf	fsr2h
	movf	indf2,w
	
	call	_I2C_Master_Write
	line	44
	
l9023:; BSR set to: 0

	call	_I2C_Repeated_Start	;wreg free
	line	45
	
l9025:; BSR set to: 0

	movlw	(0D1h)&0ffh
	
	call	_I2C_Master_Write
	line	46
	
l9027:; BSR set to: 0

	movf	((leerRTC@i))&0ffh,w
	addlw	low(leerRTC@rtc)
	movwf	fsr2l
	clrf	fsr2h
	movlw	(0)&0ffh
	
	call	_I2C_Master_Read
	
	call	_BCD_a_Decimal
	movwf	indf2,c

	line	47
	
l9029:; BSR set to: 0

	call	_I2C_Stop	;wreg free
	line	48
	
l9031:; BSR set to: 0

	incf	((leerRTC@i))&0ffh
	
l9033:; BSR set to: 0

		movlw	07h-1
	cpfsgt	((leerRTC@i))&0ffh
	goto	u10241
	goto	u10240

u10241:
	goto	l9019
u10240:
	line	51
	
l9035:; BSR set to: 0

	movf	((leerRTC@hora))&0ffh,w
	movwf	fsr2l
	clrf	fsr2h
	movff	0+(leerRTC@rtc+02h),indf2

	line	52
	movf	((leerRTC@minutos))&0ffh,w
	movwf	fsr2l
	clrf	fsr2h
	movff	0+(leerRTC@rtc+01h),indf2

	line	53
	movf	((leerRTC@segundos))&0ffh,w
	movwf	fsr2l
	clrf	fsr2h
	movff	(leerRTC@rtc),indf2

	line	54
	movf	((leerRTC@dia))&0ffh,w
	movwf	fsr2l
	clrf	fsr2h
	movff	0+(leerRTC@rtc+03h),indf2

	line	55
	movf	((leerRTC@mes))&0ffh,w
	movwf	fsr2l
	clrf	fsr2h
	movff	0+(leerRTC@rtc+04h),indf2

	line	56
	movf	((leerRTC@ano))&0ffh,w
	movwf	fsr2l
	clrf	fsr2h
	movff	0+(leerRTC@rtc+05h),indf2

	line	57
	movf	((leerRTC@diaSe))&0ffh,w
	movwf	fsr2l
	clrf	fsr2h
	movff	0+(leerRTC@rtc+06h),indf2

	line	58
	
l650:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_leerRTC
	__end_of_leerRTC:
	signat	_leerRTC,28793
	global	_I2C_Stop

;; *************** function _I2C_Stop *****************
;; Defined at:
;;		line 34 in file "I2C.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 13
;; This function calls:
;;		_I2C_Master_Wait
;; This function is called by:
;;		_leerRtcSeg
;;		_leerRTC
;;		_escribirRTC
;; This function uses a non-reentrant model
;;
psect	text69,class=CODE,space=0,reloc=2,group=0
	file	"I2C.c"
	line	34
global __ptext69
__ptext69:
psect	text69
	file	"I2C.c"
	line	34
	
_I2C_Stop:; BSR set to: 0

;incstack = 0
	callstack 14
	line	35
	
l5817:; BSR set to: 0

	call	_I2C_Master_Wait	;wreg free
	line	36
	
l5819:; BSR set to: 0

	bsf	((c:4037))^0f00h,c,2	;volatile
	line	37
	
l711:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_I2C_Stop
	__end_of_I2C_Stop:
	signat	_I2C_Stop,89
	global	_I2C_Start

;; *************** function _I2C_Start *****************
;; Defined at:
;;		line 29 in file "I2C.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 13
;; This function calls:
;;		_I2C_Master_Wait
;; This function is called by:
;;		_leerRtcSeg
;;		_leerRTC
;;		_escribirRTC
;; This function uses a non-reentrant model
;;
psect	text70,class=CODE,space=0,reloc=2,group=0
	line	29
global __ptext70
__ptext70:
psect	text70
	file	"I2C.c"
	line	29
	
_I2C_Start:; BSR set to: 0

;incstack = 0
	callstack 14
	line	30
	
l5791:
	call	_I2C_Master_Wait	;wreg free
	line	31
	
l5793:; BSR set to: 0

	bsf	((c:4037))^0f00h,c,0	;volatile
	line	32
	
l708:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_I2C_Start
	__end_of_I2C_Start:
	signat	_I2C_Start,89
	global	_I2C_Repeated_Start

;; *************** function _I2C_Repeated_Start *****************
;; Defined at:
;;		line 39 in file "I2C.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 13
;; This function calls:
;;		_I2C_Master_Wait
;; This function is called by:
;;		_leerRtcSeg
;;		_leerRTC
;; This function uses a non-reentrant model
;;
psect	text71,class=CODE,space=0,reloc=2,group=0
	line	39
global __ptext71
__ptext71:
psect	text71
	file	"I2C.c"
	line	39
	
_I2C_Repeated_Start:; BSR set to: 0

;incstack = 0
	callstack 14
	line	40
	
l5799:; BSR set to: 0

	call	_I2C_Master_Wait	;wreg free
	line	41
	
l5801:; BSR set to: 0

	bsf	((c:4037))^0f00h,c,1	;volatile
	line	42
	
l714:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_I2C_Repeated_Start
	__end_of_I2C_Repeated_Start:
	signat	_I2C_Repeated_Start,89
	global	_I2C_Master_Write

;; *************** function _I2C_Master_Write *****************
;; Defined at:
;;		line 44 in file "I2C.c"
;; Parameters:    Size  Location     Type
;;  dato            1    wreg     unsigned char 
;; Auto vars:     Size  Location     Type
;;  dato            1   38[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       1       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       1       0       0       0       0       0       0       0
;;Total ram usage:        1 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 13
;; This function calls:
;;		_I2C_Master_Wait
;; This function is called by:
;;		_leerRtcSeg
;;		_leerRTC
;;		_escribirRTC
;; This function uses a non-reentrant model
;;
psect	text72,class=CODE,space=0,reloc=2,group=0
	line	44
global __ptext72
__ptext72:
psect	text72
	file	"I2C.c"
	line	44
	
_I2C_Master_Write:; BSR set to: 0

;incstack = 0
	callstack 14
	movwf	((I2C_Master_Write@dato))&0ffh
	line	45
	
l5795:
	call	_I2C_Master_Wait	;wreg free
	line	46
	
l5797:; BSR set to: 0

	movff	(I2C_Master_Write@dato),(c:4041)	;volatile
	line	47
	
l717:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_I2C_Master_Write
	__end_of_I2C_Master_Write:
	signat	_I2C_Master_Write,4217
	global	_I2C_Master_Read

;; *************** function _I2C_Master_Read *****************
;; Defined at:
;;		line 49 in file "I2C.c"
;; Parameters:    Size  Location     Type
;;  ACK             1    wreg     unsigned char 
;; Auto vars:     Size  Location     Type
;;  ACK             1   39[BANK0 ] unsigned char 
;;  dato            1   40[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      unsigned char 
;; Registers used:
;;		wreg, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       2       0       0       0       0       0       0       0
;;      Temps:          0       1       0       0       0       0       0       0       0
;;      Totals:         0       3       0       0       0       0       0       0       0
;;Total ram usage:        3 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 13
;; This function calls:
;;		_I2C_Master_Wait
;; This function is called by:
;;		_leerRtcSeg
;;		_leerRTC
;; This function uses a non-reentrant model
;;
psect	text73,class=CODE,space=0,reloc=2,group=0
	line	49
global __ptext73
__ptext73:
psect	text73
	file	"I2C.c"
	line	49
	
_I2C_Master_Read:; BSR set to: 0

;incstack = 0
	callstack 14
	movwf	((I2C_Master_Read@ACK))&0ffh
	line	51
	
l5803:
	call	_I2C_Master_Wait	;wreg free
	line	52
	
l5805:; BSR set to: 0

	bsf	((c:4037))^0f00h,c,3	;volatile
	line	53
	call	_I2C_Master_Wait	;wreg free
	line	54
	
l5807:; BSR set to: 0

	movff	(c:4041),(I2C_Master_Read@dato)	;volatile
	line	55
	call	_I2C_Master_Wait	;wreg free
	line	59
	
l5809:; BSR set to: 0

	movf	((I2C_Master_Read@ACK))&0ffh,w
	btfsc	status,2
	goto	u5531
	goto	u5530
u5531:
	clrf	(??_I2C_Master_Read+0+0)&0ffh
	incf	(??_I2C_Master_Read+0+0)&0ffh
	goto	u5548
u5530:
	movlb	0	; () banked
	clrf	(??_I2C_Master_Read+0+0)&0ffh
u5548:
	swapf	(??_I2C_Master_Read+0+0)&0ffh
	rlncf	(??_I2C_Master_Read+0+0)&0ffh
	movf	((c:4037))^0f00h,c,w	;volatile
	xorwf	(??_I2C_Master_Read+0+0)&0ffh,w
	andlw	not (((1<<1)-1)<<5)
	xorwf	(??_I2C_Master_Read+0+0)&0ffh,w
	movwf	((c:4037))^0f00h,c	;volatile
	line	64
	
l5811:; BSR set to: 0

	bsf	((c:4037))^0f00h,c,4	;volatile
	line	65
	
l5813:; BSR set to: 0

	movf	((I2C_Master_Read@dato))&0ffh,w
	line	66
	
l720:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_I2C_Master_Read
	__end_of_I2C_Master_Read:
	signat	_I2C_Master_Read,4217
	global	_I2C_Master_Wait

;; *************** function _I2C_Master_Wait *****************
;; Defined at:
;;		line 25 in file "I2C.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       1       0       0       0       0       0       0       0
;;      Totals:         0       1       0       0       0       0       0       0       0
;;Total ram usage:        1 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_I2C_Start
;;		_I2C_Stop
;;		_I2C_Repeated_Start
;;		_I2C_Master_Write
;;		_I2C_Master_Read
;; This function uses a non-reentrant model
;;
psect	text74,class=CODE,space=0,reloc=2,group=0
	line	25
global __ptext74
__ptext74:
psect	text74
	file	"I2C.c"
	line	25
	
_I2C_Master_Wait:; BSR set to: 0

;incstack = 0
	callstack 14
	line	26
	
l5539:
	
l5541:
	movff	(c:4037),??_I2C_Master_Wait+0+0	;volatile
	movlw	01Fh
	movlb	0	; () banked
	andwf	(??_I2C_Master_Wait+0+0)&0ffh
	btfss	status,2
	goto	u5161
	goto	u5160
u5161:
	goto	l5541
u5160:
	
l5543:; BSR set to: 0

	
	btfsc	((c:4039))^0f00h,c,(2)&7	;volatile
	goto	u5171
	goto	u5170
u5171:
	goto	l5541
u5170:
	line	27
	
l705:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_I2C_Master_Wait
	__end_of_I2C_Master_Wait:
	signat	_I2C_Master_Wait,89
	global	_BCD_a_Decimal

;; *************** function _BCD_a_Decimal *****************
;; Defined at:
;;		line 11 in file "DS1307.c"
;; Parameters:    Size  Location     Type
;;  numero          1    wreg     unsigned char 
;; Auto vars:     Size  Location     Type
;;  numero          1   38[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      unsigned char 
;; Registers used:
;;		wreg, status,2, status,0, prodl, prodh
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       1       0       0       0       0       0       0       0
;;      Temps:          0       1       0       0       0       0       0       0       0
;;      Totals:         0       2       0       0       0       0       0       0       0
;;Total ram usage:        2 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_leerRtcSeg
;;		_leerRTC
;; This function uses a non-reentrant model
;;
psect	text75,class=CODE,space=0,reloc=2,group=0
	file	"DS1307.c"
	line	11
global __ptext75
__ptext75:
psect	text75
	file	"DS1307.c"
	line	11
	
_BCD_a_Decimal:; BSR set to: 0

;incstack = 0
	callstack 15
	movwf	((BCD_a_Decimal@numero))&0ffh
	line	12
	
l5783:
	movff	(BCD_a_Decimal@numero),??_BCD_a_Decimal+0+0
	movlw	0Fh
	movlb	0	; () banked
	andwf	(??_BCD_a_Decimal+0+0)&0ffh
	swapf	((BCD_a_Decimal@numero))&0ffh,w
	andlw	(0ffh shr 4) & 0ffh
	mullw	0Ah
	movf	(prodl)^0f00h,c,w
	addwf	(??_BCD_a_Decimal+0+0)&0ffh,w
	line	13
	
l637:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_BCD_a_Decimal
	__end_of_BCD_a_Decimal:
	signat	_BCD_a_Decimal,4217
	global	_getMillis

;; *************** function _getMillis *****************
;; Defined at:
;;		line 15 in file "TimeBase.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  4   37[BANK0 ] unsigned long 
;; Registers used:
;;		None
;; Tracked objects:
;;		On entry : 3C/1
;;		On exit  : 3C/0
;;		Unchanged: 3C/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       4       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       4       0       0       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_taskAlarm
;;		_taskAplicacion
;;		_taskBuzzer
;;		_taskCluster
;;		_taskLedLive
;;		_taskAnalizaUart1
;; This function uses a non-reentrant model
;;
psect	text76,class=CODE,space=0,reloc=2,group=0
	file	"TimeBase.c"
	line	15
global __ptext76
__ptext76:
psect	text76
	file	"TimeBase.c"
	line	15
	
_getMillis:; BSR set to: 0

;incstack = 0
	callstack 16
	line	17
	
l6005:
	movff	(_ulCntTick1ms),(?_getMillis)
	movff	(_ulCntTick1ms+1),(?_getMillis+1)
	movff	(_ulCntTick1ms+2),(?_getMillis+2)
	movff	(_ulCntTick1ms+3),(?_getMillis+3)
	line	18
	
l946:
	return	;funcret
	callstack 0
GLOBAL	__end_of_getMillis
	__end_of_getMillis:
	signat	_getMillis,92
	global	_UART_init_baud

;; *************** function _UART_init_baud *****************
;; Defined at:
;;		line 20 in file "./UART.h"
;; Parameters:    Size  Location     Type
;;  baudRate        4   37[BANK0 ] const long 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 3F/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       4       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       4       0       0       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text77,class=CODE,space=0,reloc=2,group=0
	file	"./UART.h"
	line	20
global __ptext77
__ptext77:
psect	text77
	file	"./UART.h"
	line	20
	
_UART_init_baud:
;incstack = 0
	callstack 18
	line	26
	
l7821:; BSR set to: 0

	bcf	((c:4012))^0f00h,c,2	;volatile
	line	28
	bsf	((c:3988))^0f00h,c,7	;volatile
	line	29
	bcf	((c:3988))^0f00h,c,6	;volatile
	line	31
	bcf	((c:4012))^0f00h,c,4	;volatile
	line	32
	bcf	((c:4012))^0f00h,c,6	;volatile
	line	34
	
l7823:; BSR set to: 0

	movlw	low(020h)
	movwf	((c:4015))^0f00h,c	;volatile
	line	36
	
l7825:; BSR set to: 0

	bsf	((c:4011))^0f00h,c,7	;volatile
	line	37
	
l7827:; BSR set to: 0

	bsf	((c:4012))^0f00h,c,5	;volatile
	line	38
	
l7829:; BSR set to: 0

	bsf	((c:4011))^0f00h,c,4	;volatile
	line	41
	
l7831:; BSR set to: 0

	bsf	((c:3997))^0f00h,c,5	;volatile
	line	42
	
l104:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_UART_init_baud
	__end_of_UART_init_baud:
	signat	_UART_init_baud,4217
	global	_INT_init

;; *************** function _INT_init *****************
;; Defined at:
;;		line 148 in file "main.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text78,class=CODE,space=0,reloc=2,group=0
	file	"main.c"
	line	148
global __ptext78
__ptext78:
psect	text78
	file	"main.c"
	line	148
	
_INT_init:; BSR set to: 0

;incstack = 0
	callstack 18
	line	152
	
l7859:
	bsf	((c:4048))^0f00h,c,7	;volatile
	line	153
	bsf	((c:4082))^0f00h,c,7	;volatile
	line	154
	bsf	((c:4082))^0f00h,c,6	;volatile
	line	157
	bsf	((c:4082))^0f00h,c,5	;volatile
	line	158
	bsf	((c:4082))^0f00h,c,7	;volatile
	line	162
	
l7861:
	movlw	high(0FFECh)
	movwf	((c:4054+1))^0f00h,c	;volatile
	movlw	low(0FFECh)
	movwf	((c:4054))^0f00h,c	;volatile
	line	163
	movlw	low(087h)
	movwf	((c:4053))^0f00h,c	;volatile
	line	164
	
l152:
	return	;funcret
	callstack 0
GLOBAL	__end_of_INT_init
	__end_of_INT_init:
	signat	_INT_init,89
	global	_I2C_Master_Init

;; *************** function _I2C_Master_Init *****************
;; Defined at:
;;		line 9 in file "I2C.c"
;; Parameters:    Size  Location     Type
;;  clock           4   16[BANK2 ] unsigned long 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2, status,0, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3F/2
;;		On exit  : 3F/2
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       4       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       4       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 13
;; This function calls:
;;		___fladd
;;		___fldiv
;;		___flmul
;;		___fltol
;;		___xxtofl
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text79,class=CODE,space=0,reloc=2,group=0
	file	"I2C.c"
	line	9
global __ptext79
__ptext79:
psect	text79
	file	"I2C.c"
	line	9
	
_I2C_Master_Init:
;incstack = 0
	callstack 17
	line	11
	
l18205:; BSR set to: 2

	bsf	((c:3987))^0f00h,c,0	;volatile
	line	12
	bsf	((c:3987))^0f00h,c,1	;volatile
	line	14
	bsf	((c:4039))^0f00h,c,7	;volatile
	line	15
	bsf	((c:4038))^0f00h,c,5	;volatile
	line	16
	
l18207:; BSR set to: 2

	movf	((c:4038))^0f00h,c,w	;volatile
	andlw	not (((1<<4)-1)<<0)
	iorlw	(08h & ((1<<4)-1))<<0
	movwf	((c:4038))^0f00h,c	;volatile
	line	20
	
l18209:; BSR set to: 2

	movlw	low(normalize32(0xbf800000))
	movwf	((___fladd@a))&0ffh
	movlw	high(normalize32(0xbf800000))
	movwf	((___fladd@a+1))&0ffh
	movlw	low highword(normalize32(0xbf800000))
	movwf	((___fladd@a+2))&0ffh
	movlw	high highword(normalize32(0xbf800000))
	movwf	((___fladd@a+3))&0ffh
	movlw	low(normalize32(0x40800000))
	movlb	0	; () banked
	movwf	((___flmul@a))&0ffh
	movlw	high(normalize32(0x40800000))
	movwf	((___flmul@a+1))&0ffh
	movlw	low highword(normalize32(0x40800000))
	movwf	((___flmul@a+2))&0ffh
	movlw	high highword(normalize32(0x40800000))
	movwf	((___flmul@a+3))&0ffh
	movff	(I2C_Master_Init@clock),(___xxtofl@val)
	movff	(I2C_Master_Init@clock+1),(___xxtofl@val+1)
	movff	(I2C_Master_Init@clock+2),(___xxtofl@val+2)
	movff	(I2C_Master_Init@clock+3),(___xxtofl@val+3)
	movlw	(0)&0ffh
	
	call	___xxtofl
	movff	0+?___xxtofl,(___flmul@b)
	movff	1+?___xxtofl,(___flmul@b+1)
	movff	2+?___xxtofl,(___flmul@b+2)
	movff	3+?___xxtofl,(___flmul@b+3)
	
	call	___flmul	;wreg free
	movff	0+?___flmul,(___fldiv@a)
	movff	1+?___flmul,(___fldiv@a+1)
	movff	2+?___flmul,(___fldiv@a+2)
	movff	3+?___flmul,(___fldiv@a+3)
	
	movlw	low(normalize32(0x4b989680))
	movwf	((___fldiv@b))&0ffh
	movlw	high(normalize32(0x4b989680))
	movwf	((___fldiv@b+1))&0ffh
	movlw	low highword(normalize32(0x4b989680))
	movwf	((___fldiv@b+2))&0ffh
	movlw	high highword(normalize32(0x4b989680))
	movwf	((___fldiv@b+3))&0ffh
	call	___fldiv	;wreg free
	movff	0+?___fldiv,(___fladd@b)
	movff	1+?___fldiv,(___fladd@b+1)
	movff	2+?___fldiv,(___fladd@b+2)
	movff	3+?___fldiv,(___fladd@b+3)
	
	call	___fladd	;wreg free
	movff	0+?___fladd,(___fltol@f1)
	movff	1+?___fladd,(___fltol@f1+1)
	movff	2+?___fladd,(___fltol@f1+2)
	movff	3+?___fladd,(___fltol@f1+3)
	
	call	___fltol	;wreg free
	movlb	2	; () banked
	movf	(0+?___fltol)&0ffh,w
	movwf	((c:4040))^0f00h,c	;volatile
	line	21
	
l18211:; BSR set to: 2

	movlw	low(0)
	movwf	((c:4037))^0f00h,c	;volatile
	line	22
	
l699:; BSR set to: 2

	return	;funcret
	callstack 0
GLOBAL	__end_of_I2C_Master_Init
	__end_of_I2C_Master_Init:
	signat	_I2C_Master_Init,4217
	global	___xxtofl

;; *************** function ___xxtofl *****************
;; Defined at:
;;		line 10 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\xxtofl.c"
;; Parameters:    Size  Location     Type
;;  sign            1    wreg     unsigned char 
;;  val             4   42[BANK0 ] long 
;; Auto vars:     Size  Location     Type
;;  sign            1   50[BANK0 ] unsigned char 
;;  arg             4   52[BANK0 ] unsigned long 
;;  exp             1   51[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  4   42[BANK0 ] unsigned char 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       4       0       0       0       0       0       0       0
;;      Locals:         0       6       0       0       0       0       0       0       0
;;      Temps:          0       4       0       0       0       0       0       0       0
;;      Totals:         0      14       0       0       0       0       0       0       0
;;Total ram usage:       14 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_taskAplicacion
;;		_I2C_Master_Init
;; This function uses a non-reentrant model
;;
psect	text80,class=CODE,space=0,reloc=2,group=2
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\xxtofl.c"
	line	10
global __ptext80
__ptext80:
psect	text80
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\xxtofl.c"
	line	10
	
___xxtofl:; BSR set to: 2

;incstack = 0
	callstack 16
	movwf	((___xxtofl@sign))&0ffh
	line	15
	
l6565:
	movlb	0	; () banked
	movf	((___xxtofl@sign))&0ffh,w
	btfsc	status,2
	goto	u6611
	goto	u6610
u6611:
	goto	l1604
u6610:
	
l6567:; BSR set to: 0

	btfsc	((___xxtofl@val+3))&0ffh,7
	goto	u6620
	goto	u6621

u6621:
	goto	l1604
u6620:
	line	16
	
l6569:; BSR set to: 0

	movff	(___xxtofl@val),??___xxtofl+0+0
	movff	(___xxtofl@val+1),??___xxtofl+0+0+1
	movff	(___xxtofl@val+2),??___xxtofl+0+0+2
	movff	(___xxtofl@val+3),??___xxtofl+0+0+3
	comf	(??___xxtofl+0+0)&0ffh
	comf	(??___xxtofl+0+1)&0ffh
	comf	(??___xxtofl+0+2)&0ffh
	comf	(??___xxtofl+0+3)&0ffh
	incf	(??___xxtofl+0+0)&0ffh
	movlw	0
	addwfc	(??___xxtofl+0+1)&0ffh
	addwfc	(??___xxtofl+0+2)&0ffh
	addwfc	(??___xxtofl+0+3)&0ffh
	movff	??___xxtofl+0+0,(___xxtofl@arg)
	movff	??___xxtofl+0+1,(___xxtofl@arg+1)
	movff	??___xxtofl+0+2,(___xxtofl@arg+2)
	movff	??___xxtofl+0+3,(___xxtofl@arg+3)
	line	17
	goto	l6571
	line	18
	
l1604:; BSR set to: 0

	line	19
	movff	(___xxtofl@val),(___xxtofl@arg)
	movff	(___xxtofl@val+1),(___xxtofl@arg+1)
	movff	(___xxtofl@val+2),(___xxtofl@arg+2)
	movff	(___xxtofl@val+3),(___xxtofl@arg+3)
	line	21
	
l6571:; BSR set to: 0

	movf	((___xxtofl@val))&0ffh,w
iorwf	((___xxtofl@val+1))&0ffh,w
iorwf	((___xxtofl@val+2))&0ffh,w
iorwf	((___xxtofl@val+3))&0ffh,w
	btfss	status,2
	goto	u6631
	goto	u6630

u6631:
	goto	l6577
u6630:
	line	22
	
l6573:; BSR set to: 0

	movlw	low(normalize32(0x0))
	movwf	((?___xxtofl))&0ffh
	movlw	high(normalize32(0x0))
	movwf	((?___xxtofl+1))&0ffh
	movlw	low highword(normalize32(0x0))
	movwf	((?___xxtofl+2))&0ffh
	movlw	high highword(normalize32(0x0))
	movwf	((?___xxtofl+3))&0ffh
	goto	l1607
	line	23
	
l6577:; BSR set to: 0

	movlw	low(096h)
	movwf	((___xxtofl@exp))&0ffh
	line	24
	goto	l6581
	line	25
	
l6579:; BSR set to: 0

	incf	((___xxtofl@exp))&0ffh
	line	26
	bcf	status,0
	rrcf	((___xxtofl@arg+3))&0ffh
	rrcf	((___xxtofl@arg+2))&0ffh
	rrcf	((___xxtofl@arg+1))&0ffh
	rrcf	((___xxtofl@arg))&0ffh
	line	24
	
l6581:; BSR set to: 0

	movlw	0
	andwf	((___xxtofl@arg))&0ffh,w
	movwf	(??___xxtofl+0+0)&0ffh
	movlw	0
	andwf	((___xxtofl@arg+1))&0ffh,w
	movwf	1+(??___xxtofl+0+0)&0ffh
	
	movlw	0
	andwf	((___xxtofl@arg+2))&0ffh,w
	movwf	2+(??___xxtofl+0+0)&0ffh
	
	movlw	0FEh
	andwf	((___xxtofl@arg+3))&0ffh,w
	movwf	3+(??___xxtofl+0+0)&0ffh
	movf	(??___xxtofl+0+0)&0ffh,w
iorwf	(??___xxtofl+0+1)&0ffh,w
iorwf	(??___xxtofl+0+2)&0ffh,w
iorwf	(??___xxtofl+0+3)&0ffh,w
	btfss	status,2
	goto	u6641
	goto	u6640

u6641:
	goto	l6579
u6640:
	goto	l1611
	line	29
	
l6583:; BSR set to: 0

	incf	((___xxtofl@exp))&0ffh
	line	30
	
l6585:; BSR set to: 0

	movlw	low(01h)
	addwf	((___xxtofl@arg))&0ffh
	movlw	0
	addwfc	((___xxtofl@arg+1))&0ffh
	addwfc	((___xxtofl@arg+2))&0ffh
	addwfc	((___xxtofl@arg+3))&0ffh
	line	31
	
l6587:; BSR set to: 0

	bcf	status,0
	rrcf	((___xxtofl@arg+3))&0ffh
	rrcf	((___xxtofl@arg+2))&0ffh
	rrcf	((___xxtofl@arg+1))&0ffh
	rrcf	((___xxtofl@arg))&0ffh
	line	32
	
l1611:; BSR set to: 0

	line	28
	movlw	0
	andwf	((___xxtofl@arg))&0ffh,w
	movwf	(??___xxtofl+0+0)&0ffh
	movlw	0
	andwf	((___xxtofl@arg+1))&0ffh,w
	movwf	1+(??___xxtofl+0+0)&0ffh
	
	movlw	0
	andwf	((___xxtofl@arg+2))&0ffh,w
	movwf	2+(??___xxtofl+0+0)&0ffh
	
	movlw	0FFh
	andwf	((___xxtofl@arg+3))&0ffh,w
	movwf	3+(??___xxtofl+0+0)&0ffh
	movf	(??___xxtofl+0+0)&0ffh,w
iorwf	(??___xxtofl+0+1)&0ffh,w
iorwf	(??___xxtofl+0+2)&0ffh,w
iorwf	(??___xxtofl+0+3)&0ffh,w
	btfss	status,2
	goto	u6651
	goto	u6650

u6651:
	goto	l6583
u6650:
	goto	l6591
	line	34
	
l6589:; BSR set to: 0

	decf	((___xxtofl@exp))&0ffh
	line	35
	bcf	status,0
	rlcf	((___xxtofl@arg))&0ffh
	rlcf	((___xxtofl@arg+1))&0ffh
	rlcf	((___xxtofl@arg+2))&0ffh
	rlcf	((___xxtofl@arg+3))&0ffh
	line	33
	
l6591:; BSR set to: 0

	
	btfsc	((___xxtofl@arg+2))&0ffh,(23)&7
	goto	u6661
	goto	u6660
u6661:
	goto	l1618
u6660:
	
l6593:; BSR set to: 0

		movlw	02h-0
	cpfslt	((___xxtofl@exp))&0ffh
	goto	u6671
	goto	u6670

u6671:
	goto	l6589
u6670:
	
l1618:; BSR set to: 0

	line	37
	
	btfsc	((___xxtofl@exp))&0ffh,(0)&7
	goto	u6681
	goto	u6680
u6681:
	goto	l6597
u6680:
	line	38
	
l6595:; BSR set to: 0

	bcf	(0+(23/8)+(___xxtofl@arg))&0ffh,(23)&7
	line	39
	
l6597:; BSR set to: 0

	bcf status,0
	rrcf	((___xxtofl@exp))&0ffh

	line	40
	
l6599:; BSR set to: 0

	movff	(___xxtofl@exp),??___xxtofl+0+0
	clrf	(??___xxtofl+0+0+1)&0ffh
	clrf	(??___xxtofl+0+0+2)&0ffh
	clrf	(??___xxtofl+0+0+3)&0ffh
	movff	??___xxtofl+0+0,??___xxtofl+0+3
	clrf	(??___xxtofl+0+2)&0ffh
	clrf	(??___xxtofl+0+1)&0ffh
	clrf	(??___xxtofl+0+0)&0ffh
	movf	(??___xxtofl+0+0)&0ffh,w
	iorwf	((___xxtofl@arg))&0ffh
	movf	(??___xxtofl+0+1)&0ffh,w
	iorwf	((___xxtofl@arg+1))&0ffh
	movf	(??___xxtofl+0+2)&0ffh,w
	iorwf	((___xxtofl@arg+2))&0ffh
	movf	(??___xxtofl+0+3)&0ffh,w
	iorwf	((___xxtofl@arg+3))&0ffh

	line	41
	
l6601:; BSR set to: 0

	movf	((___xxtofl@sign))&0ffh,w
	btfsc	status,2
	goto	u6691
	goto	u6690
u6691:
	goto	l6607
u6690:
	
l6603:; BSR set to: 0

	btfsc	((___xxtofl@val+3))&0ffh,7
	goto	u6700
	goto	u6701

u6701:
	goto	l6607
u6700:
	line	42
	
l6605:; BSR set to: 0

	bsf	(0+(31/8)+(___xxtofl@arg))&0ffh,(31)&7
	line	43
	
l6607:; BSR set to: 0

	movff	(___xxtofl@arg),(?___xxtofl)
	movff	(___xxtofl@arg+1),(?___xxtofl+1)
	movff	(___xxtofl@arg+2),(?___xxtofl+2)
	movff	(___xxtofl@arg+3),(?___xxtofl+3)
	line	44
	
l1607:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of___xxtofl
	__end_of___xxtofl:
	signat	___xxtofl,8316
	global	___fltol

;; *************** function ___fltol *****************
;; Defined at:
;;		line 43 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\fltol.c"
;; Parameters:    Size  Location     Type
;;  f1              4    8[BANK2 ] unsigned char 
;; Auto vars:     Size  Location     Type
;;  exp1            1   98[BANK0 ] unsigned char 
;;  sign1           1   97[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  4    8[BANK2 ] long 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 3C/0
;;		On exit  : 3D/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       4       0       0       0       0       0
;;      Locals:         0       2       0       0       0       0       0       0       0
;;      Temps:          0       0       0       4       0       0       0       0       0
;;      Totals:         0       2       0       8       0       0       0       0       0
;;Total ram usage:       10 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_I2C_Master_Init
;; This function uses a non-reentrant model
;;
psect	text81,class=CODE,space=0,reloc=2,group=2
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\fltol.c"
	line	43
global __ptext81
__ptext81:
psect	text81
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\fltol.c"
	line	43
	
___fltol:; BSR set to: 0

;incstack = 0
	callstack 17
	line	47
	
l18147:
	movlb	2	; () banked
	rlcf	((___fltol@f1+2))&0ffh,w
	rlcf	((___fltol@f1+3))&0ffh,w
	movlb	0	; () banked
	movwf	((___fltol@exp1))&0ffh
	movf	((___fltol@exp1))&0ffh,w
	btfss	status,2
	goto	u22721
	goto	u22720
u22721:
	goto	l18153
u22720:
	line	48
	
l18149:; BSR set to: 0

	movlw	low(0)
	movlb	2	; () banked
	movwf	((?___fltol))&0ffh
	movlw	high(0)
	movwf	((?___fltol+1))&0ffh
	movlw	low highword(0)
	movwf	((?___fltol+2))&0ffh
	movlw	high highword(0)
	movwf	((?___fltol+3))&0ffh
	goto	l1246
	line	49
	
l18153:; BSR set to: 0

	movff	(___fltol@f1),??___fltol+0+0
	movff	(___fltol@f1+1),??___fltol+0+0+1
	movff	(___fltol@f1+2),??___fltol+0+0+2
	movff	(___fltol@f1+3),??___fltol+0+0+3
	movlw	01Fh+1
	goto	u22730
u22735:
	movlb	2	; () banked
	bcf	status,0
	rrcf	(??___fltol+0+3)&0ffh
	rrcf	(??___fltol+0+2)&0ffh
	rrcf	(??___fltol+0+1)&0ffh
	rrcf	(??___fltol+0+0)&0ffh
u22730:
	decfsz	wreg
	goto	u22735
	movf	(??___fltol+0+0)&0ffh,w
	movlb	0	; () banked
	movwf	((___fltol@sign1))&0ffh
	line	50
	
l18155:; BSR set to: 0

	movlb	2	; () banked
	bsf	(0+(23/8)+(___fltol@f1))&0ffh,(23)&7
	line	51
	
l18157:; BSR set to: 2

	movlw	0FFh
	andwf	((___fltol@f1))&0ffh
	movlw	0FFh
	andwf	((___fltol@f1+1))&0ffh
	movlw	0FFh
	andwf	((___fltol@f1+2))&0ffh
	movlw	0
	andwf	((___fltol@f1+3))&0ffh
	line	52
	
l18159:; BSR set to: 2

	movlw	(096h)&0ffh
	movlb	0	; () banked
	subwf	((___fltol@exp1))&0ffh
	line	53
	
l18161:; BSR set to: 0

	btfsc	((___fltol@exp1))&0ffh,7
	goto	u22740
	goto	u22741

u22741:
	goto	l18173
u22740:
	line	54
	
l18163:; BSR set to: 0

		movf	((___fltol@exp1))&0ffh,w
	xorlw	80h
	addlw	-(80h^-23)
	btfsc	status,0
	goto	u22751
	goto	u22750

u22751:
	goto	l18169
u22750:
	goto	l18149
	line	57
	
l18169:; BSR set to: 0

	movlb	2	; () banked
	bcf	status,0
	rrcf	((___fltol@f1+3))&0ffh
	rrcf	((___fltol@f1+2))&0ffh
	rrcf	((___fltol@f1+1))&0ffh
	rrcf	((___fltol@f1))&0ffh
	
l18171:; BSR set to: 2

	movlb	0	; () banked
	incfsz	((___fltol@exp1))&0ffh
	
	goto	l18169
	goto	l18183
	line	60
	
l18173:; BSR set to: 0

		movlw	020h-1
	cpfsgt	((___fltol@exp1))&0ffh
	goto	u22761
	goto	u22760

u22761:
	goto	l18181
u22760:
	goto	l18149
	line	63
	
l18179:; BSR set to: 0

	movlb	2	; () banked
	bcf	status,0
	rlcf	((___fltol@f1))&0ffh
	rlcf	((___fltol@f1+1))&0ffh
	rlcf	((___fltol@f1+2))&0ffh
	rlcf	((___fltol@f1+3))&0ffh
	line	64
	movlb	0	; () banked
	decf	((___fltol@exp1))&0ffh
	line	62
	
l18181:; BSR set to: 0

	movf	((___fltol@exp1))&0ffh,w
	btfss	status,2
	goto	u22771
	goto	u22770
u22771:
	goto	l18179
u22770:
	line	67
	
l18183:; BSR set to: 0

	movf	((___fltol@sign1))&0ffh,w
	btfsc	status,2
	goto	u22781
	goto	u22780
u22781:
	goto	l18187
u22780:
	line	68
	
l18185:; BSR set to: 0

	movlb	2	; () banked
	comf	((___fltol@f1+3))&0ffh
	comf	((___fltol@f1+2))&0ffh
	comf	((___fltol@f1+1))&0ffh
	negf	((___fltol@f1))&0ffh
	movlw	0
	addwfc	((___fltol@f1+1))&0ffh
	addwfc	((___fltol@f1+2))&0ffh
	addwfc	((___fltol@f1+3))&0ffh
	line	69
	
l18187:
	movff	(___fltol@f1),(?___fltol)
	movff	(___fltol@f1+1),(?___fltol+1)
	movff	(___fltol@f1+2),(?___fltol+2)
	movff	(___fltol@f1+3),(?___fltol+3)
	line	70
	
l1246:
	return	;funcret
	callstack 0
GLOBAL	__end_of___fltol
	__end_of___fltol:
	signat	___fltol,4220
	global	___flmul

;; *************** function ___flmul *****************
;; Defined at:
;;		line 8 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\sprcmul.c"
;; Parameters:    Size  Location     Type
;;  b               4   56[BANK0 ] long 
;;  a               4   60[BANK0 ] long 
;; Auto vars:     Size  Location     Type
;;  prod            4   75[BANK0 ] struct .
;;  grs             4   70[BANK0 ] unsigned long 
;;  temp            2   79[BANK0 ] struct .
;;  bexp            1   74[BANK0 ] unsigned char 
;;  aexp            1   69[BANK0 ] unsigned char 
;;  sign            1   68[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  4   56[BANK0 ] unsigned char 
;; Registers used:
;;		wreg, status,2, status,0, prodl, prodh
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       8       0       0       0       0       0       0       0
;;      Locals:         0      13       0       0       0       0       0       0       0
;;      Temps:          0       4       0       0       0       0       0       0       0
;;      Totals:         0      25       0       0       0       0       0       0       0
;;Total ram usage:       25 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_taskAplicacion
;;		_I2C_Master_Init
;; This function uses a non-reentrant model
;;
psect	text82,class=CODE,space=0,reloc=2,group=2
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\sprcmul.c"
	line	8
global __ptext82
__ptext82:
psect	text82
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\sprcmul.c"
	line	8
	
___flmul:
;incstack = 0
	callstack 16
	line	17
	
l6435:; BSR set to: 0

	movf	(0+(___flmul@b+03h))&0ffh,w
	andlw	low(080h)
	movwf	((___flmul@sign))&0ffh
	line	18
	movf	(0+(___flmul@b+03h))&0ffh,w
	addwf	(0+(___flmul@b+03h))&0ffh,w
	movwf	((___flmul@bexp))&0ffh
	line	19
	
l6437:; BSR set to: 0

	
	btfss	(0+(___flmul@b+02h))&0ffh,(7)&7
	goto	u6431
	goto	u6430
u6431:
	goto	l6441
u6430:
	line	20
	
l6439:; BSR set to: 0

	bsf	(0+(0/8)+(___flmul@bexp))&0ffh,(0)&7
	line	24
	
l6441:; BSR set to: 0

	movf	((___flmul@bexp))&0ffh,w
	btfsc	status,2
	goto	u6441
	goto	u6440
u6441:
	goto	l6449
u6440:
	line	26
	
l6443:; BSR set to: 0

		incf	((___flmul@bexp))&0ffh,w
	btfss	status,2
	goto	u6451
	goto	u6450

u6451:
	goto	l6447
u6450:
	line	28
	
l6445:; BSR set to: 0

	movlw	low(normalize32(0x0))
	movwf	((___flmul@b))&0ffh
	movlw	high(normalize32(0x0))
	movwf	((___flmul@b+1))&0ffh
	movlw	low highword(normalize32(0x0))
	movwf	((___flmul@b+2))&0ffh
	movlw	high highword(normalize32(0x0))
	movwf	((___flmul@b+3))&0ffh
	line	31
	
l6447:; BSR set to: 0

	bsf	(0+(23/8)+(___flmul@b))&0ffh,(23)&7
	line	33
	goto	l6451
	line	36
	
l6449:; BSR set to: 0

	movlw	low(normalize32(0x0))
	movwf	((___flmul@b))&0ffh
	movlw	high(normalize32(0x0))
	movwf	((___flmul@b+1))&0ffh
	movlw	low highword(normalize32(0x0))
	movwf	((___flmul@b+2))&0ffh
	movlw	high highword(normalize32(0x0))
	movwf	((___flmul@b+3))&0ffh
	line	39
	
l6451:; BSR set to: 0

	movf	(0+(___flmul@a+03h))&0ffh,w
	andlw	low(080h)
	xorwf	((___flmul@sign))&0ffh
	line	40
	
l6453:; BSR set to: 0

	movf	(0+(___flmul@a+03h))&0ffh,w
	addwf	(0+(___flmul@a+03h))&0ffh,w
	movwf	((___flmul@aexp))&0ffh
	line	41
	
l6455:; BSR set to: 0

	
	btfss	(0+(___flmul@a+02h))&0ffh,(7)&7
	goto	u6461
	goto	u6460
u6461:
	goto	l6459
u6460:
	line	42
	
l6457:; BSR set to: 0

	bsf	(0+(0/8)+(___flmul@aexp))&0ffh,(0)&7
	line	45
	
l6459:; BSR set to: 0

	movf	((___flmul@aexp))&0ffh,w
	btfsc	status,2
	goto	u6471
	goto	u6470
u6471:
	goto	l6467
u6470:
	line	48
	
l6461:; BSR set to: 0

		incf	((___flmul@aexp))&0ffh,w
	btfss	status,2
	goto	u6481
	goto	u6480

u6481:
	goto	l6465
u6480:
	line	50
	
l6463:; BSR set to: 0

	movlw	low(normalize32(0x0))
	movwf	((___flmul@a))&0ffh
	movlw	high(normalize32(0x0))
	movwf	((___flmul@a+1))&0ffh
	movlw	low highword(normalize32(0x0))
	movwf	((___flmul@a+2))&0ffh
	movlw	high highword(normalize32(0x0))
	movwf	((___flmul@a+3))&0ffh
	line	53
	
l6465:; BSR set to: 0

	bsf	(0+(23/8)+(___flmul@a))&0ffh,(23)&7
	line	54
	goto	l1563
	line	57
	
l6467:; BSR set to: 0

	movlw	low(normalize32(0x0))
	movwf	((___flmul@a))&0ffh
	movlw	high(normalize32(0x0))
	movwf	((___flmul@a+1))&0ffh
	movlw	low highword(normalize32(0x0))
	movwf	((___flmul@a+2))&0ffh
	movlw	high highword(normalize32(0x0))
	movwf	((___flmul@a+3))&0ffh
	line	58
	
l1563:; BSR set to: 0

	line	65
	movf	((___flmul@aexp))&0ffh,w
	btfsc	status,2
	goto	u6491
	goto	u6490
u6491:
	goto	l6471
u6490:
	
l6469:; BSR set to: 0

	movf	((___flmul@bexp))&0ffh,w
	btfss	status,2
	goto	u6501
	goto	u6500
u6501:
	goto	l6475
u6500:
	line	66
	
l6471:; BSR set to: 0

	movlw	low(normalize32(0x0))
	movwf	((?___flmul))&0ffh
	movlw	high(normalize32(0x0))
	movwf	((?___flmul+1))&0ffh
	movlw	low highword(normalize32(0x0))
	movwf	((?___flmul+2))&0ffh
	movlw	high highword(normalize32(0x0))
	movwf	((?___flmul+3))&0ffh
	goto	l1567
	line	95
	
l6475:; BSR set to: 0

	movf	(0+(___flmul@a+02h))&0ffh,w
	mulwf	((___flmul@b))&0ffh
	movff	prodl,(___flmul@temp)
	movff	prodh,(___flmul@temp+1)
	line	96
	
l6477:; BSR set to: 0

	movf	((___flmul@temp))&0ffh,w
	movwf	((___flmul@grs))&0ffh
	clrf	((___flmul@grs+1))&0ffh
	clrf	((___flmul@grs+2))&0ffh
	clrf	((___flmul@grs+3))&0ffh

	line	97
	
l6479:; BSR set to: 0

	movf	(0+(___flmul@temp+01h))&0ffh,w
	movwf	((___flmul@prod))&0ffh
	clrf	((___flmul@prod+1))&0ffh
	clrf	((___flmul@prod+2))&0ffh
	clrf	((___flmul@prod+3))&0ffh

	line	98
	movf	(0+(___flmul@a+01h))&0ffh,w
	mulwf	(0+(___flmul@b+01h))&0ffh
	movff	prodl,(___flmul@temp)
	movff	prodh,(___flmul@temp+1)
	line	99
	
l6481:; BSR set to: 0

	movf	((___flmul@temp))&0ffh,w
	addwf	((___flmul@grs))&0ffh
	movlw	0
	addwfc	((___flmul@grs+1))&0ffh
	addwfc	((___flmul@grs+2))&0ffh
	addwfc	((___flmul@grs+3))&0ffh
	line	100
	
l6483:; BSR set to: 0

	movf	(0+(___flmul@temp+01h))&0ffh,w
	addwf	((___flmul@prod))&0ffh
	movlw	0
	addwfc	((___flmul@prod+1))&0ffh
	addwfc	((___flmul@prod+2))&0ffh
	addwfc	((___flmul@prod+3))&0ffh
	line	101
	movf	((___flmul@a))&0ffh,w
	mulwf	(0+(___flmul@b+02h))&0ffh
	movff	prodl,(___flmul@temp)
	movff	prodh,(___flmul@temp+1)
	line	102
	
l6485:; BSR set to: 0

	movf	((___flmul@temp))&0ffh,w
	addwf	((___flmul@grs))&0ffh
	movlw	0
	addwfc	((___flmul@grs+1))&0ffh
	addwfc	((___flmul@grs+2))&0ffh
	addwfc	((___flmul@grs+3))&0ffh
	line	103
	
l6487:; BSR set to: 0

	movf	(0+(___flmul@temp+01h))&0ffh,w
	addwf	((___flmul@prod))&0ffh
	movlw	0
	addwfc	((___flmul@prod+1))&0ffh
	addwfc	((___flmul@prod+2))&0ffh
	addwfc	((___flmul@prod+3))&0ffh
	line	104
	
l6489:; BSR set to: 0

	movff	(___flmul@grs+2),(___flmul@grs+3)
	movff	(___flmul@grs+1),(___flmul@grs+2)
	movff	(___flmul@grs),(___flmul@grs+1)
	clrf	((___flmul@grs))&0ffh
	line	105
	
l6491:; BSR set to: 0

	movf	((___flmul@a))&0ffh,w
	mulwf	(0+(___flmul@b+01h))&0ffh
	movff	prodl,(___flmul@temp)
	movff	prodh,(___flmul@temp+1)
	line	106
	
l6493:; BSR set to: 0

	movf	((___flmul@temp))&0ffh,w
	addwf	((___flmul@grs))&0ffh
	movf	((___flmul@temp+1))&0ffh,w
	addwfc	((___flmul@grs+1))&0ffh
	movlw	0
	addwfc	((___flmul@grs+2))&0ffh
	movlw	0
	addwfc	((___flmul@grs+3))&0ffh

	line	107
	
l6495:; BSR set to: 0

	movf	(0+(___flmul@a+01h))&0ffh,w
	mulwf	((___flmul@b))&0ffh
	movff	prodl,(___flmul@temp)
	movff	prodh,(___flmul@temp+1)
	line	108
	
l6497:; BSR set to: 0

	movf	((___flmul@temp))&0ffh,w
	addwf	((___flmul@grs))&0ffh
	movf	((___flmul@temp+1))&0ffh,w
	addwfc	((___flmul@grs+1))&0ffh
	movlw	0
	addwfc	((___flmul@grs+2))&0ffh
	movlw	0
	addwfc	((___flmul@grs+3))&0ffh

	line	109
	
l6499:; BSR set to: 0

	movff	(___flmul@grs+2),(___flmul@grs+3)
	movff	(___flmul@grs+1),(___flmul@grs+2)
	movff	(___flmul@grs),(___flmul@grs+1)
	clrf	((___flmul@grs))&0ffh
	line	110
	movf	((___flmul@a))&0ffh,w
	mulwf	((___flmul@b))&0ffh
	movff	prodl,(___flmul@temp)
	movff	prodh,(___flmul@temp+1)
	line	111
	
l6501:; BSR set to: 0

	movf	((___flmul@temp))&0ffh,w
	addwf	((___flmul@grs))&0ffh
	movf	((___flmul@temp+1))&0ffh,w
	addwfc	((___flmul@grs+1))&0ffh
	movlw	0
	addwfc	((___flmul@grs+2))&0ffh
	movlw	0
	addwfc	((___flmul@grs+3))&0ffh

	line	112
	
l6503:; BSR set to: 0

	movf	(0+(___flmul@a+02h))&0ffh,w
	mulwf	(0+(___flmul@b+01h))&0ffh
	movff	prodl,(___flmul@temp)
	movff	prodh,(___flmul@temp+1)
	line	113
	movf	((___flmul@temp))&0ffh,w
	addwf	((___flmul@prod))&0ffh
	movf	((___flmul@temp+1))&0ffh,w
	addwfc	((___flmul@prod+1))&0ffh
	movlw	0
	addwfc	((___flmul@prod+2))&0ffh
	movlw	0
	addwfc	((___flmul@prod+3))&0ffh

	line	114
	
l6505:; BSR set to: 0

	movf	(0+(___flmul@a+01h))&0ffh,w
	mulwf	(0+(___flmul@b+02h))&0ffh
	movff	prodl,(___flmul@temp)
	movff	prodh,(___flmul@temp+1)
	line	115
	
l6507:; BSR set to: 0

	movf	((___flmul@temp))&0ffh,w
	addwf	((___flmul@prod))&0ffh
	movf	((___flmul@temp+1))&0ffh,w
	addwfc	((___flmul@prod+1))&0ffh
	movlw	0
	addwfc	((___flmul@prod+2))&0ffh
	movlw	0
	addwfc	((___flmul@prod+3))&0ffh

	line	116
	movf	(0+(___flmul@a+02h))&0ffh,w
	mulwf	(0+(___flmul@b+02h))&0ffh
	movff	prodl,(___flmul@temp)
	movff	prodh,(___flmul@temp+1)
	line	117
	
l6509:; BSR set to: 0

	movf	((___flmul@temp))&0ffh,w
	movwf	(??___flmul+0+0)&0ffh
	movf	((___flmul@temp+1))&0ffh,w
	movwf	1+(??___flmul+0+0)&0ffh
	
	clrf	2+(??___flmul+0+0)&0ffh
	
	clrf	3+(??___flmul+0+0)&0ffh
	movff	??___flmul+0+2,??___flmul+0+3
	movff	??___flmul+0+1,??___flmul+0+2
	movff	??___flmul+0+0,??___flmul+0+1
	clrf	(??___flmul+0+0)&0ffh
	movf	(??___flmul+0+0)&0ffh,w
	addwf	((___flmul@prod))&0ffh
	movf	(??___flmul+0+1)&0ffh,w
	addwfc	((___flmul@prod+1))&0ffh
	movf	(??___flmul+0+2)&0ffh,w
	addwfc	((___flmul@prod+2))&0ffh
	movf	(??___flmul+0+3)&0ffh,w
	addwfc	((___flmul@prod+3))&0ffh

	line	145
	
l6511:; BSR set to: 0

	movf	(0+(___flmul@grs+03h))&0ffh,w
	addwf	((___flmul@prod))&0ffh
	movlw	0
	addwfc	((___flmul@prod+1))&0ffh
	addwfc	((___flmul@prod+2))&0ffh
	addwfc	((___flmul@prod+3))&0ffh
	line	146
	
l6513:; BSR set to: 0

	movff	(___flmul@grs+2),(___flmul@grs+3)
	movff	(___flmul@grs+1),(___flmul@grs+2)
	movff	(___flmul@grs),(___flmul@grs+1)
	clrf	((___flmul@grs))&0ffh
	line	149
	
l6515:; BSR set to: 0

	movf	((___flmul@aexp))&0ffh,w
	movff	(___flmul@bexp),??___flmul+0+0
	clrf	(??___flmul+0+0+1)&0ffh
	addwf	(??___flmul+0+0)&0ffh
	movlw	0
	addwfc	(??___flmul+0+1)&0ffh
	movlw	low(-126)
	addwf	(??___flmul+0+0)&0ffh,w
	movwf	((___flmul@temp))&0ffh
	movlw	high(-126)
	addwfc	(??___flmul+0+1)&0ffh,w
	movwf	1+((___flmul@temp))&0ffh
	line	152
	goto	l6523
	line	153
	
l6517:; BSR set to: 0

	bcf	status,0
	rlcf	((___flmul@prod))&0ffh
	rlcf	((___flmul@prod+1))&0ffh
	rlcf	((___flmul@prod+2))&0ffh
	rlcf	((___flmul@prod+3))&0ffh
	line	154
	
l6519:; BSR set to: 0

	
	btfss	((___flmul@grs+3))&0ffh,(31)&7
	goto	u6511
	goto	u6510
u6511:
	goto	l1570
u6510:
	line	155
	
l6521:; BSR set to: 0

	bsf	(0+(0/8)+(___flmul@prod))&0ffh,(0)&7
	line	156
	
l1570:; BSR set to: 0

	line	157
	bcf	status,0
	rlcf	((___flmul@grs))&0ffh
	rlcf	((___flmul@grs+1))&0ffh
	rlcf	((___flmul@grs+2))&0ffh
	rlcf	((___flmul@grs+3))&0ffh
	line	158
	decf	((___flmul@temp))&0ffh
	btfss	status,0
	decf	((___flmul@temp+1))&0ffh
	line	152
	
l6523:; BSR set to: 0

	
	btfss	((___flmul@prod+2))&0ffh,(23)&7
	goto	u6521
	goto	u6520
u6521:
	goto	l6517
u6520:
	line	163
	
l6525:; BSR set to: 0

	movlw	low(0)
	movwf	((___flmul@aexp))&0ffh
	line	164
	
l6527:; BSR set to: 0

	
	btfss	((___flmul@grs+3))&0ffh,(31)&7
	goto	u6531
	goto	u6530
u6531:
	goto	l1572
u6530:
	line	165
	
l6529:; BSR set to: 0

	movlw	0FFh
	andwf	((___flmul@grs))&0ffh,w
	movwf	(??___flmul+0+0)&0ffh
	movlw	0FFh
	andwf	((___flmul@grs+1))&0ffh,w
	movwf	1+(??___flmul+0+0)&0ffh
	
	movlw	0FFh
	andwf	((___flmul@grs+2))&0ffh,w
	movwf	2+(??___flmul+0+0)&0ffh
	
	movlw	07Fh
	andwf	((___flmul@grs+3))&0ffh,w
	movwf	3+(??___flmul+0+0)&0ffh
	movf	(??___flmul+0+0)&0ffh,w
iorwf	(??___flmul+0+1)&0ffh,w
iorwf	(??___flmul+0+2)&0ffh,w
iorwf	(??___flmul+0+3)&0ffh,w
	btfsc	status,2
	goto	u6541
	goto	u6540

u6541:
	goto	l1573
u6540:
	line	166
	
l6531:; BSR set to: 0

	movlw	low(01h)
	movwf	((___flmul@aexp))&0ffh
	line	167
	goto	l1572
	line	168
	
l1573:; BSR set to: 0

	line	169
	
	btfss	((___flmul@prod))&0ffh,(0)&7
	goto	u6551
	goto	u6550
u6551:
	goto	l1572
u6550:
	goto	l6531
	line	173
	
l1572:; BSR set to: 0

	line	174
	movf	((___flmul@aexp))&0ffh,w
	btfsc	status,2
	goto	u6561
	goto	u6560
u6561:
	goto	l6543
u6560:
	line	175
	
l6535:; BSR set to: 0

	movlw	low(01h)
	addwf	((___flmul@prod))&0ffh
	movlw	0
	addwfc	((___flmul@prod+1))&0ffh
	addwfc	((___flmul@prod+2))&0ffh
	addwfc	((___flmul@prod+3))&0ffh
	line	176
	
l6537:; BSR set to: 0

	
	btfss	((___flmul@prod+3))&0ffh,(24)&7
	goto	u6571
	goto	u6570
u6571:
	goto	l6543
u6570:
	line	177
	
l6539:; BSR set to: 0

	movff	(___flmul@prod),??___flmul+0+0
	movff	(___flmul@prod+1),??___flmul+0+0+1
	movff	(___flmul@prod+2),??___flmul+0+0+2
	movff	(___flmul@prod+3),??___flmul+0+0+3
	rlcf	(??___flmul+0+3)&0ffh,w
	rrcf	(??___flmul+0+3)&0ffh
	rrcf	(??___flmul+0+2)&0ffh
	rrcf	(??___flmul+0+1)&0ffh
	rrcf	(??___flmul+0+0)&0ffh
	movff	??___flmul+0+0,(___flmul@prod)
	movff	??___flmul+0+1,(___flmul@prod+1)
	movff	??___flmul+0+2,(___flmul@prod+2)
	movff	??___flmul+0+3,(___flmul@prod+3)
	line	178
	
l6541:; BSR set to: 0

	infsnz	((___flmul@temp))&0ffh
	incf	((___flmul@temp+1))&0ffh
	line	183
	
l6543:; BSR set to: 0

	btfsc	((___flmul@temp+1))&0ffh,7
	goto	u6581
	movf	((___flmul@temp+1))&0ffh,w
	bnz	u6580
	incf	((___flmul@temp))&0ffh,w
	btfss	status,0
	goto	u6581
	goto	u6580

u6581:
	goto	l6547
u6580:
	line	184
	
l6545:; BSR set to: 0

	movlw	low(07F800000h)
	movwf	((___flmul@prod))&0ffh
	movlw	high(07F800000h)
	movwf	((___flmul@prod+1))&0ffh
	movlw	low highword(07F800000h)
	movwf	((___flmul@prod+2))&0ffh
	movlw	high highword(07F800000h)
	movwf	((___flmul@prod+3))&0ffh
	line	185
	goto	l6559
	line	187
	
l6547:; BSR set to: 0

	btfsc	((___flmul@temp+1))&0ffh,7
	goto	u6590
	movf	((___flmul@temp+1))&0ffh,w
	bnz	u6591
	decf	((___flmul@temp))&0ffh,w
	btfsc	status,0
	goto	u6591
	goto	u6590

u6591:
	goto	l1580
u6590:
	line	188
	
l6549:; BSR set to: 0

	movlw	low(0)
	movwf	((___flmul@prod))&0ffh
	movlw	high(0)
	movwf	((___flmul@prod+1))&0ffh
	movlw	low highword(0)
	movwf	((___flmul@prod+2))&0ffh
	movlw	high highword(0)
	movwf	((___flmul@prod+3))&0ffh
	line	190
	movlw	low(0)
	movwf	((___flmul@sign))&0ffh
	line	191
	goto	l6559
	line	192
	
l1580:; BSR set to: 0

	line	194
	movff	(___flmul@temp),(___flmul@bexp)
	line	195
	
l6551:; BSR set to: 0

	movlw	0FFh
	andwf	((___flmul@prod))&0ffh
	movlw	0FFh
	andwf	((___flmul@prod+1))&0ffh
	movlw	07Fh
	andwf	((___flmul@prod+2))&0ffh
	movlw	0
	andwf	((___flmul@prod+3))&0ffh
	line	196
	
l6553:; BSR set to: 0

	
	btfss	((___flmul@bexp))&0ffh,(0)&7
	goto	u6601
	goto	u6600
u6601:
	goto	l6557
u6600:
	line	197
	
l6555:; BSR set to: 0

	bsf	(0+(7/8)+0+(___flmul@prod+02h))&0ffh,(7)&7
	line	199
	
l6557:; BSR set to: 0

	bcf	status,0
	rrcf	((___flmul@bexp))&0ffh,w
	movwf	(0+(___flmul@prod+03h))&0ffh
	line	201
	
l6559:; BSR set to: 0

	movf	((___flmul@sign))&0ffh,w
	iorwf	(0+(___flmul@prod+03h))&0ffh
	line	203
	
l6561:; BSR set to: 0

	movff	(___flmul@prod),(?___flmul)
	movff	(___flmul@prod+1),(?___flmul+1)
	movff	(___flmul@prod+2),(?___flmul+2)
	movff	(___flmul@prod+3),(?___flmul+3)
	line	205
	
l1567:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of___flmul
	__end_of___flmul:
	signat	___flmul,8316
	global	___fldiv

;; *************** function ___fldiv *****************
;; Defined at:
;;		line 11 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\sprcdiv.c"
;; Parameters:    Size  Location     Type
;;  b               4   81[BANK0 ] unsigned char 
;;  a               4   85[BANK0 ] unsigned char 
;; Auto vars:     Size  Location     Type
;;  grs             4    7[BANK1 ] unsigned long 
;;  rem             4    0[BANK1 ] unsigned long 
;;  new_exp         2    5[BANK1 ] short 
;;  aexp            1   12[BANK1 ] unsigned char 
;;  bexp            1   11[BANK1 ] unsigned char 
;;  sign            1    4[BANK1 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  4   81[BANK0 ] unsigned char 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       8       0       0       0       0       0       0       0
;;      Locals:         0       0      13       0       0       0       0       0       0
;;      Temps:          0       4       0       0       0       0       0       0       0
;;      Totals:         0      12      13       0       0       0       0       0       0
;;Total ram usage:       25 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_I2C_Master_Init
;; This function uses a non-reentrant model
;;
psect	text83,class=CODE,space=0,reloc=2,group=2
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\sprcdiv.c"
	line	11
global __ptext83
__ptext83:
psect	text83
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\sprcdiv.c"
	line	11
	
___fldiv:; BSR set to: 0

;incstack = 0
	callstack 17
	line	26
	
l12393:; BSR set to: 0

	movf	(0+(___fldiv@b+03h))&0ffh,w
	andlw	low(080h)
	movlb	1	; () banked
	movwf	((___fldiv@sign))&0ffh
	line	27
	movlb	0	; () banked
	movf	(0+(___fldiv@b+03h))&0ffh,w
	addwf	(0+(___fldiv@b+03h))&0ffh,w
	movlb	1	; () banked
	movwf	((___fldiv@bexp))&0ffh
	line	28
	
l12395:; BSR set to: 1

	movlb	0	; () banked
	
	btfss	(0+(___fldiv@b+02h))&0ffh,(7)&7
	goto	u14991
	goto	u14990
u14991:
	goto	l12399
u14990:
	line	29
	
l12397:; BSR set to: 0

	movlb	1	; () banked
	bsf	(0+(0/8)+(___fldiv@bexp))&0ffh,(0)&7
	line	33
	
l12399:
	movlb	1	; () banked
	movf	((___fldiv@bexp))&0ffh,w
	btfsc	status,2
	goto	u15001
	goto	u15000
u15001:
	goto	l12409
u15000:
	line	35
	
l12401:; BSR set to: 1

		incf	((___fldiv@bexp))&0ffh,w
	btfss	status,2
	goto	u15011
	goto	u15010

u15011:
	goto	l12405
u15010:
	line	37
	
l12403:; BSR set to: 1

	movlw	low(normalize32(0x0))
	movlb	0	; () banked
	movwf	((___fldiv@b))&0ffh
	movlw	high(normalize32(0x0))
	movwf	((___fldiv@b+1))&0ffh
	movlw	low highword(normalize32(0x0))
	movwf	((___fldiv@b+2))&0ffh
	movlw	high highword(normalize32(0x0))
	movwf	((___fldiv@b+3))&0ffh
	line	40
	
l12405:
	movlb	0	; () banked
	bsf	(0+(23/8)+(___fldiv@b))&0ffh,(23)&7
	line	42
	
l12407:; BSR set to: 0

	movlw	low(0)
	movwf	(0+(___fldiv@b+03h))&0ffh
	line	43
	goto	l12411
	line	46
	
l12409:; BSR set to: 1

	movlw	low(normalize32(0x0))
	movlb	0	; () banked
	movwf	((___fldiv@b))&0ffh
	movlw	high(normalize32(0x0))
	movwf	((___fldiv@b+1))&0ffh
	movlw	low highword(normalize32(0x0))
	movwf	((___fldiv@b+2))&0ffh
	movlw	high highword(normalize32(0x0))
	movwf	((___fldiv@b+3))&0ffh
	line	49
	
l12411:; BSR set to: 0

	movf	(0+(___fldiv@a+03h))&0ffh,w
	andlw	low(080h)
	movlb	1	; () banked
	xorwf	((___fldiv@sign))&0ffh
	line	50
	
l12413:; BSR set to: 1

	movlb	0	; () banked
	movf	(0+(___fldiv@a+03h))&0ffh,w
	addwf	(0+(___fldiv@a+03h))&0ffh,w
	movlb	1	; () banked
	movwf	((___fldiv@aexp))&0ffh
	line	51
	
l12415:; BSR set to: 1

	movlb	0	; () banked
	
	btfss	(0+(___fldiv@a+02h))&0ffh,(7)&7
	goto	u15021
	goto	u15020
u15021:
	goto	l12419
u15020:
	line	52
	
l12417:; BSR set to: 0

	movlb	1	; () banked
	bsf	(0+(0/8)+(___fldiv@aexp))&0ffh,(0)&7
	line	56
	
l12419:
	movlb	1	; () banked
	movf	((___fldiv@aexp))&0ffh,w
	btfsc	status,2
	goto	u15031
	goto	u15030
u15031:
	goto	l12429
u15030:
	line	58
	
l12421:; BSR set to: 1

		incf	((___fldiv@aexp))&0ffh,w
	btfss	status,2
	goto	u15041
	goto	u15040

u15041:
	goto	l12425
u15040:
	line	60
	
l12423:; BSR set to: 1

	movlw	low(normalize32(0x0))
	movlb	0	; () banked
	movwf	((___fldiv@a))&0ffh
	movlw	high(normalize32(0x0))
	movwf	((___fldiv@a+1))&0ffh
	movlw	low highword(normalize32(0x0))
	movwf	((___fldiv@a+2))&0ffh
	movlw	high highword(normalize32(0x0))
	movwf	((___fldiv@a+3))&0ffh
	line	63
	
l12425:
	movlb	0	; () banked
	bsf	(0+(23/8)+(___fldiv@a))&0ffh,(23)&7
	line	65
	
l12427:; BSR set to: 0

	movlw	low(0)
	movwf	(0+(___fldiv@a+03h))&0ffh
	line	66
	goto	l12431
	line	69
	
l12429:; BSR set to: 1

	movlw	low(normalize32(0x0))
	movlb	0	; () banked
	movwf	((___fldiv@a))&0ffh
	movlw	high(normalize32(0x0))
	movwf	((___fldiv@a+1))&0ffh
	movlw	low highword(normalize32(0x0))
	movwf	((___fldiv@a+2))&0ffh
	movlw	high highword(normalize32(0x0))
	movwf	((___fldiv@a+3))&0ffh
	line	75
	
l12431:; BSR set to: 0

	movf	((___fldiv@a))&0ffh,w
iorwf	((___fldiv@a+1))&0ffh,w
iorwf	((___fldiv@a+2))&0ffh,w
iorwf	((___fldiv@a+3))&0ffh,w
	btfss	status,2
	goto	u15051
	goto	u15050

u15051:
	goto	l12443
u15050:
	line	76
	
l12433:; BSR set to: 0

	movlw	low(0)
	movwf	((___fldiv@b))&0ffh
	movlw	high(0)
	movwf	((___fldiv@b+1))&0ffh
	movlw	low highword(0)
	movwf	((___fldiv@b+2))&0ffh
	movlw	high highword(0)
	movwf	((___fldiv@b+3))&0ffh
	line	77
	
l12435:; BSR set to: 0

	movlw	low(07F80h)
	iorwf	(0+(___fldiv@b+02h))&0ffh
	movlw	high(07F80h)
	iorwf	(1+(___fldiv@b+02h))&0ffh
	line	78
	
l12437:; BSR set to: 0

	movlb	1	; () banked
	movf	((___fldiv@sign))&0ffh,w
	movlb	0	; () banked
	iorwf	(0+(___fldiv@b+03h))&0ffh
	line	79
	
l12439:; BSR set to: 0

	movff	(___fldiv@b),(?___fldiv)
	movff	(___fldiv@b+1),(?___fldiv+1)
	movff	(___fldiv@b+2),(?___fldiv+2)
	movff	(___fldiv@b+3),(?___fldiv+3)
	goto	l1531
	line	83
	
l12443:; BSR set to: 0

	movlb	1	; () banked
	movf	((___fldiv@bexp))&0ffh,w
	btfss	status,2
	goto	u15061
	goto	u15060
u15061:
	goto	l12451
u15060:
	line	84
	
l12445:; BSR set to: 1

	line	85
	
l12447:; BSR set to: 1

	movlw	low(0)
	movlb	0	; () banked
	movwf	((?___fldiv))&0ffh
	movlw	high(0)
	movwf	((?___fldiv+1))&0ffh
	movlw	low highword(0)
	movwf	((?___fldiv+2))&0ffh
	movlw	high highword(0)
	movwf	((?___fldiv+3))&0ffh
	goto	l1531
	line	89
	
l12451:; BSR set to: 1

	movf	((___fldiv@aexp))&0ffh,w
	movff	(___fldiv@bexp),??___fldiv+0+0
	movlb	0	; () banked
	clrf	(??___fldiv+0+0+1)&0ffh
	subwf	(??___fldiv+0+0)&0ffh
	movlw	0
	subwfb	(??___fldiv+0+1)&0ffh
	movlw	low(07Fh)
	addwf	(??___fldiv+0+0)&0ffh,w
	movlb	1	; () banked
	movwf	((___fldiv@new_exp))&0ffh
	movlw	high(07Fh)
	movlb	0	; () banked
	addwfc	(??___fldiv+0+1)&0ffh,w
	movlb	1	; () banked
	movwf	1+((___fldiv@new_exp))&0ffh
	line	92
	
l12453:; BSR set to: 1

	movff	(___fldiv@b),(___fldiv@rem)
	movff	(___fldiv@b+1),(___fldiv@rem+1)
	movff	(___fldiv@b+2),(___fldiv@rem+2)
	movff	(___fldiv@b+3),(___fldiv@rem+3)
	line	93
	
l12455:; BSR set to: 1

	movlw	low(0)
	movlb	0	; () banked
	movwf	((___fldiv@b))&0ffh
	movlw	high(0)
	movwf	((___fldiv@b+1))&0ffh
	movlw	low highword(0)
	movwf	((___fldiv@b+2))&0ffh
	movlw	high highword(0)
	movwf	((___fldiv@b+3))&0ffh
	line	94
	
l12457:; BSR set to: 0

	movlw	low(0)
	movlb	1	; () banked
	movwf	((___fldiv@grs))&0ffh
	movlw	high(0)
	movwf	((___fldiv@grs+1))&0ffh
	movlw	low highword(0)
	movwf	((___fldiv@grs+2))&0ffh
	movlw	high highword(0)
	movwf	((___fldiv@grs+3))&0ffh
	line	96
	
l12459:; BSR set to: 1

	movlw	low(0)
	movwf	((___fldiv@aexp))&0ffh
	line	97
	goto	l1533
	line	100
	
l12461:; BSR set to: 1

	movf	((___fldiv@aexp))&0ffh,w
	btfsc	status,2
	goto	u15071
	goto	u15070
u15071:
	goto	l12469
u15070:
	line	101
	
l12463:; BSR set to: 1

	bcf	status,0
	rlcf	((___fldiv@rem))&0ffh
	rlcf	((___fldiv@rem+1))&0ffh
	rlcf	((___fldiv@rem+2))&0ffh
	rlcf	((___fldiv@rem+3))&0ffh
	line	102
	movlb	0	; () banked
	bcf	status,0
	rlcf	((___fldiv@b))&0ffh
	rlcf	((___fldiv@b+1))&0ffh
	rlcf	((___fldiv@b+2))&0ffh
	rlcf	((___fldiv@b+3))&0ffh
	line	103
	
l12465:; BSR set to: 0

	movlb	1	; () banked
	
	btfss	((___fldiv@grs+3))&0ffh,(31)&7
	goto	u15081
	goto	u15080
u15081:
	goto	l1536
u15080:
	line	104
	
l12467:; BSR set to: 1

	movlb	0	; () banked
	bsf	(0+(0/8)+(___fldiv@b))&0ffh,(0)&7
	line	105
	
l1536:
	line	106
	movlb	1	; () banked
	bcf	status,0
	rlcf	((___fldiv@grs))&0ffh
	rlcf	((___fldiv@grs+1))&0ffh
	rlcf	((___fldiv@grs+2))&0ffh
	rlcf	((___fldiv@grs+3))&0ffh
	line	112
	
l12469:; BSR set to: 1

	movlb	0	; () banked
		movf	((___fldiv@a))&0ffh,w
	movlb	1	; () banked
	subwf	((___fldiv@rem))&0ffh,w
	movlb	0	; () banked
	movf	((___fldiv@a+1))&0ffh,w
	movlb	1	; () banked
	subwfb	((___fldiv@rem+1))&0ffh,w
	movlb	0	; () banked
	movf	((___fldiv@a+2))&0ffh,w
	movlb	1	; () banked
	subwfb	((___fldiv@rem+2))&0ffh,w
	movlb	0	; () banked
	movf	((___fldiv@a+3))&0ffh,w
	movlb	1	; () banked
	subwfb	((___fldiv@rem+3))&0ffh,w
	btfss	status,0
	goto	u15091
	goto	u15090

u15091:
	goto	l12475
u15090:
	line	115
	
l12471:; BSR set to: 1

	bsf	(0+(30/8)+(___fldiv@grs))&0ffh,(30)&7
	line	116
	
l12473:; BSR set to: 1

	movlb	0	; () banked
	movf	((___fldiv@a))&0ffh,w
	movlb	1	; () banked
	subwf	((___fldiv@rem))&0ffh
	movlb	0	; () banked
	movf	((___fldiv@a+1))&0ffh,w
	movlb	1	; () banked
	subwfb	((___fldiv@rem+1))&0ffh
	movlb	0	; () banked
	movf	((___fldiv@a+2))&0ffh,w
	movlb	1	; () banked
	subwfb	((___fldiv@rem+2))&0ffh
	movlb	0	; () banked
	movf	((___fldiv@a+3))&0ffh,w
	movlb	1	; () banked
	subwfb	((___fldiv@rem+3))&0ffh

	line	118
	
l12475:; BSR set to: 1

	incf	((___fldiv@aexp))&0ffh
	line	119
	
l1533:; BSR set to: 1

	line	97
		movlw	01Ah-1
	cpfsgt	((___fldiv@aexp))&0ffh
	goto	u15101
	goto	u15100

u15101:
	goto	l12461
u15100:
	line	122
	
l12477:; BSR set to: 1

	movf	((___fldiv@rem))&0ffh,w
iorwf	((___fldiv@rem+1))&0ffh,w
iorwf	((___fldiv@rem+2))&0ffh,w
iorwf	((___fldiv@rem+3))&0ffh,w
	btfsc	status,2
	goto	u15111
	goto	u15110

u15111:
	goto	l12487
u15110:
	line	123
	
l12479:; BSR set to: 1

	bsf	(0+(0/8)+(___fldiv@grs))&0ffh,(0)&7
	goto	l12487
	line	128
	
l12481:; BSR set to: 0

	bcf	status,0
	rlcf	((___fldiv@b))&0ffh
	rlcf	((___fldiv@b+1))&0ffh
	rlcf	((___fldiv@b+2))&0ffh
	rlcf	((___fldiv@b+3))&0ffh
	line	129
	
l12483:; BSR set to: 0

	movlb	1	; () banked
	
	btfss	((___fldiv@grs+3))&0ffh,(31)&7
	goto	u15121
	goto	u15120
u15121:
	goto	l1542
u15120:
	line	130
	
l12485:; BSR set to: 1

	movlb	0	; () banked
	bsf	(0+(0/8)+(___fldiv@b))&0ffh,(0)&7
	line	131
	
l1542:
	line	132
	movlb	1	; () banked
	bcf	status,0
	rlcf	((___fldiv@grs))&0ffh
	rlcf	((___fldiv@grs+1))&0ffh
	rlcf	((___fldiv@grs+2))&0ffh
	rlcf	((___fldiv@grs+3))&0ffh
	line	133
	decf	((___fldiv@new_exp))&0ffh
	btfss	status,0
	decf	((___fldiv@new_exp+1))&0ffh
	line	127
	
l12487:; BSR set to: 1

	movlb	0	; () banked
	
	btfss	((___fldiv@b+2))&0ffh,(23)&7
	goto	u15131
	goto	u15130
u15131:
	goto	l12481
u15130:
	line	139
	
l12489:; BSR set to: 0

	movlw	low(0)
	movlb	1	; () banked
	movwf	((___fldiv@aexp))&0ffh
	line	140
	
l12491:; BSR set to: 1

	
	btfss	((___fldiv@grs+3))&0ffh,(31)&7
	goto	u15141
	goto	u15140
u15141:
	goto	l1544
u15140:
	line	141
	
l12493:; BSR set to: 1

	movlw	0FFh
	andwf	((___fldiv@grs))&0ffh,w
	movlb	0	; () banked
	movwf	(??___fldiv+0+0)&0ffh
	movlw	0FFh
	movlb	1	; () banked
	andwf	((___fldiv@grs+1))&0ffh,w
	movlb	0	; () banked
	movwf	1+(??___fldiv+0+0)&0ffh
	
	movlw	0FFh
	movlb	1	; () banked
	andwf	((___fldiv@grs+2))&0ffh,w
	movlb	0	; () banked
	movwf	2+(??___fldiv+0+0)&0ffh
	
	movlw	07Fh
	movlb	1	; () banked
	andwf	((___fldiv@grs+3))&0ffh,w
	movlb	0	; () banked
	movwf	3+(??___fldiv+0+0)&0ffh
	movf	(??___fldiv+0+0)&0ffh,w
iorwf	(??___fldiv+0+1)&0ffh,w
iorwf	(??___fldiv+0+2)&0ffh,w
iorwf	(??___fldiv+0+3)&0ffh,w
	btfsc	status,2
	goto	u15151
	goto	u15150

u15151:
	goto	l1545
u15150:
	line	142
	
l12495:; BSR set to: 0

	movlw	low(01h)
	movlb	1	; () banked
	movwf	((___fldiv@aexp))&0ffh
	line	143
	goto	l1544
	line	144
	
l1545:; BSR set to: 0

	line	145
	
	btfss	((___fldiv@b))&0ffh,(0)&7
	goto	u15161
	goto	u15160
u15161:
	goto	l1544
u15160:
	goto	l12495
	line	149
	
l1544:
	line	150
	movlb	1	; () banked
	movf	((___fldiv@aexp))&0ffh,w
	btfsc	status,2
	goto	u15171
	goto	u15170
u15171:
	goto	l12507
u15170:
	line	151
	
l12499:; BSR set to: 1

	movlw	low(01h)
	movlb	0	; () banked
	addwf	((___fldiv@b))&0ffh
	movlw	0
	addwfc	((___fldiv@b+1))&0ffh
	addwfc	((___fldiv@b+2))&0ffh
	addwfc	((___fldiv@b+3))&0ffh
	line	152
	
l12501:; BSR set to: 0

	
	btfss	((___fldiv@b+3))&0ffh,(24)&7
	goto	u15181
	goto	u15180
u15181:
	goto	l12507
u15180:
	line	153
	
l12503:; BSR set to: 0

	movff	(___fldiv@b),??___fldiv+0+0
	movff	(___fldiv@b+1),??___fldiv+0+0+1
	movff	(___fldiv@b+2),??___fldiv+0+0+2
	movff	(___fldiv@b+3),??___fldiv+0+0+3
	rlcf	(??___fldiv+0+3)&0ffh,w
	rrcf	(??___fldiv+0+3)&0ffh
	rrcf	(??___fldiv+0+2)&0ffh
	rrcf	(??___fldiv+0+1)&0ffh
	rrcf	(??___fldiv+0+0)&0ffh
	movff	??___fldiv+0+0,(___fldiv@b)
	movff	??___fldiv+0+1,(___fldiv@b+1)
	movff	??___fldiv+0+2,(___fldiv@b+2)
	movff	??___fldiv+0+3,(___fldiv@b+3)
	line	154
	
l12505:; BSR set to: 0

	movlb	1	; () banked
	infsnz	((___fldiv@new_exp))&0ffh
	incf	((___fldiv@new_exp+1))&0ffh
	line	159
	
l12507:
	movlb	1	; () banked
	btfsc	((___fldiv@new_exp+1))&0ffh,7
	goto	u15191
	movf	((___fldiv@new_exp+1))&0ffh,w
	bnz	u15190
	incf	((___fldiv@new_exp))&0ffh,w
	btfss	status,0
	goto	u15191
	goto	u15190

u15191:
	goto	l12511
u15190:
	line	160
	
l12509:; BSR set to: 1

	movlw	high(0FFh)
	movwf	((___fldiv@new_exp+1))&0ffh
	setf	((___fldiv@new_exp))&0ffh
	line	161
	movlw	low(0)
	movlb	0	; () banked
	movwf	((___fldiv@b))&0ffh
	movlw	high(0)
	movwf	((___fldiv@b+1))&0ffh
	movlw	low highword(0)
	movwf	((___fldiv@b+2))&0ffh
	movlw	high highword(0)
	movwf	((___fldiv@b+3))&0ffh
	line	165
	
l12511:
	movlb	1	; () banked
	btfsc	((___fldiv@new_exp+1))&0ffh,7
	goto	u15200
	movf	((___fldiv@new_exp+1))&0ffh,w
	bnz	u15201
	decf	((___fldiv@new_exp))&0ffh,w
	btfsc	status,0
	goto	u15201
	goto	u15200

u15201:
	goto	l12515
u15200:
	line	166
	
l12513:; BSR set to: 1

	movlw	high(0)
	movwf	((___fldiv@new_exp+1))&0ffh
	movlw	low(0)
	movwf	((___fldiv@new_exp))&0ffh
	line	167
	movlw	low(0)
	movlb	0	; () banked
	movwf	((___fldiv@b))&0ffh
	movlw	high(0)
	movwf	((___fldiv@b+1))&0ffh
	movlw	low highword(0)
	movwf	((___fldiv@b+2))&0ffh
	movlw	high highword(0)
	movwf	((___fldiv@b+3))&0ffh
	line	169
	movlw	low(0)
	movlb	1	; () banked
	movwf	((___fldiv@sign))&0ffh
	line	173
	
l12515:; BSR set to: 1

	movff	(___fldiv@new_exp),(___fldiv@bexp)
	line	175
	
l12517:; BSR set to: 1

	
	btfss	((___fldiv@bexp))&0ffh,(0)&7
	goto	u15211
	goto	u15210
u15211:
	goto	l12521
u15210:
	line	176
	
l12519:; BSR set to: 1

	movlb	0	; () banked
	bsf	(0+(7/8)+0+(___fldiv@b+02h))&0ffh,(7)&7
	line	177
	goto	l12523
	line	180
	
l12521:; BSR set to: 1

	movlb	0	; () banked
	bcf	(0+(7/8)+0+(___fldiv@b+02h))&0ffh,(7)&7
	line	182
	
l12523:; BSR set to: 0

	movlb	1	; () banked
	bcf	status,0
	rrcf	((___fldiv@bexp))&0ffh,w
	movlb	0	; () banked
	movwf	(0+(___fldiv@b+03h))&0ffh
	goto	l12437
	line	185
	
l1531:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of___fldiv
	__end_of___fldiv:
	signat	___fldiv,8316
	global	___fladd

;; *************** function ___fladd *****************
;; Defined at:
;;		line 10 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\sprcadd.c"
;; Parameters:    Size  Location     Type
;;  b               4    0[BANK2 ] unsigned char 
;;  a               4    4[BANK2 ] unsigned char 
;; Auto vars:     Size  Location     Type
;;  grs             1   16[BANK1 ] unsigned char 
;;  bexp            1   15[BANK1 ] unsigned char 
;;  aexp            1   14[BANK1 ] unsigned char 
;;  signs           1   13[BANK1 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  4    0[BANK2 ] unsigned char 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 3D/2
;;		On exit  : 3C/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       8       0       0       0       0       0
;;      Locals:         0       0       4       0       0       0       0       0       0
;;      Temps:          0       4       0       0       0       0       0       0       0
;;      Totals:         0       4       4       8       0       0       0       0       0
;;Total ram usage:       16 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_taskAplicacion
;;		_I2C_Master_Init
;; This function uses a non-reentrant model
;;
psect	text84,class=CODE,space=0,reloc=2,group=2
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\sprcadd.c"
	line	10
global __ptext84
__ptext84:
psect	text84
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\sprcadd.c"
	line	10
	
___fladd:; BSR set to: 0

;incstack = 0
	callstack 16
	line	21
	
l17429:
	movlb	2	; () banked
	movf	(0+(___fladd@b+03h))&0ffh,w
	andlw	low(080h)
	movlb	1	; () banked
	movwf	((___fladd@signs))&0ffh
	line	22
	movlb	2	; () banked
	movf	(0+(___fladd@b+03h))&0ffh,w
	addwf	(0+(___fladd@b+03h))&0ffh,w
	movlb	1	; () banked
	movwf	((___fladd@bexp))&0ffh
	line	23
	
l17431:; BSR set to: 1

	movlb	2	; () banked
	
	btfss	(0+(___fladd@b+02h))&0ffh,(7)&7
	goto	u21651
	goto	u21650
u21651:
	goto	l17435
u21650:
	line	24
	
l17433:; BSR set to: 2

	movlb	1	; () banked
	bsf	(0+(0/8)+(___fladd@bexp))&0ffh,(0)&7
	line	28
	
l17435:
	movlb	1	; () banked
	movf	((___fladd@bexp))&0ffh,w
	btfsc	status,2
	goto	u21661
	goto	u21660
u21661:
	goto	l17445
u21660:
	line	30
	
l17437:; BSR set to: 1

		incf	((___fladd@bexp))&0ffh,w
	btfss	status,2
	goto	u21671
	goto	u21670

u21671:
	goto	l17441
u21670:
	line	32
	
l17439:; BSR set to: 1

	movlw	low(normalize32(0x0))
	movlb	2	; () banked
	movwf	((___fladd@b))&0ffh
	movlw	high(normalize32(0x0))
	movwf	((___fladd@b+1))&0ffh
	movlw	low highword(normalize32(0x0))
	movwf	((___fladd@b+2))&0ffh
	movlw	high highword(normalize32(0x0))
	movwf	((___fladd@b+3))&0ffh
	line	35
	
l17441:
	movlb	2	; () banked
	bsf	(0+(23/8)+(___fladd@b))&0ffh,(23)&7
	line	37
	
l17443:; BSR set to: 2

	movlw	low(0)
	movwf	(0+(___fladd@b+03h))&0ffh
	line	38
	goto	l17447
	line	41
	
l17445:; BSR set to: 1

	movlw	low(normalize32(0x0))
	movlb	2	; () banked
	movwf	((___fladd@b))&0ffh
	movlw	high(normalize32(0x0))
	movwf	((___fladd@b+1))&0ffh
	movlw	low highword(normalize32(0x0))
	movwf	((___fladd@b+2))&0ffh
	movlw	high highword(normalize32(0x0))
	movwf	((___fladd@b+3))&0ffh
	line	44
	
l17447:; BSR set to: 2

	movf	(0+(___fladd@a+03h))&0ffh,w
	andlw	low(080h)
	movlb	1	; () banked
	movwf	((___fladd@aexp))&0ffh
	line	46
	
l17449:; BSR set to: 1

	movf	((___fladd@signs))&0ffh,w
xorwf	((___fladd@aexp))&0ffh,w
	btfsc	status,2
	goto	u21681
	goto	u21680

u21681:
	goto	l17453
u21680:
	line	47
	
l17451:; BSR set to: 1

	bsf	(0+(6/8)+(___fladd@signs))&0ffh,(6)&7
	line	49
	
l17453:; BSR set to: 1

	movlb	2	; () banked
	movf	(0+(___fladd@a+03h))&0ffh,w
	addwf	(0+(___fladd@a+03h))&0ffh,w
	movlb	1	; () banked
	movwf	((___fladd@aexp))&0ffh
	line	50
	
l17455:; BSR set to: 1

	movlb	2	; () banked
	
	btfss	(0+(___fladd@a+02h))&0ffh,(7)&7
	goto	u21691
	goto	u21690
u21691:
	goto	l17459
u21690:
	line	51
	
l17457:; BSR set to: 2

	movlb	1	; () banked
	bsf	(0+(0/8)+(___fladd@aexp))&0ffh,(0)&7
	line	55
	
l17459:
	movlb	1	; () banked
	movf	((___fladd@aexp))&0ffh,w
	btfsc	status,2
	goto	u21701
	goto	u21700
u21701:
	goto	l17469
u21700:
	line	57
	
l17461:; BSR set to: 1

		incf	((___fladd@aexp))&0ffh,w
	btfss	status,2
	goto	u21711
	goto	u21710

u21711:
	goto	l17465
u21710:
	line	59
	
l17463:; BSR set to: 1

	movlw	low(normalize32(0x0))
	movlb	2	; () banked
	movwf	((___fladd@a))&0ffh
	movlw	high(normalize32(0x0))
	movwf	((___fladd@a+1))&0ffh
	movlw	low highword(normalize32(0x0))
	movwf	((___fladd@a+2))&0ffh
	movlw	high highword(normalize32(0x0))
	movwf	((___fladd@a+3))&0ffh
	line	62
	
l17465:
	movlb	2	; () banked
	bsf	(0+(23/8)+(___fladd@a))&0ffh,(23)&7
	line	64
	
l17467:; BSR set to: 2

	movlw	low(0)
	movwf	(0+(___fladd@a+03h))&0ffh
	line	65
	goto	l17471
	line	68
	
l17469:; BSR set to: 1

	movlw	low(normalize32(0x0))
	movlb	2	; () banked
	movwf	((___fladd@a))&0ffh
	movlw	high(normalize32(0x0))
	movwf	((___fladd@a+1))&0ffh
	movlw	low highword(normalize32(0x0))
	movwf	((___fladd@a+2))&0ffh
	movlw	high highword(normalize32(0x0))
	movwf	((___fladd@a+3))&0ffh
	line	75
	
l17471:; BSR set to: 2

	movlb	1	; () banked
		movf	((___fladd@bexp))&0ffh,w
	subwf	((___fladd@aexp))&0ffh,w
	btfsc	status,0
	goto	u21721
	goto	u21720

u21721:
	goto	l17507
u21720:
	line	77
	
l17473:; BSR set to: 1

	
	btfss	((___fladd@signs))&0ffh,(6)&7
	goto	u21731
	goto	u21730
u21731:
	goto	l17477
u21730:
	line	78
	
l17475:; BSR set to: 1

	movlw	(080h)&0ffh
	xorwf	((___fladd@signs))&0ffh
	line	81
	
l17477:; BSR set to: 1

	movff	(___fladd@bexp),(___fladd@grs)
	line	82
	
l17479:; BSR set to: 1

	movff	(___fladd@aexp),(___fladd@bexp)
	line	83
	
l17481:; BSR set to: 1

	movff	(___fladd@grs),(___fladd@aexp)
	line	84
	
l17483:; BSR set to: 1

	movff	(___fladd@b),(___fladd@grs)
	line	85
	
l17485:; BSR set to: 1

	movff	(___fladd@a),(___fladd@b)
	line	86
	
l17487:; BSR set to: 1

	movff	(___fladd@grs),(___fladd@a)
	line	87
	
l17489:; BSR set to: 1

	movff	0+(___fladd@b+01h),(___fladd@grs)
	line	88
	
l17491:; BSR set to: 1

	movff	0+(___fladd@a+01h),0+(___fladd@b+01h)
	line	89
	
l17493:; BSR set to: 1

	movff	(___fladd@grs),0+(___fladd@a+01h)
	line	90
	
l17495:; BSR set to: 1

	movff	0+(___fladd@b+02h),(___fladd@grs)
	line	91
	
l17497:; BSR set to: 1

	movff	0+(___fladd@a+02h),0+(___fladd@b+02h)
	line	92
	
l17499:; BSR set to: 1

	movff	(___fladd@grs),0+(___fladd@a+02h)
	line	93
	
l17501:; BSR set to: 1

	movff	0+(___fladd@b+03h),(___fladd@grs)
	line	94
	
l17503:; BSR set to: 1

	movff	0+(___fladd@a+03h),0+(___fladd@b+03h)
	line	95
	
l17505:; BSR set to: 1

	movff	(___fladd@grs),0+(___fladd@a+03h)
	line	98
	
l17507:; BSR set to: 1

	movlw	low(0)
	movwf	((___fladd@grs))&0ffh
	line	100
	
l17509:; BSR set to: 1

	movf	((___fladd@bexp))&0ffh,w
	movff	(___fladd@aexp),??___fladd+0+0
	movlb	0	; () banked
	clrf	(??___fladd+0+0+1)&0ffh
	subwf	(??___fladd+0+0)&0ffh
	movlw	0
	subwfb	(??___fladd+0+1)&0ffh
	btfsc	(??___fladd+0+1)&0ffh,7
	goto	u21741
	movf	(??___fladd+0+1)&0ffh,w
	bnz	u21740
	movlw	26
	subwf	 (??___fladd+0+0)&0ffh,w
	btfss	status,0
	goto	u21741
	goto	u21740

u21741:
	goto	l1478
u21740:
	line	101
	
l17511:; BSR set to: 0

	movlb	2	; () banked
	movf	((___fladd@b))&0ffh,w
iorwf	((___fladd@b+1))&0ffh,w
iorwf	((___fladd@b+2))&0ffh,w
iorwf	((___fladd@b+3))&0ffh,w
	btfss	status,2
	goto	u21751
	goto	u21750

u21751:
	movlw	1
	goto	u21760
u21750:
	movlw	0
u21760:
	movlb	1	; () banked
	movwf	((___fladd@grs))&0ffh
	line	102
	
l17513:; BSR set to: 1

	movlw	low(0)
	movlb	2	; () banked
	movwf	((___fladd@b))&0ffh
	movlw	high(0)
	movwf	((___fladd@b+1))&0ffh
	movlw	low highword(0)
	movwf	((___fladd@b+2))&0ffh
	movlw	high highword(0)
	movwf	((___fladd@b+3))&0ffh
	line	103
	
l17515:; BSR set to: 2

	movff	(___fladd@aexp),(___fladd@bexp)
	line	104
	goto	l1477
	line	106
	
l1479:; BSR set to: 1

	line	109
	
	btfss	((___fladd@grs))&0ffh,(0)&7
	goto	u21771
	goto	u21770
u21771:
	goto	l17519
u21770:
	line	110
	
l17517:; BSR set to: 1

	bcf	status,0
	rrcf	((___fladd@grs))&0ffh,w
	iorlw	low(01h)
	movwf	((___fladd@grs))&0ffh
	line	111
	goto	l17521
	line	113
	
l17519:; BSR set to: 1

	bcf status,0
	rrcf	((___fladd@grs))&0ffh

	line	115
	
l17521:; BSR set to: 1

	movlb	2	; () banked
	
	btfss	((___fladd@b))&0ffh,(0)&7
	goto	u21781
	goto	u21780
u21781:
	goto	l17525
u21780:
	line	116
	
l17523:; BSR set to: 2

	movlb	1	; () banked
	bsf	(0+(7/8)+(___fladd@grs))&0ffh,(7)&7
	line	118
	
l17525:
	movlb	2	; () banked
	rlcf	((___fladd@b+3))&0ffh,w
	rrcf	((___fladd@b+3))&0ffh
	rrcf	((___fladd@b+2))&0ffh
	rrcf	((___fladd@b+1))&0ffh
	rrcf	((___fladd@b))&0ffh
	line	119
	
l17527:; BSR set to: 2

	movlb	1	; () banked
	incf	((___fladd@bexp))&0ffh
	line	120
	
l1478:
	line	106
	movlb	1	; () banked
		movf	((___fladd@aexp))&0ffh,w
	subwf	((___fladd@bexp))&0ffh,w
	btfss	status,0
	goto	u21791
	goto	u21790

u21791:
	goto	l1479
u21790:
	line	121
	
l1477:
	line	124
	movlb	1	; () banked
	
	btfsc	((___fladd@signs))&0ffh,(6)&7
	goto	u21801
	goto	u21800
u21801:
	goto	l17553
u21800:
	line	127
	
l17529:; BSR set to: 1

	movf	((___fladd@bexp))&0ffh,w
	btfss	status,2
	goto	u21811
	goto	u21810
u21811:
	goto	l17535
u21810:
	line	128
	
l17531:; BSR set to: 1

	movlw	low(normalize32(0x0))
	movlb	2	; () banked
	movwf	((?___fladd))&0ffh
	movlw	high(normalize32(0x0))
	movwf	((?___fladd+1))&0ffh
	movlw	low highword(normalize32(0x0))
	movwf	((?___fladd+2))&0ffh
	movlw	high highword(normalize32(0x0))
	movwf	((?___fladd+3))&0ffh
	goto	l1486
	line	132
	
l17535:; BSR set to: 1

	movlb	2	; () banked
	movf	((___fladd@a))&0ffh,w
	addwf	((___fladd@b))&0ffh
	movf	((___fladd@a+1))&0ffh,w
	addwfc	((___fladd@b+1))&0ffh
	movf	((___fladd@a+2))&0ffh,w
	addwfc	((___fladd@b+2))&0ffh
	movf	((___fladd@a+3))&0ffh,w
	addwfc	((___fladd@b+3))&0ffh
	line	134
	
l17537:; BSR set to: 2

	
	btfss	((___fladd@b+3))&0ffh,(24)&7
	goto	u21821
	goto	u21820
u21821:
	goto	l17589
u21820:
	line	135
	
l17539:; BSR set to: 2

	movlb	1	; () banked
	
	btfss	((___fladd@grs))&0ffh,(0)&7
	goto	u21831
	goto	u21830
u21831:
	goto	l17543
u21830:
	line	136
	
l17541:; BSR set to: 1

	bcf	status,0
	rrcf	((___fladd@grs))&0ffh,w
	iorlw	low(01h)
	movwf	((___fladd@grs))&0ffh
	line	137
	goto	l17545
	line	139
	
l17543:; BSR set to: 1

	bcf status,0
	rrcf	((___fladd@grs))&0ffh

	line	141
	
l17545:; BSR set to: 1

	movlb	2	; () banked
	
	btfss	((___fladd@b))&0ffh,(0)&7
	goto	u21841
	goto	u21840
u21841:
	goto	l17549
u21840:
	line	142
	
l17547:; BSR set to: 2

	movlb	1	; () banked
	bsf	(0+(7/8)+(___fladd@grs))&0ffh,(7)&7
	line	144
	
l17549:
	movlb	2	; () banked
	rlcf	((___fladd@b+3))&0ffh,w
	rrcf	((___fladd@b+3))&0ffh
	rrcf	((___fladd@b+2))&0ffh
	rrcf	((___fladd@b+1))&0ffh
	rrcf	((___fladd@b))&0ffh
	line	145
	
l17551:; BSR set to: 2

	movlb	1	; () banked
	incf	((___fladd@bexp))&0ffh
	goto	l17589
	line	153
	
l17553:; BSR set to: 1

	movlb	2	; () banked
		movf	((___fladd@a))&0ffh,w
	subwf	((___fladd@b))&0ffh,w
	movf	((___fladd@a+1))&0ffh,w
	subwfb	((___fladd@b+1))&0ffh,w
	movf	((___fladd@a+2))&0ffh,w
	subwfb	((___fladd@b+2))&0ffh,w
	movf	((___fladd@b+3))&0ffh,w
	xorlw	80h
	movlb	0	; () banked
	movwf	(??___fladd+0+0)&0ffh
	movlb	2	; () banked
	movf	((___fladd@a+3))&0ffh,w
	xorlw	80h
	movlb	0	; () banked
	subwfb	(??___fladd+0+0)&0ffh,w
	btfsc	status,0
	goto	u21851
	goto	u21850

u21851:
	goto	l17563
u21850:
	line	154
	
l17555:; BSR set to: 0

	movlb	2	; () banked
	movf	((___fladd@b))&0ffh,w
	subwf	((___fladd@a))&0ffh,w
	movlb	0	; () banked
	movwf	(??___fladd+0+0)&0ffh
	movlb	2	; () banked
	movf	((___fladd@b+1))&0ffh,w
	subwfb	((___fladd@a+1))&0ffh,w
	movlb	0	; () banked
	movwf	1+(??___fladd+0+0)&0ffh
	
	movlb	2	; () banked
	movf	((___fladd@b+2))&0ffh,w
	subwfb	((___fladd@a+2))&0ffh,w
	movlb	0	; () banked
	movwf	2+(??___fladd+0+0)&0ffh
	
	movlb	2	; () banked
	movf	((___fladd@b+3))&0ffh,w
	subwfb	((___fladd@a+3))&0ffh,w
	movlb	0	; () banked
	movwf	3+(??___fladd+0+0)&0ffh
	movlw	0FFh
	addwf	(??___fladd+0+0)&0ffh,w
	movlb	2	; () banked
	movwf	((___fladd@b))&0ffh
	movlw	0FFh
	movlb	0	; () banked
	addwfc	(??___fladd+0+1)&0ffh,w
	movlb	2	; () banked
	movwf	1+((___fladd@b))&0ffh
	
	movlw	0FFh
	movlb	0	; () banked
	addwfc	(??___fladd+0+2)&0ffh,w
	movlb	2	; () banked
	movwf	2+((___fladd@b))&0ffh
	
	movlw	0FFh
	movlb	0	; () banked
	addwfc	(??___fladd+0+3)&0ffh,w
	movlb	2	; () banked
	movwf	3+((___fladd@b))&0ffh
	line	155
	movlw	(080h)&0ffh
	movlb	1	; () banked
	xorwf	((___fladd@signs))&0ffh
	line	156
	
l17557:; BSR set to: 1

	negf	((___fladd@grs))&0ffh
	line	157
	
l17559:; BSR set to: 1

	movf	((___fladd@grs))&0ffh,w
	btfss	status,2
	goto	u21861
	goto	u21860
u21861:
	goto	l1494
u21860:
	line	158
	
l17561:; BSR set to: 1

	movlw	low(01h)
	movlb	2	; () banked
	addwf	((___fladd@b))&0ffh
	movlw	0
	addwfc	((___fladd@b+1))&0ffh
	addwfc	((___fladd@b+2))&0ffh
	addwfc	((___fladd@b+3))&0ffh
	goto	l1494
	line	162
	
l17563:; BSR set to: 0

	movlb	2	; () banked
	movf	((___fladd@a))&0ffh,w
	subwf	((___fladd@b))&0ffh
	movf	((___fladd@a+1))&0ffh,w
	subwfb	((___fladd@b+1))&0ffh
	movf	((___fladd@a+2))&0ffh,w
	subwfb	((___fladd@b+2))&0ffh
	movf	((___fladd@a+3))&0ffh,w
	subwfb	((___fladd@b+3))&0ffh
	line	163
	
l1494:
	line	166
	movlb	2	; () banked
	movf	((___fladd@b))&0ffh,w
iorwf	((___fladd@b+1))&0ffh,w
iorwf	((___fladd@b+2))&0ffh,w
iorwf	((___fladd@b+3))&0ffh,w
	btfss	status,2
	goto	u21871
	goto	u21870

u21871:
	goto	l17587
u21870:
	
l17565:; BSR set to: 2

	movlb	1	; () banked
	movf	((___fladd@grs))&0ffh,w
	btfss	status,2
	goto	u21881
	goto	u21880
u21881:
	goto	l17587
u21880:
	line	167
	
l17567:; BSR set to: 1

	movlw	low(normalize32(0x0))
	movlb	2	; () banked
	movwf	((?___fladd))&0ffh
	movlw	high(normalize32(0x0))
	movwf	((?___fladd+1))&0ffh
	movlw	low highword(normalize32(0x0))
	movwf	((?___fladd+2))&0ffh
	movlw	high highword(normalize32(0x0))
	movwf	((?___fladd+3))&0ffh
	goto	l1486
	line	172
	
l17571:; BSR set to: 2

	bcf	status,0
	rlcf	((___fladd@b))&0ffh
	rlcf	((___fladd@b+1))&0ffh
	rlcf	((___fladd@b+2))&0ffh
	rlcf	((___fladd@b+3))&0ffh
	line	173
	
l17573:; BSR set to: 2

	movlb	1	; () banked
	
	btfss	((___fladd@grs))&0ffh,(7)&7
	goto	u21891
	goto	u21890
u21891:
	goto	l17577
u21890:
	line	174
	
l17575:; BSR set to: 1

	movlb	2	; () banked
	bsf	(0+(0/8)+(___fladd@b))&0ffh,(0)&7
	line	176
	
l17577:
	movlb	1	; () banked
	
	btfss	((___fladd@grs))&0ffh,(0)&7
	goto	u21901
	goto	u21900
u21901:
	goto	l17581
u21900:
	line	177
	
l17579:; BSR set to: 1

	bsf	status,0
	
	rlcf	((___fladd@grs))&0ffh
	line	178
	goto	l17583
	line	180
	
l17581:; BSR set to: 1

	bcf status,0
	rlcf	((___fladd@grs))&0ffh

	line	182
	
l17583:; BSR set to: 1

	movf	((___fladd@bexp))&0ffh,w
	btfsc	status,2
	goto	u21911
	goto	u21910
u21911:
	goto	l17587
u21910:
	line	183
	
l17585:; BSR set to: 1

	decf	((___fladd@bexp))&0ffh
	line	171
	
l17587:
	movlb	2	; () banked
	
	btfss	((___fladd@b+2))&0ffh,(23)&7
	goto	u21921
	goto	u21920
u21921:
	goto	l17571
u21920:
	line	192
	
l17589:
	movlw	low(0)
	movlb	1	; () banked
	movwf	((___fladd@aexp))&0ffh
	line	193
	
l17591:; BSR set to: 1

	
	btfss	((___fladd@grs))&0ffh,(7)&7
	goto	u21931
	goto	u21930
u21931:
	goto	l1503
u21930:
	line	194
	
l17593:; BSR set to: 1

	movff	(___fladd@grs),??___fladd+0+0
	movlw	07Fh
	movlb	0	; () banked
	andwf	(??___fladd+0+0)&0ffh
	btfsc	status,2
	goto	u21941
	goto	u21940
u21941:
	goto	l1504
u21940:
	line	195
	
l17595:
	movlw	low(01h)
	movlb	1	; () banked
	movwf	((___fladd@aexp))&0ffh
	line	196
	goto	l1503
	line	197
	
l1504:; BSR set to: 0

	line	198
	movlb	2	; () banked
	
	btfss	((___fladd@b))&0ffh,(0)&7
	goto	u21951
	goto	u21950
u21951:
	goto	l1503
u21950:
	goto	l17595
	line	202
	
l1503:
	line	203
	movlb	1	; () banked
	movf	((___fladd@aexp))&0ffh,w
	btfsc	status,2
	goto	u21961
	goto	u21960
u21961:
	goto	l17607
u21960:
	line	204
	
l17599:; BSR set to: 1

	movlw	low(01h)
	movlb	2	; () banked
	addwf	((___fladd@b))&0ffh
	movlw	0
	addwfc	((___fladd@b+1))&0ffh
	addwfc	((___fladd@b+2))&0ffh
	addwfc	((___fladd@b+3))&0ffh
	line	205
	
l17601:; BSR set to: 2

	
	btfss	((___fladd@b+3))&0ffh,(24)&7
	goto	u21971
	goto	u21970
u21971:
	goto	l17607
u21970:
	line	206
	
l17603:; BSR set to: 2

	movff	(___fladd@b),??___fladd+0+0
	movff	(___fladd@b+1),??___fladd+0+0+1
	movff	(___fladd@b+2),??___fladd+0+0+2
	movff	(___fladd@b+3),??___fladd+0+0+3
	movlb	0	; () banked
	rlcf	(??___fladd+0+3)&0ffh,w
	rrcf	(??___fladd+0+3)&0ffh
	rrcf	(??___fladd+0+2)&0ffh
	rrcf	(??___fladd+0+1)&0ffh
	rrcf	(??___fladd+0+0)&0ffh
	movff	??___fladd+0+0,(___fladd@b)
	movff	??___fladd+0+1,(___fladd@b+1)
	movff	??___fladd+0+2,(___fladd@b+2)
	movff	??___fladd+0+3,(___fladd@b+3)
	line	207
	movlb	1	; () banked
		incf	((___fladd@bexp))&0ffh,w
	btfsc	status,2
	goto	u21981
	goto	u21980

u21981:
	goto	l17607
u21980:
	line	208
	
l17605:; BSR set to: 1

	incf	((___fladd@bexp))&0ffh
	line	215
	
l17607:
	movlb	1	; () banked
		incf	((___fladd@bexp))&0ffh,w
	btfsc	status,2
	goto	u21991
	goto	u21990

u21991:
	goto	l17611
u21990:
	
l17609:; BSR set to: 1

	movf	((___fladd@bexp))&0ffh,w
	btfss	status,2
	goto	u22001
	goto	u22000
u22001:
	goto	l17615
u22000:
	line	216
	
l17611:; BSR set to: 1

	movlw	low(0)
	movlb	2	; () banked
	movwf	((___fladd@b))&0ffh
	movlw	high(0)
	movwf	((___fladd@b+1))&0ffh
	movlw	low highword(0)
	movwf	((___fladd@b+2))&0ffh
	movlw	high highword(0)
	movwf	((___fladd@b+3))&0ffh
	line	218
	movlb	1	; () banked
	movf	((___fladd@bexp))&0ffh,w
	btfss	status,2
	goto	u22011
	goto	u22010
u22011:
	goto	l17615
u22010:
	line	219
	
l17613:; BSR set to: 1

	movlw	low(0)
	movwf	((___fladd@signs))&0ffh
	line	225
	
l17615:; BSR set to: 1

	
	btfss	((___fladd@bexp))&0ffh,(0)&7
	goto	u22021
	goto	u22020
u22021:
	goto	l17619
u22020:
	line	226
	
l17617:; BSR set to: 1

	movlb	2	; () banked
	bsf	(0+(7/8)+0+(___fladd@b+02h))&0ffh,(7)&7
	line	227
	goto	l17621
	line	230
	
l17619:; BSR set to: 1

	movlb	2	; () banked
	bcf	(0+(7/8)+0+(___fladd@b+02h))&0ffh,(7)&7
	line	232
	
l17621:; BSR set to: 2

	movlb	1	; () banked
	bcf	status,0
	rrcf	((___fladd@bexp))&0ffh,w
	movlb	2	; () banked
	movwf	(0+(___fladd@b+03h))&0ffh
	line	233
	
l17623:; BSR set to: 2

	movlb	1	; () banked
	
	btfss	((___fladd@signs))&0ffh,(7)&7
	goto	u22031
	goto	u22030
u22031:
	goto	l17627
u22030:
	line	234
	
l17625:; BSR set to: 1

	movlb	2	; () banked
	bsf	(0+(7/8)+0+(___fladd@b+03h))&0ffh,(7)&7
	line	236
	
l17627:
	movff	(___fladd@b),(?___fladd)
	movff	(___fladd@b+1),(?___fladd+1)
	movff	(___fladd@b+2),(?___fladd+2)
	movff	(___fladd@b+3),(?___fladd+3)
	line	237
	
l1486:
	return	;funcret
	callstack 0
GLOBAL	__end_of___fladd
	__end_of___fladd:
	signat	___fladd,8316
	global	_ADC_init

;; *************** function _ADC_init *****************
;; Defined at:
;;		line 172 in file "main.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 3F/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 12
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text85,class=CODE,space=0,reloc=2,group=0
	file	"main.c"
	line	172
global __ptext85
__ptext85:
psect	text85
	file	"main.c"
	line	172
	
_ADC_init:
;incstack = 0
	callstack 18
	line	174
	
l7863:; BSR set to: 0

	movlw	((0 & ((1<<2)-1))<<4)|not (((1<<2)-1)<<4)
	andwf	((c:4033))^0f00h,c	;volatile
	line	175
	movf	((c:4033))^0f00h,c,w	;volatile
	andlw	not (((1<<4)-1)<<0)
	iorlw	(0Bh & ((1<<4)-1))<<0
	movwf	((c:4033))^0f00h,c	;volatile
	line	177
	movf	((c:4032))^0f00h,c,w	;volatile
	andlw	not (((1<<3)-1)<<3)
	iorlw	(02h & ((1<<3)-1))<<3
	movwf	((c:4032))^0f00h,c	;volatile
	line	178
	movf	((c:4032))^0f00h,c,w	;volatile
	andlw	not (((1<<3)-1)<<0)
	iorlw	(04h & ((1<<3)-1))<<0
	movwf	((c:4032))^0f00h,c	;volatile
	line	179
	
l7865:; BSR set to: 0

	bsf	((c:4032))^0f00h,c,7	;volatile
	line	181
	
l7867:; BSR set to: 0

	bsf	((c:4034))^0f00h,c,0	;volatile
	line	182
	
l155:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_ADC_init
	__end_of_ADC_init:
	signat	_ADC_init,89
	global	_INT_ISR_LOW

;; *************** function _INT_ISR_LOW *****************
;; Defined at:
;;		line 92 in file "main.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0      13       0       0       0       0       0       0       0
;;      Totals:         0      13       0       0       0       0       0       0       0
;;Total ram usage:       13 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 11
;; This function calls:
;;		_printf
;; This function is called by:
;;		Interrupt level 1
;; This function uses a non-reentrant model
;;
psect	intcodelo,class=CODE,space=0,reloc=2
	file	"D:\@Proyect\Baliza\1 Firmware\Doc mplabx\build_xc8\main.as"
	line	#
global __pintcodelo
__pintcodelo:
psect	intcodelo
	file	"main.c"
	line	92
	
_INT_ISR_LOW:; BSR set to: 0

;incstack = 0
	callstack 6
	bsf int$flags,0,c ;set compiler interrupt flag (level 1)
	movff	status+0,??_INT_ISR_LOW+2
	movff	wreg+0,??_INT_ISR_LOW+3
	movff	bsr+0,??_INT_ISR_LOW+4
	movff	fsr1l+0,??_INT_ISR_LOW+5
	movff	fsr1h+0,??_INT_ISR_LOW+6
	movff	fsr2l+0,??_INT_ISR_LOW+7
	movff	fsr2h+0,??_INT_ISR_LOW+8
	movff	tblptrl+0,??_INT_ISR_LOW+9
	movff	tblptrh+0,??_INT_ISR_LOW+10
	movff	tblptru+0,??_INT_ISR_LOW+11
	movff	tablat+0,??_INT_ISR_LOW+12
	line	94
	
i1l18217:
	btfss	((c:4080))^0f00h,c,3	;volatile
	goto	i1u2280_21
	goto	i1u2280_20
i1u2280_21:
	goto	i1l141
i1u2280_20:
	
i1l18219:
	btfss	((c:4080))^0f00h,c,0	;volatile
	goto	i1u2281_21
	goto	i1u2281_20
i1u2281_21:
	goto	i1l141
i1u2281_20:
	line	96
	
i1l18221:
		movlw	low(STR_1)
	movlb	0	; () banked
	movwf	((printf@fmt))&0ffh
	movlw	high(STR_1)
	movwf	((printf@fmt+1))&0ffh

	call	_printf	;wreg free
	line	97
	
i1l18223:; BSR set to: 1

	asmopt push
asmopt off
movlw  102
	movlb	0	; () banked
movwf	(??_INT_ISR_LOW+0+0+1)&0ffh
movlw	118
movwf	(??_INT_ISR_LOW+0+0)&0ffh
	movlw	193
i1u2282_27:
decfsz	wreg,f
	bra	i1u2282_27
	decfsz	(??_INT_ISR_LOW+0+0)&0ffh,f
	bra	i1u2282_27
	decfsz	(??_INT_ISR_LOW+0+0+1)&0ffh,f
	bra	i1u2282_27
asmopt pop

	line	98
	
i1l18225:
		movlw	low(STR_2)
	movlb	0	; () banked
	movwf	((printf@fmt))&0ffh
	movlw	high(STR_2)
	movwf	((printf@fmt+1))&0ffh

	call	_printf	;wreg free
	line	99
	
i1l18227:; BSR set to: 1

	bcf	((c:4080))^0f00h,c,0	;volatile
	line	101
	
i1l141:
	movff	??_INT_ISR_LOW+12,tablat+0
	movff	??_INT_ISR_LOW+11,tblptru+0
	movff	??_INT_ISR_LOW+10,tblptrh+0
	movff	??_INT_ISR_LOW+9,tblptrl+0
	movff	??_INT_ISR_LOW+8,fsr2h+0
	movff	??_INT_ISR_LOW+7,fsr2l+0
	movff	??_INT_ISR_LOW+6,fsr1h+0
	movff	??_INT_ISR_LOW+5,fsr1l+0
	movff	??_INT_ISR_LOW+4,bsr+0
	movff	??_INT_ISR_LOW+3,wreg+0
	movff	??_INT_ISR_LOW+2,status+0
	bcf int$flags,0,c ;clear compiler interrupt flag (level 1)
	retfie
	callstack 0
GLOBAL	__end_of_INT_ISR_LOW
	__end_of_INT_ISR_LOW:
	signat	_INT_ISR_LOW,89
	global	_printf

;; *************** function _printf *****************
;; Defined at:
;;		line 5 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\printf.c"
;; Parameters:    Size  Location     Type
;;  fmt             2   20[BANK0 ] PTR const unsigned char 
;;		 -> STR_2(24), STR_1(27), 
;; Auto vars:     Size  Location     Type
;;  ap              2   22[BANK0 ] PTR void [1]
;;		 -> ?_printf(2), ?_sprintf(2), 
;;  ret             2    0        int 
;; Return value:  Size  Location     Type
;;                  2   20[BANK0 ] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/1
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       2       0       0       0       0       0       0       0
;;      Locals:         0       2       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       4       0       0       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 10
;; This function calls:
;;		i1_vfprintf
;; This function is called by:
;;		_INT_ISR_LOW
;; This function uses a non-reentrant model
;;
psect	text87,class=CODE,space=0,reloc=2,group=3
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\printf.c"
	line	5
global __ptext87
__ptext87:
psect	text87
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\printf.c"
	line	5
	
_printf:
;incstack = 0
	callstack 6
	line	9
	
i1l18199:; BSR set to: 0

		movlw	low(?_printf+02h)
	movwf	((printf@ap))&0ffh
	clrf	((printf@ap+1))&0ffh

	line	10
	
i1l18201:; BSR set to: 0

		movlw	low(0)
	movwf	((i1vfprintf@fp))&0ffh
	movlw	high(0)
	movwf	((i1vfprintf@fp+1))&0ffh

		movff	(printf@fmt),(i1vfprintf@fmt)
	movff	(printf@fmt+1),(i1vfprintf@fmt+1)

		movlw	low(printf@ap)
	movwf	((i1vfprintf@ap))&0ffh
	clrf	((i1vfprintf@ap+1))&0ffh

	call	i1_vfprintf	;wreg free
	line	13
	
i1l1820:; BSR set to: 1

	return	;funcret
	callstack 0
GLOBAL	__end_of_printf
	__end_of_printf:
	signat	_printf,602
	global	i1_vfprintf

;; *************** function i1_vfprintf *****************
;; Defined at:
;;		line 1390 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
;; Parameters:    Size  Location     Type
;;  fp              2   12[BANK0 ] PTR struct _IO_FILE
;;		 -> sprintf@f(11), NULL(0), 
;;  fmt             2   14[BANK0 ] PTR const unsigned char 
;;		 -> STR_16(4), STR_15(3), STR_14(3), STR_13(3), 
;;		 -> STR_12(4), STR_11(38), STR_10(36), STR_9(36), 
;;		 -> STR_8(36), STR_7(36), STR_6(43), STR_5(18), 
;;		 -> STR_4(11), STR_2(24), STR_1(27), 
;;  ap              2   16[BANK0 ] PTR PTR void 
;;		 -> printf@ap(2), sprintf@ap(2), 
;; Auto vars:     Size  Location     Type
;;  cfmt            2   18[BANK0 ] PTR unsigned char 
;;		 -> STR_16(4), STR_15(3), STR_14(3), STR_13(3), 
;;		 -> STR_12(4), STR_11(38), STR_10(36), STR_9(36), 
;;		 -> STR_8(36), STR_7(36), STR_6(43), STR_5(18), 
;;		 -> STR_4(11), STR_2(24), STR_1(27), 
;; Return value:  Size  Location     Type
;;                  2   12[BANK0 ] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/1
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       6       0       0       0       0       0       0       0
;;      Locals:         0       2       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       8       0       0       0       0       0       0       0
;;Total ram usage:        8 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 9
;; This function calls:
;;		i1_vfpfcnvrt
;; This function is called by:
;;		_printf
;; This function uses a non-reentrant model
;;
psect	text88,class=CODE,space=0,reloc=2,group=0
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
	line	1390
global __ptext88
__ptext88:
psect	text88
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
	line	1390
	
i1_vfprintf:; BSR set to: 1

;incstack = 0
	callstack 6
	line	1395
	
i1l18191:; BSR set to: 0

		movff	(i1vfprintf@fmt),(i1vfprintf@cfmt)
	movff	(i1vfprintf@fmt+1),(i1vfprintf@cfmt+1)

	line	1396
	
i1l18193:; BSR set to: 0

	movlw	high(0)
	movlb	1	; () banked
	movwf	((_nout+1))&0ffh
	movlw	low(0)
	movwf	((_nout))&0ffh
	line	1397
	goto	i1l18197
	line	1398
	
i1l18195:; BSR set to: 1

		movff	(i1vfprintf@fp),(c:i1vfpfcnvrt@fp)
	movff	(i1vfprintf@fp+1),(c:i1vfpfcnvrt@fp+1)

		movlw	low(i1vfprintf@cfmt)
	movwf	((c:i1vfpfcnvrt@fmt))^00h,c
	clrf	((c:i1vfpfcnvrt@fmt+1))^00h,c

		movff	(i1vfprintf@ap),(c:i1vfpfcnvrt@ap)
	movff	(i1vfprintf@ap+1),(c:i1vfpfcnvrt@ap+1)

	call	i1_vfpfcnvrt	;wreg free
	movf	(0+?i1_vfpfcnvrt)^00h,c,w
	movlb	1	; () banked
	addwf	((_nout))&0ffh
	movf	(1+?i1_vfpfcnvrt)^00h,c,w
	addwfc	((_nout+1))&0ffh

	line	1397
	
i1l18197:; BSR set to: 1

	movff	(i1vfprintf@cfmt),tblptrl
	movff	(i1vfprintf@cfmt+1),tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	iorlw	0
	btfss	status,2
	goto	i1u2279_21
	goto	i1u2279_20
i1u2279_21:
	goto	i1l18195
i1u2279_20:
	
i1l1785:; BSR set to: 1

	line	1400
	movff	(_nout),(?i1_vfprintf)
	movff	(_nout+1),(?i1_vfprintf+1)
	line	1404
	
i1l1786:; BSR set to: 1

	return	;funcret
	callstack 0
GLOBAL	__end_ofi1_vfprintf
	__end_ofi1_vfprintf:
	signat	i1_vfprintf,12378
	global	i1_vfpfcnvrt

;; *************** function i1_vfpfcnvrt *****************
;; Defined at:
;;		line 692 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
;; Parameters:    Size  Location     Type
;;  fp              2   71[COMRAM] PTR struct _IO_FILE
;;		 -> sprintf@f(11), NULL(0), 
;;  fmt             2   73[COMRAM] PTR PTR unsigned char 
;;		 -> i1vfprintf@cfmt(2), vfprintf@cfmt(2), 
;;  ap              2   75[COMRAM] PTR PTR void 
;;		 -> printf@ap(2), sprintf@ap(2), 
;; Auto vars:     Size  Location     Type
;;  ll              8    0[BANK0 ] long long 
;;  llu             8    0        unsigned long long 
;;  f               4    0        unsigned long long 
;;  vp              3    0        PTR void 
;;  ct              3    0        unsigned char [3]
;;  cp              2    8[BANK0 ] PTR unsigned char 
;;		 -> ?_printf(2), ?_sprintf(2), readDevide@bufferHorario(5), readDevide@bufferEnable(5), 
;;  i               2    0        int 
;;  done            2    0        int 
;;  c               1    0        unsigned char 
;; Return value:  Size  Location     Type
;;                  2   71[COMRAM] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 3E/1
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         6       0       0       0       0       0       0       0       0
;;      Locals:         0      12       0       0       0       0       0       0       0
;;      Temps:          2       0       0       0       0       0       0       0       0
;;      Totals:         8      12       0       0       0       0       0       0       0
;;Total ram usage:       20 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 8
;; This function calls:
;;		i1_dtoa
;;		i1_fputc
;;		i1_stoa
;;		i1_strncmp
;; This function is called by:
;;		i1_vfprintf
;; This function uses a non-reentrant model
;;
psect	text89,class=CODE,space=0,reloc=2,group=0
	line	692
global __ptext89
__ptext89:
psect	text89
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
	line	692
	
i1_vfpfcnvrt:; BSR set to: 1

;incstack = 0
	callstack 6
	line	702
	
i1l17631:
	movff	(c:i1vfpfcnvrt@fmt),fsr2l
	movff	(c:i1vfpfcnvrt@fmt+1),fsr2h
	movff	postinc2,tblptrl
	movff	postdec2,tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	xorlw	025h
	btfss	status,2
	goto	i1u2204_21
	goto	i1u2204_20
i1u2204_21:
	goto	i1l17683
i1u2204_20:
	line	703
	
i1l17633:
	movff	(c:i1vfpfcnvrt@fmt),fsr2l
	movff	(c:i1vfpfcnvrt@fmt+1),fsr2h
	incf	postinc2
	movlw	0
	addwfc	postdec2
	line	705
	
i1l17635:
	movlw	high(0)
	movlb	0	; () banked
	movwf	((_width+1))&0ffh
	movlw	low(0)
	movwf	((_width))&0ffh
	movff	(_width),(_flags)
	movff	(_width+1),(_flags+1)
	line	706
	
i1l17637:; BSR set to: 0

	setf	((_prec))&0ffh
	setf	((_prec+1))&0ffh
	line	847
	
i1l17639:; BSR set to: 0

	movff	(c:i1vfpfcnvrt@fmt),fsr2l
	movff	(c:i1vfpfcnvrt@fmt+1),fsr2h
	movff	postinc2,tblptrl
	movff	postdec2,tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	xorlw	064h
	btfsc	status,2
	goto	i1u2205_21
	goto	i1u2205_20
i1u2205_21:
	goto	i1l17643
i1u2205_20:
	
i1l17641:; BSR set to: 0

	movff	(c:i1vfpfcnvrt@fmt),fsr2l
	movff	(c:i1vfpfcnvrt@fmt+1),fsr2h
	movff	postinc2,tblptrl
	movff	postdec2,tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	xorlw	069h
	btfss	status,2
	goto	i1u2206_21
	goto	i1u2206_20
i1u2206_21:
	goto	i1l17649
i1u2206_20:
	line	849
	
i1l17643:; BSR set to: 0

	movff	(c:i1vfpfcnvrt@fmt),fsr2l
	movff	(c:i1vfpfcnvrt@fmt+1),fsr2h
	incf	postinc2
	movlw	0
	addwfc	postdec2
	line	850
	movff	(c:i1vfpfcnvrt@ap),fsr2l
	movff	(c:i1vfpfcnvrt@ap+1),fsr2h
	movff	indf2,??i1_vfpfcnvrt+0+0
	movlw	low(02h)
	addwf	postinc2
	movff	indf2,??i1_vfpfcnvrt+0+0+1
	movlw	high(02h)
	addwfc	postdec2
	movff	??i1_vfpfcnvrt+0+0,fsr2l
	movff	??i1_vfpfcnvrt+0+1,fsr2h
	movff	postinc2,(i1vfpfcnvrt@ll)
	movff	postdec2,(i1vfpfcnvrt@ll+1)
	movlw	0
	btfsc	((i1vfpfcnvrt@ll+1))&0ffh,7
	movlw	-1
	movwf	((i1vfpfcnvrt@ll+2))&0ffh
	movwf	((i1vfpfcnvrt@ll+3))&0ffh
	movwf	((i1vfpfcnvrt@ll+4))&0ffh
	movwf	((i1vfpfcnvrt@ll+5))&0ffh
	movwf	((i1vfpfcnvrt@ll+6))&0ffh
	movwf	((i1vfpfcnvrt@ll+7))&0ffh
	line	852
	
i1l17645:; BSR set to: 0

		movff	(c:i1vfpfcnvrt@fp),(c:i1dtoa@fp)
	movff	(c:i1vfpfcnvrt@fp+1),(c:i1dtoa@fp+1)

	movff	(i1vfpfcnvrt@ll),(c:i1dtoa@d)
	movff	(i1vfpfcnvrt@ll+1),(c:i1dtoa@d+1)
	movff	(i1vfpfcnvrt@ll+2),(c:i1dtoa@d+2)
	movff	(i1vfpfcnvrt@ll+3),(c:i1dtoa@d+3)
	movff	(i1vfpfcnvrt@ll+4),(c:i1dtoa@d+4)
	movff	(i1vfpfcnvrt@ll+5),(c:i1dtoa@d+5)
	movff	(i1vfpfcnvrt@ll+6),(c:i1dtoa@d+6)
	movff	(i1vfpfcnvrt@ll+7),(c:i1dtoa@d+7)
	call	i1_dtoa	;wreg free
	movff	0+?i1_dtoa,(c:?i1_vfpfcnvrt)
	movff	1+?i1_dtoa,(c:?i1_vfpfcnvrt+1)
	goto	i1l1772
	line	1171
	
i1l17649:; BSR set to: 0

	movff	(c:i1vfpfcnvrt@fmt),fsr2l
	movff	(c:i1vfpfcnvrt@fmt+1),fsr2h
	movff	postinc2,tblptrl
	movff	postdec2,tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	xorlw	073h
	btfsc	status,2
	goto	i1u2207_21
	goto	i1u2207_20
i1u2207_21:
	goto	i1l17653
i1u2207_20:
	
i1l17651:; BSR set to: 0

	movff	(c:i1vfpfcnvrt@fmt),fsr2l
	movff	(c:i1vfpfcnvrt@fmt+1),fsr2h
	movff	postinc2,(c:i1strncmp@_l)
	movff	postdec2,(c:i1strncmp@_l+1)
		movlw	low(STR_43)
	movwf	((c:i1strncmp@_r))^00h,c
	movlw	high(STR_43)
	movwf	((c:i1strncmp@_r+1))^00h,c

	movlw	high(03h)
	movwf	((c:i1strncmp@n+1))^00h,c
	movlw	low(03h)
	movwf	((c:i1strncmp@n))^00h,c
	call	i1_strncmp	;wreg free
	movf	(0+?i1_strncmp)^00h,c,w
iorwf	(1+?i1_strncmp)^00h,c,w
	btfss	status,2
	goto	i1u2208_21
	goto	i1u2208_20

i1u2208_21:
	goto	i1l17667
i1u2208_20:
	line	1173
	
i1l17653:
	movff	(c:i1vfpfcnvrt@fmt),fsr2l
	movff	(c:i1vfpfcnvrt@fmt+1),fsr2h
	movff	postinc2,tblptrl
	movff	postdec2,tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	xorlw	073h
	btfsc	status,2
	goto	i1u2209_21
	goto	i1u2209_20
i1u2209_21:
	goto	i1l17657
i1u2209_20:
	
i1l17655:
	movlw	high(03h)
	movlb	0	; () banked
	movwf	((i1_vfpfcnvrt$2810+1))&0ffh
	movlw	low(03h)
	movwf	((i1_vfpfcnvrt$2810))&0ffh
	goto	i1l17659
	
i1l17657:
	movlw	high(01h)
	movlb	0	; () banked
	movwf	((i1_vfpfcnvrt$2810+1))&0ffh
	movlw	low(01h)
	movwf	((i1_vfpfcnvrt$2810))&0ffh
	
i1l17659:; BSR set to: 0

	movff	(c:i1vfpfcnvrt@fmt),fsr2l
	movff	(c:i1vfpfcnvrt@fmt+1),fsr2h
	movf	((i1_vfpfcnvrt$2810))&0ffh,w
	addwf	postinc2
	movf	((i1_vfpfcnvrt$2810+1))&0ffh,w
	addwfc	postdec2
	line	1174
	
i1l17661:; BSR set to: 0

	movff	(c:i1vfpfcnvrt@ap),fsr2l
	movff	(c:i1vfpfcnvrt@ap+1),fsr2h
	movff	indf2,??i1_vfpfcnvrt+0+0
	movlw	low(02h)
	addwf	postinc2
	movff	indf2,??i1_vfpfcnvrt+0+0+1
	movlw	high(02h)
	addwfc	postdec2
	movff	??i1_vfpfcnvrt+0+0,fsr2l
	movff	??i1_vfpfcnvrt+0+1,fsr2h
	movff	postinc2,(i1vfpfcnvrt@cp)
	movff	postdec2,(i1vfpfcnvrt@cp+1)
	line	1176
	
i1l17663:; BSR set to: 0

		movff	(c:i1vfpfcnvrt@fp),(c:i1stoa@fp)
	movff	(c:i1vfpfcnvrt@fp+1),(c:i1stoa@fp+1)

		movff	(i1vfpfcnvrt@cp),(c:i1stoa@s)
	movff	(i1vfpfcnvrt@cp+1),(c:i1stoa@s+1)

	call	i1_stoa	;wreg free
	movff	0+?i1_stoa,(c:?i1_vfpfcnvrt)
	movff	1+?i1_stoa,(c:?i1_vfpfcnvrt+1)
	goto	i1l1772
	line	1372
	
i1l17667:
	movff	(c:i1vfpfcnvrt@fmt),fsr2l
	movff	(c:i1vfpfcnvrt@fmt+1),fsr2h
	movff	postinc2,tblptrl
	movff	postdec2,tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	xorlw	025h
	btfss	status,2
	goto	i1u2210_21
	goto	i1u2210_20
i1u2210_21:
	goto	i1l17677
i1u2210_20:
	line	1373
	
i1l17669:
	movff	(c:i1vfpfcnvrt@fmt),fsr2l
	movff	(c:i1vfpfcnvrt@fmt+1),fsr2h
	incf	postinc2
	movlw	0
	addwfc	postdec2
	line	1374
	
i1l17671:
	movlw	high(025h)
	movwf	((c:i1fputc@c+1))^00h,c
	movlw	low(025h)
	movwf	((c:i1fputc@c))^00h,c
		movff	(c:i1vfpfcnvrt@fp),(c:i1fputc@fp)
	movff	(c:i1vfpfcnvrt@fp+1),(c:i1fputc@fp+1)

	call	i1_fputc	;wreg free
	line	1375
	
i1l17673:
	movlw	high(01h)
	movwf	((c:?i1_vfpfcnvrt+1))^00h,c
	movlw	low(01h)
	movwf	((c:?i1_vfpfcnvrt))^00h,c
	goto	i1l1772
	line	1379
	
i1l17677:
	movff	(c:i1vfpfcnvrt@fmt),fsr2l
	movff	(c:i1vfpfcnvrt@fmt+1),fsr2h
	incf	postinc2
	movlw	0
	addwfc	postdec2
	line	1380
	
i1l17679:
	movlw	high(0)
	movwf	((c:?i1_vfpfcnvrt+1))^00h,c
	movlw	low(0)
	movwf	((c:?i1_vfpfcnvrt))^00h,c
	goto	i1l1772
	line	1384
	
i1l17683:
	movff	(c:i1vfpfcnvrt@fmt),fsr2l
	movff	(c:i1vfpfcnvrt@fmt+1),fsr2h
	movff	postinc2,tblptrl
	movff	postdec2,tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w

	movwf	((c:i1fputc@c))^00h,c
	clrf	((c:i1fputc@c+1))^00h,c
		movff	(c:i1vfpfcnvrt@fp),(c:i1fputc@fp)
	movff	(c:i1vfpfcnvrt@fp+1),(c:i1fputc@fp+1)

	call	i1_fputc	;wreg free
	line	1385
	
i1l17685:
	movff	(c:i1vfpfcnvrt@fmt),fsr2l
	movff	(c:i1vfpfcnvrt@fmt+1),fsr2h
	incf	postinc2
	movlw	0
	addwfc	postdec2
	goto	i1l17673
	line	1387
	
i1l1772:
	return	;funcret
	callstack 0
GLOBAL	__end_ofi1_vfpfcnvrt
	__end_ofi1_vfpfcnvrt:
	signat	i1_vfpfcnvrt,12378
	global	i1_strncmp

;; *************** function i1_strncmp *****************
;; Defined at:
;;		line 3 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\strncmp.c"
;; Parameters:    Size  Location     Type
;;  _l              2    6[COMRAM] PTR const unsigned char 
;;		 -> NULL(0), STR_16(4), STR_15(3), STR_14(3), 
;;		 -> STR_13(3), STR_12(4), STR_11(38), STR_10(36), 
;;		 -> STR_9(36), STR_8(36), STR_7(36), STR_6(43), 
;;		 -> STR_5(18), STR_4(11), STR_2(24), STR_1(27), 
;;		 -> anaT1(69), 
;;  _r              2    8[COMRAM] PTR const unsigned char 
;;		 -> STR_43(4), STR_39(2), STR_37(2), STR_35(2), 
;;		 -> STR_33(2), STR_32(2), STR_29(2), STR_28(2), 
;;		 -> STR_25(2), STR_23(2), STR_22(2), STR_20(2), 
;;		 -> STR_18(2), 
;;  n               2   10[COMRAM] unsigned int 
;; Auto vars:     Size  Location     Type
;;  r               2   15[COMRAM] PTR const unsigned char 
;;		 -> STR_43(4), STR_39(2), STR_37(2), STR_35(2), 
;;		 -> STR_33(2), STR_32(2), STR_29(2), STR_28(2), 
;;		 -> STR_25(2), STR_23(2), STR_22(2), STR_20(2), 
;;		 -> STR_18(2), 
;;  l               2   13[COMRAM] PTR const unsigned char 
;;		 -> NULL(0), STR_16(4), STR_15(3), STR_14(3), 
;;		 -> STR_13(3), STR_12(4), STR_11(38), STR_10(36), 
;;		 -> STR_9(36), STR_8(36), STR_7(36), STR_6(43), 
;;		 -> STR_5(18), STR_4(11), STR_2(24), STR_1(27), 
;;		 -> anaT1(69), 
;; Return value:  Size  Location     Type
;;                  2    6[COMRAM] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, status,2, status,0, tblptrl, tblptrh, tblptru
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         6       0       0       0       0       0       0       0       0
;;      Locals:         4       0       0       0       0       0       0       0       0
;;      Temps:          1       0       0       0       0       0       0       0       0
;;      Totals:        11       0       0       0       0       0       0       0       0
;;Total ram usage:       11 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 2
;; This function calls:
;;		Nothing
;; This function is called by:
;;		i1_vfpfcnvrt
;; This function uses a non-reentrant model
;;
psect	text90,class=CODE,space=0,reloc=2,group=0
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\strncmp.c"
	line	3
global __ptext90
__ptext90:
psect	text90
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\strncmp.c"
	line	3
	
i1_strncmp:
;incstack = 0
	callstack 11
	line	5
	
i1l17365:; BSR set to: 0

		movff	(c:i1strncmp@_l),(c:i1strncmp@l)
	movff	(c:i1strncmp@_l+1),(c:i1strncmp@l+1)

		movff	(c:i1strncmp@_r),(c:i1strncmp@r)
	movff	(c:i1strncmp@_r+1),(c:i1strncmp@r+1)

	line	6
	decf	((c:i1strncmp@n))^00h,c
	btfss	status,0
	decf	((c:i1strncmp@n+1))^00h,c
		incf	((c:i1strncmp@n))^00h,c,w
	bnz	i1u2156_21
	incf	((c:i1strncmp@n+1))^00h,c,w
	btfss	status,2
	goto	i1u2156_21
	goto	i1u2156_20

i1u2156_21:
	goto	i1l17373
i1u2156_20:
	
i1l17367:; BSR set to: 0

	movlw	high(0)
	movwf	((c:?i1_strncmp+1))^00h,c
	movlw	low(0)
	movwf	((c:?i1_strncmp))^00h,c
	goto	i1l1830
	line	7
	
i1l17371:
	infsnz	((c:i1strncmp@l))^00h,c
	incf	((c:i1strncmp@l+1))^00h,c
	infsnz	((c:i1strncmp@r))^00h,c
	incf	((c:i1strncmp@r+1))^00h,c
	decf	((c:i1strncmp@n))^00h,c
	btfss	status,0
	decf	((c:i1strncmp@n+1))^00h,c
	
i1l17373:
	movff	(c:i1strncmp@l),tblptrl
	movff	(c:i1strncmp@l+1),tblptrh
	clrf	tblptru
	
	movlw	high __ramtop-1
	cpfsgt	tblptrh
	bra	i1u2157_27
	tblrd	*
	
	movf	tablat,w
	bra	i1u2157_20
i1u2157_27:
	movff	tblptrl,fsr1l
	movff	tblptrh,fsr1h
	movf	indf1,w
i1u2157_20:
	iorlw	0
	btfsc	status,2
	goto	i1u2158_21
	goto	i1u2158_20
i1u2158_21:
	goto	i1l17381
i1u2158_20:
	
i1l17375:
	movff	(c:i1strncmp@r),tblptrl
	movff	(c:i1strncmp@r+1),tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	iorlw	0
	btfsc	status,2
	goto	i1u2159_21
	goto	i1u2159_20
i1u2159_21:
	goto	i1l17381
i1u2159_20:
	
i1l17377:
	movf	((c:i1strncmp@n))^00h,c,w
iorwf	((c:i1strncmp@n+1))^00h,c,w
	btfsc	status,2
	goto	i1u2160_21
	goto	i1u2160_20

i1u2160_21:
	goto	i1l17381
i1u2160_20:
	
i1l17379:
	movff	(c:i1strncmp@r),tblptrl
	movff	(c:i1strncmp@r+1),tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movff	tablat,??i1_strncmp+0+0
	movff	(c:i1strncmp@l),tblptrl
	movff	(c:i1strncmp@l+1),tblptrh
	clrf	tblptru
	
	movlw	high __ramtop-1
	cpfsgt	tblptrh
	bra	i1u2161_27
	tblrd	*
	
	movf	tablat,w
	bra	i1u2161_25
i1u2161_27:
	movff	tblptrl,fsr1l
	movff	tblptrh,fsr1h
	movf	indf1,w
i1u2161_25:
	xorwf	(??i1_strncmp+0+0)^00h,c,w
	btfsc	status,2
	goto	i1u2161_21
	goto	i1u2161_20
i1u2161_21:
	goto	i1l17371
i1u2161_20:
	line	8
	
i1l17381:
	movff	(c:i1strncmp@l),tblptrl
	movff	(c:i1strncmp@l+1),tblptrh
	clrf	tblptru
	
	movlw	high __ramtop-1
	cpfsgt	tblptrh
	bra	i1u2162_27
	tblrd	*
	
	movf	tablat,w
	bra	i1u2162_20
i1u2162_27:
	movff	tblptrl,fsr1l
	movff	tblptrh,fsr1h
	movf	indf1,w
i1u2162_20:
	movwf	(??i1_strncmp+0+0)^00h,c
	movff	(c:i1strncmp@r),tblptrl
	movff	(c:i1strncmp@r+1),tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w

	subwf	((??i1_strncmp+0+0))^00h,c,w
	movwf	((c:?i1_strncmp))^00h,c
	clrf	1+((c:?i1_strncmp))^00h,c
	btfss	status,0
	decf	1+((c:?i1_strncmp))^00h,c
	
	line	9
	
i1l1830:
	return	;funcret
	callstack 0
GLOBAL	__end_ofi1_strncmp
	__end_ofi1_strncmp:
	signat	i1_strncmp,12378
	global	i1_stoa

;; *************** function i1_stoa *****************
;; Defined at:
;;		line 568 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
;; Parameters:    Size  Location     Type
;;  fp              2   17[COMRAM] PTR struct _IO_FILE
;;		 -> sprintf@f(11), NULL(0), 
;;  s               2   19[COMRAM] PTR unsigned char 
;;		 -> ?_printf(2), ?_sprintf(2), readDevide@bufferHorario(5), readDevide@bufferEnable(5), 
;; Auto vars:     Size  Location     Type
;;  nuls            7   22[COMRAM] unsigned char [7]
;;  l               2   37[COMRAM] int 
;;  p               2   35[COMRAM] int 
;;  cp              2   33[COMRAM] PTR unsigned char 
;;		 -> i1stoa@nuls(7), ?_printf(2), stoa@nuls(7), ?_sprintf(2), 
;;		 -> readDevide@bufferHorario(5), readDevide@bufferEnable(5), 
;;  w               2   31[COMRAM] int 
;;  i               2   29[COMRAM] int 
;; Return value:  Size  Location     Type
;;                  2   17[COMRAM] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         4       0       0       0       0       0       0       0       0
;;      Locals:        17       0       0       0       0       0       0       0       0
;;      Temps:          1       0       0       0       0       0       0       0       0
;;      Totals:        22       0       0       0       0       0       0       0       0
;;Total ram usage:       22 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 5
;; This function calls:
;;		i1_fputc
;;		i1_strlen
;; This function is called by:
;;		i1_vfpfcnvrt
;; This function uses a non-reentrant model
;;
psect	text91,class=CODE,space=0,reloc=2,group=0
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
	line	568
global __ptext91
__ptext91:
psect	text91
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
	line	568
	
i1_stoa:
;incstack = 0
	callstack 8
	line	570
	
i1l17323:; BSR set to: 0

	lfsr	2,(stoa@F1150)
	lfsr	1,(i1stoa@nuls)
	movlw	7-1
i1u2147_21:
	movff	plusw2,plusw1
	decf	wreg
	bc	i1u2147_21

	line	574
	
i1l17325:; BSR set to: 0

		movff	(c:i1stoa@s),(c:i1stoa@cp)
	movff	(c:i1stoa@s+1),(c:i1stoa@cp+1)

	line	575
	
i1l17327:; BSR set to: 0

	movf	((c:i1stoa@cp))^00h,c,w
iorwf	((c:i1stoa@cp+1))^00h,c,w
	btfss	status,2
	goto	i1u2148_21
	goto	i1u2148_20

i1u2148_21:
	goto	i1l17331
i1u2148_20:
	line	576
	
i1l17329:; BSR set to: 0

		movlw	low(i1stoa@nuls)
	movwf	((c:i1stoa@cp))^00h,c
	clrf	((c:i1stoa@cp+1))^00h,c

	line	580
	
i1l17331:; BSR set to: 0

		movff	(c:i1stoa@cp),(c:i1strlen@s)
	movff	(c:i1stoa@cp+1),(c:i1strlen@s+1)

	call	i1_strlen	;wreg free
	movff	0+?i1_strlen,(c:i1stoa@l)
	movff	1+?i1_strlen,(c:i1stoa@l+1)
	line	581
	
i1l17333:
	movff	(_prec),(c:i1stoa@p)
	movff	(_prec+1),(c:i1stoa@p+1)
	line	582
	
i1l17335:
	btfsc	((c:i1stoa@p+1))^00h,c,7
	goto	i1u2149_21
	goto	i1u2149_20

i1u2149_21:
	goto	i1l1751
i1u2149_20:
	
i1l17337:
		movf	((c:i1stoa@l))^00h,c,w
	subwf	((c:i1stoa@p))^00h,c,w
	movf	((c:i1stoa@p+1))^00h,c,w
	xorlw	80h
	movwf	(??i1_stoa+0+0)^00h,c
	movf	((c:i1stoa@l+1))^00h,c,w
	xorlw	80h
	subwfb	(??i1_stoa+0+0)^00h,c,w
	btfss	status,0
	goto	i1u2150_21
	goto	i1u2150_20

i1u2150_21:
	goto	i1l1749
i1u2150_20:
	goto	i1l1751
	
i1l1749:
	movff	(c:i1stoa@p),(c:i1stoa@l)
	movff	(c:i1stoa@p+1),(c:i1stoa@l+1)
	
i1l1751:
	line	583
	movff	(c:i1stoa@l),(c:i1stoa@p)
	movff	(c:i1stoa@l+1),(c:i1stoa@p+1)
	line	584
	movff	(_width),(c:i1stoa@w)
	movff	(_width+1),(c:i1stoa@w+1)
	line	587
	movlb	0	; () banked
	
	btfsc	((_flags))&0ffh,(0)&7
	goto	i1u2151_21
	goto	i1u2151_20
i1u2151_21:
	goto	i1l17347
i1u2151_20:
	goto	i1l17345
	line	589
	
i1l17341:
	movlw	high(020h)
	movwf	((c:i1fputc@c+1))^00h,c
	movlw	low(020h)
	movwf	((c:i1fputc@c))^00h,c
		movff	(c:i1stoa@fp),(c:i1fputc@fp)
	movff	(c:i1stoa@fp+1),(c:i1fputc@fp+1)

	call	i1_fputc	;wreg free
	line	590
	
i1l17343:
	infsnz	((c:i1stoa@l))^00h,c
	incf	((c:i1stoa@l+1))^00h,c
	line	588
	
i1l17345:
		movf	((c:i1stoa@w))^00h,c,w
	subwf	((c:i1stoa@l))^00h,c,w
	movf	((c:i1stoa@l+1))^00h,c,w
	xorlw	80h
	movwf	(??i1_stoa+0+0)^00h,c
	movf	((c:i1stoa@w+1))^00h,c,w
	xorlw	80h
	subwfb	(??i1_stoa+0+0)^00h,c,w
	btfss	status,0
	goto	i1u2152_21
	goto	i1u2152_20

i1u2152_21:
	goto	i1l17341
i1u2152_20:
	line	595
	
i1l17347:
	movlw	high(0)
	movwf	((c:i1stoa@i+1))^00h,c
	movlw	low(0)
	movwf	((c:i1stoa@i))^00h,c
	line	596
	goto	i1l17355
	line	597
	
i1l17349:
	movff	(c:i1stoa@cp),fsr2l
	movff	(c:i1stoa@cp+1),fsr2h
	movf	indf2,w
	movwf	(??i1_stoa+0+0)^00h,c
	movf	((??i1_stoa+0+0))^00h,c,w
	movwf	((c:i1fputc@c))^00h,c
	clrf	((c:i1fputc@c+1))^00h,c
		movff	(c:i1stoa@fp),(c:i1fputc@fp)
	movff	(c:i1stoa@fp+1),(c:i1fputc@fp+1)

	call	i1_fputc	;wreg free
	line	598
	
i1l17351:
	infsnz	((c:i1stoa@cp))^00h,c
	incf	((c:i1stoa@cp+1))^00h,c
	line	599
	
i1l17353:
	infsnz	((c:i1stoa@i))^00h,c
	incf	((c:i1stoa@i+1))^00h,c
	line	596
	
i1l17355:
		movf	((c:i1stoa@p))^00h,c,w
	subwf	((c:i1stoa@i))^00h,c,w
	movf	((c:i1stoa@i+1))^00h,c,w
	xorlw	80h
	movwf	(??i1_stoa+0+0)^00h,c
	movf	((c:i1stoa@p+1))^00h,c,w
	xorlw	80h
	subwfb	(??i1_stoa+0+0)^00h,c,w
	btfss	status,0
	goto	i1u2153_21
	goto	i1u2153_20

i1u2153_21:
	goto	i1l17349
i1u2153_20:
	
i1l1760:
	line	603
	movlb	0	; () banked
	
	btfss	((_flags))&0ffh,(0)&7
	goto	i1u2154_21
	goto	i1u2154_20
i1u2154_21:
	goto	i1l1761
i1u2154_20:
	goto	i1l17363
	line	605
	
i1l17359:
	movlw	high(020h)
	movwf	((c:i1fputc@c+1))^00h,c
	movlw	low(020h)
	movwf	((c:i1fputc@c))^00h,c
		movff	(c:i1stoa@fp),(c:i1fputc@fp)
	movff	(c:i1stoa@fp+1),(c:i1fputc@fp+1)

	call	i1_fputc	;wreg free
	line	606
	
i1l17361:
	infsnz	((c:i1stoa@l))^00h,c
	incf	((c:i1stoa@l+1))^00h,c
	line	604
	
i1l17363:
		movf	((c:i1stoa@w))^00h,c,w
	subwf	((c:i1stoa@l))^00h,c,w
	movf	((c:i1stoa@l+1))^00h,c,w
	xorlw	80h
	movwf	(??i1_stoa+0+0)^00h,c
	movf	((c:i1stoa@w+1))^00h,c,w
	xorlw	80h
	subwfb	(??i1_stoa+0+0)^00h,c,w
	btfss	status,0
	goto	i1u2155_21
	goto	i1u2155_20

i1u2155_21:
	goto	i1l17359
i1u2155_20:
	line	608
	
i1l1761:
	line	610
	movff	(c:i1stoa@l),(c:?i1_stoa)
	movff	(c:i1stoa@l+1),(c:?i1_stoa+1)
	line	611
	
i1l1765:
	return	;funcret
	callstack 0
GLOBAL	__end_ofi1_stoa
	__end_ofi1_stoa:
	signat	i1_stoa,8282
	global	i1_dtoa

;; *************** function i1_dtoa *****************
;; Defined at:
;;		line 287 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
;; Parameters:    Size  Location     Type
;;  fp              2   35[COMRAM] PTR struct _IO_FILE
;;		 -> sprintf@f(11), NULL(0), 
;;  d               8   37[COMRAM] long long 
;; Auto vars:     Size  Location     Type
;;  n               8   61[COMRAM] long long 
;;  i               2   69[COMRAM] int 
;;  s               2   59[COMRAM] int 
;;  w               2   57[COMRAM] int 
;;  p               2   55[COMRAM] int 
;; Return value:  Size  Location     Type
;;                  2   35[COMRAM] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:        10       0       0       0       0       0       0       0       0
;;      Locals:        18       0       0       0       0       0       0       0       0
;;      Temps:          8       0       0       0       0       0       0       0       0
;;      Totals:        36       0       0       0       0       0       0       0       0
;;Total ram usage:       36 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 7
;; This function calls:
;;		i1___aodiv
;;		i1___aomod
;;		i1_abs
;;		i1_pad
;; This function is called by:
;;		i1_vfpfcnvrt
;; This function uses a non-reentrant model
;;
psect	text92,class=CODE,space=0,reloc=2,group=0
	line	287
global __ptext92
__ptext92:
psect	text92
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
	line	287
	
i1_dtoa:
;incstack = 0
	callstack 6
	line	293
	
i1l17261:; BSR set to: 0

	movff	(c:i1dtoa@d),(c:i1dtoa@n)
	movff	(c:i1dtoa@d+1),(c:i1dtoa@n+1)
	movff	(c:i1dtoa@d+2),(c:i1dtoa@n+2)
	movff	(c:i1dtoa@d+3),(c:i1dtoa@n+3)
	movff	(c:i1dtoa@d+4),(c:i1dtoa@n+4)
	movff	(c:i1dtoa@d+5),(c:i1dtoa@n+5)
	movff	(c:i1dtoa@d+6),(c:i1dtoa@n+6)
	movff	(c:i1dtoa@d+7),(c:i1dtoa@n+7)
	line	294
	
i1l17263:; BSR set to: 0

	btfsc	((c:i1dtoa@n+7))^00h,c,7
	goto	i1u2132_21
	goto	i1u2132_20

i1u2132_21:
	movlw	1
	goto	i1u2133_20
i1u2132_20:
	movlw	0
i1u2133_20:
	movwf	((c:i1dtoa@s))^00h,c
	clrf	((c:i1dtoa@s+1))^00h,c
	line	295
	movf	((c:i1dtoa@s))^00h,c,w
iorwf	((c:i1dtoa@s+1))^00h,c,w
	btfsc	status,2
	goto	i1u2134_21
	goto	i1u2134_20

i1u2134_21:
	goto	i1l17267
i1u2134_20:
	line	296
	
i1l17265:; BSR set to: 0

	comf	((c:i1dtoa@n+7))^00h,c
	comf	((c:i1dtoa@n+6))^00h,c
	comf	((c:i1dtoa@n+5))^00h,c
	comf	((c:i1dtoa@n+4))^00h,c
	comf	((c:i1dtoa@n+3))^00h,c
	comf	((c:i1dtoa@n+2))^00h,c
	comf	((c:i1dtoa@n+1))^00h,c
	negf	((c:i1dtoa@n))^00h,c
	movlw	0
	addwfc	((c:i1dtoa@n+1))^00h,c
	addwfc	((c:i1dtoa@n+2))^00h,c
	addwfc	((c:i1dtoa@n+3))^00h,c
	addwfc	((c:i1dtoa@n+4))^00h,c
	addwfc	((c:i1dtoa@n+5))^00h,c
	addwfc	((c:i1dtoa@n+6))^00h,c
	addwfc	((c:i1dtoa@n+7))^00h,c
	line	300
	
i1l17267:; BSR set to: 0

	btfsc	((_prec+1))&0ffh,7
	goto	i1u2135_21
	goto	i1u2135_20

i1u2135_21:
	goto	i1l17271
i1u2135_20:
	line	301
	
i1l17269:; BSR set to: 0

	bcf	(0+(1/8)+(_flags))&0ffh,(1)&7
	line	303
	
i1l17271:; BSR set to: 0

	btfsc	((_prec+1))&0ffh,7
	goto	i1u2136_20
	movf	((_prec+1))&0ffh,w
	bnz	i1u2136_21
	decf	((_prec))&0ffh,w
	btfsc	status,0
	goto	i1u2136_21
	goto	i1u2136_20

i1u2136_21:
	goto	i1l1722
i1u2136_20:
	
i1l17273:; BSR set to: 0

	movlw	high(01h)
	movwf	((c:i1dtoa@p+1))^00h,c
	movlw	low(01h)
	movwf	((c:i1dtoa@p))^00h,c
	goto	i1l1724
	
i1l1722:; BSR set to: 0

	movff	(_prec),(c:i1dtoa@p)
	movff	(_prec+1),(c:i1dtoa@p+1)
	
i1l1724:; BSR set to: 0

	line	304
	movff	(_width),(c:i1dtoa@w)
	movff	(_width+1),(c:i1dtoa@w+1)
	line	305
	
i1l17275:; BSR set to: 0

	movf	((c:i1dtoa@s))^00h,c,w
iorwf	((c:i1dtoa@s+1))^00h,c,w
	btfss	status,2
	goto	i1u2137_21
	goto	i1u2137_20

i1u2137_21:
	goto	i1l17279
i1u2137_20:
	
i1l17277:; BSR set to: 0

	
	btfss	((_flags))&0ffh,(2)&7
	goto	i1u2138_21
	goto	i1u2138_20
i1u2138_21:
	goto	i1l17281
i1u2138_20:
	line	306
	
i1l17279:; BSR set to: 0

	decf	((c:i1dtoa@w))^00h,c
	btfss	status,0
	decf	((c:i1dtoa@w+1))^00h,c
	line	310
	
i1l17281:; BSR set to: 0

	movlw	high(01Fh)
	movwf	((c:i1dtoa@i+1))^00h,c
	movlw	low(01Fh)
	movwf	((c:i1dtoa@i))^00h,c
	line	311
	
i1l17283:; BSR set to: 0

	movlw	low(0)
	movlb	2	; () banked
	movwf	(0+(_dbuf+01Fh))&0ffh
	line	312
	goto	i1l17295
	line	313
	
i1l17285:
	decf	((c:i1dtoa@i))^00h,c
	btfss	status,0
	decf	((c:i1dtoa@i+1))^00h,c
	line	314
	
i1l17287:
	movlw	low(_dbuf)
	addwf	((c:i1dtoa@i))^00h,c,w
	movwf	c:fsr2l
	movlw	high(_dbuf)
	addwfc	((c:i1dtoa@i+1))^00h,c,w
	movwf	1+c:fsr2l
	movff	(c:i1dtoa@n),(c:i1___aomod@dividend)
	movff	(c:i1dtoa@n+1),(c:i1___aomod@dividend+1)
	movff	(c:i1dtoa@n+2),(c:i1___aomod@dividend+2)
	movff	(c:i1dtoa@n+3),(c:i1___aomod@dividend+3)
	movff	(c:i1dtoa@n+4),(c:i1___aomod@dividend+4)
	movff	(c:i1dtoa@n+5),(c:i1___aomod@dividend+5)
	movff	(c:i1dtoa@n+6),(c:i1___aomod@dividend+6)
	movff	(c:i1dtoa@n+7),(c:i1___aomod@dividend+7)
	movlw	byte0(0Ah)
	movwf	((c:i1___aomod@divisor))^00h,c
	movlw	byte1(0Ah)
	movwf	((c:i1___aomod@divisor+1))^00h,c
	movlw	byte2(0Ah)
	movwf	((c:i1___aomod@divisor+2))^00h,c
	movlw	byte3(0Ah)
	movwf	((c:i1___aomod@divisor+3))^00h,c
	movlw	byte4(0Ah)
	movwf	((c:i1___aomod@divisor+4))^00h,c
	movlw	byte5(0Ah)
	movwf	((c:i1___aomod@divisor+5))^00h,c
	movlw	byte6(0Ah)
	movwf	((c:i1___aomod@divisor+6))^00h,c
	movlw	byte7(0Ah)
	movwf	((c:i1___aomod@divisor+7))^00h,c
	call	i1___aomod	;wreg free
	movff	0+?i1___aomod,??i1_dtoa+0+0
	movff	1+?i1___aomod,??i1_dtoa+0+0+1
	movff	2+?i1___aomod,??i1_dtoa+0+0+2
	movff	3+?i1___aomod,??i1_dtoa+0+0+3
	movff	4+?i1___aomod,??i1_dtoa+0+0+4
	movff	5+?i1___aomod,??i1_dtoa+0+0+5
	movff	6+?i1___aomod,??i1_dtoa+0+0+6
	movff	7+?i1___aomod,??i1_dtoa+0+0+7
	
	movff	??i1_dtoa+0+0,(c:i1abs@a)
	movff	??i1_dtoa+0+2,(c:i1abs@a+1)
	call	i1_abs	;wreg free
	movf	(0+?i1_abs)^00h,c,w
	addlw	low(030h)
	movwf	indf2,c

	line	315
	
i1l17289:
	decf	((c:i1dtoa@p))^00h,c
	btfss	status,0
	decf	((c:i1dtoa@p+1))^00h,c
	line	316
	
i1l17291:
	decf	((c:i1dtoa@w))^00h,c
	btfss	status,0
	decf	((c:i1dtoa@w+1))^00h,c
	line	317
	
i1l17293:
	movff	(c:i1dtoa@n),(c:i1___aodiv@dividend)
	movff	(c:i1dtoa@n+1),(c:i1___aodiv@dividend+1)
	movff	(c:i1dtoa@n+2),(c:i1___aodiv@dividend+2)
	movff	(c:i1dtoa@n+3),(c:i1___aodiv@dividend+3)
	movff	(c:i1dtoa@n+4),(c:i1___aodiv@dividend+4)
	movff	(c:i1dtoa@n+5),(c:i1___aodiv@dividend+5)
	movff	(c:i1dtoa@n+6),(c:i1___aodiv@dividend+6)
	movff	(c:i1dtoa@n+7),(c:i1___aodiv@dividend+7)
	movlw	byte0(0Ah)
	movwf	((c:i1___aodiv@divisor))^00h,c
	movlw	byte1(0Ah)
	movwf	((c:i1___aodiv@divisor+1))^00h,c
	movlw	byte2(0Ah)
	movwf	((c:i1___aodiv@divisor+2))^00h,c
	movlw	byte3(0Ah)
	movwf	((c:i1___aodiv@divisor+3))^00h,c
	movlw	byte4(0Ah)
	movwf	((c:i1___aodiv@divisor+4))^00h,c
	movlw	byte5(0Ah)
	movwf	((c:i1___aodiv@divisor+5))^00h,c
	movlw	byte6(0Ah)
	movwf	((c:i1___aodiv@divisor+6))^00h,c
	movlw	byte7(0Ah)
	movwf	((c:i1___aodiv@divisor+7))^00h,c
	call	i1___aodiv	;wreg free
	movff	0+?i1___aodiv,(c:i1dtoa@n)
	movff	1+?i1___aodiv,(c:i1dtoa@n+1)
	movff	2+?i1___aodiv,(c:i1dtoa@n+2)
	movff	3+?i1___aodiv,(c:i1dtoa@n+3)
	movff	4+?i1___aodiv,(c:i1dtoa@n+4)
	movff	5+?i1___aodiv,(c:i1dtoa@n+5)
	movff	6+?i1___aodiv,(c:i1dtoa@n+6)
	movff	7+?i1___aodiv,(c:i1dtoa@n+7)
	
	line	312
	
i1l17295:
	btfsc	((c:i1dtoa@i+1))^00h,c,7
	goto	i1u2139_21
	movf	((c:i1dtoa@i+1))^00h,c,w
	bnz	i1u2139_20
	decf	((c:i1dtoa@i))^00h,c,w
	btfss	status,0
	goto	i1u2139_21
	goto	i1u2139_20

i1u2139_21:
	goto	i1l17305
i1u2139_20:
	
i1l17297:
	movf	((c:i1dtoa@n))^00h,c,w
iorwf	((c:i1dtoa@n+1))^00h,c,w
iorwf	((c:i1dtoa@n+2))^00h,c,w
iorwf	((c:i1dtoa@n+3))^00h,c,w
iorwf	((c:i1dtoa@n+4))^00h,c,w
iorwf	((c:i1dtoa@n+5))^00h,c,w
iorwf	((c:i1dtoa@n+6))^00h,c,w
iorwf	((c:i1dtoa@n+7))^00h,c,w
	btfss	status,2
	goto	i1u2140_21
	goto	i1u2140_20

i1u2140_21:
	goto	i1l17285
i1u2140_20:
	
i1l17299:
	btfsc	((c:i1dtoa@p+1))^00h,c,7
	goto	i1u2141_20
	movf	((c:i1dtoa@p+1))^00h,c,w
	bnz	i1u2141_21
	decf	((c:i1dtoa@p))^00h,c,w
	btfsc	status,0
	goto	i1u2141_21
	goto	i1u2141_20

i1u2141_21:
	goto	i1l17285
i1u2141_20:
	
i1l17301:
	btfsc	((c:i1dtoa@w+1))^00h,c,7
	goto	i1u2142_21
	movf	((c:i1dtoa@w+1))^00h,c,w
	bnz	i1u2142_20
	decf	((c:i1dtoa@w))^00h,c,w
	btfss	status,0
	goto	i1u2142_21
	goto	i1u2142_20

i1u2142_21:
	goto	i1l17305
i1u2142_20:
	
i1l17303:
	movlb	0	; () banked
	
	btfsc	((_flags))&0ffh,(1)&7
	goto	i1u2143_21
	goto	i1u2143_20
i1u2143_21:
	goto	i1l17285
i1u2143_20:
	line	321
	
i1l17305:
	movf	((c:i1dtoa@s))^00h,c,w
iorwf	((c:i1dtoa@s+1))^00h,c,w
	btfss	status,2
	goto	i1u2144_21
	goto	i1u2144_20

i1u2144_21:
	goto	i1l17309
i1u2144_20:
	
i1l17307:
	movlb	0	; () banked
	
	btfss	((_flags))&0ffh,(2)&7
	goto	i1u2145_21
	goto	i1u2145_20
i1u2145_21:
	goto	i1l17319
i1u2145_20:
	line	322
	
i1l17309:
	decf	((c:i1dtoa@i))^00h,c
	btfss	status,0
	decf	((c:i1dtoa@i+1))^00h,c
	line	323
	
i1l17311:
	movf	((c:i1dtoa@s))^00h,c,w
iorwf	((c:i1dtoa@s+1))^00h,c,w
	btfss	status,2
	goto	i1u2146_21
	goto	i1u2146_20

i1u2146_21:
	goto	i1l17315
i1u2146_20:
	
i1l17313:
	movlw	high(02Bh)
	movwf	((c:i1_dtoa$2781+1))^00h,c
	movlw	low(02Bh)
	movwf	((c:i1_dtoa$2781))^00h,c
	goto	i1l17317
	
i1l17315:
	movlw	high(02Dh)
	movwf	((c:i1_dtoa$2781+1))^00h,c
	movlw	low(02Dh)
	movwf	((c:i1_dtoa$2781))^00h,c
	
i1l17317:
	movlw	low(_dbuf)
	addwf	((c:i1dtoa@i))^00h,c,w
	movwf	c:fsr2l
	movlw	high(_dbuf)
	addwfc	((c:i1dtoa@i+1))^00h,c,w
	movwf	1+c:fsr2l
	movff	(c:i1_dtoa$2781),indf2

	line	327
	
i1l17319:
		movff	(c:i1dtoa@fp),(c:i1pad@fp)
	movff	(c:i1dtoa@fp+1),(c:i1pad@fp+1)

	movlw	low(_dbuf)
	addwf	((c:i1dtoa@i))^00h,c,w
	movwf	((c:i1pad@buf))^00h,c
	movlw	high(_dbuf)
	addwfc	((c:i1dtoa@i+1))^00h,c,w
	movwf	1+((c:i1pad@buf))^00h,c
	movff	(c:i1dtoa@w),(c:i1pad@p)
	movff	(c:i1dtoa@w+1),(c:i1pad@p+1)
	call	i1_pad	;wreg free
	movff	0+?i1_pad,(c:?i1_dtoa)
	movff	1+?i1_pad,(c:?i1_dtoa+1)
	line	328
	
i1l1742:
	return	;funcret
	callstack 0
GLOBAL	__end_ofi1_dtoa
	__end_ofi1_dtoa:
	signat	i1_dtoa,8282
	global	i1_pad

;; *************** function i1_pad *****************
;; Defined at:
;;		line 72 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
;; Parameters:    Size  Location     Type
;;  fp              2   24[COMRAM] PTR struct _IO_FILE
;;		 -> sprintf@f(11), NULL(0), 
;;  buf             2   26[COMRAM] PTR unsigned char 
;;		 -> dbuf(32), 
;;  p               2   28[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;  w               2   33[COMRAM] int 
;;  i               2   31[COMRAM] int 
;; Return value:  Size  Location     Type
;;                  2   24[COMRAM] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         6       0       0       0       0       0       0       0       0
;;      Locals:         4       0       0       0       0       0       0       0       0
;;      Temps:          1       0       0       0       0       0       0       0       0
;;      Totals:        11       0       0       0       0       0       0       0       0
;;Total ram usage:       11 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 6
;; This function calls:
;;		i1_fputc
;;		i1_fputs
;;		i1_strlen
;; This function is called by:
;;		i1_dtoa
;; This function uses a non-reentrant model
;;
psect	text93,class=CODE,space=0,reloc=2,group=0
	line	72
global __ptext93
__ptext93:
psect	text93
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\doprnt.c"
	line	72
	
i1_pad:
;incstack = 0
	callstack 6
	line	77
	
i1l17177:
	movlb	0	; () banked
	
	btfss	((_flags))&0ffh,(0)&7
	goto	i1u2118_21
	goto	i1u2118_20
i1u2118_21:
	goto	i1l17181
i1u2118_20:
	line	78
	
i1l17179:; BSR set to: 0

		movff	(c:i1pad@buf),(c:i1fputs@s)
	movff	(c:i1pad@buf+1),(c:i1fputs@s+1)

		movff	(c:i1pad@fp),(c:i1fputs@fp)
	movff	(c:i1pad@fp+1),(c:i1fputs@fp+1)

	call	i1_fputs	;wreg free
	line	82
	
i1l17181:
	btfsc	((c:i1pad@p+1))^00h,c,7
	goto	i1u2119_21
	goto	i1u2119_20

i1u2119_21:
	goto	i1l17185
i1u2119_20:
	
i1l17183:
	movff	(c:i1pad@p),(c:i1pad@w)
	movff	(c:i1pad@p+1),(c:i1pad@w+1)
	goto	i1l1711
	
i1l17185:
	movlw	high(0)
	movwf	((c:i1pad@w+1))^00h,c
	movlw	low(0)
	movwf	((c:i1pad@w))^00h,c
	
i1l1711:
	line	83
	movlw	high(0)
	movwf	((c:i1pad@i+1))^00h,c
	movlw	low(0)
	movwf	((c:i1pad@i))^00h,c
	line	84
	goto	i1l17191
	line	85
	
i1l17187:
	movlw	high(020h)
	movwf	((c:i1fputc@c+1))^00h,c
	movlw	low(020h)
	movwf	((c:i1fputc@c))^00h,c
		movff	(c:i1pad@fp),(c:i1fputc@fp)
	movff	(c:i1pad@fp+1),(c:i1fputc@fp+1)

	call	i1_fputc	;wreg free
	line	86
	
i1l17189:
	infsnz	((c:i1pad@i))^00h,c
	incf	((c:i1pad@i+1))^00h,c
	line	84
	
i1l17191:
		movf	((c:i1pad@w))^00h,c,w
	subwf	((c:i1pad@i))^00h,c,w
	movf	((c:i1pad@i+1))^00h,c,w
	xorlw	80h
	movwf	(??i1_pad+0+0)^00h,c
	movf	((c:i1pad@w+1))^00h,c,w
	xorlw	80h
	subwfb	(??i1_pad+0+0)^00h,c,w
	btfss	status,0
	goto	i1u2120_21
	goto	i1u2120_20

i1u2120_21:
	goto	i1l17187
i1u2120_20:
	
i1l1714:
	line	90
	movlb	0	; () banked
	
	btfsc	((_flags))&0ffh,(0)&7
	goto	i1u2121_21
	goto	i1u2121_20
i1u2121_21:
	goto	i1l17195
i1u2121_20:
	line	91
	
i1l17193:; BSR set to: 0

		movff	(c:i1pad@buf),(c:i1fputs@s)
	movff	(c:i1pad@buf+1),(c:i1fputs@s+1)

		movff	(c:i1pad@fp),(c:i1fputs@fp)
	movff	(c:i1pad@fp+1),(c:i1fputs@fp+1)

	call	i1_fputs	;wreg free
	line	94
	
i1l17195:
		movff	(c:i1pad@buf),(c:i1strlen@s)
	movff	(c:i1pad@buf+1),(c:i1strlen@s+1)

	call	i1_strlen	;wreg free
	movf	((c:i1pad@w))^00h,c,w
	addwf	(0+?i1_strlen)^00h,c,w
	movwf	((c:?i1_pad))^00h,c
	movf	((c:i1pad@w+1))^00h,c,w
	addwfc	(1+?i1_strlen)^00h,c,w
	movwf	1+((c:?i1_pad))^00h,c
	line	95
	
i1l1716:
	return	;funcret
	callstack 0
GLOBAL	__end_ofi1_pad
	__end_ofi1_pad:
	signat	i1_pad,12378
	global	i1_strlen

;; *************** function i1_strlen *****************
;; Defined at:
;;		line 5 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\strlen.c"
;; Parameters:    Size  Location     Type
;;  s               2    6[COMRAM] PTR const unsigned char 
;;		 -> i1stoa@nuls(7), ?_printf(2), stoa@nuls(7), dbuf(32), 
;;		 -> ?_sprintf(2), extraerFrame@buffer(10), STR_39(2), STR_37(2), 
;;		 -> STR_35(2), STR_33(2), STR_32(2), STR_29(2), 
;;		 -> STR_28(2), STR_25(2), STR_23(2), STR_22(2), 
;;		 -> STR_20(2), STR_18(2), transmitUart1@bufferTx1(45), readDevide@bufferHorario(5), 
;;		 -> readDevide@bufferEnable(5), STR_3(25), ap(76), anaT1(69), 
;; Auto vars:     Size  Location     Type
;;  a               2    8[COMRAM] PTR const unsigned char 
;;		 -> i1stoa@nuls(7), ?_printf(2), stoa@nuls(7), dbuf(32), 
;;		 -> ?_sprintf(2), extraerFrame@buffer(10), STR_39(2), STR_37(2), 
;;		 -> STR_35(2), STR_33(2), STR_32(2), STR_29(2), 
;;		 -> STR_28(2), STR_25(2), STR_23(2), STR_22(2), 
;;		 -> STR_20(2), STR_18(2), transmitUart1@bufferTx1(45), readDevide@bufferHorario(5), 
;;		 -> readDevide@bufferEnable(5), STR_3(25), ap(76), anaT1(69), 
;; Return value:  Size  Location     Type
;;                  2    6[COMRAM] unsigned int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, status,2, status,0, tblptrl, tblptrh, tblptru
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:         2       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         4       0       0       0       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 2
;; This function calls:
;;		Nothing
;; This function is called by:
;;		i1_pad
;;		i1_stoa
;; This function uses a non-reentrant model
;;
psect	text94,class=CODE,space=0,reloc=2,group=0
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\strlen.c"
	line	5
global __ptext94
__ptext94:
psect	text94
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\strlen.c"
	line	5
	
i1_strlen:
;incstack = 0
	callstack 10
	line	7
	
i1l17075:
		movff	(c:i1strlen@s),(c:i1strlen@a)
	movff	(c:i1strlen@s+1),(c:i1strlen@a+1)

	line	8
	goto	i1l17079
	line	9
	
i1l17077:
	infsnz	((c:i1strlen@s))^00h,c
	incf	((c:i1strlen@s+1))^00h,c
	line	8
	
i1l17079:
	movff	(c:i1strlen@s),tblptrl
	movff	(c:i1strlen@s+1),tblptrh
	clrf	tblptru
	
	movlw	high __ramtop-1
	cpfsgt	tblptrh
	bra	i1u2103_27
	tblrd	*
	
	movf	tablat,w
	bra	i1u2103_20
i1u2103_27:
	movff	tblptrl,fsr1l
	movff	tblptrh,fsr1h
	movf	indf1,w
i1u2103_20:
	iorlw	0
	btfss	status,2
	goto	i1u2104_21
	goto	i1u2104_20
i1u2104_21:
	goto	i1l17077
i1u2104_20:
	line	11
	
i1l17081:
	movf	((c:i1strlen@a))^00h,c,w
	subwf	((c:i1strlen@s))^00h,c,w
	movwf	((c:?i1_strlen))^00h,c
	movf	((c:i1strlen@a+1))^00h,c,w
	subwfb	((c:i1strlen@s+1))^00h,c,w
	movwf	1+((c:?i1_strlen))^00h,c
	line	12
	
i1l1826:
	return	;funcret
	callstack 0
GLOBAL	__end_ofi1_strlen
	__end_ofi1_strlen:
	signat	i1_strlen,4186
	global	i1_fputs

;; *************** function i1_fputs *****************
;; Defined at:
;;		line 8 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\nf_fputs.c"
;; Parameters:    Size  Location     Type
;;  s               2   17[COMRAM] PTR const unsigned char 
;;		 -> dbuf(32), 
;;  fp              2   19[COMRAM] PTR struct _IO_FILE
;;		 -> sprintf@f(11), NULL(0), 
;; Auto vars:     Size  Location     Type
;;  i               2   22[COMRAM] int 
;;  c               1   21[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  2   17[COMRAM] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         4       0       0       0       0       0       0       0       0
;;      Locals:         3       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         7       0       0       0       0       0       0       0       0
;;Total ram usage:        7 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 5
;; This function calls:
;;		i1_fputc
;; This function is called by:
;;		i1_pad
;; This function uses a non-reentrant model
;;
psect	text95,class=CODE,space=0,reloc=2,group=0
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\nf_fputs.c"
	line	8
global __ptext95
__ptext95:
psect	text95
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\nf_fputs.c"
	line	8
	
i1_fputs:
;incstack = 0
	callstack 6
	line	13
	
i1l17067:; BSR set to: 0

	movlw	high(0)
	movwf	((c:i1fputs@i+1))^00h,c
	movlw	low(0)
	movwf	((c:i1fputs@i))^00h,c
	line	14
	goto	i1l17073
	line	15
	
i1l17069:
	movff	(c:i1fputs@c),(c:i1fputc@c)
	clrf	((c:i1fputc@c+1))^00h,c
		movff	(c:i1fputs@fp),(c:i1fputc@fp)
	movff	(c:i1fputs@fp+1),(c:i1fputc@fp+1)

	call	i1_fputc	;wreg free
	line	16
	
i1l17071:
	infsnz	((c:i1fputs@i))^00h,c
	incf	((c:i1fputs@i+1))^00h,c
	line	14
	
i1l17073:
	movf	((c:i1fputs@i))^00h,c,w
	addwf	((c:i1fputs@s))^00h,c,w
	movwf	c:fsr2l
	movf	((c:i1fputs@i+1))^00h,c,w
	addwfc	((c:i1fputs@s+1))^00h,c,w
	movwf	1+c:fsr2l
	movf	indf2,w
	movwf	((c:i1fputs@c))^00h,c
	movf	((c:i1fputs@c))^00h,c,w
	btfss	status,2
	goto	i1u2102_21
	goto	i1u2102_20
i1u2102_21:
	goto	i1l17069
i1u2102_20:
	line	19
	
i1l1813:
	return	;funcret
	callstack 0
GLOBAL	__end_ofi1_fputs
	__end_ofi1_fputs:
	signat	i1_fputs,8282
	global	i1_fputc

;; *************** function i1_fputc *****************
;; Defined at:
;;		line 8 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\nf_fputc.c"
;; Parameters:    Size  Location     Type
;;  c               2    8[COMRAM] int 
;;  fp              2   10[COMRAM] PTR struct _IO_FILE
;;		 -> sprintf@f(11), NULL(0), 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  2    8[COMRAM] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         4       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          5       0       0       0       0       0       0       0       0
;;      Totals:         9       0       0       0       0       0       0       0       0
;;Total ram usage:        9 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 4
;; This function calls:
;;		i1_putch
;; This function is called by:
;;		i1_pad
;;		i1_stoa
;;		i1_vfpfcnvrt
;;		i1_fputs
;; This function uses a non-reentrant model
;;
psect	text96,class=CODE,space=0,reloc=2,group=0
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\nf_fputc.c"
	line	8
global __ptext96
__ptext96:
psect	text96
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\nf_fputc.c"
	line	8
	
i1_fputc:
;incstack = 0
	callstack 8
	line	12
	
i1l17045:
	movf	((c:i1fputc@fp))^00h,c,w
iorwf	((c:i1fputc@fp+1))^00h,c,w
	btfsc	status,2
	goto	i1u2097_21
	goto	i1u2097_20

i1u2097_21:
	goto	i1l17049
i1u2097_20:
	
i1l17047:
	movf	((c:i1fputc@fp))^00h,c,w
iorwf	((c:i1fputc@fp+1))^00h,c,w
	btfss	status,2
	goto	i1u2098_21
	goto	i1u2098_20

i1u2098_21:
	goto	i1l17051
i1u2098_20:
	line	13
	
i1l17049:
	movf	((c:i1fputc@c))^00h,c,w
	
	call	i1_putch
	line	14
	goto	i1l1805
	line	15
	
i1l17051:
	lfsr	2,09h
	movf	((c:i1fputc@fp))^00h,c,w
	addwf	fsr2l
	movf	((c:i1fputc@fp+1))^00h,c,w
	addwfc	fsr2h
	movf	postinc2,w
iorwf	postinc2,w
	btfsc	status,2
	goto	i1u2099_21
	goto	i1u2099_20

i1u2099_21:
	goto	i1l17055
i1u2099_20:
	
i1l17053:
	lfsr	2,09h
	movf	((c:i1fputc@fp))^00h,c,w
	addwf	fsr2l
	movf	((c:i1fputc@fp+1))^00h,c,w
	addwfc	fsr2h
	lfsr	1,03h
	movf	((c:i1fputc@fp))^00h,c,w
	addwf	fsr1l
	movf	((c:i1fputc@fp+1))^00h,c,w
	addwfc	fsr1h
		movf	postinc2,w
	subwf	postinc1,w
	movf	postinc1,w
	xorlw	80h
	movwf	(??i1_fputc+4+0)^00h,c
	movf	postinc2,w
	xorlw	80h
	subwfb	(??i1_fputc+4+0)^00h,c,w
	btfsc	status,0
	goto	i1u2100_21
	goto	i1u2100_20

i1u2100_21:
	goto	i1l1805
i1u2100_20:
	line	18
	
i1l17055:
	lfsr	2,03h
	movf	((c:i1fputc@fp))^00h,c,w
	addwf	fsr2l
	movf	((c:i1fputc@fp+1))^00h,c,w
	addwfc	fsr2h
	movff	postinc2,??i1_fputc+0+0
	movff	postdec2,??i1_fputc+0+0+1
	movff	(c:i1fputc@fp),fsr2l
	movff	(c:i1fputc@fp+1),fsr2h
	movff	postinc2,??i1_fputc+2+0
	movff	postdec2,??i1_fputc+2+0+1
	movf	(??i1_fputc+0+0)^00h,c,w
	addwf	(??i1_fputc+2+0)^00h,c,w
	movwf	c:fsr2l
	movf	(??i1_fputc+0+1)^00h,c,w
	addwfc	(??i1_fputc+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movff	(c:i1fputc@c),indf2

	line	20
	lfsr	2,03h
	movf	((c:i1fputc@fp))^00h,c,w
	addwf	fsr2l
	movf	((c:i1fputc@fp+1))^00h,c,w
	addwfc	fsr2h
	incf	postinc2
	movlw	0
	addwfc	postdec2
	line	24
	
i1l1805:
	return	;funcret
	callstack 0
GLOBAL	__end_ofi1_fputc
	__end_ofi1_fputc:
	signat	i1_fputc,8282
	global	i1_putch

;; *************** function i1_putch *****************
;; Defined at:
;;		line 78 in file "./UART.h"
;; Parameters:    Size  Location     Type
;;  dato            1    wreg     unsigned char 
;; Auto vars:     Size  Location     Type
;;  dato            1    7[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         1       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         1       0       0       0       0       0       0       0       0
;;Total ram usage:        1 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 3
;; This function calls:
;;		i1_UART_write
;; This function is called by:
;;		i1_fputc
;; This function uses a non-reentrant model
;;
psect	text97,class=CODE,space=0,reloc=2,group=0
	file	"./UART.h"
	line	78
global __ptext97
__ptext97:
psect	text97
	file	"./UART.h"
	line	78
	
i1_putch:
;incstack = 0
	callstack 8
	movwf	((c:i1putch@dato))^00h,c
	line	80
	
i1l16983:
	movf	((c:i1putch@dato))^00h,c,w
	
	call	i1_UART_write
	line	81
	
i1l125:
	return	;funcret
	callstack 0
GLOBAL	__end_ofi1_putch
	__end_ofi1_putch:
	signat	i1_putch,4185
	global	i1_UART_write

;; *************** function i1_UART_write *****************
;; Defined at:
;;		line 63 in file "./UART.h"
;; Parameters:    Size  Location     Type
;;  dato            1    wreg     unsigned char 
;; Auto vars:     Size  Location     Type
;;  dato            1    6[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         1       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         1       0       0       0       0       0       0       0       0
;;Total ram usage:        1 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 2
;; This function calls:
;;		Nothing
;; This function is called by:
;;		i1_putch
;; This function uses a non-reentrant model
;;
psect	text98,class=CODE,space=0,reloc=2,group=0
	line	63
global __ptext98
__ptext98:
psect	text98
	file	"./UART.h"
	line	63
	
i1_UART_write:
;incstack = 0
	callstack 8
	movwf	((c:i1UART_write@dato))^00h,c
	line	65
	
i1l16857:
	movff	(c:i1UART_write@dato),(c:4013)	;volatile
	line	66
	
i1l113:
	btfss	((c:4012))^0f00h,c,1	;volatile
	goto	i1u2058_21
	goto	i1u2058_20
i1u2058_21:
	goto	i1l113
i1u2058_20:
	line	67
	
i1l116:
	return	;funcret
	callstack 0
GLOBAL	__end_ofi1_UART_write
	__end_ofi1_UART_write:
	signat	i1_UART_write,4185
	global	i1_abs

;; *************** function i1_abs *****************
;; Defined at:
;;		line 1 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\abs.c"
;; Parameters:    Size  Location     Type
;;  a               2   24[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  2   24[COMRAM] int 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 0/2
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          2       0       0       0       0       0       0       0       0
;;      Totals:         4       0       0       0       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 2
;; This function calls:
;;		Nothing
;; This function is called by:
;;		i1_dtoa
;; This function uses a non-reentrant model
;;
psect	text99,class=CODE,space=0,reloc=2,group=0
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\abs.c"
	line	1
global __ptext99
__ptext99:
psect	text99
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\abs.c"
	line	1
	
i1_abs:
;incstack = 0
	callstack 10
	line	3
	
i1l17199:
	btfsc	((c:i1abs@a+1))^00h,c,7
	goto	i1u2122_20
	movf	((c:i1abs@a+1))^00h,c,w
	bnz	i1u2122_21
	decf	((c:i1abs@a))^00h,c,w
	btfsc	status,0
	goto	i1u2122_21
	goto	i1u2122_20

i1u2122_21:
	goto	i1l1790
i1u2122_20:
	
i1l17201:
	movff	(c:i1abs@a),??i1_abs+0+0
	movff	(c:i1abs@a+1),??i1_abs+0+0+1
	comf	(??i1_abs+0+0)^00h,c
	comf	(??i1_abs+0+1)^00h,c
	infsnz	(??i1_abs+0+0)^00h,c
	incf	(??i1_abs+0+1)^00h,c
	movff	??i1_abs+0+0,(c:?i1_abs)
	movff	??i1_abs+0+1,(c:?i1_abs+1)
	goto	i1l1793
	
i1l1790:
	movff	(c:i1abs@a),(c:?i1_abs)
	movff	(c:i1abs@a+1),(c:?i1_abs+1)
	line	4
	
i1l1793:
	return	;funcret
	callstack 0
GLOBAL	__end_ofi1_abs
	__end_ofi1_abs:
	signat	i1_abs,4186
	global	i1___aomod

;; *************** function i1___aomod *****************
;; Defined at:
;;		line 9 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\aomod.c"
;; Parameters:    Size  Location     Type
;;  dividend        8    6[COMRAM] long long 
;;  divisor         8   14[COMRAM] long long 
;; Auto vars:     Size  Location     Type
;;  sign            1   23[COMRAM] unsigned char 
;;  counter         1   22[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  8    6[COMRAM] long long 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 0/2
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:        16       0       0       0       0       0       0       0       0
;;      Locals:         2       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:        18       0       0       0       0       0       0       0       0
;;Total ram usage:       18 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 2
;; This function calls:
;;		Nothing
;; This function is called by:
;;		i1_dtoa
;; This function uses a non-reentrant model
;;
psect	text100,class=CODE,space=0,reloc=2,group=0
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\aomod.c"
	line	9
global __ptext100
__ptext100:
psect	text100
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\aomod.c"
	line	9
	
i1___aomod:
;incstack = 0
	callstack 10
	line	14
	
i1l17141:
	movlw	low(0)
	movwf	((c:i1___aomod@sign))^00h,c
	line	15
	
i1l17143:
	btfsc	((c:i1___aomod@dividend+7))^00h,c,7
	goto	i1u2112_20
	goto	i1u2112_21

i1u2112_21:
	goto	i1l17149
i1u2112_20:
	line	16
	
i1l17145:
	comf	((c:i1___aomod@dividend+7))^00h,c
	comf	((c:i1___aomod@dividend+6))^00h,c
	comf	((c:i1___aomod@dividend+5))^00h,c
	comf	((c:i1___aomod@dividend+4))^00h,c
	comf	((c:i1___aomod@dividend+3))^00h,c
	comf	((c:i1___aomod@dividend+2))^00h,c
	comf	((c:i1___aomod@dividend+1))^00h,c
	negf	((c:i1___aomod@dividend))^00h,c
	movlw	0
	addwfc	((c:i1___aomod@dividend+1))^00h,c
	addwfc	((c:i1___aomod@dividend+2))^00h,c
	addwfc	((c:i1___aomod@dividend+3))^00h,c
	addwfc	((c:i1___aomod@dividend+4))^00h,c
	addwfc	((c:i1___aomod@dividend+5))^00h,c
	addwfc	((c:i1___aomod@dividend+6))^00h,c
	addwfc	((c:i1___aomod@dividend+7))^00h,c
	line	17
	
i1l17147:
	movlw	low(01h)
	movwf	((c:i1___aomod@sign))^00h,c
	line	19
	
i1l17149:
	btfsc	((c:i1___aomod@divisor+7))^00h,c,7
	goto	i1u2113_20
	goto	i1u2113_21

i1u2113_21:
	goto	i1l17153
i1u2113_20:
	line	20
	
i1l17151:
	comf	((c:i1___aomod@divisor+7))^00h,c
	comf	((c:i1___aomod@divisor+6))^00h,c
	comf	((c:i1___aomod@divisor+5))^00h,c
	comf	((c:i1___aomod@divisor+4))^00h,c
	comf	((c:i1___aomod@divisor+3))^00h,c
	comf	((c:i1___aomod@divisor+2))^00h,c
	comf	((c:i1___aomod@divisor+1))^00h,c
	negf	((c:i1___aomod@divisor))^00h,c
	movlw	0
	addwfc	((c:i1___aomod@divisor+1))^00h,c
	addwfc	((c:i1___aomod@divisor+2))^00h,c
	addwfc	((c:i1___aomod@divisor+3))^00h,c
	addwfc	((c:i1___aomod@divisor+4))^00h,c
	addwfc	((c:i1___aomod@divisor+5))^00h,c
	addwfc	((c:i1___aomod@divisor+6))^00h,c
	addwfc	((c:i1___aomod@divisor+7))^00h,c
	line	21
	
i1l17153:
	movf	((c:i1___aomod@divisor))^00h,c,w
iorwf	((c:i1___aomod@divisor+1))^00h,c,w
iorwf	((c:i1___aomod@divisor+2))^00h,c,w
iorwf	((c:i1___aomod@divisor+3))^00h,c,w
iorwf	((c:i1___aomod@divisor+4))^00h,c,w
iorwf	((c:i1___aomod@divisor+5))^00h,c,w
iorwf	((c:i1___aomod@divisor+6))^00h,c,w
iorwf	((c:i1___aomod@divisor+7))^00h,c,w
	btfsc	status,2
	goto	i1u2114_21
	goto	i1u2114_20

i1u2114_21:
	goto	i1l17169
i1u2114_20:
	line	22
	
i1l17155:
	movlw	low(01h)
	movwf	((c:i1___aomod@counter))^00h,c
	line	23
	goto	i1l17159
	line	24
	
i1l17157:
	bcf	status,0
	rlcf	((c:i1___aomod@divisor))^00h,c
	rlcf	((c:i1___aomod@divisor+1))^00h,c
	rlcf	((c:i1___aomod@divisor+2))^00h,c
	rlcf	((c:i1___aomod@divisor+3))^00h,c
	rlcf	((c:i1___aomod@divisor+4))^00h,c
	rlcf	((c:i1___aomod@divisor+5))^00h,c
	rlcf	((c:i1___aomod@divisor+6))^00h,c
	rlcf	((c:i1___aomod@divisor+7))^00h,c
	line	25
	incf	((c:i1___aomod@counter))^00h,c
	line	23
	
i1l17159:
	
	btfss	((c:i1___aomod@divisor+7))^00h,c,(63)&7
	goto	i1u2115_21
	goto	i1u2115_20
i1u2115_21:
	goto	i1l17157
i1u2115_20:
	line	28
	
i1l17161:
		movf	((c:i1___aomod@divisor))^00h,c,w
	subwf	((c:i1___aomod@dividend))^00h,c,w
	movf	((c:i1___aomod@divisor+1))^00h,c,w
	subwfb	((c:i1___aomod@dividend+1))^00h,c,w
	movf	((c:i1___aomod@divisor+2))^00h,c,w
	subwfb	((c:i1___aomod@dividend+2))^00h,c,w
	movf	((c:i1___aomod@divisor+3))^00h,c,w
	subwfb	((c:i1___aomod@dividend+3))^00h,c,w
	movf	((c:i1___aomod@divisor+4))^00h,c,w
	subwfb	((c:i1___aomod@dividend+4))^00h,c,w
	movf	((c:i1___aomod@divisor+5))^00h,c,w
	subwfb	((c:i1___aomod@dividend+5))^00h,c,w
	movf	((c:i1___aomod@divisor+6))^00h,c,w
	subwfb	((c:i1___aomod@dividend+6))^00h,c,w
	movf	((c:i1___aomod@divisor+7))^00h,c,w
	subwfb	((c:i1___aomod@dividend+7))^00h,c,w
	btfss	status,0
	goto	i1u2116_21
	goto	i1u2116_20

i1u2116_21:
	goto	i1l17165
i1u2116_20:
	line	29
	
i1l17163:
	movf	((c:i1___aomod@divisor))^00h,c,w
	subwf	((c:i1___aomod@dividend))^00h,c
	movf	((c:i1___aomod@divisor+1))^00h,c,w
	subwfb	((c:i1___aomod@dividend+1))^00h,c
	movf	((c:i1___aomod@divisor+2))^00h,c,w
	subwfb	((c:i1___aomod@dividend+2))^00h,c
	movf	((c:i1___aomod@divisor+3))^00h,c,w
	subwfb	((c:i1___aomod@dividend+3))^00h,c
	movf	((c:i1___aomod@divisor+4))^00h,c,w
	subwfb	((c:i1___aomod@dividend+4))^00h,c
	movf	((c:i1___aomod@divisor+5))^00h,c,w
	subwfb	((c:i1___aomod@dividend+5))^00h,c
	movf	((c:i1___aomod@divisor+6))^00h,c,w
	subwfb	((c:i1___aomod@dividend+6))^00h,c
	movf	((c:i1___aomod@divisor+7))^00h,c,w
	subwfb	((c:i1___aomod@dividend+7))^00h,c
	line	30
	
i1l17165:
	bcf	status,0
	rrcf	((c:i1___aomod@divisor+7))^00h,c
	rrcf	((c:i1___aomod@divisor+6))^00h,c
	rrcf	((c:i1___aomod@divisor+5))^00h,c
	rrcf	((c:i1___aomod@divisor+4))^00h,c
	rrcf	((c:i1___aomod@divisor+3))^00h,c
	rrcf	((c:i1___aomod@divisor+2))^00h,c
	rrcf	((c:i1___aomod@divisor+1))^00h,c
	rrcf	((c:i1___aomod@divisor))^00h,c
	line	31
	
i1l17167:
	decfsz	((c:i1___aomod@counter))^00h,c
	
	goto	i1l17161
	line	33
	
i1l17169:
	movf	((c:i1___aomod@sign))^00h,c,w
	btfsc	status,2
	goto	i1u2117_21
	goto	i1u2117_20
i1u2117_21:
	goto	i1l17173
i1u2117_20:
	line	34
	
i1l17171:
	comf	((c:i1___aomod@dividend+7))^00h,c
	comf	((c:i1___aomod@dividend+6))^00h,c
	comf	((c:i1___aomod@dividend+5))^00h,c
	comf	((c:i1___aomod@dividend+4))^00h,c
	comf	((c:i1___aomod@dividend+3))^00h,c
	comf	((c:i1___aomod@dividend+2))^00h,c
	comf	((c:i1___aomod@dividend+1))^00h,c
	negf	((c:i1___aomod@dividend))^00h,c
	movlw	0
	addwfc	((c:i1___aomod@dividend+1))^00h,c
	addwfc	((c:i1___aomod@dividend+2))^00h,c
	addwfc	((c:i1___aomod@dividend+3))^00h,c
	addwfc	((c:i1___aomod@dividend+4))^00h,c
	addwfc	((c:i1___aomod@dividend+5))^00h,c
	addwfc	((c:i1___aomod@dividend+6))^00h,c
	addwfc	((c:i1___aomod@dividend+7))^00h,c
	line	35
	
i1l17173:
	movff	(c:i1___aomod@dividend),(c:?i1___aomod)
	movff	(c:i1___aomod@dividend+1),(c:?i1___aomod+1)
	movff	(c:i1___aomod@dividend+2),(c:?i1___aomod+2)
	movff	(c:i1___aomod@dividend+3),(c:?i1___aomod+3)
	movff	(c:i1___aomod@dividend+4),(c:?i1___aomod+4)
	movff	(c:i1___aomod@dividend+5),(c:?i1___aomod+5)
	movff	(c:i1___aomod@dividend+6),(c:?i1___aomod+6)
	movff	(c:i1___aomod@dividend+7),(c:?i1___aomod+7)
	line	36
	
i1l1076:
	return	;funcret
	callstack 0
GLOBAL	__end_ofi1___aomod
	__end_ofi1___aomod:
	signat	i1___aomod,8287
	global	i1___aodiv

;; *************** function i1___aodiv *****************
;; Defined at:
;;		line 9 in file "C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\aodiv.c"
;; Parameters:    Size  Location     Type
;;  dividend        8    6[COMRAM] long long 
;;  divisor         8   14[COMRAM] long long 
;; Auto vars:     Size  Location     Type
;;  quotient        8   24[COMRAM] long long 
;;  sign            1   23[COMRAM] unsigned char 
;;  counter         1   22[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  8    6[COMRAM] long long 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0
;; Tracked objects:
;;		On entry : 0/2
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:        16       0       0       0       0       0       0       0       0
;;      Locals:        10       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:        26       0       0       0       0       0       0       0       0
;;Total ram usage:       26 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 2
;; This function calls:
;;		Nothing
;; This function is called by:
;;		i1_dtoa
;; This function uses a non-reentrant model
;;
psect	text101,class=CODE,space=0,reloc=2,group=0
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\aodiv.c"
	line	9
global __ptext101
__ptext101:
psect	text101
	file	"C:\Program Files\Microchip\xc8\v2.36\pic\sources\c99\common\aodiv.c"
	line	9
	
i1___aodiv:
;incstack = 0
	callstack 10
	line	15
	
i1l17097:
	movlw	low(0)
	movwf	((c:i1___aodiv@sign))^00h,c
	line	16
	
i1l17099:
	btfsc	((c:i1___aodiv@divisor+7))^00h,c,7
	goto	i1u2105_20
	goto	i1u2105_21

i1u2105_21:
	goto	i1l17105
i1u2105_20:
	line	17
	
i1l17101:
	comf	((c:i1___aodiv@divisor+7))^00h,c
	comf	((c:i1___aodiv@divisor+6))^00h,c
	comf	((c:i1___aodiv@divisor+5))^00h,c
	comf	((c:i1___aodiv@divisor+4))^00h,c
	comf	((c:i1___aodiv@divisor+3))^00h,c
	comf	((c:i1___aodiv@divisor+2))^00h,c
	comf	((c:i1___aodiv@divisor+1))^00h,c
	negf	((c:i1___aodiv@divisor))^00h,c
	movlw	0
	addwfc	((c:i1___aodiv@divisor+1))^00h,c
	addwfc	((c:i1___aodiv@divisor+2))^00h,c
	addwfc	((c:i1___aodiv@divisor+3))^00h,c
	addwfc	((c:i1___aodiv@divisor+4))^00h,c
	addwfc	((c:i1___aodiv@divisor+5))^00h,c
	addwfc	((c:i1___aodiv@divisor+6))^00h,c
	addwfc	((c:i1___aodiv@divisor+7))^00h,c
	line	18
	
i1l17103:
	movlw	low(01h)
	movwf	((c:i1___aodiv@sign))^00h,c
	line	20
	
i1l17105:
	btfsc	((c:i1___aodiv@dividend+7))^00h,c,7
	goto	i1u2106_20
	goto	i1u2106_21

i1u2106_21:
	goto	i1l17111
i1u2106_20:
	line	21
	
i1l17107:
	comf	((c:i1___aodiv@dividend+7))^00h,c
	comf	((c:i1___aodiv@dividend+6))^00h,c
	comf	((c:i1___aodiv@dividend+5))^00h,c
	comf	((c:i1___aodiv@dividend+4))^00h,c
	comf	((c:i1___aodiv@dividend+3))^00h,c
	comf	((c:i1___aodiv@dividend+2))^00h,c
	comf	((c:i1___aodiv@dividend+1))^00h,c
	negf	((c:i1___aodiv@dividend))^00h,c
	movlw	0
	addwfc	((c:i1___aodiv@dividend+1))^00h,c
	addwfc	((c:i1___aodiv@dividend+2))^00h,c
	addwfc	((c:i1___aodiv@dividend+3))^00h,c
	addwfc	((c:i1___aodiv@dividend+4))^00h,c
	addwfc	((c:i1___aodiv@dividend+5))^00h,c
	addwfc	((c:i1___aodiv@dividend+6))^00h,c
	addwfc	((c:i1___aodiv@dividend+7))^00h,c
	line	22
	
i1l17109:
	movlw	(01h)&0ffh
	xorwf	((c:i1___aodiv@sign))^00h,c
	line	24
	
i1l17111:
	lfsr	2,(i1___aodiv@quotient)
	movlw	8-1
i1u2107_21:
	clrf	postinc2
	decf	wreg
	bc	i1u2107_21
	line	25
	
i1l17113:
	movf	((c:i1___aodiv@divisor))^00h,c,w
iorwf	((c:i1___aodiv@divisor+1))^00h,c,w
iorwf	((c:i1___aodiv@divisor+2))^00h,c,w
iorwf	((c:i1___aodiv@divisor+3))^00h,c,w
iorwf	((c:i1___aodiv@divisor+4))^00h,c,w
iorwf	((c:i1___aodiv@divisor+5))^00h,c,w
iorwf	((c:i1___aodiv@divisor+6))^00h,c,w
iorwf	((c:i1___aodiv@divisor+7))^00h,c,w
	btfsc	status,2
	goto	i1u2108_21
	goto	i1u2108_20

i1u2108_21:
	goto	i1l17133
i1u2108_20:
	line	26
	
i1l17115:
	movlw	low(01h)
	movwf	((c:i1___aodiv@counter))^00h,c
	line	27
	goto	i1l17119
	line	28
	
i1l17117:
	bcf	status,0
	rlcf	((c:i1___aodiv@divisor))^00h,c
	rlcf	((c:i1___aodiv@divisor+1))^00h,c
	rlcf	((c:i1___aodiv@divisor+2))^00h,c
	rlcf	((c:i1___aodiv@divisor+3))^00h,c
	rlcf	((c:i1___aodiv@divisor+4))^00h,c
	rlcf	((c:i1___aodiv@divisor+5))^00h,c
	rlcf	((c:i1___aodiv@divisor+6))^00h,c
	rlcf	((c:i1___aodiv@divisor+7))^00h,c
	line	29
	incf	((c:i1___aodiv@counter))^00h,c
	line	27
	
i1l17119:
	
	btfss	((c:i1___aodiv@divisor+7))^00h,c,(63)&7
	goto	i1u2109_21
	goto	i1u2109_20
i1u2109_21:
	goto	i1l17117
i1u2109_20:
	line	32
	
i1l17121:
	bcf	status,0
	rlcf	((c:i1___aodiv@quotient))^00h,c
	rlcf	((c:i1___aodiv@quotient+1))^00h,c
	rlcf	((c:i1___aodiv@quotient+2))^00h,c
	rlcf	((c:i1___aodiv@quotient+3))^00h,c
	rlcf	((c:i1___aodiv@quotient+4))^00h,c
	rlcf	((c:i1___aodiv@quotient+5))^00h,c
	rlcf	((c:i1___aodiv@quotient+6))^00h,c
	rlcf	((c:i1___aodiv@quotient+7))^00h,c
	line	33
	
i1l17123:
		movf	((c:i1___aodiv@divisor))^00h,c,w
	subwf	((c:i1___aodiv@dividend))^00h,c,w
	movf	((c:i1___aodiv@divisor+1))^00h,c,w
	subwfb	((c:i1___aodiv@dividend+1))^00h,c,w
	movf	((c:i1___aodiv@divisor+2))^00h,c,w
	subwfb	((c:i1___aodiv@dividend+2))^00h,c,w
	movf	((c:i1___aodiv@divisor+3))^00h,c,w
	subwfb	((c:i1___aodiv@dividend+3))^00h,c,w
	movf	((c:i1___aodiv@divisor+4))^00h,c,w
	subwfb	((c:i1___aodiv@dividend+4))^00h,c,w
	movf	((c:i1___aodiv@divisor+5))^00h,c,w
	subwfb	((c:i1___aodiv@dividend+5))^00h,c,w
	movf	((c:i1___aodiv@divisor+6))^00h,c,w
	subwfb	((c:i1___aodiv@dividend+6))^00h,c,w
	movf	((c:i1___aodiv@divisor+7))^00h,c,w
	subwfb	((c:i1___aodiv@dividend+7))^00h,c,w
	btfss	status,0
	goto	i1u2110_21
	goto	i1u2110_20

i1u2110_21:
	goto	i1l17129
i1u2110_20:
	line	34
	
i1l17125:
	movf	((c:i1___aodiv@divisor))^00h,c,w
	subwf	((c:i1___aodiv@dividend))^00h,c
	movf	((c:i1___aodiv@divisor+1))^00h,c,w
	subwfb	((c:i1___aodiv@dividend+1))^00h,c
	movf	((c:i1___aodiv@divisor+2))^00h,c,w
	subwfb	((c:i1___aodiv@dividend+2))^00h,c
	movf	((c:i1___aodiv@divisor+3))^00h,c,w
	subwfb	((c:i1___aodiv@dividend+3))^00h,c
	movf	((c:i1___aodiv@divisor+4))^00h,c,w
	subwfb	((c:i1___aodiv@dividend+4))^00h,c
	movf	((c:i1___aodiv@divisor+5))^00h,c,w
	subwfb	((c:i1___aodiv@dividend+5))^00h,c
	movf	((c:i1___aodiv@divisor+6))^00h,c,w
	subwfb	((c:i1___aodiv@dividend+6))^00h,c
	movf	((c:i1___aodiv@divisor+7))^00h,c,w
	subwfb	((c:i1___aodiv@dividend+7))^00h,c
	line	35
	
i1l17127:
	bsf	(0+(0/8)+(c:i1___aodiv@quotient))^00h,c,(0)&7
	line	37
	
i1l17129:
	bcf	status,0
	rrcf	((c:i1___aodiv@divisor+7))^00h,c
	rrcf	((c:i1___aodiv@divisor+6))^00h,c
	rrcf	((c:i1___aodiv@divisor+5))^00h,c
	rrcf	((c:i1___aodiv@divisor+4))^00h,c
	rrcf	((c:i1___aodiv@divisor+3))^00h,c
	rrcf	((c:i1___aodiv@divisor+2))^00h,c
	rrcf	((c:i1___aodiv@divisor+1))^00h,c
	rrcf	((c:i1___aodiv@divisor))^00h,c
	line	38
	
i1l17131:
	decfsz	((c:i1___aodiv@counter))^00h,c
	
	goto	i1l17121
	line	40
	
i1l17133:
	movf	((c:i1___aodiv@sign))^00h,c,w
	btfsc	status,2
	goto	i1u2111_21
	goto	i1u2111_20
i1u2111_21:
	goto	i1l17137
i1u2111_20:
	line	41
	
i1l17135:
	comf	((c:i1___aodiv@quotient+7))^00h,c
	comf	((c:i1___aodiv@quotient+6))^00h,c
	comf	((c:i1___aodiv@quotient+5))^00h,c
	comf	((c:i1___aodiv@quotient+4))^00h,c
	comf	((c:i1___aodiv@quotient+3))^00h,c
	comf	((c:i1___aodiv@quotient+2))^00h,c
	comf	((c:i1___aodiv@quotient+1))^00h,c
	negf	((c:i1___aodiv@quotient))^00h,c
	movlw	0
	addwfc	((c:i1___aodiv@quotient+1))^00h,c
	addwfc	((c:i1___aodiv@quotient+2))^00h,c
	addwfc	((c:i1___aodiv@quotient+3))^00h,c
	addwfc	((c:i1___aodiv@quotient+4))^00h,c
	addwfc	((c:i1___aodiv@quotient+5))^00h,c
	addwfc	((c:i1___aodiv@quotient+6))^00h,c
	addwfc	((c:i1___aodiv@quotient+7))^00h,c
	line	42
	
i1l17137:
	movff	(c:i1___aodiv@quotient),(c:?i1___aodiv)
	movff	(c:i1___aodiv@quotient+1),(c:?i1___aodiv+1)
	movff	(c:i1___aodiv@quotient+2),(c:?i1___aodiv+2)
	movff	(c:i1___aodiv@quotient+3),(c:?i1___aodiv+3)
	movff	(c:i1___aodiv@quotient+4),(c:?i1___aodiv+4)
	movff	(c:i1___aodiv@quotient+5),(c:?i1___aodiv+5)
	movff	(c:i1___aodiv@quotient+6),(c:?i1___aodiv+6)
	movff	(c:i1___aodiv@quotient+7),(c:?i1___aodiv+7)
	line	43
	
i1l1063:
	return	;funcret
	callstack 0
GLOBAL	__end_ofi1___aodiv
	__end_ofi1___aodiv:
	signat	i1___aodiv,8287
	global	_INT_isr

;; *************** function _INT_isr *****************
;; Defined at:
;;		line 45 in file "main.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;  ch              1    5[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         1       0       0       0       0       0       0       0       0
;;      Temps:          4       0       0       0       0       0       0       0       0
;;      Totals:         5       0       0       0       0       0       0       0       0
;;Total ram usage:        5 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		_UART_read
;;		_receiverUart1
;; This function is called by:
;;		Interrupt level 2
;; This function uses a non-reentrant model
;;
psect	intcode,class=CODE,space=0,reloc=2
	file	"D:\@Proyect\Baliza\1 Firmware\Doc mplabx\build_xc8\main.as"
	line	#
global __pintcode
__pintcode:
psect	intcode
	file	"main.c"
	line	45
	
_INT_isr:
;incstack = 0
	callstack 6
	bsf int$flags,1,c ;set compiler interrupt flag (level 2)
	global	int_func
	call	int_func,f	;refresh shadow registers
psect	intcode_body,class=CODE,space=0,reloc=2
global __pintcode_body
__pintcode_body:
int_func:

	pop	; remove dummy address from shadow register refresh
	movff	fsr1l+0,??_INT_isr+0
	movff	fsr1h+0,??_INT_isr+1
	movff	fsr2l+0,??_INT_isr+2
	movff	fsr2h+0,??_INT_isr+3
	line	50
	
i2l7907:
	btfss	((c:4082))^0f00h,c,2	;volatile
	goto	i2u880_41
	goto	i2u880_40
i2u880_41:
	goto	i2l7917
i2u880_40:
	line	53
	
i2l7909:
	movlw	high(0FFECh)
	movwf	((c:4054+1))^0f00h,c	;volatile
	movlw	low(0FFECh)
	movwf	((c:4054))^0f00h,c	;volatile
	line	55
	
i2l7911:
	bcf	((c:4082))^0f00h,c,2	;volatile
	line	58
	
i2l7913:
	movlw	low(01h)
	movlb	1	; () banked
	addwf	((_ulCntTick1ms))&0ffh
	movlw	0
	addwfc	((_ulCntTick1ms+1))&0ffh
	addwfc	((_ulCntTick1ms+2))&0ffh
	addwfc	((_ulCntTick1ms+3))&0ffh
		movf	((_ulCntTick1ms+3))&0ffh,w
	iorwf	((_ulCntTick1ms+2))&0ffh,w
	bnz	i2u881_40
	movlw	96
	subwf	 ((_ulCntTick1ms))&0ffh,w
	movlw	234
	subwfb	((_ulCntTick1ms+1))&0ffh,w
	btfss	status,0
	goto	i2u881_41
	goto	i2u881_40

i2u881_41:
	goto	i2l7917
i2u881_40:
	line	60
	
i2l7915:; BSR set to: 1

	movlw	low(0)
	movwf	((_ulCntTick1ms))&0ffh
	movlw	high(0)
	movwf	((_ulCntTick1ms+1))&0ffh
	movlw	low highword(0)
	movwf	((_ulCntTick1ms+2))&0ffh
	movlw	high highword(0)
	movwf	((_ulCntTick1ms+3))&0ffh
	line	62
	movlw	low(0)
	movwf	((_ulCntPeriodLedLive))&0ffh
	movlw	high(0)
	movwf	((_ulCntPeriodLedLive+1))&0ffh
	movlw	low highword(0)
	movwf	((_ulCntPeriodLedLive+2))&0ffh
	movlw	high highword(0)
	movwf	((_ulCntPeriodLedLive+3))&0ffh
	line	63
	movlw	low(0)
	movwf	((_ulCntPeriodAplicacion))&0ffh
	movlw	high(0)
	movwf	((_ulCntPeriodAplicacion+1))&0ffh
	movlw	low highword(0)
	movwf	((_ulCntPeriodAplicacion+2))&0ffh
	movlw	high highword(0)
	movwf	((_ulCntPeriodAplicacion+3))&0ffh
	line	64
	movlw	low(0)
	movwf	((_ulCntPeriodAlarm))&0ffh
	movlw	high(0)
	movwf	((_ulCntPeriodAlarm+1))&0ffh
	movlw	low highword(0)
	movwf	((_ulCntPeriodAlarm+2))&0ffh
	movlw	high highword(0)
	movwf	((_ulCntPeriodAlarm+3))&0ffh
	line	66
	movlw	low(0)
	movwf	((_ulCntPeriodBuzzer))&0ffh
	movlw	high(0)
	movwf	((_ulCntPeriodBuzzer+1))&0ffh
	movlw	low highword(0)
	movwf	((_ulCntPeriodBuzzer+2))&0ffh
	movlw	high highword(0)
	movwf	((_ulCntPeriodBuzzer+3))&0ffh
	line	68
	movlw	low(0)
	movwf	((_ulCntPeriodAnaUart1))&0ffh
	movlw	high(0)
	movwf	((_ulCntPeriodAnaUart1+1))&0ffh
	movlw	low highword(0)
	movwf	((_ulCntPeriodAnaUart1+2))&0ffh
	movlw	high highword(0)
	movwf	((_ulCntPeriodAnaUart1+3))&0ffh
	line	69
	movlw	low(0)
	movwf	((_ulCntPeriodCluster))&0ffh
	movlw	high(0)
	movwf	((_ulCntPeriodCluster+1))&0ffh
	movlw	low highword(0)
	movwf	((_ulCntPeriodCluster+2))&0ffh
	movlw	high highword(0)
	movwf	((_ulCntPeriodCluster+3))&0ffh
	line	77
	
i2l7917:
	btfss	((c:3998))^0f00h,c,5	;volatile
	goto	i2u882_41
	goto	i2u882_40
i2u882_41:
	goto	i2l135
i2u882_40:
	line	79
	
i2l7919:
	call	_UART_read	;wreg free
	movwf	((c:INT_isr@ch))^00h,c
	line	82
	
i2l7921:
		movlw	low(INT_isr@ch)
	movwf	((c:receiverUart1@dest))^00h,c

	call	_receiverUart1	;wreg free
	line	83
	
i2l7923:; BSR set to: 2

	bsf	((_serial1))&0ffh,0
	line	84
	
i2l7925:; BSR set to: 2

	movlw	high(0)
	movlb	1	; () banked
	movwf	(1+(_anaT1+029h))&0ffh
	movlw	low(0)
	movwf	(0+(_anaT1+029h))&0ffh
	line	86
	
i2l135:
	movff	??_INT_isr+3,fsr2h+0
	movff	??_INT_isr+2,fsr2l+0
	movff	??_INT_isr+1,fsr1h+0
	movff	??_INT_isr+0,fsr1l+0
	bcf int$flags,1,c ;clear compiler interrupt flag (level 2)
	retfie f
	callstack 0
GLOBAL	__end_of_INT_isr
	__end_of_INT_isr:
	signat	_INT_isr,89
	global	_receiverUart1

;; *************** function _receiverUart1 *****************
;; Defined at:
;;		line 74 in file "Serial.c"
;; Parameters:    Size  Location     Type
;;  dest            1    0[COMRAM] PTR unsigned char 
;;		 -> INT_isr@ch(1), 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 3F/2
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         1       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         1       0       0       0       0       0       0       0       0
;;Total ram usage:        1 bytes
;; Hardware stack levels used: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_INT_isr
;; This function uses a non-reentrant model
;;
psect	text103,class=CODE,space=0,reloc=2,group=0
	file	"Serial.c"
	line	74
global __ptext103
__ptext103:
psect	text103
	file	"Serial.c"
	line	74
	
_receiverUart1:
;incstack = 0
	callstack 6
	line	76
	
i2l7849:
	movf	((c:receiverUart1@dest))^00h,c,w
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(_serial1+01h)
	movlb	2	; () banked
	addwf	(0+(_serial1+029h))&0ffh,w
	movwf	c:fsr1l
	clrf	1+c:fsr1l
	movlw	high(_serial1+01h)
	addwfc	1+c:fsr1l
	movff	indf2,indf1
	
i2l7851:; BSR set to: 2

	incf	(0+(_serial1+029h))&0ffh
	line	77
	
i2l830:; BSR set to: 2

	return	;funcret
	callstack 0
GLOBAL	__end_of_receiverUart1
	__end_of_receiverUart1:
	signat	_receiverUart1,4217
	global	_UART_read

;; *************** function _UART_read *****************
;; Defined at:
;;		line 44 in file "./UART.h"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      unsigned char 
;; Registers used:
;;		wreg, status,2
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_INT_isr
;; This function uses a non-reentrant model
;;
psect	text104,class=CODE,space=0,reloc=2,group=0
	file	"./UART.h"
	line	44
global __ptext104
__ptext104:
psect	text104
	file	"./UART.h"
	line	44
	
_UART_read:; BSR set to: 2

;incstack = 0
	callstack 6
	line	46
	
i2l7833:
	btfss	((c:3998))^0f00h,c,5	;volatile
	goto	i2u878_41
	goto	i2u878_40
i2u878_41:
	goto	i2l7845
i2u878_40:
	line	50
	
i2l7835:
	btfss	((c:4011))^0f00h,c,1	;volatile
	goto	i2u879_41
	goto	i2u879_40
i2u879_41:
	goto	i2l7839
i2u879_40:
	line	52
	
i2l7837:
	bcf	((c:4011))^0f00h,c,4	;volatile
	line	53
	asmopt	push
	asmopt	off
	nop
	asmopt	pop
	line	54
	bsf	((c:4011))^0f00h,c,4	;volatile
	line	56
	
i2l7839:
	movf	((c:4014))^0f00h,c,w	;volatile
	goto	i2l109
	line	60
	
i2l7845:
	movlw	(0)&0ffh
	line	61
	
i2l109:
	return	;funcret
	callstack 0
GLOBAL	__end_of_UART_read
	__end_of_UART_read:
	signat	_UART_read,89
psect	mediumconst
	db 0	; dummy byte at the end
	global	__mediumconst
	GLOBAL	__activetblptr
__activetblptr	EQU	2
	psect	intsave_regs,class=BIGRAM,space=1,noexec
	PSECT	rparam,class=COMRAM,space=1,noexec
	GLOBAL	__Lrparam
	FNCONF	rparam,??,?
	GLOBAL	___rparam_used
	___rparam_used EQU 1
	GLOBAL	___param_bank
	___param_bank EQU 0
GLOBAL	__Lparam, __Hparam
GLOBAL	__Lrparam, __Hrparam
__Lparam	EQU	__Lrparam
__Hparam	EQU	__Hrparam
       psect   temp,common,ovrld,class=COMRAM,space=1
	global	btemp
btemp:
	ds	1
	global	int$flags
	int$flags	set btemp
	global	wtemp8
	wtemp8 set btemp+1
	global	ttemp5
	ttemp5 set btemp+1
	global	ttemp6
	ttemp6 set btemp+4
	global	ttemp7
	ttemp7 set btemp+8
	end
