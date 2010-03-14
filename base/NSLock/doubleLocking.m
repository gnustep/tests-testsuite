#import <Foundation/Foundation.h>
#import "Testing.h"
#import "ObjectTesting.h"

int main()
{
  NSAutoreleasePool	*arp = [NSAutoreleasePool new];
  NSFileManager		*mgr;
  NSString		*helpers;
  NSString		*command;
  NSTask		*task;
  NSPipe		*ePipe;
  NSFileHandle		*hdl;
  NSData		*data;
  NSString		*string;
  NSLock 		*lock = nil;

  mgr = [NSFileManager defaultManager];
  helpers = [mgr currentDirectoryPath];
  helpers = [helpers stringByAppendingPathComponent: @"Helpers"];
  helpers = [helpers stringByAppendingPathComponent: @"obj"];

  command = [helpers stringByAppendingPathComponent: @"doubleNSLock"];
  task = [[NSTask alloc] init];
  ePipe = [[NSPipe pipe] retain];
  [task setLaunchPath: command];
  [task setStandardError: ePipe]; 
  hdl = [ePipe fileHandleForReading];
  [task launch];
  [task waitUntilExit];
  data = [hdl availableData];
  pass([data length] > 0, "was able to read data from doubleNSLock");
  //NSLog(@"Data was %*.*s", [data length], [data length], [data bytes]);
  string = [NSString alloc];
  string = [string initWithData: data encoding: NSISOLatin1StringEncoding];
  pass([string rangeOfString: @"deadlock"].length > 0,
    "NSLock deadlocked as expected");

  command = [helpers stringByAppendingPathComponent: @"doubleNSConditionLock"];
  task = [[NSTask alloc] init];
  ePipe = [[NSPipe pipe] retain];
  [task setLaunchPath: command];
  [task setStandardError: ePipe]; 
  hdl = [ePipe fileHandleForReading];
  [task launch];
  [task waitUntilExit];
  data = [hdl availableData];
  pass([data length] > 0, "was able to read data from doubleNSConditionLock");
  //NSLog(@"Data was %*.*s", [data length], [data length], [data bytes]);
  string = [NSString alloc];
  string = [string initWithData: data encoding: NSISOLatin1StringEncoding];
  pass([string rangeOfString: @"deadlock"].length > 0,
    "NSConditionLock deadlocked as expected");

  ASSIGN(lock,[NSRecursiveLock new]);
  [lock lock];
  [lock lock];
  [lock unlock];
  [lock unlock];

  ASSIGN(lock,[NSLock new]);
  pass([lock tryLock] == YES, "NSLock can tryLock");
  pass([lock tryLock] == NO, "NSLock says NO for recursive tryLock");
  [lock unlock];

  ASSIGN(lock,[NSConditionLock new]);
  pass([lock tryLock] == YES, "NSConditionLock can tryLock");
  pass([lock tryLock] == NO, "NSConditionLock says NO for recursive tryLock");
  [lock unlock];

  ASSIGN(lock,[NSRecursiveLock new]);
  pass([lock tryLock] == YES, "NSRecursiveLock can tryLock");
  pass([lock tryLock] == YES, "NSRecursiveLock says YES for recursive tryLock");
  [lock unlock];

  [arp release];
  return 0;
}
