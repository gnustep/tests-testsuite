#import "Testing.h"
#import "ObjectTesting.h"
#import <Foundation/NSCalendar.h>
#import <Foundation/NSAutoreleasePool.h>

int main()
{  
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  id testObj = [NSLocale new];

  test_NSObject(@"NSCalendar", [NSArray arrayWithObject: testObj]);
  test_NSCoding([NSArray arrayWithObject: testObj]);
  test_NSCopying(@"NSCalendar", @"NSCalendar",
    [NSArray arrayWithObject: testObj], NO, NO);
  
  RELEASE(arp);
  return 0;
}
