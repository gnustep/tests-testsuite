#include "Testing.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSCharacterSet.h>
#include <Foundation/NSString.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  pass([[@"" stringByTrimmingLeadSpaces] isEqual:@""],
       "'' stringByTrimmingLeadSpaces == ''"); 
  pass([[@"home" stringByTrimmingLeadSpaces] isEqual:@"home"],
       "'home' stringByTrimmingLeadSpaces == 'home'"); 
  pass([[@" hello" stringByTrimmingLeadSpaces] isEqual:@"hello"],
       "' hello' stringByTrimmingLeadSpaces == 'hello'"); 
  pass([[@"\thello" stringByTrimmingLeadSpaces] isEqual:@"hello"],
       "'\\thello' stringByTrimmingLeadSpaces == 'hello'"); 
  pass([[@"\nhello" stringByTrimmingLeadSpaces] isEqual:@"hello"],
       "'\\nhello' stringByTrimmingLeadSpaces == 'hello'"); 
  
  pass([[@"" stringByTrimmingTailSpaces] isEqual:@""],
       "'' stringByTrimmingTailSpaces == ''"); 
  pass([[@"home" stringByTrimmingTailSpaces] isEqual:@"home"],
       "'home' stringByTrimmingTailSpaces == 'home'"); 
  pass([[@"hello " stringByTrimmingTailSpaces] isEqual:@"hello"],
       "'hello ' stringByTrimmingTailSpaces == 'hello'"); 
  pass([[@"hello\t" stringByTrimmingTailSpaces] isEqual:@"hello"],
       "'hello\\t' stringByTrimmingTailSpaces == 'hello'"); 
  pass([[@"hello\n" stringByTrimmingTailSpaces] isEqual:@"hello"],
       "'hello\\n' stringByTrimmingTailSpaces == 'hello'"); 
  
  pass([[@"" stringByTrimmingSpaces] isEqual:@""],
       "'' stringByTrimmingSpaces == ''"); 
  pass([[@"home" stringByTrimmingSpaces] isEqual:@"home"],
       "'home' stringByTrimmingSpaces == 'home'"); 
  pass([[@" hello" stringByTrimmingSpaces] isEqual:@"hello"],
       "' hello' stringByTrimmingSpaces == 'hello'"); 
  pass([[@"\thello" stringByTrimmingSpaces] isEqual:@"hello"],
       "'\\thello' stringByTrimmingSpaces == 'hello'"); 
  pass([[@"\nhello" stringByTrimmingSpaces] isEqual:@"hello"],
       "'\\nhello' stringByTrimmingSpaces == 'hello'"); 
  
  pass([[@"home" stringByTrimmingCharactersInSet:ws] isEqual: @"home"],
       "'home' stringByTrimmingCharactersInSet == 'home'"); 
  pass([[@"hello\n" stringByTrimmingCharactersInSet:ws] isEqual: @"hello"],
       "'hello\\n' stringByTrimmingCharactersInSet == 'hello'"); 
  pass([[@"\nhello" stringByTrimmingCharactersInSet:ws] isEqual: @"hello"],
       "'\\nhello' stringByTrimmingCharactersInSet == 'hello'"); 
  pass([[@"\nhello\n" stringByTrimmingCharactersInSet:ws] isEqual: @"hello"],
       "'\nhello\n' stringByTrimmingCharactersInSet == 'hello'"); 
  pass([[@"\n  \n" stringByTrimmingCharactersInSet:ws] isEqual: @""],
       "'\\n  \\n' stringByTrimmingCharactersInSet == ''"); 
  
  pass([[@"hello" stringByPaddingToLength:3 
                               withString:@"." 
			  startingAtIndex:0] isEqual:@"hel"],
       "'hello' stringByPaddingToLength:3 withString:'.' startingAtIndex:0 == 'hel'");
  pass([[@"hello" stringByPaddingToLength:8 
                               withString:@"." 
			  startingAtIndex:0] isEqual:@"hello..."],
       "'hello' stringByPaddingToLength:8 withString:'.' startingAtIndex:0 == 'hello...'");
  pass([[@"hello" stringByPaddingToLength:8 
                               withString:@"xy" 
			  startingAtIndex:1] isEqual:@"helloyxy"],
       "'hello' stringByPaddingToLength:8 withString:'xy' startingAtIndex:0 == 'helloyxy'");
   
  DESTROY(arp);
  return 0;
}
