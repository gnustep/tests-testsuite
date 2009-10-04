#import <Foundation/NSTask.h>
#import <Foundation/NSFileHandle.h>
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
  NSFileHandle *outHandle;
  NSAutoreleasePool *arp;
  NSData *data = nil;

  arp = [[NSAutoreleasePool alloc] init];

  task = [[NSTask alloc] init];
  outPipe = [[NSPipe pipe] retain];
  [task setLaunchPath: [NSString stringWithString: COMMAND]];
  [task setArguments: [NSArray arrayWithObjects: ARGUMENTS]];
  [task setStandardOutput: outPipe]; 
  outHandle = [outPipe fileHandleForReading];

  [task launch];

  data = [outHandle readDataToEndOfFile];
  pass([data length] > 0, "was able to read data from subtask");
  NSLog(@"Data was %*.*s", [data length], [data length], [data bytes]);

  [task terminate];

  TEST_EXCEPTION([task launch];, @"NSInvalidArgumentException", YES,
    "raised exception on failed launch") 

  data = [outHandle readDataToEndOfFile];

  // test data?

  [task terminate];

  [outPipe release];
  [task release];

  [arp release];

  return 0;
}
