#include <Foundation/NSString.h>
#include <Foundation/NSArray.h>
#include <Foundation/NSArchiver.h>
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSData.h>
#include "Testing.h"
#include "ObjectTesting.h"

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSString *val1, *val2, *val3;
  NSArray  *vals1, *vals2;
  NSData   *data1;
  NSArray *a;

  TEST_EXCEPTION(val1 = [NSString stringWithCString:"Archiver.dat"];
  		 val2 = [NSString stringWithCString:"A Goodbye"];
		 val3 = [NSString stringWithCString:"Testing all strings"];
		 vals1 = [[NSArray arrayWithObject:val1] arrayByAddingObject:val2];
		 vals2 = [vals1 arrayByAddingObject:val2];, nil, NO, 
		 "We can build basic strings and arrays for tests");
  
  data1 = [NSArchiver archivedDataWithRootObject:vals2];
  pass((data1 != nil && [data1 length] != 0), "archivedDataWithRootObject: seems ok");
  
  pass([NSArchiver archiveRootObject:vals2 toFile:val1],"archiveRootObject:toFile: seems ok"); 
  
  a = [NSUnarchiver unarchiveObjectWithData:data1];
  pass((a != nil && [a isKindOfClass:[NSArray class]] && [a isEqual:vals2]),
       "unarchiveObjectWithData: seems ok");
  
  a = [NSUnarchiver unarchiveObjectWithFile:val1];
  pass((a != nil && [a isKindOfClass:[NSArray class]] && [a isEqual:vals2]),
       "unarchiveObjectWithFile: seems ok");

  
  DESTROY(arp);
  return 0;
}
