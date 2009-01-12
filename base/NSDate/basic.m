#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSDate.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  id testObj = [NSDate new];
  
  test_NSObject(@"NSDate",[NSArray arrayWithObject:[NSDate new]]);
  test_NSCoding([NSArray arrayWithObject:testObj]);
  test_NSCopying(@"NSDate",@"NSDate",[NSArray arrayWithObject:testObj],NO,NO);
   
  IF_NO_GC(DESTROY(arp));
  return 0;
}
