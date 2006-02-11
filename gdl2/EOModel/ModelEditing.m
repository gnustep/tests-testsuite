#include <EOControl/EOArrayDataSource.h>
#include <EOControl/EOEditingContext.h>

#include <Foundation/Foundation.h>

#include <unistd.h>

#include "../GDL2Testing.h"

@interface Test : NSObject
{
  BOOL recv_objsChangedInEC;
}
- (BOOL) recvObjsChangedNotif;
- (id) initWithEditingContext:(EOEditingContext *)ec;
- (void) objectsChangedInEditingContext:(NSNotification *)notif;
- (void) resetTests;
@end


@implementation Test 

- (id) initWithEditingContext:(EOEditingContext *)ec
{
  self = [super init];
  [ec setDelegate:self];
  [[NSNotificationCenter defaultCenter] 
  		addObserver: self 
  		   selector: @selector(objectsChangedInEditingContext:)
		       name: EOObjectsChangedInEditingContextNotification
		     object: nil];
  /* For perhaps not entirely good reasons, a run loop with no input sources
  does nothing when you tell it to run. Thus, we open a pipe to ourself and
  add the reading end to the run loop's list of sources. */
  {
    int fds[2];
    pipe(fds);
    [[NSRunLoop currentRunLoop] addEvent: (void *)fds[0]
        type: ET_RDESC
        watcher: [Test self]
        forMode: NSDefaultRunLoopMode];
  }
  return self;
}
+(void) receivedEvent: (void *)data
    type: (RunLoopEventType)type
    extra: (void *)extra
    forMode: (NSString *)mode
{
}

- (BOOL) recvObjsChangedNotif
{
  return recv_objsChangedInEC;
}

- (void) objectsChangedInEditingContext:(NSNotification *)notif
{
  recv_objsChangedInEC = YES; 
}
- (void) resetTests
{
  recv_objsChangedInEC = NO;
}


- (void) performTestWithObject:(id)object selector:(SEL)selector argument:(id)arg
{
  [self resetTests];
  [object performSelector:selector withObject:arg];
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
  pass([self recvObjsChangedNotif] == YES, "[%s %s] causes EOObjectsChangedInEditingContextNotification",
  					   [[[object class] description] cString],
					   [NSStringFromSelector(selector) cString]);
  [self resetTests];
}

@end

int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  EOModel *model = [[EOModel alloc] init];
  EOEditingContext *ec; 
  EOEntity *ent;
  EOAttribute *attrib = [EOAttribute new];
  id testObject; 

  ec = [EOEditingContext new];
  ent = [[EOEntity alloc] init];
  testObject = [[Test alloc] initWithEditingContext:ec];
  [testObject performTestWithObject:ec selector:@selector(insertObject:) argument:model];
  [testObject performTestWithObject:model selector:@selector(setName:) argument: @"aModel"];
  [[EOModelGroup defaultGroup] addModel: model];
  [testObject performTestWithObject:ec selector:@selector(insertObject:) argument:ent];
  
  [testObject performTestWithObject:ent selector:@selector(setName:) argument: @"anEntity"];
  [testObject performTestWithObject:ent selector:@selector(setClassName:) argument: @"EOGenericRecord"];
  [testObject performTestWithObject:model selector:@selector(addEntity:) argument:ent];
  
  [testObject performTestWithObject:ec selector:@selector(insertObject:) argument:attrib];
  [testObject performTestWithObject:attrib selector:@selector(setName:) argument:@"anAttribute"];
  [testObject performTestWithObject:ent selector:@selector(addAttribute:) argument:attrib];
  
  RELEASE(pool);
  return 0;
}

