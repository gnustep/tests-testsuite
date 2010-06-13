#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSPropertyList.h>
#import <Foundation/NSValue.h>
#import <Foundation/NSDecimalNumber.h>

#include <stdlib.h>
#include <limits.h>

#if	!defined(LLONG_MAX)
#  if	defined(__LONG_LONG_MAX__)
#    define LLONG_MAX __LONG_LONG_MAX__
#    define LLONG_MIN	(-LLONG_MAX-1)
#    define ULLONG_MAX	(LLONG_MAX * 2ULL + 1)
#  else
#    error Neither LLONG_MAX nor __LONG_LONG_MAX__ found
#  endif
#endif

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  NSNumber *val1, *val2, *val3;
  NSArray *a;
  id    o;
  double d;

  val1 = [NSNumber numberWithBool:YES];
  pass(val1 != nil, "We can create a boolean (YES)");
  
  val2 = [NSNumber numberWithBool:NO];
  pass(val2 != nil, "We can create a boolean (NO)");
  
  pass(![val1 isEqual:val2], "A boolean YES is not a NO");
  pass(![val2 isEqual:val1], "A boolean NO is not a YES");
  pass([val1 isEqual:[NSNumber numberWithBool:YES]], "A boolean YES is a YES");
  pass([val2 isEqual:[NSNumber numberWithBool:NO]], "A boolean NO is a NO");
  
  val1 = [NSNumber numberWithChar: 99];
  pass(val1 != nil, "We can create a char number");
  val1 = [NSNumber numberWithChar: -1];
  pass(val1 != nil, "We can create a signed char number");
  val2 = [NSNumber numberWithUnsignedChar: 255];
  pass(val2 != nil, "We can create an unsigned char number");
  pass(![val1 isEqual: val2], "A -1 signed char is not a 255 unsigned char");
  pass([val1 isEqual: [NSNumber numberWithChar: 255]], 
       "A -1 signed char is a 255 signed char");
  
  val1 = [NSNumber numberWithChar: -100];
  pass([val1 isEqual: [NSNumber numberWithShort: -100]],
       "A -100 signed char is a -100 signed short");
  pass([val1 isEqual: [NSNumber numberWithInt: -100]],
       "A -100 signed char is a -100 signed int");
  pass([val1 isEqual: [NSNumber numberWithLong: -100]],
       "A -100 signed char is a -100 signed long");
  pass([val1 isEqual: [NSNumber numberWithLongLong: -100]],
       "A -100 signed char is a -100 signed long long");
  pass([val1 isEqual: [NSNumber numberWithFloat: -100.0]],
       "A -100 signed char is a -100 signed float");
  pass([val1 isEqual: [NSNumber numberWithDouble: -100.0]],
       "A -100 signed char is a -100 signed double");
  pass([val1 isEqual: [NSNumber numberWithInteger: -100]],
       "A -100 signed char is a -100 NSInteger");

  pass([val1 shortValue] == (signed short)-100,
       "A -100 signed char is a -100 signed short");
  pass([val1 intValue] == (signed int)-100,
       "A -100 signed char is a -100 signed int");
  pass([val1 longValue] == (signed long)-100,
       "A -100 signed char is a -100 signed long");
  pass([val1 longLongValue] == (signed long long)-100,
       "A -100 signed char is a -100 signed long long");
  pass([val1 floatValue] == (float)-100.0,
       "A -100 signed char is a -100 signed float");
  pass([val1 doubleValue] == (double)-100.0,
       "A -100 signed char is a -100 signed double");
  pass([val1 integerValue] == (NSInteger)-100,
       "A -100 signed char is a -100 NSInteger");
  pass([val1 boolValue] == YES,
       "A -100 signed char is a YES BOOL");

  val1 = [NSNumber numberWithInt: 127];
  val2 = [NSNumber numberWithInt: 128];
  pass([val2 compare: val1] == NSOrderedDescending, 
       "integer numbers - 127 < 128"); 
  pass([val1 compare: val2] == NSOrderedAscending, 
       "integer numbers - 128 > 127"); 
  val1 = [NSNumber numberWithChar: 100];
  val2 = [NSNumber numberWithChar: 200];
  val3 = [NSNumber numberWithInt: 200];
  pass(![val2 isEqual: val3], "A 200 signed char is not a 200 int");
  pass([val2 compare: val1] == NSOrderedAscending, 
       "signed char numbers - 200 < 100");
  pass([val1 compare: val2] == NSOrderedDescending,
       "signed char numbers - 100 > 200");

  pass(5 == (NSUInteger)[[NSNumber numberWithUnsignedInteger: 5] pointerValue],
    "pointerValue works");

  val1 = [NSDecimalNumber numberWithInt: 200];
  pass(200 == [val1 intValue],
    "NSDecimalNumber numberWithInt: works");
  val1 = [NSDecimalNumber decimalNumberWithString: @"200"];
  pass(200.0 == [val1 floatValue],
    "NSDecimalNumber floatValue works");
  pass(200.0 == [val1 doubleValue],
    "NSDecimalNumber doubleValue works");
  pass(YES == [val1 boolValue],
    "NSDecimalNumber boolValue works");
  pass((char)200 == [val1 charValue],
    "NSDecimalNumber charValue works");
  pass(200 == [val1 intValue],
    "NSDecimalNumber intValue works");
  pass(200 == [val1 integerValue],
    "NSDecimalNumber integerValue works");
  pass(200 == [val1 longValue],
    "NSDecimalNumber longValue works");
  pass(200 == [val1 longLongValue],
    "NSDecimalNumber longLongValue works");
  pass(200 == [val1 shortValue],
    "NSDecimalNumber shortValue works");
  pass(200 == [val1 unsignedCharValue],
    "NSDecimalNumber unsignedCharValue works");
  pass(200 == [val1 unsignedIntValue],
    "NSDecimalNumber unsignedIntValue works");
  pass(200 == [val1 unsignedIntegerValue],
    "NSDecimalNumber unsignedIntegerValue works");
  pass(200 == [val1 unsignedLongValue],
    "NSDecimalNumber unsignedLongValue works");
  pass(200 == [val1 unsignedLongLongValue],
    "NSDecimalNumber unsignedLongLongValue works");
  pass(200 == [val1 unsignedShortValue],
    "NSDecimalNumber unsignedShortValue works");

  val1 = [[NSNumber alloc] initWithLongLong: LLONG_MIN];
  val2 = [[NSNumber alloc] initWithUnsignedLongLong:
    (unsigned long long)LLONG_MAX + 1];
  pass([val1 compare: val2] == NSOrderedAscending,
   "comparison of min signed with max unsigned works");

  a = [NSArray arrayWithObjects:
    [NSNumber numberWithUnsignedLongLong: ULLONG_MAX],
    [NSNumber numberWithInt: -2],
    [NSNumber numberWithFloat: 300.057],
    [NSNumber numberWithInt: 1],
    [NSNumber numberWithDouble: 200.0123],
    [NSNumber numberWithLongLong: LLONG_MIN],
    nil];
  a = [a sortedArrayUsingSelector: @selector(compare:)];
  pass([[a objectAtIndex: 0] longLongValue] == LLONG_MIN
    && [[a objectAtIndex: 1] longLongValue] == -2
    && [[a objectAtIndex: 2] longLongValue] == 1
    && [[a objectAtIndex: 3] longLongValue] == 200
    && [[a objectAtIndex: 4] longLongValue] == 300
    && [[a objectAtIndex: 5] unsignedLongLongValue] == ULLONG_MAX,
    "sorted numbers are correctly ordered");

#if     defined(GNUSTEP_BASE_LIBRARY)
  pass([[NSPropertyListSerialization propertyListFromData: [NSPropertyListSerialization dataFromPropertyList: [NSNumber numberWithInt: -10] format: NSPropertyListGNUstepFormat errorDescription: 0] mutabilityOption: NSPropertyListImmutable format: 0 errorDescription: 0] intValue] == -10,
    "store negative integer in property list works");
  pass((d = [[NSPropertyListSerialization propertyListFromData: [NSPropertyListSerialization dataFromPropertyList: [NSNumber numberWithDouble: -1.2] format: NSPropertyListGNUstepFormat errorDescription: 0] mutabilityOption: NSPropertyListImmutable format: 0 errorDescription: 0] doubleValue]) > -1.21 && d < -1.19,
    "store negative double in property list works");
#endif

  o = [NSDecimalNumber numberWithDouble: 66.66];   
  pass([o isKindOfClass: [NSDecimalNumber class]], "+numberWith... subclass");

  [arp release]; arp = nil;
  return 0;
}
