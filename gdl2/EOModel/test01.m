#include <Foundation/NSAutoreleasePool.h>
#include "../GDL2Testing.h"

int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  EOModel *model = [EOModel new];
  EOEntity *entity = [EOEntity new];
  EOAttribute *attribute = [EOAttribute new];
  EORelationship *relationship = [EORelationship new];
  volatile BOOL result;
  NSArray *validNames;
  NSArray *invalidNames;
  NSArray *objectsToTest;
  int i, j = 0;
  validNames = [NSArray arrayWithObjects: @"foo",
  					  @"foo$",
					  @"f00",
					  @"#f00",
					  @"@foo",
					  @"_foo",
					  nil];
  [validNames retain];
  /* nil is also an invalid name but can't go into the array
     it is tested too. */
  invalidNames = [NSArray arrayWithObjects: @"",
  					    @"foo&",
					    @"$foo",
					    nil];
  [invalidNames retain];
  objectsToTest = [NSArray arrayWithObjects: entity, attribute,
  					     relationship, nil];
  [objectsToTest retain];

  
  for (j = 0; j < [objectsToTest count]; j++)
    {
      id objectToTest = [objectsToTest objectAtIndex:j];
      const char *className = [[[objectToTest class] description] cString];
      START_SET("-validateName: with valid names");
      for (i = 0; i < [validNames count]; i++)
        {
          NSString *aName = [validNames objectAtIndex:i];
          START_TEST(YES);
          result = ([objectToTest validateName:aName] == nil);
          END_TEST(result, "%s -validateName: with valid name '%s'", className,
								     [aName cString]);
        }
      END_SET("-validateName: with valid names");
      
      START_SET("-validateName with invalid names");
      for (i = 0; i < [invalidNames count]; i++)
        {
          NSString *aName = [invalidNames objectAtIndex:i];
	  START_TEST(YES);
	  result = [[objectToTest validateName:aName] isKindOfClass:[NSException class]];
	  END_TEST(result, "%s -validateName: with invalid name '%s'", className,
								       [aName cString]);
	}
      START_TEST(YES);
      result = [[entity validateName: nil] isKindOfClass:[NSException class]];
      END_TEST(result, "%s -validateName: with invalid name '(nil)", className);
      END_SET("-validateName with invalid names");
     
      START_SET("%s -setName: with valid names", className);
      for (i = 0; i < [validNames count]; i++)
	{
	  NSString *aName = [validNames objectAtIndex:i];
	  START_TEST(YES);
	  
	  NS_DURING
	    [objectToTest setName:aName];
	    result = [[objectToTest name] isEqual:aName];
	  NS_HANDLER
	    result = NO;
	  NS_ENDHANDLER
	  
	  END_TEST(result, "%s -setName: with valid name '%s'", className,
								[aName cString]);
    	}
      END_SET("%s -setName: with valid names", className);

      START_SET("%s -setName: with invalid names", className);
      for (i = 0; i < [invalidNames count]; i++)
	{
	  NSString *aName = [invalidNames objectAtIndex:i];
	  START_TEST(YES);

	  NS_DURING
	    [entity setName:aName];
	    result = NO;
	  NS_HANDLER
	      result = YES;
	  NS_ENDHANDLER
	  
	  END_TEST(result, "%s -setName: with invalid name '%s'", className, [aName cString]);
	}
      END_SET("%s -setName: with invalid names", className);
      
    }
    
  START_SET("-validateName return values");
  {
    NSString *aName = [validNames objectAtIndex:0];
    START_TEST(YES);
    [entity setName:aName];
    [entity setClassName:@"EOGenericRecord"];
    [model addEntity:entity];
    result = ([entity validateName:aName] == nil);

    END_TEST(result, "EOEntity -validateName: returns nil when entity name is unchanged");
  }
  
  {
    NSString *aName = [validNames objectAtIndex:0];
    EOEntity *entity2 = [[EOEntity alloc] init];

    START_TEST(YES);
    [entity2 setName:[validNames objectAtIndex:1]];
    [entity2 setClassName:@"EOGenericRecord"];
    [model addEntity:entity2];
    result = ([[entity2 validateName:aName] isKindOfClass:[NSException class]] == YES);
    [model removeEntity:entity2];
    [entity2 release];
    END_TEST(result, "EOEntity -validateName: returns exception when entity with same name exists in model");
  }

  {
    NSString *aName = [validNames objectAtIndex:0];
    START_TEST(YES);
    [attribute setName: aName];
    [entity addAttribute: attribute];
    result = ([attribute validateName:aName] == nil);

    END_TEST(result, "EOAttribute -validateName returns nil when name is unchanged");
  }
  
  {
    NSString *aName = [validNames objectAtIndex:0];
    EOAttribute *attribute2 = [[EOAttribute alloc] init];
    START_TEST(YES);
    [attribute2 setName:[validNames objectAtIndex:1]];
    [entity addAttribute: attribute2];
    result = ([[attribute2 validateName:aName] isKindOfClass:[NSException class]] == YES);
    [entity removeAttribute:attribute2];
    [attribute2 release];
    END_TEST(result, "EOAttribute -validateName returns exception when entity with same name exists in model");
  }
 
  {
    NSString *aName = [validNames objectAtIndex:1];
    START_TEST(YES);
    [relationship setName:aName];
    [entity addRelationship:relationship];
    result = ([relationship validateName:aName] == nil);

    END_TEST(result, "EORelationship -validateName: returns nil when relationship name is unchanged");
  }
  
  {
    NSString *aName = [validNames objectAtIndex:1];
    EORelationship *relationship2 = [[EORelationship alloc] init];
    START_TEST(YES);
    [relationship2 setName:[validNames objectAtIndex:2]];
    [entity addRelationship:relationship2];
    result = ([[relationship2 validateName:aName] isKindOfClass:[NSException class]] == YES);
    [entity removeRelationship:relationship2];
    [relationship2 release];
    END_TEST(result, "EORelationship -validateName: returns exception when relationship with same name exists in model");
  }

  END_SET("-validateName return values");
  
  [validNames release];
  [invalidNames release];
  
  DESTROY(pool); 
  return 0;
}

