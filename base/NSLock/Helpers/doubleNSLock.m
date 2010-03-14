#import <Foundation/NSLock.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSThread.h>

@interface	MyClass : NSObject
+ (void) run;
@end

@implementation	MyClass
+ (void) run
{
  NSAutoreleasePool	*arp = [NSAutoreleasePool new];
  NSLock		*lock = [NSLock new];

  [lock lock];
  [lock lock];
  [arp release];
}
@end

int main()
{
  [NSThread detachNewThreadSelector: @selector(run)
			   toTarget: [MyClass class]
			 withObject: nil];
  [NSThread sleepForTimeInterval: 1.0];
  return 0;
}
