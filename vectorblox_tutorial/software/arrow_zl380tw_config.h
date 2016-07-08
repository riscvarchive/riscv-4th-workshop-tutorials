/*config record structures*/
#ifndef __ARROW_ZL380TW_CONFIG_H_
#define __ARROW_ZL380TW_CONFIG_H_

#define ZL380XX_CFG_BLOCK_SIZE 112

typedef struct {
   unsigned short reg;   /*the register */
   unsigned short value[ZL380XX_CFG_BLOCK_SIZE]; /*the value to write into reg */
} dataArr;

extern const unsigned short configStreamLen;
extern const dataArr st_twConfig[];
#endif
