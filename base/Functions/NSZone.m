#include <Foundation/Foundation.h>
#include "Testing.h"

int main()
{ 
  CREATE_AUTORELEASE_POOL(pool);
  NSZone *aZone;
  char *vp; 
  void *ovp;

  aZone = NSDefaultMallocZone();
  pass((aZone != NULL), "NSDefaultMallocZone() returns something");

  aZone = NSCreateZone(1024,1024,0);
  pass((aZone != NULL), "NSCreateZone() works for an unfreeable zone");
 
  aZone = NSCreateZone(1024,1024,1);
  pass((aZone != NULL), "NSCreateZone() works for a normal zone");
 
  NSSetZoneName(aZone, @"My Zone");
  pass(([NSZoneName(aZone) isEqual: @"My Zone"]), "NSZoneName() returns previously set string");
 
  vp = NSZoneCalloc(aZone,17,12);
  memset(vp,1,17*12);

  NS_DURING
    {
      NSZoneFree(aZone,vp);
      pass(1, "NSZoneFree() calloc'd buffer"); 
    }
  NS_HANDLER
   pass(0, "NSZoneFree() calloc'd buffer %s",[[localException name] cString]); 
  NS_ENDHANDLER
  
  NS_DURING
    NSZoneFree(aZone,vp);
    pass(0, "NSZoneFree() free'd buffer throws exception"); 
  NS_HANDLER
    pass(1, "NSZoneFree() free'd buffer throws exception: %s",[[localException name] cString]); 
  NS_ENDHANDLER

  
  vp = NSZoneMalloc(aZone,2000);
  memset(vp,2,2000);

  NS_DURING
    {
      NSZoneFree(aZone,vp);
      pass(1, "NSZoneFree() malloc'd buffer"); 
    }
  NS_HANDLER
   pass(0, "NSZoneFree() malloc'd buffer %s",[[localException name] cString]); 
  NS_ENDHANDLER

  ovp = NSZoneMalloc(aZone, 1000);
  vp = NSZoneRealloc(aZone, ovp, 2000); 
  memset(vp,3,2000); 
  
  NSZoneRealloc(aZone, vp, 1000);
  memset(vp,4,1000); 
  
  NS_DURING
    NSZoneFree(aZone,vp);
    pass(1,"NSZoneFree() releases memory held after realloc");
  NS_HANDLER
    pass(0,"NSZoneFree() releases memory held after realloc");
  NS_ENDHANDLER

  pass((NSZoneFromPointer(vp) == aZone), "NSZoneFromPointer() returns zone where memory came from");
 
  NS_DURING
   [NSString allocWithZone:aZone];
   NSRecycleZone(aZone);
    pass(1,"NSRecycleZone seems to operate");
  NS_HANDLER
    pass(0,"NSRecycleZone seems to operate");
  NS_ENDHANDLER
  DESTROY(pool);
 
  return 0;
}
