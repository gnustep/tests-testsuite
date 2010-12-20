#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSXMLParser.h>
#include <string.h>

@interface      Handler : NSObject <NSXMLParserDelegate>
{
  NSMutableString       *s;
}

- (void) parser: (NSXMLParser *)parser
  didStartMappingPrefix: (NSString *)prefix
  toURI: uri;
  
- (void) parser: (NSXMLParser *)parser
  didEndMappingPrefix: (NSString *)prefix;
  
- (void) parser: (NSXMLParser *)parser
  foundCDATA: (NSString *)string;

- (void) parser: (NSXMLParser *)parser
  foundCharacters: (NSString *)string;

- (void) parser: (NSXMLParser *)parser
  didStartElement: (NSString *)elementName
  namespaceURI: (NSString *)namespaceURI
  qualifiedName: (NSString *)qualifiedName
  attributes: (NSDictionary *)attributeDict;

- (void) parser: (NSXMLParser *)parser
  didEndElement: (NSString *)elementName
  namespaceURI: (NSString *)namespaceURI
  qualifiedName: (NSString *)qName;
@end

@implementation Handler

- (void) dealloc
{
  [s release];
  [super dealloc];
}

- (NSString*) description
{
  return s;
}

- (id) init
{
  s = [NSMutableString new];
  return self;
}

- (void) parser: (NSXMLParser *)parser
  didStartMappingPrefix: (NSString *)prefix
  toURI: uri
{
  [s appendFormat: @"%@ %@\n", NSStringFromSelector(_cmd), prefix];
}
  
- (void) parser: (NSXMLParser *)parser
  didEndMappingPrefix: (NSString *)prefix
{
  [s appendFormat: @"%@ %@\n", NSStringFromSelector(_cmd), prefix];
}
  
- (void) parser: (NSXMLParser *)parser
  foundCDATA: (NSString *)string
{
  [s appendFormat: @"%@ %@\n", NSStringFromSelector(_cmd), string];
}

- (void) parser: (NSXMLParser *)parser
  foundCharacters: (NSString *)string
{
  [s appendFormat: @"%@ %@\n", NSStringFromSelector(_cmd), string];
}

- (void) parser: (NSXMLParser *)parser
  didStartElement: (NSString *)elementName
  namespaceURI: (NSString *)namespaceURI
  qualifiedName: (NSString *)qualifiedName
  attributes: (NSDictionary *)attributeDict
{
  [s appendFormat: @"%@ %@ %@ %@ %@\n", NSStringFromSelector(_cmd),
    elementName, namespaceURI, qualifiedName, attributeDict];
}

- (void) parser: (NSXMLParser *)parser
  didEndElement: (NSString *)elementName
  namespaceURI: (NSString *)namespaceURI
  qualifiedName: (NSString *)qName
{
  [s appendFormat: @"%@ %@ %@ %@\n", NSStringFromSelector(_cmd),
    elementName, namespaceURI, qName];
}

- (void) reset
{
  [s setString: @""];
}

@end

/* Use these booleans to control parsing behavior.
 */
static BOOL     setShouldProcessNamespaces = YES;
static BOOL     setShouldReportNamespacePrefixes = YES;
static BOOL     setShouldResolveExternalEntities = NO;

static BOOL
testParse(const char *xmlBytes, NSString *expect)
{
  NSAutoreleasePool     *arp = [NSAutoreleasePool new];
  Handler               *handler;
  NSXMLParser           *parser;
  NSData                *xml;

  xml = [NSData dataWithBytes: xmlBytes length: strlen(xmlBytes)];

  parser = [[NSXMLParser alloc] initWithData: xml];

  [parser setShouldProcessNamespaces: setShouldProcessNamespaces];
  [parser setShouldReportNamespacePrefixes: setShouldReportNamespacePrefixes];
  [parser setShouldResolveExternalEntities: setShouldResolveExternalEntities];

  handler = [[Handler new] autorelease];
  [parser setDelegate: handler];
  if (NO == [parser parse])
    {
      NSLog(@"%@", [parser parserError]);
      [arp release];
      return NO;
    }
  else
    {
      NSLog(@"%@", handler);
      if (NO == [[handler description] isEqual: expect]) 
        {
          [arp release];
          return NO;
        }
    }
  [arp release];
  return YES;
}

int main()
{
  NSAutoreleasePool     *arp = [NSAutoreleasePool new];
  const char            *x1 = "<?xml version=\"1.0\"?><test></test>";
  const char            *x1e = "<test></test>";
  NSString              *e1 =
@"parser:didStartElement:namespaceURI:qualifiedName:attributes: test  test {\n}\nparser:didEndElement:namespaceURI:qualifiedName: test  test\n";

  pass(testParse(x1, e1), "simple document 1");
  pass(testParse(x1e, e1), "simple document 1");

  [arp release]; arp = nil;
  return 0;
}
