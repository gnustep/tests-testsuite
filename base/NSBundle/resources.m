#include "Testing.h"
#include <Foundation/NSArray.h>
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSBundle.h>
#include <Foundation/NSFileManager.h>
#include <Foundation/NSString.h>

int main()
{
 CREATE_AUTORELEASE_POOL(arp);
 NSBundle *bundle;
 NSBundle *gstepBundle;
 NSArray  *arr;
  
 bundle = [NSBundle bundleWithPath: [[NSFileManager defaultManager] 
 						currentDirectoryPath]];
 gstepBundle = [NSBundle bundleForLibrary: @"gnustep-base"];
 
 pass([bundle isKindOfClass:[NSBundle class]],"+bundleWithPath returns anNSBundle");
 arr = [bundle pathsForResourcesOfType:@"m" inDirectory:nil];
 pass([arr isKindOfClass:[NSArray class]] && [arr count],"-pathsForResourcesOfType:inDirectory: returns an array");
 pass([bundle pathForResource:@"hiwelf0-2" 
                             ofType:nil 
			inDirectory:nil] == nil,
      "-pathForResource:ofType:inDirectory: works with nil args");
 pass([bundle pathForResource:@"hiwelf0-2" ofType:nil] == nil,
      "-pathForResource:ofType: works with nil args");
 pass([[bundle resourcePath] testEquals: [[bundle bundlePath] 
                                 stringByAppendingPathComponent:@"Resources"]],
      "-resourcePath returns the correct path");
 
 pass([[NSBundle pathForResource:@"whitespaceCharSet" 
                          ofType:@"dat" 
			  inDirectory: [[gstepBundle bundlePath] 
			     stringByAppendingPathComponent:@"NSCharacterSets"]]
			      testForString],
      "+pathForResource:ofType:inDirectory: works");
 
 pass([[NSBundle pathForResource:@"whitespaceCharSet" 
                          ofType:@"dat" 
		     inDirectory:[[gstepBundle bundlePath] 
			    stringByAppendingPathComponent:@"NSCharacterSets"]
	             withVersion:0] testForString],
      "+pathForResource:ofType:inDirectory:withVersion: works");

 arr = [gstepBundle pathsForResourcesOfType:@"dat" 
                                 inDirectory:@"NSCharacterSets"];
 pass(([arr isKindOfClass:[NSArray class]] && [arr count] > 0),
      "-pathsForResourcesOfType:inDirectory: returns an array");
 pass([[gstepBundle pathForResource:@"whitespaceCharSet"
                            ofType:@"dat"
		       inDirectory:@"NSCharacterSets"] testForString],
      "-pathForResource:ofType:inDirectory: finds a file");
 pass([gstepBundle pathForResource:@"whitespaceCharSet"
                            ofType:@"8nicola8"
		       inDirectory:@"NSCharacterSets"] == nil,
      "-pathForResource:ofType:inDirectory: doesn't find a non-existing file");
 pass([gstepBundle pathForResource:@"whitespaceCharSet"
                            ofType:@"dat"
		       inDirectory:@"NSCharacterSets_dummy"] == nil,
      "-pathForResource:ofType:inDirectory: doesn't find files in a non-existing dir");
 pass([[gstepBundle pathForResource:@"whitespaceCharSet"
                             ofType:nil
		        inDirectory:@"NSCharacterSets"] testForString],
      "-pathForResource:ofType:inDirectory: with nil type finds a file");
 pass([gstepBundle pathForResource:@"whasssdlkf"
                             ofType:nil
		        inDirectory:@"NSCharacterSets"] == nil,
      "-pathForResource:ofType:inDirectory: with nil type doesn't find non-existing files");
 
 pass([[gstepBundle pathForResource:@"NSTimeZones" ofType:nil] testForString], 
      "-pathForResource:ofType: finds a file");
 DESTROY(arp);
 return 0;
}
