#import <Foundation/Foundation.h>
#import "Testing.h"
#import "ObjectTesting.h"

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  Class cls;
  NSURL *httpURL, *foobarURL;
  id handle1, handle2;

  httpURL = [NSURL URLWithString: @"http://www.gnustep.org"];
  foobarURL = [NSURL URLWithString: @"foobar://localhost/madeupscheme"];

  TEST_FOR_CLASS(@"NSURLHandle", [NSURLHandle alloc],
    "NSURLHandle +alloc returns an NSURLHandle");

  cls = [NSURLHandle URLHandleClassForURL: httpURL];

  pass([cls canInitWithURL: httpURL] == YES,
    "Appropriate subclass found for +URLHandleClassForURL:");
  handle1 = [[cls alloc] initWithURL: httpURL cached: YES];
  handle2 = [NSURLHandle cachedHandleForURL: httpURL];

  pass(handle2 != nil, "Available handle returned from cache");

  [handle1 autorelease];
  [cls autorelease];

  cls = [NSURLHandle URLHandleClassForURL: foobarURL];

  pass(cls == Nil, "Nil class returned for unknown URL scheme");

  IF_NO_GC(DESTROY(arp));
  return 0;
}
