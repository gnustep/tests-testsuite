#import <Foundation/NSArchiver.h>
#import <Foundation/NSException.h>
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSData.h>
#import "Testing.h"
#import "ObjectTesting.h"

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
  
  
  
  IF_NO_GC(DESTROY(arp));
  return 0; 
}
