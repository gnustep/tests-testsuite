/*
   Copyright (C) 2008 Free SoftwareFoundation, Inc.

*/

/*
Testing of Various Byte Order conversion.
*/

#import "Testing.h"
#import <Foundation/Foundation.h>

int main(int argc, char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  NSString *s = @"A";
  NSData *d;
  const uint8_t *b;

  d = [s dataUsingEncoding: NSUTF16BigEndianStringEncoding];
  b = [d bytes];
  pass(b[0] == 0 && b[1] == 65, "UTF-16 BE OK");

  d = [s dataUsingEncoding: NSUTF16LittleEndianStringEncoding];
  b = [d bytes];
  pass(b[0] == 65 && b[1] == 0, "UTF-16 LE OK");

  d = [s dataUsingEncoding: NSUTF32BigEndianStringEncoding];
  b = [d bytes];
  pass(b[0] == 0 && b[1] == 0 && b[2] == 0 && b[3] == 65, "UTF-32 BE OK");

  d = [s dataUsingEncoding: NSUTF32LittleEndianStringEncoding];
  b = [d bytes];
  pass(b[0] == 65 && b[1] == 0 && b[2] == 0 && b[3] == 0, "UTF-32 LE OK");

  [pool release];
  return 0;
}

