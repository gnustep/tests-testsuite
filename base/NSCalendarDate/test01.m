#include "Testing.h"
#include <Foundation/NSCalendarDate.h>
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSString.h>
int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSTimeInterval time1,time2,time3,time4,time5,time6,time7,time8,time9;
  NSCalendarDate *date1;

  time1 = [[NSCalendarDate dateWithString:@"Nov 20 02 01:54:22"
                           calendarFormat:@"%b %d %y %H:%M:%S"] 
			          timeIntervalSinceReferenceDate]; 
  time2 = [[NSCalendarDate dateWithString:@"Nov 20 02 02:54:22"
                           calendarFormat:@"%b %d %y %H:%M:%S"] 
			          timeIntervalSinceReferenceDate]; 
  time3 = [[NSCalendarDate dateWithString:@"Nov 20 02 03:54:22"
                           calendarFormat:@"%b %d %y %H:%M:%S"]
			          timeIntervalSinceReferenceDate]; 
  time4 = [[NSCalendarDate dateWithString:@"Nov 20 02 04:54:22"
                           calendarFormat:@"%b %d %y %H:%M:%S"]
			          timeIntervalSinceReferenceDate]; 
  time5 = [[NSCalendarDate dateWithString:@"Nov 20 02 05:54:22"
                          calendarFormat:@"%b %d %y %H:%M:%S"] 
			          timeIntervalSinceReferenceDate]; 
  time6 = [[NSCalendarDate dateWithString:@"Nov 20 02 06:54:22"
                          calendarFormat:@"%b %d %y %H:%M:%S"] 
			          timeIntervalSinceReferenceDate]; 
  time7 = [[NSCalendarDate dateWithString:@"Nov 20 02 07:54:22"
                          calendarFormat:@"%b %d %y %H:%M:%S"] 
			          timeIntervalSinceReferenceDate]; 
  time8 = [[NSCalendarDate dateWithString:@"Nov 20 02 08:54:22"
                          calendarFormat:@"%b %d %y %H:%M:%S"]
			          timeIntervalSinceReferenceDate]; 
  time9 = [[NSCalendarDate dateWithString:@"Nov 20 02 09:54:22"
                          calendarFormat:@"%b %d %y %H:%M:%S"] 
			          timeIntervalSinceReferenceDate]; 
 
  pass ((time1 < time2 && 
        time2 < time3 && 
	time3 < time4 && 
	time4 < time5 &&
	time5 < time6 &&
	time6 < time7 &&
	time7 < time8 &&
	time8 < time9), "+dateWithString:calendarFormat: works if no time zone is specified");
  
  date1 = [NSCalendarDate dateWithString:@"Nov 29 01:25:38" 
                          calendarFormat:@"%b %d %y %H:%M:%S"]; 
  pass([date1 timeIntervalSinceReferenceDate] + 1 == [[date1 addTimeInterval:1]
  						timeIntervalSinceReferenceDate],
       "-addTimeInterval: works on a NSCalendarDate parsed with no timezone");

  DESTROY(arp);
  return 0;
}
