#include <Foundation/Foundation.h>
#include <EOAccess/EOEntity.h>
#include <EOAccess/EOModel.h>

#include "../GDL2Testing.h"

int main()
{  
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  BOOL result;
  EOModel *model;
  EOModel *model2;
  EOEntity *ent1;
  EOEntity *ent2;
  EOEntity *tmp1;
  EOEntity *tmp2;
  NSString *filePath;
  
  model = [[EOModel alloc] init];
  [model setName:@"foo"];

  ent1 = [[EOEntity alloc] init];
  [ent1 setName:@"ent1"];
  [ent1 setClassName:@"EOGenericRecord"];
 
  ent2 = [[EOEntity alloc] init];
  [ent2 setName:@"ent2"];
  [ent2 setClassName:@"EOGenericRecord"];

  START_SET(YES)
  [ent1 addSubEntity:ent2];
  START_TEST(YES)
  result = [ent2 parentEntity] == ent1;
  END_TEST(result, "-parentEntity 1");
  START_TEST(YES)
  result = [[ent1 subEntities] containsObject:ent2];
  END_TEST(result, "-subEntities 1");
  [model addEntity: ent1];
  [model addEntity: ent2];

  filePath = NSTemporaryDirectory();
  filePath = [filePath stringByAppendingPathComponent: [model name]];
  [model writeToFile:filePath];
  model2 = [[EOModel alloc] initWithContentsOfFile:filePath];
  tmp1 = [model2 entityNamed:@"ent1"];
  tmp2 = [model2 entityNamed:@"ent2"];

  START_TEST(YES)
  result = [tmp2 parentEntity] == tmp1;
  END_TEST(result, "-parentEntity 2");
  START_TEST(YES)
  result = [[tmp1 subEntities] containsObject:tmp2];
  END_TEST(result, "-subEntities 2");

  RELEASE(model2);
  RELEASE(tmp1);
  RELEASE(tmp2);
  /* same as the 2 tests above but with the child loaded before the parent. */
  model2 = [[EOModel alloc] initWithContentsOfFile:filePath];
  tmp2 = [model2 entityNamed:@"ent2"];
  tmp1 = [model2 entityNamed:@"ent1"];

  START_TEST(YES)
  result = [tmp2 parentEntity] == tmp1;
  END_TEST(result, "-parentEntity 3");
  START_TEST(YES)
  result = [[tmp1 subEntities] containsObject:tmp2];
  END_TEST(result, "-subEntities 3");

  // similar to the 2 tests above but with the parent never specificially loaded
  model2 = [[EOModel alloc] initWithContentsOfFile:filePath];
  tmp2 = [model2 entityNamed:@"ent2"];

  START_TEST(YES)
  result = [[[tmp2 parentEntity] name] isEqual:@"ent1"];
  END_TEST(result, "-parentEntity 4");
  START_TEST(YES)
  result = [[[tmp2 parentEntity] subEntities] containsObject:tmp2];
  END_TEST(result, "-subEntities 4");
 
  [[NSFileManager defaultManager] removeFileAtPath:[model path] handler:nil];
  END_SET("EOModel parent tests");

  return 0; 
}
