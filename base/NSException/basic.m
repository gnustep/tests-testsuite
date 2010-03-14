#import <Foundation/NSException.h>
#import <Foundation/NSAutoreleasePool.h>
#import "ObjectTesting.h"

static void
handler(NSException *e)
{
  pass (YES == [[e reason] isEqual: @"Terminate"],
    "uncaught exceptionhandler called as expected");
  abort();
}

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

      while ((s = [e nextObject]) != nil)
        if ([s rangeOfString: @"testAbc"].length > 0)
          break;
      pass(s != nil, "working callStackSymbols ... if this has failed it is probably due to a lack of support for objective-c method names (local symbols) in the backtrace_symbols() function of your libc. If so, you might lobby your operating system provider for a fix.");
    }
  NS_ENDHANDLER

  pass(NSGetUncaughtExceptionHandler() == 0, "default handler is null");
  NSSetUncaughtExceptionHandler(handler);
  pass(NSGetUncaughtExceptionHandler() == handler, "setting handler works");

  fprintf(stderr, "We expect a single FAIL without any explanation as\n"
    "the test is terminated by an uncaught exception ...\n");
  [NSException raise: NSGenericException format: @"Terminate"];
  pass(NO, "shouldn't get here ... exception should have terminated process");

  [arp release]; arp = nil;
  return 0;
}
