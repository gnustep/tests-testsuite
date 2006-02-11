#include <Foundation/Foundation.h>
#include <GNUstepBase/GSXML.h>
#include "Testing.h"
#include "ObjectTesting.h"
int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  GSXMLDocument *doc;
  volatile GSXMLNamespace *namespace;
  GSXMLNode *node;

  TEST_FOR_CLASS(@"GSXMLDocument",[GSXMLDocument alloc],"GSXMLDocument +alloc returns a GSXMLDocument");
  
  TEST_FOR_CLASS(@"GSXMLDocument",[GSXMLDocument documentWithVersion:@"1.0"],"GSXMLDocument +documentWithVersion: returns a GSXMLDocument");
  
  TEST_FOR_CLASS(@"GSXMLNode",[GSXMLNode alloc],"GSXMLNode +alloc returns a GSXMLNode");
  
  NS_DURING
    node = [GSXMLNode new]; 
    pass(node == nil, "GSXMLNode +new returns nil");
  NS_HANDLER
    pass(node == nil, "GSXMLNode +new returns nil");
  NS_ENDHANDLER
  
  TEST_FOR_CLASS(@"GSXMLNamespace",[GSXMLNamespace alloc],"GSXMLNamespace +alloc returns a GSXMLNamespace");
  

  NS_DURING
    namespace = [GSXMLNamespace new]; 
    pass(namespace == nil, "GSXMLNamespace +new returns nil");
  NS_HANDLER
    pass(namespace == nil, "GSXMLNamespace +new returns nil");
  NS_ENDHANDLER
  
  doc = [GSXMLDocument documentWithVersion:@"1.0"];
  node = [doc makeNodeWithNamespace:nil name: @"nicola" content:nil]; 
  pass (node != nil,"Can create a document node");
  
  
  [doc setRoot:node];
  pass([[doc root] isEqual:node],"Can set document node as root node");
  
  [doc makeNodeWithNamespace:nil name: @"nicola" content:nil];
  [node makeChildWithNamespace:nil name:@"paragraph" content:@"Hi this is some text"];
  [node makeChildWithNamespace:nil name:@"paragraph" content:@"Hi this is even some more text"];
  [doc setRoot:node];
  pass([[doc root] isEqual:node], "Can set a document node (with children) as root node");
  
  namespace = [node makeNamespaceHref:@"http://www.gnustep.org" prefix:@"gnustep"];
  pass(namespace != nil,"Can create a node namespace");
  
  node = [doc makeNodeWithNamespace:namespace name:@"nicola" content:nil];
  pass([[node namespace] isEqual:namespace],"Can create a node with a namespace");

  node = [doc makeNodeWithNamespace:namespace name:@"another" content:nil];
  pass([[node namespace] isEqual:namespace],"Can create a node with same namespace as another node");
  
  pass([[namespace prefix] isEqual:@"gnustep"],"A namespace remembers its prefix");
  
  DESTROY(arp);
  return 0;
}
