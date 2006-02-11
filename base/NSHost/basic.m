#include "ObjectTesting.h"
#include <Foundation/NSArray.h>
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSHost.h>
#include <Foundation/NSString.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  test_NSObject(@"NSHost",[NSArray arrayWithObject:[NSHost currentHost]]); 
  DESTROY(arp);
  return 0;
}
