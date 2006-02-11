#include <Foundation/NSArchiver.h>
#include <Foundation/NSException.h>
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSData.h>
#include "Testing.h"
#include "ObjectTesting.h"

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  id obj = [NSArchiver new];
  NSMutableData     *data1;

  pass((obj != nil && [obj isKindOfClass:[NSArchiver class]] &&
       [obj archiverData] != nil), "+new creates an empty NSArchiver");
  [obj release];
  obj = [NSArchiver alloc];
  data1 = [NSMutableData dataWithLength: 0];
  obj = [obj initForWritingWithMutableData: data1];
  pass((obj != nil && [obj isKindOfClass:[NSArchiver class]] && data1 == [obj archiverData]), "-initForWritingWithMutableData seems ok");

  TEST_EXCEPTION([[NSUnarchiver alloc] initForReadingWithData:nil];, 
                 @"NSInvalidArgumentException", YES,
		 "Creating an NSUnarchiver with nil data throws an exception");
  
  
  
  DESTROY(arp);
  return 0; 
}
