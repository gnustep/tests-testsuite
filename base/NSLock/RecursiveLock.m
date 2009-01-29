#import "Testing.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSLock.h>

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  BOOL ret;
  NSLock *lock = [NSRecursiveLock new];
  ret = [lock tryLock];
  if (ret)
    [lock unlock];
  pass(ret, "NSRecursiveLock with tryLock, then unlocking");
  
  ASSIGN(lock,[NSRecursiveLock new]);
  ret = [lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:5]];
  if (ret)
    [lock unlock];
  pass(ret, "NSRecursiveLock lockBeforeDate: works");
  
  ASSIGN(lock,[NSRecursiveLock new]);
  [lock tryLock];
  ret = [lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:5]];
  if (ret)
    [lock unlock];
  pass(ret, "NSRecursiveLock lockBeforeDate: with NSRecursiveLock returns YES");


  
  [arp release]; arp = nil;
  return 0;
}

