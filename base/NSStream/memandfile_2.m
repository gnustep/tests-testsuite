/**
 * This test tests asynchronized copying between mem and file using a runloop
 */
#include "ObjectTesting.h"
#include <Foundation/Foundation.h>
#include <Foundation/NSStream.h>

static NSOutputStream *defaultOutput = nil;
static NSInputStream *defaultInput = nil;

@interface Listener1 : NSObject <GSStreamListener>
@end

@interface Listener2 : NSObject <GSStreamListener>
@end

@implementation Listener1

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
  static uint8_t buffer[4096];
  switch (streamEvent) 
    {
    case NSStreamEventHasBytesAvailable:
      {
        int len = [(NSInputStream*)theStream read:buffer maxLength:4096];
        uint8_t *p = buffer;
        
        if (len==0)
          {
            [theStream close];
            [defaultOutput close];
          }
        else 
          {
            while(len>0)
              {
                int written = [defaultOutput write:p maxLength:len];
                p = p + written;
                len = len - written;
              }
          }
        break;
      }
    case NSStreamEventEndEncountered:
      {
        [theStream close];
        [defaultOutput close];
        break;
      }
    default:
      {
        NSAssert1(1, @"Error! code is %d", [[theStream streamError] code]);
        break;
      }  
    }
} 

@end

@implementation Listener2

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
  static uint8_t *p;
  static uint8_t buffer[4096];
  static int len = 0;

  switch (streamEvent) 
    {
    case NSStreamEventHasSpaceAvailable:
      {
        if (len==0)
          {
            len = [defaultInput read:buffer maxLength:4096];
            p = buffer;
          }
        if (len==0)
          {
            [theStream close];
            [defaultInput close];
          }
        else 
          {
            int written = [(NSOutputStream*)theStream write:p maxLength:len];
            p = p + written;
            len = len - written;
          }
        break;
      }
    case NSStreamEventEndEncountered:
      {
        [theStream close];
        [defaultInput close];
        break;
      }
    default:
      {
        NSAssert1(1, @"Error! code is %d", [[theStream streamError] code]);
        break;
      }  
    }
} 

@end

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSRunLoop *rl = [NSRunLoop currentRunLoop];

  // first test, file to memory copy
  NSString *path = @"memandfile.m";
  NSData *goldData = [NSData dataWithContentsOfFile:path];
  NSInputStream *input = [NSInputStream inputStreamWithFileAtPath:path];
  NSOutputStream *output = [NSOutputStream outputStreamToMemory];
  Listener1 *l1 = AUTORELEASE([Listener1 new]);

  [input setDelegate:l1];
  [input scheduleInRunLoop:rl forMode:NSDefaultRunLoopMode];
  [input open];
  [output open];
  defaultOutput = output;
  [rl run];

  NSData *answer = [output propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
  pass([goldData isEqualToData:answer], "file to memory copy ok");

  // second test, memory to file copy
  NSString *pathO = @"temp";
  NSInputStream *input2 = [NSInputStream inputStreamWithData:goldData];
  NSOutputStream *output2 = [NSOutputStream outputStreamToFileAtPath:pathO append:NO];
  Listener1 *l2 = AUTORELEASE([Listener2 new]);

  [output2 setDelegate:l2];
  [output2 scheduleInRunLoop:rl forMode:NSDefaultRunLoopMode];
  [input2 open];
  [output2 open];
  defaultInput = input2;
  [rl run];

  NSData *answer2 = [NSData dataWithContentsOfFile:pathO];
  pass([goldData isEqualToData:answer2], "memory to file copy ok");

  [[NSFileManager defaultManager] removeFileAtPath: pathO handler: nil];
    
  RELEASE(arp);
  return 0;
}

