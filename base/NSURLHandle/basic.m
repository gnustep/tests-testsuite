#import <Foundation/Foundation.h>
#import "Testing.h"
#import "ObjectTesting.h"

@interface DummyHandle : NSURLHandle
@end
@implementation DummyHandle
@end

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  Class cls;
  NSURL *httpURL, *foobarURL;
  id handle1, handle2;


  httpURL = [NSURL URLWithString: @"http://www.gnustep.org"];
  foobarURL = [NSURL URLWithString: @"foobar://localhost/madeupscheme"];

  TEST_FOR_CLASS(@"NSURLHandle", [NSURLHandle alloc],
    "NSURLHandle +alloc returns an NSURLHandle");

  TEST_EXCEPTION([DummyHandle cachedHandleForURL: httpURL];,
    NSInvalidArgumentException, YES, 
    "NSURLHandle subclass must implement +cachedHandleForURLL");

  cls = [NSURLHandle URLHandleClassForURL: httpURL];

  pass([cls canInitWithURL: httpURL] == YES,
    "Appropriate subclass found for +URLHandleClassForURL:");
  handle1 = [[cls alloc] initWithURL: httpURL cached: YES];
  handle2 = [NSURLHandle cachedHandleForURL: httpURL];

  pass(handle2 != nil, "Available handle returned from cache");

  [handle1 autorelease];
  [cls autorelease];

#if	!defined(GNUSTEP_BASE_LIBRARY)
  pass(NO, "URLHandleClassForURL: seems to hang on MacOS-X when given an unknown URL scheme ... you may want to check to see if it has been fixed");
#else
  cls = [NSURLHandle URLHandleClassForURL: foobarURL];
  pass(cls == Nil, "Nil class returned for unknown URL scheme");
#endif

  [arp release]; arp = nil;
  return 0;
}
