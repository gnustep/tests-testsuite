#include <Foundation/Foundation.h>
#include "Testing.h"
#include "ObjectTesting.h"

/* This test collection examines the responses when a variety of HTTP
* status codes are returned by the server. Relies on the
* StatusServer helper tool.
*
* Graham J Lee < leeg@thaesofereode.info >
*/

int main(int argc, char **argv)
{
  CREATE_AUTORELEASE_POOL(arp) ;
  
  NSString *helpers;
  NSString *statusServer;
  NSURL *url;
  NSURLHandle *handle;
  NSTask *t;
  Class cls;
  NSData *resp;
  NSData *rxd;
  
  url = [NSURL URLWithString: @"http://localhost:54321/200"];
  cls = [NSURLHandle URLHandleClassForURL: url];
  resp = [NSData dataWithBytes: "Hello\r\n" length: 7];
  
  helpers = [[NSFileManager defaultManager] currentDirectoryPath];
  helpers = [helpers stringByAppendingPathComponent: @"Helpers"];
  helpers = [helpers stringByAppendingPathComponent: @"obj"];
  statusServer = [helpers stringByAppendingPathComponent: @"StatusServer"];
  
  t = [NSTask launchedTaskWithLaunchPath: statusServer arguments: nil];
  
  if (t != nil)
    {
      // pause, so that the server is set up
      [NSThread sleepUntilDate: [NSDate dateWithTimeIntervalSinceNow: 0.5]];
      // try some different requests
      handle = [[[cls alloc] initWithURL: url cached: NO] autorelease];
      rxd = [handle loadInForeground];
      pass([rxd isEqual: resp],
           "Got the correct data from a 200 - status load") ;
      pass([handle status] == NSURLHandleLoadSucceeded,
           "200 - status: Handle load succeeded") ;
      
      url = [NSURL URLWithString: @"http://localhost:54321/401"];
      handle = [[[cls alloc] initWithURL: url cached: NO] autorelease];
      rxd = [handle loadInForeground];
      pass([handle status] == NSURLHandleNotLoaded,
           "401 - status: Handle load not loaded (unanswered auth challenge)");
    }
  
  DESTROY(arp) ;
  
  return 0;
}

