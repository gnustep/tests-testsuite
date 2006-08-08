#import "Testing.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSString.h>

int main()
{
  Class theClass = NSClassFromString(@"NSObject"); 
  pass(theClass == [NSObject class],
       "'NSObject' %s","uses +class to return self");
  return 0;
}
