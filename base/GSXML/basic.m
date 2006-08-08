#import <Foundation/Foundation.h>
#import <GNUstepBase/GSXML.h>
#import "Testing.h"
#import "ObjectTesting.h"
int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  GSXMLDocument *doc;
  volatile GSXMLNamespace *namespace;
  NSMutableArray *iparams;
  NSMutableArray *oparams;
  GSXMLNode	*node;
  GSXMLRPC	*rpc;
  NSString	*str;
  NSData	*dat;

  TEST_FOR_CLASS(@"GSXMLDocument",[GSXMLDocument alloc],
    "GSXMLDocument +alloc returns a GSXMLDocument");
  
  TEST_FOR_CLASS(@"GSXMLDocument",[GSXMLDocument documentWithVersion: @"1.0"],
    "GSXMLDocument +documentWithVersion: returns a GSXMLDocument");
  
  TEST_FOR_CLASS(@"GSXMLNode",[GSXMLNode alloc],
    "GSXMLNode +alloc returns a GSXMLNode");
  
  TEST_FOR_CLASS(@"GSXMLRPC",[GSXMLRPC alloc],
    "GSXMLRPC +alloc returns a GSXMLRPC instance");

  NS_DURING
    node = [GSXMLNode new]; 
    pass(node == nil, "GSXMLNode +new returns nil");
  NS_HANDLER
    pass(node == nil, "GSXMLNode +new returns nil");
  NS_ENDHANDLER
  
  TEST_FOR_CLASS(@"GSXMLNamespace",[GSXMLNamespace alloc],
    "GSXMLNamespace +alloc returns a GSXMLNamespace");
  

  NS_DURING
    namespace = [GSXMLNamespace new]; 
    pass(namespace == nil, "GSXMLNamespace +new returns nil");
  NS_HANDLER
    pass(namespace == nil, "GSXMLNamespace +new returns nil");
  NS_ENDHANDLER
  
  doc = [GSXMLDocument documentWithVersion: @"1.0"];
  node = [doc makeNodeWithNamespace: nil name: @"nicola" content: nil]; 
  pass (node != nil,"Can create a document node");
  
  
  [doc setRoot: node];
  pass([[doc root] isEqual: node],"Can set document node as root node");
  
  [doc makeNodeWithNamespace: nil name: @"nicola" content: nil];
  [node makeChildWithNamespace: nil
			  name: @"paragraph"
		       content: @"Hi this is some text"];
  [node makeChildWithNamespace: nil
			  name: @"paragraph"
		       content: @"Hi this is even some more text"];
  [doc setRoot: node];
  pass([[doc root] isEqual: node],
    "Can set a document node (with children) as root node");
  
  namespace = [node makeNamespaceHref: @"http: //www.gnustep.org"
			       prefix: @"gnustep"];
  pass(namespace != nil,"Can create a node namespace");
  
  node = [doc makeNodeWithNamespace: namespace name: @"nicola" content: nil];
  pass([[node namespace] isEqual: namespace],
    "Can create a node with a namespace");

  node = [doc makeNodeWithNamespace: namespace name: @"another" content: nil];
  pass([[node namespace] isEqual: namespace],
    "Can create a node with same namespace as another node");
  
  pass([[namespace prefix] isEqual: @"gnustep"],
    "A namespace remembers its prefix");
  

  rpc = [[GSXMLRPC alloc] initWithURL: @"http://localhost/"];
  pass(rpc != nil, "Can initialise an RPC instance");

  iparams = [NSMutableArray array];
  oparams = [NSMutableArray array];

  dat = [rpc buildMethod: @"method" params: nil];
  pass(dat != nil, "Can build an empty method call (nil params)");
  str = [rpc parseMethod: dat params: oparams];
  pass([str isEqual: @"method"] && [iparams isEqual: oparams],
    "Can parse an empty method call (nil params)");

  dat = [rpc buildMethod: @"method" params: iparams];
  pass(dat != nil, "Can build an empty method call");
  str = [rpc parseMethod: dat params: oparams];
  pass([str isEqual: @"method"] && [iparams isEqual: oparams],
    "Can parse an empty method call");

  [iparams addObject: @"a string"];
  dat = [rpc buildMethod: @"method" params: iparams];
  pass(dat != nil, "Can build a method call with a string");
  str = [rpc parseMethod: dat params: oparams];
  pass([str isEqual: @"method"] && [iparams isEqual: oparams],
    "Can parse a method call with a string");

  [rpc setCompact: YES];
  str = [rpc buildMethodCall: @"method" params: iparams];
  [rpc setCompact: NO];
  str = [str stringByReplacingString: @"<string>" withString: @""];
  str = [str stringByReplacingString: @"</string>" withString: @""];
  str = [rpc parseMethod: [str dataUsingEncoding: NSUTF8StringEncoding]
  		  params: oparams];
  pass([str isEqual: @"method"] && [iparams isEqual: oparams],
    "Can parse a method call with a string without the <string> element");

  [iparams addObject: [NSNumber numberWithInt: 4]];
  dat = [rpc buildMethod: @"method" params: iparams];
  pass(dat != nil, "Can build a method call with an integer");
  str = [rpc parseMethod: dat params: oparams];
  pass([str isEqual: @"method"] && [iparams isEqual: oparams],
    "Can parse a method call with an integer");

  [iparams addObject: [NSNumber numberWithFloat: 4.5]];
  dat = [rpc buildMethod: @"method" params: iparams];
  pass(dat != nil, "Can build a method call with a float");
  str = [rpc parseMethod: dat params: oparams];
  pass([str isEqual: @"method"] && [iparams isEqual: oparams],
    "Can parse a method call with a float");

  [iparams addObject: [NSData dataWithBytes: "1234" length: 4]];
  dat = [rpc buildMethod: @"method" params: iparams];
  pass(dat != nil, "Can build a method call with binary data");
  str = [rpc parseMethod: dat params: oparams];
  pass([str isEqual: @"method"] && [iparams isEqual: oparams],
    "Can parse a method call with binary data");

  [iparams addObject: [NSDate date]];
  dat = [rpc buildMethod: @"method" params: iparams];
  pass(dat != nil, "Can build a method call with a date");
  str = [rpc parseMethod: dat params: oparams];
  pass([str isEqual: @"method"]
    && [[iparams description] isEqual: [oparams description]],
    "Can parse a method call with a date");


  DESTROY(arp);
  return 0;
}
