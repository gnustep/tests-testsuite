#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSObject.h>
int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  test_alloc(@"NSObject");
  test_NSObject(@"NSObject", [NSArray arrayWithObject:[[NSObject new] autorelease]]);
  DESTROY(arp);
  return 0;
}
