#include "printf.h"
#include "spi.h"
#include "flash.h"

#define IRAM_TEST 1
#define SPAD_TEST 1
#define SPI_TEST 1
#define I2S_TEST 1
#define FLASH_TEST 1
#define UART_TEST 1

static int array[8] = {'0', '1', '2', '3', '4', '5', '6', '7'};

#define SYS_CLK 12500000
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

#define DRAM1 ((volatile int*) (0x10000100))
#define DRAM2 ((volatile int*) (0x10000200))
#define I2S           ((volatile int*) (0x50000000))
#define I2S_VERSION   ((volatile int*) (0x50000000))
#define I2S_CLOCK_DIV ((volatile int*) (0x50000004))
#define I2S_DATA      ((volatile int*) (0x50000008))

int main(void)
{
  volatile register uint32_t test asm ("a5");
  volatile int *address1 = DRAM1;
  volatile int *address2 = DRAM2;
  volatile int i2s_read;
  volatile int *flash_data;
  volatile int temp; 
  int i;

  // Test DPRAM and printf
  init_printf(0, mputc);
  printf("Test\r\n");

#if FLASH_TEST
// Test Flash Memory
  flash_data = FLASH_ENDRAM - 50;
  for(i = 0; i < 100; i++) {
    asm volatile("mv %0,sp" :"=r"(temp) :); 
    printf("sp : %0x ", temp);
    printf("%0x : ", (int)flash_data);
    temp = *(flash_data++);
    printf("%0x", temp);
    printf("\r\n");
  }
#endif

// Test SPI
#if SPI_TEST
  *SPI_CONTROL1 = 0x03;
  *SPI_SSEL = 0x01;
  *SPI_TXDATA = 0xCD;
  *SPI_TXDATALAST = 0xAB;
  while(!((*SPI_INTRAW) & TX_DONE_MASK));
  *SPI_INTCLR |= TX_DONE_INT_MASK;
  *SPI_SSEL = 0x00;

  *SPI_CONTROL1 = 0x03;
  *SPI_SSEL = 0x01;
  *SPI_TXDATA = 0x34;
  *SPI_TXDATALAST = 0x12;
  while(!((*SPI_INTRAW) & TX_DONE_MASK));
  *SPI_INTCLR |= TX_DONE_INT_MASK;
  *SPI_SSEL = 0x00;
#endif

#if I2S_TEST
// Test I2S
  i2s_read = *I2S_DATA; 
  i2s_read = *I2S_DATA; 
#endif

#if IRAM_TEST 
// Test IRAM reads
  for (i = 0; i < 8; i++) {
    UART_PUTC((char)array[i]);
  }
  UART_PUTC('\r');
  UART_PUTC('\n');
  delayms(1000);
#endif

#if UART_TEST
// Test UART
  char c;
  for (c = 'A'; c <= 'z'; c++) {
    UART_PUTC(c);
    delayms(100);
  }
#endif

#if SPAD_TEST
// Test data mem and LEDs 
  *address1 = 'A';
  *address2 = 'B';

  address1 = DRAM1;
  while(1) {
    *address1+=1;
    *address2+=1;
    test = *address1;
    asm volatile("csrw mtohost,%0"
      :
      :"r" (test));
    UART_PUTC((char)(*address1));
    delayms(1000);
    
    test = *address2;
    asm volatile("csrw mtohost,%0"
      :
      :"r" (test));
    UART_PUTC((char)(*address2));
    delayms(1000);
  }
#endif

  return 1;
}


int handle_trap(long cause,long epc, long regs[32])
{
	//spin forever
	for(;;);
}
