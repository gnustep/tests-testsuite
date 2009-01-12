#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSInvocation.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSMethodSignature *testSig = [NSMethodSignature signatureWithObjCTypes:"@@::"];
  NSInvocation *testObj = [NSInvocation invocationWithMethodSignature:testSig];
  test_alloc(@"NSInvocation");
  test_NSObject(@"NSInvocation", [NSArray arrayWithObject:testObj]);
  IF_NO_GC(DESTROY(arp));
  return 0;
}
