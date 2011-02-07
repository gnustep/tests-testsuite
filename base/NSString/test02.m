#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSString.h>

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  NSArray *result;
  char *testPath = NULL;
  char *resultPath = NULL;

  pass([[[@"home" pathComponents] objectAtIndex:0] isEqual: @"home"],
       "[@\"home\" pathComponents] == @\"home\"]");
  
  result = [@"/home" pathComponents];
  pass([[result objectAtIndex:0] isEqual: @"/"]
       && [[result objectAtIndex:1] isEqual: @"home"],
       "[@\"/home\" pathComponents] == (@\"/\", @\"home\"])");
  
  result = [@"/home/" pathComponents];
  pass([[result objectAtIndex:0] isEqual: @"/"]
       && [[result objectAtIndex:1] isEqual: @"home"]
       && [[result objectAtIndex:2] isEqual: @"/"],
       "[@\"/home\" pathComponents] == (@\"/\", @\"home\",\"/\")]");
  
  result = [@"/home/nicola" pathComponents];
  pass([[result objectAtIndex:0] isEqual: @"/"]
       && [[result objectAtIndex:1] isEqual: @"home"]
       && [[result objectAtIndex:2] isEqual: @"nicola"],
       "[@\"/home/nicola\" pathComponents] == (@\"/\", @\"home\",\"nicola\")]");
  
  result = [@"//home//nicola" pathComponents];
  pass([[result objectAtIndex:0] isEqual: @"/"]
       && [[result objectAtIndex:1] isEqual: @"home"]
       && [[result objectAtIndex:2] isEqual: @"nicola"],
       "[@\"//home//nicola\" pathComponents] == (@\"/\", @\"home\",\"nicola\")]");
  pass([[@"home/nicola.jpg" pathExtension] isEqual: @"jpg"],
       "[@\"home/nicola.jpg\" pathExtension] == @\"jpg\"");

  pass([[@"/home/nicola.jpg" pathExtension] isEqual: @"jpg"],
       "[@\"/home/nicola.jpg\\\" pathExtension] == @\"jpg\"");
  
  pass([[@"home/nicola" pathExtension] isEqual: @""],
       "[@\"home/nicola\" pathExtension] == @\"\"");
 
  pass([[@"home/nicola/" pathExtension] isEqual: @""],
       "[@\"home/nicola\" pathExtension] == @\"\"");
  
  pass([[@"/home/nicola..jpg" pathExtension] isEqual: @"jpg"],
       "[@\"/home/nicola..jpg\" pathExtension] == @\"jpg\"");
  
  pass([[@"/home/nicola.jpg/" pathExtension] isEqual: @"jpg"],
       "[@\"/home/nicola.jpg/\" pathExtension] == @\"jpg\"");
  
  pass([[@"/home/nicola.jpg/extra" pathExtension] isEqual: @""],
       "[@\"/home/nicola.jpg/extra\" pathExtension] == @\"\"");
  
  pass([[@"/home/nicola./" pathExtension] isEqual: @""],
       "[@\"/home/nicola./\" pathExtension] == @\"\"");
  
  pass([[@"/home" stringByAppendingPathComponent: @"nicola.jpg"] isEqual: @"/home/nicola.jpg"],
       "'/home' stringByAppendingPathComponent: 'nicola.jpg' == '/home/nicola.jpg'");
  
  pass([[@"/home/" stringByAppendingPathComponent: @"nicola.jpg"] isEqual: @"/home/nicola.jpg"],
       "'/home/' stringByAppendingPathComponent: 'nicola.jpg' == '/home/nicola.jpg'");
    
  pass([[@"/" stringByAppendingPathComponent: @"nicola.jpg"] isEqual: @"/nicola.jpg"],
       "'/' stringByAppendingPathComponent: 'nicola.jpg' == '/nicola.jpg'");
  
  pass([[@"" stringByAppendingPathComponent: @"nicola.jpg"] isEqual: @"nicola.jpg"],
       "'' stringByAppendingPathComponent: 'nicola.jpg' == 'nicola.jpg'");
  
  pass([[@"/home/nicola.jpg" stringByAppendingPathExtension: @"jpg"] isEqual: @"/home/nicola.jpg.jpg"],
       "'/home/nicola.jpg' stringByAppendingPathExtension:'jpg' == '/home/nicola.jpg.jpg'");
  
  pass([[@"/home/nicola." stringByAppendingPathExtension: @"jpg"] isEqual: @"/home/nicola..jpg"],
       "'/home/nicola.' stringByAppendingPathExtension:'jpg' == '/home/nicola..jpg'");
  
  /* in the guile version of this test the description was different than the 
     test i've updated it for the description to be the same as the test not
     sure which is correct but the test passes */
  pass([[@"/home/nicola/" stringByAppendingPathExtension: @"jpg"] isEqual: @"/home/nicola.jpg"],
       "'/home/nicola/' stringByAppendingPathExtension:'jpg' == '/home/nicola.jpg'");
  
  pass([[@"nicola" stringByAppendingPathExtension: @"jpg"] isEqual: @"nicola.jpg"],
       "'nicola' stringByAppendingPathExtension:'jpg' == 'nicola.jpg'");
  
  pass([[@"nicola" stringByAppendingPathExtension: @"jpg"] isEqual: @"nicola.jpg"],
       "'nicola' stringByAppendingPathExtension:'jpg' == 'nicola.jpg'");
 
 /* string by deleting last path component tests */

  pass([[@"/home/nicola.jpg" stringByDeletingLastPathComponent] isEqual: @"/home"],
       "'/home/nicola.jpg' stringByDeletingLastPathComponent == '/home'");
  
  pass([[@"/home/nicola/" stringByDeletingLastPathComponent] isEqual: @"/home"],
       "'/home/nicola/' stringByDeletingLastPathComponent == '/home'");
  pass([[@"/home/nicola" stringByDeletingLastPathComponent] isEqual: @"/home"],
       "'/home/nicola' stringByDeletingLastPathComponent == '/'");
  pass([[@"/home/" stringByDeletingLastPathComponent] isEqual: @"/"],
       "'/home/' stringByDeletingLastPathComponent == '/'");
  pass([[@"/home" stringByDeletingLastPathComponent] isEqual: @"/"],
       "'/home' stringByDeletingLastPathComponent == '/'");
  pass([[@"/" stringByDeletingLastPathComponent] isEqual: @"/"],
       "'/' stringByDeletingLastPathComponent == '/'");
  pass([[@"hello" stringByDeletingLastPathComponent] isEqual: @""],
       "'hello' stringByDeletingLastPathComponent == ''");

/* Check behavior for UNC absolute and relative paths.
 */
#ifdef	GNUSTEP_BASE_LIBRARY
  GSPathHandling("gnustep");

  // UNC
  PASS_EQUAL([@"//host/share/file.jpg" stringByDeletingLastPathComponent],
    @"//host/share/",
    "'//host/file.jpg' stringByDeletingLastPathComponent == '//host/'");

  // UNC
  PASS_EQUAL([@"//host/share/" stringByDeletingLastPathComponent],
    @"//host/share/",
    "'//host/share/' stringByDeletingLastPathComponent == '//host/share/'");

  // Not UNC
  PASS_EQUAL([@"///host/share/" stringByDeletingLastPathComponent],
    @"///host",
    "'///host/share/' stringByDeletingLastPathComponent == '///host'");

  // Not UNC
  PASS_EQUAL([@"//host/share" stringByDeletingLastPathComponent],
    @"//host",
    "'//host/share' stringByDeletingLastPathComponent == '//host'");

  // Not UNC
  PASS_EQUAL([@"//dir/" stringByDeletingLastPathComponent],
    @"/",
    "'//dir/' stringByDeletingLastPathComponent == '/'");

  GSPathHandling("unix");
#endif

/* Check behavior when UNC paths are not supported.
 */
  pass([[@"//host/share/file.jpg" stringByDeletingLastPathComponent]
    isEqual: @"//host/share"],
    "'//host/file.jpg' stringByDeletingLastPathComponent == '//host/share'");
  pass([[@"//host/share/" stringByDeletingLastPathComponent]
    isEqual: @"//host"],
    "'//host/share/' stringByDeletingLastPathComponent == '//host'");
  pass([[@"//host/share" stringByDeletingLastPathComponent]
   isEqual: @"//host"],
   "'//host/share' stringByDeletingLastPathComponent == '//host'");
  pass([[@"//dir/" stringByDeletingLastPathComponent] isEqual: @"/"],
   "'//dir/' stringByDeletingLastPathComponent == '/'");

#ifdef	GNUSTEP_BASE_LIBRARY
  GSPathHandling("gnustep");
#endif

  /* delete path extension tests */
  pass([[@"/home/nicola.jpg" stringByDeletingPathExtension] isEqual: @"/home/nicola"],
       "'/home/nicola.jpg' stringByDeletingPathExtension == '/home/nicola'");
  pass([[@"/home/" stringByDeletingPathExtension] isEqual: @"/home"],
       "'/home/' stringByDeletingPathExtension == '/home'");
  pass([[@"nicola.jpg" stringByDeletingPathExtension] isEqual: @"nicola"],
       "'nicola.jpg' stringByDeletingPathExtension == 'nicola'");
  pass([[@"nicola..jpg" stringByDeletingPathExtension] isEqual: @"nicola."],
       "'nicola..jpg' stringByDeletingPathExtension == 'nicola.'");
  pass([[@".jpg" stringByDeletingPathExtension] isEqual: @".jpg"],
       "'.jpg' stringByDeletingPathExtension == '.jpg'");
  pass([[@"/" stringByDeletingPathExtension] isEqual: @"/"],
       "'/' stringByDeletingPathExtension == '/'");
  
  /* stringByExpandingTildeInPath tests */
 
  pass([[@"/home/nicola/nil" stringByExpandingTildeInPath] 
					isEqual: @"/home/nicola/nil"],
      "'/home/nicola/nil' stringByExpandingTildeInPath: == '/home/nicola/nil'");
  pass(![[@"~/nil" stringByExpandingTildeInPath] 
					isEqual: @"~/nil"],
      "'~/nil' stringByExpandingTildeInPath: != '~/nil'");

#if	defined(__MINGW32__)
  {
    NSString *s = [@"~" stringByAppendingString: NSUserName()];
    pass(![[s stringByExpandingTildeInPath] isEqual: s],
      "'~user' stringByExpandingTildeInPath: != '~user'");
  }
#else
  pass(![[@"~root" stringByExpandingTildeInPath] 
				isEqual: @"~root"],
      "'~root' stringByExpandingTildeInPath: != '~root'");
#endif
  
#ifdef	GNUSTEP_BASE_LIBRARY

  PASS_EQUAL([@"//home/user/" stringByStandardizingPath], @"//home/user/",
    "//home/user/ stringByStandardizingPath == //home/user/");

  PASS_EQUAL([@"\\\\home\\user\\" stringByStandardizingPath],
    @"\\\\home\\user\\",
    "\\\\home\\user\\ stringByStandardizingPath == \\\\home\\user\\");

  PASS_EQUAL([@"c:\\." stringByStandardizingPath], @"c:\\",
    "'c:\\.' stringByStandardizingPath == 'c:\\'");
  
  PASS_EQUAL([@"c:\\..." stringByStandardizingPath], @"c:\\...",
    "'c:\\...' stringByStandardizingPath == 'c:\\...'");
  
  pass([@"c:/home" isAbsolutePath] == YES,
       "'c:/home' isAbsolutePath == YES");

  pass([@"//host/share/" isAbsolutePath] == YES,
       "'//host/share/' isAbsolutePath == YES");

#endif

  PASS_EQUAL([@"/home//user/" stringByStandardizingPath], @"/home/user",
   "/home//user/ stringByStandardizingPath == /home/user");

  PASS_EQUAL([@"//home/user" stringByStandardizingPath], @"/home/user",
   "//home/user stringByStandardizingPath == /home/user");

  PASS_EQUAL([@"///home/user" stringByStandardizingPath], @"/home/user",
   "///home/user stringByStandardizingPath == /home/user");
  
  PASS_EQUAL([@"/home/./user" stringByStandardizingPath], @"/home/user",
   "/home/./user stringByStandardizingPath == /home/user");
  
  PASS_EQUAL([@"/home/user/." stringByStandardizingPath], @"/home/user",
   "/home/user/. stringByStandardizingPath == /home/user");
  
  PASS_EQUAL([@"/home/.//././user" stringByStandardizingPath], @"/home/user",
   "/home/.//././user stringByStandardizingPath == /home/user");
  
  PASS_EQUAL([@"/home/../nicola" stringByStandardizingPath], @"/home/../nicola",
   "/home/../nicola stringByStandardizingPath == /home/../nicola");
  
  PASS_EQUAL([@"/." stringByStandardizingPath], @"/",
   "/. stringByStandardizingPath == /");
  
  result = [NSArray arrayWithObjects: @"nicola",@"core",nil];
  result = [@"home" stringsByAppendingPaths:result];
  pass([result count] == 2
    && [[result objectAtIndex:0] isEqual: @"home/nicola"]
    && [[result objectAtIndex:1] isEqual: @"home/core"],
    "stringsByAppendingPaths works");
  
  pass([@"home" isAbsolutePath] == NO,
       "'home' isAbsolutePath == NO");

#if	defined(__MINGW32__)
  pass([@"/home" isAbsolutePath] == NO,
       "'/home' isAbsolutePath == NO");
  pass([@"//host/share" isAbsolutePath] == NO,
       "'//host/share' isAbsolutePath == NO");
#else
  pass([@"/home" isAbsolutePath] == YES,
       "'/home' isAbsolutePath == YES");
  pass([@"//host/share" isAbsolutePath] == YES,
       "'//host/share' isAbsolutePath == YES");
#endif
  
  result = [NSArray arrayWithObjects: @"nicola",@"core",nil];
  pass([[NSString pathWithComponents:result] isEqual: @"nicola/core"],
       "+pathWithComponents works for relative path");
  result = [NSArray arrayWithObjects: @"/", @"nicola", @"core", nil];
  pass([[NSString pathWithComponents:result] isEqual: @"/nicola/core"],
       "+pathWithComponents works works for absolute path");
  
  [arp release]; arp = nil;
  return 0;
}
