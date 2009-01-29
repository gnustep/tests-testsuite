#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSObject.h>
int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  test_alloc(@"NSObject");
  test_NSObject(@"NSObject", [NSArray arrayWithObject:[[NSObject new] autorelease]]);
  [arp release]; arp = nil;
  return 0;
}
