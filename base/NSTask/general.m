#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSTask.h>
#import <Foundation/NSProcessInfo.h>
#import <Foundation/NSBundle.h>
#import "ObjectTesting.h"

int main()
{
  CREATE_AUTORELEASE_POOL(arp);

  id task;
  id info;
  id env;
  id path1;
  id path2;
  BOOL yes;
  BOOL windows;

  info = [NSProcessInfo processInfo];
  env = [[info environment] mutableCopy];
  yes = YES;

  pass(info != nil && [info isKindOfClass: [NSProcessInfo class]]
       && env != nil && [env isKindOfClass: [NSMutableDictionary class]]
       && yes == YES,
       "We can build the objects for task tests");

  /* Check which OS we are on */
  windows = is_mswindows();
  if (windows)
    {
#if defined(__MINGW32__)
      path1 = [env objectForKey: @"SYSTEMROOT"];
      pass(path1 != nil, "Found Windows system installation '%s'",[path1 lossyCString]);
      path1 = [path1 stringByAppendingString: @"\\system32\\mem.exe"];
#else
      path1 = @"unused";
#endif
    }
  else
    {
      path1 = @"/bin/ls";
    }
  pass(YES, "Determined command to run as '%s'",[path1 lossyCString]);

  /* Try some tasks.  Make sure the program we use is common between Unix
     and Windows (and others?) */
  task = [NSTask launchedTaskWithLaunchPath: path1
		 arguments: [NSArray array]];
  [task waitUntilExit];
  pass(task != nil, "launchedTaskWithLaunchPath:arguments: works");

  if (windows == NO)
    {
      id task = [NSTask new];
      id args = [NSArray arrayWithObjects: @"-c", @"echo $PATH", nil];
      path2 = @"/bin/sh";
      [task setEnvironment: env];
      [task setLaunchPath: path2];
      [task setArguments: args];
      [task launch];
      [task waitUntilExit];
    }
  
  DESTROY(arp);
  return 0;
}
