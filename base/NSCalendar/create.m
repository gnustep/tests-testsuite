#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSLocale.h>
#import <Foundation/NSCalendar.h>
#import "ObjectTesting.h"

int main(void)
{
  NSAutoreleasePool *arp = [NSAutoreleasePool new];
  NSCalendar *cal;
  
  cal = [NSCalendar currentCalendar];
  pass (cal != nil, "+currentCalendar returns non-nil");
  TEST_FOR_CLASS(@"NSCalendar", cal, "+currentCalendar return a NSCalendar");
  
  cal = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
  pass (cal != nil, "-initWithCalendarIdentifier: return non-nil");
  TEST_FOR_CLASS(@"NSCalendar", cal,
    "-initWithCalendarIdentifier: return a NSCalendar");
  RELEASE(cal);
  
  RELEASE(arp);
  return 0;
}
