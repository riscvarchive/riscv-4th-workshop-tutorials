#ifndef __MAIN_H
#define __MAIN_H

#include <stdint.h>

int mxp_test();

#define SYS_CLK 12500000
static inline uint32_t get_time() {
  int tmp;
  asm volatile("csrr %0,time":"=r"(tmp));
  return tmp;
}

#endif //__MAIN_H
