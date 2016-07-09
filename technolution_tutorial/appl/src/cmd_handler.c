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
 * @brief   Simple command handler implementation. It captures the input
 *          until a newline is given. This string will be split in white
 *          space seperated chunks and dispatched to the command handler.
 *
 *          Note:   this file is used to demonstrate exploitable code.
 *                  It should therefore not be used in production code.
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
#include "cmd_handler.h"
#include "serial.h"
#include "led.h"
#include "tunnel.h"

#define MAX_ARGS (8)

static void vCmdHandlerTask(void *pvParameters);

xComPortHandle xComPort = NULL;
int verbose = 0;

int serial_putchr(int ch)
{
    if (xComPort != NULL) {
        if (xSerialPutChar(xComPort, ch, 10) == pdTRUE) {
            return ch;
        }
    }

    return EOF;
}

void InitCmdHandlerTask(void)
{
    xComPort = xSerialPortInitMinimal(57600, 1024);
    xTaskCreate(vCmdHandlerTask, "CmdHandlerTask", configMINIMAL_STACK_SIZE, NULL, 1, NULL);
}

static int ReceiveCmd(char* buf)
{
    unsigned short idx = -1;

    /* accumulate characters until the enter is hit */
    do {
        /* increment index pointer for each character increment */
        idx++;

        if (xSerialGetChar(xComPort, (signed char *) &buf[idx], portMAX_DELAY) == pdFALSE) {
            continue;
        }

        /* echo the character back to the terminal */
        xSerialPutChar(xComPort, buf[idx], 0);

        /* handle the hit of an backspace by shifting the idx back */
        if(buf[idx] == '\b'){
            idx -= 2;
        }

        /* add some verbosity for the demo */
        if (verbose >= 2) {
            printf("buf[%d] = 0x%02x\n", idx, buf[idx]);
        }
    } while ((buf[idx] != '\n') && (buf[idx] != '\r'));

    /* return the command string without the new line, so we have only the command */
    buf[idx] = '\0';

    if (verbose >= 1){
        mdump(buf, 512);
    }

    /* return the length of the string */
    return idx + 1;
}

static int SplitCmd(char* buf, int* argc, char* argv[])
{
    /* set initial command */
    *argc = 1;
    argv[0] = buf;

    /* split args */
    size_t len = strlen(buf);
    for (size_t i = 0; i < len; i++) {
        if (buf[i] == ' ') {
            /* end the string at every space */
            buf[i] = '\0';
            /* place start of next string in arg buffer */
            argv[*argc] = &buf[i + 1];
            (*argc)++;
        }
    }

    return *argc;
}

static void ExecCmd(int argc, const char* argv[])
{
    /* dispatch command */
    if (!strcmp(argv[0], "normal")) {
        setGreenTimeMs(2000);
        setWaitTimeMs(2000);
    } else if (!strcmp(argv[0], "rush")) {
        setGreenTimeMs(6000);
        setWaitTimeMs(2000);
    } else if (!strcmp(argv[0], "stats")) {
        printf("Green time : %d ms\n", getGreenTimeMs());
        printf("Wait time  : %d ms\n", getWaitTimeMs());
    } else if (!strcmp(argv[0], "debug")) {
        register int *sp asm("sp");
        extern void *pxCurrentTCB;

        printf("@cmd_str = 0x%08x\n", (unsigned int) argv[0]);
        printf("pxCurrentTCB = 0x%08x\n", (unsigned int) pxCurrentTCB);
        printf("sp = 0x%08x\n", (unsigned int) sp);
    } else if (!strcmp(argv[0], "wleds")) {
        unsigned long value = strtoul(argv[1], NULL, 16);
        writeGpio(value);
    } else if (!strcmp(argv[0], "mem")) {
        const void *base = argv[0];
        unsigned long size = 512;

        if(argc > 1){
            unsigned long address = strtoul(argv[1], NULL, 16);
            base = (void *) address;
        }

        if(argc > 2){
            size = strtoul(argv[2], NULL, 16);
        }

        mdump(base, size);
    } else if (!strcmp(argv[0], "ps")) {
        char buffer[1024];
        vTaskList(buffer);
        printf(buffer);
    } else if (!strcmp(argv[0], "verbose")) {
        verbose = strtoul(argv[1], NULL, 10);
    } else {
        printf("\nunknown command, '%s'\n\n", argv[0]);
        printf("*************************************************\n");
        printf("* The following commands are available:\n");
        printf("* > normal\n");
        printf("*      use short delays, to optimize waiting times\n");
        printf("* > rush\n");
        printf("*      use long delays, to optimize througput during rush hours\n");
        printf("* > stats\n");
        printf("*      print current wait time and green wait time\n");
        printf("*************************************************\n");
    }
}

static void HandleCmd(void)
{
    char cmd_str[256];
    char* argv[MAX_ARGS];
    int argc = 0;

    memset(argv, 0, sizeof(argv));
    memset(cmd_str, 0, sizeof(cmd_str));
    ReceiveCmd(cmd_str);
    SplitCmd(cmd_str, &argc, argv);
    ExecCmd(argc, (const char**) argv);
}

static void vCmdHandlerTask(void *pvParameters)
{
    (void) pvParameters;

    for (;;) {
        printf("target> ");
        HandleCmd();
    }
}
