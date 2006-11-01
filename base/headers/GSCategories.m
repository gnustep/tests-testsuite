#include <GNUstepBase/GSCategories.h>
#include "ObjectTesting.h"

@class NSAutoreleasePool;
int main()
{
  NSAutoreleasePool *arp = [NSAutoreleasePool new];

  pass (1, "include of GNUstepBase/GSCategories.h works");
  [arp release];
  return 0;
}
