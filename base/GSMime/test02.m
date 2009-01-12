#if     defined(GNUSTEP_BASE_LIBRARY)
#import <Foundation/Foundation.h>
#import <GNUstepBase/GSMime.h>
#import "Testing.h"

int main()
{
  CREATE_AUTORELEASE_POOL(arp);

  // Test charset conversions.
  pass([GSMimeDocument encodingFromCharset: @"ansi_x3.4-1968"]
    == NSASCIIStringEncoding,
    "charset 'ansi_x3.4-1968' is NSASCIIStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"ansi_x3.4-1986"]
    == NSASCIIStringEncoding,
    "charset 'ansi_x3.4-1986' is NSASCIIStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"apple-roman"]
    == NSMacOSRomanStringEncoding,
    "charset 'apple-roman' is NSMacOSRomanStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"ascii"]
    == NSASCIIStringEncoding,
    "charset 'ascii' is NSASCIIStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"big5"]
    == NSBIG5StringEncoding,
    "charset 'big5' is NSBIG5StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"cp367"]
    == NSASCIIStringEncoding,
    "charset 'cp367' is NSASCIIStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"cp819"]
    == NSISOLatin1StringEncoding,
    "charset 'cp819' is NSISOLatin1StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"csascii"]
    == NSASCIIStringEncoding,
    "charset 'csascii' is NSASCIIStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"csisolatin1"]
    == NSISOLatin1StringEncoding,
    "charset 'csisolatin1' is NSISOLatin1StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"gb2312.1980"]
    == NSGB2312StringEncoding,
    "charset 'gb2312.1980' is NSGB2312StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"gsm0338"]
    == NSGSM0338StringEncoding,
    "charset 'gsm0338' is NSGSM0338StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"ia5"]
    == NSASCIIStringEncoding,
    "charset 'ia5' is NSASCIIStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"ibm367"]
    == NSASCIIStringEncoding,
    "charset 'ibm367' is NSASCIIStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"ibm819"]
    == NSISOLatin1StringEncoding,
    "charset 'ibm819' is NSISOLatin1StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso-10646-ucs-2"]
    == NSUnicodeStringEncoding,
    "charset 'iso-10646-ucs-2' is NSUnicodeStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso10646-ucs-2"]
    == NSUnicodeStringEncoding,
    "charset 'iso10646-ucs-2' is NSUnicodeStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso-8859-1"]
    == NSISOLatin1StringEncoding,
    "charset 'iso-8859-1' is NSISOLatin1StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso8859-1"]
    == NSISOLatin1StringEncoding,
    "charset 'iso8859-1' is NSISOLatin1StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso-8859-10"]
    == NSISOLatin6StringEncoding,
    "charset 'iso-8859-10' is NSISOLatin6StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso8859-10"]
    == NSISOLatin6StringEncoding,
    "charset 'iso8859-10' is NSISOLatin6StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso-8859-11"]
    == NSISOThaiStringEncoding,
    "charset 'iso-8859-11' is NSISOThaiStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso8859-11"]
    == NSISOThaiStringEncoding,
    "charset 'iso8859-11' is NSISOThaiStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso-8859-13"]
    == NSISOLatin7StringEncoding,
    "charset 'iso-8859-13' is NSISOLatin7StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso8859-13"]
    == NSISOLatin7StringEncoding,
    "charset 'iso8859-13' is NSISOLatin7StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso-8859-14"]
    == NSISOLatin8StringEncoding,
    "charset 'iso-8859-14' is NSISOLatin8StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso8859-14"]
    == NSISOLatin8StringEncoding,
    "charset 'iso8859-14' is NSISOLatin8StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso-8859-15"]
    == NSISOLatin9StringEncoding,
    "charset 'iso-8859-15' is NSISOLatin9StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso8859-15"]
    == NSISOLatin9StringEncoding,
    "charset 'iso8859-15' is NSISOLatin9StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso-8859-1:1987"]
    == NSISOLatin1StringEncoding,
    "charset 'iso-8859-1:1987' is NSISOLatin1StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso8859-1:1987"]
    == NSISOLatin1StringEncoding,
    "charset 'iso8859-1:1987' is NSISOLatin1StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso-8859-2"]
    == NSISOLatin2StringEncoding,
    "charset 'iso-8859-2' is NSISOLatin2StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso8859-2"]
    == NSISOLatin2StringEncoding,
    "charset 'iso8859-2' is NSISOLatin2StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso-8859-3"]
    == NSISOLatin3StringEncoding,
    "charset 'iso-8859-3' is NSISOLatin3StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso8859-3"]
    == NSISOLatin3StringEncoding,
    "charset 'iso8859-3' is NSISOLatin3StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso-8859-4"]
    == NSISOLatin4StringEncoding,
    "charset 'iso-8859-4' is NSISOLatin4StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso8859-4"]
    == NSISOLatin4StringEncoding,
    "charset 'iso8859-4' is NSISOLatin4StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso-8859-5"]
    == NSISOCyrillicStringEncoding,
    "charset 'iso-8859-5' is NSISOCyrillicStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso8859-5"]
    == NSISOCyrillicStringEncoding,
    "charset 'iso8859-5' is NSISOCyrillicStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso-8859-6"]
    == NSISOArabicStringEncoding,
    "charset 'iso-8859-6' is NSISOArabicStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso8859-6"]
    == NSISOArabicStringEncoding,
    "charset 'iso8859-6' is NSISOArabicStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso-8859-7"]
    == NSISOGreekStringEncoding,
    "charset 'iso-8859-7' is NSISOGreekStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso8859-7"]
    == NSISOGreekStringEncoding,
    "charset 'iso8859-7' is NSISOGreekStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso-8859-8"]
    == NSISOHebrewStringEncoding,
    "charset 'iso-8859-8' is NSISOHebrewStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso8859-8"]
    == NSISOHebrewStringEncoding,
    "charset 'iso8859-8' is NSISOHebrewStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso-8859-9"]
    == NSISOLatin5StringEncoding,
    "charset 'iso-8859-9' is NSISOLatin5StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso8859-9"]
    == NSISOLatin5StringEncoding,
    "charset 'iso8859-9' is NSISOLatin5StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso-ir-100"]
    == NSISOLatin1StringEncoding,
    "charset 'iso-ir-100' is NSISOLatin1StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso-ir-6"]
    == NSASCIIStringEncoding,
    "charset 'iso-ir-6' is NSASCIIStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso-10646-1"]
    == NSUnicodeStringEncoding,
    "charset 'iso-10646-1' is NSUnicodeStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso10646-1"]
    == NSUnicodeStringEncoding,
    "charset 'iso10646-1' is NSUnicodeStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso646-us"]
    == NSASCIIStringEncoding,
    "charset 'iso646-us' is NSASCIIStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso_646.991-irv"]
    == NSASCIIStringEncoding,
    "charset 'iso_646.991-irv' is NSASCIIStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso_646.irv:1991"]
    == NSASCIIStringEncoding,
    "charset 'iso_646.irv:1991' is NSASCIIStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"iso_8859-1"]
    == NSISOLatin1StringEncoding,
    "charset 'iso_8859-1' is NSISOLatin1StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"jisx0201.1976"]
    == NSShiftJISStringEncoding,
    "charset 'jisx0201.1976' is NSShiftJISStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"koi8-r"]
    == NSKOI8RStringEncoding,
    "charset 'koi8-r' is NSKOI8RStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"ksc5601.1987"]
    == NSKoreanEUCStringEncoding,
    "charset 'ksc5601.1987' is NSKoreanEUCStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"ksc5601.1997"]
    == NSKoreanEUCStringEncoding,
    "charset 'ksc5601.1997' is NSKoreanEUCStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"l1"]
    == NSISOLatin1StringEncoding,
    "charset 'l1' is NSISOLatin1StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"latin1"]
    == NSISOLatin1StringEncoding,
    "charset 'latin1' is NSISOLatin1StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"microsoft-cp1250"]
    == NSWindowsCP1250StringEncoding,
    "charset 'microsoft-cp1250' is NSWindowsCP1250StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"microsoft-cp1251"]
    == NSWindowsCP1251StringEncoding,
    "charset 'microsoft-cp1251' is NSWindowsCP1251StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"microsoft-cp1252"]
    == NSWindowsCP1252StringEncoding,
    "charset 'microsoft-cp1252' is NSWindowsCP1252StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"microsoft-cp1253"]
    == NSWindowsCP1253StringEncoding,
    "charset 'microsoft-cp1253' is NSWindowsCP1253StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"microsoft-cp1254"]
    == NSWindowsCP1254StringEncoding,
    "charset 'microsoft-cp1254' is NSWindowsCP1254StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"microsoft-symbol"]
    == NSSymbolStringEncoding,
    "charset 'microsoft-symbol' is NSSymbolStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"shift_JIS"]
    == NSShiftJISStringEncoding,
    "charset 'shift_JIS' is NSShiftJISStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"us"]
    == NSASCIIStringEncoding,
    "charset 'us' is NSASCIIStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"us-ascii"]
    == NSASCIIStringEncoding,
    "charset 'us-ascii' is NSASCIIStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"utf-16"]
    == NSUnicodeStringEncoding,
    "charset 'utf-16' is NSUnicodeStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"utf16"]
    == NSUnicodeStringEncoding,
    "charset 'utf16' is NSUnicodeStringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"utf-7"]
    == NSUTF7StringEncoding,
    "charset 'utf-7' is NSUTF7StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"utf7"]
    == NSUTF7StringEncoding,
    "charset 'utf7' is NSUTF7StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"utf-8"]
    == NSUTF8StringEncoding,
    "charset 'utf-8' is NSUTF8StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"utf8"]
    == NSUTF8StringEncoding,
    "charset 'utf8' is NSUTF8StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"windows-1250"]
    == NSWindowsCP1250StringEncoding,
    "charset 'windows-1250' is NSWindowsCP1250StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"windows-1251"]
    == NSWindowsCP1251StringEncoding,
    "charset 'windows-1251' is NSWindowsCP1251StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"windows-1252"]
    == NSWindowsCP1252StringEncoding,
    "charset 'windows-1252' is NSWindowsCP1252StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"windows-1253"]
    == NSWindowsCP1253StringEncoding,
    "charset 'windows-1253' is NSWindowsCP1253StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"windows-1254"]
    == NSWindowsCP1254StringEncoding,
    "charset 'windows-1254' is NSWindowsCP1254StringEncoding");
  pass([GSMimeDocument encodingFromCharset: @"windows-symbol"]
    == NSSymbolStringEncoding,
    "charset 'windows-symbol' is NSSymbolStringEncoding");

  // Test canonical charset names.

  pass([[GSMimeDocument charsetFromEncoding: NSASCIIStringEncoding]
    isEqualToString: @"us-ascii"],
    "NSASCIIStringEncoding canonical charset is us-ascii");
  pass([[GSMimeDocument charsetFromEncoding: NSBIG5StringEncoding]
    isEqualToString: @"big5"],
    "NSBIG5StringEncoding canonical charset is big5");
  pass([[GSMimeDocument charsetFromEncoding: NSGB2312StringEncoding]
    isEqualToString: @"gb2312.1980"],
    "NSGB2312StringEncoding canonical charset is gb2312.1980");
  pass([[GSMimeDocument charsetFromEncoding: NSGSM0338StringEncoding]
    isEqualToString: @"gsm0338"],
    "NSGSM0338StringEncoding canonical charset is gsm0338");
  pass([[GSMimeDocument charsetFromEncoding: NSISOArabicStringEncoding]
    isEqualToString: @"iso-8859-6"],
    "NSISOArabicStringEncoding canonical charset is iso-8859-6");
  pass([[GSMimeDocument charsetFromEncoding: NSISOCyrillicStringEncoding]
    isEqualToString: @"iso-8859-5"],
    "NSISOCyrillicStringEncoding canonical charset is iso-8859-5");
  pass([[GSMimeDocument charsetFromEncoding: NSISOGreekStringEncoding]
    isEqualToString: @"iso-8859-7"],
    "NSISOGreekStringEncoding canonical charset is iso-8859-7");
  pass([[GSMimeDocument charsetFromEncoding: NSISOHebrewStringEncoding]
    isEqualToString: @"iso-8859-8"],
    "NSISOHebrewStringEncoding canonical charset is iso-8859-8");
  pass([[GSMimeDocument charsetFromEncoding: NSISOLatin1StringEncoding]
    isEqualToString: @"iso-8859-1"],
    "NSISOLatin1StringEncoding canonical charset is iso-8859-1");
  pass([[GSMimeDocument charsetFromEncoding: NSISOLatin2StringEncoding]
    isEqualToString: @"iso-8859-2"],
    "NSISOLatin2StringEncoding canonical charset is iso-8859-2");
  pass([[GSMimeDocument charsetFromEncoding: NSISOLatin3StringEncoding]
    isEqualToString: @"iso-8859-3"],
    "NSISOLatin3StringEncoding canonical charset is iso-8859-3");
  pass([[GSMimeDocument charsetFromEncoding: NSISOLatin4StringEncoding]
    isEqualToString: @"iso-8859-4"],
    "NSISOLatin4StringEncoding canonical charset is iso-8859-4");
  pass([[GSMimeDocument charsetFromEncoding: NSISOLatin5StringEncoding]
    isEqualToString: @"iso-8859-9"],
    "NSISOLatin5StringEncoding canonical charset is iso-8859-9");
  pass([[GSMimeDocument charsetFromEncoding: NSISOLatin6StringEncoding]
    isEqualToString: @"iso-8859-10"],
    "NSISOLatin6StringEncoding canonical charset is iso-8859-10");
  pass([[GSMimeDocument charsetFromEncoding: NSISOLatin7StringEncoding]
    isEqualToString: @"iso-8859-13"],
    "NSISOLatin7StringEncoding canonical charset is iso-8859-13");
  pass([[GSMimeDocument charsetFromEncoding: NSISOLatin8StringEncoding]
    isEqualToString: @"iso-8859-14"],
    "NSISOLatin8StringEncoding canonical charset is iso-8859-14");
  pass([[GSMimeDocument charsetFromEncoding: NSISOLatin9StringEncoding]
    isEqualToString: @"iso-8859-15"],
    "NSISOLatin9StringEncoding canonical charset is iso-8859-15");
  pass([[GSMimeDocument charsetFromEncoding: NSISOThaiStringEncoding]
    isEqualToString: @"iso-8859-11"],
    "NSISOThaiStringEncoding canonical charset is iso-8859-11");
  pass([[GSMimeDocument charsetFromEncoding: NSKOI8RStringEncoding]
    isEqualToString: @"koi8-r"],
    "NSKOI8RStringEncoding canonical charset is koi8-r");
  pass([[GSMimeDocument charsetFromEncoding: NSKoreanEUCStringEncoding]
    isEqualToString: @"ksc5601.1987"],
    "NSKoreanEUCStringEncoding canonical charset is ksc5601.1987");
  pass([[GSMimeDocument charsetFromEncoding: NSMacOSRomanStringEncoding]
    isEqualToString: @"apple-roman"],
    "NSMacOSRomanStringEncoding canonical charset is apple-roman");
  pass([[GSMimeDocument charsetFromEncoding: NSShiftJISStringEncoding]
    isEqualToString: @"shift_JIS"],
    "NSShiftJISStringEncoding canonical charset is shift_JIS");
  pass([[GSMimeDocument charsetFromEncoding: NSUTF7StringEncoding]
    isEqualToString: @"utf-7"],
    "NSUTF7StringEncoding canonical charset is utf-7");
  pass([[GSMimeDocument charsetFromEncoding: NSUTF8StringEncoding]
    isEqualToString: @"utf-8"],
    "NSUTF8StringEncoding canonical charset is utf-8");
  pass([[GSMimeDocument charsetFromEncoding: NSUnicodeStringEncoding]
    isEqualToString: @"utf-16"],
    "NSUnicodeStringEncoding canonical charset is utf-16");
  pass([[GSMimeDocument charsetFromEncoding: NSWindowsCP1250StringEncoding]
    isEqualToString: @"windows-1250"],
    "NSWindowsCP1250StringEncoding canonical charset is windows-1250");
  pass([[GSMimeDocument charsetFromEncoding: NSWindowsCP1251StringEncoding]
    isEqualToString: @"windows-1251"],
    "NSWindowsCP1251StringEncoding canonical charset is windows-1251");
  pass([[GSMimeDocument charsetFromEncoding: NSWindowsCP1252StringEncoding]
    isEqualToString: @"windows-1252"],
    "NSWindowsCP1252StringEncoding canonical charset is windows-1252");
  pass([[GSMimeDocument charsetFromEncoding: NSWindowsCP1253StringEncoding]
    isEqualToString: @"windows-1253"],
    "NSWindowsCP1253StringEncoding canonical charset is windows-1253");
  pass([[GSMimeDocument charsetFromEncoding: NSWindowsCP1254StringEncoding]
    isEqualToString: @"windows-1254"],
    "NSWindowsCP1254StringEncoding canonical charset is windows-1254");
  IF_NO_GC(DESTROY(arp));
  return 0;
}
#else
int main(int argc,char **argv)
{
  return 0;
}
#endif
