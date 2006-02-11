#include "Testing.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSString.h>
#include <Foundation/NSData.h>
#include <Foundation/NSPropertyList.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSString *bstr = @"\"Hello---@?pP-l\\U00a6&\\U00e4\\U00a6\"";
  NSData   *adat;
  NSString *cstr;

  /* Prepare UTF-8 string from plist style c-string.  */
  bstr = [bstr propertyList];
  adat = [bstr dataUsingEncoding: NSUTF8StringEncoding];

  pass((adat != nil && [adat isKindOfClass: [NSData class]]),
	 "We can convert from UTF8 Encoding");

  cstr = [[NSString alloc] initWithData: adat encoding: NSUTF8StringEncoding];
  pass((cstr != nil && [cstr isKindOfClass: [NSString class]]),
       "We can convert to UTF8 Encoding");

  DESTROY(arp);
  return 0;
}

