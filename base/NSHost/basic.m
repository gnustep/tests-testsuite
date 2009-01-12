#import "ObjectTesting.h"
#import <Foundation/NSArray.h>
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSHost.h>
#import <Foundation/NSString.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  test_NSObject(@"NSHost",[NSArray arrayWithObject:[NSHost currentHost]]); 
  IF_NO_GC(DESTROY(arp));
  return 0;
}
