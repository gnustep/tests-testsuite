#include "Testing.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSDate.h>
#include <Foundation/NSRunLoop.h>
#include <Foundation/NSString.h>

#include <unistd.h>

@interface Watcher : NSObject
@end
@implementation Watcher
+(void) receivedEvent: (void *)data
    type: (RunLoopEventType)type
    extra: (void *)extra
    forMode: (NSString *)mode
{
}
@end

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSRunLoop *run;
  NSDate *date;
  NSMutableString *str;
   
  run = [NSRunLoop currentRunLoop];
  
  /* For perhaps not entirely good reasons, a run loop with no input sources
  does nothing when you tell it to run. Thus, we open a pipe to ourself and
  add the reading end to the run loop's list of sources. */
  {
    int fds[2];
    pipe(fds);
    [run addEvent: (void *)fds[0]
	type: ET_RDESC
	watcher: [Watcher self]
	forMode: NSDefaultRunLoopMode];
  }

  str = [[NSMutableString alloc] init]; 
  [run performSelector:@selector(appendString:)
  	target:str
	argument:@"foo"
	order:0
	modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
  date = [NSDate dateWithTimeIntervalSinceNow:0.1];
  [run runUntilDate:date];
  pass([str isEqual:@"foo"], 
       "-performSelector:target:argument:order:modes: works for one performer");
  
  str = [[NSMutableString alloc] init]; 
  [run performSelector:@selector(appendString:)
  	target:str
	argument:@"foo"
	order:0
	modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
  date = [NSDate dateWithTimeIntervalSinceNow:0.1];
  [run runUntilDate:date];
  [run runUntilDate:date];
  pass([str isEqual:@"foo"],
       "-performSelector:target:argument:order:modes: only sends the message once");
  
  str = [[NSMutableString alloc] init]; 
  [run performSelector:@selector(appendString:)
  	target:str
	argument:@"bar"
	order:11
	modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
  [run performSelector:@selector(appendString:)
  	target:str
	argument:@"foo"
	order:10
	modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
  date = [NSDate dateWithTimeIntervalSinceNow:0.1];
  [run runUntilDate:date];
  pass([str isEqual:@"foobar"],
       "-performSelector:target:argument:order:modes: orders performers correctly");
  
  str = [[NSMutableString alloc] init]; 
  [run performSelector:@selector(appendString:)
  	target:str
	argument:@"foo"
	order:10
	modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
  [run performSelector:@selector(appendString:)
  	target:str
	argument:@"bar"
	order:11
	modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
  [run performSelector:@selector(appendString:)
  	target:str
	argument:@"zot"
	order:11
	modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
  [run cancelPerformSelector:@selector(appendString:)
  	target:str
	argument:@"bar"];
  date = [NSDate dateWithTimeIntervalSinceNow:0.1];
  [run runUntilDate:date];
  pass([str isEqual:@"foozot"],
       "-cancelPerformSelector:target:argument: works");
  
  str = [[NSMutableString alloc] init]; 
  [run performSelector:@selector(appendString:)
  	target:str
	argument:@"foo"
	order:10
	modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
  [run performSelector:@selector(appendString:)
  	target:str
	argument:@"zot"
	order:11
	modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
  [run cancelPerformSelectorsWithTarget:str];
  date = [NSDate dateWithTimeIntervalSinceNow:0.1];
  [run runUntilDate:date];
  pass([str isEqualToString:@""], "-cancelPerformSelectorsWithTarget: works %s",[str cString]); 
  
  DESTROY(arp);
  return 0;
}
