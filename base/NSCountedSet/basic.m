#include "ObjectTesting.h"
#include <Foundation/NSSet.h>
#include <Foundation/NSAutoreleasePool.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  id testObject = [NSCountedSet new];
  test_alloc(@"NSCountedSet");
  test_NSObject(@"NSCountedSet",[NSArray arrayWithObject:testObject]);
  test_NSCoding([NSArray arrayWithObject:testObject]);
  test_NSCopying(@"NSCountedSet",
                 @"NSCountedSet",
		 [NSArray arrayWithObject:testObject], NO, YES);
  test_NSMutableCopying(@"NSCountedSet",
                        @"NSCountedSet",
		        [NSArray arrayWithObject:testObject]);

  DESTROY(arp);
  return 0;
}

