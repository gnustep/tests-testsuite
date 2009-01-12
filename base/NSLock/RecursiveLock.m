#import "Testing.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSLock.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
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


  
  IF_NO_GC(DESTROY(arp));
  return 0;
}

