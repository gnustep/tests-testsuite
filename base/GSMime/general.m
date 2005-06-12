#include <Foundation/Foundation.h>
#include <GNUstepBase/GSMime.h>
#include "Testing.h"

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSData *data;
  GSMimeParser *parser;
  GSMimeDocument *doc;

  data = [NSData dataWithContentsOfFile:@"mime1.dat"];
  doc = [GSMimeParser documentFromData:data];
  pass(([[[[doc content] objectAtIndex:0] content] isEqual: @"a"]),
       "can parse one char base64 mime1.dat");
  
  data = [NSData dataWithContentsOfFile:@"mime2.dat"];
  doc = [GSMimeParser documentFromData:data];
  pass(([[doc content] isEqual: @"aa"]), "can parse two char base64 mime2.dat");
 
 
  data = [NSData dataWithContentsOfFile:@"mime3.dat"];
  doc = [GSMimeParser documentFromData:data];
  pass(([[doc content] isEqual: @"aaa"]), "can parse three char base64 mime3.dat");
   
   
  data = [NSData dataWithContentsOfFile:@"mime4.dat"];
  doc = RETAIN([GSMimeParser documentFromData:data]);
  pass(([[[[doc content] objectAtIndex:0] content] isEqual: @"hello\n"] &&
       [[[[doc content] objectAtIndex:1] content] isEqual: @"there\n"]),
       "can parse multi-part text mime4.dat");
  
  pass(([[[[doc content] objectAtIndex:0] contentFile] isEqual: @"a.a"]),
       "can extract content file name from mime4.dat");
  
  pass(([[[[doc content] objectAtIndex:0] contentType] isEqual: @"text"]),
       "can extract content type from mime4.dat");
  
  pass(([[[[doc content] objectAtIndex:0] contentSubtype] isEqual: @"plain"]),
       "can extract content sub type from mime4.dat");
  RELEASE(doc);
    
  data = [NSData dataWithContentsOfFile:@"mime5.dat"];
  doc = [GSMimeParser documentFromData:data];
  pass(([[doc contentSubtype] isEqual: @"xml"]),
       "can parse http document mime5.dat"); 
  
  data = [NSData dataWithContentsOfFile:@"mime6.dat"];
  doc = [GSMimeParser documentFromData:data];
  pass(([[doc content] count] == 3),
       "can parse multipart mixed mime6.dat"); 
 
  data = [NSData dataWithContentsOfFile:@"mime7.dat"];
  pass(([[[[doc content] objectAtIndex:1] content] isEqual: data]),
       "mime6.dat binary data part matches mime7.dat");

  
  
  DESTROY(arp);
  return 0;
}
