#include "ObjectTesting.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSInvocation.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSMethodSignature *testSig = [NSMethodSignature signatureWithObjCTypes:"@@::"];
  NSInvocation *testObj = [NSInvocation invocationWithMethodSignature:testSig];
  test_alloc(@"NSInvocation");
  test_NSObject(@"NSInvocation", [NSArray arrayWithObject:testObj]);
  DESTROY(arp);
  return 0;
}
