
#include <stdint.h>

typedef struct
{
	volatile uint32_t CSR;
	volatile uint32_t RVR;
	volatile uint32_t CVR;
	volatile uint32_t CALIB;
}SYSTICK_Config_t;

SYSTICK_Config_t *Systick = (uint32_t *)0xE000E010;

void Systick_Delay_ms(uint32_t u32Delay);

int main()
{
	uint32_t *pClockControl = (uint32_t*)(0x40023800 + 0x30);					//ahp1 peripheral clock enable reg
	uint32_t *pModeReg_GPIOD = (uint32_t*)(0x40020C00);
	uint32_t *pOutputReg_GPIOD = (uint32_t*)(0x40020C00 + 0x14);
	
	/*1. enable clock for GPIOD peripheral*/
	uint32_t temp = *pClockControl; 			//read gia tri trong thanh ghi enale clock
	temp |=0x08;
	*pClockControl = temp;
	
	/*2.config output mode */
	*pModeReg_GPIOD &=0xfcffffff;
	*pModeReg_GPIOD |= 0x01000000;
	
	/*3. set bit 12 as high*/

	*pOutputReg_GPIOD &= ~(1<<12);
	Systick_Delay_ms(1000);
	*pOutputReg_GPIOD &= ~(1<<12);
	*pOutputReg_GPIOD |= 1<<13;
	*pOutputReg_GPIOD |= 1<<14;
	while(1)
	{
		*pOutputReg_GPIOD |= 1<<12;
		Systick_Delay_ms(1000);
		*pOutputReg_GPIOD &= ~(1<<12);
		Systick_Delay_ms(1000);
	}
}

void Systick_Delay_ms(uint32_t u32Delay)
{
	while(u32Delay)
	{
		/*Cortex System timer clock max 168/8 MHz*/
		Systick->RVR = 21000-1;
		Systick->CVR = 0;
		
		/*no exception*/
		/*clear counter flag*/
		/*enable counter*/
		/*processor clock - 72M*/
		Systick->CSR = 0x05;
	
		while(((Systick->CSR) & (1<<16)) == 0)
		{
			
		}
		--u32Delay;
	}
}