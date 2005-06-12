/*
   Copyright (C) 2004 Free Software Foundation, Inc.

   Written by: David Ayers <d.ayers@inode.at>
   Date: February 2005
   
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
#include <EOAccess/EOAccess.h>

#include "../GDL2Testing.h"

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  NSArray   *adaptorNamesArr = nil;

  NSString  *currAdaptorName;
  EOAdaptor *currAdaptor = nil;
  EOAdaptorContext *currAdaptorContext = nil;
  EOAdaptorChannel *currAdaptorChannel = nil;
  Class    currAdaptorExprClass = 0;

  EOModel *model;
  EOEntity *entity;
  EOClassDescription *cd;
  NSString *filePath;

  EOEditingContext *ec;

  id obj = nil, tmp = nil, tmp1 = nil, tmp2 = nil, tmp3 = nil, tmp4 = nil;
  unsigned i,c;
  volatile BOOL result = NO;

  /*  Now we have the testcases for the installed Adaptors.  */

  START_SET(YES);
  adaptorNamesArr = [EOAdaptor availableAdaptorNames];

  for (i = 0, c = [adaptorNamesArr count]; i < c; i++)
    {
      NSAutoreleasePool *pool;
      currAdaptorName = [adaptorNamesArr objectAtIndex: i];
      START_SET(YES);

      pool = [NSAutoreleasePool new];
      currAdaptor = [EOAdaptor adaptorWithName: currAdaptorName];

      currAdaptorExprClass = [currAdaptor expressionClass];
      tmp = [NSDictionary dictionaryWithObject: @"gdl2test"
			  forKey: @"databaseName"];
      [currAdaptor setConnectionDictionary: tmp];
      [currAdaptor assertConnectionDictionaryIsValid];
      currAdaptorContext = [currAdaptor createAdaptorContext];
      currAdaptorChannel = [currAdaptorContext createAdaptorChannel];
      [currAdaptorChannel openChannel];

      model = [[EOModel alloc] initWithContentsOfFile: @"EOAdaptorTypes.eomodel"];
      NSCAssert(model, @"Failed to load model. ");
      [model setAdaptorName: currAdaptorName];
      [[currAdaptor class] assignExternalInfoForEntireModel: model];
      filePath = NSTemporaryDirectory();
      filePath = [filePath stringByAppendingPathComponent: currAdaptorName];
      filePath = [filePath stringByAppendingPathComponent: [model name]];
      [model writeToFile: filePath];
      createDatabaseWithModel(model);

      [[EOModelGroup defaultGroup] addModel: model];
      ec = [EOEditingContext new];
      entity = [model entityNamed: @"MyEntity"];
      cd = [entity classDescriptionForInstances];
      obj = [cd createInstanceWithEditingContext: ec
		globalID: nil
		zone: NULL];
      [ec insertObject: obj];

      tmp4 = [NSCalendarDate date];
      tmp2 = [tmp4 description];
      tmp1 = [NSNumber numberWithInt: [tmp4 secondOfMinute]];
      tmp3 = [[tmp2 dataUsingEncoding: NSUTF8StringEncoding] md5Digest];

      [obj takeValue: tmp1 forKey: @"number"];
      [obj takeValue: tmp2 forKey: @"string"];
      [obj takeValue: tmp3 forKey: @"data"];
      [obj takeValue: tmp4 forKey: @"date"];

      START_TEST(YES);
      [ec saveChanges];
      END_TEST(YES, "-[EOEditingContext saveChanges] 1");

      [[ec rootObjectStore] invalidateAllObjects];

      START_TEST(YES);
      result = [[obj valueForKey: @"number"] isEqual: tmp1];
      END_TEST(result, "fetched number");

      START_TEST(YES);
      result = [[obj valueForKey: @"string"] isEqual: tmp2];
      END_TEST(result, "fetched string");

      START_TEST(YES);
      result = [[obj valueForKey: @"data"] isEqual: tmp3];
      END_TEST(result, "fetched data");

      START_TEST(YES);
      result = [[obj valueForKey: @"date"] isEqual: tmp4];
      END_TEST(result, "fetched date");

      [ec release];
      [[EOModelGroup defaultGroup] removeModel: model];

      dropDatabaseWithModel(model);
      [pool release];

      END_SET("EOAdaptor: %s", [currAdaptorName cString]);
    }

  END_SET("EOAdaptor/EOAdaptorTypes00.m");
  [pool release];
  return (0);
}




