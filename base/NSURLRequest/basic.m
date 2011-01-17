#import <Foundation/Foundation.h>
#import "Testing.h"
#import "ObjectTesting.h"

int main()
{
  NSAutoreleasePool     *arp = [NSAutoreleasePool new];
  NSURLRequest          *request;
  NSMutableURLRequest   *mutable;
  NSURL                 *httpURL, *foobarURL;

  httpURL = [NSURL URLWithString: @"http://www.gnustep.org"];
  foobarURL = [NSURL URLWithString: @"foobar://localhost/madeupscheme"];

  TEST_FOR_CLASS(@"NSURLRequest", [NSURLRequest alloc],
    "NSURLRequest +alloc returns an NSURLRequest");

  request = [NSURLRequest requestWithURL: httpURL];
  pass(request != nil,
    "NSURLRequest +requestWithURL returns a request from a valid URL");
  passeq([[request URL] absoluteString], [httpURL absoluteString],
    "Request URL is equal to the URL used for creation");
  passeq([request HTTPMethod], @"GET",
    "Request is initialized with a GET method");

  request = [NSURLRequest requestWithURL: foobarURL];
  pass(request != nil,
    "NSURLRequest +requestWithURL returns a request from an invalid URL (unknown scheme)");
  
  mutable = [request mutableCopy];
  pass(mutable != nil && [mutable isKindOfClass:[NSMutableURLRequest class]],
    "NSURLRequest -mutableCopy returns a mutable request");
  [mutable setHTTPMethod: @"POST"];
  passeq([mutable HTTPMethod], @"POST",
    "Can setHTTPMethod of a mutable request (POST)");
  [mutable setHTTPMethod: @"NONHTTPMETHOD"];
  passeq([mutable HTTPMethod], @"NONHTTPMETHOD",
    "Can setHTTPMethod of a mutable request (non existant NONHTTPMETHOD)");

  [mutable addValue: @"value1" forHTTPHeaderField: @"gnustep"];
  passeq([mutable valueForHTTPHeaderField: @"gnustep"], @"value1",
    "Can set and get a value for an HTTP header field");
  [mutable addValue: @"value2" forHTTPHeaderField: @"gnustep"];
  pass([mutable valueForHTTPHeaderField: @"gnustep"], @"value1,value2",
    "Handle multiple values for an HTTP header field");
  [mutable release];

  [arp release]; arp = nil;
  return 0;
}
