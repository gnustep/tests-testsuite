#include "Testing.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSDate.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSDate *cdate, *date1, *date2;
  NSComparisonResult comp;
  
  cdate = [NSDate date];
  
  comp = [cdate compare: [NSDate distantFuture]];
  pass(comp == NSOrderedAscending, "+distantFuture is in the future");
  
  comp = [cdate compare: [NSDate distantPast]];
  pass(comp == NSOrderedDescending, "+distantPast is in the past");
  
  date1 = [NSDate dateWithTimeIntervalSinceNow:-600];
  date2 = [cdate earlierDate: date1];
  pass(date1 == date2, "-earlierDate works");
  
  date2 = [cdate laterDate: date1];
  pass(cdate == date2, "-laterDate works");
  
  date2 = [date1 addTimeInterval:0];
  pass ([date1 isEqualToDate:date2], "-isEqualToDate works");

  
  DESTROY(arp);
  return 0;
}

