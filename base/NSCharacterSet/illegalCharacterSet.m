#include "Testing.h"
#include "ObjectTesting.h"
#include <Foundation/Foundation.h>

int
main (int argc, char**argv)
{
  id pool = [NSAutoreleasePool new];
  NSCharacterSet *illegal = [NSCharacterSet illegalCharacterSet];
  NSCharacterSet *legal = [illegal invertedSet];

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

  RELEASE(pool);
  return (0);
}


