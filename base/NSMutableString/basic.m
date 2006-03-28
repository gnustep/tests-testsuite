#include "ObjectTesting.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSString.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  unichar	u0 = 'a';
  unichar	u1 = 0xfe66;
  NSMutableString *testObj,*base,*ext,*want;
  test_alloc(@"NSMutableString");
  testObj = [[NSMutableString alloc] initWithCString:"Hello\n"];
  test_NSCoding([NSArray arrayWithObject:testObj]);
  test_NSCopying(@"NSString",@"NSMutableString",
                 [NSArray arrayWithObject:testObj],NO,NO); 
  test_NSMutableCopying(@"NSString",@"NSMutableString",
                        [NSArray arrayWithObject:testObj]);
 
  base = [[NSMutableString alloc] initWithCString:"hello"];
  ext = [@"\"\\UFE66???\"" propertyList];
  want = [@"\"hello\\UFE66???\"" propertyList];
  [base appendString:ext];
  pass([base length] == 9 && [ext length] == 4
    && [want length] == 9 && [base isEqual:want],
    "We can append a unicode string to a C string");

  pass([[[NSMutableString alloc] initWithCharacters: &u0 length: 1]
    isKindOfClass: [NSMutableString class]],
    "initWithCharacters:length: creates mutable string for ascii");

  pass([[[NSMutableString alloc] initWithCharacters: &u1 length: 1]
    isKindOfClass: [NSMutableString class]],
    "initWithCharacters:length: creates mutable string for unicode");

  TEST_EXCEPTION([[NSMutableString stringWithString: @"foo"]
		  			appendString: @"bar"];,
		nil,
		NO,
		"can append to string from NSMutableString +stringWithString:");

  DESTROY(arp); 
  return 0;
}
