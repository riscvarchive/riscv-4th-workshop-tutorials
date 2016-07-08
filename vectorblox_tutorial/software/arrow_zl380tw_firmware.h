#include <stdint.h>

/*firmware data structures*/
#ifndef __ARROW_ZL380TW_FIRMWARE_H_
#define __ARROW_ZL380TW_FIRMWARE_H_
#define ZL380XX_FWR_BLOCK_SIZE 112

typedef struct {
    uint16_t buf[ZL380XX_FWR_BLOCK_SIZE];     /*the firmware data block to send to the device*/
    uint8_t  numWords;     /*the number of words within the block of data stored in buf[]*/
    uint32_t targetAddr;   /*the target base address to write to register 0x00c of the device*/
    uint8_t useTargetAddr; /*this value is either 0 or 1. When 1 the tarGetAddr must be written to the device*/
} twFwr;

typedef struct {
    twFwr *st_Fwr;
    uint8_t havePrgmBase;
    uint32_t prgmBase;
    uint32_t execAddr;            /*The execution start address of the firmware in RAM*/
    uint16_t twFirmwareStreamLen; /*The number of blocks within the firmware*/
    uint32_t byteCount;           /*The total number of bytes within the firmware - NOT USED*/
} twFirmware;

extern const twFwr st_twFirmware[];
extern const unsigned short firmwareStreamLen;
extern const unsigned long programBaseAddress;
extern const unsigned long executionAddress;
extern const unsigned char haveProgramBaseAddress;
//extern const unsigned short zl_firmwareBlockSize;
#endif
