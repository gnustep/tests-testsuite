#include <Foundation/Foundation.h>
#include "ObjectTesting.h"
int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  test_alloc(@"NSKeyedArchiver");
  test_NSObject(@"NSKeyedArchiver",[NSArray arrayWithObject:[[NSKeyedArchiver alloc] init]]);
  test_alloc(@"NSKeyedUnarchiver");  
  test_NSObject(@"NSKeyedUnarchiver",[NSArray arrayWithObject:[[NSKeyedUnarchiver alloc] init]]);
  
  DESTROY(arp);
  return 0;
}
