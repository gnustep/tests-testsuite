#include "Testing.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSArray.h>
#include <Foundation/NSString.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSArray *result;
  char *testPath = NULL;
  char *resultPath = NULL;

  pass([[[@"home" pathComponents] objectAtIndex:0] isEqual:@"home"],
       "[@\"home\" pathComponents] == @\"home\"]");
  
  result = [@"/home" pathComponents];
  pass([[result objectAtIndex:0] isEqual:@"/"]
       && [[result objectAtIndex:1] isEqual:@"home"],
       "[@\"/home\" pathComponents] == (@\"/\", @\"home\"])");
  
  result = [@"/home/" pathComponents];
  pass([[result objectAtIndex:0] isEqual:@"/"]
       && [[result objectAtIndex:1] isEqual:@"home"]
       && [[result objectAtIndex:2] isEqual:@"/"],
       "[@\"/home\" pathComponents] == (@\"/\", @\"home\",\"/\")]");
  
  result = [@"/home/nicola" pathComponents];
  pass([[result objectAtIndex:0] isEqual:@"/"]
       && [[result objectAtIndex:1] isEqual:@"home"]
       && [[result objectAtIndex:2] isEqual:@"nicola"],
       "[@\"/home/nicola\" pathComponents] == (@\"/\", @\"home\",\"nicola\")]");
  
  result = [@"//home//nicola" pathComponents];
  pass([[result objectAtIndex:0] isEqual:@"/"]
       && [[result objectAtIndex:1] isEqual:@"home"]
       && [[result objectAtIndex:2] isEqual:@"nicola"],
       "[@\"//home//nicola\" pathComponents] == (@\"/\", @\"home\",\"nicola\")]");
  pass([[@"home/nicola.jpg" pathExtension] isEqual:@"jpg"],
       "[@\"home/nicola.jpg\" pathExtension] == @\"jpg\"");

  pass([[@"/home/nicola.jpg" pathExtension] isEqual:@"jpg"],
       "[@\"/home/nicola.jpg\\\" pathExtension] == @\"jpg\"");
  
  pass([[@"home/nicola" pathExtension] isEqual:@""],
       "[@\"home/nicola\" pathExtension] == @\"\"");
 
  pass([[@"home/nicola/" pathExtension] isEqual:@""],
       "[@\"home/nicola\" pathExtension] == @\"\"");
  
  pass([[@"/home/nicola..jpg" pathExtension] isEqual:@"jpg"],
       "[@\"/home/nicola..jpg\" pathExtension] == @\"jpg\"");
  
  pass([[@"/home/nicola.jpg/" pathExtension] isEqual:@"jpg"],
       "[@\"/home/nicola.jpg/\" pathExtension] == @\"jpg\"");
  
  pass([[@"/home/nicola.jpg/extra" pathExtension] isEqual:@""],
       "[@\"/home/nicola.jpg/extra\" pathExtension] == @\"\"");
  
  pass([[@"/home/nicola./" pathExtension] isEqual:@""],
       "[@\"/home/nicola./\" pathExtension] == @\"\"");
  
  pass([[@"/home" stringByAppendingPathComponent:@"nicola.jpg"] isEqual:@"/home/nicola.jpg"],
       "'/home' stringByAppendingPathComponent: 'nicola.jpg' == '/home/nicola.jpg'");
  
  pass([[@"/home/" stringByAppendingPathComponent:@"nicola.jpg"] isEqual:@"/home/nicola.jpg"],
       "'/home/' stringByAppendingPathComponent: 'nicola.jpg' == '/home/nicola.jpg'");
    
  pass([[@"/" stringByAppendingPathComponent:@"nicola.jpg"] isEqual:@"/nicola.jpg"],
       "'/' stringByAppendingPathComponent: 'nicola.jpg' == '/nicola.jpg'");
  
  pass([[@"" stringByAppendingPathComponent:@"nicola.jpg"] isEqual:@"nicola.jpg"],
       "'' stringByAppendingPathComponent: 'nicola.jpg' == 'nicola.jpg'");
  
  pass([[@"/home/nicola.jpg" stringByAppendingPathExtension:@"jpg"] isEqual:@"/home/nicola.jpg.jpg"],
       "'/home/nicola.jpg' stringByAppendingPathExtension:'jpg' == '/home/nicola.jpg.jpg'");
  
  pass([[@"/home/nicola." stringByAppendingPathExtension:@"jpg"] isEqual:@"/home/nicola..jpg"],
       "'/home/nicola.' stringByAppendingPathExtension:'jpg' == '/home/nicola..jpg'");
  
  /* in the guile version of this test the description was different than the 
     test i've updated it for the description to be the same as the test not
     sure which is correct but the test passes */
  pass([[@"/home/nicola/" stringByAppendingPathExtension:@"jpg"] isEqual:@"/home/nicola.jpg"],
       "'/home/nicola/' stringByAppendingPathExtension:'jpg' == '/home/nicola.jpg'");
  
  pass([[@"nicola" stringByAppendingPathExtension:@"jpg"] isEqual:@"nicola.jpg"],
       "'nicola' stringByAppendingPathExtension:'jpg' == 'nicola.jpg'");
  
  pass([[@"nicola" stringByAppendingPathExtension:@"jpg"] isEqual:@"nicola.jpg"],
       "'nicola' stringByAppendingPathExtension:'jpg' == 'nicola.jpg'");
 
 /* string by deleting last path component tests */

  pass([[@"/home/nicola.jpg" stringByDeletingLastPathComponent] isEqual:@"/home"],
       "'/home/nicola.jpg' stringByDeletingLastPathComponent == '/home'");
  
  pass([[@"/home/nicola/" stringByDeletingLastPathComponent] isEqual:@"/home"],
       "'/home/nicola/' stringByDeletingLastPathComponent == '/home'");
  pass([[@"/home/" stringByDeletingLastPathComponent] isEqual:@"/"],
       "'/home/nicola/' stringByDeletingLastPathComponent == '/'");
  pass([[@"/home/" stringByDeletingLastPathComponent] isEqual:@"/"],
       "'/home/' stringByDeletingLastPathComponent == '/'");
  pass([[@"/home" stringByDeletingLastPathComponent] isEqual:@"/"],
       "'/home' stringByDeletingLastPathComponent == '/'");
  pass([[@"/" stringByDeletingLastPathComponent] isEqual:@"/"],
       "'/' stringByDeletingLastPathComponent == '/'");
  pass([[@"hello" stringByDeletingLastPathComponent] isEqual:@""],
       "'hello' stringByDeletingLastPathComponent == ''");
  /* delete path extension tests */
  pass([[@"/home/nicola.jpg" stringByDeletingPathExtension] isEqual:@"/home/nicola"],
       "'/home/nicola.jpg' stringByDeletingPathExtension == '/home/nicola'");
  pass([[@"/home/" stringByDeletingPathExtension] isEqual:@"/home"],
       "'/home/' stringByDeletingPathExtension == '/home'");
  pass([[@"nicola.jpg" stringByDeletingPathExtension] isEqual:@"nicola"],
       "'nicola.jpg' stringByDeletingPathExtension == 'nicola'");
  pass([[@"nicola..jpg" stringByDeletingPathExtension] isEqual:@"nicola."],
       "'nicola..jpg' stringByDeletingPathExtension == 'nicola.'");
  pass([[@".jpg" stringByDeletingPathExtension] isEqual:@""],
       "'.jpg' stringByDeletingPathExtension == ''");
  pass([[@"/" stringByDeletingPathExtension] isEqual:@"/"],
       "'/' stringByDeletingPathExtension == '/'");
  
  /* stringByExpandingTildeInPath tests */
 
  pass([[@"/home/nicola/nil" stringByExpandingTildeInPath] 
					isEqual:@"/home/nicola/nil"],
      "'/home/nicola/nil' stringByExpandingTildeInPath: == '/home/nicola/nil'");
  pass(![[@"~/nil" stringByExpandingTildeInPath] 
					isEqual:@"~/nil"],
      "'~/nil' stringByExpandingTildeInPath: != '~/nil'");
  pass(![[@"~root" stringByExpandingTildeInPath] 
				isEqual:@"~root"],
      "'~root' stringByExpandingTildeInPath: != '~root'");
  
  testPath = "/home//user";
  resultPath = "/home/user";
  pass(strcmp([[[NSString stringWithCString:testPath] 
	                stringByStandardizingPath] cString],resultPath) == 0,
       "'%s' stringByStandardizingPath == '%s'",testPath,resultPath);
  
  testPath = "/home/./user";
  pass(strcmp([[[NSString stringWithCString:testPath] 
	                stringByStandardizingPath] cString],resultPath) == 0,
       "'%s' stringByStandardizingPath == '%s'",testPath,resultPath);
  
  testPath = "/home/.//././user";
  pass(strcmp([[[NSString stringWithCString:testPath] 
	                stringByStandardizingPath] cString],resultPath) == 0,
       "'%s' stringByStandardizingPath == '%s'",testPath,resultPath);
  
  pass([[@"home/../nicola" stringByStandardizingPath]
  				isEqual:@"home/../nicola"],
       "'home/../nicola' stringByStandardizingPath == 'home/../nicola'");
  
  result = [NSArray arrayWithObjects:@"nicola",@"core",nil];
  result = [@"home" stringsByAppendingPaths:result];
  pass([result count] == 2
       && [[result objectAtIndex:0] isEqual:@"home/nicola"]
       && [[result objectAtIndex:1] isEqual:@"home/core"],
       "stringsByAppendingPaths works");
  
  
  pass([@"home" isAbsolutePath] == NO,
       "'home' isAbsolutePath == NO");
  pass([@"/home" isAbsolutePath] == YES,
       "'/home' isAbsolutePath == YES");
  
  result = [NSArray arrayWithObjects:@"nicola",@"core",nil];
  pass([[NSString pathWithComponents:result] isEqual:@"nicola/core"],
       "+pathWithComponents works for relative path");
  result = [NSArray arrayWithObjects:@"/", @"nicola", @"core", nil];
  pass([[NSString pathWithComponents:result] isEqual:@"/nicola/core"],
       "+pathWithComponents works works for absolute path");
  
  DESTROY(arp);
  return 0;
}
