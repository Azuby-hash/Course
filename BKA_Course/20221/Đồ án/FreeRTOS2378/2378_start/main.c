
/* Standard includes. */
#include <stdlib.h>

/* Scheduler includes. */
#include "FreeRTOS.h"
#include "task.h"

/* Demo application includes. */
#include "partest.h"
#include "flash.h"
#include "comtest2.h"
#include "PollQ.h"
#include "BlockQ.h"
#include "semtest.h"
#include "dynamic.h"
#include "queue.h"

#include "lcd.h"
#include "serial.h"
#include "exint.h"
#include "ADC.h"

/*-----------------------------------------------------------*/

/* Constants to setup I/O and processor. */
#define mainTX_ENABLE		( ( unsigned portLONG ) 0x00000020 )	/* UART1. */
#define mainRX_ENABLE		( ( unsigned portLONG ) 0x00000080 ) 	/* UART1. */
#define mainBAURATE			9600
/*-----------------------------------------------------------*/
xQueueHandle* xqh;
static void vLedToggle(void *pvParameters);
	   void vButtonLedToggle(void* pvParameters);
	   void vSerialTest0(void* pvParameters);
	   //LCD
	   void vLCDTest(void* pvParameters);
/*Configure the hardware*/
static void prvSetupHardware( void );
/*-----------------------------------------------------------*/
xTaskHandle xth0;
int main( void )
{
		
	/* Setup the hardware for use with the Keil demo board. */
	
	FIO2DIR=0xFF;
	PINSEL10=0x00000000;
	prvSetupHardware();
	//you must create your tasks here
	xTaskCreate(vLedToggle,			"test1",configMINIMAL_STACK_SIZE,NULL,2,&xth0);
	xTaskCreate(vButtonLedToggle,	"test2",configMINIMAL_STACK_SIZE,NULL,2,NULL);
	lcd_init();
	lcd_clear();
	//xTaskCreate(vLCDTest,			"test4",configMINIMAL_STACK_SIZE,NULL,0,NULL);	
	//Scheduling all tasks
	
	init_serial();
	vInitIntx();
	initADC();
	
	vTaskStartScheduler();
	
	while(1)
	{	
		
	}
}
///////////////////////////////////////////////////////////////
static void prvSetupHardware( void )
{
	//Output LED2.0 and LED 2.2
	FIO2DIR=0xFF;
	PINSEL10=0x00000000;
}
/*-----------------------------------------------------------*/
/////////////////////////////////////////////////////////////
/////// This is new code
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
/////////////// The end////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
static void vLedToggle(void* pvParameters)
{
	//vTaskSuspend(NULL);
 while(1)
 	{	
	FIO2SET=0x01;
	vTaskDelay((portTickType)1000);
	FIO2CLR=0x01;
	vTaskDelay((portTickType)1000);
	}		
}
void vButtonLedToggle(void* pvParameters)
{
	while(1)
	{
	//FIO2CLR=0x01;
	FIO2SET=0x04;
	vTaskDelay(500);
	FIO2CLR=0x04;
	vTaskDelay(500);
	}

}
void vSerialTest0(void* pvParameters)
{
	char ch;
	int i=0,j=0;
	init_serial();
	lcd_init();
	lcd_clear();
	
	while(1)
		{
			//sendchar('A');
			ch=getkey();
			sendchar(ch);
			i++;
			//sendchar(ch);
			lcd_putchar(ch);
			if(i==16)
			if(j==0)
			{
				lcd_gotoxy(0,j+1);
				i=0;
			}
			else
			{
				lcd_clear();
				lcd_gotoxy(0,0);
				i=0;
				j=0;
			}
		}
}
 /////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
unsigned char strDisplay[11];
unsigned char* vRunningText(unsigned char* str,int len,int col)
{
	int i=0;
	if(col<0)
		{
			for(i=0;i<=len+col;i++)
				strDisplay[i]=str[i-col];
			return strDisplay;
			}
	return str;
			
}
void vLCDTest(void* pvParameters)
{
	int lin=0,rcol=0;
	unsigned char* str="KTMT-K51";
	lcd_init();	
	while(1)
	{
		lcd_clear();
		lcd_gotoxy(rcol++,lin);
		lcd_puts(str);
		vTaskDelay(700);
		if(rcol==16)rcol=0;
	}
}
