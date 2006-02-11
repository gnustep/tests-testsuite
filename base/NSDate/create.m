#include "Testing.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSDate.h>
#include <Foundation/NSString.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSString *val;
  NSDate *date1,*date2;

  val = @"2000-10-19";
  date1 = [NSDate date];
  pass(date1 != nil && [date1 isKindOfClass:[NSDate class]],
       "+date works");
  date1 = [NSDate dateWithString:val];
  pass(date1 != nil && [date1 isKindOfClass:[NSDate class]],
       "+dateWithString works");

  date2 = [NSCalendarDate dateWithTimeIntervalSinceReferenceDate: 
   			    [date1 timeIntervalSinceReferenceDate]];
  pass(date2 != nil && [date2 isKindOfClass:[NSDate class]],
       "+dateWithTimeIntervalSinceReferenceDate: works");
  pass([date2 dayOfMonth] == 19, "+dateWithString makes correct day");
  pass([date2 monthOfYear] == 10, "+dateWithString makes correct month");
  pass([date2 yearOfCommonEra] == 2000, "+dateWithString makes correct year");
  
  date1 = [NSDate dateWithTimeIntervalSinceNow:0];
  pass(date1 != nil && [date1 isKindOfClass:[NSDate class]],
        "+dateWithTimeIntervalSinceNow: works");
  
  date1 = [NSDate dateWithTimeIntervalSince1970:0];
  pass(date1 != nil && [date1 isKindOfClass:[NSDate class]],
        "+dateWithTimeIntervalSince1970: works");
  
  date1 = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
  pass(date1 != nil && [date1 isKindOfClass:[NSDate class]],
        "+dateWithTimeIntervalSinceReferenceDate: works");
  
  date1 = [NSDate distantFuture];
  pass(date1 != nil && [date1 isKindOfClass:[NSDate class]],
       "+distantFuture works");
  
  date1 = [NSDate distantPast];
  pass(date1 != nil && [date1 isKindOfClass:[NSDate class]],
       "+distantPast works");
  
  DESTROY(arp);
  return 0;
}
