#include <Foundation/NSPortMessage.h>
#include "ObjectTesting.h"

@class NSAutoreleasePool;
int main()
{
  NSAutoreleasePool *arp = [NSAutoreleasePool new];

  pass (1, "include of Foundation/NSPortMessage.h works");
  [arp release];
  return 0;
}