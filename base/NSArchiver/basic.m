#import <Foundation/Foundation.h>
#import "ObjectTesting.h"
int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  test_alloc(@"NSArchiver");
  test_NSObject(@"NSArchiver",[NSArray arrayWithObject:[[NSArchiver alloc] init]]);
  test_alloc(@"NSUnarchiver");  
  test_NSObject(@"NSUnarchiver",[NSArray arrayWithObject:[[NSUnarchiver alloc] init]]);
  
  DESTROY(arp);
  return 0;
}
