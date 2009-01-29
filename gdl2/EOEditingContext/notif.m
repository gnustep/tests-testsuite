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
  return self;
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
  NSFileHandle *fh = [NSFileHandle fileHandleWithStandardInput];

  [fh retain];
  [fh readInBackgroundAndNotify];

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

  [fh closeFile];
  [fh release];
  [pool release];
  return 0;
}

