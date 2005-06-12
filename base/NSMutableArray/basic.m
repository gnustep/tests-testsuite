#include "ObjectTesting.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSArray.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSArray *testObj = [NSMutableArray arrayWithCapacity:1];
  test_alloc(@"NSMutableArray");
  test_NSObject(@"NSMutableArray", [NSArray arrayWithObject:testObj]); 
  test_NSCoding([NSArray arrayWithObject:testObj]); 
  test_NSCopying(@"NSArray",@"NSMutableArray", 
                 [NSArray arrayWithObject:testObj], NO, NO); 
  test_NSMutableCopying(@"NSArray",@"NSMutableArray", 
                 [NSArray arrayWithObject:testObj]); 
  DESTROY(arp);
  return 0;
}
