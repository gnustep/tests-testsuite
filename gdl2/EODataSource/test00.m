/*
   Copyright (C) 2004 Free Software Foundation, Inc.

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
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA.
  
 */

#include <Foundation/Foundation.h>
#include <EOControl/EOControl.h>
#include <EOAccess/EOAccess.h>

#include "../GDL2Testing.h"

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  EOModel *model;
  EOEntity *orderEnt;
  EOEntity *orderPosEnt;
  EOEntity *productEnt;
  EOEntity *productGrpEnt;
  EOEditingContext *ec;
  EODatabaseDataSource *masterDS = nil;
  EODetailDataSource *detailDS = nil;

  id tmp = nil, tmp1 = nil, tmp2 = nil, tmp3 = nil;
  volatile BOOL result = NO;

  START_SET("EODataSource/test00.m");

  /* Setup the database */
  model = globalModelForKey(TSTTradingModelName);
  setupModel(model);
  createDatabaseWithModel(model);
  [[EOModelGroup defaultGroup] addModel: model];
  ec = [[EOEditingContext new] autorelease];

  START_TEST(YES);
  masterDS = [[EODatabaseDataSource alloc] initWithEditingContext: ec
					   entityName: @"Order"
					   fetchSpecificationName: nil];
  result = [masterDS isKindOfClass: [EODataSource class]];
  END_TEST(result, 
	   "-[EODatabaseDataSource"
	   " initWithEditingContext:entityName:fetchSpecificationName:]");

  START_TEST(YES);
  tmp = [masterDS fetchObjects];
  result = [tmp isKindOfClass: [NSArray class]];
  END_TEST(result, 
	   "-[EODatabaseDataSource fetchObjects] empty");
  
  START_TEST(YES);
  detailDS = (id)[masterDS dataSourceQualifiedByKey: @"orderPos"];
  result = [detailDS isKindOfClass: [EODetailDataSource class]];
  END_TEST(result, 
	   "-[EODatabaseDataSource dataSourceQualifiedByKey:]");
  
  START_TEST(YES);
  result = ([detailDS editingContext] == [masterDS editingContext]);
  END_TEST(result,
	   "-[EODetailDataSource editingContext]");

  START_TEST(YES);
  tmp = [detailDS fetchObjects];
  result = [tmp isKindOfClass: [NSArray class]];
  END_TEST(result, 
	   "-[EODetailDataSource fetchObjects] empty");

  orderEnt = [model entityNamed: @"Order"];
  tmp = [orderEnt classDescriptionForInstances];
  tmp1 = [tmp createInstanceWithEditingContext: ec globalID: nil zone: 0];
  [ec insertObject: tmp1];
  [tmp1 takeValue: [NSCalendarDate dateWithString:@"2002-02-02"
				   calendarFormat:@"%Y-%m-%d"] forKey: @"date"];
  START_TEST(YES);
  [masterDS insertObject: tmp1];
  START_SET("-[EODatabaseDataSource insertObject:] result evaluation 1");
  [ec saveChanges];
  tmp2 = [masterDS fetchObjects];
  result = [tmp2 containsObject: tmp1];
  END_SET("-[EODatabaseDataSource insertObject:] result evaluation 1");
  END_TEST(result,
	   "-[EODatabaseDataSource insertObject:] 1");

  START_TEST(YES);
  [detailDS qualifyWithRelationshipKey:@"orderPos" ofObject: tmp1];
  START_SET("-[EODetailDataSource qualifyWithRelationshipKey:ofObject:]");
  result = ([detailDS masterObject] == tmp1);
  END_SET("-[EODetailDataSource qualifyWithRelationshipKey:ofObject:]"
	  "result evaluation");
  END_TEST(result,
	   "-[EODetailDataSource qualifyWithRelationshipKey:ofObject:]");

  productGrpEnt = [model entityNamed: @"ProductGroup"];
  tmp = [productGrpEnt classDescriptionForInstances];
  tmp1 = [tmp createInstanceWithEditingContext: ec globalID: nil zone: 0];
  [ec insertObject: tmp1];
  [tmp1 takeValue: @"HOWTOs" forKey: @"name"];
  [tmp1 takeValue: [NSCalendarDate dateWithString:@"2002-02-02"
				   calendarFormat:@"%Y-%m-%d"] forKey: @"date"];

  productEnt = [model entityNamed: @"Product"];
  tmp = [productEnt classDescriptionForInstances];
  tmp3 = [tmp createInstanceWithEditingContext: ec globalID: nil zone: 0];
  [ec insertObject: tmp3];
  [tmp3 takeValue: @"The GNUstep Build Guide" forKey: @"name"];
  [tmp3 takeValue: tmp1 forKey: @"productGroup"];
  [ec saveChanges];

  orderPosEnt = [model entityNamed: @"OrderPos"];
  tmp = [orderPosEnt classDescriptionForInstances];
  tmp1 = [tmp createInstanceWithEditingContext: ec globalID: nil zone: 0];
  [ec insertObject: tmp1];
  [tmp1 takeValue: [NSNumber numberWithInt: 1] forKey: @"posnr"];
  [tmp1 takeValue: tmp3 forKey: @"product"];
  [tmp1 takeValue: [NSNumber numberWithInt: 1] forKey: @"amount"];
  [tmp1 takeValue: [NSNumber numberWithInt: 1] forKey: @"value"];
  [tmp1 takeValue: [NSNumber numberWithInt: 1] forKey: @"price"];
  START_TEST(YES);
  [detailDS insertObject: tmp1];
  START_SET("-[EODetailDataSource insertObject:] result evaluation 2");
  [ec saveChanges];
  tmp2 = [detailDS fetchObjects];
  result = [tmp2 containsObject: tmp1];
  END_SET("-[EODetailDataSource insertObject:] result evaluation 2");
  END_TEST(result,
	   "-[EODetailDataSource insertObject:] 2");

  START_TEST(YES);
  tmp1 = [detailDS createObject];
  START_SET("-[EODetailDataSource insertObject:] result evaluation 3");
  [tmp1 takeValue: [NSNumber numberWithInt: 2] forKey: @"amount"];
  [tmp1 takeValue: [NSNumber numberWithInt: 2] forKey: @"value"];
  [tmp1 takeValue: [NSNumber numberWithInt: 2] forKey: @"price"];
  [tmp1 takeValue: [NSNumber numberWithInt: 2] forKey: @"posnr"];
  [tmp1 takeValue: tmp3 forKey: @"product"];
  [detailDS insertObject:tmp1];
  [ec saveChanges];
  tmp2 = [detailDS fetchObjects];
  result = [tmp2 containsObject:tmp1];
  END_SET("-[EODetailDataSource insertObject:] result evaluation 3");
  END_TEST(result,
	   "-[EODetailDataSource insertObject:] 3");

  dropDatabaseWithModel(model);

  END_SET("EODataSource/test00.m");

  [pool release];
  return (0);
}


