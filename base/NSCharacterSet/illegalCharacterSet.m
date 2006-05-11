#include "Testing.h"
#include "ObjectTesting.h"
#include <Foundation/Foundation.h>

int
main (int argc, char**argv)
{
  id pool = [NSAutoreleasePool new];
  NSCharacterSet *cs0,*cs1=[[NSCharacterSet illegalCharacterSet] invertedSet];
  NSMutableData  *md =[NSMutableData dataWithCapacity:sizeof(unichar)*USHRT_MAX];
  NSString *s;
  unichar u;
  const void *b;
  unsigned len;

  for (u=0;u<USHRT_MAX;u++)
    {
      if ([cs1 characterIsMember: u])
	[md appendBytes: &u length: sizeof(u)];
    }
  b = [md bytes];
  len = [md length];
  len = len / sizeof(u);
  s = [NSString alloc];
  s = [s initWithCharacters:b length: len];
  cs0 = [NSCharacterSet characterSetWithCharactersInString:s];
  pass([cs0 isEqual: cs1], "illegal set");

  RELEASE(pool);
  return (0);
}


