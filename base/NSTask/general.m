#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSTask.h>
#include <Foundation/NSProcessInfo.h>
#include <Foundation/NSBundle.h>
#include "ObjectTesting.h"

int main()
{
  CREATE_AUTORELEASE_POOL(arp);

  id task;
  id info;
  id env;
  id pth1;
  id pth2;
  BOOL yes;
  BOOL windows;

  info = [NSProcessInfo processInfo];
  env = [[info environment] mutableCopy];
  yes = YES;
  
  pass(info != nil && [info isKindOfClass: [NSProcessInfo class]]
       && env != nil && [env isKindOfClass: [NSMutableDictionary class]]
       && yes == YES,
       "We can build some objects for task tests");

  /* Check which OS we are on. FIXME: Need a better test for this */
  windows = [[NSBundle _gnustep_target_os] isEqual: @"mingw32"];
  pth1 = windows ? @"C:\\WINDOWS\\COMMAND\\MEM.EXE" : @"/bin/ls";
  pass(YES, "Check which os we are running");

  /* Try some tasks.  Make sure the program we use is common between Unix
     and Windows (and others?) */
  task = [NSTask launchedTaskWithLaunchPath: pth1
		 arguments: nil];
  [task waitUntilExit];
  pass(YES, "launchedTaskWithLaunchPath:arguments: works");

  if (windows == NO)
    {
      id task = [NSTask new];
      id args = [NSArray arrayWithObjects: @"-c", @"echo $PATH", nil];
      pth2 = @"/bin/sh";
      [task setEnvironment: env];
      [task setLaunchPath: pth2];
      [task setArguments: args];
      [task launch];
      [task waitUntilExit];
    }
  
  DESTROY(arp);
  return 0;
}
