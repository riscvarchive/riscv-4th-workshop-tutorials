#include "vectorblox_mxp_riscv.h"
#define MXP_WORD_FXP_BITS    16
#define MXP_HALF_FXP_BITS    15
#define MXP_BYTE_FXP_BITS    4
#define MXP_DATA_SPAN        (32*1024)
#define MXP_SCRATCHPAD_BASE  0x10000000
#define MXP_INSTRUCTION_BASE 0x20000000
