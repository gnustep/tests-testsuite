#include "Testing.h"
#include <Foundation/NSArray.h>
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSBundle.h>
#include <Foundation/NSFileManager.h>
#include <Foundation/NSString.h>
#include <Foundation/NSPathUtilities.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSString *path, *localPath;
  NSBundle *bundle;
  NSArray  *arr, *carr;
  
  path = [[[[NSFileManager defaultManager] currentDirectoryPath]
		    stringByAppendingPathComponent:@"Resources"]
		   stringByAppendingPathComponent: @"TestBundle.bundle"];

  /* --- [NSBundle -pathsForResourcesOfType:inDirectory:] --- */
  bundle = [NSBundle bundleWithPath: path];
  pass([bundle isKindOfClass:[NSBundle class]],"+bundleWithPath returns an NSBundle");

  arr = [bundle pathsForResourcesOfType:@"txt" inDirectory: nil];
  pass((arr && [arr count]), "-pathsForResourcesOfType:inDirectory: returns an array");
  localPath = [path stringByAppendingPathComponent: @"Resources/NonLocalRes.txt"];
  pass([arr containsObject: localPath], "Returned array contains non-localized resource");
  localPath = [path stringByAppendingPathComponent: @"Resources/English.lproj/TextRes.txt"];
  pass([arr containsObject: localPath], "Returned array contains localized resource");

  /* --- [NSBundle +pathsForResourcesOfType:inDirectory:] --- */
  carr = [NSBundle pathsForResourcesOfType:@"txt" inDirectory: path];
  pass([arr isEqual: carr], "+pathsForResourcesOfType:inDirectory: returns same array");

  /* --- [NSBundle -pathsForResourcesOfType:inDirectory:forLocalization:] --- */
  arr = [bundle pathsForResourcesOfType:@"txt" inDirectory: nil forLocalization: @"English"];
  pass((arr && [arr count]), "-pathsForResourcesOfType:inDirectory:forLocalization returns an array");
  localPath = [path stringByAppendingPathComponent: @"Resources/NonLocalRes.txt"];
  pass([arr containsObject: localPath], "Returned array contains non-localized resource");
  localPath = [path stringByAppendingPathComponent: @"Resources/English.lproj/TextRes.txt"];
  pass([arr containsObject: localPath], "Returned array contains localized resource");

  DESTROY(arp);
  return 0;
}
