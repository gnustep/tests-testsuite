#import "Testing.h"
#import <Foundation/NSArray.h>
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSBundle.h>
#import <Foundation/NSFileManager.h>
#import <Foundation/NSString.h>

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  NSBundle *bundle;
  NSBundle *gstepBundle;
  NSArray  *arr;
  
  bundle = [NSBundle bundleWithPath: [[NSFileManager defaultManager] 
    currentDirectoryPath]];
  gstepBundle = [NSBundle bundleForLibrary: @"gnustep-base"];
 
  pass([bundle isKindOfClass: [NSBundle class]],
    "+bundleWithPath returns anNSBundle");
  arr = [bundle pathsForResourcesOfType: @"m" inDirectory: nil];
  pass([arr isKindOfClass: [NSArray class]] && [arr count],
    "-pathsForResourcesOfType: inDirectory: returns an array");
  pass([bundle pathForResource: @"hiwelf0-2" 
		        ofType: nil 
		   inDirectory: nil] == nil,
    "-pathForResource:ofType:inDirectory: works with nil args");
  pass([bundle pathForResource: @"hiwelf0-2" ofType: nil] == nil,
    "-pathForResource:ofType: works with nil type");
  pass([bundle pathForResource: nil ofType: @"tiff"] == nil,
    "-pathForResource:ofType: works with nil name");
  pass([bundle pathForResource: @"hiwelf0-2" ofType: @""] == nil,
    "-pathForResource:ofType: works with empty type");
  pass([bundle pathForResource: @"" ofType: @"tiff"] == nil,
    "-pathForResource:ofType: works with empty name");
  pass([[bundle resourcePath] testEquals: [[bundle bundlePath] 
    stringByAppendingPathComponent: @"Resources"]],
    "-resourcePath returns the correct path");
 
  pass([[NSBundle pathForResource: @"abbreviations" 
                           ofType: @"plist" 
		      inDirectory: [[gstepBundle bundlePath] 
    stringByAppendingPathComponent: @"NSTimeZones"]] testForString],
    "+pathForResource:ofType:inDirectory: works");
 
  pass([[NSBundle pathForResource: @"abbreviations" 
                           ofType: @"plist" 
		      inDirectory: [[gstepBundle bundlePath] 
    stringByAppendingPathComponent: @"NSTimeZones"] withVersion: 0]
    testForString],
    "+pathForResource:ofType:inDirectory:withVersion: works");

  arr = [gstepBundle pathsForResourcesOfType: @"m" 
                                 inDirectory: @"NSTimeZones"];
  pass(([arr isKindOfClass: [NSArray class]] && [arr count] > 0),
    "-pathsForResourcesOfType:inDirectory: returns an array");
  pass([[gstepBundle pathForResource: @"abbreviations"
			      ofType: @"plist"
			 inDirectory: @"NSTimeZones"] testForString],
    "-pathForResource:ofType:inDirectory: finds a file");
  pass([gstepBundle pathForResource: @"abbreviations"
                             ofType: @"8nicola8"
		        inDirectory: @"NSTimeZones"] == nil,
    "-pathForResource:ofType:inDirectory: doesn't find a non-existing file");
  pass([gstepBundle pathForResource: @"abbreviations"
                             ofType: @"plist"
		        inDirectory: @"NSTimeZones_dummy"] == nil,
    "-pathForResource:ofType:inDirectory: doesn't find files in"
    "a non-existing dir");
  pass([[gstepBundle pathForResource: @"abbreviations"
                              ofType: nil
		         inDirectory: @"NSTimeZones"] testForString],
    "-pathForResource:ofType:inDirectory: with nil type finds a file");
  pass([gstepBundle pathForResource: @"whasssdlkf"
                             ofType: nil
		        inDirectory: @"NSTimeZones"] == nil,
    "-pathForResource:ofType:inDirectory: with nil type doesn't find"
    "non-existing files");
 
  pass([[gstepBundle pathForResource: @"NSTimeZones" ofType: nil]
    testForString], 
    "-pathForResource:ofType: finds a file");
  [arp release]; arp = nil;
  return 0;
}
