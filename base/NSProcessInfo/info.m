/*
 *  More detailed testing of the information returned by NSProcessInfo
 *
 *  AUTHOR:  Sheldon Gill <sheldon@westnet.net.au>
 *
 *  Copyright (C) 2006, Sheldon Gill
 *  License: GPL V2
 */

#import "Testing.h"
#import <Foundation/NSArray.h>
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSProcessInfo.h>
#import <Foundation/NSString.h>

#if defined(__MINGW32__)
#define PROCESSNAME @"info.exe"
#else
#define PROCESSNAME @"info"
#endif

/*
 * Return the integer ID of this process
 */
int get_process_id(void);

/*
 * Return the integer ID of this process
 */
int operating_system(void);

#if defined(__MINGW32__)
int get_process_id(void)
{
  return (int)GetCurrentProcessId();
}

int operating_system(void)
{
  return NSWindowsNTOperatingSystem;
}
#else

#include <sys/unistd.h>
#include <sys/utsname.h>

int get_process_id(void)
{
  return (int)getpid();
}

/* GNUstep extensions so they don't exist in Cocoa */
#if defined(__APPLE__)
#define NSGNULinuxOperatingSystem 65534
#define NSBSDOperatingSystem      65533
#define NSBeOperatingSystem       65532
#endif

#ifndef NSCygwinOperatingSystem
#define NSCygwinOperatingSystem   65531
#endif

int operating_system(void)
{
    struct utsname uns;

    if (!uname(&uns))
      {
        /* The regular OpenStep defined OperatingSystem */
        if (strcmp(uns.sysname,"Solaris") == 0)
            return NSSolarisOperatingSystem;
        if (strcmp(uns.sysname,"SunOS") == 0)
            return NSSunOSOperatingSystem;
        if (strcmp(uns.sysname,"Darwin") == 0)
            return NSMACHOperatingSystem;
        /* The regular OpenStep defined OperatingSystem */
        if (strcmp(uns.sysname,"Linux") == 0)
            return NSGNULinuxOperatingSystem;
        // FIXME: What do the BSDs return? -SG
        if (strcmp(uns.sysname,"DragonFly") == 0)
            return NSBSDOperatingSystem; // NSDragonFlyBSDOperatingSystem
        if (strncmp(uns.sysname,"CYGWIN",6) == 0)
            return NSCygwinOperatingSystem;
      }
    else
      {
        return -1; // Failed
      }
}
#endif

/*
 * return the name of local host based on answer in file
 */
NSString *local_host_name(id obj)
{
/*
#if defined(__MINGW32__)
    NSString *hostEnvKey = @"COMPUTERNAME";
#else
    NSString *hostEnvKey = @"HOSTNAME";
#endif

    // FIXME: Let's implement an expects() style solution
    //         so we can get authoritative answers from
    //         the human running the tests. -SG
    if ([obj respondsToSelector: @selector(environment)])
      {
        return [[obj environment] objectForKey: hostEnvKey];
      }
*/
    NSString *hostName = [NSString stringWithCString: get_test_answer("HostName")];
    return hostName;
}

/*
 * return a string representation of the NS*OperationSystem constant
 */
char *os_constant(int os_id)
{
    switch(os_id)
      {
        case NSWindowsNTOperatingSystem:
            return "NSWindowsNTOperatingSystem";
        case NSWindows95OperatingSystem:
            return "NSWindows95OperatingSystem";
        case NSSolarisOperatingSystem:
            return "NSSolarisOperatingSystem";
        case  NSHPUXOperatingSystem:
            return "NSHPUXOperatingSystem";
        case  NSMACHOperatingSystem:
            return "NSMACHOperatingSystem";
        case  NSSunOSOperatingSystem:
            return "NSSunOSOperatingSystem";
        case  NSOSF1OperatingSystem:
            return "NSOSF1OperatingSystem";
        case  NSGNULinuxOperatingSystem:
            return "NSGNULinuxOperatingSystem";
        case  NSBSDOperatingSystem:
            return "NSBSDOperatingSystem";
        case  NSBeOperatingSystem:
            return "NSBeOperatingSystem";
        case  NSCygwinOperatingSystem:
            return "NSCygwinOperatingSystem";
      }
    return "unknown";
}

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSProcessInfo *info = [NSProcessInfo processInfo];
  NSDictionary  *env;
  NSString      *aString;
  unsigned int val;
  pass(info != nil, "NSProcessInfo returned processInfo");

  env = [info environment];
  aString = [env objectForKey: @"GNUSTEP_MAKEFILES"];

  pass(aString != nil, "Can read GNUSTEP_MAKEFILES environment variable");

  aString = [info processName];
  pass(aString != nil &&
       [aString isEqual: PROCESSNAME],
       "processName is %s", [aString lossyCString]);

  val = get_process_id();
  pass(val == [info processIdentifier], "processIdentifier seems correct");

  aString = [info hostName];
  pass([aString isEqualToString: local_host_name(info)],
         "got hostName '%s' correct", [aString lossyCString]);

  val = [info operatingSystem];
  pass(val != 0, "operating system is %s",os_constant(val));

  aString = [NSString stringWithCString: os_constant(val)];
  pass([aString isEqualToString: [info operatingSystemName]],
         "NeXT/OSX compatible operatingSystemName implementation");

  DESTROY(arp);
  return 0;
}
