#import "ObjectTesting.h"

#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSFileHandle.h>
#import <Foundation/NSThread.h>
#import <Foundation/NSTimer.h>
#import <Foundation/NSRunLoop.h>

@interface ThreadTest : NSObject {
  char  acceptBlocks;
  char  blockForEmpty;
  char  blockForInput;
  char  blockForTimer;
  char  limitForEmpty;
  char  limitForInput;
  char  limitForTimer;
  char  moreForEmpty;
  char  moreForInput;
  char  moreForTimer;
  char  performed;
}
- (void) timeout: (NSTimer*)t;
- (void) thread1: (id)o;
@end

@implementation ThreadTest

- (void) timeout: (NSTimer*)t
{
}

- (void) thread1: (id)o
{
  NSAutoreleasePool     *pool = [NSAutoreleasePool new];
  NSRunLoop             *loop;
  NSFileHandle          *fh;
  NSTimer               *timer;
  NSDate                *end;
  NSDate                *start;
 
  loop = [NSRunLoop currentRunLoop];

  end = [loop limitDateForMode: NSDefaultRunLoopMode];
  if (end == nil)
    limitForEmpty = 'N';
  else
    limitForEmpty = 'Y';

  end = [NSDate dateWithTimeIntervalSinceNow: 0.2];
  start = [NSDate date];
  if ([loop runMode: NSDefaultRunLoopMode beforeDate: end] == YES)
    moreForEmpty = 'Y';
  else
    moreForEmpty = 'N';
  if (fabs([start timeIntervalSinceNow]) < 0.01)
    blockForEmpty = 'N';
  else
    blockForEmpty = 'Y';
  
  end = [NSDate dateWithTimeIntervalSinceNow: 0.2];
  start = [NSDate date];
  [loop acceptInputForMode: NSDefaultRunLoopMode beforeDate: end];
  if (fabs([start timeIntervalSinceNow]) < 0.01)
    acceptBlocks = 'N';
  else
    acceptBlocks = 'Y';
  
  timer = [NSTimer timerWithTimeInterval: 2.0
                                  target: self
                                selector: @selector(timeout:)
                                userInfo: nil
                                 repeats: NO];
  [loop addTimer: timer forMode: NSDefaultRunLoopMode];
  end = [loop limitDateForMode: NSDefaultRunLoopMode];
  if (fabs([end timeIntervalSinceDate: [timer fireDate]]) < 0.01)
    limitForTimer = 'Y';
  else
    limitForTimer = 'N';
  end = [NSDate dateWithTimeIntervalSinceNow: 0.2];
  start = [NSDate date];
  if ([loop runMode: NSDefaultRunLoopMode beforeDate: end] == YES)
    moreForTimer = 'Y';
  else
    moreForTimer = 'N';
  [timer invalidate];
  if (fabs([start timeIntervalSinceNow]) < 0.01)
    blockForTimer = 'N';
  else
    blockForTimer = 'Y';

  fh = [NSFileHandle fileHandleWithStandardInput];
  [fh readInBackgroundAndNotify];
  end = [loop limitDateForMode: NSDefaultRunLoopMode];
  if ([end isEqual: [NSDate distantFuture]] == YES)
    limitForInput = 'Y';
  else
    limitForInput = 'N';
  end = [NSDate dateWithTimeIntervalSinceNow: 0.2];
  start = [NSDate date];
  if ([loop runMode: NSDefaultRunLoopMode beforeDate: end] == YES)
    moreForInput = 'Y';
  else
    moreForInput = 'N';
  [timer invalidate];
  if (fabs([start timeIntervalSinceNow]) < 0.01)
    blockForInput = 'N';
  else
    blockForInput = 'Y';

  [pool release];
}

- (void) thread2: (id)o
{
  NSAutoreleasePool     *pool = [NSAutoreleasePool new];
  NSRunLoop             *loop;
  NSDate                *end;
 
  loop = [NSRunLoop currentRunLoop];

  [NSTimer scheduledTimerWithTimeInterval: 2.0
                                   target: self
                                 selector: @selector(timeout:)
                                 userInfo: nil
                                  repeats: NO];

  end = [NSDate dateWithTimeIntervalSinceNow: 2.0];
  while ([end timeIntervalSinceNow] > 0)
    {
      [loop runUntilDate: end];
    }
  [pool release];
}

- (void) threadEvent: (id)ignored
{
  performed = 'Y';
}

- (void) run
{
  NSDate                *until = [NSDate dateWithTimeIntervalSinceNow: 5.0];
  NSThread              *t;
  
  [NSTimer scheduledTimerWithTimeInterval: 5.0
                                   target: self
                                 selector: @selector(timeout:)
                                 userInfo: nil
                                  repeats: YES];

  [NSThread detachNewThreadSelector: @selector(thread1:)
                           toTarget: self
                         withObject: nil];
  t = [[NSThread alloc] initWithTarget: self
                              selector: @selector(thread2:)
                                object: nil];
  [t start];

  [self performSelector: @selector(threadEvent:)
               onThread: t
             withObject: nil
          waitUntilDone: NO];
  while ([until timeIntervalSinceNow] > 0)
    {
      [[NSRunLoop currentRunLoop] runUntilDate: until];
    }

  pass(acceptBlocks == 'N', "Accept with no inputs or timers will exit");
  pass(blockForEmpty == 'N', "A loop with no inputs or timers will exit");
  pass(blockForInput == 'Y', "A loop with an input source will block");
  pass(blockForTimer == 'Y', "A loop with a timer will block");
  pass(limitForEmpty == 'N', "A loop with no inputs or timers has no limit");
  pass(limitForInput == 'Y', "A loop with an input source has distant future");
  pass(limitForTimer == 'Y', "A loop with a timer has timer fire date");
  pass(moreForEmpty == 'N', "A loop with no inputs or timers has no more");
  pass(moreForInput == 'Y', "A loop with an input source has more");
  pass(moreForTimer == 'Y', "A loop with a timer has more");
  pass(performed == 'Y', "Methods will be performed in a loop without inputs");
}

@end

int main(int argc, char *argv[])
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  [[[ThreadTest new] autorelease] run];
  [pool release];
  return 0;
}
