#include <Foundation/NSArray.h>
#include <Foundation/NSString.h>
#include <Foundation/NSAutoreleasePool.h>
#include "ObjectTesting.h"

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  id val1,val2,val3;
  id ptrvals[3];
  val1 = @"Tom";
  val2 = @"Petty";
  val3 = @"doesn't want to live like a refugee";
  NSArray *obj, *old;

  ptrvals[0] = val1;
  ptrvals[1] = val2;
  ptrvals[2] = val3;
 
  obj = [NSArray new];
  pass((obj != nil && [obj isKindOfClass:[NSArray class]] && [obj count] == 0),
       "+new creates an empty array");
  RELEASE(obj);
  obj = [NSArray array];
  pass((obj != nil && [obj isKindOfClass:[NSArray class]] && [obj count] == 0),
       "+array creates an empty array");
  TEST_EXCEPTION([NSArray arrayWithObject:nil];, @"NSInvalidArgumentException",
                 YES, "+arrayWithObject with nil argument throws exception");
 
  obj = [NSArray arrayWithObject:val1];
  pass(obj != nil && [obj isKindOfClass:[NSArray class]] && [obj count] == 1,
       "+arrayWithObject: builds a minimal array");
  
  obj = [NSArray arrayWithObjects:ptrvals count:3];
  old = obj;
  pass(obj != nil && [obj isKindOfClass:[NSArray class]] && [obj count] == 3,
       "+arrayWithObjects: builds an array");

  obj = [NSArray arrayWithArray:old];
  pass(obj != nil && [old isEqual:obj], "+arrayWithArray: copies array");

  DESTROY(arp);
  return 0;
}

