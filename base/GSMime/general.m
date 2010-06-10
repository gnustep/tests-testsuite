#if     defined(GNUSTEP_BASE_LIBRARY)
#import <Foundation/Foundation.h>
#import <GNUstepBase/GSMime.h>
#import "Testing.h"

static GSMimeDocument *
parse(GSMimeParser *parser, NSData *data)
{
  unsigned	length = [data length];
  unsigned	index;

  for (index = 0; index < length-1; index++)
    {
      NSAutoreleasePool	*arp = [NSAutoreleasePool new];
      NSData		*d;

      d = [data subdataWithRange: NSMakeRange(index, 1)];
      if ([parser parse: d] == NO)
	{
	  return [parser mimeDocument];
	}
      [arp release];
    }
  data = [data subdataWithRange: NSMakeRange(index, 1)];
  if ([parser parse: data] == YES)
    {
      [parser parse: nil];
    }
  return [parser mimeDocument];
}

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  NSData *data;
  GSMimeDocument *doc;
  GSMimeDocument *idoc;

  data = [NSData dataWithContentsOfFile:@"mime1.dat"];
  idoc = parse([[GSMimeParser new] autorelease], data);
  pass(([[[[idoc content] objectAtIndex:0] content] isEqual: @"a"]),
       "can parse one char base64 mime1.dat incrementally");
  doc = [GSMimeParser documentFromData:data];
  pass(([[[[doc content] objectAtIndex:0] content] isEqual: @"a"]),
       "can parse one char base64 mime1.dat in one go");
  pass([idoc isEqual: doc], "mime1.dat documents are the same");
  
  data = [NSData dataWithContentsOfFile:@"mime2.dat"];
  idoc = parse([[GSMimeParser new] autorelease], data);
  pass(([[idoc content] isEqual: @"aa"]),
    "can parse two char base64 mime2.dat incrementally");
  doc = [GSMimeParser documentFromData:data];
  pass(([[doc content] isEqual: @"aa"]),
    "can parse two char base64 mime2.dat in one go");
  pass([idoc isEqual: doc], "mime2.dat documents are the same");
 
  data = [NSData dataWithContentsOfFile:@"mime3.dat"];
  idoc = parse([[GSMimeParser new] autorelease], data);
  pass(([[idoc content] isEqual: @"aaa"]),
    "can parse three char base64 mime3.dat incrementally");
  doc = [GSMimeParser documentFromData:data];
  pass(([[doc content] isEqual: @"aaa"]),
    "can parse three char base64 mime3.dat in one go");
  pass([idoc isEqual: doc], "mime3.dat documents are the same");
   
  data = [NSData dataWithContentsOfFile:@"mime4.dat"];
  idoc = parse([[GSMimeParser new] autorelease], data);
  pass(([[[[idoc content] objectAtIndex:0] content] isEqual: @"hello\n"]
    && [[[[idoc content] objectAtIndex:1] content] isEqual: @"there\n"]),
    "can parse multi-part text mime4.dat incrementally");
  pass(([[[[idoc content] objectAtIndex:0] contentFile] isEqual: @"a.a"]),
   "can extract content file name from mime4.dat (incrementally parsed)");
  pass(([[[[idoc content] objectAtIndex:0] contentType] isEqual: @"text"]),
   "can extract content type from mime4.dat (incrementally parsed)");
  pass(([[[[idoc content] objectAtIndex:0] contentSubtype] isEqual: @"plain"]),
   "can extract content sub type from mime4.dat (incrementally parsed)");
    
  doc = [GSMimeParser documentFromData:data];
  pass(([[[[doc content] objectAtIndex:0] content] isEqual: @"hello\n"]
    && [[[[doc content] objectAtIndex:1] content] isEqual: @"there\n"]),
    "can parse multi-part text mime4.dat in one go");
  pass(([[[[doc content] objectAtIndex:0] contentFile] isEqual: @"a.a"]),
   "can extract content file name from mime4.dat (parsed in one go)");
  pass(([[[[doc content] objectAtIndex:0] contentType] isEqual: @"text"]),
   "can extract content type from mime4.dat (parsed in one go)");
  pass(([[[[doc content] objectAtIndex:0] contentSubtype] isEqual: @"plain"]),
   "can extract content sub type from mime4.dat (parsed in one go)");
  pass([idoc isEqual: doc], "mime4.dat documents are the same");
    
  data = [NSData dataWithContentsOfFile:@"mime5.dat"];
  idoc = parse([[GSMimeParser new] autorelease], data);
  pass(([[idoc contentSubtype] isEqual: @"xml"]),
   "can parse http document mime5.dat incrementally"); 
  doc = [GSMimeParser documentFromData:data];
  pass(([[doc contentSubtype] isEqual: @"xml"]),
   "can parse http document mime5.dat in one go"); 
  pass([idoc isEqual: doc], "mime5.dat documents are the same");
  
  data = [NSData dataWithContentsOfFile:@"mime6.dat"];
  idoc = parse([[GSMimeParser new] autorelease], data);
  pass(([[idoc content] count] == 3),
    "can parse multipart mixed mime6.dat incrementally"); 
  doc = [GSMimeParser documentFromData:data];
  pass(([[doc content] count] == 3),
    "can parse multipart mixed mime6.dat in one go"); 
  pass([idoc isEqual: doc], "mime6.dat documents are the same");
 
  data = [NSData dataWithContentsOfFile:@"mime7.dat"];
  pass(([[[[doc content] objectAtIndex:1] content] isEqual: data]),
   "mime6.dat binary data part matches mime7.dat");

  data = [NSData dataWithContentsOfFile:@"mime9.dat"];
  idoc = parse([[GSMimeParser new] autorelease], data);
  pass(([[[idoc headerNamed: @"Long"] value] isEqual: @"first second third"]),
   "mime9.dat folded header unfolds correctly incrementally");
  doc = [GSMimeParser documentFromData:data];
//NSLog(@"'%@'", [[doc headerNamed: @"Long"] value]);
  pass(([[[doc headerNamed: @"Long"] value] isEqual: @"first second third"]),
   "mime9.dat folded header unfolds correctly in one go");
  pass([idoc isEqual: doc], "mime9.dat documents are the same");

  
  [arp release]; arp = nil;
  return 0;
}
#else
int main(int argc,char **argv)
{
  return 0;
}
#endif
