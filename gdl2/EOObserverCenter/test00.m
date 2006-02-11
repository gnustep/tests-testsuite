#include <EOControl/EOControl.h>
#include <Foundation/Foundation.h>
#include "../GDL2Testing.h"
#include <unistd.h>

static NSMutableArray *recordedObservers;
static int reachedDealloc = 0;
static int omniChangeCount = 0;

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

@interface Foo : NSObject <EOObserving>
@end

@implementation Foo
- (void) objectWillChange:(id)sender
{
  [recordedObservers addObject:self];
}
@end

@interface SuperflousExample : NSObject <EOObserving>
{
  Foo *_foo;
}
@end

@implementation SuperflousExample
- (id) initWithFoo:(Foo *)foo
{
  self = [super init];
  ASSIGN(_foo,foo);
  [EOObserverCenter addObserver:self forObject:foo];
  return self;
}
- (void) dealloc
{
  [EOObserverCenter removeObserver:self forObject:_foo];
  RELEASE(_foo);
  reachedDealloc = 1;
  [super dealloc];
}
- (void) objectWillChange:(id)sender {};
@end

@interface OmniscientObserver : NSObject <EOObserving>

@end

@implementation OmniscientObserver
- (void) objectWillChange:(id)sender
{
  omniChangeCount++;
}
@end
int main()
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  NSMutableArray *observers = [[NSMutableArray alloc] init];
  id observer;
  id object;
  id takeupmemory;
  int i,tmpi1, tmpi2;
  NSArray *tmp;
  
  {
    int fds[2];
    pipe(fds);
    [[NSRunLoop currentRunLoop] addEvent: (void *)fds[0]
        type: ET_RDESC
        watcher: [Watcher self]
        forMode: NSDefaultRunLoopMode];
  }

  
  recordedObservers = [NSMutableArray new];

  object = [Foo new];
  
  for (i = 0; i < 64; i++)
    {
      observer = [Foo new];
      [EOObserverCenter addObserver:observer forObject:object];
      [observers addObject:observer];
      RELEASE(observer);
    }
  
  tmp = [EOObserverCenter observersForObject:object];
  pass([tmp isEqual:observers], "+observersForObject: works"); 
  
  [object willChange];
  pass([recordedObservers isEqual:observers],
       "observers receive -objectWillChange:");
  RELEASE(recordedObservers);
  
  [EOObserverCenter removeObserver:observer forObject:object];
  [observers removeObject:observer];
  pass([observers isEqual: [EOObserverCenter observersForObject:object]],
       "+removeObserver:forObject: works");
  for (i = 0; i < [observers count]; i++)
    {
      [EOObserverCenter removeObserver:[observers objectAtIndex:i]
	      		     forObject:object];
    }
  [observers removeAllObjects];
  object = [Foo new];
  observer = [Foo new];
  [EOObserverCenter addObserver:observer forObject:object];
  pass([object retainCount] == 1,
       "EOObserverCenter +addObserver:forObject doesn't retain object");
  tmpi1 = [object retainCount];
  pass([observer retainCount] == 1,
       "EOObserverCenter +addObserver:forObject doesn't retain observer");
  tmpi2 = [observer retainCount];
  
  [EOObserverCenter removeObserver:observer forObject:object];
  pass(tmpi1 == 1 && [object retainCount] == 1,
       "EOObserverCenter +removeObserver:forObject doesn't release object");
  pass(tmpi2 == 1 && [observer retainCount] == 1,
       "EOObserverCenter +addObserver:forObject doesn't release observer");
  RELEASE(observer);
  RELEASE(object);
  

  object = [Foo new];
  observer = [[SuperflousExample alloc] initWithFoo:object];
  RELEASE(object);
  RELEASE(observer);
  pass(reachedDealloc == 1,
       "can add observer in -init and remove in -dealloc");
  
  object = [Foo new];
  observer = [OmniscientObserver new];
  [observers addObject: observer];
  [EOObserverCenter addOmniscientObserver:observer];
  RELEASE(observer); 
  observer = [OmniscientObserver new];
  [observers addObject: observer];
  [EOObserverCenter addOmniscientObserver:observer];
  RELEASE(observer); 
   
  [object willChange];
  pass(omniChangeCount == 2,
       "multiple omniscient observers works.");
  tmpi1 = omniChangeCount;  
  [object willChange];
  pass(omniChangeCount == 2 && tmpi1 == 2,
       "sending will change twice only sends to observers once");
  DESTROY(object); 
  object = [Foo new];
  omniChangeCount = 0;
  [object willChange];
  [EOObserverCenter notifyObserversObjectWillChange:nil]; 
  [object willChange];
  /* when object occupied the same memory space 
   * EOObserverCenter can contain a dangling pointer to the new object 
   * and if (lastObject != object) will return a false negative */
  pass(tmpi1 == 2 && omniChangeCount == 4,
       "+notifyObserversObjectWillChange: with nil argument dangling pointer test");
  DESTROY(object);

  /* just make sure we have new memory.. */
  takeupmemory = [Foo new]; 
  object = [Foo new];
  omniChangeCount = 0;
  [object willChange];
  [EOObserverCenter notifyObserversObjectWillChange:nil]; 
  [object willChange];
  /* when oldobject and object occupied the same memory space 
   * EOObserverCenter can contain a dangling pointer to the new object */
  pass( tmpi1 == 2 && omniChangeCount == 4,
       "+notifyObserversObjectWillChange: with nil argument works");
  
  object = [Foo new];
  [EOObserverCenter removeOmniscientObserver:[observers objectAtIndex:0]];  
  [observers removeObjectAtIndex:0];
  omniChangeCount = 0;
  [object willChange];
  pass(tmpi1 == 2 && omniChangeCount == 1,
       "+removeOmniscientObserver: works");
  [EOObserverCenter removeOmniscientObserver:[observers objectAtIndex:0]];  
   
  RELEASE(observers);
  RELEASE(pool);
  return 0;
}
