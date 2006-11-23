#if	defined(GNUSTEP_BASE_LIBRARY)
#include	<Foundation/Foundation.h>

@interface	TestClass : NSObject
{
  NSOutputStream *op;
  NSInputStream *ip;
  NSData	*content;
  unsigned	written;
  BOOL		readable;
  BOOL		writable;
  unsigned	writeLen;
  unsigned	count;
}
- (int) runTest;
@end

@implementation	TestClass

- (void) dealloc
{
  RELEASE(content);
  RELEASE(op);
  RELEASE(ip);
  [super dealloc];
}

- (id) init
{
  return self;
}

- (int) runTest
{
  NSUserDefaults	*defs = [NSUserDefaults standardUserDefaults];
  NSRunLoop		*rl = [NSRunLoop currentRunLoop];
  NSHost		*host = [NSHost hostWithName: @"localhost"];
  NSStream		*serverStream;
  NSString		*file;
  int			port = [[defs stringForKey: @"Port"] intValue];

  if (port == 0) port = 4321;

  count = [[defs stringForKey: @"Count"] intValue];
  if (count == 0) count = 1;

  file = [defs stringForKey: @"FileName"];
  if (file == nil) file = @"Respond.dat";
  content = [[NSData alloc] initWithContentsOfFile: file];
  if (content == nil)
    {
      NSLog(@"Unable to load data from '%@'", file);
      return 1;
    }

  if ([defs boolForKey: @"Shrink"] == YES)
    {
      writeLen = [content length];
    }
  else
    {
      writeLen = 0;
    }

  serverStream = [GSServerStream serverStreamToAddr: [host address] port: port];
  if (serverStream == nil)
    {
      NSLog(@"Failed to create server stream");
      return 1;
    }
  [serverStream setDelegate: self];
  [serverStream scheduleInRunLoop: rl forMode: NSDefaultRunLoopMode];
  [serverStream open];

  [rl runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 30]];

  return 0;
}

- (void) stream: (NSStream *)theStream handleEvent: (NSStreamEvent)streamEvent
{
  NSRunLoop	*rl = [NSRunLoop currentRunLoop];

//NSLog(@"Server %p %d", theStream, streamEvent);
  switch (streamEvent) 
    {
    case NSStreamEventHasBytesAvailable: 
      {
        if (theStream != ip)
          {
	    if (ip != nil)
	      {
		[ip close];
		[ip removeFromRunLoop: rl forMode: NSDefaultRunLoopMode];
		ip = nil;
	      }
	    if (op != nil)
	      {
		[op close];
		[op removeFromRunLoop: rl forMode: NSDefaultRunLoopMode];
		op = nil;
	      }
	    written = 0;	// Nothing written yet on this connection.
            [(GSServerStream*)theStream acceptWithInputStream: &ip
						 outputStream: &op];
            if (ip)   // it is ok to accept nothing
              {
                RETAIN(ip);
                RETAIN(op);
                [ip scheduleInRunLoop: rl forMode: NSDefaultRunLoopMode];
                [op scheduleInRunLoop: rl forMode: NSDefaultRunLoopMode];
                [ip setDelegate: self];
                [op setDelegate: self];
                [ip open];
                [op open];
		if (count > 0)
		  {
		    count--;
		  }
		if (count == 0)
		  {
		    /*
		     * Handled enough requests ... close down
		     */
                    [theStream close];
		    [theStream removeFromRunLoop: rl
		   			 forMode: NSDefaultRunLoopMode];
		  }
		if (writeLen > 0 && [[NSUserDefaults standardUserDefaults]
		  boolForKey: @"Shrink"] == YES)
		  {
		    /* Want to write in slightly smaller chunks for each
		     * connection so that the remote end can check that
		     * it handles different chunk sizes properly.
		     */
		    writeLen--;
		  }
              }
          }
        else if (theStream == ip)
          {
	    readable = YES;
	    while (readable == YES)
	      {
		unsigned char	buffer[BUFSIZ];
		int		readSize;

		readSize = [ip read: buffer maxLength: sizeof(buffer)];
		if (readSize <= 0)
		  {
		    readable = NO;
		  }
	      }
	  }
        break;
      }
    case NSStreamEventHasSpaceAvailable: 
      {
        NSAssert(theStream == op, @"Wrong stream for writing");
	writable = YES;
	while (writable == YES && written < [content length])
	  {
	    int	length = [content length] - written;

	    /* If we have a write length limit set, don't try to write
	     * more than that in one chunk.
	     */
	    if (writeLen > 0 && length > writeLen)
	      {
	        length = writeLen;
	      }

	    /* Just pause for a very short time to try to stop the operating
	     * system from combining individual writes ... because we want
	     * the remote end to have to deal with separate reads.
	     */
	    [NSThread sleepUntilDate:
	      [NSDate dateWithTimeIntervalSinceNow: 0.0001]];

	    length = [op write: [content bytes] + written maxLength: length];
	    if (length <= 0)
	      {
	        writable = NO;
	      }
	    else
	      {
	        written += length;
	      }
	  }
	if (written == [content length])
	  {
	    [op close];
	    [op removeFromRunLoop: rl forMode: NSDefaultRunLoopMode];
	    op = nil;
	    if (ip != nil)
	      {
		[ip close];
		[ip removeFromRunLoop: rl forMode: NSDefaultRunLoopMode];
		ip = nil;
	      }
	  }
        break;
      }
    case NSStreamEventEndEncountered: 
      {
        [theStream close];
	[theStream removeFromRunLoop: rl forMode: NSDefaultRunLoopMode];
	if (theStream == ip) ip = nil;
	if (theStream == op) op = nil;
//        NSLog(@"Server close %p", theStream);
        break;
      }

    case NSStreamEventErrorOccurred: 
      {
        int	code = [[theStream streamError] code];

        [theStream close];
	[theStream removeFromRunLoop: rl forMode: NSDefaultRunLoopMode];
	if (theStream == ip) ip = nil;
	if (theStream == op) op = nil;
        NSAssert1(1, @"Error! code is %d", code);
        break;
      }  

    default: 
      break;
    }
} 

@end

int
main(int argc, char **argv)
{
  int	result;
  CREATE_AUTORELEASE_POOL(arp);

  result = [[[[TestClass alloc] init] autorelease] runTest];

  RELEASE(arp);
  return result;
}

#else

int main()
{
  return 0;
}

#endif
