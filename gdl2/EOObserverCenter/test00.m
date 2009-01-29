#include <EOControl/EOControl.h>
#include <Foundation/Foundation.h>
#include "../GDL2Testing.h"
#include <unistd.h>

static NSMutableArray *recordedObservers;
static NSMutableArray *recordedObjects;
static int reachedDealloc = 0;
static int omniChangeCount = 0;

@interface Foo : NSObject <EOObserving>
{
  unsigned _hash;
}
@end

@implementation Foo
- (void) setHash:(unsigned)hash
{
  _hash = hash; 
}

- (unsigned) hash;
{
  return _hash;
}

- (BOOL) isEqual:(id)obj;
{
  BOOL flag = NO;

  if ([obj isKindOfClass:isa]
      && _hash == ((Foo *)obj)->_hash)
    {
      flag = YES;
    }
  return flag;
}

- (void) objectWillChange:(id)sender
{
  [recordedObservers addObject:self];
  [recordedObjects addObject:sender];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%i", self, _hash];
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
  [_foo release];
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
  id tmp;
  id tmp2;
  id omnisc1, omnisc2;
  NSFileHandle *fh = [NSFileHandle fileHandleWithStandardInput];

  [fh retain];
  [fh readInBackgroundAndNotify];

  recordedObservers = [NSMutableArray new];
  recordedObjects = [NSMutableArray new];

  object = [NSObject new];
  
  for (i = 0; i < 64; i++)
    {
      observer = [Foo new];
      [observer setHash:i];
      [EOObserverCenter addObserver:observer forObject:object];
      [observers addObject:observer];
      [observer release];
    }
  
  tmp = [NSSet setWithArray:[EOObserverCenter observersForObject:object]];
  tmp2 = [NSSet setWithArray:observers];
  pass([tmp isEqualToSet:tmp2], "+observersForObject: works"); 
  
  [object willChange];
  tmp2 = [NSSet setWithArray:recordedObservers];
  pass([tmp isEqualToSet:tmp2],
       "observers receive -objectWillChange:");
   
  [EOObserverCenter removeObserver:observer forObject:object];
  [observers removeObject:observer];
  tmp = [NSSet setWithArray:[EOObserverCenter observersForObject:object]];
  tmp2 = [NSSet setWithArray:observers];
  pass([tmp2 isEqualToSet: tmp],
       "+removeObserver:forObject: works");
  tmp = [EOObserverCenter observersForObject:object];
  for (i = 0; i < [tmp count]; i++)
    {
      [EOObserverCenter removeObserver:[tmp objectAtIndex:i]
	      		     forObject:object];
    }
  [observers removeAllObjects];
  object = [NSObject new];
  observer = [NSObject new];
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
  [observer release];
  [object release];
  

  object = [NSObject new];
  observer = [[SuperflousExample alloc] initWithFoo:object];
  [object release];
  [observer release];
  pass(reachedDealloc == 1,
       "can add observer in -init and remove in -dealloc");
  
  object = [NSObject new];
  
  omnisc1 = [OmniscientObserver new];
  [observers addObject: omnisc1];
  [omnisc1 release]; 
  [EOObserverCenter addOmniscientObserver:omnisc1];
  
  omnisc2 = [OmniscientObserver new];
  [observers addObject: omnisc2];
  [omnisc2 release]; 
  [EOObserverCenter addOmniscientObserver:omnisc2];
   
  [object willChange];
  pass(omniChangeCount == 2,
       "multiple omniscient observers works.");
  tmpi1 = omniChangeCount;  
  [object willChange];
  pass(omniChangeCount == 2 && tmpi1 == 2,
       "sending will change twice only sends to observers once");
  DESTROY(object); 
  
  object = [NSObject new];
  omniChangeCount = 0;
  [object willChange];
  [EOObserverCenter notifyObserversObjectWillChange:nil]; 
  [object willChange];
  /* when object occupied the same memory space 
   * EOObserverCenter can contain a dangling pointer to the new object 
   * and if (lastObject != object) will return a false negative */
  pass(tmpi1 == 2 && omniChangeCount == 6,
       "+notifyObserversObjectWillChange: with nil argument dangling pointer test");
  DESTROY(object);

  /* just make sure we have new memory.. */
  takeupmemory = [NSObject new]; 
  object = [NSObject new];
  omniChangeCount = 0;
  [object willChange];
  [EOObserverCenter notifyObserversObjectWillChange:nil]; 
  [object willChange];
  /* when oldobject and object occupied the same memory space 
   * EOObserverCenter can contain a dangling pointer to the new object */
  pass( tmpi1 == 2 && omniChangeCount == 6,
       "+notifyObserversObjectWillChange: with nil argument works");
  
  omniChangeCount = 0;
  [EOObserverCenter notifyObserversObjectWillChange:nil];
  pass(omniChangeCount == 2, "+notifyObserversObjectWillChange notifies omniscient observers of a nil argument");
  
  object = [NSObject new];
  [EOObserverCenter removeOmniscientObserver:omnisc1];  
  [observers removeObject:omnisc1];
  omniChangeCount = 0;
  [object willChange];
  pass(tmpi1 == 2 && omniChangeCount == 1,
       "+removeOmniscientObserver: works");
  [EOObserverCenter removeOmniscientObserver:omnisc2];  
  [observers removeObject:omnisc2];

  {
    id obj1 = [Foo new];
    id obj2 = [Foo new];
    id obj3 = [Foo new];

    [recordedObservers removeAllObjects];
    [observers removeAllObjects];

    [obj1 setHash:99];
    [obj2 setHash:99];
    [obj3 setHash:11];
    [observers addObject:obj1];
    [observers addObject:obj2];

    [EOObserverCenter addObserver:obj1 forObject:obj3];
    [EOObserverCenter addObserver:obj2 forObject:obj3];
   
    pass([obj1 hash] == [obj2 hash] && [obj1 isEqual:obj2],
	 "internal test consistency");
    tmp = [EOObserverCenter observersForObject:obj3];
    pass([tmp indexOfObjectIdenticalTo:obj1] != NSNotFound,
	 "+observersForObjects with observers responding YES to isEqual: 1");
    pass([tmp indexOfObjectIdenticalTo:obj2] != NSNotFound,
	 "+observersForObjects with observers responding YES to isEqual: 2");

    [obj3 willChange];
    pass([recordedObservers indexOfObjectIdenticalTo:obj1] != NSNotFound,
	 "-willChange notifies -isEqual: objects 1");
    pass([recordedObservers indexOfObjectIdenticalTo:obj2] != NSNotFound,
	 "-willChange notifies -isEqual: objects 2");
    
    [EOObserverCenter removeObserver:obj1 forObject:obj3];
    [observers removeObject:obj1];
    tmp = [EOObserverCenter observersForObject:obj3];
    pass([tmp indexOfObjectIdenticalTo:obj1] == NSNotFound
	 && [tmp indexOfObjectIdenticalTo:obj2] == 0,
	 "-removeObject: notifies -isEqual: objects");
   
    [recordedObservers removeAllObjects];
    [EOObserverCenter addObserver:obj3 forObject:obj1];
    [obj2 willChange];
    pass([recordedObservers count] == 0, "false positives in -willChange");
    
    [recordedObservers removeAllObjects];
    [recordedObjects removeAllObjects];
    [EOObserverCenter addObserver:obj3 forObject:obj2];
    [obj1 willChange];
    [obj2 willChange];
    pass([recordedObservers count] == 2
	 && [recordedObservers objectAtIndex:0] == obj3
	 && [recordedObservers objectAtIndex:1] == obj3,
	 "observer for -isEqual: objects recieves 2 changes");
    pass([recordedObjects indexOfObjectIdenticalTo:obj1] != NSNotFound
         && [recordedObjects indexOfObjectIdenticalTo:obj2] != NSNotFound,
	 "observed objects for -isEqual: objects");
  }
  
  [observers release];

  [fh closeFile];
  [fh release];
  [pool release];
  return 0;
}
