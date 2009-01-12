#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSProcessInfo.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSProcessInfo *pi;
  test_alloc(@"NSProcessInfo");
  pi = [NSProcessInfo processInfo];
  test_NSObject(@"NSProcessInfo", [NSArray arrayWithObject:pi]);
  IF_NO_GC(DESTROY(arp));
  return 0;
}
