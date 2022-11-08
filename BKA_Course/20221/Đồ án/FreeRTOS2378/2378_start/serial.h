/******************************************************************************/
/* SERIAL.C: Low Level Serial Routines                                        */
/******************************************************************************/
/* This file is part of the uVision/ARM development tools.                    */
/* Copyright (c) 2005-2006 Keil Software. All rights reserved.                */
/* This software may only be used under the terms of a valid, current,        */
/* end user licence from KEIL for a compatible version of KEIL software       */
/* development tools. Nothing else gives you the right to use this software.  */
/******************************************************************************/

#include <LPC23xx.H>                     /* LPC23xx definitions               */

#define UART1                            /* Use UART 0 for printf             */
#define RINT
/////////////////////////////////////////////////////////////////////////////////
////////////////////////NOTE/////////////////////////////////////////////////////
//Author: Dinh Thuan
//You can't use UART interrupt in FreeRTOS//////////////////////////////////////
//Reason: Being use FreeRTOS, you haven't to delete following code:
/*;  Enter User Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_USR
                IF      :DEF:__MICROLIB

                EXPORT __initial_sp

                ELSE

                MOV     SP, R0
                SUB     SL, SP, #USR_Stack_Size

                ENDIF
 */
 ///// Line 842: in file lpc23xx.s
 ///This is the code that allow you can use UART int
 //--> If you want to use UART int, you must turn off multitasking
 ////////////////////////////////////////////////////////////////////////////////////

/* If UART 0 is used for printf                                               */
#ifdef UART0
  #define UxFDR  U0FDR
  #define UxLCR  U0LCR
  #define UxDLL  U0DLL
  #define UxDLM  U0DLM
  #define UxLSR  U0LSR
  #define UxTHR  U0THR
  #define UxRBR  U0RBR
  #define UxIER	 U0IER
/* If UART 1 is used for printf                                               */
#elif defined(UART1)
  #define UxFDR  U1FDR
  #define UxLCR  U1LCR
  #define UxDLL  U1DLL
  #define UxDLM  U1DLM
  #define UxLSR  U1LSR
  #define UxTHR  U1THR
  #define UxRBR  U1RBR
  #define UxIER	 U1IER
#endif

   	#define TASK_UART_INT 0
	#define UART_TASK_PRIORITY 0


void RECEIVED_isr(void)__irq;
void vTaskReceivedChar(void* pvParameter);
xTaskHandle xhUARTInt;//Handle of UART interrupt task
void init_serial (void)  {               /* Initialize Serial Interface       */
  #ifdef UART0
    PINSEL0 |= 0x00000050;               /* Enable TxD0 and RxD0              */
  #elif defined (UART1)
    PINSEL0 |= 0x40000000;               /* Enable TxD1                       */
    PINSEL1 |= 0x00000001;               /* Enable RxD1                       */
  #endif
  //PCONP|=0x00000018;
  UxFDR    = 0;                          /* Fractional divider not used       */
  UxLCR    = 0x83;                       /* 8 bits, no Parity, 1 Stop bit     */
  UxDLL    = 78;                         /* 9600 Baud Rate @ 12.0 MHZ PCLK    */
  UxDLM    = 0;                          /* High divisor latch = 0            */
  UxLCR    = 0x03;                       /* DLAB = 0                          */
		//
  #ifdef RINT
  UxIER    |=0x01;							//Enable Receive buffer reg int--> Data available
  #if(TASK_UART_INT==1)
  xTaskCreate(vTaskReceivedChar,"UART0",configMINIMAL_STACK_SIZE,NULL,UART_TASK_PRIORITY,&xhUARTInt);
  vTaskSuspend(xhUARTInt);
  #endif
  	#ifdef UART0
		VICVectAddr6=(unsigned)RECEIVED_isr;
		VICVectCtrl6=1;
		VICIntEnable |=(1<<6);			
	#elif defined (UART1)
		VICVectAddr7=(unsigned)RECEIVED_isr;
		VICVectCntl7=1;
		VICIntEnable |=(1<<7);
	#endif

  #endif
}


/* Implementation of putchar (also used by printf function to output data)    */
int sendchar (int ch)  {                 /* Write character to Serial Port    */

  while (!(UxLSR & 0x20));

  return (UxTHR = ch);
}


int getkey (void)  {                     /* Read character from Serial Port   */

  while (!(UxLSR & 0x01));

  return (UxRBR);
}
int i=0;
int m=0;
char ch;
void RECEIVED_isr(void)__irq
{
	//Read to clear interrupt 
	ch=UxRBR;
	#if(TASK_UART_INT==0)
	lcd_gotoxy(m,1);
	sendchar(ch);
	lcd_putchar(ch);
	FIO2CLR=0xFF;
	FIO2SET=0x01<<i;
	i++;
	m++;
	if(i==9)i=0;
	if(m==17)
	{
		lcd_gotoxy(0,1);
		lcd_puts("                ");		
		m=0;
	}
	#else 
	if(xTaskIsTaskSuspended(xhUARTInt)==pdTRUE)		
		vTaskResume(xhUARTInt);
	#endif
	VICVectAddr=0x00;	
}
void vTaskReceivedChar(void* pvParameter)
{
	//lcd_putchar(ch);
	while(1)
	{
		portENTER_CRITICAL();
		{
		lcd_gotoxy(m,1);
		sendchar(ch);
		lcd_putchar(ch);
		}
		portEXIT_CRITICAL();
		//Display running led/////
		FIO2CLR=0xFF;
		FIO2SET=0x01<<i;
		i++;
		///////////////////////
	
		m++;
		if(i==9)i=0;
		if(m==17)
		{
			portENTER_CRITICAL();
				{
				lcd_gotoxy(0,1);
				lcd_puts("                ");
				}
			portEXIT_CRITICAL();		
			m=0;
		}

		vTaskSuspend(NULL);
	}
}
