#import "ObjectTesting.h"
#import <Foundation/NSPointerArray.h>
#import <Foundation/NSAutoreleasePool.h>

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  NSString *val1, *val2, *val3;
  NSPointerArray *obj, *old;
  id vals[3];
  
  val1 = @"Hello";
  val2 = @"Goodbye";
  val3 = @"Testing";
  
  vals[0] = val1;
  vals[1] = val2;
  vals[2] = val3;

  obj = [[NSPointerArray new] autorelease];
  pass(obj != nil
    && [obj isKindOfClass:[NSPointerArray class]]
    && [obj count] == 0,
    "+new creates an empty pointer array");
  
  [obj addPointer: (void*)@"hello"];
  pass([obj count] == 1, "+addPointer: increments count");
  [obj addPointer: nil];
  pass([obj count] == 2, "+addPointer: works with nil");

  [obj insertPointer: (void*)vals[0] atIndex: 0];
  [obj insertPointer: (void*)vals[1] atIndex: 0];
  [obj insertPointer: (void*)vals[2] atIndex: 0];
  pass([obj count] == 5 && [obj pointerAtIndex: 2] == (void*)vals[0],
    "+insertPointer:atIndex: works");
  
  [arp release]; arp = nil;
  return 0;
} 

