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
#include <EOInterface/EOInterface.h>

#include "../GDL2Testing.h"

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  volatile BOOL result = NO;
  id tmp = nil;
  EODisplayGroup *displayGroup;
  EOEditingContext *context;
  
  EOModel *model;
  EODataSource *dataSource;

  START_SET(YES);

  START_TEST(YES);
  tmp = [EODisplayGroup globalDefaultStringMatchOperator];
  result = [tmp isEqual: @"caseInsensitiveLike"];
  END_TEST(result, "+[EODisplayGroup globalDefaultStringMatchOperator]");

  START_TEST(YES);
  [EODisplayGroup setGlobalDefaultStringMatchOperator: @"like"];
  tmp = [EODisplayGroup globalDefaultStringMatchOperator];
  result = [tmp isEqual: @"like"];
  END_TEST(result, "+[EODisplayGroup setGlobalDefaultStringMatchOperator:]");
  [EODisplayGroup setGlobalDefaultStringMatchOperator: @"caseInsensitiveLike"];

  START_TEST(YES);
  result = [EODisplayGroup globalDefaultForValidatesChangesImmediately] == NO;
  END_TEST(result,
	   "+[EODisplayGroup globalDefaultForValidatesChangesImmediately]");

  START_TEST(YES);
  [EODisplayGroup setGlobalDefaultForValidatesChangesImmediately: YES];
  result = [EODisplayGroup globalDefaultForValidatesChangesImmediately];
  END_TEST(result,
	   "+[EODisplayGroup "
	   "setGlobalDefaultForValidatesChangesImmediately:]");
  [EODisplayGroup setGlobalDefaultForValidatesChangesImmediately: NO];

  START_TEST(YES);
  displayGroup = [[EODisplayGroup alloc] init];
  result = [displayGroup selectsFirstObjectAfterFetch];
  tmp = [EODisplayGroup globalDefaultStringMatchOperator];
  result = result && [[displayGroup defaultStringMatchOperator] isEqual: tmp];
  result = result && [[displayGroup defaultStringMatchFormat] isEqual: @"%@*"];
  END_TEST(result, "-[EODisplayGroup init]");

  context = [EOEditingContext new];
  model = globalModelForKey(TSTTradingModelName);
  [[EOModelGroup defaultGroup] addModel: model];
  dataSource = [[EODatabaseDataSource alloc] initWithEditingContext: context
					     entityName: @"ProductGroup"
					     fetchSpecificationName: nil];

  START_TEST(YES);
  [displayGroup setDataSource: dataSource];
  result = [displayGroup dataSource] == dataSource;
  END_TEST(result, "-[EODisplayGroup setDataSource]");

  START_TEST(YES);
  [displayGroup insert: nil];
  result = [[displayGroup allObjects] count] == 1;
  result = result && [[displayGroup displayedObjects] count] == 1;
  NSLog(@"%@",[displayGroup allObjects]);
  END_TEST(result, "-[EODisplayGroup insert:]");

  START_TEST(YES);
  END_TEST(result, "-[EODisplayGroup ]");

  END_SET("EODisplayGroup/EODisplayGroup00.m");

  [pool release];
  return (0);
}
