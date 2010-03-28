#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSValue.h>

int main()
{
  NSAutoreleasePool     *arp = [NSAutoreleasePool new];
  NSMutableArray        *ma;
  NSNumber              *testObj;

  test_alloc_only(@"NSNumber");
  testObj = [NSNumber numberWithInt: 5];
  test_NSObject(@"NSNumber", [NSArray arrayWithObject:testObj]);
  test_NSCoding([NSArray arrayWithObject:testObj]);
  ma = [NSMutableArray new];
  [ma addObject: [NSNumber numberWithShort: -10]];
  [ma addObject: [NSNumber numberWithInt: -1]];
  [ma addObject: [NSNumber numberWithInt: 0]];
  [ma addObject: [NSNumber numberWithLong: 10]];
  [ma addObject: [NSNumber numberWithLongLong: 12]];
  test_NSCopying(@"NSNumber", @"NSNumber", ma, YES, NO);
  [ma removeAllObjects];
  [ma addObject: [NSNumber numberWithShort: -13]];
  [ma addObject: [NSNumber numberWithInt: 13]];
  [ma addObject: [NSNumber numberWithInt: 0x7fffffff]];
  test_NSCopying(@"NSNumber", @"NSNumber", ma, NO, YES);

  [arp release]; arp = nil;
  return 0;
}
