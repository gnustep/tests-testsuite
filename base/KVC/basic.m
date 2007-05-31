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

int main()
{
  CREATE_AUTORELEASE_POOL(arp);

  TestClass * tester = [[TestClass alloc] init];
  [tester setValue:[[[TestClass alloc] init] autorelease] forKey:@"child"];

  NSNumber * n = [NSNumber numberWithInt:8];
  NSNumber * adjustedN = [NSNumber numberWithInt:7];
  NSNumber * n2 = [NSNumber numberWithDouble:87.999];

  [tester setValue:@"tester" forKey:@"name"];
  pass([[tester valueForKey:@"name"] isEqualToString:@"tester"],
      "NSKeyValueCoding works with strings");
  [tester setValue:n forKey:@"num1"];
  pass([[tester valueForKey:@"num1"] isEqualToNumber:n],
      "NSKeyValueCoding works with ints");
  [tester setValue:n2 forKey:@"num2"];
  pass([[tester valueForKey:@"num2"] isEqualToNumber:n2],
      "NSKeyValueCoding works with doubles");

  [tester setValue:n2 forKeyPath:@"child.num2"];
  pass([[tester valueForKeyPath:@"child.num2"] isEqualToNumber:n2],
      "NSKeyValueCoding works with paths");

  [tester setValue:n forKey:@"num3"];
  pass([[tester valueForKey:@"num3"] isEqualToNumber:adjustedN],
      "NSKeyValueCoding works with setKey:");
  [tester setValue:n forKey:@"num4"];
  pass([[tester valueForKey:@"num4"] isEqualToNumber:adjustedN],
      "NSKeyValueCoding works with _setKey:");


  [tester release];

  DESTROY(arp);
  return 0;
}
