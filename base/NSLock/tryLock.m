#include "Testing.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSLock.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
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
  pass(ret == NO, "Recursive locking with NSLock should return NO"); 
  
  ASSIGN(lock,[NSLock new]);
  ret = [lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:5]];
  if (ret)
    [lock unlock];
  pass(ret, "NSLock lockBeforeDate: works");
  
  ASSIGN(lock,[NSLock new]);
  [lock tryLock];
  ret = [lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:5]];
  if (ret)
    [lock unlock];
  pass(ret == NO, "Recursive lockBeforeDate: with NSLock returns NO");
  
  DESTROY(arp);
  return 0;
}

