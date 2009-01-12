/*
copyright 2004 Alexander Malmberg <alexander@malmberg.org>
*/

#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSString.h>

#import "Testing.h"

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

	IF_NO_GC(DESTROY(arp));

	return 0;
}

