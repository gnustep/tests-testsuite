#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSLocale.h>
#import <Foundation/NSValue.h>
#import "ObjectTesting.h"

int main(void)
{
  NSAutoreleasePool *arp = [NSAutoreleasePool new];
  NSLocale *locale;
  NSString *str;
  NSDictionary *dict;
  id            o;
  unichar       u;
  
  // These tests don't really work all that well.  I need to come up with
  // something better.  Most of the ones that fail are because nil is returned.
  locale = [[NSLocale alloc] initWithLocaleIdentifier: @"es_ES_PREEURO"];
  passeq ([locale objectForKey: NSLocaleIdentifier],
    @"es_ES@currency=ESP",
    "NSLocaleIdentifier key returns 'es_ES@currency=ESP'");
  passeq ([locale objectForKey: NSLocaleLanguageCode],
    @"es",
    "NSLocaleLanguageCode key returns 'es'");
  passeq ([locale objectForKey: NSLocaleCountryCode],
    @"ES",
    "NSLocaleCountryCode key returns 'ES'");

  passeq ([locale objectForKey: NSLocaleScriptCode], nil,
    "NSLocaleScriptCode key returns nil");
  passeq ([locale objectForKey: NSLocaleVariantCode], nil,
    "NSLocaleVariantCode key returns nil");
  passeq ([locale objectForKey: NSLocaleCollationIdentifier], nil,
    "NSLocaleCollationIdentifier key returns nil");
  TEST_FOR_CLASS(@"NSCharacterSet",
    [locale objectForKey: NSLocaleExemplarCharacterSet],
    "NSLocaleExemplarCharacterSet key returns a NSCharacterSet");
  TEST_FOR_CLASS(@"NSCalendar", [locale objectForKey: NSLocaleCalendar],
    "NSLocaleCalendar key returns a NSCalendar");
  o = [locale objectForKey: NSLocaleUsesMetricSystem];
  TEST_FOR_CLASS(@"NSNumber", o,
    "NSLocaleUsesMetricSystem key returns a NSNumber");
  passeq (o, [NSNumber numberWithBool: YES],
    "NSLocaleUsesMetricSystem key returns YES");
  passeq ([locale objectForKey: NSLocaleMeasurementSystem],
    @"Metric",
    "NSLocaleMeasurementSystem key returns 'Metric'");
  passeq ([locale objectForKey: NSLocaleDecimalSeparator],
    @",",
    "NSLocaleDecimalSeparator key returns ','");
  passeq ([locale objectForKey: NSLocaleGroupingSeparator],
    @".",
    "NSLocaleGroupingSeparator key returns '.'");
  u = 8359;
  passeq ([locale objectForKey: NSLocaleCurrencySymbol],
    [NSString stringWithCharacters: &u length: 1],
    "NSLocaleCurrencySymbol key returns 'xx3'");
  passeq ([locale objectForKey: NSLocaleCurrencyCode],
    @"ESP",
    "NSLocaleCurrencyCode key returns 'ESP'");
  passeq([locale objectForKey: NSLocaleCollatorIdentifier],
    @"es_ES@currency=ESP", "NSLocaleCollatorIdentifier for Spain");
  u = 8216;
  passeq ([locale objectForKey: NSLocaleQuotationBeginDelimiterKey],
    [NSString stringWithCharacters: &u length: 1],
    "NSLocaleQuotationBeginDelimiterKey key works");
  u = 8217;
  passeq ([locale objectForKey: NSLocaleQuotationEndDelimiterKey],
    [NSString stringWithCharacters: &u length: 1],
    "NSLocaleQuotationEndDelimiterKey key returns 'xx6'");
  u = 8220;
  passeq ([locale objectForKey: NSLocaleAlternateQuotationBeginDelimiterKey],
    [NSString stringWithCharacters: &u length: 1],
    "NSLocaleAlternateQuotationBeginDelimiterKey key returns 'xx7'");
  u = 8221;
  passeq ([locale objectForKey: NSLocaleAlternateQuotationEndDelimiterKey],
    [NSString stringWithCharacters: &u length: 1],
    "NSLocaleAlternateQuotationEndDelimiterKey key returns 'xx8'");
  RELEASE(locale);
  
  locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US"];
  passeq ([locale localeIdentifier], @"en_US",
    "'en_US' is stored as 'en_US'.");
  passeq ([locale objectForKey: NSLocaleScriptCode], nil,
    "en_US does not have script code");
  passeq ([locale objectForKey: NSLocaleVariantCode], nil,
    "en_US does not have variant code");
  passeq ([locale objectForKey: NSLocaleCollationIdentifier], nil,
    "en_US does not have a collation identifier");
  pass ([[locale objectForKey: NSLocaleUsesMetricSystem] boolValue] == NO,
    "en_US does not use the metric system");
  RELEASE(locale);
  
  locale = [[NSLocale alloc] initWithLocaleIdentifier: @"zh-Hant_TW"];
  passeq ([locale objectForKey: NSLocaleCountryCode], @"TW",
    "zh-Hant_TW country code is zh");
  passeq ([locale objectForKey: NSLocaleLanguageCode], @"zh",
    "zh-Hant_TW language code is zh");
  passeq ([locale localeIdentifier], @"zh_TW",
    "'zh-Hant_TW' is stored as 'zh_TW'");
  passeq ([locale objectForKey: NSLocaleScriptCode], nil,
    "zh-Hant_TW has no script code");
  RELEASE(locale);
  
  passeq ([NSLocale canonicalLocaleIdentifierFromString: @"AmericanEnglish"],
    @"americanenglish",
    "Canonical identifier for 'AmericanEnglish is americanenglish");
  passeq ([NSLocale canonicalLanguageIdentifierFromString: @"AmericanEnglish"],
    @"americanenglish",
    "Canonical language identifier for 'AmericanEnglish is americanenglish");
  
  RELEASE(arp);
  return 0;
}
