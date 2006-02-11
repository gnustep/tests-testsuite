#include <Foundation/Foundation.h>
#include <GNUstepBase/GSMime.h>
#include "Testing.h"

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  GSMimeParser *parser = [GSMimeParser mimeParser];
  NSStringEncoding enc = [GSMimeDocument encodingFromCharset: @"utf-8"];
  NSData *data;
  GSMimeDocument *doc = RETAIN([parser mimeDocument]);

  data = [@"Content-type: application/xxx\r\n" dataUsingEncoding: enc];
  pass([parser parse:data] && [parser isInHeaders] && (doc != nil),
       "can parse one header");

  pass([doc contentType] == nil, "First Header not complete until next starts");

  data = [@"Content-id: <" dataUsingEncoding:enc];
  pass([parser parse: data] &&
       [parser isInHeaders],
       "Adding partial headers is ok");

  pass([[doc contentType] isEqual: @"application"] &&
       [[doc contentSubtype] isEqual:@"xxx"],"Parsed first header as expected");

  data = [@"hello>\r\n" dataUsingEncoding: enc];
  pass([parser parse: data] &&
       [parser isInHeaders],
       "Completing partial header is ok");

  pass([doc contentID] == nil, "Partial header not complete until next starts");

  data = [@"Folded\r\n : testing\r\n" dataUsingEncoding:enc];
  pass([parser parse:data] && [parser isInHeaders], "Folded header is ok");
  
  pass([@"<hello>" isEqual: [doc contentID]],"Parsed partial header as expected %s",[[doc contentID] cString]);
 
  pass([doc headerNamed: @"Folded"] == nil,"Folded header not complete until next starts");

  data = [@"\r" dataUsingEncoding:enc];
  pass([parser parse:data] && [parser isInHeaders], "partial end-of-line is ok");

  pass([[[doc headerNamed:@"Folded"] value] isEqual: @"testing"],"Parsed folded header as expected %s",[[[doc headerNamed:@"Folded"] value] cString]);

  data = [@"\n" dataUsingEncoding:enc];
  pass([parser parse:data] && ![parser isInHeaders], "completing end-of-line is ok");
  
  doc = [GSMimeDocument documentWithContent:[@"\"\\UFE66???\"" propertyList]
  					type:@"text/plain"
					name:nil];
  [doc rawMimeData];
  pass([[[doc headerNamed:@"content-type"] parameterForKey:@"charset"] isEqual:@"utf-8"],"charset is inferred");

  
  
  DESTROY(arp);
  return 0;
}

