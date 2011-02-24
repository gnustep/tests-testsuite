/*
   Copyright (C) 2005 Free SoftwareFoundation, Inc.

   Written by: Manuel Guesdon <mguesdon@orange-concept.com>
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

/* This file tests insert+delete+change (i.e.: insert an object
and delete it before saving changes  */

static void
insertObjects(EOModel *model, EOEditingContext *ec, id *objPrd)
{
  EOEntity *entity;
  EOClassDescription *cdPrd;

  entity = [model entityNamed: @"Product"];
  cdPrd = [entity classDescriptionForInstances];
  *objPrd = [cdPrd createInstanceWithEditingContext: ec 
		   globalID: nil zone: 0];
  [ec insertObject: *objPrd];
  [*objPrd takeValue: @"Should not be there" forKey: @"name"];
}


int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  volatile BOOL result = NO;
  EOModel  *model;
  EOEditingContext *ec = nil;
  id objPrd = nil;

  START_SET("EOEditingContext/" __FILE__);

  model = globalModelForKey(@"TSTTradingModel.eomodeld");
  setupModel(model);

  createDatabaseWithModel(model);
  [[EOModelGroup defaultGroup] addModel: model];

  ec = [EOEditingContext new];

  START_TEST(YES);
  insertObjects(model, ec, &objPrd);
  [ec processRecentChanges];
  [ec deleteObject: objPrd];
  [objPrd takeValue: @"No more here !" forKey: @"name"];
  [ec processRecentChanges];

  // We should'nt have inserted/deleted/modified object !
  result = [[ec updatedObjects] count] == 0
    && [[ec insertedObjects] count] == 0
    && [[ec deletedObjects] count] == 0;

  END_TEST(result,"Insert, Delete and Save");

  dropDatabaseWithModel(model);
  END_SET("EOEditingContext/" __FILE__);

  [pool release];
  return (0);
}
