/**
 * This test tests client and server socket
 */
#include "ObjectTesting.h"
#include <Foundation/Foundation.h>
#include <Foundation/NSStream.h>

static GSServerStream *serverStream; 
static NSOutputStream *serverOutput = nil;
static NSOutputStream *clientOutput = nil;
static NSInputStream *serverInput = nil;
static NSInputStream *clientInput = nil;
static NSData *goldData;
static NSMutableData *testData;

@interface ClientListener : NSObject <GSStreamListener>
{
  uint8_t buffer[4096];
  int writePointer;
}
@end

@implementation ClientListener

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
  switch (streamEvent) 
    {
    case NSStreamEventOpenCompleted:
      {
        if (theStream==clientOutput)
          writePointer = 0;
        break;
      }
    case NSStreamEventHasSpaceAvailable:
      {
        NSAssert(theStream==clientOutput, @"Wrong stream for writing");
        if (writePointer<[goldData length])
          {
            int writeReturn = [clientOutput write:[goldData bytes]+writePointer 
	      maxLength:[goldData length]-writePointer];
            writePointer += writeReturn;
          }          
        else
	  {
	    writePointer = 0;
            [clientOutput close];          
	  }
        break;
      }
    case NSStreamEventHasBytesAvailable:
      {
        int readSize;
        NSAssert(theStream==clientInput, @"Wrong stream for reading");
        readSize = [clientInput read:buffer maxLength:4096];
        if (readSize < 0)
          {
            // it is possible that readSize<0 but not an Error.
	    // For example would block
            NSAssert([clientInput streamError] == nil, @"read error");
          }
        else if (readSize == 0)
          [clientInput close];
        else
          [testData appendBytes:buffer length:readSize];
        break;
      }
    case NSStreamEventErrorOccurred:
      {
        NSAssert1(1, @"Error! code is %d", [[theStream streamError] code]);
        break;
      }  
    default:
      break;
    }
}

@end

@interface ServerListener : NSObject <GSStreamListener>
{
  uint8_t buffer[4096];
  int readSize;
  int writeSize;
  BOOL finished;
}
@end

@implementation ServerListener

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
  switch (streamEvent) 
    {
    case NSStreamEventHasBytesAvailable:
      {
        if (theStream==serverStream)
          {
            NSAssert(serverInput==nil, @"accept twice");
            [serverStream acceptWithInputStream:&serverInput outputStream:&serverOutput];
            if (serverInput)   // it is ok to accept nothing
              {
                NSRunLoop *rl = [NSRunLoop currentRunLoop];
                [serverInput scheduleInRunLoop:rl forMode:NSDefaultRunLoopMode];
                [serverOutput scheduleInRunLoop:rl forMode:NSDefaultRunLoopMode];
                RETAIN(serverInput);
                RETAIN(serverOutput);
                [serverInput setDelegate:self];
                [serverOutput setDelegate:self];
                [serverInput open];
                [serverOutput open];
                finished = NO;
                readSize = 0;
                writeSize = 0;
                [serverStream close];
              }
          }
        else if (theStream == serverInput)
          {
            if (writeSize == readSize)
              {
                readSize = [serverInput read:buffer maxLength:4096];
                writeSize = 0;
                NSAssert(readSize>=0, @"read error");
                if (readSize == 0)
                  {
                    [serverInput close];
                    finished = YES;
                    DESTROY(serverInput);
                  }
              }
          }
        else
          NSAssert(1, @"wrong stream");
        break;
      }
    case NSStreamEventHasSpaceAvailable:
      {
        NSAssert(theStream==serverOutput, @"Wrong stream for writing");
        if (writeSize < readSize)
          {
            int writeReturn = [serverOutput write:buffer+writeSize 
                                            maxLength:readSize-writeSize];
            writeSize += writeReturn;
          }
        else if (finished)
          {
            [serverOutput close];
            DESTROY(serverOutput);
          }
        break;
      }
    case NSStreamEventErrorOccurred:
      {
        NSAssert1(1, @"Error! code is %d", [[theStream streamError] code]);
        break;
      }  
    default:
      break;
    }
} 

@end

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSRunLoop *rl = [NSRunLoop currentRunLoop];
  NSHost *host = [NSHost currentHost];
  ServerListener *sli;
  ClientListener *cli;

  NSString *path = @"socket_cs.m";
  NSString *socketPath = @"test-socket";
  NSLog(@"sending and receiving on %@: %@", host, [host address]);
  goldData = [NSData dataWithContentsOfFile:path];

  sli = AUTORELEASE([ServerListener new]);
  cli = AUTORELEASE([ClientListener new]);
  testData = [NSMutableData dataWithCapacity:4096];
  serverStream = [GSServerStream serverStreamToAddr:[host address] port:4321];
  [serverStream setDelegate:sli];
  [serverStream scheduleInRunLoop:rl forMode:NSDefaultRunLoopMode];
  [serverStream open];

  [NSStream getStreamsToHost:host port:4321 inputStream:&clientInput outputStream:&clientOutput];
  [clientInput setDelegate:cli];
  [clientOutput setDelegate:cli];
  [clientInput scheduleInRunLoop:rl forMode:NSDefaultRunLoopMode];
  [clientOutput scheduleInRunLoop:rl forMode:NSDefaultRunLoopMode];
  [clientInput open];
  [clientOutput open];

  [rl run];
  pass([goldData isEqualToData:testData], "Local tcp");

  sli = AUTORELEASE([ServerListener new]);
  cli = AUTORELEASE([ClientListener new]);
  testData = [NSMutableData dataWithCapacity:4096];
  serverStream = [GSServerStream serverStreamToAddr:socketPath];
  [serverStream setDelegate:sli];
  [serverStream scheduleInRunLoop:rl forMode:NSDefaultRunLoopMode];
  [serverStream open];
  
  [testData setLength: 0];
  [NSStream getLocalStreamsToPath:socketPath inputStream:&clientInput outputStream:&clientOutput];
  [clientInput setDelegate:cli];
  [clientOutput setDelegate:cli];
  [clientInput scheduleInRunLoop:rl forMode:NSDefaultRunLoopMode];
  [clientOutput scheduleInRunLoop:rl forMode:NSDefaultRunLoopMode];
  [clientInput open];
  [clientOutput open];

  [rl run];

  pass([goldData isEqualToData:testData], "Local unix domain socket");

  [[NSFileManager defaultManager] removeFileAtPath: socketPath handler: nil];

  RELEASE(arp);
  return 0;
}
