#include "../GDL2Testing.h"
#include <Foundation/NSAutoreleasePool.h>

int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  EOEntity *ent;
  EOEntity *ent2;
  
  EOModel *model;
  EORelationship *rel;
  EOAttribute *attrib;
  EOAttribute *attrib2;

  rel = [EORelationship new];
  ent = [EOEntity new];
  ent2 = [EOEntity new];
  model = [EOModel new];
  attrib = [EOAttribute new];
  attrib2 = [EOAttribute new];

  [model setName:@"model"];
  [ent setName:@"ent"];
  [ent2 setName:@"ent2"];
  [attrib setName:@"attrib"];
  [attrib2 setName:@"attrib2"];
  [rel setName:@"rel"];

  [ent setClassName:@"EOGenericRecord"];
  [ent addAttribute:attrib];
  [ent addRelationship:rel];
  [ent2 setClassName:@"EOGenericRecord"];
  [ent2 addAttribute:attrib2];

  [model addEntity:ent];
  [model addEntity:ent2];
  
  pass([[model referencesToProperty:attrib] count] == 0, 
	"-referencesToProperty: with no references (to source)");
  pass([[model referencesToProperty:attrib2] count] == 0,
	"-referencesToProperty: with no references (to destination)");
  [rel addJoin:[EOJoin joinWithSourceAttribute:attrib destinationAttribute:attrib2]];

  pass([[model referencesToProperty:attrib] containsObject:rel],
	"-referencesToProperty: contains references (to source attribute)");
  pass([[model referencesToProperty:attrib2] containsObject:rel],
       "-referencesToProperty: contains references (to destination attribute)");

  pass([ent referencesProperty:attrib2] == YES,
  	"entity with relationship -referencesProperty: destination attribute");
  pass([ent referencesProperty:attrib] == YES,
  	"entity with relationship -referencesProperty: source attribute");
  pass([rel referencesProperty:attrib2] == YES,
  	"relationship -referencesProperty: destination attribute");
  pass([rel referencesProperty:attrib] == YES,
  	"relationship -referencesProperty: source attribute");

  RELEASE(pool);
  return 0;
}
