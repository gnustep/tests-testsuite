#include "ObjectTesting.h"
#include <Foundation/Foundation.h>

int main()
{ 
  CREATE_AUTORELEASE_POOL(arp);
  NSBundle *gnustepBundle, *bundle;
  NSFileManager *fm = [NSFileManager defaultManager];
  NSString *path, *exepath;
  
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

  exepath = [gnustepBundle executablePath];
  pass([fm isExecutableFileAtPath: exepath],"-executablePath returns an executable path (library bundle)");

  path = [[[fm currentDirectoryPath] stringByAppendingPathComponent:@"Resources"]
		   stringByAppendingPathComponent: @"TestBundle.bundle"];

  bundle = [NSBundle bundleWithPath: path];
  pass([bundle isKindOfClass:[NSBundle class]],"+bundleWithPath returns an NSBundle");

  exepath = [bundle executablePath];
  pass([fm isExecutableFileAtPath: exepath],"-executablePath returns an executable path (real bundle)");
  
  DESTROY(arp);
  return 0;
}
