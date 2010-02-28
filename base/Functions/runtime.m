#import "Testing.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSException.h>
#import <Foundation/NSDebug.h>
#import <Foundation/NSObject.h>

#include        <objc/runtime.h>

@interface      Class1 : NSObject
{
  int   ivar1;
}
- (const char *) sel1;
@end

@implementation Class1
- (const char *) sel1
{
  return "";
}
@end

@interface      SubClass1 : Class1
{
  int   ivar2;
}
- (const char *) sel2;
@end

@implementation SubClass1
- (const char *) sel2
{
  return "";
}
@end

int
main(int argc, char *argv[])
{
  Class cls;
  Ivar  ivar;

  cls = [SubClass1 class];
  ivar = class_getInstanceVariable(cls, "bad name");
  pass(ivar == 0, "class_getInstanceVariable() returns 0 for non-existent");
  ivar = class_getInstanceVariable(cls, "ivar2");
  pass(ivar != 0, "class_getInstanceVariable() works");
  ivar = class_getInstanceVariable(cls, "ivar1");
  pass(ivar != 0, "class_getInstanceVariable() works for superclass ivar");

  exit(0);
}

