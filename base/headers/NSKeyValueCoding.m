#include <Foundation/NSKeyValueCoding.h>
#include "ObjectTesting.h"

@class NSAutoreleasePool;
int main()
{
  NSAutoreleasePool *arp = [NSAutoreleasePool new];

  pass (1, "include of Foundation/NSKeyValueCoding.h works");
  [arp release];
  return 0;
}
