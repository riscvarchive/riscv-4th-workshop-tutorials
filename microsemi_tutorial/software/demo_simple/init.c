#include <stdlib.h>
#include <stddef.h>
#include <stdint.h>
#include <unistd.h>

#include "encoding.h"
#include "shared.h"

#ifdef USE_PLIC
extern void handle_m_ext_interrupt();
#endif

uintptr_t handle_trap(uintptr_t mcause, uintptr_t epc)
{
  if (0){
#ifdef USE_PLIC
  // External Machine-Level Interrupt from PLIC
 }else if ((mcause & MCAUSE_INT) && ((mcause & MCAUSE_CAUSE)  == IRQ_M_EXT)) {
    handle_m_ext_interrupt();
#endif
  }    
  else{
    write(1, "trap\n", 5);
    _exit(1 + mcause);
  }
  return epc;
}

void _init(void)
{
  UART_init( &g_uart, COREUARTAPB0_BASE_ADDR, BAUD_VALUE_115200, (DATA_8_BITS | NO_PARITY) );
  
  extern int main(int, char**);
  const char *argv0 = "hello";
  char *argv[] = {(char *)argv0, NULL, NULL};

  exit(main(1, argv));
}
