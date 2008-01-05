/**
 * This test tests basic client side socket
 */
#import "ObjectTesting.h"
#import <Foundation/Foundation.h>
#import <Foundation/NSStream.h>

static NSOutputStream *defaultOutput = nil;
static NSInputStream *defaultInput = nil;
static int byteCount = 0;

static const uint8_t * rawstring = "GET / HTTP/1.0\r\n\r\n";
static BOOL     done = NO;

@interface Listener : NSObject
@end

@implementation Listener

- (void)stream: (NSStream *)theStream handleEvent: (NSStreamEvent)streamEvent
{
  static uint8_t buffer[4096];
  static BOOL doneWrite = NO;
  int readSize;
NSLog(@"Got %d on %p", streamEvent, theStream);
  switch (streamEvent) 
    {
    case NSStreamEventOpenCompleted: 
      {
	if (theStream == defaultOutput)
	  {
	    doneWrite = NO;
	  }
	break;
      }
    case NSStreamEventHasSpaceAvailable: 
      {
        NSAssert(theStream==defaultOutput, @"Wrong stream for reading");
        if (doneWrite == NO)
          {
            // there may be a problem so that write is not complete. 
            // However, since this is so short it is pretty much always ok.
	    NSLog(@"Written request");
	    doneWrite = YES;
            [defaultOutput write: rawstring
		       maxLength: strlen((char*)rawstring)];
	  }
/*
	else
	  {
            [defaultOutput close];
	    [defaultOutput removeFromRunLoop: [NSRunLoop currentRunLoop]
				     forMode: NSDefaultRunLoopMode];
	    NSLog(@"Closed %p", defaultOutput);
          }          
*/
        break;
      }
    case NSStreamEventHasBytesAvailable: 
      {
        NSAssert(theStream==defaultInput, @"Wrong stream for reading");
        readSize = [defaultInput read: buffer maxLength: 4096];
        if (readSize < 0)
          {
            // it is possible that readSize<0 but not an Error.
	    // For example would block
            NSAssert([defaultInput streamError]==nil, @"read error");
          }
        if (readSize == 0)
	  {
            [defaultInput close];
	    [defaultInput removeFromRunLoop: [NSRunLoop currentRunLoop]
				    forMode: NSDefaultRunLoopMode];
	    NSLog(@"Closed %p", defaultInput);
	  }
        else
	  {
            byteCount += readSize;
	    NSLog(@"Read %d: %*.*s", readSize, readSize, readSize, buffer);
	  }
        break;
      }
    case NSStreamEventEndEncountered: 
      {
        [theStream close];
	[theStream removeFromRunLoop: [NSRunLoop currentRunLoop]
			     forMode: NSDefaultRunLoopMode];
        NSLog(@"Close %p", theStream);
        done = YES;
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
  NSDate *d;

  rl = [NSRunLoop currentRunLoop];
  host = [NSHost hostWithName: @"www.google.com"];
  li = AUTORELEASE([Listener new]);
  [NSStream getStreamsToHost: host port: 80
    inputStream: &defaultInput outputStream: &defaultOutput];

  [defaultInput setDelegate: li];
  [defaultOutput setDelegate: li];
  [defaultInput scheduleInRunLoop: rl forMode: NSDefaultRunLoopMode];
  [defaultOutput scheduleInRunLoop: rl forMode: NSDefaultRunLoopMode];
  [defaultInput open];
  [defaultOutput open];
  
  d = [NSDate dateWithTimeIntervalSinceNow: 30];
  while (done == NO && [d timeIntervalSinceNow] > 0.0)
    {
      [rl runMode: NSDefaultRunLoopMode beforeDate: d];
    }

  // I cannot verify the content at www.google.com,
  // so as long as it has something, that is passing
  pass(byteCount>0, "read www.google.com");


  done = NO;
  byteCount = 0;
  defaultInput = nil;
  defaultOutput = nil;
  li = AUTORELEASE([Listener new]);
  [NSStream getStreamsToHost: host port: 443
    inputStream: &defaultInput outputStream: &defaultOutput];

  [defaultInput setDelegate: li];
  [defaultOutput setDelegate: li];
  [defaultInput scheduleInRunLoop: rl forMode: NSDefaultRunLoopMode];
  [defaultOutput scheduleInRunLoop: rl forMode: NSDefaultRunLoopMode];
  [defaultInput setProperty: NSStreamSocketSecurityLevelNegotiatedSSL
                     forKey: NSStreamSocketSecurityLevelKey];
  [defaultOutput setProperty: NSStreamSocketSecurityLevelNegotiatedSSL
                      forKey: NSStreamSocketSecurityLevelKey];
  [defaultInput open];
  [defaultOutput open];

  d = [NSDate dateWithTimeIntervalSinceNow: 30];
  while (done == NO && [d timeIntervalSinceNow] > 0.0)
    {
      [rl runMode: NSDefaultRunLoopMode beforeDate: d];
    }

  pass(byteCount>0, "read www.google.com https");

  RELEASE(arp);
  return 0;
}

@end
