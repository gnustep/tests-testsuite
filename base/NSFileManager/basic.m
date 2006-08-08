#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSFileManager.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  test_NSObject(@"NSFileManager", 
                [NSArray arrayWithObject:[NSFileManager defaultManager]]);
  DESTROY(arp);
  return 0;
}
