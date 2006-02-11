#include "ObjectTesting.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSString.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
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
  pass([base length] == 9 &&
       [ext length] == 4 &&
       [want length] == 9 &&
       [base isEqual:want],
       "We can append a unicode string to a C string");
   
  DESTROY(arp);
  return 0;
}
