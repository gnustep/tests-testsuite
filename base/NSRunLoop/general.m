#include "ObjectTesting.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSInvocation.h>
#include <Foundation/NSRunLoop.h>
#include <Foundation/NSTimer.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSMethodSignature *sig;
  NSInvocation      *inv;
  NSTimer	    *tim;
  NSRunLoop	    *run;
  NSDate	    *date;

  sig = [NSTimer instanceMethodSignatureForSelector:@selector(isValid)];
  inv = [NSInvocation invocationWithMethodSignature: sig];
  
  run = [NSRunLoop currentRunLoop];
  pass(run != nil, "NSRunLoop understands [+currentRunLoop]");
  pass([run currentMode] == nil, "-currentMode returns nil");
  
  TEST_EXCEPTION(date = [NSDate dateWithTimeIntervalSinceNow:3];
  		 [run runUntilDate:date];,
		 nil,NO,"-runUntilDate: works");
  TEST_EXCEPTION(date = [NSDate dateWithTimeIntervalSinceNow:5];
  		 tim = [NSTimer scheduledTimerWithTimeInterval: 2.0
						    invocation:inv
				 		       repeats:YES];,
	         nil,NO,"-runUntilDate: works with a timer");
  
  
  
  DESTROY(arp);
  return 0;
}
