/**
 * Microsemi semiconductor Timberwolf product family HBI access driver
 *
 * History:
 *    Jean Bony 2014.11.19
 */

#ifndef __ARROW_ZL380TW_H_
#define __ARROW_ZL380TW_H_
#include <stdint.h>

/*IF the ZL380TW is controlling a slave flash device
* Then define these macros below so that the firmware and config can be save
* into that flash
*
*/
#undef SAVE_IMAGE_TO_FLASH /*define this macro to save the firmware from RAM to flash*/
#undef SAVE_CFG_TO_FLASH   /*define this macro to save the cfg from RAM to flash*/
#define ZL380TW_HBI_SPI    /*define this macros to select SPI as the access interface
                            *If undefined, then I2C will be used*/


/*Cached register range*/
#define ZL380TW_INT_MASK_REG  0x200

#define TWOLF_MBCMDREG_SPINWAIT  10000
#define TWOLF_MAILBOX_SPINWAIT  1000

/*TWOLF DIRECT Page REGisters*/
#define ZL380TW_10MS_COUNTER_REG    0x0036   /*free running 10ms counter*/
#define ZL380TW_CMD_REG             0x0032   /*Host Command register*/
#define ZL380TW_CMD_IDLE            0x0000  /*idle/ operation complete*/
#define ZL380TW_CMD_NO_OP           0x0001  /*no-op*/
#define ZL380TW_CMD_IMG_CFG_LOAD    0x0002  /*load firmware and CR from flash*/
#define ZL380TW_CMD_IMG_LOAD        0x0003  /*load firmware only from flash*/
#define ZL380TW_CMD_IMG_CFG_SAVE    0x0004  /*save a firmware and CR to flash*/
#define ZL380TW_CMD_IMG_CFG_ERASE   0x0005  /*erase a firmware and CR in flash*/
#define ZL380TW_CMD_CFG_LOAD        0x0006  /*Load CR from flash*/
#define ZL380TW_CMD_CFG_SAVE        0x0007  /*save CR to flash*/
#define ZL380TW_CMD_FWR_GO          0x0008  /*start/restart firmware (GO)*/
#define ZL380TW_CMD_LOAD_CMP        0x000D  /*Host Application Load Complete*/
#define ZL380TW_CMD_FLASH_INIT      0x000B  /*Host Application flash discovery*/
#define ZL380TW_CMD_FWR_STOP        0x8000  /*stop firmware */
#define ZL380TW_CMD_CMD_IN_PROGRESS 0xFFFF  /*wait command is in progress */
#define ZL380TW_CMD_APP_SLEEP       0x8005

/*Direct page registers*/
#define ZL380TW_P255_CHKSUM_LO_REG  0x000A
#define ZL380TW_P255_CHKSUM_HI_REG  0x0008
#define ZL380TW_CLK_STATUS_REG  0x0014   /*Clock status register*/
#define ZL380TW_P255_BASE_LO_REG    0x000E
#define ZL380TW_P255_BASE_HI_REG    0x000C
#define ZL380TW_SW_FLAGS_REG   0x0006
#define ZL380TW_SW_FLAGS_CMD       0x0001
#define ZL380TW_SW_FLAGS_CMD_NORST 0x0004
#define ZL380TW_PRODUCT_CODE_REG   0x0022
#define ZL380TW_HWARE_REV_REG      0x0020

#define ZL380TW_CMD_PARAM_RESULT_REG   0x0034 /*Host Command Param/Result register*/


#define ZL380TW_CLK_STATUS_HBI_BOOT    0x0001

#define HBI_CONFIG_REG              0xFD00
#define HBI_CONFIG_ENDIANNESS_LIT   0x0001
#define HBI_CONFIG_DIVEMODE_TTL     0x0000

#define HBI_CONFIG_WAKE			1<<7
#define HBI_CONFIG_VAL          (HBI_CONFIG_DIVEMODE_TTL<<1)

#define ZL380TW_FWR_COUNT_REG   0x0026 /*Fwr on flash count register*/
#define ZL380TW_FWR_EXEC_REG    0x012C  /*Fwr EXEC register*/

/*Page 1 registers*/
#define ZL380TW_OUTPUT_PATH_EN_REG  0x202

/*Macros to enable one of the pre-defined audio cross-points*/
#define ZL380TW_SINGLE_CHANNEL_AEC 0
#define ZL380TW_STEREO_BYPASS      1
#define ZL380TW_ADDA_LOOPBACK      2

/*defined error types*/
typedef enum VprocStatusType {
    VPROC_STATUS_SUCCESS      =      0,
    VPROC_STATUS_FAILURE,
    VPROC_STATUS_INIT_FAILED,
    VPROC_STATUS_WR_FAILED,
    VPROC_STATUS_RD_FAILED,
    VPROC_STATUS_FW_LOAD_FAILED,
    VPROC_STATUS_CFG_LOAD_FAILED,
    VPROC_STATUS_CLOSE_FAILED,
    VPROC_STATUS_FW_SAVE_FAILED,
    VPROC_STATUS_GFG_SAVE_FAILED,
    VPROC_STATUS_MAU_NOT_READY,
    VPROC_STATUS_CHK_FAILED,
    VPROC_STATUS_FUNC_NOT_SUPPORTED,
    VPROC_STATUS_INVALID_ARG,
    VPROC_STATUS_ERR_VTD_CODE,
    VPROC_STATUS_ERR_VERIFY,
    VPROC_STATUS_DEVICE_BUSY,
    VPROC_STATUS_ERR_HBI,
    VPROC_STATUS_ERR_IMAGE,
    VPROC_STATUS_MAILBOX_BUSY,
    VPROC_STATUS_CMDREG_BUSY,
    VPROC_STATUS_IN_CRTCL_SECTN,
    VPROC_STATUS_BOOT_LOADING_MORE_DATA,
    VPROC_STATUS_BOOT_LOADING_CMP,
    VPROC_STATUS_DEV_NOT_INITIALIZED,
} VprocStatusType;

/* Device Reset modes*/
typedef enum VprocResetMode {
    VPROC_RST_HARDWARE_ROM  =  0, /*hardware reset -reset the device and reload the firmware from flash*/
    VPROC_RST_HARDWARE_RAM  =  1, /*hardware reset -reset the device and reload the firmware from RAM*/
    VPROC_RST_SOFTWARE      =  2, /*reset the firmware - but don't change any of of the RAM contents*/
    VPROC_RST_AEC   		=  3, /*software reset -reset and runs the firmware from RAM*/
    VPROC_RST_BOOT 			=  4  /*Put the device in boot mode- so the firmware can be loaded into its RAM*/
} VprocResetMode;

/*function to write 1 or up to 124 16-bit words to the ZL380tw*/
extern int zl380tw_hbi_mwords_wr(
    uint16_t addr,     /*the 16-bit register address of the device to write to*/
	uint16_t *pData,   /*pointer to the data to write*/
	uint8_t numwords); /*The number of 16-bit words to write (Range: 1-124)*/

/*function to write 1or 2 16-bit words to the ZL380tw, then read 1 or up to 124 16-bit words from the ZL380tw*/
extern int zl380tw_hbi_mwords_rd(
    uint16_t addr,     /*the 16-bit register address of the device to read from*/
	uint16_t *pData,   /*pointer to the read data*/
	uint8_t numwords); /*The number of 16-bit words to read (Range: 1-124)*/
/*-----------------------------*/
/*Other sub-routines*/

extern int zl380tw_init();    /*0 - to load both the firmware and the config
	                   *1 - to load the firmware only
					   *2 - to load the config only*/
extern int zl380tw_reset(VprocResetMode mode);
extern int zl380tw_suspend();
extern int zl380tw_resume();
extern void zl380tw_msDelay(uint16_t time); /*time - the delay time in ms*/
extern int zl380tw_configure_codec(
	uint8_t mode);   /*0 - to configure the audio for 2-channel stereo mode
	                  *1 - to configure the audio for 1-channel AEC mode
					  *2 - AD-DA audio Loopback mode
					  */
#endif
