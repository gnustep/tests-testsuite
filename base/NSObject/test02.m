#include "Testing.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSObject.h>
/* Nicola Pero, Tue Dec 18 17:54:53 GMT 2001 */
@protocol DoingNothing
- (void) doNothing;
@end

@protocol DoingNothingCategory
- (void) doNothingCategory;
@end


@interface NicolaTest : NSObject <DoingNothing>
{
}
@end

@implementation NicolaTest
- (void) doNothing
{
  return;
}
@end

@interface NicolaTest (Category) <DoingNothingCategory>
@end

@implementation NicolaTest (Category)
- (void) doNothingCategory
{
  return;
}
@end


int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  pass([NicolaTest conformsToProtocol:@protocol(DoingNothing)],
       "+conformsToProtocol returns YES on an implemented protocol");
  pass([NicolaTest conformsToProtocol:@protocol(DoingNothingCategory)],
       "+conformsToProtocol returns YES on a protocol implemented in a category");
  pass(![NicolaTest conformsToProtocol:@protocol(NSCoding)],
       "+conformsToProtocol returns NO on an unimplemented protocol");
  pass([[NicolaTest new] conformsToProtocol:@protocol(DoingNothing)],
       "-conformsToProtocol returns YES on an implemented protocol");
  pass([[NicolaTest new] conformsToProtocol:@protocol(DoingNothingCategory)],
       "-conformsToProtocol returns YES on a protocol implemented in a category"); 
  pass(![[NicolaTest new] conformsToProtocol:@protocol(NSCoding)],
       "-conformsToProtocol returns NO on an unimplemented protocol");

  DESTROY(arp);
  return 0;
}
