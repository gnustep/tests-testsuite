#import <Foundation/NSArray.h>
#import <Foundation/NSAutoreleasePool.h>
#import "ObjectTesting.h"

int main()
{
  NSArray *obj;
  NSMutableArray *testObjs = [[NSMutableArray alloc] init];
  NSString *str;
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  test_alloc(@"NSArray"); 
  obj = [NSArray new];
  pass((obj != nil && [obj count] == 0),"can create an empty array");
  str = @"hello";
  [testObjs addObject: obj];
  obj = [NSArray arrayWithObject:str];
  pass((obj != nil && [obj count] == 1), "can create an array with one element");
  [testObjs addObject: obj];
  test_NSObject(@"NSArray", testObjs);
  test_NSCoding(testObjs);
  test_NSCopying(@"NSArray",@"NSMutableArray",testObjs,YES,NO);
  test_NSMutableCopying(@"NSArray",@"NSMutableArray",testObjs);
  
  obj = [NSArray arrayWithContentsOfFile: @"test.plist"];
  pass((obj != nil && [obj count] > 0),"can create an array from file");
#if defined(GNUSTEP_BASE_LIBRARY)
  /* The apple foundation is arguably buggy in that it seems to create a
   * mutable array ... we would copy that in base, but it would currently
   * break jigs wrapping of initWithContentsIfFile: for java.
   */
  pass([obj isKindOfClass: [NSMutableArray class]] == NO,"array immutable");
#endif
  obj = [obj objectAtIndex: 0];
  pass([obj isKindOfClass: [NSMutableArray class]] == YES,"array mutable");
  [arp release]; arp = nil;
  return 0;
}
