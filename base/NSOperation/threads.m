#import <Foundation/NSOperation.h>
#import <Foundation/NSThread.h>
#import <Foundation/NSNotification.h>
#import <Foundation/NSAutoreleasePool.h>
#import "ObjectTesting.h"


@interface      ThreadCounter : NSObject
{
  unsigned count;
}
- (unsigned) count;
- (void) increment: (NSNotification*)n;
- (void) reset;
@end

@implementation ThreadCounter
- (unsigned) count
{
  return count;
}

- (void) dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver: self];
  [super dealloc];
}

- (void) increment: (NSNotification*)n
{
  count++;
}

- (id) init
{
  [[NSNotificationCenter defaultCenter] addObserver: self
                                           selector: @selector(increment:)
                                               name: NSThreadWillExitNotification
                                             object: nil];
  return self;
}

- (void) reset
{
  count = 0;
}

@end

@interface      OpFlag : NSOperation
{
  BOOL flag;
}
- (void) main;
- (BOOL) ran;
@end

@implementation OpFlag
- (void) main
{
  flag = YES;
}
- (BOOL) ran
{
  return flag;
}
@end

@interface OpExit : OpFlag
@end

@implementation OpExit 
- (void) main
{
  [super main];
  [NSThread exit];
}
@end

@interface OpRaise : OpFlag
@end

@implementation OpRaise 
- (void) main
{
  [super main];
  [NSException raise: NSGenericException format: @"done"];
}
@end

int main()
{
  ThreadCounter         *cnt;
  id                    obj;
  NSAutoreleasePool     *arp = [NSAutoreleasePool new];

  cnt = [ThreadCounter new];
  pass((cnt != nil && [cnt count] == 0), "counter was set up");

  // Check that operation runs in current thread.
  obj = [OpFlag new];
  [cnt reset];
  [obj start];
  pass(([obj ran] == YES), "operation ran");
  pass(([cnt count] == 0), "operation ran in this thread");
  [obj release];

  // Check that monitoring of another thread works.
  obj = [OpFlag new];
  [cnt reset];
  [NSThread detachNewThreadSelector: @selector(start)
                           toTarget: obj
                         withObject: nil];
  [NSThread sleepForTimeInterval: 1.0];
  pass(([cnt count] == 1), "operation ran in other thread");
  pass(([obj isFinished] == YES), "operation finished");
  pass(([obj ran] == YES), "operation ran");
  [obj release];

  // Check that exit from thread in -main causes operation tracking to fail.
  obj = [OpExit new];
  [cnt reset];
  [NSThread detachNewThreadSelector: @selector(start)
                           toTarget: obj
                         withObject: nil];
  [NSThread sleepForTimeInterval: 1.0];
  pass(([cnt count] == 1), "operation ran in other thread");
  pass(([obj isFinished] == NO), "operation exited");
  pass(([obj ran] == YES), "operation ran");
  pass(([obj isExecuting] == YES), "operation seems to be running");
  [obj release];

  // Check that raising exception in -main causes operation tracking to fail.
  obj = [OpRaise new];
  TEST_EXCEPTION([obj start];,
  		 NSGenericException, YES, 
		 "NSOperation exceptions propogate from main");
  pass(([obj isFinished] == NO), "operation failed to finish");
  pass(([obj ran] == YES), "operation ran");
  pass(([obj isExecuting] == YES), "operation seems to be running");
  [obj release];

  [arp release]; arp = nil;
  return 0;
}
