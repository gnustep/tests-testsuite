#include "Testing.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSCharacterSet.h>
#include <Foundation/NSData.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSCharacterSet *theSet,*iSet;
  NSData *data1 = nil;
  theSet = [NSCharacterSet alphanumericCharacterSet];
  pass([theSet characterIsMember:'A'] &&
       [theSet characterIsMember:'Z'] &&
       [theSet characterIsMember:'a'] &&
       [theSet characterIsMember:'z'] &&
       [theSet characterIsMember:'9'] &&
       [theSet characterIsMember:'0'] &&
       ![theSet characterIsMember:'#'] &&
       ![theSet characterIsMember:' '] &&
       ![theSet characterIsMember:'\n'],
       "Check some characters from alphanumericCharacterSet");
  
  theSet = [NSCharacterSet lowercaseLetterCharacterSet];
  pass(![theSet characterIsMember:'A'] &&
       ![theSet characterIsMember:'Z'] &&
       [theSet characterIsMember:'a'] &&
       [theSet characterIsMember:'z'] &&
       ![theSet characterIsMember:'9'] &&
       ![theSet characterIsMember:'0'] &&
       ![theSet characterIsMember:'#'] &&
       ![theSet characterIsMember:' '] &&
       ![theSet characterIsMember:'\n'],
       "Check some characters from lowercaseLetterCharacterSet");
  
  theSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  pass(![theSet characterIsMember:'A'] &&
       ![theSet characterIsMember:'Z'] &&
       ![theSet characterIsMember:'a'] &&
       ![theSet characterIsMember:'z'] &&
       ![theSet characterIsMember:'9'] &&
       ![theSet characterIsMember:'0'] &&
       ![theSet characterIsMember:'#'] &&
       [theSet characterIsMember:' '] &&
       [theSet characterIsMember:'\n'] &&
       [theSet characterIsMember:'\t'],
       "Check some characters from whitespaceAndNewlineCharacterSet");
  
  data1 = [theSet bitmapRepresentation];
  pass(data1 != nil && [data1 isKindOfClass:[NSData class]],
       "-bitmapRepresentation works");
  
  iSet = [theSet invertedSet]; 
  pass([iSet characterIsMember:'A'] &&
       [iSet characterIsMember:'Z'] &&
       [iSet characterIsMember:'a'] &&
       [iSet characterIsMember:'z'] &&
       [iSet characterIsMember:'9'] &&
       [iSet characterIsMember:'0'] &&
       [iSet characterIsMember:'#'] &&
       ![iSet characterIsMember:' '] &&
       ![iSet characterIsMember:'\n'] &&
       ![iSet characterIsMember:'\t'],
       "-invertedSet works");
  {
    NSCharacterSet *firstSet,*secondSet,*thirdSet,*fourthSet;
    firstSet = [NSCharacterSet decimalDigitCharacterSet];
    secondSet = [NSCharacterSet decimalDigitCharacterSet];
    thirdSet = nil;
    fourthSet = [NSMutableCharacterSet decimalDigitCharacterSet];
    thirdSet = [[firstSet class] decimalDigitCharacterSet];
    pass (firstSet == secondSet && 
          firstSet == thirdSet && 
	  firstSet != fourthSet,
	  "Caching of standard sets");
  }

  theSet = [NSCharacterSet characterSetWithCharactersInString:@"Not a set"];
  pass(theSet != nil && [theSet isKindOfClass:[NSCharacterSet class]],
       "Create custom set with characterSetWithCharactersInString:");
  
  pass([theSet characterIsMember:' '] &&
       [theSet characterIsMember:'N'] &&
       [theSet characterIsMember:'o'] &&
       ![theSet characterIsMember:'A'] &&
       ![theSet characterIsMember:'#'],
       "Check custom set");


  
  DESTROY(arp);
  return 0;
}

