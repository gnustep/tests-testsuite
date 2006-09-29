#include <Foundation/NSAutoreleasePool.h>
#include "../GDL2Testing.h"
#include <EOAccess/EODatabaseDataSource.h>
#include <Foundation/NSRunLoop.h>
#include <unistd.h>

@interface Test : NSObject

@end
@implementation Test 
- (id) init
{
  self = [super init];
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
@end

int main()
{
  EODatabaseDataSource *ds1;
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  EOModel  *model;
  EOEditingContext *ec1 = nil;
  EOClassDescription *cd;
  id tmp1;
  
  [[Test alloc] init];  /* hack for NSRunLoop */
  model = globalModelForKey(@"TSTTradingModel.eomodeld");
  setupModel(model);
  createDatabaseWithModel(model);

  [[EOModelGroup defaultGroup] addModel: model];
  ec1 = [EOEditingContext new];
  ds1 = [[EODatabaseDataSource alloc] initWithEditingContext: ec1
					  	  entityName: @"Order"];
  cd = [[model entityNamed:@"Order"] classDescriptionForInstances];
  
  tmp1 = [ds1 createObject];
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
  [ds1 insertObject:tmp1];
  [tmp1 takeValue:[NSDate dateWithTimeIntervalSinceNow:999] forKey:@"date"];
  [pool dealloc];
  pool = [NSAutoreleasePool new]; 
  [ec1 saveChanges]; /* we shouldn't segfault here. 
  			2005-02-08  Matt Rice  <ratmice@yahoo.com>
			* EOControl/EOEditingContext.m (-_globalIDChanged:):...
  		      */ 
  pass(1, "save changes after destroying the pool doesn't segfault");
  pass([[ds1 fetchObjects] isEqual: [NSArray arrayWithObject: tmp1]], "save/fetch still works"); 
  dropDatabaseWithModel(model);

  DESTROY(pool);
  return 0;
}
