#include "Testing.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSObject.h>
#include <Foundation/NSString.h>

int main()
{
  Class theClass = NSClassFromString(@"NSObject"); 
  pass(theClass == [NSObject class],
       "'NSObject' %s","uses +class to return self");
  return 0;
}
