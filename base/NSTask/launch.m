#import <Foundation/NSTask.h>
#import <Foundation/NSFileHandle.h>
#import <Foundation/NSFileManager.h>
#import <Foundation/NSData.h>
#import <Foundation/NSAutoreleasePool.h>

#import "ObjectTesting.h" 

#if	defined(__MINGW32__)
#define	COMMAND		@"C:\\WINDOWS\\SYSTEM32\\MEM.EXE"
#define ARGUMENTS	nil
#else
#define	COMMAND		@"/bin/ls"
#define ARGUMENTS	@"-l",nil
#endif

int main()
{
  NSTask *task;
  NSPipe *outPipe;
  NSFileManager *mgr;
  NSString      *helpers;
  NSFileHandle  *outHandle;
  NSAutoreleasePool *arp;
  NSData *data = nil;

  arp = [[NSAutoreleasePool alloc] init];

  mgr = [NSFileManager defaultManager];
  helpers = [mgr currentDirectoryPath];
  helpers = [helpers stringByAppendingPathComponent: @"Helpers"];
  helpers = [helpers stringByAppendingPathComponent: @"obj"];

  task = [[NSTask alloc] init];
  outPipe = [[NSPipe pipe] retain];
  [task setLaunchPath: [NSString stringWithString: COMMAND]];
  [task setArguments: [NSArray arrayWithObjects: ARGUMENTS]];
  [task setStandardOutput: outPipe]; 
  outHandle = [outPipe fileHandleForReading];

  [task launch];
  data = [outHandle readDataToEndOfFile];
  pass([data length] > 0, "was able to read data from subtask");
  //NSLog(@"Data was %*.*s", [data length], [data length], [data bytes]);
  [task terminate];

  TEST_EXCEPTION([task launch];, @"NSInvalidArgumentException", YES,
    "raised exception on failed launch") 
  [outPipe release];
  [task release];

  task = [[NSTask alloc] init];
  [task setLaunchPath:
    [helpers stringByAppendingPathComponent: @"processgroup"]];
  [task setArguments: [NSArray arrayWithObjects:
    [NSString stringWithFormat: @"%d", getpgrp()],
    nil]];
  [task launch];
  [task waitUntilExit];
  pass([task terminationStatus] == 0, "subtask changes process group");
  [task release];

  [arp release];

  return 0;
}
