#import "Testing.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSBundle.h>
#import <Foundation/NSConnection.h>
#import <Foundation/NSException.h>
#import <Foundation/NSFileManager.h>
#import <Foundation/NSString.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSBundle *bundle;
  NSString *bundlePath = [[NSFileManager defaultManager] currentDirectoryPath];
  bundlePath = [bundlePath stringByAppendingPathComponent: @"Resources"];
  bundlePath = [NSBundle pathForResource:@"TestConnection" 
                   		  ofType:@"bundle"
			     inDirectory:bundlePath];
  bundle = [NSBundle bundleWithPath:bundlePath];
  pass([bundle load],"We can load the test bundle");
  {
    /* this should probably be rewritten to uh return a bool */
    NS_DURING
      NSDate *date;
      NSRunLoop *run = [NSRunLoop currentRunLoop];
      [NSClassFromString(@"Tester") performSelector:@selector(startup)];
    
      date = [NSDate dateWithTimeIntervalSinceNow:1];
      [run runUntilDate:date];
      pass(1, "NSConnection can do a simple connection");
    NS_HANDLER
      pass(0, "NSConnection can do a simple connection");
    NS_ENDHANDLER
  }
  DESTROY(arp);
  return 0;
}
