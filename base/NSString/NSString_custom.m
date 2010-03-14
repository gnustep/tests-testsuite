/*
copyright 2004 Alexander Malmberg <alexander@malmberg.org>

Test that a minimal custom subclass works. This tests the generic
implementations of the NSString methods in NSString itself.
*/

#import "NSString_tests.h"

#import <Foundation/NSString.h>

@interface CustomString : NSString
{
  unichar *characters;
  NSUInteger length;
}

@end

@implementation CustomString

- initWithBytesNoCopy: (void *)c
	       length: (NSUInteger)l
	     encoding: (NSStringEncoding)encoding
         freeWhenDone: (BOOL)freeWhenDone
{
  if (l > 0)
    {
      if (encoding == NSUnicodeStringEncoding)
	{
	  characters = malloc(l);
	  memcpy(characters, c, l);
	}
      else
	{
	  NSString	*s;

	  s = [[NSString alloc] initWithBytesNoCopy: c
					     length: l
					   encoding: encoding
				       freeWhenDone: freeWhenDone];
	  if (s == nil) return nil;
	  l = [s length] * sizeof(unichar);
	  characters = malloc(l);
	  [s getCharacters: characters];
	  [s release];
	}
    }
  length = l / sizeof(unichar);
  return self;
}

- (void) dealloc
{
  if (characters)
    {
      free(characters);
      characters = NULL;
    }
  [super dealloc];
}

- (NSUInteger) length
{
  return length;
}

- (unichar) characterAtIndex: (NSUInteger)index
{
  return characters[index];
}

@end


int main(int argc,char **argv)
{
  TestNSStringClass([CustomString class]);
  return 0;
}
