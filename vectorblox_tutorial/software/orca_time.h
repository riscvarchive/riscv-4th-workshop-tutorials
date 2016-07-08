#ifndef ORCA_TIME_H
#define ORCA_TIME_H
#include <stdint.h>

#define SYS_CLK 12500000

inline uint32_t get_time();

inline uint32_t get_time() {
  int tmp;
  asm volatile("csrr %0,time":"=r"(tmp));
  return tmp;
}

void delayms(int ms);
void delayus(int us);

#endif
