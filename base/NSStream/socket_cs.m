/**
 * This test tests client and server socket
 */
#import "ObjectTesting.h"
#import <Foundation/Foundation.h>
#import <Foundation/NSStream.h>

static GSServerStream *serverStream; 
static NSOutputStream *serverOutput = nil;
static NSOutputStream *clientOutput = nil;
static NSInputStream *serverInput = nil;
static NSInputStream *clientInput = nil;
static NSData *goldData;
static NSMutableData *testData;

@interface ClientListener : NSObject
{
  uint8_t buffer[4096];
  int writePointer;
}
@end

@implementation ClientListener

- (void)stream: (NSStream *)theStream handleEvent: (NSStreamEvent)streamEvent
{
NSLog(@"Client %p %d", theStream, streamEvent);
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
            int writeReturn = [clientOutput write: [goldData bytes]+writePointer 
	      maxLength: [goldData length]-writePointer];
            writePointer += writeReturn;
	   NSLog(@"Client wrote %d", writeReturn);
          }          
        else
	  {
	    writePointer = 0;
            [clientOutput close];          
	    [clientOutput removeFromRunLoop: [NSRunLoop currentRunLoop]
				    forMode: NSDefaultRunLoopMode];
            NSLog(@"Client close %p", clientOutput);
	  }
        break;
      }
    case NSStreamEventHasBytesAvailable: 
      {
        int readSize;
        NSAssert(theStream==clientInput, @"Wrong stream for reading");
        readSize = [clientInput read: buffer maxLength: 4096];
        if (readSize < 0)
          {
            // it is possible that readSize<0 but not an Error.
	    // For example would block
            NSAssert([clientInput streamError] == nil, @"read error");
          }
        else if (readSize == 0)
	  {
            [clientInput close];
	    [clientInput removeFromRunLoop: [NSRunLoop currentRunLoop]
				   forMode: NSDefaultRunLoopMode];
            NSLog(@"Client close %p", clientInput);
	  }
        else
	  {
            [testData appendBytes: buffer length: readSize];
	    NSLog(@"Client read %d", readSize);
	  }
        break;
      }
    case NSStreamEventEndEncountered: 
      {
        [theStream close];
	[theStream removeFromRunLoop: [NSRunLoop currentRunLoop]
			     forMode: NSDefaultRunLoopMode];
        NSLog(@"Client close %p", theStream);
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

@interface ServerListener : NSObject
{
  uint8_t buffer[4096];
  int readSize;
  int writeSize;
  BOOL readable;
  BOOL writable;
}
@end

@implementation ServerListener

- (void)stream: (NSStream *)theStream handleEvent: (NSStreamEvent)streamEvent
{
NSLog(@"Server %p %d", theStream, streamEvent);
  switch (streamEvent) 
    {
    case NSStreamEventHasBytesAvailable: 
      {
        if (theStream==serverStream)
          {
            NSAssert(serverInput==nil, @"accept twice");
            [serverStream acceptWithInputStream: &serverInput
				   outputStream: &serverOutput];
            if (serverInput)   // it is ok to accept nothing
              {
                NSRunLoop *rl = [NSRunLoop currentRunLoop];
                [serverInput scheduleInRunLoop: rl
				       forMode: NSDefaultRunLoopMode];
                [serverOutput scheduleInRunLoop: rl
					forMode: NSDefaultRunLoopMode];
                RETAIN(serverInput);
                RETAIN(serverOutput);
                [serverInput setDelegate: self];
                [serverOutput setDelegate: self];
                [serverInput open];
                [serverOutput open];
                readSize = 0;
                writeSize = 0;
                [serverStream close];
		[serverStream removeFromRunLoop: [NSRunLoop currentRunLoop]
					forMode: NSDefaultRunLoopMode];
              }
          }
        if (theStream == serverInput)
          {
	    readable = YES;
	  }
        break;
      }
    case NSStreamEventHasSpaceAvailable: 
      {
        NSAssert(theStream==serverOutput, @"Wrong stream for writing");
	writable = YES;
        break;
      }
    case NSStreamEventEndEncountered: 
      {
        [theStream close];
	[theStream removeFromRunLoop: [NSRunLoop currentRunLoop]
			     forMode: NSDefaultRunLoopMode];
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

  while ((readable == YES && writeSize == readSize)
    || (writable == YES && writeSize < readSize))
    {
      if (readable == YES && writeSize == readSize)
	{
	  readSize = [serverInput read: buffer maxLength: 4096];
	  readable = NO;
	  NSLog(@"Server read %d", readSize);
	  writeSize = 0;
	  NSAssert(readSize>=0, @"read error");
	  if (readSize == 0)
	    {
	      [serverInput close];
	      [serverInput removeFromRunLoop: [NSRunLoop currentRunLoop]
				     forMode: NSDefaultRunLoopMode];
	      NSLog(@"Server close %p", serverInput);
	      [serverOutput close];
	      [serverOutput removeFromRunLoop: [NSRunLoop currentRunLoop]
				      forMode: NSDefaultRunLoopMode];
	      NSLog(@"Server close %p", serverOutput);
	    }
	  else if (readSize < 0)
	    {
	      readSize = 0;
	    }
	}
      if (writable == YES && writeSize < readSize)
	{
	  int writeReturn = [serverOutput write: buffer+writeSize 
					  maxLength: readSize-writeSize];
	  writable = NO;
	  if (writeReturn == 0)
	    {
	      [serverOutput close];
	      [serverOutput removeFromRunLoop: [NSRunLoop currentRunLoop]
				      forMode: NSDefaultRunLoopMode];
	      NSLog(@"Server close %p", serverOutput);
	      [serverInput close];
	      [serverInput removeFromRunLoop: [NSRunLoop currentRunLoop]
				     forMode: NSDefaultRunLoopMode];
	      NSLog(@"Server close %p", serverInput);
	    }
	  else if (writeReturn > 0)
	    {
	      writeSize += writeReturn;
	      NSLog(@"Server wrote %d", writeReturn);
	    }

	  /* If we have finished writing and there is no more data coming,
	   * we can close the output stream.
	   */
	  if (writeSize == readSize
	    && [serverInput streamStatus] == NSStreamStatusClosed)
	    {
	      [serverOutput close];
	      [serverOutput removeFromRunLoop: [NSRunLoop currentRunLoop]
				      forMode: NSDefaultRunLoopMode];
	      NSLog(@"Server close %p", serverOutput);
	    }
	}
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
  goldData = [NSData dataWithContentsOfFile: path];

  sli = AUTORELEASE([ServerListener new]);
  cli = AUTORELEASE([ClientListener new]);
  testData = [NSMutableData dataWithCapacity: 4096];
  serverStream = [GSServerStream serverStreamToAddr: [host address] port: 4321];
  [serverStream setDelegate: sli];
  [serverStream scheduleInRunLoop: rl forMode: NSDefaultRunLoopMode];
  [serverStream open];

  [NSStream getStreamsToHost: host
			port: 4321
		 inputStream: &clientInput
		outputStream: &clientOutput];
  [clientInput setDelegate: cli];
  [clientOutput setDelegate: cli];
  [clientInput scheduleInRunLoop: rl forMode: NSDefaultRunLoopMode];
  [clientOutput scheduleInRunLoop: rl forMode: NSDefaultRunLoopMode];
  [clientInput open];
  [clientOutput open];

  [rl run];
  pass([goldData isEqualToData: testData], "Local tcp");

  DESTROY(serverInput);
  DESTROY(serverOutput);

  sli = AUTORELEASE([ServerListener new]);
  cli = AUTORELEASE([ClientListener new]);
  testData = [NSMutableData dataWithCapacity: 4096];
  serverStream = [GSServerStream serverStreamToAddr: socketPath];
  [serverStream setDelegate: sli];
  [serverStream scheduleInRunLoop: rl forMode: NSDefaultRunLoopMode];
  [serverStream open];
  
  [testData setLength: 0];
  [NSStream getLocalStreamsToPath: socketPath
		      inputStream: &clientInput
		     outputStream: &clientOutput];
  [clientInput setDelegate: cli];
  [clientOutput setDelegate: cli];
  [clientInput scheduleInRunLoop: rl forMode: NSDefaultRunLoopMode];
  [clientOutput scheduleInRunLoop: rl forMode: NSDefaultRunLoopMode];
  [clientInput open];
  [clientOutput open];

  [rl run];

  pass([goldData isEqualToData: testData], "Local unix domain socket");

  [[NSFileManager defaultManager] removeFileAtPath: socketPath handler: nil];

  RELEASE(arp);
  return 0;
}
