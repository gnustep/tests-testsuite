#import "ObjectTesting.h"
#import <Foundation/NSHost.h>
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSString.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSHost *current = [NSHost currentHost];
  NSHost *localh = [NSHost localHost];
  NSHost *tmp; 
  pass(current != nil && [current isKindOfClass:[NSHost class]],
       "NSHost understands +currentHost");
 
  pass(localh != nil && [localh isKindOfClass:[NSHost class]],
       "NSHost understands +localHost");
  
  tmp = [NSHost hostWithName:[current name]];
  pass([tmp isEqualToHost:current], "NSHost understands +hostWithName:");
  
  tmp = [NSHost hostWithAddress:[current address]];
  pass([tmp isEqualToHost:current], "NSHost understands +hostWithAddress:");
  
  tmp = [NSHost hostWithName:@"127.0.0.1"];
  pass(tmp != nil && [tmp isEqualToHost:localh], 
       "NSHost understands [+hostWithName: 127.0.0.1]");
  
  DESTROY(arp);
  return 0;
}
