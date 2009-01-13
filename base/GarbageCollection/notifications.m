#import <Foundation/Foundation.h>
#import "ObjectTesting.h"

@interface	MyClass : NSObject
+ (unsigned) finalisationCounter;
+ (unsigned) notificationCounter;
- (void) notified: (NSNotification*)n;
@end

@implementation	MyClass
static unsigned notificationCounter = 0;
static unsigned finalisationCounter = 0;
+ (unsigned) finalisationCounter
{
  return finalisationCounter;
}
+ (unsigned) notificationCounter
{
  return notificationCounter;
}
- (void) finalize
{
  finalisationCounter++;
}
- (void) notified: (NSNotification*)n
{
  notificationCounter++;
}
@end

int
main()
{
  NSGarbageCollector	*collector = [NSGarbageCollector defaultCollector];
  NSNotificationCenter	*center;
  MyClass		*object;

  if (collector == nil) return 0;	// No garbage collection.

  center = [NSNotificationCenter defaultCenter];
  object = [MyClass new];
  [center addObserver: object
	     selector: @selector(notified:)
		 name: @"Notification"
	       object: nil];

  [center postNotificationName: @"Notification" object: nil];
  pass([MyClass notificationCounter] == 1, "simple notification works");
  object = nil;
  [collector collectExhaustively];
  pass([MyClass finalisationCounter] == 1, "finalisation done");
  [center postNotificationName: @"Notification" object: nil];
  pass([MyClass notificationCounter] == 1, "automatic removal works");

  return 0;
}
