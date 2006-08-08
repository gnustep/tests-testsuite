#if     defined(GNUSTEP_BASE_LIBRARY)
#import <Foundation/Foundation.h>
#import <GNUstepBase/GSMime.h>
#import "Testing.h"
int main(int argc,char **argv)
{
  CREATE_AUTORELEASE_POOL(arp);
  NSString *data = nil;
  GSMimeDocument *doc = [[GSMimeDocument alloc] init];
  NSMutableDictionary *par = [[NSMutableDictionary alloc] init];
  [par setObject: @"my/type" forKey: @"type"];
  [doc setContent: @"Hello\r\n"];
  [doc setHeader: [[GSMimeHeader alloc] initWithName: @"content-type"
  					       value: @"text/plain"
					  parameters: par]];

  [doc setHeader: [[GSMimeHeader alloc] initWithName: @"content-transfer-encoding"
  					       value: @"binary"
					  parameters: nil]];
				
  data = [NSData dataWithContentsOfFile: @"mime8.dat"];
  pass([[doc rawMimeData] isEqual: data], "Can make a simple document");
  DESTROY(arp);
  return 0;
}
#else
int main(int argc,char **argv)
{
  return 0;
}
#endif
