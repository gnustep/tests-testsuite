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
  
  str = [url scheme];
  pass([str isEqual: @"file"], "Scheme of file URL is file");

  url = [NSURL URLWithString: @"http://www.w3.org/"];
  data = [url resourceDataUsingCache: NO];
  pass(data != nil,
    "Can load a page from www.w3.org");
  str = [url propertyForKey: NSHTTPPropertyStatusCodeKey];
  pass([str isEqual: @"200"],
    "Status of load is 200 for www.w3.org");

  url = [NSURL URLWithString:@"this isn't a URL"];
  pass(url == nil, "URL with 'this isn't a URL' returns nil");

  url = [NSURL URLWithString: @"http://www.w3.org/silly-file-name"];
  data = [url resourceDataUsingCache: NO];
  str = [url propertyForKey: NSHTTPPropertyStatusCodeKey];
  pass([str isEqual: @"404"],
    "Status of load is 404 for www.w3.org/silly-file-name");

  str = [url scheme];
  pass([str isEqual: @"http"],
       "Scheme of http://www.w3.org/silly-file-name is http");
  str = [url host];
  pass([str isEqual: @"www.w3.org"],
    "Host of http://www.w3.org/silly-file-name is www.w3.org");
  str = [url path];
  pass([str isEqual: @"/silly-file-name"],
    "Path of http://www.w3.org/silly-file-name is /silly-file-name");

  IF_NO_GC(DESTROY(arp));
  return 0;
}
