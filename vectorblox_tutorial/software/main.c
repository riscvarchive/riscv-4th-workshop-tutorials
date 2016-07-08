#include "printf.h"
#include "spi.h"
#include "flash.h"
#include "arrow_zl380tw.h"
#include "arrow_zl380tw_firmware.h"
#include "arrow_zl380tw_config.h"
#include "vbx.h"
#include "main.h"

#define SIMULATION 0
#define IRAM_TEST 1
#define SPAD_TEST 1
#define SPI_TEST 1
#define I2S_TEST 1
#define FLASH_TEST 1
#define UART_TEST 1
#define MXP_TEST 1


//////////////////////
//
// UART stuff
//////////////////////
#define UART_BASE  ((volatile int*) (0x30000000))
#define UART_DATA UART_BASE
#define UART_LSR   ((volatile int*) (0x30000010))

//#define UART_INIT() do{*UART_LCR = UART_LCR_8BIT_DEFAULT;}while(0)
#define UART_PUTC(c) do{*UART_DATA = (c);}while(0)
#define UART_BUSY() (!((*UART_LSR) & 0x01))
void mputc (void* p, char c)
{
  delayms(1);
	while(UART_BUSY());
	*UART_DATA = c;
}

#define I2S           ((volatile int*) (0x50000000))
#define I2S_VERSION   ((volatile int*) (0x50000000))
#define I2S_CLOCK_DIV ((volatile int*) (0x50000004))
#define I2S_DATA      ((volatile int*) (0x50000008))
#define SPEAKER           ((volatile int*) (0x70000000))
#define SPEAKER_VERSION   ((volatile int*) (0x70000000))
#define SPEAKER_CLOCK_DIV ((volatile int*) (0x70000004))
#define SPEAKER_DATA      ((volatile int*) (0x70000008))

#define SAMPLE_RATE 8000

void init_audio()
{
  uint16_t read_data[1];
  uint16_t write_data[1];

  // Chip takes 3 ms to boot after reset.
  delayms(3);
  // Initialize the chip with firmware and config.

  zl380tw_init();
  zl380tw_configure_codec(ZL380TW_STEREO_BYPASS);
  zl380tw_hbi_mwords_rd(0x2B0, read_data, 1);

  write_data[0] = 0x0003;
  zl380tw_hbi_mwords_wr(0x2B0, write_data, 1);

  zl380tw_reset(VPROC_RST_SOFTWARE);
  zl380tw_hbi_mwords_rd(0x2B0, read_data, 1);


  zl380tw_hbi_mwords_rd(ZL380TW_PRODUCT_CODE_REG, read_data, 1);
  printf("PRODUCT CODE: %0x\r\n", read_data[0]);

}

int sound_filter_test(void);

int main(void)
{

  VectorBlox_MXP_Initialize();

  // Test DPRAM and printf
  init_printf(0, mputc);

  printf("Hello World\r\n");

  init_audio();



  int seconds=30;
  printf("Microphone Direct to Speaker %ds\r\n", seconds);
  int i=0;
  int leds=0;
  while(seconds--){
	 asm("csrw mtohost,%0"::"r"(leds));
	 leds=~leds;
	 i=0;
	 printf("Hello World\r\n");
	 while(++i<SAMPLE_RATE) {
		*SPEAKER_DATA = *I2S_DATA;
	 }
  }
  printf("running filter\r\n");
  sound_filter_test();
  return 1;
}


int handle_trap(long cause,long epc, long regs[32])
{
	//spin forever
	for(;;);
}
