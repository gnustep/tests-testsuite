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
  RETAIN(validNames);
  /* nil is also an invalid name but can't go into the array
     it is tested too. */
  invalidNames = [NSArray arrayWithObjects: @"",
  					    @"foo&",
					    @"$foo",
					    nil];
  RETAIN(invalidNames);
  objectsToTest = [NSArray arrayWithObjects: entity, attribute,
  					     relationship, nil];
  RETAIN(objectsToTest);

  
  for (j = 0; j < [objectsToTest count]; j++)
    {
      id objectToTest = [objectsToTest objectAtIndex:j];
      char *className = [[[objectToTest class] description] cString];
      START_SET(YES);
      for (i = 0; i < [validNames count]; i++)
        {
          NSString *aName = [validNames objectAtIndex:i];
          START_TEST(YES);
          result = ([objectToTest validateName:aName] == nil);
          END_TEST(result, "%s -validateName: with valid name '%s'", className,
								     [aName cString]);
        }
      END_SET("-validateName: with valid names");
      
      START_SET(YES);
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
     
      START_SET(YES);
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

      START_SET(YES);
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
    
  START_SET(YES)
  {
    NSString *aName = [validNames objectAtIndex:0];
    START_TEST(YES);
    [entity setName:aName];
    [entity setClassName:@"EOGenericRecord"];
    [model addEntity:entity];
    result = ([[entity validateName:aName] isKindOfClass:[NSException class]] == YES);

    END_TEST(result, "EOEntity -validateName: returns exception when entity with same name exists in model");
  }
  {
    NSString *aName = [validNames objectAtIndex:0];
    START_TEST(YES);
    [attribute setName: aName];
    [entity addAttribute: attribute];
    result = ([[attribute validateName:aName] isKindOfClass:[NSException class]] == YES);

    END_TEST(result, "EOAttribute -validateName returns exception when entity with same name exists in model");
  }
  {
    NSString *aName = [validNames objectAtIndex:1];
    START_TEST(YES);
    [relationship setName:aName];
    [entity addRelationship:relationship];
    result = ([[relationship validateName:aName] isKindOfClass:[NSException class]] == YES);

    END_TEST(result, "EORelationship -validateName: returns exception when entity with same name exists in model");
  }

  END_SET("-validateName returns exception with invalid name (already exists in model)");
  
  RELEASE(validNames);
  RELEASE(invalidNames);
  
  DESTROY(pool); 
  return 0;
}

