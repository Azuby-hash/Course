#include "lpc23xx.h"
#include "task.h"

#define EINT 0	//Ext interrupt 0,1,2,3
#define EDGLE 1	// 1 is interrupt follow edgle,0 - level
#define HIGH_RISING_EDGE 0//1 is interrupt follow hight sensitive or rising edgle
							// 0 - vise versa

#define EXINT_PRIORITY 0
xTaskHandle xhExInt;
	   //Interupt 0
void vTaskExIntx(void* pvParameters);
void vInitInt0(void);
void EXTINTVectoredIRQ(void)__irq;
void vInitIntx()
{
	EXTMODE=EDGLE<<EINT;
	EXTPOLAR=HIGH_RISING_EDGE<<EINT;
		
	PINSEL4|=(1<<(20+2*EINT));
 	VICVectCntl14=15;
	VICVectAddr14=(unsigned)EXTINTVectoredIRQ;
	xTaskCreate(vTaskExIntx,			"test9",configMINIMAL_STACK_SIZE,NULL,EXINT_PRIORITY,&xhExInt);
	vTaskSuspend(xhExInt);
 	VICIntEnable |=1<<(14+EINT);
}
void EXTINTVectoredIRQ(void)__irq
{
	if(xTaskIsTaskSuspended(xhExInt)==pdTRUE)		
		vTaskResume(xhExInt);
	//FIO2SET=0x80;
	EXTINT=0x01<<EINT;//Clear INT0
	VICVectAddr=0x00;
}
void vTaskExIntx(void* pvParameters)
{
	
	while(1)
	{
	//Your code
	/////////////////////////////////
	if(FIO2PIN & 0x80)
		FIO2CLR=0x80;
	else FIO2SET=0x80;
	////////////////////////////////////
	vTaskSuspend(NULL);
	}	
}
