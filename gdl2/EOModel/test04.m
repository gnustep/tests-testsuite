#include <Foundation/NSAutoreleasePool.h>
#include "../GDL2Testing.h"

int main()
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  EOModel *model = [EOModel new];
  EOModel *model2 = [EOModel new];
  EOEntity *entity2 = [EOEntity new];
  EOEntity *entity = [EOEntity new];
  EOAttribute *attrib = [EOAttribute new];
  EOAttribute *attrib2 = [EOAttribute new];
  EOModelGroup *modelGroup = [EOModelGroup defaultGroup];

  NS_DURING
    {
      [model2 setName:@"hmm"];
      [modelGroup addModel:model2];
      [model setName:@"foo"];
      [modelGroup addModel:model];
      [model setName:@"bar"];
      pass([modelGroup modelNamed:@"bar"] == model, 
           "modelGroup -modelNamed: knows new model name");
      pass([modelGroup modelNamed:@"foo"] == nil, 
           "modelGroup -modelNamed no model with old model name");
      [model setName:@"foo"];
      pass([modelGroup modelNamed:@"hmm"] == model2,
           "modelGroup previously added models intact."); 
      pass(YES, "Model -setName: renaming a model and back again");
    }
  NS_HANDLER
    {
      pass(NO, "Model -setName: renaming a model and back again");
      [localException raise];
    }
  NS_ENDHANDLER
  
  NS_DURING
    {
      [entity2 setName:@"hmm"];
      [entity2 setClassName:@"EOGenericRecord"];
      [model addEntity:entity2];
      [entity setName:@"foo"];
      [entity setClassName:@"EOGenericRecord"];
      [model addEntity:entity];
      [entity setName:@"bar"];
      pass([model entityNamed:@"bar"] == entity,
           "model recognizes new entity name");
      pass([model entityNamed:@"foo"] == nil,
           "model doesn't recognize old entity name");
      [entity setName:@"foo"];
      pass(YES, "Entity -setName: renaming an entity and back again");
      pass([model entityNamed:@"hmm"] != nil, "existing entities still exist..");
    }
  NS_HANDLER
    {
      pass(NO, "Entity -setName: renaming an entity and back again");
      [localException raise];
    }
  NS_ENDHANDLER
  
  NS_DURING
    {
      [attrib2 setName:@"hmm"];
      [entity addAttribute:attrib2];
      [attrib setName:@"foo"];
      [entity addAttribute:attrib];
      [attrib setName:@"bar"];
      pass([entity attributeNamed:@"bar"] == attrib,
      	   "-entity attributeNamed: knows new name");
      pass([entity attributeNamed:@"foo"] == nil,
      	   "-entity attributeNamed: doesn't know old name");
      [attrib setName:@"foo"];
      pass(YES, "Attribute -setName: renaming an attribute and back again");
      pass([entity attributeNamed:@"hmm"] == attrib2,
      	   "existing attributes still exist..");
    }
  NS_HANDLER
    {
      pass(NO, "Attribute -setName: renaming an attribute and back again");
      [localException raise];
    }
  NS_ENDHANDLER
  
  DESTROY(pool);  
  return 0;
}
