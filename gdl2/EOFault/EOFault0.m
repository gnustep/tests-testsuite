#include <Foundation/NSString.h>
#include <EOControl/EOFault.h>
#include <Foundation/NSAutoreleasePool.h>
#include "../../Testing.h"

@interface TestFaultHandler : EOFaultHandler
@end
@implementation TestFaultHandler : EOFaultHandler
- (void) completeInitializationOfObject:(id)object
{ 
  [EOFault clearFault:object];
}
@end

int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  EOFaultHandler *fh = [[TestFaultHandler alloc] init];
  id foo = [[NSMutableString alloc] initWithString:@"foo"];
  int rc1 = [foo retainCount];
  int rc2;
  int i;
  
  [EOFault makeObjectIntoFault:foo withHandler:fh];
  pass([EOFault isFault:foo], "EOFault +isFault:");
  
  rc2 = [foo retainCount]; 
  pass(rc1 == rc2, "fault retainCount equal original %i, %i", rc1, rc2);
  
  rc1 = [foo retainCount];
  [foo retain];
  rc2 = [foo retainCount];
  pass(rc1 + 1 == rc2, "EOFault -retain %i, %i", rc1, rc2);

  [foo autorelease];
  rc1 = [foo retainCount];
  [pool emptyPool];
  rc2 = [foo retainCount];
  pass(rc1 - 1 == rc2, "EOFault -autorelease %i, %i", rc1, rc2);
  
  for (i = 0; i < 5; i++)
    {
      [foo retain];
    }
  rc1 = [foo retainCount]; 
  [foo release];
  rc2 = [foo retainCount];
  pass(rc1 - 1 == rc2, "EOFault -release %i %i", rc1, rc2);
  rc1 = rc2;
  
  [foo self];
  pass([foo isKindOfClass:[NSMutableString class]], "fault fires");
  pass([foo isEqual:@"foo"], "data intact");
 
  
  rc2 = [foo retainCount];
  pass(rc1 == rc2, "faulted object has faults retains %i, %i", rc1, rc2);
  
  RELEASE(pool);
  return 0;
}
