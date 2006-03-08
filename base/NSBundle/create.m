#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSBundle.h>
#include <Foundation/NSFileManager.h>
#include "ObjectTesting.h"

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSString *path;
  NSBundle *bundle;
  
  path = [[[NSFileManager defaultManager] currentDirectoryPath] 
  				 stringByAppendingPathComponent:@"Resources"];
  
  pass([NSBundle mainBundle] != nil, 
       "+mainBundle returns non-nil if the tool has no bundle");
  
  bundle = [NSBundle bundleWithPath:path];
  RETAIN(bundle);

  TEST_FOR_CLASS(@"NSBundle", bundle, "+bundleWithPath returns a bundle");
  
  TEST_STRING([bundle bundlePath],"a bundle has a path");
  
  pass([path isEqual:[bundle bundlePath]] &&
       [[bundle bundlePath] isEqual:path],
       "bundlePath returns the correct path");
  
  TEST_FOR_CLASS(@"NSDictionary",[bundle infoDictionary],
                 "a bundle has an infoDictionary");
  
  pass([NSBundle bundleWithPath:
           [path stringByAppendingPathComponent:@"nonexistent"]] == nil,
       "+bundleWithPath returns nil for a non-existing path"); 
  
  {
    NSArray *arr = [NSBundle allBundles];
    pass(arr != nil && [arr isKindOfClass:[NSArray class]] && [arr count] != 0,
         "+allBundles returns an array");
  }
  DESTROY(arp);
  return 0;
}
