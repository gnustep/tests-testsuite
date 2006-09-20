#import <Foundation/NSTask.h>
#import <Foundation/NSFileHandle.h>
#import <Foundation/NSData.h>
#import <Foundation/NSAutoreleasePool.h>

#import "ObjectTesting.h"

int main()
{
  NSTask *task;
  NSPipe *outPipe;
  NSFileHandle *outHandle;
  NSAutoreleasePool *arp;
  NSData *data = nil;
  NSString *command_path;
  NSString *command_args;

  if (is_mswindows())
    {
      command_path = @"E:\\msys\\bin\\ls";
      command_args = @"-l";
    }
  else
    {
      command_path = @"/bin/ls";
      command_args = @"-l";
    }

  arp = [[NSAutoreleasePool alloc] init];

  task = [[NSTask alloc] init];
  outPipe = RETAIN([NSPipe pipe]);
  [task setLaunchPath: [NSString stringWithString: command_path]];
  [task setArguments: [NSArray arrayWithObjects: command_args, nil]];
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
