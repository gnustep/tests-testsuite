#include "ObjectTesting.h"
#include <Foundation/NSBundle.h>
#include <Foundation/NSAutoreleasePool.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
   
  test_alloc(@"NSBundle");
  test_NSObject(@"NSBundle", [NSArray arrayWithObject:[NSBundle new]]); 
  DESTROY(arp);
  return 0;
}
