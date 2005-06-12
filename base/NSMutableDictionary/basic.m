#include "ObjectTesting.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSDictionary.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSMutableDictionary *testObj;
  
  testObj = [NSMutableDictionary new];
  
  test_NSObject(@"NSMutableDictionary", [NSArray arrayWithObject:testObj]);
  
  test_NSCoding([NSArray arrayWithObject:testObj]);
  
  test_NSCopying(@"NSDictionary",@"NSMutableDictionary", 
                 [NSArray arrayWithObject:testObj], NO, NO);
  
  test_NSMutableCopying(@"NSDictionary",@"NSMutableDictionary", 
                        [NSArray arrayWithObject:testObj]);
  DESTROY(arp);
  return 0;
}
