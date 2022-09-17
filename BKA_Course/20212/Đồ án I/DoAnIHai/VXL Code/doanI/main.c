#include "main.h"
#include "..\Lib\LCD4.h"
#include "..\Lib\Delay.h"
#include "..\Lib\UartMode1.h"

// Khai bao k�t noi HC-SRF04
sbit SRF_TRIG = P2^2;
sbit SRF_ECHO = P2^3;
sbit Am = P1^0;
sbit Duong = P1^1;

unsigned char setPoint = 50;
unsigned long int testSetPoint = 50;
unsigned char setPoints[5];
unsigned char distance = 0;
unsigned int time = 0;
unsigned int i = 0;

void main()
{
	Lcd_Init();
	
	Lcd_Out(1,1,"Distance:");
	Lcd_Out(2,1,"Set Point:");
	Lcd_Out(1,15,"cm");
	Lcd_Out(2,15,"cm");
	
	// Timer Distance
	TMOD = 0x21;
	TH0 = 0x00;
	TL0 = 0x00;
	TR0 = 0;

	TH1 = 0xFD;				// Toc do baud 9600
	TR1 = 1;				// Timer1 bat dau chay
	TI = 1;					// San sang gui du lieu
	REN = 1;				// Cho phep nhan du lieu
	SM0 = 0; SM1 = 1;		// Chon UART mode 1
	RI = 0;

	Uart_Write_Text("Enter spacing by XXXcm: ");

	while(1) {

		// Distance
		SRF_TRIG = 1;
		Delay_ms(15);
		SRF_TRIG = 0;
		
		while(SRF_ECHO == 0);
		TR0 = 1;
		while(SRF_ECHO == 1);
		TR0 = 0;
		
		time = TH0;
		time <<= 8;
		time += TL0;
		
		// UART
		
		if(time > 100 && time < 25000) {
			distance = time / 58;
			Lcd_Chr(1,11,distance / 100 + 0x30);
			Lcd_Chr_Cp(distance % 100 / 10 + 0x30);
			Lcd_Chr_Cp(distance % 10 + 0x30);

			Lcd_Chr(2,11,setPoint / 100 + 0x30);
			Lcd_Chr_Cp(setPoint % 100 / 10 + 0x30);
			Lcd_Chr_Cp(setPoint % 10 + 0x30);
			
			if(RI == 1) {
				RI = 0;
				setPoints[i] = SBUF - 128;
				if(setPoints[i] >= 0x30 && setPoints[i] <= 0x39) {
					Uart_Write(setPoints[i]);
					i++;
				}
				if(i == 3) {
					testSetPoint = (setPoints[0] - 0x30) * 100 + (setPoints[1] - 0x30) * 10 + (setPoints[2] - 0x30);
					i = 0;
					Uart_Write_Text("cm ...");
					Uart_Write(0x0D);
					if(testSetPoint < 255) {
						setPoint = testSetPoint;
					} else {
						Uart_Write_Text("Set point invalid!");
						Uart_Write(0x0D);
					}
					Uart_Write_Text("Enter spacing by XXXcm: ");
				}
				// Uart_Write(setPoint);
			}

			if (distance > setPoint) {
				Am = 1;
				Duong = 0;
			} 
			if (distance < setPoint) {
				Am = 0;
				Duong = 1;
			} 
			if (distance == setPoint) {
				Am = 0;
				Duong = 0;
			} 
		} else {
			Lcd_Cmd(_LCD_CLEAR);
			Lcd_Out(2,1,"Not in range!");
		}
		
		TH0 = 0x00;
		TL0 = 0x00;

	}
}
