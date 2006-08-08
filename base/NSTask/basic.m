#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSTask.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSArray *testObj = [NSTask new];

  test_NSObject(@"NSTask", [NSArray arrayWithObject:testObj]); 

  DESTROY(arp);
  return 0;
}
