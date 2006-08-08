#import "Testing.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSCalendarDate.h>
#import <Foundation/NSString.h>
@interface NSCalendarDate(TestAdditions)
-(BOOL)testDateValues:(int)y :(int)m :(int)d :(int)h :(int)i :(int)s;
@end
@implementation NSCalendarDate(TestAdditions)
-(BOOL)testDateValues:(int)y :(int)m :(int)d :(int)h :(int)i :(int)s
{  
  return (y == [self yearOfCommonEra] &&
          m == [self monthOfYear] &&
	  d == [self dayOfMonth] &&
	  h == [self hourOfDay] &&
	  i == [self minuteOfHour] &&
	  s == [self secondOfMinute]);
}
@end
int main()
{ 
  CREATE_AUTORELEASE_POOL(arp);
  NSString *val1,*val2;
  NSCalendarDate *date1, *date2;
  
  val1 = @"1999-12-31 23:59:59"; 
  val2 = @"%Y-%m-%d %H:%M:%S";
  
  /* Y2K checks */
  date1 = [NSCalendarDate calendarDate];
  pass(date1 != nil && [date1 isKindOfClass:[NSCalendarDate class]],
       "+calendarDate works");
  date1 = [NSCalendarDate dateWithString:val1 calendarFormat:val2];
  pass(date1 != nil, "+dateWithString:calendarFormat: works");
  date1 = [NSCalendarDate dateWithString:@"Fri Oct 27 08:41:14MDT 2000" calendarFormat:nil];
  pass(date1 != nil,"+dateWithString:calendarFormat: with nil format works");
  date1 = [NSCalendarDate dateWithString: @"1999-12-31 23:59:59" 
                          calendarFormat:val2];
  pass([date1 testDateValues:1999 :12 :31 :23 :59 :59],
       "date check with %s",[[date1 description] cString]);
  date2 = [date1 dateByAddingYears:0 months:0 days:0 hours:0 minutes:0 seconds:1];
  pass([date2 testDateValues:2000 :01 :01 :00 :00 :00], 
       "date check with %s",[[date2 description] cString]);
  
  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:0 minutes:0 seconds:1];
  pass([date2 testDateValues:2000 :01 :01 :00 :00 :01],
       "date check with %s",[[date2 description] cString]);
 
  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:1 minutes:0 seconds:0];
  pass([date2 testDateValues:2000 :01 :01 :01 :00 :01],
       "date check with %s",[[date2 description] cString]);
  
  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:-2 minutes:0 seconds:0];
  pass([date2 testDateValues:1999 :12 :31 :23 :00 :01],
       "date check with %s",[[date2 description] cString]);
  
  /* Y2K is a leap year checks */
  date2 = [NSCalendarDate dateWithString:@"2000-2-28 23:59:59" 
                          calendarFormat:val2];
   
  pass([date2 testDateValues:2000 :02 :28 :23 :59 :59],
       "date check with %s",[[date2 description] cString]);
  
  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:0 minutes:0 seconds:1];
  pass([date2 testDateValues:2000 :02 :29 :00 :00 :00],
       "date check with %s",[[date2 description] cString]);
  
  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:0 minutes:0 seconds:1];
  pass([date2 testDateValues:2000 :02 :29 :00 :00 :01],
       "date check with %s",[[date2 description] cString]);
  
  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:1 minutes:0 seconds:0];
  pass([date2 testDateValues:2000 :02 :29 :01 :00 :01],
       "date check with %s",[[date2 description] cString]);

  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:-2 minutes:0 seconds:0];
  pass([date2 testDateValues:2000 :02 :28 :23 :00 :01],
       "date check with %s",[[date2 description] cString]);
  
  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:5 minutes:0 seconds:0];
  pass([date2 testDateValues:2000 :02 :29 :04 :00 :01],
       "date check with %s",[[date2 description] cString]);
  
  date2 = [date2 dateByAddingYears:1 months:0 days:0 hours:0 minutes:0 seconds:0];
  pass([date2 testDateValues:2001 :03 :01 :04 :00 :01],
       "date check with %s",[[date2 description] cString]);
  
  date2 = [date2 dateByAddingYears:0 months:0 days:-1 hours:0 minutes:0 seconds:0];
  pass([date2 testDateValues:2001 :02 :28 :04 :00 :01],
       "date check with %s",[[date2 description] cString]);
  
  date2 = [date2 dateByAddingYears:1 months:0 days:1 hours:0 minutes:0 seconds:0];
  pass([date2 testDateValues:2002 :03 :01 :04 :00 :01],
       "date check with %s",[[date2 description] cString]);
  
  /* 2004 is a year leap check */
  date2 = [NSCalendarDate dateWithString:@"2004-2-28 23:59:59" 
                          calendarFormat:val2];
  pass([date2 testDateValues:2004 :02 :28 :23 :59 :59],
       "date check with %s",[[date2 description] cString]);
  
  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:0 minutes:0 seconds:1];
  pass([date2 testDateValues:2004 :02 :29 :00 :00 :00],
       "date check with %s",[[date2 description] cString]);
  
  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:0 minutes:0 seconds:1];
  pass([date2 testDateValues:2004 :02 :29 :00 :00 :01],
       "date check with %s",[[date2 description] cString]);
  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:1 minutes:0 seconds:0];
  pass([date2 testDateValues:2004 :02 :29 :01 :00 :01],
       "date check with %s",[[date2 description] cString]);

  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:-2 minutes:0 seconds:0];
  pass([date2 testDateValues:2004 :02 :28 :23 :00 :01],
       "date check with %s",[[date2 description] cString]);
  
  /* 2100 is not a leap year */

  date2 = [NSCalendarDate dateWithString:@"2100-2-28 23:59:59" calendarFormat:val2];
  pass([date2 testDateValues:2100 :02 :28 :23 :59 :59],
       "date check with %s",[[date2 description] cString]);
  
  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:0 minutes:0 seconds:1];
  pass([date2 testDateValues:2100 :03 :01 :00 :00 :00],
       "date check with %s",[[date2 description] cString]);
  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:0 minutes:0 seconds:1];
  pass([date2 testDateValues:2100 :03 :01 :00 :00 :01],
       "date check with %s",[[date2 description] cString]);
  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:1 minutes:0 seconds:0];
  pass([date2 testDateValues:2100 :03 :01 :01 :00 :01],
       "date check with %s",[[date2 description] cString]);

  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:-2 minutes:0 seconds:0];
  pass([date2 testDateValues:2100 :02 :28 :23 :00 :01],
       "date check with %s",[[date2 description] cString]);
  
  /* daylight savings time checks */
  [NSTimeZone setDefaultTimeZone: [NSTimeZone timeZoneWithName:@"GB"]];
  date2 = [NSCalendarDate dateWithString:@"2002-3-31 00:30:00" calendarFormat:val2];
  pass([date2 testDateValues:2002 :03 :31 :00 :30 :00],
       "date check with %s",[[date2 description] cString]);
  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:1 minutes:0 seconds:0];
  pass([date2 testDateValues:2002 :03 :31 :02 :30 :00],
       "date check with %s",[[date2 description] cString]);
  
  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:-1 minutes:0 seconds:0];
  pass([date2 testDateValues:2002 :03 :31 :00 :30 :00],
       "date check with %s",[[date2 description] cString]);

  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:2 minutes:0 seconds:0];
  pass([date2 testDateValues:2002 :03 :31 :02 :30 :00],
       "date check with %s",[[date2 description] cString]);
  
  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:-1 minutes:0 seconds:0];
  pass([date2 testDateValues:2002 :03 :31 :00 :30 :00],
       "date check with %s",[[date2 description] cString]);
  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:-1 minutes:0 seconds:0];
  pass([date2 testDateValues:2002 :03 :30 :23 :30 :00],
       "date check with %s",[[date2 description] cString]);
  /* End daylight savings checks */
  
  date2 = [NSCalendarDate dateWithString:@"2002-10-27 00:30:00" calendarFormat:val2];
  pass([date2 testDateValues:2002 :10 :27 :00 :30 :00],
       "date check with %s",[[date2 description] cString]);
  
  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:1 minutes:0 seconds:0];
  pass([date2 testDateValues:2002 :10 :27 :01 :30 :00],
       "date check with %s",[[date2 description] cString]);
  
  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:-1 minutes:0 seconds:0];
  pass([date2 testDateValues:2002 :10 :27 :00 :30 :00],
       "date check with %s",[[date2 description] cString]);

  date2 = [date2 dateByAddingYears:0 months:0 days:0 hours:2 minutes:0 seconds:0];
  pass([date2 testDateValues:2002 :10 :27 :02 :30 :00],
       "date check with %s",[[date2 description] cString]);
  

  DESTROY(arp);
  return 0;
}
