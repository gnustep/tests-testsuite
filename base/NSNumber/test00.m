#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSPropertyList.h>
#import <Foundation/NSValue.h>

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  NSNumber *val1, *val2, *val3;
  double d;

  val1 = [NSNumber numberWithBool:YES];
  pass(val1 != nil, "We can create a boolean (YES)");
  
  val2 = [NSNumber numberWithBool:NO];
  pass(val2 != nil, "We can create a boolean (NO)");
  
  pass(![val1 isEqual:val2], "A boolean YES is not a NO");
  pass(![val2 isEqual:val1], "A boolean NO is not a YES");
  pass([val1 isEqual:[NSNumber numberWithBool:YES]], "A boolean YES is a YES");
  pass([val2 isEqual:[NSNumber numberWithBool:NO]], "A boolean NO is a NO");
  
  val1 = [NSNumber numberWithChar:99];
  pass(val1 != nil, "We can create a char number");
  val1 = [NSNumber numberWithChar:-1];
  pass(val1 != nil, "We can create a signed char number");
  val2 = [NSNumber numberWithUnsignedChar:255];
  pass(val2 != nil, "We can create an unsigned char number");
  pass(![val1 isEqual:val2], "A -1 signed char is not a 255 unsigned char");
  pass([val1 isEqual:[NSNumber numberWithChar:255]], 
       "A -1 signed char is a 255 signed char");
  
  val1 = [NSNumber numberWithChar:-100];
  pass([val1 isEqual:[NSNumber numberWithShort:-100]],
       "A -100 signed char is a -100 signed short");
  pass([val1 isEqual:[NSNumber numberWithInt:-100]],
       "A -100 signed char is a -100 signed int");
  pass([val1 isEqual:[NSNumber numberWithLong:-100]],
       "A -100 signed char is a -100 signed long");
  pass([val1 isEqual:[NSNumber numberWithLongLong:-100]],
       "A -100 signed char is a -100 signed long long");
  pass([val1 isEqual:[NSNumber numberWithFloat:-100.0]],
       "A -100 signed char is a -100 signed float");
  pass([val1 isEqual:[NSNumber numberWithDouble:-100.0]],
       "A -100 signed char is a -100 signed double");

  val1 = [NSNumber numberWithInt:127];
  val2 = [NSNumber numberWithInt:128];
  pass([val2 compare:val1] == NSOrderedDescending, 
       "integer numbers - 127 < 128"); 
  pass([val1 compare:val2] == NSOrderedAscending, 
       "integer numbers - 128 > 127"); 
  val1 = [NSNumber numberWithChar:100];
  val2 = [NSNumber numberWithChar:200];
  val3 = [NSNumber numberWithInt:200];
  pass(![val2 isEqual:val3], "A 200 signed char is not a 200 int");
  pass([val2 compare:val1] == NSOrderedAscending, 
       "signed char numbers - 200 < 100");
  pass([val1 compare:val2] == NSOrderedDescending,
       "signed char numbers - 100 > 200");

#if     defined(GNUSTEP_BASE_LIBRARY)
  pass([[NSPropertyListSerialization propertyListFromData: [NSPropertyListSerialization dataFromPropertyList: [NSNumber numberWithInt:-10] format: NSPropertyListGNUstepFormat errorDescription: 0] mutabilityOption: NSPropertyListImmutable format: 0 errorDescription: 0] intValue] == -10,
    "store negative integer in property list works");
  pass((d = [[NSPropertyListSerialization propertyListFromData: [NSPropertyListSerialization dataFromPropertyList: [NSNumber numberWithDouble:-1.2] format: NSPropertyListGNUstepFormat errorDescription: 0] mutabilityOption: NSPropertyListImmutable format: 0 errorDescription: 0] doubleValue]) > -1.21 && d < -1.19,
    "store negative double in property list works");
#endif

  [arp release]; arp = nil;
  return 0;
}
