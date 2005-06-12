#include "ObjectTesting.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSUserDefaults.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSArray *testObj = [NSUserDefaults new];

  test_NSObject(@"NSUserDefaults", [NSArray arrayWithObject:testObj]); 

  DESTROY(arp);
  return 0;
}
