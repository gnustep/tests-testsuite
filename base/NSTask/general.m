#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSTask.h>
#import <Foundation/NSProcessInfo.h>
#import <Foundation/NSBundle.h>
#import <Foundation/NSFileHandle.h>
#import "ObjectTesting.h"

int main()
{
  CREATE_AUTORELEASE_POOL(arp);

  id task;
  id args;
  id info;
  id env;
  id path1;
  id path2;

  info = [NSProcessInfo processInfo];
  env = [[info environment] mutableCopy];

  pass(info != nil && [info isKindOfClass: [NSProcessInfo class]]
       && env != nil && [env isKindOfClass: [NSMutableDictionary class]],
       "We can build the objects for task tests");

  /* ----------------------------------------------------------------
   * TEST 1:
   * Launching this against base 1.13 on MS-Windows causes an error
   *  which isn't reported by the API at all...
   * ------------------------------------------------------------- */
#if defined(__MINGW32__)
  // MSYS uppercases the env-var so we see if it's our shell first...
  path1 = [env objectForKey: @"MSYSTEM"];
  if (path1 != nil)
      path1 = [env objectForKey: @"SYSTEMROOT"];
  else
      path1 = [env objectForKey: @"SystemRoot"];
  pass(path1 != nil && [path1 isKindOfClass: [NSString class]],
       "Found Windows system installation '%s'",[path1 lossyCString]);
  path1 = [path1 stringByAppendingString: @"\\system32\\mem.exe"];

  task = [NSTask launchedTaskWithLaunchPath: path1
		 arguments: [NSArray array]];
  [task waitUntilExit];
  pass(task != nil, "launching mem.exe shouldn't cause a stir");
#endif

  /* ----------------------------------------------------------------
   * TEST 2:
   * The output from this should appear on the console or test.log
   *  if everything is working right...
   * ------------------------------------------------------------- */
#if defined(__MINGW32__)
  // MSYS uppercases the env-var so we see if it's our shell first...
  path1 = [env objectForKey: @"MSYSTEM"];
  if (path1 != nil)
      path1 = [env objectForKey: @"COMSPEC"];
  else
      path1 = [env objectForKey: @"ComSpec"];
  pass(path1 != nil && [path1 isKindOfClass: [NSString class]],
       "Got shell path '%s'",[path1 lossyCString]);
  args  = [NSArray arrayWithObjects: @"/C dir", nil];
#else
  path1 = @"/bin/ls";
  args  = [NSArray arrayWithObjects: @"-l", nil];
#endif

  task = [NSTask launchedTaskWithLaunchPath: path1
		 arguments: args];
  [task waitUntilExit];
  pass(task != nil, "launchedTaskWithLaunchPath:arguments: works");

  /* ----------------------------------------------------------------
   * TEST 3:
   * Launch a shell with instructions to execute a child command.
   *  We read the result and make sure it is what we expected!
   * ------------------------------------------------------------- */
  task = [NSTask new];
  path2 = @"sh";
  args = [NSArray arrayWithObjects: @"-c", @"echo -n $GNUSTEP_MAKEFILES", nil];
  id stdOut = [NSPipe pipe];

  [task setEnvironment: env];
  [task setLaunchPath: path2];
  [task setArguments: args];
  [task setStandardOutput: stdOut];
  [task launch];
  [task waitUntilExit];

  id stdOutRead = [stdOut fileHandleForReading];

  pass(stdOutRead != nil && [stdOutRead isKindOfClass: [NSFileHandle class]],
       "Got handle for reading launched task output");

  /* Now we read the result */
  NSData *outputResult = [stdOutRead readDataToEndOfFile];
  NSString *outputString;
  NSString *expectString;

  pass([outputResult length] > 0, "Have output data");

  expectString = [[[NSProcessInfo processInfo] environment]
                       objectForKey: @"GNUSTEP_MAKEFILES"];

  outputString = [[NSString alloc] initWithData: outputResult
                                       encoding: NSUTF8StringEncoding];

  pass([outputString isEqual: expectString],
         "Received expected result from child task");
  [stdOut release];

  DESTROY(arp);
  return 0;
}
