#include "printf.h"
#include "spi.h"
#include "flash.h"

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


int main(void)
{
  int i=0;
  // Test DPRAM and printf
  init_printf(0, mputc);
  printf("Test\r\n");
  for(;;){
	 printf("Hello World %d\r\n",i++);
	 delayms(200);
  }


  return 1;
}


int handle_trap(long cause,long epc, long regs[32])
{
	//spin forever
	for(;;);
}
