#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSValue.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSNumber *val1, *val2, *val3;

  val1 = [NSNumber numberWithBool:YES];
  pass(val1 != nil, "We can create a boolean (YES)");
  
  val2 = [NSNumber numberWithBool:NO];
  pass(val2 != nil, "We can create a boolean (NO)");
  
  pass(![val1 isEqual:val2], "A boolean YES is not a NO");
  pass(![val2 isEqual:val1], "A boolean NO is not a YES");
  pass([val1 isEqual:[NSNumber numberWithBool:YES]], "A boolean YES is a YES");
  pass([val2 isEqual:[NSNumber numberWithBool:NO]], "A boolean NO is a NO");
  
  val1 = [NSNumber numberWithChar:99];
  pass(val1 != nil, "We can create a char number");
  val1 = [NSNumber numberWithChar:-1];
  pass(val1 != nil, "We can create a signed char number");
  val2 = [NSNumber numberWithUnsignedChar:255];
  pass(val2 != nil, "We can create an unsigned char number");
  pass(![val1 isEqual:val2], "A -1 signed char is not a 255 unsigned char");
  pass([val1 isEqual:[NSNumber numberWithChar:255]], 
       "A -1 signed char is a 255 signed char");
  
  val1 = [NSNumber numberWithChar:-100];
  pass([val1 isEqual:[NSNumber numberWithShort:-100]],
       "A -100 signed char is a -100 signed short");
  pass([val1 isEqual:[NSNumber numberWithInt:-100]],
       "A -100 signed char is a -100 signed int");
  pass([val1 isEqual:[NSNumber numberWithLong:-100]],
       "A -100 signed char is a -100 signed long");
  pass([val1 isEqual:[NSNumber numberWithLongLong:-100]],
       "A -100 signed char is a -100 signed long long");
  pass([val1 isEqual:[NSNumber numberWithFloat:-100.0]],
       "A -100 signed char is a -100 signed float");
  pass([val1 isEqual:[NSNumber numberWithDouble:-100.0]],
       "A -100 signed char is a -100 signed double");

  val1 = [NSNumber numberWithInt:127];
  val2 = [NSNumber numberWithInt:128];
  pass([val2 compare:val1] == NSOrderedDescending, 
       "integer numbers - 127 < 128"); 
  pass([val1 compare:val2] == NSOrderedAscending, 
       "integer numbers - 128 > 127"); 
  val1 = [NSNumber numberWithChar:100];
  val2 = [NSNumber numberWithChar:200];
  val3 = [NSNumber numberWithInt:200];
  pass(![val2 isEqual:val3], "A 200 signed char is not a 200 int");
  pass([val2 compare:val1] == NSOrderedAscending, 
       "signed char numbers - 200 < 100");
  pass([val1 compare:val2] == NSOrderedDescending,
       "signed char numbers - 100 > 200");

  DESTROY(arp);
  return 0;
}
