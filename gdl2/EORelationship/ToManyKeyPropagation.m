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
  EOClassDescription *prdCD = nil;
  EOClassDescription *prdGrpCD = nil;
  id prdObj, prdGrpObj;
  EOEditingContext *ec = nil;
  NSString *filePath;

  START_SET(YES);

  filePath = @"ToManyKeyPropagation.eomodel";
  model = [[EOModel alloc] initWithContentsOfFile: filePath];
  createDatabaseWithModel(model);
  
  [[EOModelGroup defaultGroup] addModel: model];
  ec = [EOEditingContext new];
  prdEnt    = [model entityNamed: @"Product"];
  prdGrpEnt = [model entityNamed: @"ProductGroup"];
  prdCD    = [prdEnt classDescriptionForInstances];
  prdGrpCD = [prdGrpEnt classDescriptionForInstances];

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

  dropDatabaseWithModel(model);
  END_SET("EORelationship/" __FILE__);

  [pool release];
  return (0);
}
