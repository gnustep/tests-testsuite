#include "Testing.h"
#include "ObjectTesting.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSCharacterSet.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  id testObj = [NSCharacterSet alphanumericCharacterSet];
  test_alloc(@"NSCharacterSet"); 
  test_NSObject(@"NSCharacterSet", [NSArray arrayWithObject:testObj]); 
  test_NSCoding([NSArray arrayWithObject:testObj]);
  test_NSCopying(@"NSCharacterSet", @"NSMutableCharacterSet", [NSArray arrayWithObject:testObj], NO, NO);
  test_NSMutableCopying(@"NSCharacterSet",@"NSMutableCharacterSet", [NSArray arrayWithObject:testObj]);

  
  DESTROY(arp);
  return 0;
}
