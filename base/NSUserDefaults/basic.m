#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSUserDefaults.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSArray *testObj = [NSUserDefaults new];

  test_NSObject(@"NSUserDefaults", [NSArray arrayWithObject:testObj]); 

  IF_NO_GC(DESTROY(arp));
  return 0;
}
