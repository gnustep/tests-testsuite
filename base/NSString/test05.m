#include "ObjectTesting.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSString.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSString *theString;
  unichar theUniChar[1] = {0xe5};
  theString = [NSString stringWithCharacters:theUniChar length:1];
  NS_DURING
    pass([theString isEqual:[[NSString alloc] initWithCString: [theString cString]]],"foo");
  NS_HANDLER
    pass(1,"bar");
  NS_ENDHANDLER
  
  NS_DURING
    pass([theString isEqual:[[NSMutableString alloc] initWithCString: [theString cString]]],"foo2");
  NS_HANDLER
    pass(1,"bar2");
  NS_ENDHANDLER
  
  DESTROY(arp);
  return 0;
}
