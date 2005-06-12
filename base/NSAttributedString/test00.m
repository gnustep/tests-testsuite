#include <Foundation/NSString.h>
#include <Foundation/NSAttributedString.h>
#include <Foundation/NSAutoreleasePool.h>
#include "ObjectTesting.h"

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSString *key1, *val1, *str1;
  NSRange r = NSMakeRange(0,6);
  NSAttributedString *astr1, *astr2;
  NSDictionary *dict1;
  NSRange range = NSMakeRange(0,0);
  id obj;

  key1 = @"Helvetica 12-point";
  val1 = @"NSFontAttributeName";
  str1 = @"Attributed string test";
  dict1 = [NSDictionary dictionaryWithObject:val1 forKey:key1];

  astr1 = [[NSAttributedString alloc] initWithString:str1 attributes:dict1];
  pass(astr1 != nil && [astr1 isKindOfClass:[NSAttributedString class]] && 
       [[astr1 string] isEqual: str1],"-initWithString:attributes: works");
  
  obj = [astr1 attributesAtIndex:0 effectiveRange:&range];
  pass(obj != nil && [obj isKindOfClass:[NSDictionary class]] && 
       [obj count] == 1 && range.length != 0,
       "-attributesAtIndex:effectiveRange: works");
    
  obj = [astr1 attribute:key1 atIndex:0 effectiveRange:&range];
  pass(obj != nil && [obj isEqual:val1] && range.length != 0,
       "-attribute:atIndex:effectiveRange: works");
  obj = [astr1 attributedSubstringFromRange:r];
  pass(obj != nil && [obj isKindOfClass:[NSAttributedString class]] &&
       [obj length] == r.length,"-attributedSubstringFromRange works");

  r = NSMakeRange(0,[astr1 length]);
  astr2 = [astr1 attributedSubstringFromRange:r];
  pass(astr2 != nil && [astr1 isEqualToAttributedString:astr2],
       "extract and compare using -isEqualToAttributedString works");

  DESTROY(arp);
  return 0;
}

