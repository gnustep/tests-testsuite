#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSString.h>

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  unichar	u0 = 'a';
  unichar	u1 = 0xfe66;
  NSString	*s;
  NSString *testObj = [NSString stringWithCString: "Hello\n"];

  test_alloc(@"NSString");
  test_NSObject(@"NSString",[NSArray arrayWithObject:testObj]);
  test_NSCoding([NSArray arrayWithObject:testObj]);
  test_NSCopying(@"NSString", @"NSMutableString", 
                 [NSArray arrayWithObject:testObj], NO, NO);
  test_NSMutableCopying(@"NSString", @"NSMutableString",
  			[NSArray arrayWithObject:testObj]);

  /* Test non-ASCII strings.  */
  testObj = [@"\"\\U00C4\\U00DF\"" propertyList];
  test_NSMutableCopying(@"NSString", @"NSMutableString",
  			[NSArray arrayWithObject:testObj]);

  pass([(s = [[NSString alloc] initWithCharacters: &u0 length: 1])
    isKindOfClass: [NSString class]]
    && ![s isKindOfClass: [NSMutableString class]],
    "initWithCharacters:length: creates mutable string for ascii");

  pass([(s = [[NSString alloc] initWithCharacters: &u1 length: 1])
    isKindOfClass: [NSString class]]
    && ![s isKindOfClass: [NSMutableString class]],
    "initWithCharacters:length: creates mutable string for unicode");

  TEST_EXCEPTION([[NSString alloc] initWithString: nil];,
  		 NSInvalidArgumentException, YES, 
		 "NSString -initWithString: does not allow nil argument");

  [arp release]; arp = nil;
  return 0;
}
