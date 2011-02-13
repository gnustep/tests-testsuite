#import "Testing.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSException.h>
#import <Foundation/NSDebug.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSString.h>
#import <Foundation/NSObjCRuntime.h>

#include        <string.h>
#include        <objc/runtime.h>

static int      c1count = 0;
static int      c1initialize = 0;
static int      c1load = 0;

@interface      Class1 : NSObject
{
  int   ivar1;
  Class1 *ivar1obj;
}
- (const char *) sel1;
@end

@implementation Class1
+ (void) initialize
{
  if (self == [Class1 class])
    c1initialize = ++c1count;
}
+ (void) load
{
  c1load = ++c1count;
}
- (const char *) sel1
{
  return "";
}
@end

@protocol       SubProto
- (const char *) sel2;
@end

@interface      SubClass1 : Class1 <SubProto>
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
  id            obj;
  Class         cls;
  Class         meta;
  SEL           sel;
  Ivar          ivar;
  Ivar          *ivars;
  unsigned int  count;
  unsigned int  index;
  Method        method;
  Method        *methods;
  Protocol      **protocols;
  NSUInteger    s;
  NSUInteger    a;
  const char    *t0;
  const char    *t1;

  t0 = "1@1:@";
  t1 = NSGetSizeAndAlignment(t0, &s, &a);
  pass(t1 == &t0[2], "NSGetSizeAndAlignment() steps through id");
  t1 = NSGetSizeAndAlignment(t1, &s, &a);
  pass(t1 == &t0[4], "NSGetSizeAndAlignment() steps through sel");

  pass(NO == class_isMetaClass(Nil),
    "class_isMetaClass() returns NO for Nil");
  pass(Nil == class_getSuperclass(Nil),
    "class_getSuperclass() returns NO for Nil");
  pass(strcmp(class_getName(Nil), "nil") == 0,
    "class_getName() for Nil is nil");
  pass(0 == class_getInstanceVariable(Nil, 0), 
    "class_getInstanceVariables() for Nil,0 is 0");
  pass(0 == class_getVersion(Nil), 
    "class_getVersion() for Nil is 0");

  obj = [NSObject new];
  cls = [SubClass1 class];

  pass(c1initialize != 0, "+initialize was called");
  pass(c1load != 0, "+load was called");
  pass(c1initialize > c1load, "+load occurs before +initialize");
  pass(strcmp(class_getName(cls), "SubClass1") == 0, "class name works");
  pass(YES == class_respondsToSelector(cls, @selector(sel2)),
    "class_respondsToSelector() works for class method");
  pass(YES == class_respondsToSelector(cls, @selector(sel1)),
    "class_respondsToSelector() works for superclass method");
  pass(NO == class_respondsToSelector(cls, @selector(rangeOfString:)),
    "class_respondsToSelector() returns NO for unknown method");
  pass(NO == class_respondsToSelector(cls, 0),
    "class_respondsToSelector() returns NO for nul selector");
  pass(NO == class_respondsToSelector(0, @selector(sel1)),
    "class_respondsToSelector() returns NO for nul class");
  meta = object_getClass(cls);
  pass(class_isMetaClass(meta), "object_getClass() retrieves meta class");
  pass(strcmp(class_getName(meta), "SubClass1") == 0, "metaclass name works");
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

  method = methods[2];
  sel = method_getName(method);
  pass(sel_isEqual(sel, sel_getUid("sel2")),
    "last method is sel2");
  pass(method_getImplementation(method) != [cls instanceMethodForSelector: sel],
    "method 2 is the original, overridden by the category");

  method = methods[0];
  sel = method_getName(method);
  pass(sel_isEqual(sel, sel_getUid("catMethod"))
    || sel_isEqual(sel, sel_getUid("sel2")),
    "method 0 has expected name");

  if (sel_isEqual(sel, sel_getUid("catMethod")))
    {
      method = methods[1];
      sel = method_getName(method);
      pass(sel_isEqual(sel, sel_getUid("sel2")),
        "method 1 has expected name");
      pass(method_getImplementation(method)
        == [cls instanceMethodForSelector: sel],
        "method 1 is the category method overriding original");
    }
  else
    {
      pass(method_getImplementation(method)
        == [cls instanceMethodForSelector: sel],
        "method 0 is the category method overriding original");
      method = methods[1];
      sel = method_getName(method);
      pass(sel_isEqual(sel, sel_getUid("catMethod")),
        "method 1 has expected name");
    }

  ivars = class_copyIvarList(cls, &count);
  pass(count == 1, "SubClass1 has one ivar");
  pass(ivars[count] == 0, "ivar list is terminated");
  pass(strcmp(ivar_getName(ivars[0]), "ivar2") == 0,
    "ivar has correct name");
  pass(strcmp(ivar_getTypeEncoding(ivars[0]), @encode(int)) == 0,
    "ivar has correct type");

  protocols = class_copyProtocolList(cls, &count);
  pass(count == 1, "SubClass1 has one protocol");
  pass(protocols[count] == 0, "protocol list is terminated");
  pass(strcmp(protocol_getName(protocols[0]), "SubProto") == 0,
    "protocol has correct name");

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
  objc_registerClassPair (cls);
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

  /* NSObjCRuntime function tests.
   */
  sel = NSSelectorFromString(nil);
  pass(sel == 0,
    "NSSelectorFromString() returns 0 for nil string");
  pass(NSStringFromSelector(0) == nil,
    "NSStringFromSelector() returns nil for null selector");
  sel = NSSelectorFromString(@"xxxyyy_odd_name_xxxyyy");
  pass(sel != 0,
    "NSSelectorFromString() creates for non-existent selector");
  pass([NSStringFromSelector(sel) isEqual: @"xxxyyy_odd_name_xxxyyy"],
    "NSStringFromSelector() works for existing selector");

  return 0;
}

