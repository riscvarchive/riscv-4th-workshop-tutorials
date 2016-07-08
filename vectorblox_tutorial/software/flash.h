#ifndef FLASH_H
#define FLASH_H

#define FLASH_BASE    ((volatile int*) (0x00000000))
#define FLASH_INSTR   FLASH_BASE
#define FLASH_ENDRAM  ((volatile int*) (0x00002000))

#endif
