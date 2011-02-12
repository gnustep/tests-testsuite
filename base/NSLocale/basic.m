#import "Testing.h"
#import "ObjectTesting.h"
#import <Foundation/NSLocale.h>
#import <Foundation/NSAutoreleasePool.h>

int main()
{  
  START_SET(GS_USE_ICU)
  id testObj = [NSLocale currentLocale];

  test_NSObject(@"NSLocale", [NSArray arrayWithObject: testObj]);
  test_keyed_NSCoding([NSArray arrayWithObject: testObj]);
  test_NSCopying(@"NSLocale", @"NSLocale",
    [NSArray arrayWithObject: testObj], NO, NO);
  
  END_SET("NSLocale basic")
  return 0;
}
