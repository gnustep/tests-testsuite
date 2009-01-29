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
  NSFileHandle *fh = [NSFileHandle fileHandleWithStandardInput];

  [fh retain];
  [fh readInBackgroundAndNotify];

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

  [fh closeFile];
  [fh release];

  [pool release];
  return 0;
}

