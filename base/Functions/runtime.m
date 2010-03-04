#import "Testing.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSException.h>
#import <Foundation/NSDebug.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSString.h>

#include        <objc/runtime.h>

@interface      Class1 : NSObject
{
  int   ivar1;
  Class1 *ivar1obj;
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

@interface      SubClass1 (Cat1)
- (BOOL) catMethod;
- (const char *) sel2;
@end

@implementation SubClass1 (Cat1)
- (BOOL) catMethod
{
  return YES;
}
- (const char *) sel2
{
  return "category sel2";
}
@end

int
main(int argc, char *argv[])
{
  Class         cls;
  Ivar          ivar;
  unsigned int  count;
  unsigned int  index;
  Method        *methods;

  cls = [SubClass1 class];

  ivar = class_getInstanceVariable(cls, 0);
  pass(ivar == 0, "class_getInstanceVariable() returns 0 for null name");
  ivar = class_getInstanceVariable(cls, "bad name");
  pass(ivar == 0, "class_getInstanceVariable() returns 0 for non-existent");
  ivar = class_getInstanceVariable(0, "ivar2");
  pass(ivar == 0, "class_getInstanceVariable() returns 0 for Nil class");
  ivar = class_getInstanceVariable(cls, "ivar2");
  pass(ivar != 0, "class_getInstanceVariable() works");
  ivar = class_getInstanceVariable(cls, "ivar1");
  pass(ivar != 0, "class_getInstanceVariable() works for superclass ivar");
  ivar = class_getInstanceVariable(cls, "ivar1obj");
  pass(ivar != 0, "class_getInstanceVariable() works for superclass obj ivar");

  methods = class_copyMethodList(cls, &count);
  pass(count == 3, "SubClass1 has three methods");
  pass(methods[count] == 0, "method list is terminated");

  cls = objc_allocateClassPair([NSString class], "runtime generated", 0);
  pass(cls != Nil, "can allocate a class pair");
  pass(class_addIvar(cls, "iv1", 1, 6, "c") == YES,
    "able to add iVar 'iv1'");
  pass(class_addIvar(cls, "iv2", 1, 5, "c") == YES,
    "able to add iVar 'iv2'");
  pass(class_addIvar(cls, "iv3", 1, 4, "c") == YES,
    "able to add iVar 'iv3'");
  pass(class_addIvar(cls, "iv4", 1, 3, "c") == YES,
    "able to add iVar 'iv4'");
  ivar = class_getInstanceVariable(cls, "iv1");
  pass(ivar != 0, "iv1 exists");
  pass(ivar_getOffset(ivar) == 64, "iv1 offset is 64");
  ivar = class_getInstanceVariable(cls, "iv2");
  pass(ivar != 0, "iv2 exists");
  pass(ivar_getOffset(ivar) == 96, "iv2 offset is 96");
  ivar = class_getInstanceVariable(cls, "iv3");
  pass(ivar != 0, "iv3 exists");
  pass(ivar_getOffset(ivar) == 112, "iv3 offset is 112");
  ivar = class_getInstanceVariable(cls, "iv4");
  pass(ivar != 0, "iv4 exists");
  pass(ivar_getOffset(ivar) == 120, "iv4 offset is 120");

  exit(0);
}

