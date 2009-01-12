#import "Testing.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSCharacterSet.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSMutableCharacterSet *testMutableNamedSet, *testMutableNamedSet1, *testMutableNamedSet2;
  NSCharacterSet *testNamedSet;
  testMutableNamedSet = [NSMutableCharacterSet letterCharacterSet];
  testNamedSet = [NSCharacterSet letterCharacterSet];
  [testMutableNamedSet invert];
  pass([testMutableNamedSet characterIsMember:[@"." characterAtIndex:0]] &&
       ![testNamedSet characterIsMember:[@"." characterAtIndex:0]],
       "Insure defaults set accessors return the correct class");
   
  testMutableNamedSet1 = [NSMutableCharacterSet letterCharacterSet];
  testMutableNamedSet2 = [NSMutableCharacterSet letterCharacterSet];
  [testMutableNamedSet1 invert];
  pass([testMutableNamedSet1 characterIsMember:[@"." characterAtIndex:0]] &&
       ![testMutableNamedSet2 characterIsMember:[@"." characterAtIndex:0]],
       "Test whether we always get a clean mutable set"); 
  
  IF_NO_GC(DESTROY(arp));
  return 0;
}

