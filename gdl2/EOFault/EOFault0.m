#import <Foundation/Foundation.h>
#import <EOControl/EOControl.h>
#include <Testing.h>

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
  Class fClass = [foo class];
  
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
  [pool release];
  pool = [[NSAutoreleasePool alloc] init];
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
  
  pass([foo isKindOfClass:[NSMutableString class]] && [EOFault isFault:foo], "-isKindOfClass: is transparent but doesn't fire");
  pass([foo isMemberOfClass:fClass]&& [EOFault isFault:foo], "-isMemberOfClass: is transparent but doesn't fire");
  pass([[foo class] isSubclassOfClass: [NSString class]] && [EOFault isFault:foo], "-class is transparent but doesn't fire");
  pass([[foo superclass] isSubclassOfClass: [NSObject class]] && [EOFault isFault:foo], "-superclass is transparent but doesn't fire");
  pass([foo conformsToProtocol: @protocol(NSCopying)] && [EOFault isFault:foo], "-conformsToProtocol is transparent but doesn't fire");
  pass([foo isProxy] == NO && [EOFault isFault:foo], "-isProxy is transparent but doesn't fire");
  pass([foo methodSignatureForSelector:@selector(appendString:)] && [EOFault isFault:foo], "-methodSignatureForSelector is transparent but doesn't fire");
  pass([foo respondsToSelector:@selector(appendString:)] && [EOFault isFault:foo], "-respondsToSelector is transparent but doesn't fire");
  pass([foo zone] && [EOFault isFault:foo], "zone is transparent but doesn't fire");
  NS_DURING
    [foo doesNotRecognizeSelector: @selector(addObject:)];
  NS_HANDLER;
  NS_ENDHANDLER;
  pass([EOFault isFault:foo], "doesNotRecognizeSelector: is transparent but doesn't fire");

  [foo self];
  pass([EOFault isFault:foo] == NO, "fault fire");

  pass([foo isEqual:@"foo"], "data intact");
 
  
  rc2 = [foo retainCount];
  pass(rc1 == rc2, "faulted object has faults retains %i, %i", rc1, rc2);
  
  [pool release];
  return 0;
}
