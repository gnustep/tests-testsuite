#import "ObjectTesting.h"
#import <Foundation/NSHost.h>
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSString.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSHost *current;
  NSHost *localh;
  NSHost *tmp; 

  current = [NSHost currentHost];
  pass(current != nil && [current isKindOfClass:[NSHost class]],
       "NSHost understands +currentHost");
 
#if	defined(GNUSTEP_BASE_LIBRARY)
  localh = [NSHost localHost];
  pass(localh != nil && [localh isKindOfClass:[NSHost class]],
       "NSHost understands +localHost");
#else
  localh = current;
#endif

  tmp = [NSHost hostWithName:[current name]];
  pass([tmp isEqualToHost:current], "NSHost understands +hostWithName:");
  
  tmp = [NSHost hostWithAddress:[current address]];
  pass([tmp isEqualToHost:current], "NSHost understands +hostWithAddress:");
  
  tmp = [NSHost hostWithName:@"127.0.0.1"];
  pass(tmp != nil && [tmp isEqualToHost:localh], 
       "NSHost understands [+hostWithName: 127.0.0.1]");
  
  IF_NO_GC(DESTROY(arp));
  return 0;
}
