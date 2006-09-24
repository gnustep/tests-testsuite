#ifndef TEST_PARAM
#error You need to define TEST_PARAM for this to compile
#endif

#include "Testing.h"

extern int bar_main(void);

int main()
{
  printf("Say foo!\n");
  pass(bar_main() == 1, "Got return from other module");

  return 0;
}
