#import <Foundation/Foundation.h>
#import "Testing.h"

int main()
{ 
  NSAutoreleasePool   *pool = [NSAutoreleasePool new];

  pass([NSUserName() length] > 0, "we can get a user name");
  pass([NSFullUserName() length] > 0, "we can get a full user name");
  pass([NSHomeDirectory() length] > 0, "we can get a home directory");
  pass([NSStandardApplicationPaths() count] > 0, "we have app paths");
  NSLog(@"NSStandardApplicationPaths() gives %@", NSStandardApplicationPaths());
  pass([NSStandardLibraryPaths() count] > 0, "we have app paths");
  NSLog(@"NSStandardLibraryPaths() gives %@", NSStandardLibraryPaths());

  [pool release]; pool = nil;
 
  return 0;
}
