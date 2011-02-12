#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSLocale.h>
#import "ObjectTesting.h"

int main(void)
{
  START_SET(GS_USE_ICU)

  NSLocale *locale;
  
  locale = [NSLocale systemLocale];
  pass (locale != nil, "+systemLocale returns non-nil");
  TEST_FOR_CLASS(@"NSLocale", locale, "+systemLocale return a NSLocale");
  
  locale = [NSLocale currentLocale];
  pass (locale != nil, "+currentLocale return non-nil");
  TEST_FOR_CLASS(@"NSLocale", locale, "+currentLocale return a NSLocale");
  
  END_SET("NSLocale create")

  return 0;
}
