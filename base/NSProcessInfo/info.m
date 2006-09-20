/*
   More detailed testing of the information returned by NSProcessInfo

   AUTHOR:  Sheldon Gill

   COPYRIGHT (C) 2006, Sheldon Gill
   
   License: GPL V2
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
int get_process_id(void)
{
  return (int)getpid();
}

int operating_system(void)
{
    struct utsname uns;

    if (!uname(&uns))
      {
        if (strcmp(uns.sysname,"Linux") == 0)
            return NSGNULinuxOperatingSystem;
        if (strcmp(uns.sysname,"Solaris") == 0)
            return NSSolarisOperatingSystem;
        if (strcmp(uns.system,"Darwin") == 0)
            return NSMachOperatingSystem;
        if (strcmp(uns.system,"cygwin") == 0)
            return NSCygwinOperatingSystem;
      }
    else
      {
        return -1; // Failed
      }
}
#endif

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
  pass(val == [info processIdentifier], "-processIdentifier works");

  val = [info operatingSystem];
  pass(val != 0, "operating  system is %s",os_constant(val));

  aString = [NSString stringWithCString: os_constant(val)];
  pass([aString isEqual: [info operatingSystemName]],
         "NeXT/OSX compatible operatingSystemName implementation");

  DESTROY(arp);
  return 0;
}
