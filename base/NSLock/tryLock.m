#import "Testing.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSLock.h>

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  BOOL ret;
  
  NSLock *lock = [NSLock new];
  ret = [lock tryLock];
  if (ret)
    [lock unlock];
  pass(ret, "NSLock with tryLock, then unlocking");
 
  ASSIGN(lock,[NSLock new]);
  [lock tryLock];
  ret = [lock tryLock];
  if (ret)
    [lock unlock];
  pass(ret == NO, "Recursive try lock with NSLock should return NO"); 
  
  ASSIGN(lock,[NSConditionLock new]);
  [lock tryLock];
  ret = [lock tryLock];
  if (ret)
    [lock unlock];
  pass(ret == NO, "Recursive try lock with NSConditionLock should return NO"); 
  
  ASSIGN(lock,[NSRecursiveLock new]);
  [lock tryLock];
  ret = [lock tryLock];
  if (ret)
    [lock unlock];
  pass(ret == YES, "Recursive try lock with NSRecursiveLock should return YES"); 
  
  ASSIGN(lock,[NSLock new]);
  ret = [lock lockBeforeDate: [NSDate dateWithTimeIntervalSinceNow: 1]];
  if (ret)
    [lock unlock];
  pass(ret, "NSLock lockBeforeDate: works");
  
  ASSIGN(lock,[NSLock new]);
  [lock tryLock];
  ret = [lock lockBeforeDate: [NSDate dateWithTimeIntervalSinceNow: 1]];
  if (ret)
    [lock unlock];
  pass(ret == NO, "Recursive lockBeforeDate: with NSLock returns NO");
  
  ASSIGN(lock,[NSConditionLock new]);
  [lock tryLock];
  ret = [lock lockBeforeDate: [NSDate dateWithTimeIntervalSinceNow: 1]];
  if (ret)
    [lock unlock];
  pass(ret == NO, "Recursive lockBeforeDate: with NSConditionLock returns NO");
  
  ASSIGN(lock,[NSConditionLock new]);
  [lock tryLock];
  ret = [lock lockBeforeDate: [NSDate dateWithTimeIntervalSinceNow: 1]];
  if (ret)
    [lock unlock];
  pass(ret == NO, "Recursive lockBeforeDate: with NSRecursiveLock returns YES");
  
  [arp release]; arp = nil;
  return 0;
}

