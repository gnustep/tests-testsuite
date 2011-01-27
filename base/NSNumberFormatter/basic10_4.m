#import <Foundation/Foundation.h>
#import "Testing.h"
#import "ObjectTesting.h"

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  NSNumberFormatter *fmt;
  NSNumber *num;
  NSString *str;

  fmt = [[[NSNumberFormatter alloc] init] autorelease];
  num = [[[NSNumber alloc] initWithFloat: 1234.567] autorelease];

  str = [fmt stringFromNumber: num];
  pass([str isEqual: @"1,234.57"], "default 10.4 format same as Cocoa");

  [fmt setMaximumFractionDigits: 0];
  str = [fmt stringFromNumber: num];

  pass([str isEqual: @"1,235"], "round up for fractional part >0.5");

  num = [[[NSNumber alloc] initWithFloat: 1234.432] autorelease];
  str = [fmt stringFromNumber: num];

  pass([str isEqual: @"1,234"], "round down for fractional part <0.5");

  [fmt setNumberStyle: NSNumberFormatterNoStyle];
  [fmt setMaximumFractionDigits: 0];
  [fmt setFormatWidth: 6];
  [fmt setPositivePrefix: @"+"];
  [fmt setPaddingCharacter: @"0"];
  [fmt setPaddingPosition: NSNumberFormatterPadBeforePrefix];
  str = [fmt stringFromNumber: num];
  
  pass([str isEqual: @"0+1234"], "numeric and space padding OK");

  num = [[[NSNumber alloc] initWithFloat: 1234.56] autorelease];
  [fmt setNumberStyle: NSNumberFormatterCurrencyStyle];
  [fmt setPositiveSuffix: @"c"];
  str = [fmt stringFromNumber: num];
  
  pass([str isEqual: @"$1,234.56c"], "prefix and suffix used properly");

  num = [[[NSNumber alloc] initWithFloat: -1234.56] autorelease];
  str = [fmt stringFromNumber: num];

  pass([str isEqual: @"($1,234.56)"], "negativeFormat used for -ve number");

  str = [fmt stringFromNumber: [NSDecimalNumber notANumber]];

  pass([str isEqual: @"NaN"], "notANumber special case");

  [fmt setNumberStyle: NSNumberFormatterNoStyle];
  [fmt setMaximumFractionDigits: 0];
  str = [fmt stringFromNumber: num];
  
  pass([str isEqual: @"-1235"], "format string of length 1");

  [arp release]; arp = nil;
  return 0;
}

