#include <GNUstepBase/GSXML.h>
#include "ObjectTesting.h"

@class NSAutoreleasePool;
int main()
{
  NSAutoreleasePool *arp = [NSAutoreleasePool new];

  pass (1, "include of GNUstepBase/GSXML.h works");
  [arp release];
  return 0;
}
