#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSValue.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSNumber *testObj;
  test_alloc(@"NSNumber");
  testObj = [NSNumber new];
  test_NSObject(@"NSNumber", [NSArray arrayWithObject:testObj]);
  test_NSCoding([NSArray arrayWithObject:testObj]);
  test_NSCopying(@"NSNumber", @"NSNumber", 
  		 [NSArray arrayWithObject:testObj],YES,NO);
  DESTROY(arp);
  return 0;
}
