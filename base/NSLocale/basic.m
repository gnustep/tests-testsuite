#import "Testing.h"
#import "ObjectTesting.h"
#import <Foundation/NSLocale.h>
#import <Foundation/NSAutoreleasePool.h>

int main()
{  
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  id testObj = [NSLocale new];

  test_NSObject(@"NSLocale", [NSArray arrayWithObject: testObj]);
  test_NSCoding([NSArray arrayWithObject: testObj]);
  test_NSCopying(@"NSLocale", @"NSLocale",
    [NSArray arrayWithObject: testObj], NO, NO);
  
  RELEASE(arp);
  return 0;
}
