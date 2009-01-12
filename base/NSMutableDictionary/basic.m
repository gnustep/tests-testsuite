#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSDictionary.h>

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
  IF_NO_GC(DESTROY(arp));
  return 0;
}
