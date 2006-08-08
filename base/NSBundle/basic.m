#import "ObjectTesting.h"
#import <Foundation/NSBundle.h>
#import <Foundation/NSAutoreleasePool.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
   
  test_alloc(@"NSBundle");
  test_NSObject(@"NSBundle", [NSArray arrayWithObject:[NSBundle new]]); 
  DESTROY(arp);
  return 0;
}
