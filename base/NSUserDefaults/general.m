#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSUserDefaults.h>
#include "ObjectTesting.h"

int main()
{
  CREATE_AUTORELEASE_POOL(arp);

  NSUserDefaults *defs;
  id lang;

  defs = [NSUserDefaults standardUserDefaults];
  pass(defs != nil && [defs isKindOfClass: [NSUserDefaults class]],
       "NSUserDefaults understands +standardUserDefaults");

  lang = [NSUserDefaults userLanguages];
  pass(lang != nil && [lang isKindOfClass: [NSArray class]],
       "NSUserDefaults understands +userLanguages");

  [NSUserDefaults setUserLanguages:
    [NSArray arrayWithObject: @"Bogus language"]];
  pass([lang isEqual: [NSUserDefaults userLanguages]] == NO,
       "NSUserDefaults understands +setUserLanguages");

  [NSUserDefaults setUserLanguages: lang];
  pass([lang isEqual: [NSUserDefaults userLanguages]],
       "NSUserDefaults can set user languages");

  [defs setBool: YES forKey: @"Test Suite Bool"];
  pass([defs boolForKey: @"Test Suite Bool"],
       "NSUserDefaults can set/get a BOOL");

  [defs setInteger: 34 forKey: @"Test Suite Int"];
  pass([defs integerForKey: @"Test Suite Int"] == 34,
       "NSUserDefaults can set/get an int");

  [defs setObject: @"SetString" forKey: @"Test Suite Str"];
  pass([[defs stringForKey: @"Test Suite Str"] isEqual: @"SetString"],
       "NSUserDefaults can set/get a string");
  
  DESTROY(arp);
  return 0;
}
