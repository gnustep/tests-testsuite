#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSObject.h>
int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  test_alloc(@"NSObject");
  test_NSObject(@"NSObject", [NSArray arrayWithObject:[[NSObject new] autorelease]]);
  IF_NO_GC(DESTROY(arp));
  return 0;
}
