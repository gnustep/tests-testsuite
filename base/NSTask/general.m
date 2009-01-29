#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSTask.h>
#import <Foundation/NSProcessInfo.h>
#import <Foundation/NSBundle.h>
#import "ObjectTesting.h"

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];

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
  windows = ([info operatingSystem] == NSWindowsNTOperatingSystem);
  pth1 = windows ? @"C:\\WINDOWS\\SYSTEM32\\MEM.EXE" : @"/bin/ls";
  pass(YES, "Check which os we are running");

  /* Try some tasks.  Make sure the program we use is common between Unix
     and Windows (and others?) */
  task = [NSTask launchedTaskWithLaunchPath: pth1
		 arguments: [NSArray array]];
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
  
  [arp release]; arp = nil;
  return 0;
}
