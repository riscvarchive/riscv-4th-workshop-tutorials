/*
    FreeRTOS V8.2.3 - Copyright (C) 2015 Real Time Engineers Ltd.
    All rights reserved

    VISIT http://www.FreeRTOS.org TO ENSURE YOU ARE USING THE LATEST VERSION.

    This file is part of the FreeRTOS distribution and was contributed
    to the project by Technolution B.V. (www.technolution.nl,
    freertos-riscv@technolution.eu) under the terms of the FreeRTOS
    contributors license.

    FreeRTOS is free software; you can redistribute it and/or modify it under
    the terms of the GNU General Public License (version 2) as published by the
    Free Software Foundation >>>> AND MODIFIED BY <<<< the FreeRTOS exception.

    ***************************************************************************
    >>!   NOTE: The modification to the GPL is included to allow you to     !<<
    >>!   distribute a combined work that includes FreeRTOS without being   !<<
    >>!   obliged to provide the source code for proprietary components     !<<
    >>!   outside of the FreeRTOS kernel.                                   !<<
    ***************************************************************************

    FreeRTOS is distributed in the hope that it will be useful, but WITHOUT ANY
    WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
    FOR A PARTICULAR PURPOSE.  Full license text is available on the following
    link: http://www.freertos.org/a00114.html

    ***************************************************************************
     *                                                                       *
     *    FreeRTOS provides completely free yet professionally developed,    *
     *    robust, strictly quality controlled, supported, and cross          *
     *    platform software that is more than just the market leader, it     *
     *    is the industry's de facto standard.                               *
     *                                                                       *
     *    Help yourself get started quickly while simultaneously helping     *
     *    to support the FreeRTOS project by purchasing a FreeRTOS           *
     *    tutorial book, reference manual, or both:                          *
     *    http://www.FreeRTOS.org/Documentation                              *
     *                                                                       *
    ***************************************************************************

    http://www.FreeRTOS.org/FAQHelp.html - Having a problem?  Start by reading
    the FAQ page "My application does not run, what could be wrong?".  Have you
    defined configASSERT()?

    http://www.FreeRTOS.org/support - In return for receiving this top quality
    embedded software for free we request you assist our global community by
    participating in the support forum.

    http://www.FreeRTOS.org/training - Investing in training allows your team to
    be as productive as possible as early as possible.  Now you can receive
    FreeRTOS training directly from Richard Barry, CEO of Real Time Engineers
    Ltd, and the world's leading authority on the world's leading RTOS.

    http://www.FreeRTOS.org/plus - A selection of FreeRTOS ecosystem products,
    including FreeRTOS+Trace - an indispensable productivity tool, a DOS
    compatible FAT file system, and our tiny thread aware UDP/IP stack.

    http://www.FreeRTOS.org/labs - Where new FreeRTOS products go to incubate.
    Come and try FreeRTOS+TCP, our new open source TCP/IP stack for FreeRTOS.

    http://www.OpenRTOS.com - Real Time Engineers ltd. license FreeRTOS to High
    Integrity Systems ltd. to sell under the OpenRTOS brand.  Low cost OpenRTOS
    licenses offer ticketed support, indemnification and commercial middleware.

    http://www.SafeRTOS.com - High Integrity Systems also provide a safety
    engineered and independently SIL3 certified version for use in safety and
    mission critical applications that require provable dependability.

    1 tab == 4 spaces!
*/

/*-----------------------------------------------------------
 * Implementation of functions defined in portable.h for the RISC-V port.
 *----------------------------------------------------------*/

/* Scheduler includes. */
#include "stdint.h"
#include "portmacro.h"
#include "FreeRTOS.h"
#include "task.h"
#include "encoding.h"
#include "shared.h"

#include "clib.h"

/* A variable is used to keep track of the critical section nesting.  This
variable has to be stored as part of the task context and must be initialised to
a non zero value to ensure interrupts don't inadvertently become unmasked before
the scheduler starts.  As it is stored as part of the task context it will
automatically be set to 0 when the first task is started. */
static UBaseType_t uxCriticalNesting;

/* Contains context when starting scheduler, save all 31 registers */
#ifdef __gracefulExit
BaseType_t xStartContext[31] = {0};
#endif

/*
 * Handler for timer interrupt
 */
void vPortSysTickHandler( void );

/*
 * Setup the timer to generate the tick interrupts.
 */
void vPortSetupTimer( void );


/*
 * Used to catch tasks that attempt to return from their implementing function.
 */
static void prvTaskExitError( void );

/*
 * Interrupt handler including the timer tick
 */
void vPortInterruptHandler(void);
void UartRxRdyHandler(void);

static timer_instance_t g_timer0;
static gpio_instance_t g_gpio1;
static plic_instance_t g_plic;

typedef void tskTCB;
extern volatile tskTCB * volatile pxCurrentTCB;

/*-----------------------------------------------------------*/

/* Sets and enable the timer interrupt */
void vPortSetupTimer(void)
{
   /* Init PLIC, TMR, GPIO */
   PLIC_init(&g_plic, PLIC_BASE_ADDR, PLIC_NUM_SOURCES, PLIC_NUM_PRIORITIES);
   TMR_init(&g_timer0,CORETIMER0_BASE_ADDR,TMR_CONTINUOUS_MODE,PRESCALER_DIV_16,(configTICK_CLOCK_HZ / configTICK_RATE_HZ));
   GPIO_init(&g_gpio1, COREGPIO_OUT_BASE_ADDR, GPIO_APB_32_BITS_BUS);

   /* Config GPIO */
   GPIO_config(&g_gpio1, GPIO_0, GPIO_OUTPUT_MODE);
   GPIO_set_outputs(&g_gpio1, 0xFFFFFFFF);

   /* Enable Timer 0 Interrupt */
   PLIC_set_priority(&g_plic, INT_DEVICE_TIMER0, 1);  
   PLIC_enable_interrupt(&g_plic, INT_DEVICE_TIMER0);  

   /* Enable global interrupts and machine external interupt */
   write_csr(mip, 0);
   set_csr(mie, MIP_MEIP);

   /* Start timer */
   TMR_enable_int(&g_timer0);
   TMR_start(&g_timer0);
}
/*-----------------------------------------------------------*/

void prvTaskExitError( void )
{
	/* A function that implements a task must not exit or attempt to return to
	its caller as there is nothing to return to.  If a task wants to exit it
	should instead call vTaskDelete( NULL ).

	Artificially force an assert() to be triggered if configASSERT() is
	defined, then stop here so application writers can catch the error. */
	configASSERT( uxCriticalNesting == ~0UL );
	portDISABLE_INTERRUPTS();
	for( ;; );
}
/*-----------------------------------------------------------*/

/* Clear current interrupt mask and set given mask */
void vPortClearInterruptMask(int mask)
{
	/* Put saved interrupt register */
	__asm volatile("csrw mie, %0"::"r"(mask));
}
/*-----------------------------------------------------------*/

/* Set interrupt mask and return current interrupt enable register */
int vPortSetInterruptMask(void)
{
	/* Save interrupt enable register and disable timer interrupt */
	int ret;
	__asm volatile("csrr %0,mie":"=r"(ret));
	__asm volatile("csrc mie,%0"::"i"(7));

	return ret;
}
/*-----------------------------------------------------------*/


/*
 * See header file for description.
 */
StackType_t *pxPortInitialiseStack( StackType_t *pxTopOfStack, TaskFunction_t pxCode, void *pvParameters )
{
	/* Simulate the stack frame as it would be created by a context switch
	interrupt. */

	register int *tp asm("x3");
	pxTopOfStack--;
	*pxTopOfStack = (portSTACK_TYPE)pxCode;			/* Start address */
	pxTopOfStack -= 22;
	*pxTopOfStack = (portSTACK_TYPE)pvParameters;	/* Register a0 */
	pxTopOfStack -= 6;
	*pxTopOfStack = (portSTACK_TYPE)tp; /* Register thread pointer */
	pxTopOfStack -= 3;
	*pxTopOfStack = (portSTACK_TYPE)prvTaskExitError; /* Register ra */
	
	return pxTopOfStack;
}
/*-----------------------------------------------------------*/

void vPortSysTickHandler( void )
{

	/* Increment the RTOS tick. */
	if( xTaskIncrementTick() != pdFALSE )
	{
		vTaskSwitchContext();
	}
	TMR_clear_int(&g_timer0);
}
/*-----------------------------------------------------------*/


void vPortInterruptHandler(void){
  plic_source int_num  = PLIC_claim_interrupt(&g_plic);
  switch(int_num){
  	  case INT_DEVICE_TIMER0: vPortSysTickHandler(); break;
  	  case INT_DEVICE_URXRDY: UartRxRdyHandler(); break;
  }
  PLIC_complete_interrupt(&g_plic, int_num);
}


/* Programs need to override this function. */
void __attribute__((weak)) UartRxRdyHandler(void)
{
	printf("[UART_RXXRDY] implement handler!\n");
	return;
}

