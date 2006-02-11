#include "Testing.h"
#include "ObjectTesting.h"
#include <Foundation/NSAutoreleasePool.h>

int main()
{  
  CREATE_AUTORELEASE_POOL(arp);
  id testObj = [NSCalendarDate new];
  test_NSObject(@"NSCalendarDate",[NSArray arrayWithObject:testObj]);
  test_NSCoding([NSArray arrayWithObject:testObj]);
  test_NSCopying(@"NSCalendarDate",@"NSCalendarDate",[NSArray arrayWithObject:testObj],NO,NO);
  
  
  DESTROY(arp);
  return 0;
}
