#include "orca_time.h"

void delayms(int ms) {
  unsigned start = get_time();
  ms*=(SYS_CLK/1000);
  while(get_time()-start < ms);
}

void delayus(int us) {
  unsigned start = get_time();
  us*=(SYS_CLK/1000000);
  while(get_time()-start < us);
}
