#import <Foundation/NSLock.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSThread.h>
#import <Foundation/NSUserDefaults.h>

@interface	MyClass : NSObject
+ (void) run;
@end

@implementation	MyClass
+ (void) run
{
  NSAutoreleasePool	*arp = [NSAutoreleasePool new];
  NSConditionLock	*lock = [NSConditionLock new];

  [lock lock];
  [lock lock];
  [arp release];
}
@end

int main()
{
  NSAutoreleasePool	*arp = [NSAutoreleasePool new];
  
  [NSUserDefaults standardUserDefaults];
  [NSThread detachNewThreadSelector: @selector(run)
			   toTarget: [MyClass class]
			 withObject: nil];
  [NSThread sleepForTimeInterval: 1.0];
  [arp release];
  return 0;
}
