#include "Testing.h"
#include "ObjectTesting.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSConnection.h>


int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  id testObject = nil;
  test_alloc(@"NSConnection");
  testObject = [NSConnection new];
  test_NSObject(@"NSConnection",[NSArray arrayWithObject:testObject]); 
  testObject = [NSConnection defaultConnection];
  pass(testObject != nil && [testObject isKindOfClass:[NSConnection class]],
       "NSConnection +defaultConnection works");
  
  DESTROY(arp);
  return 0;
}
