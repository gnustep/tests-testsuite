/**
 * This test tests basic client side socket
 */
#include "ObjectTesting.h"
#include <Foundation/Foundation.h>
#include <Foundation/NSStream.h>

static NSOutputStream *defaultOutput = nil;
static NSInputStream *defaultInput = nil;
static int byteCount = 0;

@interface Listener : NSObject <GSStreamListener>
@end

@implementation Listener

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
  static uint8_t buffer[4096];
  int readSize;
  switch (streamEvent) 
    {
    case NSStreamEventOpenCompleted:
      {
        if (theStream==defaultOutput)
          {
            NSString * str = [NSString stringWithFormat:@"GET / HTTP/1.0\r\n\r\n"];
            const uint8_t * rawstring = (const uint8_t *)[str UTF8String];
            // there may be a problem so that write is not complete. 
            // However, since this is so short it is pretty much always complete.
            [defaultOutput write:rawstring maxLength:strlen((char*)rawstring)];
            [defaultOutput close];
          }          
        break;
      }
    case NSStreamEventHasBytesAvailable:
      {
        NSAssert(theStream==defaultInput, @"Wrong stream for reading");
        readSize = [defaultInput read:buffer maxLength:4096];
        if (readSize<0)
          {
            // it is possible that readSize<0 but not an Error.
	    // For example would block
            NSAssert([defaultInput streamError]==nil, @"read error");
          }
        if (readSize==0)
          [defaultInput close];
        else
          byteCount += readSize;
        break;
      }
    default:
      {
        NSAssert1(1, @"Error! code is %d", [[theStream streamError] code]);
        break;
      }  
    }
} 

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSRunLoop *rl;
  NSHost *host;
  Listener *li;

  if ([[NSProcessInfo processInfo] operatingSystem]
    == NSWindowsNTOperatingSystem)
    {
      unsupported("NSStream for sockets on mingw32");
      return 0;
    }

  rl = [NSRunLoop currentRunLoop];
  host = [NSHost hostWithName:@"www.google.com"];
  li = AUTORELEASE([Listener new]);
  [NSStream getStreamsToHost:host port:80 inputStream:&defaultInput outputStream:&defaultOutput];

  [defaultInput setDelegate:li];
  [defaultOutput setDelegate:li];
  [defaultInput scheduleInRunLoop:rl forMode:NSDefaultRunLoopMode];
  [defaultOutput scheduleInRunLoop:rl forMode:NSDefaultRunLoopMode];
  [defaultInput open];
  [defaultOutput open];
  [rl run];

  // I cannot verify the content at www.google.com, so as long as it has something, that is passing
  pass(byteCount>0, "read www.google.com");

  RELEASE(arp);
  return 0;
}

@end
