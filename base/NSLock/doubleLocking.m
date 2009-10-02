#import "Testing.h"
#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSLock.h>

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  NSLock *lock = nil;

#if	1
  pass(NO, "Recursive lock with NSLock deadlocks ... this is not a real test, just a reminder that recursively locking should deadlock the thread after printing a diagnostic message");
#else
  ASSIGN(lock,[NSLock new]);
  [lock lock];
  TEST_EXCEPTION([lock lock],@"NSLockException",YES,
    "Recursive lock with NSLock raises an exception");
  [lock unlock];
#endif

#if	1
  pass(NO, "Recursive lock with NSConditionLock deadlocks ... this is not a real test, just a reminder that recursively locking should deadlock the thread after printing a diagnostic message");
#else
  ASSIGN(lock,[NSConditionLock new]);
  [lock lock];
  TEST_EXCEPTION([lock lock],@"NSConditionLockException",YES,
    "Recursive lock with NSConditionLock raises an exception");
  [lock unlock];
#endif

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
