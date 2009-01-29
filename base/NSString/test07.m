#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSString.h>

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  double d;

  pass([@"12" intValue] == 12, "simple intValue works");
  pass([@"-12" intValue] == -12, "negative intValue works");
  pass([@"+12" intValue] == 12, "positive intValue works");
  pass([@"1.2" intValue] == 1, "intValue ignores trailing data");
  pass([@"                                12" intValue] == 12,
    "intValue with leading space works");

  d = [@"1.2" doubleValue];
  pass(d > 1.199999 && d < 1.200001, "simple doubleValue works");
  d = [@"-1.2" doubleValue];
  pass(d < -1.199999 && d > -1.200001, "negative doubleValue works");
  d = [@"+1.2" doubleValue];
  pass(d > 1.199999 && d < 1.200001, "positive doubleValue works");
  d = [@"+1.2 x" doubleValue];
  pass(d > 1.199999 && d < 1.200001, "doubleValue ignores trailing data");
  d = [@"                                1.2" doubleValue];
  pass(d > 1.199999 && d < 1.200001, "doubleValue with leading space works");

  [arp release]; arp = nil;
  return 0;
}
