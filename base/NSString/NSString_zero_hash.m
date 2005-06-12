/*
copyright 2004 Alexander Malmberg <alexander@malmberg.org>
*/

#include "Testing.h"

#include <Foundation/NSString.h>

int main(int argc, char **argv)
{
	NSString *s=@"!)9\" ;";
	unsigned int h;

/*
	Generate a (hopefully ASCII printable) string with a given hash.

	h=0x50000000;
	while (h>0)
	{
		int a,b;
		a=h/33;
		b=h%33;
		if (a)
			while (b<32)
				a--,b+=33;
		printf("%10i = %10i * 33 + %3i '%c'\n",h,a,b,b);
		h=a;
	}*/

	h=[s hash];
	pass(h!=0,"[NSConstantString hash] returns 0");

	s=[[NSString alloc] initWithString: s];
	h=[s hash];
	pass(h!=0,"[NSString hash] returns 0");

	return 0;
}

