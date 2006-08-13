#import <Foundation/Foundation.h>
#import "Testing.h"
#import "ObjectTesting.h"

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSURL		*url;
  NSData	*data;
  NSString	*str;
  unichar	u = 163;
  
  TEST_FOR_CLASS(@"NSURL", [NSURL alloc],
    "NSURL +alloc returns an NSURL");
  
  TEST_FOR_CLASS(@"NSURL", [NSURL fileURLWithPath: @"."],
    "NSURL +fileURLWithPath: returns an NSURL");
  
  TEST_FOR_CLASS(@"NSURL", [NSURL URLWithString: @"http://www.w3.org/"],
    "NSURL +URLWithString: returns an NSURL");
  
  str = [NSString stringWithCharacters: &u length: 1];
  url = [NSURL fileURLWithPath: str];
  pass([[url path] isEqual: str], "Can put a pound sign in a file URL");
  
  url = [NSURL URLWithString: @"http://www.w3.org/"];
  data = [url resourceDataUsingCache: NO];
  pass(data != nil,
    "Can load a page from www.w3.org");
  str = [url propertyForKey: NSHTTPPropertyStatusCodeKey];
  pass([str isEqual: @"200"],
    "Status of load is 200 for www.w3.org");

  url = [NSURL URLWithString: @"http://www.w3.org/silly-file-name"];
  data = [url resourceDataUsingCache: NO];
  str = [url propertyForKey: NSHTTPPropertyStatusCodeKey];
  pass([str isEqual: @"404"],
    "Status of load is 404 for www.w3.org/silly-file-name");
  
  DESTROY(arp);
  return 0;
}