#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSKeyValueCoding.h>

@interface DefaultNil : NSObject
{
  int num;
}
@end

@implementation DefaultNil
- (id)init
{
  num = 7;
  return self;
}
@end

@interface DeprecatedNil : DefaultNil
- (void)unableToSetNilForKey:(NSString *)key;
@end

@implementation DeprecatedNil
- (void)unableToSetNilForKey:(NSString *)key
{
  num = 0;
}
@end

@interface SetNil : DefaultNil
- (void)setNilValueForKey:(NSString *)key;
@end

@implementation SetNil
- (void)setNilValueForKey:(NSString *)key
{
  num = 0;
}
@end


int main()
{
  CREATE_AUTORELEASE_POOL(arp);

  DefaultNil * defaultNil = [DefaultNil new];
  DeprecatedNil * deprecatedNil = [DeprecatedNil new];
  SetNil * setNil = [SetNil new];
  BOOL passed;

  passed = NO;

  NS_DURING
    [defaultNil setValue:nil forKey:@"num"];
  NS_HANDLER
    if ([[localException name] isEqualToString:NSInvalidArgumentException])
      passed = YES;
  NS_ENDHANDLER
  pass(passed, "NSKeyValueCoding handles setting nil for a scalar");

  [setNil setValue:nil forKey:@"num"];
  pass([[setNil valueForKey:@"num"] intValue] == 0,
    "NSKeyValueCoding uses setNilValueForKey:");

  [deprecatedNil setValue:nil forKey:@"num"];
  pass([[deprecatedNil valueForKey:@"num"] intValue] == 0,
    "NSKeyValueCoding uses deprecated unableToSetNilForKey:");


  DESTROY(arp);
  return 0;
}
