#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSTimeZone.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  id current;
  id localh = [NSTimeZone defaultTimeZone];
  int offset = [localh secondsFromGMT];

  current = [NSTimeZone timeZoneForSecondsFromGMT: 900];
  pass(current != nil && [current isKindOfClass: [NSTimeZone class]]
       && [current secondsFromGMT] == 900,
       "+timeZoneForSecondsFromGMT works");

  current = [NSTimeZone timeZoneForSecondsFromGMT: -45];
  pass(current != nil && [current isKindOfClass: [NSTimeZone class]]
       && [current secondsFromGMT] == -60,
       "+timeZoneForSecondsFromGMT rounds to minute");

  current = [NSTimeZone timeZoneForSecondsFromGMT: 7260];
  pass(current != nil && [current isKindOfClass: [NSTimeZone class]]
       && [[current name] isEqual: @"GMT+0201"],
       "+timeZoneForSecondsFromGMT has correct name");

  current = [NSTimeZone timeZoneForSecondsFromGMT: -3600];
  pass(current != nil && [current isKindOfClass: [NSTimeZone class]]
       && [[current abbreviation] isEqual: @"GMT-0100"],
       "+timeZoneForSecondsFromGMT has correct abbreviation");

  current = [NSTimeZone timeZoneForSecondsFromGMT: -3600];
  pass(current != nil && [current isKindOfClass: [NSTimeZone class]]
       && [current isDaylightSavingTime] == NO,
       "+timeZoneForSecondsFromGMT has DST NO");

  current = [NSTimeZone timeZoneForSecondsFromGMT: offset];
  [NSTimeZone setDefaultTimeZone: current];
  current = [NSTimeZone localTimeZone];
  pass(current != nil && [current isKindOfClass: [NSTimeZone class]]
       && [current secondsFromGMT] == offset
       && [current isDaylightSavingTime] == NO,
       "can set default time zone");

  IF_NO_GC(DESTROY(arp));
  return 0;
}
