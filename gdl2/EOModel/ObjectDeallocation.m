#include <Foundation/NSAutoreleasePool.h>
#include <EOAccess/EOAccess.h>
#include "../GDL2Testing.h"
@implementation EOModel (retain)
- (id) retain
{
  return [super retain];
}
@end
int main()
{ 
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  EOModel *model = [[EOModel alloc] init];
  EOEntity *e1 = [[EOEntity alloc] init];
  EOEntity *e2 = [[EOEntity alloc] init];
  EOEntity *e3 = [[EOEntity alloc] init];
  EOEntity *e4 = [[EOEntity alloc] init];
  EOEntity *e5 = [[EOEntity alloc] init];
  EOAttribute *a1 = [[EOAttribute alloc] init];
  EOAttribute *a2 = [[EOAttribute alloc] init];
  EOAttribute *a3 = [[EOAttribute alloc] init];
  EOAttribute *a4 = [[EOAttribute alloc] init];
  EORelationship *r1 = [[EORelationship alloc] init];
  EORelationship *r2 = [[EORelationship alloc] init];
  EOJoin *j1 = [[EOJoin alloc] initWithSourceAttribute:a1 destinationAttribute:a2];
  EOJoin *j2 = [[EOJoin alloc] initWithSourceAttribute:a3 destinationAttribute:a4];
  int rc;
  BOOL result;

  [model setName:@"model"];
  [e1 setClassName:@"EOGenericRecord"];
  [e2 setClassName:@"EOGenericRecord"];
  [e3 setClassName:@"EOGenericRecord"];
  [e1 setName:@"e1"];
  [e2 setName:@"e2"];
  [e3 setName:@"e3"];
  [e4 setName:@"e4"];
  [e5 setName:@"e5"];
  
  [r1 setName:@"r1"];
  [r2 setName:@"r2"];
  
  [a1 setName:@"a1"];
  [a2 setName:@"a2"];
  [a3 setName:@"a3"];
  [a4 setName:@"a4"];
  
  [e1 addAttribute:a1];
  [e1 addAttribute:a2];
  [e2 addAttribute:a3];
  [e3 addAttribute:a4];
  [model addEntity:e1];
  [model addEntity:e2];
  [model addEntity:e3];
  [r1 addJoin:j1];
  [r2 addJoin:j2];
  [e1 addRelationship:r1];
  [e2 addRelationship:r2];
  [e4 addSubEntity:e5];

  RELEASE(pool);
  pool = [[NSAutoreleasePool alloc] init];

  START_SET(YES);
  
  START_TEST(YES);
  rc = [model retainCount]; 
  END_TEST(rc == 1, "model will deallocate %i", [model retainCount]);
  RELEASE(model);
  
  START_TEST(YES);
  result = [e1 model] == nil;
  END_TEST(result, "EOEntity -model has no dangling pointer 1");
  
  START_TEST(YES);
  result = [e2 model] == nil;
  END_TEST(result, "EOEntity -model has no dangling pointer 2");
  
  START_TEST(YES);
  result = [e2 model] == nil;
  END_TEST(result, "EOEntity -model has no dangling pointer 3");
  
  END_SET("entity unretained pointers");
  
  START_SET(YES);
  
  START_TEST(YES);
  rc = [e1 retainCount];
  RELEASE(e1);
  END_TEST(rc == 1, "Entity will deallocate 1");

  START_TEST(YES);
  rc = [e2 retainCount];
  RELEASE(e2);
  END_TEST(rc == 1, "Entity will deallocate 2");
  
  START_TEST(YES);
  result = [a1 entity] == nil && [a2 entity] == nil;
  END_TEST(result, "attribute unretained pointers");
  
  END_SET("attribute unretained pointers");

  START_SET(YES);

  START_TEST(YES);
  result = [r1 entity] == nil;
  END_TEST(result, "relationship unretained pointers 1");
  
  START_TEST(YES);
  result = [r1 destinationEntity] == nil;
  END_TEST(result, "relationship unretained pointers 2");
  
  START_TEST(YES);
  result = [r2 entity] == nil;
  END_TEST(result, "relationship unretained pointers 3");

  START_TEST(YES);
  result = [r2 destinationEntity] == e3;
  END_TEST(result, "relationship unretained pointers 4");

  START_TEST(YES);
  rc = [e3 retainCount];
  RELEASE(e3);
  END_TEST(rc == 1, "Entity will deallocate 3");
  
  START_TEST(YES);
  result = [r2 destinationEntity] == nil;
  END_TEST(result, "relationship unretained pointers 5");
  
  END_SET("relationship unretained pointers");
 
  START_SET(YES);

  START_TEST(YES);
  rc = [e4 retainCount];
  result = rc == 1;
  END_TEST(result, "parent entity will deallocate");

  START_TEST(YES);
  RELEASE(e4);
  result = [e5 parentEntity] == nil;
  END_TEST(result, "sub entities parent entity is now nil");
  
  END_SET("parent/sub entities");
 
  RELEASE(pool);
  return 0;
}

