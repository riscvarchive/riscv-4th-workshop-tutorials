#ifndef __MAIN_H
#define __MAIN_H

#include <stdint.h>

int mxp_test();

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

#endif //__MAIN_H
