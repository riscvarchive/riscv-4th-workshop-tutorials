/*
 *    (C) COPYRIGHT 2014 TECHNOLUTION B.V., GOUDA NL
 *     =======          I                   ==          I    =
 *        I             I                    I          I
 *   |    I   ===   === I ===  I ===   ===   I  I    I ====  I   ===  I ===
 *   |    I  /   \ I    I/   I I/   I I   I  I  I    I  I    I  I   I I/   I
 *   |    I  ===== I    I    I I    I I   I  I  I    I  I    I  I   I I    I
 *   |    I  \     I    I    I I    I I   I  I  I   /I  \    I  I   I I    I
 *   |    I   ===   === I    I I    I  ===  ===  === I   ==  I   ===  I    I
 *   |                 +---------------------------------------------------+
 *   +----+            |  +++++++++++++++++++++++++++++++++++++++++++++++++|
 *        |            |             ++++++++++++++++++++++++++++++++++++++|
 *        +------------+                          +++++++++++++++++++++++++|
 *                                                           ++++++++++++++|
 *                                                                    +++++|
 */

/**
 * @file
 * @author  Jonathan Hofman <jonathan.hofman@technolution.nl>
 *
 * @brief   Simple HAL for driving the LEDs on the SOM060 platform
 */

#include "shared.h"
#include "led.h"
#include "clib.h"

gpio_instance_t g_gpio0;
int led_state;

#define LED_SHIFT			(8)
#define LED_MASK			(0xFFFF00FF)

/**
 * Initalize the GPIO unit for the leds
 */
void initLeds(void)
{
    GPIO_init(&g_gpio0, COREGPIO_IN_BASE_ADDR, GPIO_APB_32_BITS_BUS);

    // DIP Switches
    GPIO_config(&g_gpio0, GPIO_0, GPIO_INPUT_MODE);
    GPIO_config(&g_gpio0, GPIO_1, GPIO_INPUT_MODE);
    GPIO_config(&g_gpio0, GPIO_2, GPIO_INPUT_MODE);
    GPIO_config(&g_gpio0, GPIO_3, GPIO_INPUT_MODE);

    // Buttons
    GPIO_config(&g_gpio0, GPIO_4, GPIO_INPUT_MODE);
    GPIO_config(&g_gpio0, GPIO_5, GPIO_INPUT_MODE);
    GPIO_config(&g_gpio0, GPIO_6, GPIO_INPUT_MODE);
    GPIO_config(&g_gpio0, GPIO_7, GPIO_INPUT_MODE);

    // LEDs
    GPIO_config(&g_gpio0, GPIO_8, GPIO_OUTPUT_MODE);
    GPIO_config(&g_gpio0, GPIO_9, GPIO_OUTPUT_MODE);
    GPIO_config(&g_gpio0, GPIO_10, GPIO_OUTPUT_MODE);
    GPIO_config(&g_gpio0, GPIO_11, GPIO_OUTPUT_MODE);
    GPIO_config(&g_gpio0, GPIO_12, GPIO_OUTPUT_MODE);
    GPIO_config(&g_gpio0, GPIO_13, GPIO_OUTPUT_MODE);
    GPIO_config(&g_gpio0, GPIO_14, GPIO_OUTPUT_MODE);
    GPIO_config(&g_gpio0, GPIO_15, GPIO_OUTPUT_MODE);

    GPIO_set_outputs(&g_gpio0, 0xFF00);
    led_state = 0;
}

/**
 * Set the led state of an individual led. You need to call writeLeds to make
 * the setting effective.
 *
 * @param index		the led position (0 to 3)
 * @param state		TRUE > led is on, FALSE > led off
 */
void setLed(int index, int state)
{
    if (index > 4) {
        dbprintf("ERROR: led index out of range\n");
    }

    if (state) {
        led_state |= 1 << (index + NORMAL_LED_SHIFT);
    } else {
        led_state &= ~(1 << (index + NORMAL_LED_SHIFT));
    }
}

/**
 * Set the led state of all leds at once. The state is committed to the GPIO
 * directly.
 *
 * @param 	state	the value to write to the leds
 * @param	mask	the mask value is one for each IO that is not effected by the
 * 					write operation. The value will always be masked with the led
 * 					so that the operation will only effect the leds.
 */
void setLeds(int state, int mask)
{
    mask = mask | LED_MASK;

    /* TODO: should be atomic, so create a mutex or so */
    uint32_t outputs = GPIO_get_outputs(&g_gpio0);
    outputs = (outputs & mask) | (state & ~mask);
    GPIO_set_outputs(&g_gpio0, outputs);
    /* end of critical section */
}

/**
 * Write GPIO directly.
 *
 * Function is used for testing.
 *
 * @param   state   the value to write to the leds
 * @param   mask    the mask value is one for each IO that is not effected by the
 *                  write operation. The value will always be masked with the led
 *                  so that the operation will only effect the leds.
 */

void writeGpio(uint32_t value)
{
    GPIO_set_outputs(&g_gpio0, value);
    uint32_t result = GPIO_get_outputs(&g_gpio0);
    dbprintf("[GPIO] write 0x%08x, read 0x%08x\n", value, result);
}
