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
 * Implementation for a very simple tunnel control system.
 *
 * The system is for a very narrow tunnel where vehicles can pass from only one side at a time.
 * A green light at both sides of the tunnel indicates from which side drivers can enter the
 * tunnel. A wait time allows drivers to leave the tunnel before vehicles can enter from the
 * other side.
 *
 * The parameters (green-time and wait-time) can be controlled to optimize for latency during
 * normal operation and optimize for throughput during rush hour.
 */

/* Kernel includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "timers.h"

#include "clib.h"
#include "led.h"
#include "tunnel.h"

/******************************************************************************
 * local definitions and variables
 *****************************************************************************/

#define DIR_EAST	0
#define DIR_WEST	1

#define STATE_RED	0
#define STATE_GREEN	1

volatile int greenTimeMs = 2000;
volatile int waitTimeMs = 2000;

static void vTunnelTask(void *pvParameters);

/******************************************************************************
 * Exported functions
 *****************************************************************************/
void setGreenTimeMs(int newVal)
{
    greenTimeMs = newVal;
}

void setWaitTimeMs(int newVal)
{
    waitTimeMs = newVal;
}

int getGreenTimeMs(void)
{
    return greenTimeMs;
}

int getWaitTimeMs(void)
{
    return waitTimeMs;
}

/**
 * create the tunnel task
 */
void InitTunnelTask(void)
{
    xTaskCreate(vTunnelTask, "TunnelTask", configMINIMAL_STACK_SIZE, NULL, 2, NULL);
}

/******************************************************************************
 * Local functions
 *****************************************************************************/

/**
 * Initalize the GPIO unit for the leds
 *
 * @param direction     determines which trafic light will be set (DIR_EAST, DIR_WEST)
 * @param state         determines the state of the trafic light (STATE_RED, STATE_GREEN)
 */
static void setTraficLight(int direction, int state)
{
    uint32_t value = 0;
    uint32_t mask = 0;
    state = state ? 1 : 0;

    if (direction == DIR_EAST) {
        mask = ~(LED1 | LED2);
        value = (state == STATE_GREEN) ? LED1 : LED2;
    } else {
        mask = ~(LED3 | LED4);
        value = (state == STATE_GREEN) ? LED3 : LED4;
    }
    setLeds(value, mask);
}

/**
 * the tunnel task that will continously change the trafic lights given the delay values.
 */
static void vTunnelTask(void *pvParameters)
{
    (void) pvParameters;

    for (;;) {
        /* red light (e.g. no light) for both directions */
        setTraficLight(DIR_EAST, STATE_RED);
        setTraficLight(DIR_WEST, STATE_RED);
        vTaskDelay(waitTimeMs / portTICK_PERIOD_MS);

        /* green light for direction 1 */
        setTraficLight(DIR_EAST, STATE_GREEN);
        setTraficLight(DIR_WEST, STATE_RED);
        vTaskDelay(greenTimeMs / portTICK_PERIOD_MS);

        /* red light (e.g. no light) for both directions */
        setTraficLight(DIR_EAST, STATE_RED);
        setTraficLight(DIR_WEST, STATE_RED);
        vTaskDelay(waitTimeMs / portTICK_PERIOD_MS);

        /* green light for direction 2 */
        setTraficLight(DIR_EAST, STATE_RED);
        setTraficLight(DIR_WEST, STATE_GREEN);
        vTaskDelay(greenTimeMs / portTICK_PERIOD_MS);
    }
}

