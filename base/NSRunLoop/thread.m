#import "ObjectTesting.h"

#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSFileHandle.h>
#import <Foundation/NSThread.h>
#import <Foundation/NSTimer.h>
#import <Foundation/NSRunLoop.h>

@interface ThreadTest : NSObject {
  char  exitImmediately;
  char  blockForInput;
  char  blockForTimer;
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
  NSDate                *now;
 
  loop = [NSRunLoop currentRunLoop];

  end = [NSDate dateWithTimeIntervalSinceNow: 1.0];
  [loop runUntilDate: end];
  now = [NSDate date];
  if ([end earlierDate: now] == now)
    exitImmediately = 'Y';
  else
    exitImmediately = 'N';
  
  timer = [NSTimer timerWithTimeInterval: 2.0
                                  target: self
                                selector: @selector(timeout:)
                                userInfo: nil
                                 repeats: NO];
  [loop addTimer: timer forMode: NSDefaultRunLoopMode];
  end = [NSDate dateWithTimeIntervalSinceNow: 1.0];
  [loop runUntilDate: end];
  [timer invalidate];
  now = [NSDate date];
  if ([end earlierDate: now] == now)
    blockForTimer = 'N';
  else
    blockForTimer = 'Y';

  fh = [NSFileHandle fileHandleWithStandardInput];
  [fh readInBackgroundAndNotify];
  end = [NSDate dateWithTimeIntervalSinceNow: 1.0];
  [loop runUntilDate: end];
  [timer invalidate];
  now = [NSDate date];
  if ([end earlierDate: now] == now)
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

  [NSTimer scheduledTimerWithTimeInterval: 5.0
                                   target: self
                                 selector: @selector(timeout:)
                                 userInfo: nil
                                  repeats: NO];

  end = [NSDate dateWithTimeIntervalSinceNow: 6.0];
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
  NSDate                *until = [NSDate dateWithTimeIntervalSinceNow: 15];
  NSThread              *t;
  
  [NSTimer scheduledTimerWithTimeInterval: 10.0
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

  pass(exitImmediately == 'Y', "A loop with no inputs or timers will exit");
  pass(blockForInput == 'Y', "A loop with an input source will block");
  pass(blockForTimer == 'Y', "A loop with a timer will block");
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
