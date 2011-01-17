#import <Foundation/Foundation.h>
#import "Testing.h"
#import "ObjectTesting.h"

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  NSURLRequest *request;
  NSMutableURLRequest *mutable;
  NSURL *httpURL, *foobarURL;


  httpURL = [NSURL URLWithString: @"http://www.gnustep.org"];
  foobarURL = [NSURL URLWithString: @"foobar://localhost/madeupscheme"];

  TEST_FOR_CLASS(@"NSURLRequest", [NSURLRequest alloc],
    "NSURLRequest +alloc returns an NSURLRequest");

  request = [[NSURLRequest requestWithURL:httpURL] retain];
  pass(request != nil,
       "NSURLRequest +requestWithURL returns a request from a valid URL");
  pass([[[request URL] absoluteString] isEqualToString:[httpURL absoluteString]],
       "Request URL is equal to the URL used for creation");
  pass([@"GET" isEqualToString:[request HTTPMethod]],
       "Request is initialized with a GET method");

  request = [NSURLRequest requestWithURL:foobarURL];
  pass(request != nil,
       "NSURLRequest +requestWithURL returns a request from an invalid URL (unknown scheme)");
  
  mutable = [request mutableCopy];
  pass(mutable != nil && [mutable isKindOfClass:[NSMutableURLRequest class]],
       "NSURLRequest -mutableCopy returns a mutable request");
  [mutable setHTTPMethod:@"POST"];
  pass([@"POST" isEqualToString:[mutable HTTPMethod]],
       "Can setHTTPMethod of a mutable request (POST)");
  [mutable setHTTPMethod:@"NONHTTPMETHOD"];
  pass([@"NONHTTPMETHOD" isEqualToString:[mutable HTTPMethod]],
       "Can setHTTPMethod of a mutable request (non existant NONHTTPMETHOD)");

  [mutable addValue:@"value1" forHTTPHeaderField:@"gnustep"];
  pass([@"value1" isEqualToString:[mutable valueForHTTPHeaderField:@"gnustep"]],
       "Can set and get a value for an HTTP header field");
  [mutable addValue:@"value2" forHTTPHeaderField:@"gnustep"];
  pass([@"value1,value2" isEqualToString:[mutable valueForHTTPHeaderField:@"gnustep"]],
       "Handle multiple values for an HTTP header field");
  [mutable release];
  [request release];

  [arp release]; arp = nil;
  return 0;
}
