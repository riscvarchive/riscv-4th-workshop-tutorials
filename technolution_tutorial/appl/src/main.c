/*
  (C) COPYRIGHT 2016 TECHNOLUTION B.V., GOUDA NL
  =======          I                   ==          I    =
     I             I                    I          I
|    I   ===   === I ===  I ===   ===   I  I    I ====  I   ===  I ===
|    I  /   \ I    I/   I I/   I I   I  I  I    I  I    I  I   I I/   I
|    I  ===== I    I    I I    I I   I  I  I    I  I    I  I   I I    I
|    I  \     I    I    I I    I I   I  I  I   /I  \    I  I   I I    I
|    I   ===   === I    I I    I  ===  ===  === I   ==  I   ===  I    I
|                 +---------------------------------------------------+
+----+            |  +++++++++++++++++++++++++++++++++++++++++++++++++|
     |            |             ++++++++++++++++++++++++++++++++++++++|
     +------------+                          +++++++++++++++++++++++++|
                                                        ++++++++++++++|
                                                                 +++++|
 */
/**
 * @file
 * @author  Jonathan Hofman <jonathan.hofman@technolution.nl>
 *
 * @brief   Main function for the tutorial example program
 */

/* Kernel includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "timers.h"

/* Common demo includes. */
#include "cmd_handler.h"
#include "led.h"
#include "tunnel.h"
#include "freertos_hooks.h"
#include "clib.h"
#include "blink_pwm.h"


/**
 * Main function that will initialize all tasks and call the scheduler.
 */
int main( void ){
	dbprintf("\n\nTutorial 4th RISC-V workshop - Technolution session\n");
	dbprintf("(build date: %08x, build time: %08x\n", _BUILD_HEX_DATE_, _BUILD_HEX_TIME_);

	initLeds();

	/* create the tasks */
	InitCmdHandlerTask();
	InitTunnelTask();
	vCreateLedTasks();

	/* Start the kernel.  From here on, only tasks and interrupts will run. */
	vTaskStartScheduler();

	/* Exit FreeRTOS */
	return 0;
}

