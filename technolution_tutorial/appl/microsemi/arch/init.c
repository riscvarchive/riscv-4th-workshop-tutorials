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
 * @brief   C initialezer file. This file contains the startup code that
 *          is executed after the assambly init is performed. Furthermore,
 *          it contains the trap handler.
 */

#include <stddef.h>
#include <stdint.h>
#include <unistd.h>

#include "encoding.h"
#include "shared.h"
#include "FreeRTOS.h"
#include "syscall.h"
#include "clib.h"

#define HEAP_DUMP_ON_TRAP   (0)

uintptr_t handle_trap(uintptr_t mcause, uintptr_t epc);
void _init(void);


/**
 * Trap handler
 *
 * The trap handler is called for all machine traps excluding the
 * timer and external interrupts. These are handles by a different
 * function.
 */
uintptr_t handle_trap(uintptr_t mcause, uintptr_t epc)
{
    write(1, "trap\n", 5); /* use write to ensure it is printed */
    dbprintf("mcause : 0x%08x\nepc    : 0x%08x\n", mcause, epc);

#if(HEAP_DUMP_ON_TRAP == 1)
    mdump(0x80000000, 32 * 1024);
#endif

    _exit(1);
    return epc;
}

/**
 * c initiazation function
 *
 * First C function that is called after initializtion. It is called before de C
 * main is called.
 */
void _init(void)
{
    UART_init(&g_uart, COREUARTAPB0_BASE_ADDR, BAUD_VALUE_57600, (DATA_8_BITS | NO_PARITY));

    extern int main(int, char**);
    const char *argv0 = "";
    char *argv[] = { (char *) argv0, NULL, NULL };

    exit(main(1, argv));
}
