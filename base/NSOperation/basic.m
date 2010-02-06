#import <Foundation/NSOperation.h>
#import <Foundation/NSThread.h>
#import <Foundation/NSAutoreleasePool.h>
#import "ObjectTesting.h"


int main()
{
  id                    obj1;
  id                    obj2;
  NSMutableArray        *testObjs = [[NSMutableArray alloc] init];
  NSAutoreleasePool     *arp = [NSAutoreleasePool new];

  test_alloc(@"NSOperation"); 
  obj1 = [NSOperation new];
  pass((obj1 != nil), "can create an operation");
  [testObjs addObject: obj1];
  test_NSObject(@"NSOperation", testObjs);
  
  pass(([obj1 isReady] == YES), "operation is ready");
  pass(([obj1 isConcurrent] == NO), "operation is not concurrent");
  pass(([obj1 isCancelled] == NO), "operation is not cancelled");
  pass(([obj1 isExecuting] == NO), "operation is not executing");
  pass(([obj1 isFinished] == NO), "operation is not finished");
  pass(([[obj1 dependencies] isEqual: [NSArray array]]),
    "operation has no dependencies");
  pass(([obj1 queuePriority] == NSOperationQueuePriorityNormal),
    "operation has normal priority");
  [obj1 setQueuePriority: 10000];
  pass(([obj1 queuePriority] == NSOperationQueuePriorityVeryHigh),
    "operation has very high priority");

  obj2 = [NSOperation new];
  [obj2 addDependency: obj1];
  pass(([[obj2 dependencies] isEqual: testObjs]),
    "operation has added dependency");
  pass(([obj2 isReady] == NO), "operation with dependency is not ready");
  [obj1 cancel];
  pass(([[obj2 dependencies] isEqual: testObjs]),
    "cancelled dependency continues");
  pass(([obj1 isCancelled] == YES), "operation is cancelled");
  pass(([[obj2 dependencies] isEqual: testObjs]),
    "cancelled dependency continues");
  pass(([obj2 isReady] == NO), "operation with cancelled dependency not ready");
  [obj2 removeDependency: obj1];
  pass(([[obj2 dependencies] isEqual: [NSArray array]]),
    "dependency removal works");
  pass(([obj2 isReady] == YES), "operation without dependency is ready");

  [obj1 release];
  obj1 = [NSOperation new];
  [testObjs replaceObjectAtIndex: 0 withObject: obj1];
  [obj2 addDependency: obj1];
  [obj1 start];

  [NSThread sleepForTimeInterval: 1.0];
  pass(([obj1 isFinished] == YES), "operation is finished");
  pass(([obj1 isReady] == YES), "a finished operation is ready");
  pass(([[obj2 dependencies] isEqual: testObjs]),
    "finished dependency continues");
  pass(([obj2 isReady] == YES), "operation with finished dependency is ready");

  [obj2 removeDependency: obj1];
  [obj1 release];
  obj1 = [NSOperation new];
  [testObjs replaceObjectAtIndex: 0 withObject: obj1];
  [obj2 addDependency: obj1];
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


  test_alloc(@"NSOperationQueue"); 
  obj1 = [NSOperationQueue new];
  pass((obj1 != nil), "can create an operation queue");
  [testObjs removeAllObjects];
  [testObjs addObject: obj1];
  test_NSObject(@"NSOperationQueue", testObjs);
  
  pass(([obj1 isSuspended] == NO), "not suspended by default");
  [obj1 setSuspended: YES];
  pass(([obj1 isSuspended] == YES), "set suspended yes");
  [obj1 setSuspended: NO];
  pass(([obj1 isSuspended] == NO), "set suspended no");

  pass(([[obj1 name] length] > 0), "name has a default");
  [obj1 setName: @"mine"];
  pass(([[obj1 name] isEqual: @"mine"] == YES), "set name OK");
  [obj1 setName: nil];
  pass(([[obj1 name] isEqual: @""]), "setting null name gives empty string");

  pass(([obj1 maxConcurrentOperationCount] == NSOperationQueueDefaultMaxConcurrentOperationCount), "max concurrent set by default");
  [obj1 setMaxConcurrentOperationCount: 1];
  pass(([obj1 maxConcurrentOperationCount] == 1), "max concurrent set to one");
  [obj1 setMaxConcurrentOperationCount: 0];
  pass(([obj1 maxConcurrentOperationCount] == 0), "max concurrent set to zero");
  [obj1 setMaxConcurrentOperationCount: 1000000];
  pass(([obj1 maxConcurrentOperationCount] == 1000000), "max concurrent set to a million");
  [obj1 setMaxConcurrentOperationCount: NSOperationQueueDefaultMaxConcurrentOperationCount];
  pass(([obj1 maxConcurrentOperationCount] == NSOperationQueueDefaultMaxConcurrentOperationCount), "max concurrent set to default");
  TEST_EXCEPTION([obj1 setMaxConcurrentOperationCount: -1000000];,
  		 NSInvalidArgumentException, YES, 
		 "NSOperationQueue cannot be given neagative count");

  obj2 = [NSOperation new];
  [obj1 addOperation: obj2];
  [NSThread sleepForTimeInterval: 1.0];
  pass(([obj2 isFinished] == YES), "queue ran operation");

  [arp release]; arp = nil;
  return 0;
}
