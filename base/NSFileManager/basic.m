#include "ObjectTesting.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSFileManager.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  test_NSObject(@"NSFileManager", 
                [NSArray arrayWithObject:[NSFileManager defaultManager]]);
  DESTROY(arp);
  return 0;
}
