/*
   Copyright (C) 2004 Free SoftwareFoundation, Inc.

   Written by: David Ayers <d.ayers@inode.at>
   Date: October 2004

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

#include <Foundation/NSAutoreleasePool.h>
#include <EOControl/EOControl.h>
#include <EOAccess/EOAccess.h>

#include "../GDL2Testing.h"

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  NSAutoreleasePool *tmpPool;

  volatile BOOL result = NO;
  EOModel  *model;
  EOEntity *entity;
  EOClassDescription *cd;
  EOGlobalID *gid;
  EOSharedEditingContext *sec = nil;
  EOEditingContext *ec1 = nil;
  EOEditingContext *ec2 = nil;
  EOFetchSpecification *fs = nil;
  id obj = nil;
  id del = nil;
  id tmp = nil;

  START_SET(YES);

  model = globalModelForKey(@"TSTTradingModel.eomodeld");
  setupModel(model);

  createDatabaseWithModel(model);

  [[EOModelGroup defaultGroup] addModel: model];
  entity = [model entityNamed: @"ProductGroup"];
  cd = [entity classDescriptionForInstances];
  ec1 = [EOEditingContext new];

  obj = [cd createInstanceWithEditingContext: ec1
	    globalID: nil
	    zone: NULL];
  [ec1 insertObject: obj];
  [obj takeValue: @"Software" forKey: @"name"];
  [obj takeValue: [NSCalendarDate date] forKey: @"date"];
  [ec1 saveChanges];
  [ec1 forgetObject: obj];

  fs = [EOFetchSpecification fetchSpecificationWithEntityName: @"ProductGroup"
			     qualifier: nil sortOrderings: nil];

  sec = [EOSharedEditingContext defaultSharedEditingContext];

  START_TEST(YES);
  tmp = [sec objectsWithFetchSpecification: fs editingContext: sec];
  result = [tmp count]>0;
  END_TEST(result, "-[EOSharedEditingContext objectsWithFetchSpecification:editingContext:]");

  obj = [tmp lastObject];
  TEST_EXCEPTION([obj takeValue: @"Software" forKey: @"name"];,
		 NSInternalInconsistencyException, YES,
		 "object in EOSharedEditingContext may not be altered");

  TEST_EXCEPTION([sec deleteObject: obj];,
		 NSInternalInconsistencyException, YES,
		 "object in EOSharedEditingContext may not be deleted");

  START_TEST(YES);
  tmp = [ec1 objectsWithFetchSpecification: fs editingContext: ec1];
  result = [tmp count]>0;
  result = result && [tmp lastObject] == obj;
  END_TEST(result, "-[EOEditingContext objectsWithFetchSpecification:editingContext:] returns shared object");

  ec2 = [EOEditingContext new];
  START_TEST(YES);
  tmp = [ec2 objectsWithFetchSpecification: fs editingContext: ec2];
  result = [tmp count]>0;
  result = result && [tmp lastObject] == obj;
  END_TEST(result, "-[EOEditingContext objectsWithFetchSpecification:editingContext:] returns shared object 2nd EC");


  dropDatabaseWithModel(model);
  END_SET("EOSharedEditingContext/"__FILE__);

  [pool release];
  return (0);
}
