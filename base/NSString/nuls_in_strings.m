/*
copyright 2004 Alexander Malmberg <alexander@malmberg.org>

Tests that nul characters are handled correctly in strings and string
constants.
*/

#include "Testing.h"

#include <Foundation/NSString.h>

int main(int argc, char **argv)
{
	NSString *constantString=@"a\0b";
	NSString *normalString;
	unichar characters[3]={'a',0,'b'};

	normalString=[[NSString alloc]
		initWithCharacters: characters
		length: 3];

	pass([constantString length]==3,"nuls in constant strings");
	pass([normalString length]==3,"nuls in non-constant strings");
	pass([constantString hash]==[normalString hash],"hashes match");
	pass([normalString isEqual: constantString] &&
	     [constantString isEqual: normalString],
	     "compare as equal");

	return 0;
}

