/* NSGeometry tests */
#include <Foundation/Foundation.h>
#include "Testing.h"

extern BOOL	GSMacOSXCompatibleGeometry(void);	// Compatibility mode

/* Test the string functions */
int
geom_string()
{
  BOOL compat_mode;
  NSPoint p, p2;
  NSRect r, r2;
  NSSize s, s2;
  NSString *sp, *sr, *ss;
  NSUserDefaults *dflt = [NSUserDefaults standardUserDefaults];
  
  p = NSMakePoint(23.45, -3.45);
  r = NSMakeRect(23.45, -3.45, 2044.3, 2033);
  s = NSMakeSize(0.5, 0.22);

  compat_mode = GSMacOSXCompatibleGeometry();
  if (compat_mode == YES)
    {
      [dflt setBool: NO forKey: @"GSMacOSXCompatible"];
      [NSUserDefaults resetStandardUserDefaults];
    }

  pass((GSMacOSXCompatibleGeometry() == NO), 
       "Not in MacOSX geometry compat mode");
  sp = NSStringFromPoint(p);
  p2 = NSPointFromString(sp);
  pass((EQ(p2.x, p.x) && EQ(p2.y, p.y)), 
       "Can read output of NSStringFromPoint");

  sr = NSStringFromRect(r);
  r2 = NSRectFromString(sr);
  pass((EQ(r2.origin.x, r.origin.x) && EQ(r2.origin.y, r.origin.y)
	&& EQ(r2.size.width, r.size.width) && EQ(r2.size.height, r.size.height)), 
       "Can read output of NSStringFromRect");

  ss = NSStringFromSize(s);
  s2 = NSSizeFromString(ss);
  pass((EQ(s2.width, s.width) && EQ(s2.height, s.height)), 
       "Can read output of NSStringFromSize");

  dflt = [NSUserDefaults standardUserDefaults];
  [dflt setBool: YES forKey: @"GSMacOSXCompatible"];
  [NSUserDefaults resetStandardUserDefaults];
  pass((GSMacOSXCompatibleGeometry() == YES), 
       "In MacOSX geometry compat mode");

  sp = NSStringFromPoint(p);
  p2 = NSPointFromString(sp);
  pass((EQ(p2.x, p.x) && EQ(p2.y, p.y)), 
       "Can read output of NSStringFromPoint (MacOSX compat)");

  sr = NSStringFromRect(r);
  r2 = NSRectFromString(sr);
  pass((EQ(r2.origin.x, r.origin.x) && EQ(r2.origin.y, r.origin.y)
	&& EQ(r2.size.width, r.size.width) && EQ(r2.size.height, r.size.height)), 
       "Can read output of NSStringFromRect (MacOSX compat)");

  ss = NSStringFromSize(s);
  s2 = NSSizeFromString(ss);
  pass((EQ(s2.width, s.width) && EQ(s2.height, s.height)), 
       "Can read output of NSStringFromSize (MacOSX compat)");

  if (compat_mode != GSMacOSXCompatibleGeometry())
    {
      [dflt setBool: NO forKey: @"GSMacOSXCompatible"];
    }
  return 0;
}

int main()
{ 
  CREATE_AUTORELEASE_POOL(pool);

  geom_string();
  
  DESTROY(pool);
 
  return 0;
}
