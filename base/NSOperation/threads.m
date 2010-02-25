#import <Foundation/NSArray.h>
#import <Foundation/NSLock.h>
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
  NSThread      *thread;
  BOOL flag;
}
- (void) main;
- (BOOL) ran;
- (NSThread*) thread;
@end

@implementation OpFlag
- (void) main
{
  flag = YES;
  thread = [NSThread currentThread];
}
- (BOOL) ran
{
  return flag;
}
- (NSThread*) thread
{
  return thread;
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

@interface      OpOrder : NSOperation
@end
@implementation OpOrder
static NSLock *lock = nil;
static NSMutableArray *list = nil;
+ (void) initialize
{
  lock = [NSLock new];
  list = [NSMutableArray new];
}
- (void) main
{
  [lock lock];
  [list addObject: self];
  [lock unlock];
}
@end

int main()
{
  ThreadCounter         *cnt;
  id                    obj;
  NSMutableArray        *a;
  NSOperationQueue      *q;
  NSAutoreleasePool     *arp = [NSAutoreleasePool new];

  cnt = [ThreadCounter new];
  pass((cnt != nil && [cnt count] == 0), "counter was set up");

  // Check that operation runs in current thread.
  obj = [OpFlag new];
  [obj start];
  pass(([obj ran] == YES), "operation ran");
  pass(([obj thread] == [NSThread currentThread]), "operation ran in this thread");
  [obj release];

  // Check that monitoring of another thread works.
  obj = [OpFlag new];
  [NSThread detachNewThreadSelector: @selector(start)
                           toTarget: obj
                         withObject: nil];
  [NSThread sleepForTimeInterval: 0.1];
  pass(([obj isFinished] == YES), "operation finished");
  pass(([obj ran] == YES), "operation ran");
  pass(([obj thread] != [NSThread currentThread]), "operation ran in other thread");
  [obj release];

  // Check that exit from thread in -main causes operation tracking to fail.
  obj = [OpExit new];
  [NSThread detachNewThreadSelector: @selector(start)
                           toTarget: obj
                         withObject: nil];
  [NSThread sleepForTimeInterval: 0.1];
  pass(([obj isFinished] == NO), "operation exited");
  pass(([obj ran] == YES), "operation ran");
  pass(([obj thread] != [NSThread currentThread]), "operation ran in other thread");
  pass(([obj isExecuting] == YES), "operation seems to be running");
  [obj release];

  // Check that raising exception in -main causes operation tracking to fail.
  obj = [OpRaise new];
  TEST_EXCEPTION([obj start];,
  		 NSGenericException, YES, 
		 "NSOperation exceptions propogate from main");
  pass(([obj isFinished] == NO), "operation failed to finish");
  pass(([obj ran] == YES), "operation ran");
  pass(([obj thread] == [NSThread currentThread]), "operation ran in this thread");
  pass(([obj isExecuting] == YES), "operation seems to be running");
  [obj release];

  obj = [OpFlag new];
  [obj start];
  pass(([obj ran] == YES), "operation ran");
  pass(([obj thread] == [NSThread currentThread]), "operation ran in this thread");
  [obj release];

  obj = [OpFlag new];
  q = [NSOperationQueue new];
  [cnt reset];
  [q addOperation: obj];
  [q waitUntilAllOperationsAreFinished];
  pass(([obj ran] == YES), "operation ran");
  pass(([obj thread] != [NSThread currentThread]), "operation ran in other thread");
  pass(([cnt count] == 0), "thread did not exit immediately");
  [obj release];
  /* Observer behavior on OSX 10.6 is that the thread exits after five seconds ... but who knows what that might change to. */
  [NSThread sleepForTimeInterval: 5.0];
  pass(([cnt count] == 1), "thread exit occurs after five seconds");

  pass(([NSOperationQueue currentQueue] == [NSOperationQueue mainQueue]), "current queue outside -main is main queue");
  pass(([NSOperationQueue mainQueue] != nil), "main queue is not nil");
  obj = [OpFlag new];
  [q addOperation: obj];
  [q waitUntilAllOperationsAreFinished];
  pass(([obj isFinished] == YES), "main queue runs an operation");
  pass(([obj thread] != [NSThread currentThread]), "operation ran in other thread");

  [q setSuspended: YES];
  obj = [OpFlag new];
  [q addOperation: obj];
  [NSThread sleepForTimeInterval: 0.1];
  pass(([obj isFinished] == NO), "suspend works");
  [q setSuspended: NO];
  [q waitUntilAllOperationsAreFinished];
  pass(([obj isFinished] == YES), "unsuspend works");
  [obj release];

  [q setMaxConcurrentOperationCount: 0];
  obj = [OpFlag new];
  [q addOperation: obj];
  [NSThread sleepForTimeInterval: 0.1];
  pass(([obj isFinished] == NO), "max operation count of zero suspends queue");
  [q setMaxConcurrentOperationCount: 1];
  [q waitUntilAllOperationsAreFinished];
  pass(([obj isFinished] == YES), "resetting max operation queue sarts it");
  [obj release];

  a = [NSMutableArray array];

  obj = [OpOrder new];
  [a addObject: obj];
  [obj release];
  obj = [OpOrder new];
  [a addObject: obj];
  [obj release];
  obj = [OpOrder new];
  [a addObject: obj];
  [obj release];
  [q addOperations: a waitUntilFinished: YES];
  pass(([list isEqual: a]), "operations ran in order of addition");

  [list removeAllObjects];
  [a removeAllObjects];
  obj = [OpOrder new];
  [obj setQueuePriority: NSOperationQueuePriorityLow];
  [a addObject: obj];
  [obj release];
  obj = [OpOrder new];
  [a addObject: obj];
  [obj release];
  obj = [OpOrder new];
  [obj setQueuePriority: NSOperationQueuePriorityHigh];
  [a addObject: obj];
  [obj release];
  [q addOperations: a waitUntilFinished: YES];
  pass(([list objectAtIndex: 0] == [a objectAtIndex: 2] && [list objectAtIndex: 2] == [a objectAtIndex: 0]), "operations ran in order of priority");


  [arp release]; arp = nil;
  return 0;
}