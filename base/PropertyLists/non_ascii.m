/*
copyright 2004 Alexander Malmberg <alexander@malmberg.org>
*/

#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSString.h>

#include "Testing.h"

int main(int argc, char **argv)
{
	id plist;
	CREATE_AUTORELEASE_POOL(arp);

	plist=[[NSString stringWithContentsOfFile: @"non_ascii_utf8.plist"] propertyList];
	pass(plist!=nil, "utf8 plist works");

	plist=[[NSString stringWithContentsOfFile: @"non_ascii_utf16.plist"] propertyList];
	pass(plist!=nil, "utf16 plist works");

	plist=[[NSString stringWithContentsOfFile: @"non_ascii_utf8.strings"] propertyListFromStringsFileFormat];
	pass(plist!=nil, "utf8 strings file works");

	plist=[[NSString stringWithContentsOfFile: @"non_ascii_utf16.strings"] propertyListFromStringsFileFormat];
	pass(plist!=nil, "utf16 strings file works");

	DESTROY(arp);

	return 0;
}

