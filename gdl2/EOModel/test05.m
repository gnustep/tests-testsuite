#include <Foundation/NSAutoreleasePool.h>
#include "../GDL2Testing.h"

int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  EOModel *model;
  EOEntity *entity;
  EORelationship *rel;
  EOAttribute *attrib;
  
  rel = [EORelationship new];
  model = [EOModel new];
  entity = [EOEntity new];
  attrib = [EOAttribute new];
  
  [rel setName:@"testRel"];
  [model setName:@"testModel"];
  [attrib setName:@"testAttrib"];
  [entity setName:@"testEntity"];
  [entity setClassName:@"EOGenericRecord"];
  [entity addRelationship:rel];
  [entity addAttribute:attrib];
  [entity setPrimaryKeyAttributes:[NSArray arrayWithObject:attrib]];
  [entity setClassProperties:[NSArray arrayWithObjects:attrib, rel, nil]];
  [model addEntity:entity];
  [[EOModelGroup defaultGroup] addModel:model];
  [model removeEntity:entity];

  
  pass([model entityNamed:@"testEntity"] == nil,
       "EOModel -entityNamed: returns nil for entity which has been removed");
  pass([[model entities] containsObject:entity] == NO,
       "EOModel -entities does not contain an entity which has been removed");
  pass([[model entityNames] containsObject:@"testEntity"] == NO,
       "EOModel -entityNames does not contain name of entity which has been removed");
  pass([[EOModelGroup defaultGroup] entityNamed:@"testEntity"] == nil,
       "EOModelGroup -entityNamed: returns nil for entity which has been removed");
  
  pass([entity relationshipNamed:@"testRel"] == rel,
	"-[EOEntity relationshipNamed:] works"); 
  pass([[entity relationships] containsObject:rel] == YES,
	"-[EOEntity relationships] contains relationship");
  pass([[entity classProperties] containsObject:rel] == YES,
	"classProperties works.");
  
  [entity removeRelationship:rel];
  
  pass([entity relationshipNamed:@"testRel"] == nil, "-[EOEntity relationshipNamed:]  returns nil for removed relationship");
  pass([[entity relationships] containsObject:rel] == NO, "-[EOEntity relationships doesn't contain removed relationship");
  pass([[entity classProperties] containsObject:rel] == NO, "removeRelationship removes from classProperties.");

  pass([[entity attributes] containsObject:attrib],
	"entity contains removed attribute");
  pass([[entity classProperties] containsObject:attrib],
	"classProperties contains attribute");
  pass([[entity primaryKeyAttributes] containsObject:attrib],
	"primaryKeyAttributes contains attribute");
  pass([entity attributeNamed:@"testAttrib"] == attrib,
	"-attributeNamed: works");
  
  [entity removeAttribute:attrib];
  
  pass([[entity classProperties] containsObject:attrib] == NO,
	"removeAttribute: removes from classProperties");
  pass([[entity primaryKeyAttributes] containsObject:attrib] == NO,
	"removeAttribute: removes from primaryKeyAttributes");
  pass([entity attributeNamed:@"testAttrib"] == nil,
	"no attribute with removed attributes name");
  pass([[entity attributes] containsObject:attrib] == NO,
	"entity does not contain removed attribute");
  RELEASE(pool);
  return 0;
}
