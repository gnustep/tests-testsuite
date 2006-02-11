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

@end

int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  EOModel *model = globalModelForKey(TSTTradingModelName);
  EOArrayDataSource *ads;
  EOEditingContext *ec; 
  EOEntity *ent;
  id object;
  id testObject; 

  ent = [model entityNamed: @"Product"];
  [[EOModelGroup defaultGroup] addModel: model];
  ec = [EOEditingContext new];
  ads = [[EOArrayDataSource alloc] 
  		initWithClassDescription: [ent classDescriptionForInstances]
			  editingContext: ec];
  testObject = [[Test alloc] initWithEditingContext:ec];
  object = [ads createObject];
  [ads insertObject:object];
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
  [testObject resetTests];
  [object takeValue:[NSNumber numberWithInt:0] forKeyPath:@"productGroup"];
  [object takeValue:@"frob" forKeyPath:@"name"];
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
  pass([testObject recvObjsChangedNotif] == YES, "EOObserving causes EOObjectsChangedInEditingContextNotification");
  RELEASE(pool);
  return 0;
}

