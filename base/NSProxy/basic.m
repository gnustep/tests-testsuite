#include "ObjectTesting.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSProxy.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
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
  
  DESTROY(arp);
  return 0;
}
