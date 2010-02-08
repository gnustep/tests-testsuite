#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSProxy.h>

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  char *prefix = "Class 'NSProxy'";
  Class theClass = Nil;
  id obj0;
  id obj1;
  NSZone *testZone = NSCreateZone(1024,1024,1);

  theClass = [NSProxy class];
  pass(theClass != Nil, "%s exists",prefix); 
  obj0 = [NSProxy alloc];
  pass(obj0 != nil, "%s has working alloc",prefix);
  TEST_EXCEPTION([obj0 isKindOfClass:theClass];, NSInvalidArgumentException,
  		 YES, "NSProxy -isKindOfClass raises exception");
  
  TEST_EXCEPTION([obj0 isMemberOfClass:theClass];, 
                 NSInvalidArgumentException, YES, 
		 "NSProxy -isKindOfClass raises exception");
  
  obj1 = [NSProxy allocWithZone:testZone];
  pass(obj1 != nil, "%s has working allocWithZone:",prefix);
  pass(NSZoneFromPointer(obj1) == testZone, "%s uses zone for alloc",prefix);
  pass([obj1 zone] == testZone, "%s -zone works",prefix);
  
  pass([obj1 hash] != 0, "%s has working -hash",prefix);
  pass([obj1 isEqual:obj1] == YES, "%s has working -isEqual:",prefix);
  pass([obj1 class] == theClass, "%s has working -class",prefix);
  
  [arp release]; arp = nil;
  return 0;
}
