#include "Testing.h"
#include <Foundation/NSArray.h>
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSProcessInfo.h>
#include <Foundation/NSString.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSProcessInfo *info = [NSProcessInfo processInfo];
  id obj;
  unsigned int val;
  pass(info != nil, "NSProcessInfo understands [+processInfo]");
  
  obj = [info arguments];
  pass((info != nil && 
       [obj isKindOfClass:[NSArray class]] &&
       [obj count] != 0),
       "NSProcessInfo has arguments");
  
  obj = [info environment];
  pass((obj != nil &&
       [obj isKindOfClass:[NSDictionary class]]), 
       "NSProcessInfo has environment");
  
  obj = [info processName]; 
  pass((obj != nil &&
       [obj isKindOfClass:[NSString class]] &&
       [obj length] > 0),
       "-processName is non-nil");

  obj = [info globallyUniqueString];
  pass((obj != nil &&
       [obj isKindOfClass:[NSString class]] &&
       [obj length] > 0),
       "-globallyUniqueString works");

  obj = [info operatingSystemName];
  pass((obj != nil &&
       [obj isKindOfClass:[NSString class]] &&
       [obj length] > 0),
       "-operatingSystemName works");
  val = [info operatingSystem];
  pass(val != 0, "-operatingSystem works"); 
  DESTROY(arp);
  return 0;
}
