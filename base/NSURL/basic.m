#import <Foundation/Foundation.h>
#import "Testing.h"
#import "ObjectTesting.h"

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  NSURL		*url;
  NSURL		*rel;
  NSData	*data;
  NSString	*str;
  NSNumber      *num;
  unichar	u = 163;
  
  TEST_FOR_CLASS(@"NSURL", [NSURL alloc],
    "NSURL +alloc returns an NSURL");
  
  TEST_FOR_CLASS(@"NSURL", [NSURL fileURLWithPath: @"."],
    "NSURL +fileURLWithPath: returns an NSURL");
  
  TEST_FOR_CLASS(@"NSURL", [NSURL URLWithString: @"http://www.w3.org/"],
    "NSURL +URLWithString: returns an NSURL");
  
  str = [NSString stringWithCharacters: &u length: 1];
  url = [NSURL fileURLWithPath: str];
  str = [[[NSFileManager defaultManager] currentDirectoryPath]
    stringByAppendingPathComponent: str];
  pass([[url path] isEqual: str], "Can put a pound sign in a file URL");
  
  str = [url scheme];
  pass([str isEqual: @"file"], "Scheme of file URL is file");

  url = [NSURL URLWithString: @"http://www.w3.org/"];
  data = [url resourceDataUsingCache: NO];
  pass(data != nil,
    "Can load a page from www.w3.org");
  num = [url propertyForKey: NSHTTPPropertyStatusCodeKey];
  pass([num isKindOfClass: [NSNumber class]] && [num intValue] == 200,
    "Status of load is 200 for www.w3.org");

  url = [NSURL URLWithString:@"this isn't a URL"];
  pass(url == nil, "URL with 'this isn't a URL' returns nil");

  url = [NSURL URLWithString: @"http://www.w3.org/silly-file-name"];
  data = [url resourceDataUsingCache: NO];
  num = [url propertyForKey: NSHTTPPropertyStatusCodeKey];
  pass([num isKindOfClass: [NSNumber class]] && [num intValue] == 404,
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

  url = [NSURL URLWithString: @"http://www.w3.org/silly-file-path/"];
  str = [url path];
  pass([str isEqual: @"/silly-file-path"],
    "Path of http://www.w3.org/silly-file-path/ is /silly-file-path");

  str = [url absoluteString];
  pass([str isEqual: @"http://www.w3.org/silly-file-path/"],
    "Abs of http://www.w3.org/silly-file-path/ is correct");

  url = [NSURL fileURLWithPath: @"/usr"];
  str = [url path];
  pass([str isEqual: @"/usr"], "Path of file URL /usr is /usr");
  pass([[url description] isEqual: @"file://localhost/usr/"],
    "File URL /usr is file://localhost/usr/");

  url = [NSURL URLWithString: @"http://here.and.there/testing/one.html"];
  rel = [NSURL URLWithString: @"aaa/bbb/ccc/" relativeToURL: url];
  pass([[rel absoluteString]
    isEqual: @"http://here.and.there/testing/aaa/bbb/ccc/"],
    "Simple relative URL absoluteString works");
  pass([[rel path]
    isEqual: @"/testing/aaa/bbb/ccc"],
    "Simple relative URL path works");
#if     GNUSTEP
  pass([[rel fullPath]
    isEqual: @"/testing/aaa/bbb/ccc/"],
    "Simple relative URL fullPath works");
#endif

  url = [NSURL URLWithString: @"http://here.and.there/testing/one.html"];
  rel = [NSURL URLWithString: @"/aaa/bbb/ccc/" relativeToURL: url];
  pass([[rel absoluteString]
    isEqual: @"http://here.and.there/aaa/bbb/ccc/"],
    "Root relative URL absoluteString works");
  pass([[rel path]
    isEqual: @"/aaa/bbb/ccc"],
    "Root relative URL path works");
#if     GNUSTEP
  pass([[rel fullPath]
    isEqual: @"/aaa/bbb/ccc/"],
    "Root relative URL fullPath works");
#endif

  url = [NSURL URLWithString: @"/aaa/bbb/ccc/"];
  pass([[url absoluteString] isEqual: @"/aaa/bbb/ccc/"],
    "absolute root URL absoluteString works");
  pass([[url path] isEqual: @"/aaa/bbb/ccc"],
    "absolute root URL path works");
#if     GNUSTEP
  pass([[url fullPath] isEqual: @"/aaa/bbb/ccc/"],
    "absolute root URL fullPath works");
#endif

  url = [NSURL URLWithString: @"aaa/bbb/ccc/"];
  pass([[url absoluteString] isEqual: @"aaa/bbb/ccc/"],
    "absolute URL absoluteString works");
  pass([[url path] isEqual: @"aaa/bbb/ccc"],
    "absolute URL path works");
#if     GNUSTEP
  pass([[url fullPath] isEqual: @"aaa/bbb/ccc/"],
    "absolute URL fullPath works");
#endif

  url = [NSURL URLWithString: @"http://127.0.0.1/"];
  pass([[url absoluteString] isEqual: @"http://127.0.0.1/"],
    "absolute http URL absoluteString works");
  pass([[url path] isEqual: @"/"],
    "absolute http URL path works");
#if     GNUSTEP
  pass([[url fullPath] isEqual: @"/"],
    "absolute http URL fullPath works");
#endif

  url = [NSURL URLWithString: @"http://127.0.0.1/ hello"];
  pass(url == nil, "space is illegal");

  url = [NSURL URLWithString: @""];
  pass([[url absoluteString] isEqual: @""],
    "empty string gives empty URL");
  pass([url path] == nil,
    "empty string gives nil path");
  pass([url scheme] == nil,
    "empty string gives nil scheme");

  url = [NSURL URLWithString: @"aaa%20ccc/"];
  pass([[url absoluteString] isEqual: @"aaa%20ccc/"],
    "absolute URL absoluteString works with encoded space");
  pass([[url path] isEqual: @"aaa ccc"],
    "absolute URL path decodes space");

  url = [NSURL URLWithString: @"/?aaa%20ccc"];
  pass([[url query] isEqual: @"aaa%20ccc"],
    "escapes are not decoded in query");

  url = [NSURL URLWithString: @"/#aaa%20ccc"];
  pass([[url fragment] isEqual: @"aaa%20ccc"],
    "escapes are not decoded in fragment");

  url = [NSURL URLWithString: @"/tmp/xxx"];
  pass([[url path] isEqual: @"/tmp/xxx"] && [url scheme] == nil,
    "a simple path becomes a simple URL");

  url = [NSURL URLWithString: @"filename"];
  pass([[url path] isEqual: @"filename"] && [url scheme] == nil,
    "a simple file name becomes a simple URL");

  url = [NSURL URLWithString: @"file://localhost/System/Library/"
    @"Documentation/Developer/Gui/Reference/index.html"]; 

  str = @"NSApplication.html"; 
  rel = [NSURL URLWithString: str relativeToURL: url]; 
// NSLog(@"with link %@, obtained URL: %@ String: %@", str, rel, [rel absoluteString]); 
  pass([[rel absoluteString] isEqual: @"file://localhost/System/Library/Documentation/Developer/Gui/Reference/NSApplication.html"], "Adding a relative file URL works");
  str = @"NSApplication.html#class$NSApplication"; 
  rel = [NSURL URLWithString: str relativeToURL: url]; 
//NSLog(@"with link %@, obtained URL: %@ String: %@", str, rel, [rel absoluteString]); 
  pass([[rel absoluteString] isEqual: @"file://localhost/System/Library/Documentation/Developer/Gui/Reference/NSApplication.html#class$NSApplication"], "Adding relative file URL with fragment works");

  /* Test fileUrlWithPath: for messy/complex path
   */
  url = [NSURL fileURLWithPath: @"/this#is a Path with % < > ?"];
  //NSLog(@"%@", [url path]);
  pass([[url path] isEqual: @"/this#is a Path with % < > ?"], "complex -path");
  //NSLog(@"%@", [url fragment]);
  pass([url fragment] == nil, "complex -fragment");
  //NSLog(@"%@", [url parameterString]);
  pass([url parameterString] == nil, "complex -parameterString");
  //NSLog(@"%@", [url query]);
  pass([url query] == nil, "complex -query");
  //NSLog(@"%@", [url absoluteString]);
  pass([[url absoluteString] isEqual:
    @"file://localhost/this%23is%20a%20Path%20with%20%25%20%3C%20%3E%20%3F"],
    "complex -absoluteString");
  pass([[url relativeString] isEqual:
    @"file://localhost/this%23is%20a%20Path%20with%20%25%20%3C%20%3E%20%3F"],
    "complex -relativeString");
  pass([[url description] isEqual:
    @"file://localhost/this%23is%20a%20Path%20with%20%25%20%3C%20%3E%20%3F"],
    "complex -description");

  [arp release]; arp = nil;
  return 0;
}
