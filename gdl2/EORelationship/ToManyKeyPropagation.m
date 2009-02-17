/*
   Copyright (C) 2004 Free SoftwareFoundation, Inc.

   Written by: David Ayers <d.ayers@inode.at>
   Date: March 2005

   This file is part of the GNUstep Database Library.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.
   
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#include <Foundation/Foundation.h>
#include <EOControl/EOControl.h>

#include "../GDL2Testing.h"

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  volatile BOOL result = NO;
  id tmp = nil;
  EOModel *model = nil;
  EOEntity *prdEnt = nil;
  EOEntity *prdGrpEnt = nil;
  EOEntity *cstEnt = nil;
  EOEntity *cstGrpEnt = nil;
  EOClassDescription *prdCD = nil;
  EOClassDescription *prdGrpCD = nil;
  EOClassDescription *cstCD = nil;
  EOClassDescription *cstGrpCD = nil;
  id prdObj, prdGrpObj, cstObj, cstGrpObj[10];
  EOEditingContext *ec = nil;
  EOEditingContext *ec2 = nil;
  EODatabaseDataSource *ds = nil;
  NSArray *fromDB = nil;
  NSString *filePath;
  NSString *cstGrpName[] = { @"Institutions",@"Foundations",@"Non-Profit",@"NGO",@"European",
			     @"Software", @"IT", @"Licensing",@"Activist",@"Grass-Roots" };
  unsigned i,n;

  START_SET(YES);

  filePath = @"ToManyKeyPropagation.eomodel";
  model = [[EOModel alloc] initWithContentsOfFile: filePath];
  setupModel(model);
  createDatabaseWithModel(model);
  
  [[EOModelGroup defaultGroup] addModel: model];
  ec = [EOEditingContext new];
  prdEnt    = [model entityNamed: @"Product"];
  prdGrpEnt = [model entityNamed: @"ProductGroup"];
  cstEnt    = [model entityNamed: @"Customer"];
  cstGrpEnt = [model entityNamed: @"CustomerGroup"];

  prdCD    = [prdEnt classDescriptionForInstances];
  prdGrpCD = [prdGrpEnt classDescriptionForInstances];
  cstCD    = [cstEnt classDescriptionForInstances];
  cstGrpCD = [cstGrpEnt classDescriptionForInstances];

  prdGrpObj = [prdGrpCD createInstanceWithEditingContext: ec
			globalID: nil zone: 0];
  [ec insertObject: prdGrpObj];
  [prdGrpObj takeValue: @"Books" forKey: @"name"];

  prdObj = [prdCD createInstanceWithEditingContext: ec
		  globalID: nil zone: 0];
  [ec insertObject: prdObj];
  [prdObj takeValue: @"Using GCC" forKey: @"name"];
  [prdGrpObj addObject: prdObj toBothSidesOfRelationshipWithKey: @"products"];

  START_TEST(YES);
  [ec saveChanges];
  END_TEST(YES, "ToManyKeyPropagation");
 
  ec2 = [EOEditingContext new];
  ds = [[EODatabaseDataSource alloc] initWithEditingContext:ec2
	  					entityName:@"ProductGroup"];
  fromDB = [ds fetchObjects];
  START_TEST(YES);
  result = [[[fromDB objectAtIndex:0] valueForKey:@"products"] count] != 0; 
  END_TEST(result, "fetching relationship from db");


  for (i=0;i<10;i++)
    {
      cstGrpObj[i] = [cstGrpCD createInstanceWithEditingContext: ec
			       globalID: nil zone: 0];
      [ec insertObject: cstGrpObj[i]];
      [cstGrpObj[i] takeValue: cstGrpName[i] forKey: @"name"];
    }
  [ec saveChanges];

  cstObj = [cstCD createInstanceWithEditingContext: ec
		  globalID: nil zone: 0];
  [ec insertObject: cstObj];
  [cstObj takeValue: @"FSFE" forKey: @"name"];
  [ec saveChanges];
  [ec refaultObjects];

  for (i=0;i<10;i++)
    {
      [cstObj addObject: cstGrpObj[i] toBothSidesOfRelationshipWithKey: @"customerGroup"];
    }
  [ec saveChanges];
  [ec refaultObjects];

  /* Testing whether the last set value is actually retained.  */
  START_TEST(YES);
  result = [[cstObj valueForKey:@"customerGroup"] isEqual: cstGrpObj[9]];
  END_TEST(result, "ToManyKeyPropagation on modified value 'Foundations'");

  /* Testing whether setting the customer relationship will actually also update the groups relationship.  */
  START_TEST(YES);
  
  tmp = [EOFetchSpecification fetchSpecificationWithEntityName:@"CustomerGroup"
			      qualifier: [EOQualifier qualifierWithQualifierFormat:@"name = 'Institutions'"]
			      sortOrderings: nil];
  cstGrpObj[0] = [[ec objectsWithFetchSpecification: tmp] lastObject];
  [cstObj addObject: cstGrpObj[0] toBothSidesOfRelationshipWithKey: @"customerGroup"];
  [ec saveChanges];
  result = [[cstObj valueForKey:@"customerGroup"] isEqual: cstGrpObj[0]];
  result = result && [[[cstGrpObj[0] valueForKey:@"customers"] lastObject] isEqual: cstObj];
  END_TEST(result, "ToManyKeyPropagation on modified value 'Institutions'");

  /* After testing the EO's in the EC, have the refetched to insure that the DB-representation matches.  */
  START_TEST(YES);
  tmp = [ec registeredObjects];
  for(i=0,n=[tmp count];i<n;i++)
    {
      id obj = [tmp objectAtIndex: i];
      [ec forgetObject: obj];
    }

  tmp = [EOFetchSpecification fetchSpecificationWithEntityName:@"Customer"
			      qualifier: nil
			      sortOrderings: nil];

  cstObj = [[ec objectsWithFetchSpecification: tmp] lastObject];
  cstGrpObj[0] = [cstObj valueForKey:@"customerGroup"];

  result = [[cstGrpObj[0] valueForKey:@"name"] isEqual: @"Institutions"];
  END_TEST(result, "refetch objects");

  dropDatabaseWithModel(model);
  END_SET("EORelationship/" __FILE__);

  [pool release];
  return (0);
}
