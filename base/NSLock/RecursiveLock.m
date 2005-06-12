#include "Testing.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSLock.h>

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


  
  DESTROY(arp);
  return 0;
}

