#import <Foundation/NSOperation.h>
#import <Foundation/NSThread.h>
#import <Foundation/NSAutoreleasePool.h>
#import "ObjectTesting.h"


int main()
{
  NSOperation           *obj;
  NSOperation           *obj2;
  NSMutableArray        *testObjs = [[NSMutableArray alloc] init];
  NSAutoreleasePool     *arp = [NSAutoreleasePool new];

  test_alloc(@"NSOperation"); 
  obj = [NSOperation new];
  pass((obj != nil), "can create an operation");
  [testObjs addObject: obj];
  test_NSObject(@"NSOperation", testObjs);
  
  pass(([obj isReady] == YES), "operation is ready");
  pass(([obj isConcurrent] == NO), "operation is not concurrent");
  pass(([obj isCancelled] == NO), "operation is not cancelled");
  pass(([obj isExecuting] == NO), "operation is not executing");
  pass(([obj isFinished] == NO), "operation is not finished");
  pass(([[obj dependencies] isEqual: [NSArray array]]),
    "operation has no dependencies");
  pass(([obj queuePriority] == NSOperationQueuePriorityNormal),
    "operation has normal priority");
  [obj setQueuePriority: 10000];
  pass(([obj queuePriority] == NSOperationQueuePriorityVeryHigh),
    "operation has very high priority");

  obj2 = [NSOperation new];
  [obj2 addDependency: obj];
  pass(([[obj2 dependencies] isEqual: testObjs]),
    "operation has added dependency");
  pass(([obj2 isReady] == NO), "operation with dependency is not ready");
  [obj cancel];
  pass(([[obj2 dependencies] isEqual: testObjs]),
    "cancelled dependency continues");
  pass(([obj isCancelled] == YES), "operation is cancelled");
  pass(([[obj2 dependencies] isEqual: testObjs]),
    "cancelled dependency continues");
  pass(([obj2 isReady] == NO), "operation with cancelled dependency not ready");
  [obj2 removeDependency: obj];
  pass(([[obj2 dependencies] isEqual: [NSArray array]]),
    "dependency removal works");
  pass(([obj2 isReady] == YES), "operation without dependency is ready");

  [obj release];
  obj = [NSOperation new];
  [testObjs replaceObjectAtIndex: 0 withObject: obj];
  [obj2 addDependency: obj];
  [obj start];

  [NSThread sleepForTimeInterval: 1.0];
  pass(([obj isFinished] == YES), "operation is finished");
  pass(([obj isReady] == YES), "a finished operation is ready");
  pass(([[obj2 dependencies] isEqual: testObjs]),
    "finished dependency continues");
  pass(([obj2 isReady] == YES), "operation with finished dependency is ready");

  [obj2 removeDependency: obj];
  [obj release];
  obj = [NSOperation new];
  [testObjs replaceObjectAtIndex: 0 withObject: obj];
  [obj2 addDependency: obj];
  [obj2 cancel];
  pass(([obj2 isReady] == YES),
    "a cancelled object is ready even with a dependency");

  [obj2 start];
  pass(([obj2 isFinished] == YES),
    "a cancelled object can finish");

  TEST_EXCEPTION([obj2 start];,
  		 NSInvalidArgumentException, YES, 
		 "NSOperation cannot be started twice");

  pass(([obj2 waitUntilFinished], YES), "wait returns at once");

  [arp release]; arp = nil;
  return 0;
}
