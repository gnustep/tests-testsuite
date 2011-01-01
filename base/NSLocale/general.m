#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSLocale.h>
#import "ObjectTesting.h"

int main(void)
{
  NSAutoreleasePool *arp = [NSAutoreleasePool new];
  NSLocale *locale;
  NSString *str;
  NSDictionary *dict;
  
  // These tests don't really work all that well.  I need to come up with
  // something better.  Most of the ones that fail are because nil is returned.
  locale = [[NSLocale alloc] initWithLocaleIdentifier: @"es_ES_PREEURO"];
  TEST_FOR_CLASS(@"NSString", [locale objectForKey: NSLocaleIdentifier],
    "NSLocaleIdentifier key returns a NSString");
  TEST_FOR_CLASS(@"NSString", [locale objectForKey: NSLocaleLanguageCode],
    "NSLocaleLanguageCode key returns a NSString");
  TEST_FOR_CLASS(@"NSString", [locale objectForKey: NSLocaleCountryCode],
    "NSLocaleCountryCode key returns a NSString");
  TEST_FOR_CLASS(@"NSString", [locale objectForKey: NSLocaleScriptCode],
    "NSLocaleScriptCode key returns a NSString");
  TEST_FOR_CLASS(@"NSString", [locale objectForKey: NSLocaleVariantCode],
    "NSLocaleVariantCode key returns a NSString");
  TEST_FOR_CLASS(@"NSCharacterSet",
    [locale objectForKey: NSLocaleExemplarCharacterSet],
    "NSLocaleExemplarCharacterSet key returns a NSCharacterSet");
  TEST_FOR_CLASS(@"NSCalendar", [locale objectForKey: NSLocaleCalendar],
    "NSLocaleCalendar key returns a NSCalendar");
  TEST_FOR_CLASS(@"NSString", [locale objectForKey: NSLocaleCollationIdentifier],
    "NSLocaleCollationIdentifier key returns a NSString");
  TEST_FOR_CLASS(@"NSNumber", [locale objectForKey: NSLocaleUsesMetricSystem],
    "NSLocaleUsesMetricSystem key returns a NSNumber");
  TEST_FOR_CLASS(@"NSString", [locale objectForKey: NSLocaleMeasurementSystem],
    "NSLocaleMeasurementSystem key returns a NSString");
  TEST_FOR_CLASS(@"NSString", [locale objectForKey: NSLocaleDecimalSeparator],
    "NSLocaleDecimalSeparator key returns a NSString");
  TEST_FOR_CLASS(@"NSString", [locale objectForKey: NSLocaleGroupingSeparator],
    "NSLocaleGroupingSeparator key returns a NSString");
  TEST_FOR_CLASS(@"NSString", [locale objectForKey: NSLocaleCurrencySymbol],
    "NSLocaleCurrencySymbol key returns a NSString");
  TEST_FOR_CLASS(@"NSString", [locale objectForKey: NSLocaleCurrencyCode],
    "NSLocaleCurrencyCode key returns a NSString");
  TEST_FOR_CLASS(@"NSString", [locale objectForKey: NSLocaleCollatorIdentifier],
    "NSLocaleCollatorIdentifier key returns a NSString");
  TEST_FOR_CLASS(@"NSString",
    [locale objectForKey: NSLocaleQuotationBeginDelimiterKey],
    "NSLocaleQuotationBeginDelimiterKey key returns a NSString");
  TEST_FOR_CLASS(@"NSString",
    [locale objectForKey: NSLocaleQuotationEndDelimiterKey],
    "NSLocaleQuotationEndDelimiterKey key returns a NSString");
  TEST_FOR_CLASS(@"NSString",
    [locale objectForKey: NSLocaleAlternateQuotationBeginDelimiterKey],
    "NSLocaleAlternateQuotationBeginDelimiterKey key returns a NSString");
  TEST_FOR_CLASS(@"NSString",
    [locale objectForKey: NSLocaleAlternateQuotationEndDelimiterKey],
    "NSLocaleAlternateQuotationEndDelimiterKey key returns a NSString");
  RELEASE(locale);
  
  locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US"];
  pass ([[locale localeIdentifier] isEqual: @"en_US"],
    "'en_US' is stored as 'en_US'.");
  pass ([locale objectForKey: NSLocaleScriptCode] == nil,
    "en_US does not have script code");
  pass ([locale objectForKey: NSLocaleVariantCode] == nil,
    "en_US does not have variant code");
  pass ([locale objectForKey: NSLocaleCollationIdentifier] == nil,
    "en_US does not have a collation identifier");
  pass ([[locale objectForKey: NSLocaleUsesMetricSystem] boolValue] == NO,
    "en_US does not use the metric system");
  RELEASE(locale);
  
  locale = [[NSLocale alloc] initWithLocaleIdentifier: @"zh-Hant_TW"];
  pass ([[locale localeIdentifier] isEqual: @"zh_Hant_TW"],
    "'zh-Hant_TW' is stored as 'zh_Hant_TW'");
  pass ([locale objectForKey: NSLocaleScriptCode] != nil,
    "zh-Hant_TW has a script code");
  RELEASE(locale);
  
  str = [NSLocale canonicalLocaleIdentifierFromString: @"AmericanEnglish"];
  pass ([str isEqual: @"en_US"],
    "Canonical identifier for 'AmericanEnglish is en_US");
  str = [NSLocale canonicalLanguageIdentifierFromString: @"AmericanEnglish"];
  pass ([str isEqual: @"en"],
    "Canonical language identifier for 'AmericanEnglish is en");
  
  RELEASE(arp);
  return 0;
}
