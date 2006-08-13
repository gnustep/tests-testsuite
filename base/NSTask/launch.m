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
  outPipe = RETAIN([NSPipe pipe]);
  [task setLaunchPath: [NSString stringWithString: COMMAND]];
  [task setArguments: [NSArray arrayWithObjects: ARGUMENTS]];
  [task setStandardOutput: outPipe]; 
  outHandle = [outPipe fileHandleForReading];

  [task launch];

  data = [outHandle readDataToEndOfFile];

  // test data?

  [task terminate];

  TEST_EXCEPTION([task launch];, @"NSInvalidArgumentException", YES,
    "raised exception on failed launch") 

  data = [outHandle readDataToEndOfFile];

  // test data?

  [task terminate];

  RELEASE(outPipe);
  RELEASE(task);

  RELEASE(arp);

  return 0;
}
