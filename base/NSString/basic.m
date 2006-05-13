#include "ObjectTesting.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSString.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
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

  DESTROY(arp);
  return 0;
}
