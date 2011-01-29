#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSLocale.h>
#import "ObjectTesting.h"

int main(void)
{
  NSAutoreleasePool *arp = [NSAutoreleasePool new];
  NSLocale *locale;
  
  locale = [NSLocale systemLocale];
  pass (locale != nil, "+systemLocale returns non-nil");
  TEST_FOR_CLASS(@"NSLocale", locale, "+systemLocale return a NSLocale");
  
  locale = [NSLocale currentLocale];
  pass (locale != nil, "+currentLocale return non-nil");
  TEST_FOR_CLASS(@"NSLocale", locale, "+currentLocale return a NSLocale");
  
  RELEASE(arp);
  return 0;
}
