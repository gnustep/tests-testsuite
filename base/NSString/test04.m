#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSString.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSString *theString;
  unichar theUniChar[1] = {0xdd00};
  theString = [NSString stringWithCharacters:theUniChar length:1];
  NS_DURING
    pass(theString == nil, "bad unichar");
  NS_HANDLER
    pass(1,"bar");
  NS_ENDHANDLER
  
  IF_NO_GC(DESTROY(arp));
  return 0;
}
