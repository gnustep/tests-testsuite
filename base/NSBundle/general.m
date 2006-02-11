#include "ObjectTesting.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSBundle.h>

int main()
{ 
  CREATE_AUTORELEASE_POOL(arp);
  NSBundle *gnustepBundle;
  
  TEST_STRING([NSBundle _gnustep_target_cpu],
              "+_gnustep_target_cpu returns a string");  
  
  TEST_STRING([NSBundle _gnustep_target_os],
  	      "+_gnustep_target_os returns a string");
  
  TEST_STRING([NSBundle _gnustep_target_dir],
              "+_gnustep_target_dir returns a string");
  
  TEST_STRING([NSBundle _library_combo],
              "+_library_combo returns a string");

  gnustepBundle = [NSBundle gnustepBundle];
  
  TEST_FOR_CLASS(@"NSBundle",gnustepBundle,"+gnustepBundle makes a bundle for us");
  
  pass([gnustepBundle principalClass] == nil, 
       "-principalClass returns nil for the +gnustepBundle");
  
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
