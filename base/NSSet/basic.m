#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSSet.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSSet *testObj;
  NSMutableArray *testObjs = [NSMutableArray new];

  testObj = [NSSet new];
  [testObjs addObject:testObj];
  pass(testObj != nil && [testObj count] == 0,
       "can create an empty set");
   
  testObj = [NSSet setWithObject:@"Hello"];
  [testObjs addObject:testObj];
  pass(testObj != nil && [testObj count] == 1, "can create a set with one element");
  
  test_NSObject(@"NSSet", testObjs);
  test_NSCoding(testObjs);
  test_NSCopying(@"NSSet", @"NSMutableSet", testObjs, YES, NO);
  test_NSMutableCopying(@"NSSet", @"NSMutableSet", testObjs);
  

  DESTROY(arp);
  return 0;
}
