#include "ObjectTesting.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSProcessInfo.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSProcessInfo *pi;
  test_alloc(@"NSProcessInfo");
  pi = [NSProcessInfo processInfo];
  test_NSObject(@"NSProcessInfo", [NSArray arrayWithObject:pi]);
  DESTROY(arp);
  return 0;
}
