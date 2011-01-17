#import <Foundation/Foundation.h>
#import "Testing.h"
#import "ObjectTesting.h"

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  NSMutableURLRequest *mutable;
  NSURLConnection *connection;
  NSURLResponse *response;
  NSError *error;
  NSData *data;
  NSURL *httpURL;
  NSString *path;

  httpURL = [NSURL URLWithString: @"http://www.gnustep.org"];

  TEST_FOR_CLASS(@"NSURLConnection", [NSURLConnection alloc],
    "NSURLConnection +alloc returns an NSURLConnection");

  mutable = [NSMutableURLRequest requestWithURL:httpURL];
  pass([NSURLConnection canHandleRequest:mutable],
       "NSURLConnection can handle an valid HTTP request (GET)");
  [mutable setHTTPMethod:@"WRONGMETHOD"];
  pass([NSURLConnection canHandleRequest:mutable],
       "NSURLConnection can handle an invalid HTTP request (WRONGMETHOD)");

  [mutable setHTTPMethod:@"GET"];
  connection = [NSURLConnection connectionWithRequest:mutable delegate:nil];
  pass(connection != nil,
       "NSURLConnection +connectionWithRequest:delegate: with nil as delegate returns a instance");

  data = [NSURLConnection sendSynchronousRequest:mutable returningResponse:&response error:&error];
  pass(data != nil && [data length] > 0,
       "NSURLConnection synchronously load data from an http URL");
  [data release];

  path = [[NSFileManager defaultManager] currentDirectoryPath];
  path = [path stringByAppendingPathComponent:@"basic.m"];
  [mutable setURL:[NSURL fileURLWithPath:path]];
  data = [NSURLConnection sendSynchronousRequest:mutable returningResponse:&response error:&error];
  pass(data != nil && [data length] > 0,
       "NSURLConnection synchronously load data from a local file");
  [data release];

  [arp release]; arp = nil;
  return 0;
}
