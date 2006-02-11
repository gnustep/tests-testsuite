#include "ObjectTesting.h"
#include <Foundation/NSRunLoop.h>
#include <Foundation/NSAutoreleasePool.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  id testObj = [NSRunLoop new];
  
  test_alloc(@"NSRunLoop");
  test_NSObject(@"NSRunLoop", [NSArray arrayWithObject:testObj]);
  
  test_alloc(@"NSTimer");
  ASSIGN(testObj, [NSTimer new]);
  test_NSObject(@"NSTimer", [NSArray arrayWithObject:testObj]);
  
  DESTROY(arp);
  return 0;
}
