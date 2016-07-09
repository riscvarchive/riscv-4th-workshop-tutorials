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

/* a very naive implementation for a LED PWM. Because we manually stop
 * and restart the timers we will see some period jitter.
 */
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "clib.h"

/* Kernel includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "timers.h"

/* Common demo includes. */
#include "blink_pwm.h"
#include "led.h"

void ledOn(void);
void ledOff(void);


#define LED_PWM_TICKS (10)
static void vLedPwmTask( void *pvParameters );

void vCreateLedTasks( void )
{
    xTaskCreate(vLedPwmTask, "PWMLEDTask", configMINIMAL_STACK_SIZE, NULL, 1, NULL);
}

static void vLedPwmTask( void *pvParameters )
{
    TickType_t xLastWakeTime;
    (void) pvParameters;

    // Initialise the xLastWakeTime variable with the current time.
    xLastWakeTime = xTaskGetTickCount();

    for(;;){
        // Wait for the next cycle.
        for(int i = 1; i < LED_PWM_TICKS; i++){
                for(int a = 0;a<10;a++){
                vTaskDelayUntil(&xLastWakeTime, i);
                ledOn();
                vTaskDelayUntil(&xLastWakeTime, LED_PWM_TICKS - i);
                ledOff();
            }
        }
        for(int i = 9; i > 0; i--){
            for(int a = 0; a < LED_PWM_TICKS; a++){
                vTaskDelayUntil(&xLastWakeTime, i);
                ledOn();
                vTaskDelayUntil(&xLastWakeTime, LED_PWM_TICKS - i);
                ledOff();
            }
        }
    }
}

void ledOn(void){
    setLeds(0x0000, 0xFB00);
}

void ledOff(void){
    setLeds(0xFF00, 0xFB00);
}
	
