#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSDate.h>
#import <Foundation/NSKeyValueCoding.h>
#import <Foundation/NSValue.h>
#import <Foundation/NSDecimalNumber.h>

@interface TestClass : NSObject
{
  NSString * name;
  NSDate * date;
  int num1;
  double num2;
  int num3;
  int num4;
  TestClass * child;
}

- (void)setNum3:(int)num;
- (int)num3;
- (void)_setNum4:(int)num;
- (int)_num4;

@end

@implementation TestClass

- (void)setNum3:(int)num
{
  num3 = num;
  if (num3 == 8) num3 = 7;
}

- (int)num3
{
  return num3;
}

- (void)_setNum4:(int)num
{
  num4 = num;
  if (num4 == 8) num4 = 7;
}

- (int)_num4
{
  return num4;
}
@end

@interface UndefinedKey : NSObject
{
  int num1;
  NSString * string;
}
@end

@implementation UndefinedKey
- (void)dealloc
{
  [string release];
  [super dealloc];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
  if ([key isEqualToString:@"Lücke"]) {
    [string release];
    string = [value copy];
  }
}

- (id)valueForUndefinedKey:(NSString *)key
{
  if ([key isEqualToString:@"Lücke"]) {
    return string;
  }
}

@end

@interface UndefinedKey2 : NSObject
{
  int num1;
  NSString * string;
}
@end

@implementation UndefinedKey2
- (void)dealloc
{
  [string release];
  [super dealloc];
}

- (void)handleTakeValue:(id)value forUnboundKey:(NSString *)key
{
  if ([key isEqualToString:@"Lücke"]) {
    [string release];
    string = [value copy];
  }
}

- (id)handleQueryWithUnboundKey:(NSString *)key
{
  if ([key isEqualToString:@"Lücke"]) {
    return string;
  }
}

@end

int main()
{
  CREATE_AUTORELEASE_POOL(arp);

  TestClass * tester = [[[TestClass alloc] init] autorelease];
  [tester setValue:[[[TestClass alloc] init] autorelease] forKey:@"child"];
  UndefinedKey * undefinedKey = [[[UndefinedKey alloc] init] autorelease];
  UndefinedKey2 * undefinedKey2 = [[[UndefinedKey2 alloc] init] autorelease];

  NSNumber * n = [NSNumber numberWithInt:8];
  NSNumber * adjustedN = [NSNumber numberWithInt:7];
  NSNumber * n2 = [NSNumber numberWithDouble:87.999];

  [tester setValue:@"tester" forKey:@"name"];
  pass([[tester valueForKey:@"name"] isEqualToString:@"tester"],
      "KVC works with strings");
  [tester setValue:n forKey:@"num1"];
  pass([[tester valueForKey:@"num1"] isEqualToNumber:n],
      "KVC works with ints");
  [tester setValue:n2 forKey:@"num2"];
  pass([[tester valueForKey:@"num2"] isEqualToNumber:n2],
      "KVC works with doubles");

  [tester setValue:n forKey:@"num3"];
  pass([[tester valueForKey:@"num3"] isEqualToNumber:adjustedN],
      "KVC works with setKey:");
  [tester setValue:n forKey:@"num4"];
  pass([[tester valueForKey:@"num4"] isEqualToNumber:adjustedN],
      "KVC works with _setKey:");

  [undefinedKey setValue:@"GNUstep" forKey:@"Lücke"];
  pass([[undefinedKey valueForKey:@"Lücke"] isEqualToString:@"GNUstep"],
      "KVC works with undefined keys");

  [undefinedKey2 setValue:@"GNUstep" forKey:@"Lücke"];
  pass([[undefinedKey2 valueForKey:@"Lücke"] isEqualToString:@"GNUstep"],
      "KVC works with undefined keys (using deprecated methods)");

  TEST_EXCEPTION(
    [tester setValue:@"" forKey:@"nonexistent"],
    NSUndefinedKeyException, YES,
    "KVC properly throws @\"NSUnknownKeyException\"");

  TEST_EXCEPTION(
    [tester setValue:@"" forKey:@"nonexistent"],
    NSUndefinedKeyException, YES,
    "KVC properly throws NSUndefinedKeyException");

  TEST_EXCEPTION(
    [tester setValue:@"" forKeyPath:@"child.nonexistent"],
    @"NSUnknownKeyException", YES,
    "KVC properly throws @\"NSUnknownKeyException\" with key paths");

  TEST_EXCEPTION(
    [tester setValue:@"" forKeyPath:@"child.nonexistent"],
    NSUndefinedKeyException, YES,
    "KVC properly throws NSUndefinedKeyException with key paths");

  IF_NO_GC(DESTROY(arp));
  return 0;
}
