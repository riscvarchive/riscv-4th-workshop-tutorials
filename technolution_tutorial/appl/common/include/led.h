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
 * @brief   Simple HAL for driving the LEDs on the SOM060 platform
 */

#ifndef LED_H
#define LED_H

void initLeds(void);

#define LED_SHIFT           (8)
#define LED_MASK            (0xFFFF00FF)
#define NORMAL_LED_SHIFT    (11)

#define LED_MULTI_COLOR_B   (1 << 8)
#define LED_MULTI_COLOR_R   (1 << 9)
#define LED_MULTI_COLOR_G   (1 << 10)

#define LED1                (1 << 15)
#define LED2                (1 << 11)
#define LED3                (1 << 12)
#define LED4                (1 << 14)

void setLed(int index, int state);
void setLeds(int state, int mask);
void writeLeds(void);
void writeGpio(uint32_t value);

#endif /* LED_H */

