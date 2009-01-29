#import "Testing.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSCharacterSet.h>

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  NSCharacterSet *theSet = nil;
  
  theSet = [NSCharacterSet alphanumericCharacterSet];
  pass(theSet != nil, "NSCharacterSet understands [+alphanumericCharacterSet]");
  pass([NSCharacterSet alphanumericCharacterSet] == theSet, 
       "NSCharacterSet uniques alphanumericCharacterSet");
  
  theSet = [NSCharacterSet controlCharacterSet];
  pass(theSet != nil,"NSCharacterSet understands [+controlCharacterSet]");
  pass([NSCharacterSet controlCharacterSet] == theSet, 
       "NSCharacterSet uniques controlCharacterSet");
  
  theSet = [NSCharacterSet decimalDigitCharacterSet];
  pass(theSet != nil,"NSCharacterSet understands [+decimalDigitCharacterSet]");
  pass([NSCharacterSet decimalDigitCharacterSet] == theSet,
       "NSCharacterSet uniques [+decimalDigitCharacterSet]");
  
  theSet = [NSCharacterSet illegalCharacterSet];
  pass(theSet != nil,"NSCharacterSet understands [+illegalCharacterSet]");
  pass([NSCharacterSet illegalCharacterSet] == theSet,
       "NSCharacterSet uniques [+illegalCharacterSet]");
  
  theSet = [NSCharacterSet letterCharacterSet];
  pass(theSet != nil,"NSCharacterSet understands [+letterCharacterSet]");
  pass([NSCharacterSet letterCharacterSet] == theSet,
       "NSCharacterSet uniques [+letterCharacterSet]");
  
  theSet = [NSCharacterSet lowercaseLetterCharacterSet];
  pass(theSet != nil,"NSCharacterSet understands [+lowercaseLetterCharacterSet]");
  pass([NSCharacterSet lowercaseLetterCharacterSet] == theSet,
       "NSCharacterSet uniques [+lowercaseLetterCharacterSet]");
  
  theSet = [NSCharacterSet nonBaseCharacterSet];
  pass(theSet != nil,"NSCharacterSet understands [+nonBaseCharacterSet]");
  pass([NSCharacterSet nonBaseCharacterSet] == theSet,
       "NSCharacterSet uniques [+nonBaseCharacterSet]");
  
  theSet = [NSCharacterSet punctuationCharacterSet];
  pass(theSet != nil,"NSCharacterSet understands [+punctuationCharacterSet]");
  pass([NSCharacterSet punctuationCharacterSet] == theSet,
       "NSCharacterSet uniques [+punctuationCharacterSet]");
  
  theSet = [NSCharacterSet uppercaseLetterCharacterSet];
  pass(theSet != nil,"NSCharacterSet understands [+uppercaseLetterCharacterSet]");
  pass([NSCharacterSet uppercaseLetterCharacterSet] == theSet,
       "NSCharacterSet uniques [+uppercaseLetterCharacterSet]");
  
  theSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  pass(theSet != nil,"NSCharacterSet understands [+whitespaceAndNewlineCharacterSet]");
  pass([NSCharacterSet whitespaceAndNewlineCharacterSet] == theSet,
       "NSCharacterSet uniques [+whitespaceAndNewlineCharacterSet]");
  
  theSet = [NSCharacterSet whitespaceCharacterSet];
  pass(theSet != nil,"NSCharacterSet understands [+whitespaceCharacterSet]");
  pass([NSCharacterSet whitespaceCharacterSet] == theSet,
       "NSCharacterSet uniques [+whitespaceCharacterSet]");
  
  [arp release]; arp = nil;
  return 0;
}
