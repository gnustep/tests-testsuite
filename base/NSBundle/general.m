#include "ObjectTesting.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSBundle.h>

int main()
{ 
  CREATE_AUTORELEASE_POOL(arp);
  NSBundle *gnustepBundle;
  
  gnustepBundle = [NSBundle bundleForLibrary: @"gnustep-base"];
  
  TEST_FOR_CLASS(@"NSBundle",gnustepBundle,"+bundleForLibrary: makes a bundle for us");
  
  pass([gnustepBundle principalClass] == [NSObject class], 
    "-principalClass returns NSbject for the +bundleForLibrary:gnustep-base");
  
  pass([[gnustepBundle classNamed:@"NSArray"] isEqual:[NSArray class]] &&
       [[NSArray class] isEqual: [gnustepBundle classNamed:@"NSArray"]],
       "-classNamed returns the correct class");
  
  TEST_STRING([gnustepBundle resourcePath],"-resourcePath returns a string");
  
  [gnustepBundle setBundleVersion:42];
  pass([gnustepBundle bundleVersion] == 42,"we can set and get gnustep bundle version");
  
  pass([gnustepBundle load], "-load behaves properly on the gnustep bundle");
  
  DESTROY(arp);
  return 0;
}
