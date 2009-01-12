#import "Testing.h"
#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSString.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSMutableArray *testObjs = [NSMutableArray new];
  NSDictionary *obj;
  test_alloc(@"NSDictionary");
  obj = [NSDictionary new];
  [testObjs addObject:obj];
  pass(obj != nil && 
       [obj isKindOfClass:[NSDictionary class]] &&
       [obj count] == 0,
       "can create an empty dictionary");
  obj = [NSDictionary dictionaryWithObject:@"Hello" forKey:@"Key"];
  [testObjs addObject:obj];
  pass(obj != nil && 
       [obj isKindOfClass:[NSDictionary class]] &&
       [obj count] == 1, 
       "can create a dictionary with one element");
  
  test_NSObject(@"NSDictionary", testObjs);
  test_NSCoding(testObjs);
  test_NSCopying(@"NSDictionary", @"NSMutableDictionary", testObjs, YES, NO);
  test_NSMutableCopying(@"NSDictionary", @"NSMutableDictionary", testObjs);

  IF_NO_GC(DESTROY(arp));
  return 0;
}
