#import <Foundation/Foundation.h>
#import "Testing.h"
#import "ObjectTesting.h"

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  NSMutableURLRequest *mutable, *copy;
  NSURLProtocol *protocol;
  NSURL *httpURL;


  httpURL = [NSURL URLWithString: @"http://www.gnustep.org"];

  TEST_FOR_CLASS(@"NSURLProtocol", [NSURLProtocol alloc],
    "NSURLProtocol +alloc returns an NSURLProtocol");

  mutable = [[NSMutableURLRequest requestWithURL:httpURL] retain];
  TEST_EXCEPTION([NSURLProtocol canInitWithRequest:mutable], nil, YES,
		 "NSURLProtocol +canInitWithRequest throws an exeception (subclasses should be used)");

  pass(mutable == [NSURLProtocol canonicalRequestForRequest:mutable],
       "NSURLProtocol +canonicalRequestForRequest: return it argument");

  copy = [mutable copy];
  pass([NSURLProtocol requestIsCacheEquivalent:mutable toRequest:copy],
       "NSURLProtocol +requestIsCacheEquivalent:toRequest returns YES with a request and its copy");
  [copy setHTTPMethod:@"POST"];
  pass([NSURLProtocol requestIsCacheEquivalent:mutable toRequest:copy] == NO,
       "NSURLProtocol +requestIsCacheEquivalent:toRequest returns NO after a method change");
  [copy release];
  [mutable release];

  [arp release]; arp = nil;
  return 0;
}
