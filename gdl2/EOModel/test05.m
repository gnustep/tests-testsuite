#include <Foundation/NSAutoreleasePool.h>
#include "../GDL2Testing.h"

int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  EOModel *model;
  EOEntity *entity;
  
  model = [EOModel new];
  entity = [EOEntity new];
  
  [model setName:@"testModel"];
  [entity setName:@"testEntity"];
  [entity setClassName:@"EOGenericRecord"];
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

  RELEASE(pool);
  return 0;
}
