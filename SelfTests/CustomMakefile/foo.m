#ifndef TEST_PARAM
#error You need to define TEST_PARAM for this to compile
#endif

extern int bar_main(void);

int main()
{
  printf("Say foo!\n");
  bar_main();
  return 0;
}
