#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSIndexSet.h>
#include "../../Testing.h"
int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];

  [set addIndex:1];
  [set addIndex:2];
  [set addIndex:1];
  pass([set containsIndex:2], "contains index 2");
  pass([set containsIndex:1], "contains index 1");
  
  [pool release];
  return 0;
}
