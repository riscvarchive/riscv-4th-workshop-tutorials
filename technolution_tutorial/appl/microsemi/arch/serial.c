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
 * @brief   Serial driver for use within FreeRTOS. It makes use of queues.
 *          The rx data is received and handled by an interrupt.
 */

/* Kernel includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "timers.h"
#include "FreeRTOSConfig.h"

#include "clib.h"
#include "serial.h"
#include "shared.h"

/******************************************************************************
 * local definitions and variables
 *****************************************************************************/
#define MAX_RX_DATA_SIZE 128

static QueueHandle_t xRxQueue;
static QueueHandle_t xTxQueue;

UART_instance_t g_uart;

static void vSerialTxTask(void *pvParameters);
static void vSerialRXTask(void *pvParameters);

/******************************************************************************
 * Exported functions
 *****************************************************************************/

/** xSerialPortInitMinimal
 *
 * @param   ulWantedBaud    This parameter is ignored, as the baudrate is already
 *                          configered during cinit
 * @param   uxQueueLength   Length of the queues
 *
 * Note that this function does not allows to set the baudrate
 */
xComPortHandle xSerialPortInitMinimal(unsigned long ulWantedBaud, unsigned portBASE_TYPE uxQueueLength)
{
    if (ulWantedBaud != 57600) {
        dbprintf("baud rate can not be set in this function,"
                 "but in the cinit function.\n This to allow early uart output\n");
    }

    /* Create the rx and tx queues. */
    xRxQueue = xQueueCreate(uxQueueLength, sizeof(signed char));
    xTxQueue = xQueueCreate(uxQueueLength, sizeof(signed char));

    /* background task to perform the actual port read & write */
    xTaskCreate(vSerialTxTask, "SerialTxTask", configMINIMAL_STACK_SIZE, NULL, 2, NULL);
    xTaskCreate(vSerialRXTask, "SerialRxTask", configMINIMAL_STACK_SIZE, NULL, 1, NULL);

    /* we only support one serial port for now */
    return (void *) 1;
}

/** vSerialPutString
 * 
 * NOTE: This implementation does not handle the queue being full as no
 * block time is used! 
 */
void vSerialPutString(xComPortHandle pxPort, const signed char * const pcString, unsigned short usStringLength)
{
    (void)pxPort;
    unsigned short i;

    /* Send each character in the string, one at a time. */
    for (i = 0; i < usStringLength; i++) {
        xSerialPutChar(pxPort, pcString[i], 0);
    }
}

/**
 * obtain character from the Rx queue
 */
signed portBASE_TYPE xSerialGetChar(xComPortHandle pxPort, signed char *pcRxedChar, TickType_t xBlockTime)
{
    (void)pxPort;
    return xQueueReceive(xRxQueue, pcRxedChar, xBlockTime);
}

/**
 *
 * Not implemented
 */
signed portBASE_TYPE xSerialPutChar(xComPortHandle pxPort, signed char cOutChar, TickType_t xBlockTime)
{
    (void)pxPort;
    return xQueueSend(xTxQueue, &cOutChar, xBlockTime);
}

/**
 *
 * NOTE: This implementation does not handle the queue being full as no
 * block time is used!
 */
portBASE_TYPE xSerialWaitForSemaphore(xComPortHandle xPort)
{
    (void)xPort;
    return 0;
}

/**
 *
 * Not implemented
 */
void vSerialClose(xComPortHandle xPort)
{
    /* FIXME: should call close right here */
    (void)xPort;
    return;
}

/******************************************************************************
 * Local functions
 *****************************************************************************/

    /**************************************************************************
     * Rx interrupt handler and back ground task for Tx
     *************************************************************************/

/**
 * UartRx data ready interrupt handler
 * This function is called whenever there is data available in the UART
 * Rx unit. Note that this function should always empty the UART fifo,
 * else the interrupt keeps active.
 */
static void vSerialRXTask(void *pvParameters)
{
	(void) pvParameters;
	uint8_t rx_data[MAX_RX_DATA_SIZE] = { 0 };
	uint8_t rx_size = 0;

	for(;;){
		rx_size = UART_get_rx(&g_uart, rx_data, sizeof(rx_data));
		for(int i = 0; i < rx_size; i++){
			xQueueSend(xRxQueue, &rx_data[i], 0);
		}
	}
}

/**
 * A simple task that will activate when there is data in the queue and send
 * this to the UART.
 */
static void vSerialTxTask(void *pvParameters)
{
    (void) pvParameters;
    char cOutChar = 0;
    for(;;){
        if(xQueueReceive(xTxQueue, &cOutChar, 10000) == pdPASS){
            UART_send(&g_uart, (const uint8_t *) &cOutChar, 1);
        }
    }
}
