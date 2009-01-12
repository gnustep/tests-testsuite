#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSTimeZone.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  id current;
  id localh;

  current = [NSTimeZone defaultTimeZone];
  pass(current != nil && [current isKindOfClass: [NSTimeZone class]],
       "+defaultTimeZone works");

  current = [NSTimeZone localTimeZone];
  pass(current != nil && [current isKindOfClass: [NSTimeZone class]],
       "+localTimeZone works");

  current = [NSTimeZone systemTimeZone];
  pass(current != nil && [current isKindOfClass: [NSTimeZone class]],
       "+systemTimeZone works");

  current = [NSTimeZone timeZoneForSecondsFromGMT: 900];
  pass(current != nil && [current isKindOfClass: [NSTimeZone class]],
       "+timeZoneForSecondsFromGMT works");

  current = [NSTimeZone timeZoneForSecondsFromGMT: 90000];
  pass(current == nil,
       "+timeZoneForSecondsFromGMT fails for bad offset");

  current = [NSTimeZone timeZoneWithAbbreviation: @"MST"];
  pass(current != nil && [current isKindOfClass: [NSTimeZone class]],
       "+timeZoneWithAbbreviation works");

  current = [NSTimeZone timeZoneWithName: @"GB"];
  pass(current != nil && [current isKindOfClass: [NSTimeZone class]],
       "+timeZoneWithName works");

  IF_NO_GC(DESTROY(arp));
  return 0;
}
