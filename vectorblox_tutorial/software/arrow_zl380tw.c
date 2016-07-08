/*----------------------------------------------------------------------------
 *  @FileName       :: arrow_zl380tw.c
 *
 *  @Copyright      :: Copyright (C) 2014 Microsemi Corporation. All rights reserved.
 *
 *
 *  @Description    :: Microsemi ZL380XX audio AD/DA CODEC driver
 *
 *  @History        ::
 *      Date        Name        Comments
 *      5/14/2015   Jean Bony   -- Added SPI and multi-words fwr/cfg upload
 *----------------------------------------------------------------------------*/

#include <stdlib.h>
#include "arrow_zl380tw.h"
#include "arrow_zl380tw_firmware.h"
#include "arrow_zl380tw_config.h"
#include "spi.h"
#include "flash.h"
#include "printf.h"



#define ZL380TW_ACCESS_SIZE (256)   /*The maximum number of bytes that can de sent to the device*/

/*-------------------------Timberwolf MACROS-------------------------------*/

#define HBI_PAGED_READ(offset,length) \
    ((uint16_t)(((uint16_t)(offset) << 8) | (length)))
#define HBI_DIRECT_READ(offset,length) \
    ((uint16_t)(0x8000 | ((uint16_t)(offset) << 8) | (length)))
#define HBI_PAGED_WRITE(offset,length) \
    ((uint16_t)(HBI_PAGED_READ(offset,length) | 0x0080))
#define HBI_DIRECT_WRITE(offset,length) \
    ((uint16_t)(HBI_DIRECT_READ(offset,length) | 0x0080))
#define HBI_GLOBAL_DIRECT_WRITE(offset,length) \
    ((uint16_t)(0xFC00 | ((offset) << 4) | (length)))
#define HBI_CONFIGURE(pinConfig) \
    ((uint16_t)(0xFD00 | (pinConfig)))
#define HBI_SELECT_PAGE(page) \
    ((uint16_t)(0xFE00 | (page)))
#define HBI_SELECT_CL_PAGE() \
    ((uint16_t)(0xFE80)
#define HBI_CL_BROADCAST \
    ((uint16_t)0xFEFF)
#define HBI_NO_OP \
    ((uint16_t)0xFFFF)
/*---------------------------------------------------------------------------*/

/*pure stereo bypass with no AEC
 * Record
 * MIC1 -> I2S-L
 * MIC2 -> I2S-R
 * Playback
 * I2S-L -> DAC1
 * I2S-R -> DAC2
 *reg 0x202 - 0x226
 */
#define CODEC_CONFIG_REG_NUM 19

uint16_t reg_stereo[] = {0x000F, 0x0010, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
                       0x0005, 0x0006, 0x0001, 0x0002, 0x0000, 0x0000, 0x0000,
                       0x0000, 0x0000, 0x0000, 0x0000, 0x0000
                      };

/*4-port mode with AEC enabled  - ROUT to DAC1
 * MIC1 -> SIN (ADC)
 * I2S-L -> RIN (TDM Rx path)
 * SOUT -> I2S-L
 * ROUT -> DACx
 *reg 0x202 - 0x226
 */
uint16_t reg_aec[] = {0x0c05, 0x0010, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
                    0x000d, 0x0000, 0x000e, 0x0000, 0x0000, 0x0000, 0x0000,
                    0x0000, 0x0000, 0x000d, 0x0001, 0x0005
                   };


/*Loopback mode ADC to DAC1
 * MIC1 -> DAC1
 *reg 0x202 - 0x226
 */
uint16_t reg_loopback[] = {0x003, 0x0010, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
                         0x0001, 0x0002, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
                         0x0000, 0x0000, 0x000d, 0x0000, 0x0000
                        };

// Delay functions
#define SYS_CLK 20000000
static inline uint32_t get_time() {
  int tmp;
  asm volatile("csrr %0,time":"=r"(tmp));
  return tmp;
}
static void delayms(int ms) {
  unsigned start = get_time();
  ms*=(SYS_CLK/1000);
  while(get_time()-start < ms);
}


/******************************************************************************
 * zl380tw_hbi_mwords_wr()
 * This function selects the specified page, writes the number of specified
 * words, starting at the specified offset from a source buffer.
 *
 *  \param[in]     addr        the 16-bit register of the device to write to
 *  \param[in]     pData       pointer to the data to write
 *  \param[in]     numwords    the number of 16-bit words to write (Range: 1-124)
 *
 *  return ::status = 0
 *                    or a negative error code
 ******************************************************************************/
int zl380tw_hbi_mwords_wr(uint16_t addr, uint16_t *pData, uint8_t numwords)
{
    uint16_t cmd;
    uint8_t page;
    uint8_t offset;
    uint8_t i = 0, j = 0;
    uint8_t buf[ZL380TW_ACCESS_SIZE];  /*buffer for x (u8) words*/
    uint16_t numbytes = numwords*2;

    page = addr >> 8;
    offset = (addr & 0xFF)>>1;
 
    if (page == 0) { /*Direct page access*/
      cmd = HBI_DIRECT_WRITE(offset, numwords-1);/*build the cmd*/
      buf[i++] = (cmd >> 8) & 0xFF ;
      buf[i++] = (cmd & 0xFF) ;        
    } 
    else { /*indirect page access*/
      if (page != 0xFF) {
          page  -=  1;
      }
      /*select the page*/
      cmd = HBI_SELECT_PAGE(page);
      buf[i++] = (cmd >> 8) & 0xFF ;
      buf[i++] = (cmd & 0xFF) ; 
      cmd = HBI_PAGED_WRITE(offset, numwords-1); /*build the cmd*/ 
      buf[i++] = (cmd >> 8) & 0xFF ;
      buf[i++] = (cmd & 0xFF) ; 
    }
    /*memcpy(&buf[i], pData, numwords*sizeof(uint16_t));*/
    /*use the equivalent to memcpy below. Because memcpy is subject to endianness*/
    for(j = i; j < numbytes+i; j = j+2) {
        buf[j] = (uint8_t)((*pData & 0xFF00) >> 8);
        buf[j+1] = (uint8_t)(*pData & 0x00FF);
        pData++;
    }    
    /*perform the HBI access*/
    SPI_set_ss(0);
    SPI_transfer_block(buf, numbytes+i, 0, 0);
    SPI_clear_ss(0);

    return 0;
}

/******************************************************************************
 * zl380tw_hbi_mwords_rd()
 * This function selects the specified page, writes a read command to the device
 * then read the resulting data and store it in the pData buffer.
 *
 *  \param[in]     addr        the 16-bit register of the device to read from
 *  \param[in]     pData       pointer to the buffer to store the data
 *  \param[in]     numwords    the number of 16-bit words to read (Range: 1-124)
 *
 *  return ::status = 0
 *                    or a negative error code
 ******************************************************************************/
int zl380tw_hbi_mwords_rd(uint16_t addr, uint16_t *pData, uint8_t numwords)
{
    uint16_t cmd;
    uint8_t page;
    uint8_t offset;
    uint8_t tx_len = 0;
    uint8_t tx_buf[4];  /*buffer for  x (u8) words*/
    uint8_t rx_buf[ZL380TW_ACCESS_SIZE];  /*buffer for  x (u8) words*/
    uint16_t rx_len = numwords*2;  /*in bytes*/

    page = addr >> 8;
    offset = (addr & 0xFF)>>1;
 
    if (page == 0) { /*Direct page access*/
      cmd = HBI_DIRECT_READ(offset, numwords-1);/*build the cmd*/
	    tx_buf[tx_len++] = (cmd >> 8) & 0xFF ;
      tx_buf[tx_len++] = (cmd & 0xFF) ;        
    } 
    else { /*indirect page access*/
      if (page != 0xFF) {
      }
      /*select the page*/
      cmd = HBI_SELECT_PAGE(page);
      tx_buf[tx_len++] = (cmd >> 8) & 0xFF ;
      tx_buf[tx_len++] = (cmd & 0xFF) ; 
      cmd = HBI_PAGED_READ(offset, numwords-1); /*build the cmd*/
      tx_buf[tx_len++] = (cmd >> 8) & 0xFF ;
      tx_buf[tx_len++] = (cmd & 0xFF) ;  
    }

    /*perform the HBI access*/
    SPI_set_ss(0);
    SPI_transfer_block(tx_buf, tx_len, rx_buf, rx_len);
    SPI_clear_ss(0);
    {
      uint8_t j = 0;
	    for (tx_len = 0; tx_len < numwords; tx_len++) {
	        *(pData+tx_len) = (rx_buf[j]<<8) | rx_buf[j+1];
	        j +=2;
	    }
    }

    return 0;
}

/*--------------------------------------------------------------------*/
/* zl380tw_MailboxAcquire(): use this function to
*   check for the availability of the mailbox
*
* Input Argument: None
* Return: (VprocStatusType) type error code (0 = success, else= fail)
*/
static int zl380tw_MailboxAcquire(uint16_t flag, uint16_t timeout) {
    int status = VPROC_STATUS_SUCCESS;
    /*Check whether the host owns the command register*/
    uint16_t i=0, temp = 0;
    for (i = 0; i < timeout; i++) {
      status = zl380tw_hbi_mwords_rd(ZL380TW_SW_FLAGS_REG, &temp, 1);
      if ((status != VPROC_STATUS_SUCCESS)) {
          return status;
      }
      if (!(temp & flag)) {
          break;
      }
      delayms(10); /*polling interval*/
    }
    if ((i>= timeout) && (temp & flag)) {
        return VPROC_STATUS_MAILBOX_BUSY;
    }
    /*read the Host Command register*/
    return VPROC_STATUS_SUCCESS;
}


/* zl380tw_cmdRegAcquire(): use this function to
 *   check whether the last command completed sucsesfully
 *
 * Input Argument: None
 * Return: (VprocStatusType) type error code (0 = success, else= fail)
 */
static int zl380tw_cmdRegAcquire(uint16_t flag, uint16_t timeout) {
    int status = VPROC_STATUS_SUCCESS;
    /*Check whether the host owns the command register*/
    uint16_t i=0, temp = flag;
    for (i = 0; i < timeout; i++) {
      status = zl380tw_hbi_mwords_rd(ZL380TW_CMD_REG, &temp, 1);
      if ((status != VPROC_STATUS_SUCCESS)) {
          return status;
      }
      if (temp == flag) {
          break;
      }
      delayms(10); /*wait*/
    }
    if ((i>= timeout) && (temp != flag)) {
        return VPROC_STATUS_CMDREG_BUSY;
    }
    /*read the Host Command register*/
    return VPROC_STATUS_SUCCESS;
}


/* zl380tw_cmdRegWr(): use this function to
 *   access the host command register
 *
 * Input Argument: cmd - the command to send
 * Return: (VprocStatusType) type error code (0 = success, else= fail)
 */


/* zl380tw_cmdRegWr(): use this function to
 *   access the host command register
 *
 * Input Argument: cmd - the command to send
 * Return: (VprocStatusType) type error code (0 = success, else= fail)
 */

static int zl380tw_cmdRegWr(uint16_t cmd) {
    int status = VPROC_STATUS_SUCCESS;
    uint16_t flag = 0x0000;
    /*Check whether the host owns the command register*/

    status = zl380tw_MailboxAcquire(ZL380TW_SW_FLAGS_CMD, TWOLF_MAILBOX_SPINWAIT);
    if ((status != VPROC_STATUS_SUCCESS)) {
        return status;
    }
    /*write the command into the Host Command register*/
    status = zl380tw_hbi_mwords_wr(ZL380TW_CMD_REG, &cmd, 1); //KDR changed to write
    if (status != VPROC_STATUS_SUCCESS) {
        return status;
    }
    /*Release the command reg*/
    /*read the Host Command register*/
    //KDR 150731   flag = ZL380TW_SW_FLAGS_CMD; //replaced this with the follow if/else per Jean.
    if ((cmd & 0x8000) >> 15)
        flag = ZL380TW_SW_FLAGS_CMD_NORST;
    else
        flag = ZL380TW_SW_FLAGS_CMD;

    status = zl380tw_hbi_mwords_wr(ZL380TW_SW_FLAGS_REG, &flag, 1); //KDR changed to write
    if (status != VPROC_STATUS_SUCCESS) {
        return status;
    }
    /*Wait for the command to complete*/
    status = zl380tw_cmdRegAcquire(ZL380TW_CMD_IDLE, TWOLF_MAILBOX_SPINWAIT);
    if ((status != VPROC_STATUS_SUCCESS)) {
        return status;
    }
    return VPROC_STATUS_SUCCESS;
}


static int zl380tw_CheckCmdResult()
{
    int status = VPROC_STATUS_SUCCESS;
    uint16_t buf;
    status = zl380tw_hbi_mwords_rd(ZL380TW_CMD_PARAM_RESULT_REG, &buf, 1);
    if (status != VPROC_STATUS_SUCCESS) {
        return status;
    }

    if (buf != 0) {
        return VPROC_STATUS_ERR_VERIFY;
    }
    return VPROC_STATUS_SUCCESS;
}


/*zl380tw_LoadConfig() - use this function to load a custom or new config
 * record into the device RAM to override the default config
 * \retval ::VPROC_STATUS_SUCCESS
 * \retval ::VPROC_STATUS_ERR_HBI
 */
static int zl380tw_LoadConfig(dataArr *pCr2Buf, uint16_t numElements) {
    int status = VPROC_STATUS_SUCCESS;
    uint16_t i, *buf;
 
    /*send the config to the device RAM*/
    for (i=0; i<numElements; i++) {
        buf = &pCr2Buf[i].value[0];
        status = zl380tw_hbi_mwords_wr(pCr2Buf[i].reg , buf, ZL380XX_CFG_BLOCK_SIZE);
        if (status != VPROC_STATUS_SUCCESS) {
            return VPROC_STATUS_ERR_HBI;
        }
 
    }
    return status;
}
 
/* HbiSrecBoot_alt() Use this alternate method to load the st_twFirmware.c
 *(converted *.s3 to c code) to the device
 */
static int HbiSrecBoot_alt(twFirmware *st_firmware) {
  uint16_t index = 0;
  uint16_t gTargetAddr[2] = {0, 0};

  int status = VPROC_STATUS_SUCCESS;

  while (index < st_firmware->twFirmwareStreamLen) {

    /* put the address into our global target addr */
    gTargetAddr[0] = (uint16_t)((st_firmware->st_Fwr[index].targetAddr &
                               0xFFFF0000)>>16);
    gTargetAddr[1] = (uint16_t)(st_firmware->st_Fwr[index].targetAddr &
                              0x0000FFFF);

    /* write the data to the device */
    if (st_firmware->st_Fwr[index].numWords != 0) {
      uint8_t offset  = (gTargetAddr[1] & 0x00FF);
      gTargetAddr[1] &= 0xFF00; /*zero out the lsb*/
      if (st_firmware->st_Fwr[index].useTargetAddr) {
        status = zl380tw_hbi_mwords_wr(ZL380TW_P255_BASE_HI_REG , gTargetAddr, 2);
        if (status != VPROC_STATUS_SUCCESS) {
          return VPROC_STATUS_ERR_HBI;
        }
      }

      status = zl380tw_hbi_mwords_wr(((uint16_t)(0xFF<<8) | ((uint16_t)offset)),
                                st_firmware->st_Fwr[index].buf, st_firmware->st_Fwr[index].numWords);
      if(status != VPROC_STATUS_SUCCESS) {
        return status;
      }

    }
    index++;
  }

    /*
     * convert the number of bytes to two 16 bit
     * values and write them to the requested page register
     */
    /* even number of bytes required */

    /* program the program's execution start register */
    gTargetAddr[0] = (uint16_t)((st_firmware->execAddr & 0xFFFF0000) >> 16);
    gTargetAddr[1] = (uint16_t)(st_firmware->execAddr & 0x0000FFFF);
    status = zl380tw_hbi_mwords_wr(0x12C ,gTargetAddr, 2);
    if(status != VPROC_STATUS_SUCCESS) {
        return status;
    }

    return VPROC_STATUS_SUCCESS;
}

/*zl380tw_HbiBoot_alt - use this function to bootload the firmware
 * into the device
 * \param[in] pointer to image data structure
 *
 * \retval ::VPROC_STATUS_SUCCESS
 * \retval ::VPROC_STATUS_ERR_HBI
 * \retval ::VPROC_STATUS_MAILBOX_BUSY
*/
static int zl380tw_HbiBoot_alt(twFirmware *st_firmware) {
  int status = VPROC_STATUS_SUCCESS;
  uint16_t buf[2] = {0, 0};

  /* write a value of 1 to address 0x14 (direct page offset 0x0A).
   * to stop current firmware, reset the device into the Boot Rom mode.
   */
  while(1) {

    buf[0]  = ZL380TW_CLK_STATUS_HBI_BOOT;
    status = zl380tw_hbi_mwords_wr(ZL380TW_CLK_STATUS_REG , buf, 1);
    delayms(50); /*wait for reset to complete*/


    buf[0] =
    buf[1] = 0;
    status = zl380tw_hbi_mwords_rd(ZL380TW_CMD_PARAM_RESULT_REG, buf, 1);    
    if (status != VPROC_STATUS_SUCCESS) {
        return status;
    }

    /*Check if the device is accessible for command*/
    if ((buf[0] != 0xD3D3)) {
      printf("Device not accessible for command\r\n");
      printf("%0x\r\n", buf[0]);
      //return VPROC_STATUS_ERR_HBI;
    }
    else {
      break;
    }

  }

  /*Transfer the image*/
  status =  HbiSrecBoot_alt(st_firmware);
  if (status != VPROC_STATUS_SUCCESS) {
      return status;
  }

  /*tell Twolf that the firmware loading is complete*/
  buf[0] = ZL380TW_CMD_LOAD_CMP;
  status =  zl380tw_cmdRegWr(buf[0]);
  if (status != VPROC_STATUS_SUCCESS) {
      return status;
  }

  /*Verify whether the boot loading is successful*/
  if (zl380tw_CheckCmdResult() != VPROC_STATUS_SUCCESS) {
      return VPROC_STATUS_FW_LOAD_FAILED;
  }

  return VPROC_STATUS_SUCCESS;
}

/*zl380tw_FirmwareStart - use this function to start/restart the firmware
 * previously stopped with zl380tw_FirmwareStop()
 * \param[in] none
 *
 * \retval ::VPROC_STATUS_SUCCESS
 * \retval ::VPROC_STATUS_ERR_HBI
 */
static int zl380tw_FirmwareStart() {
  uint16_t buf;

  /*Start firmware*/
  buf = ZL380TW_CMD_FWR_GO;
  return zl380tw_cmdRegWr(buf);
}

/* zl380tw_reset(): use this function to reset the device.
 *
 *
 * Input Argument: mode  - the reset mode (VPROC_RST_HARDWARE_ROM,
 *         VPROC_RST_HARDWARE_ROM, VPROC_RST_SOFT, VPROC_RST_AEC)
 * Return: (VprocStatusType) type error code (0 = success, else= fail)
 */
int zl380tw_reset(VprocResetMode mode)
{

    uint16_t addr = ZL380TW_CLK_STATUS_REG;
    uint16_t data = 0;
    /*PLATFORM SPECIFIC code*/
    if (mode  == VPROC_RST_HARDWARE_RAM) {       /*hard reset*/
        /*hard reset*/
        data = 0x0005;
    } else if (mode == VPROC_RST_HARDWARE_ROM) {  /*power on reset*/
        /*hard reset*/
        data = 0x0009;
    } else if (mode == VPROC_RST_AEC) { /*AEC method*/
        addr = 0x0300;
        data = 0x0001;
    } else if (mode == VPROC_RST_SOFTWARE) { /*soft reset*/
        addr = 0x0006;
        data = 0x0002;
    } else if (mode == VPROC_RST_BOOT) { /*reset to bootrom mode*/
        data = 0x0001;
    } else {
        return VPROC_STATUS_INVALID_ARG;
    }
    if (zl380tw_hbi_mwords_wr(addr, &data, 1) < 0)
        return VPROC_STATUS_INVALID_ARG;

    delayms(50); /*wait for the HBI to settle*/
    return VPROC_STATUS_SUCCESS;
}


/*zl380tw_init - to load a converted *s3, *cr2 to c code into the device.
* Basically instead of loading the *.s3, *cr2 directly,
* use the tw_convert tool to convert the ascii hex fwr mage into code and compile
* with the application
*
* input arg: mode:  0 - load both firmware and config 
*                   1 - load firmware only
*                   2 - load config only
*/
int zl380tw_init() {
  int status= VPROC_STATUS_SUCCESS;
  twFirmware st_Firmware;
  // Access from flash, not from block RAM.
  st_Firmware.st_Fwr = (twFwr *) st_twFirmware;
  st_Firmware.twFirmwareStreamLen = (uint16_t)firmwareStreamLen;
  st_Firmware.execAddr  = (uint32_t)executionAddress;
  st_Firmware.havePrgmBase = (uint8_t)haveProgramBaseAddress;
  st_Firmware.prgmBase = (uint32_t)programBaseAddress;

  // Load firmware.
  status  = zl380tw_HbiBoot_alt(&st_Firmware);
  status  = zl380tw_FirmwareStart();
  // Load config.
  status  = zl380tw_LoadConfig((dataArr *)st_twConfig, (uint16_t)configStreamLen);
  /*Firmware reset - in order for the configuration to take effect*/
  status  = zl380tw_reset(VPROC_RST_SOFTWARE);
  printf("Init Status: %0x\r\n", status);
  return status;
}

/*To configure the Twolf HBI interface
 * Param[in] - cmd_config  : the 16-bit HBI init command ored with the
 *                           8-bit configuration.
 *              The command format is cmd_config = 0xFD00 | CONFIG_VAL
 *              CONFIG_VAL: is you desired HBI config value
 *              (see device datasheet)
 */
static int zl380tw_hbi_cfg(uint16_t cmd_config) {
	return zl380tw_hbi_mwords_wr(HBI_CONFIGURE(cmd_config), 0, 1);
}

/*zl380tw_suspend() - Places the ZL38051 in low power sleep mode. 
 * The ZL380TW will respond to no
 * other inputs until it awakens from Sleep Mode
 */
int zl380tw_suspend()
{
	uint16_t buf = ZL380TW_CMD_APP_SLEEP;
	return zl380tw_cmdRegWr(buf);
}

/*zl380tw_resume() - Wake the ZL380TW device from Sleep mode*/
int zl380tw_resume()
{
	/*wake up from sleep*/
	if (zl380tw_hbi_cfg((HBI_CONFIG_VAL | HBI_CONFIG_WAKE)) < 0)
	    return VPROC_STATUS_ERR_HBI;
	    
    delayms(10);
	/*Clear the wake up bit*/
    return zl380tw_hbi_cfg(HBI_CONFIG_VAL); 
}

/* configure_codec() - configure the cross-point to either pure 2-channel stereo
 * or for 4-port mode with Achoustic Echo Canceller
 * mode: 
 *       0 -> 4-port mode AEC
 *       1 -> Stereo bypass
 *       2 -> ADDA loopback mode
 */
int zl380tw_configure_codec(uint8_t mode) {
    uint16_t *pData;
    int status= VPROC_STATUS_SUCCESS;
    switch (mode) {
        case ZL380TW_SINGLE_CHANNEL_AEC:
          pData = reg_aec;
          break;
        case ZL380TW_STEREO_BYPASS:
          pData = reg_stereo;
          break;
        case ZL380TW_ADDA_LOOPBACK:
          pData = reg_loopback;
          break;
        default: 
          pData = reg_stereo;
          break;
    }
    if (zl380tw_hbi_mwords_wr(ZL380TW_OUTPUT_PATH_EN_REG, pData, 19) != VPROC_STATUS_SUCCESS)
        return -1;

    status  = zl380tw_reset(VPROC_RST_SOFTWARE);
    if (status != VPROC_STATUS_SUCCESS) {
        return status;
    }
    printf("Codec set succesfully\r\n");
    return 0;
}



