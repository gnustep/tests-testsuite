/* NSGeometry tests */
#import <Foundation/Foundation.h>
#import "Testing.h"

static BOOL	MacOSXCompatibleGeometry()
{
  NSUserDefaults *dflt = [NSUserDefaults standardUserDefaults];
  if ([dflt boolForKey: @"GSOldStyleGeometry"] == YES)
    return NO;
  return [dflt boolForKey: @"GSMacOSXCompatible"];
}

/* Test the string functions */
int
geom_string()
{
#if     defined(GNUSTEP_BASE_LIBRARY)
  NSUserDefaults *dflt = [NSUserDefaults standardUserDefaults];
  BOOL compat_mode = MacOSXCompatibleGeometry();
#endif
  NSPoint p, p2;
  NSRect r, r2;
  NSSize s, s2;
  NSString *sp, *sr, *ss;
  
  p = NSMakePoint(23.45, -3.45);
  r = NSMakeRect(23.45, -3.45, 2044.3, 2033);
  s = NSMakeSize(0.5, 0.22);

#if     defined(GNUSTEP_BASE_LIBRARY)
  if (compat_mode == YES)
    {
      [dflt setBool: NO forKey: @"GSMacOSXCompatible"];
      [NSUserDefaults resetStandardUserDefaults];
    }
  pass((MacOSXCompatibleGeometry() == NO), 
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
  pass((MacOSXCompatibleGeometry() == YES), 
       "In MacOSX geometry compat mode");
#endif

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

#if     defined(GNUSTEP_BASE_LIBRARY)
  if (compat_mode != MacOSXCompatibleGeometry())
    {
      [dflt setBool: NO forKey: @"GSMacOSXCompatible"];
    }
#endif
  return 0;
}

int main()
{ 
  CREATE_AUTORELEASE_POOL(pool);

  geom_string();
  
  IF_NO_GC(DESTROY(pool));
 
  return 0;
}
