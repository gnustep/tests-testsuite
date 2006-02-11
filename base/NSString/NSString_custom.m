/*
copyright 2004 Alexander Malmberg <alexander@malmberg.org>

Test that a minimal custom subclass works. This tests the generic
implementations of the NSString methods in NSString itself.
*/

#include "NSString_tests.h"

#include <Foundation/NSString.h>

@interface CustomString : NSString
{
  unichar *characters;
  unsigned int length;
}

@end

@implementation CustomString

- initWithCharactersNoCopy: (unichar *)c
		    length: (unsigned int)l
	      freeWhenDone: (BOOL)freeWhenDone
{
  if (l)
    {
      characters = malloc(l * sizeof(unichar));
      memcpy(characters, c, l * sizeof(unichar));
    }
  length = l;
  return self;
}

-(void) dealloc
{
  if (characters)
    {
      free(characters);
      characters = NULL;
    }
  [super dealloc];
}

-(unsigned int) length
{
  return length;
}

-(unichar) characterAtIndex: (unsigned int)index
{
  return characters[index];
}

@end


int main(int argc,char **argv)
{
  TestNSStringClass([CustomString class]);
  return 0;
}
