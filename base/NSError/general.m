/*
 *  Testing of NSError
 *
 *  Written by:  Sheldon Gill <sheldon@westnet.net.au>
 *
 *  Copyright (C) 2006, Sheldon Gill
 *  License: GPL V2
 */

#import "Testing.h"
#include <Foundation/NSString.h>
#include <Foundation/NSPathUtilities.h>
#include <Foundation/NSArray.h>
#include <Foundation/NSFileManager.h>
#include <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSData.h>
#import <Foundation/NSException.h>
#import <Foundation/NSError.h>

#include "TestingUtils.h"

// This is only on GNUstep after base-ng 1.14
#ifndef GSWin32ErrorDomain
const NSString *GSMSWindowsErrorDomain = @"GSMSWindowsErrorDomain";
#endif

// This is only on GNUstep after base-ng 1.14 & MacOSX 10.4
#ifndef NSLocalizedFailureReasonErrorKey
const NSString *NSLocalizedFailureReasonErrorKey = @"NSLocalizedFailureReasonErrorKey";
const NSString *NSLocalizedRecoveryOptionsErrorKey = @"NSLocalizedRecoveryOptionsErrorKey";
#endif

char *error_codes[] = {
    "No error",
    "Operation not permitted",
    "No such file or directory",
    "No such process",
    "Interrupted function call",
    "Input/output error",
    "No such device or address",
    "Arg list too long",
    "Exec format error",
    "Bad file descriptor",
    "No child processes",
    "Resource temporarily unavailable",
    "Not enough space",
    "Permission denied",
    "Bad address",
    "Unknown error",
    "Resource device",
    "File exists",
    "Improper link",
    "No such device",
    "Not a directory",
    "Is a directory",
    "Invalid argument",
    "Too many open files in system",
    "Too many open files",
    "Inappropriate I/O control operation",
    "Unknown error",
    "File too large",
    "No space left on device",
    "Invalid seek",
    "Read-only file system",
    "Too many links",
    "Broken pipe",
    "Domain error",
    "Result too large",
    "Unknown error",
    "Resource deadlock avoided",
    "Unknown error",
    "Filename too long",
    "No locks available",
    "Function not implemented",
    "Directory not empty",
    "Illegal byte sequence"
};

int main( int argc, char *argv[] )
{
  CREATE_AUTORELEASE_POOL(arp);
  NSString *aString;
  NSString *expString;
  NSString *testString;

  NSError  *anError;

  int matched;

  /* ***************************************** */
  /* OSStatus Error domain                     */
  /* ***************************************** */

  /* ***************************************** */
  /* MACH Error domain                         */
  /* ***************************************** */

  /* ***************************************** */
  /* POSIX Error domain                        */
  /* ***************************************** */

  /* ----------------------------------------------------------------
   * TEST : errno == 1 in the POSIX domain
   * ------------------------------------------------------------- */
  anError = [NSError errorWithDomain: NSPOSIXErrorDomain
                                code: 1
                            userInfo: nil];

  pass((anError != nil) && ([anError code] == 1) &&
       [[anError domain] isEqualToString: NSPOSIXErrorDomain],
       "Can construct the error object properly");

  testString = [anError localizedDescription];
  pass([testString isEqualToString: @"Operation not permitted"],
        "Correct localized description \"%s\" for code %d",[testString lossyCString],1);

  /* ***************************************** */
  /* Win32 Error domain                        */
  /* ***************************************** */

  /* ----------------------------------------------------------------
   * TEST : errno == 1 in the Win32 domain
   * ------------------------------------------------------------- */
  anError = [NSError errorWithDomain: GSMSWindowsErrorDomain
                                code: 1
                            userInfo: nil];

  pass((anError != nil) && ([anError code] == 1) &&
       [[anError domain] isEqualToString: GSMSWindowsErrorDomain],
       "Can construct the error object properly");

  testString = [anError localizedDescription];
#if defined(__MINGW32__)
  pass([testString isEqualToString: @"Incorrect function.\r\n"],
        "Correct localized description \"%s\" for code %d",[testString lossyCString],1);
#else
  pass([testString isEqualToString: @"GSMSWindowsErrorDomain 1"],
        "Correct localized description \"%s\" for code %d",[testString lossyCString],1);
#endif

  pass([testString isEqualToString: [anError description]],
         "Printing object works as expected");

  /* ***************************************** */
  /* Constructed Error domain                  */
  /* ***************************************** */

  /* ----------------------------------------------------------------
   * TEST : errno == 42 in our custom domain
   * ------------------------------------------------------------- */
  NSString *errorDomain = @"BaseNG_Custom";
  NSMutableDictionary *errDict = [NSMutableDictionary dictionaryWithCapacity: 5];

  [errDict setObject: @"Method failed."
              forKey: NSLocalizedDescriptionKey];
  [errDict setObject: @"Because it didn't work"
              forKey: NSLocalizedFailureReasonErrorKey];
  [errDict setObject: [NSArray arrayWithObjects: @"Step 1", @"Step 2", nil]
              forKey: NSLocalizedRecoveryOptionsErrorKey];

  anError = [NSError errorWithDomain: errorDomain
                                code: 42
                            userInfo: errDict];

  pass((anError != nil) && ([anError code] == 42) &&
       [[anError domain] isEqualToString: errorDomain],
       "Can construct the error object properly");

  testString = [anError localizedDescription];
  pass([testString isEqualToString: @"Method failed."],
        "Correct localized description \"%s\" for code %d",[testString lossyCString],1);


  [arp release];
  return 0;
}
