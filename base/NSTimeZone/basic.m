#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSTimeZone.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSArray *testObj = [NSTimeZone defaultTimeZone];

  test_NSObject(@"NSTimeZone", [NSArray arrayWithObject:testObj]); 

  IF_NO_GC(DESTROY(arp));
  return 0;
}
