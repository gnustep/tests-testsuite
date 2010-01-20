#include	<Foundation/Foundation.h>

int
main(int argc, char **argv)
{
  int	i = 0;
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];

#if	!defined(__MINGW32__)
/*
  printf("argc %d\n", argc);
  for (i = 0; i < argc; i++)
    printf("argv[%d] %s\n", i, argv[i]);
  printf("pgrp %d\n", getpgrp());
*/
  if (atoi(argv[1]) == getpgrp())
    i = 1;
#endif  /* __MINGW32__ */

  [arp release];
  return i;
}

