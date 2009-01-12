#import "ObjectTesting.h"
#import <Foundation/NSData.h>
#import <Foundation/NSAutoreleasePool.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  id testObject = [NSData new];
  test_alloc(@"NSData");
  test_NSObject(@"NSData",[NSArray arrayWithObject:testObject]);
  test_NSCoding([NSArray arrayWithObject:testObject]);
  test_NSCopying(@"NSData",
                 @"NSMutableData",
		 [NSArray arrayWithObject:testObject], NO, NO);
  test_NSMutableCopying(@"NSData",
                        @"NSMutableData",
		        [NSArray arrayWithObject:testObject]);

  IF_NO_GC(DESTROY(arp));
  return 0;
}

