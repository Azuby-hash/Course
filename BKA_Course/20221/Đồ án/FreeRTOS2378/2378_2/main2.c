#include "lpc23xx.h"
#include "lcd.h"
#include  "serial.h"
void main()
{
	init_serial();
	lcd_init();
	lcd_clear();
	FIO2DIR=0xFF;
	PINSEL10=0x00000000;
	while(1)
	{
		
	}
}