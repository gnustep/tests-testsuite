/*
   Copyright (C) 2005 Free SoftwareFoundation, Inc.

   Written by: David Ayers <d.ayers@inode.at>
   Date: August 2005

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
#include <EOAccess/EOAccess.h>

#include "../GDL2Testing.h"

/* This file tests delete propagation.  */
static void
insertObjects(EOModel *model, EOEditingContext *ec, id *objPrd, id *objPrdGrp)
{
  EOEntity *entity;
  EOClassDescription *cdPrd;
  EOClassDescription *cdPrdGrp;

  entity = [model entityNamed: @"ProductGroup"];
  cdPrdGrp = [entity classDescriptionForInstances];
  *objPrdGrp = [cdPrdGrp createInstanceWithEditingContext: ec 
			 globalID: nil zone: 0];
  [ec insertObject: *objPrdGrp];
  [*objPrdGrp takeValue: @"HOWTOs" forKey: @"name"];
  [*objPrdGrp takeValue: [NSCalendarDate distantPast] forKey: @"date"];

  entity = [model entityNamed: @"Product"];
  cdPrd = [entity classDescriptionForInstances];
  *objPrd = [cdPrd createInstanceWithEditingContext: ec 
		   globalID: nil zone: 0];
  [ec insertObject: *objPrd];
  [*objPrd takeValue: @"The GNUstep Build Guide" forKey: @"name"];
  [*objPrd addObject: *objPrdGrp 
	   toBothSidesOfRelationshipWithKey: @"productGroup"];

}


int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  volatile BOOL result = NO;
  EOModel  *model;
  EOEntity *entity;
  EOClassDescription *cd;
  EOGlobalID *gid;
  EOEditingContext *ec = nil;
  EOFetchSpecification *fs = nil;
  id objPrd = nil;
  id objPrdGrp = nil;
  id obj = nil;
  id del = nil;
  id tmp = nil;

  START_SET(YES);

  model = globalModelForKey(@"TSTTradingModel.eomodeld");

  createDatabaseWithModel(model);
  [[EOModelGroup defaultGroup] addModel: model];

  ec = [EOEditingContext new];
  insertObjects(model, ec, &objPrd, &objPrdGrp);
  [ec saveChanges];

  START_TEST(YES);
  [ec deleteObject: objPrdGrp];
  [ec processRecentChanges];
  NSLog(@"DAVE:%@", [ec deletedObjects]);
  result = ([[ec deletedObjects] count] == 2);
  END_TEST(result,"EODeleteRuleCascade");

  dropDatabaseWithModel(model);
  END_SET("EOEditingContext/" __FILE__);

  [pool release];
  return (0);
}
