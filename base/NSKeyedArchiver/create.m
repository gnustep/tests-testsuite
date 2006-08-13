#import <Foundation/NSKeyedArchiver.h>
#import <Foundation/NSException.h>
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSData.h>
#import "Testing.h"
#import "ObjectTesting.h"

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  id obj = [NSKeyedArchiver new];
  NSMutableData     *data1;

  pass((obj != nil && [obj isKindOfClass:[NSKeyedArchiver class]]), "+new creates an empty NSKeyedArchiver");
  [obj release];
  obj = [NSKeyedArchiver alloc];
  data1 = [NSMutableData dataWithLength: 0];
  obj = [obj initForWritingWithMutableData: data1];
  pass((obj != nil && [obj isKindOfClass:[NSKeyedArchiver class]]), "-initForWritingWithMutableData seems ok");

  TEST_EXCEPTION([[NSUnarchiver alloc] initForReadingWithData:nil];, 
                 @"NSInvalidArgumentException", YES,
		 "Creating an NSUnarchiver with nil data throws an exception");
  
  
  
  DESTROY(arp);
  return 0; 
}