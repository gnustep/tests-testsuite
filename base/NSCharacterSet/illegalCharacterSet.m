#import "Testing.h"
#import "ObjectTesting.h"
#import <Foundation/Foundation.h>

int
main (int argc, char**argv)
{
  id pool = [NSAutoreleasePool new];
  NSCharacterSet *illegal = [NSCharacterSet illegalCharacterSet];
  NSCharacterSet *legal = [illegal invertedSet];
  NSMutableData *data;
  NSString *s;
  unichar cp;

  pass([illegal characterIsMember: 0xfffe], "0xfffe is illegal");
  pass(![legal characterIsMember: 0xfffe], "0xfffe is bnot legal");
  pass([illegal characterIsMember: 0xffff], "0xffff is illegal");
  pass(![legal characterIsMember: 0xffff], "0xffff is not legal");
  pass([illegal characterIsMember: 0xfdd0], "0xfdd0 is illegal");
  pass(![legal characterIsMember: 0xfdd0], "0xfdd0 is not legal");
  pass([illegal longCharacterIsMember: 0x0010fffe], "0x0010fffe is illegal");
  pass(![legal longCharacterIsMember: 0x0010fffe], "0x0010fffe is not legal");

  // Null character
  pass(![illegal characterIsMember: 0x0000], "0x0000 is not illegal");
  pass([legal characterIsMember: 0x0000], "0x0000 is legal");
  // First half of surrogate pair
  pass(![illegal characterIsMember: 0xd800], "0xd800 is not illegal");
  pass([legal characterIsMember: 0xd800], "0xd800 is legal");
  // Second half of surrogate pair
  pass(![illegal characterIsMember: 0xdc00], "0xdc00 is not illegal");
  pass([legal characterIsMember: 0xdc00], "0xdc00 is legal");
  // Private use character in code plane 16
  pass(![illegal longCharacterIsMember: 0x0010fffd], "0x0010fffd not illegal");
  pass([legal longCharacterIsMember: 0x0010fffd], "0x0010fffd is legal");

  // Entire UCS-2 set (UTF-16 surrogates start above 0xD800)
  // (still looking for official information on the range of UCS-2 code points,
  //  i.e. whether UCS-4/UCS-2 are actually official code point sets
  //  or whether they are just commonly used terms to differentiate 
  //  the full UCS code point set from it's UTF-16 encoding.)
  data = [NSMutableData dataWithCapacity: sizeof(cp) * 0xD800];
  // Do not start with 0x0000 otherwise a leading BOM could misinterpreted.
  for (cp=0x0001;cp<0xD800;cp++)
    {
      if ([legal characterIsMember:cp])
	{
	  [data appendBytes: &cp length: sizeof(cp)];
	}
    }
  s = [[NSString alloc] initWithData: data encoding: NSUnicodeStringEncoding];
  pass([s length],"legal UCS-2 set can be represented in an NSString.");
  [s release];

  RELEASE(pool);
  return (0);
}