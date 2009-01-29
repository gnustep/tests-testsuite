#import "ObjectTesting.h"
#import <Foundation/Foundation.h>

@interface	TestClass : NSObject
@end

@implementation	TestClass
@end

int main()
{ 
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  NSBundle *classBundle, *gnustepBundle, *identifierBundle, *bundle;
  NSFileManager *fm = [NSFileManager defaultManager];
  NSString *path, *exepath;

  
  gnustepBundle = [NSBundle bundleForLibrary: @"gnustep-base"];
  
  TEST_FOR_CLASS(@"NSBundle",gnustepBundle,
    "+bundleForLibrary: makes a bundle for us");
  
  pass([gnustepBundle principalClass] == [NSObject class], 
    "-principalClass returns NSObject for the +bundleForLibrary:gnustep-base");
  
  classBundle = [NSBundle bundleForClass: [TestClass class]];

  TEST_FOR_CLASS(@"NSBundle",classBundle,
    "+bundleForClass: makes a bundle for us");

  NSLog(@"%@", [classBundle principalClass]);
  pass([classBundle principalClass] == [TestClass class], 
    "-principalClass returns TestClass for +bundleForClass:[TestClass class]");

  pass(classBundle == [NSBundle mainBundle], 
    "-mainBundle is the same as +bundleForClass:[TestClass class]");

  pass([[gnustepBundle classNamed:@"NSArray"] isEqual:[NSArray class]] &&
       [[NSArray class] isEqual: [gnustepBundle classNamed:@"NSArray"]],
       "-classNamed returns the correct class");
  
  TEST_STRING([gnustepBundle resourcePath],"-resourcePath returns a string");
  
  [gnustepBundle setBundleVersion:42];
  pass([gnustepBundle bundleVersion] == 42,
    "we can set and get gnustep bundle version");
  
  pass([gnustepBundle load], "-load behaves properly on the gnustep bundle");

  exepath = [gnustepBundle executablePath];
  pass([fm fileExistsAtPath: exepath],
    "-executablePath returns an executable path (gnustep bundle)");

  path = [[[fm currentDirectoryPath]
    stringByAppendingPathComponent:@"Resources"]
      stringByAppendingPathComponent: @"TestBundle.bundle"];

  bundle = [NSBundle bundleWithPath: path];
  pass([bundle isKindOfClass:[NSBundle class]],
    "+bundleWithPath returns an NSBundle");

  exepath = [bundle executablePath];
  pass([fm fileExistsAtPath: exepath],
    "-executablePath returns an executable path (real bundle)");
  
  identifierBundle
    = [NSBundle bundleWithIdentifier: @"Test Bundle Identifier 1"];
  pass(identifierBundle == bundle,
    "+bundleWithIdentifier returns correct bundle");

  identifierBundle
    = [NSBundle bundleWithIdentifier: @"Test Bundle Identifier 2"];
  pass(identifierBundle == nil,
    "+bundleWithIdentifier returns nil for non-existent identifier");

  [arp release]; arp = nil;
  return 0;
}
