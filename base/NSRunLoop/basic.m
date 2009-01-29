#import "ObjectTesting.h"
#import <Foundation/NSRunLoop.h>
#import <Foundation/NSAutoreleasePool.h>

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  id testObj = [NSRunLoop new];
  
  test_alloc(@"NSRunLoop");
  test_NSObject(@"NSRunLoop", [NSArray arrayWithObject:testObj]);
  
  test_alloc(@"NSTimer");
  ASSIGN(testObj, [NSTimer new]);
  test_NSObject(@"NSTimer", [NSArray arrayWithObject:testObj]);
  
  [arp release]; arp = nil;
  return 0;
}
