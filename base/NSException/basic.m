#import <Foundation/NSException.h>
#import <Foundation/NSAutoreleasePool.h>
#import "ObjectTesting.h"

@interface      MyClass : NSObject
+ (void) testAbc;
@end
@implementation MyClass
+ (void) testAbc
{
  [NSException raise: NSGenericException format: @"In MyClass"];
}
@end

int main()
{
  NSException *obj;
  NSMutableArray *testObjs = [[NSMutableArray alloc] init];
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];

  test_alloc_only(@"NSException"); 
  obj = [NSException exceptionWithName: NSGenericException
                                reason: nil
                              userInfo: nil];
  pass((obj != nil), "can create an exception");
  pass(([[obj name] isEqualToString: NSGenericException]), "name works");
  obj = [NSException exceptionWithName: NSGenericException
                                reason: nil
                              userInfo: nil];
  [testObjs addObject: obj];
  test_NSObject(@"NSException", testObjs);
  
  NS_DURING
    [MyClass testAbc];
  NS_HANDLER
    {
      NSArray *a = [localException callStackSymbols];
      NSEnumerator *e = [a objectEnumerator];
      NSString  *s = nil;

NSLog(@"%@ %@", localException, a);

      while ((s = [e nextObject]) != nil)
        if ([s rangeOfString: @"testAbc"].length > 0)
          break;
      pass(s != nil, "working callStackSymbols");
    }
  NS_ENDHANDLER
  [arp release]; arp = nil;
  return 0;
}
