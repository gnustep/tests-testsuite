#include "ObjectTesting.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSCharacterSet.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  id testObj = [NSMutableCharacterSet new];
  test_alloc(@"NSMutableCharacterSet");
  test_NSObject(@"NSMutableCharacterSet",[NSArray arrayWithObject:testObj]);
  test_NSCoding([NSArray arrayWithObject:testObj]);
  test_NSCopying(@"NSCharacterSet", @"NSMutableCharacterSet",
                 [NSArray arrayWithObject:testObj], NO, NO);
  test_NSMutableCopying(@"NSCharacterSet", @"NSMutableCharacterSet", 
                        [NSArray arrayWithObject:testObj]);
  DESTROY(arp);
  return 0;
}

