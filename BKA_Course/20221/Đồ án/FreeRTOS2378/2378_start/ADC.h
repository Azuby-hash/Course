#include "lpc23xx.h"

#define ADC 0  //ADC0.0,0.1,0.2,0.3 not 0.4->0.7
#define ADCINT	   //Allow interrupt
#define Fpclk (unsigned long)12000000
#define	ADCLK (unsigned long)1000000
#define ADCINT_PRIORITY		   0
xTaskHandle xhADCInt;
int val;
unsigned char strVal[5];

void initADC(void);
void ADC_isr(void)__irq;
void vTaskADCIntx(void* pvParameter);
unsigned char* ValueToString(int val)
{
	int i;
		int j=0;
	int eval=val;
	while(eval>0){j++;eval=eval/10;}

	for(i=j-1;i>=0;i--)
	{
		strVal[i]=val%10;
		val=val-strVal[i];
		strVal[i]=strVal[i]+0x30;
		val=val/10;
	}
	strVal[j]=0;
	return strVal;
}
void initADC(void)
{
	PCONP|=(1<<12);
	PINSEL1|=(1<<(14+2*ADC));
	AD0CR = ( 0x01 << ADC ) | 		/* SEL=1,select channel 0~7 on ADC0 */
		( (Fpclk/ADCLK-1 )<< 8 ) |  /* CLKDIV = Fpclk / 1000000 - 1 */ 
		( 0 << 16 ) | 		/* BURST = 0, no BURST, software controlled */
		( 0 << 17 ) |  		/* CLKS = 0, 11 clocks/10 bits */
		( 1 << 21 ) |  		/* PDN = 1, normal operation */
		( 0 << 22 ) |  		/* TEST1:0 = 00 */
		( 1 << 24 ) |  		/* START = 0 A/D conversion stops */
		( 0 << 27 );		/* EDGE = 0 (CAP/MAT singal falling,trigger A/D conversion) */ 
#ifdef ADCINT	
	AD0INTEN=0x01<<ADC;
	VICVectAddr18=(unsigned)ADC_isr;
	xTaskCreate(vTaskADCIntx,			"testADC",configMINIMAL_STACK_SIZE,NULL,ADCINT_PRIORITY,&xhADCInt);
	vTaskSuspend(xhADCInt);
	VICVectCntl18=15;
	VICIntEnable|=(1<<18);
#endif
}
void ADC_isr()__irq
{

	val=*(&AD0DR0+4*ADC);
	val=(val>>6)&0x03FF;

	AD0CR&=0xF8FFFFFF;
	if(xTaskIsTaskSuspended(xhADCInt)==pdTRUE)		
		vTaskResume(xhADCInt);
	VICVectAddr = 0;
}
void ADC_read(void)
{
//	float fTemp;
//	int val,volt,chuc,dvi;
 	do
	{
		val=*(&AD0DR0+4*ADC);
	}
	while((val & 0x80000000)==0);
	  val=(val>>6)&0x03FF;
	  ///////////////////////////////////
	  /////// Your code /////////////////
//	  fTemp=(float)(val*3.3/1023.0);
//	  volt=(int)(fTemp*100.0);
//	  chuc=volt/10;
//	  dvi=volt%10;
	  lcd_clear();
	  lcd_puts(ValueToString(val));
	  AD0CR=0<<24;
	  /////////////////////////////////
}
void vTaskADCIntx(void* pvParameter)
{
	while(1)
	{
		portENTER_CRITICAL();
		{
			lcd_gotoxy(0,0);
			lcd_puts("                ");
			lcd_gotoxy(0,0);
			lcd_puts(ValueToString(val));
		}
		portEXIT_CRITICAL();
		vTaskDelay(5000);
		AD0CR|=(1<<24|1<<ADC);		 	
		vTaskSuspend(NULL);	
	}
}
