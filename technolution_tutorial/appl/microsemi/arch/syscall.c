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
 * @brief   This file is based upon diverse low level stubs implementing
 *          diverse syscalls. The file is made based on numerous examples
 *          from the RISC-V codebase.
 */

#include <stdint.h>
#include <stdlib.h>
#include <stddef.h>
#include <unistd.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/times.h>
#include <stdio.h>
#include <string.h>

#include "encoding.h"

#include "shared.h"
#include "coregpio_regs.h"

/******************************************************************************
 * CoreUARTapb instance data.
 *****************************************************************************/

#undef errno
int errno;

extern UART_instance_t g_uart;

void _exit(int code)
{
  volatile uint32_t* leds = (uint32_t*) (COREGPIO_OUT_BASE_ADDR + GPIO_OUT0_REG_OFFSET);
  const char * message = "\nProgam has exited with code:";
  
  *leds = (~(code));

  write(STDERR_FILENO, message, strlen(message));
  write_hex(STDERR_FILENO, code);

  while (1);
}

static int stub(int err)
{
  errno = err;
  return -1;
}

int isatty(int fd)
{
  if (fd == STDOUT_FILENO || fd == STDERR_FILENO)
    return 1;

  errno = EBADF;
  return 0;
}

ssize_t read(int fd, void* ptr, size_t len)
{
  if (isatty(fd))
    return UART_get_rx(&g_uart,
                       (uint8_t*) ptr,
                       len);

  return stub(EBADF);
}

ssize_t write(int fd, const void* ptr, size_t len)
{

  const uint8_t * current = (const uint8_t*) ptr;
  size_t jj;
  if (isatty(fd)) {
    
    for (jj = 0; jj < len; jj++){
      UART_send(&g_uart, current + jj, 1);
    }
    return len;
  } 
  
  return stub(EBADF);
}

void write_hex(int fd, uint32_t hex){
  uint8_t ii;
  uint8_t jj;
  char towrite;
  write( fd , "0x", 2 );
  for (ii = 8 ; ii > 0; ii--){
    jj = ii-1;
    uint8_t digit = ((hex & (0xF << (jj*4))) >> (jj*4));
    towrite = digit < 0xA ? ('0' + digit) : ('A' +  (digit - 0xA));
    write( fd, &towrite, 1);
  }

}
