/*
   Copyright (C) 2008 Free Software Foundation, Inc.

   Written by: David Ayers <ayers@fsfe.org>
   Date: January 2008
   
   This file is part of the GNUstep Database Library.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 3 of the License, or (at your option) any later version.
   
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA.
  
 */

#include <Foundation/NSAutoreleasePool.h>
#include <EOAccess/EOAccess.h>

#include "../GDL2Testing.h"

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  NSString  *currAdaptorName;
  EOAdaptor *currAdaptor = nil;

  NSFileManager *mgr = [NSFileManager defaultManager];
  EOModel *model;
  EOEntity *entityP;
  EOEntity *entityS;
  EOClassDescription *cdP;
  EOClassDescription *cdS;
  NSString *filePath;
  EOEditingContext *ec;

  id objP = nil, objS = nil;

  model = [[EOModel alloc] initWithContentsOfFile: @"Bug8993.eomodel"];
  currAdaptorName = setupModel(model);
  /*  Now we have the testcases for the installed Adaptors.  */

  START_SET(YES);
  [EOSQLExpression setUseQuotedExternalNames: YES];

  currAdaptor = [EOAdaptor adaptorWithName: currAdaptorName];
  [currAdaptor setConnectionDictionary: [model connectionDictionary]];
  [currAdaptor assertConnectionDictionaryIsValid];

  [[currAdaptor class] assignExternalInfoForEntireModel: model];
  filePath = NSTemporaryDirectory();
  filePath = [filePath stringByAppendingPathComponent: currAdaptorName];
  if (! [mgr fileExistsAtPath: filePath])
    {
      [mgr createDirectoryAtPath: filePath attributes: nil];
    }
  filePath = [filePath stringByAppendingPathComponent: [model name]];
  [model writeToFile: filePath];
  createDatabaseWithModel(model);

  [[EOModelGroup defaultGroup] addModel: model];
  ec = [EOEditingContext new];

  entityP = [model entityNamed: @"Person"];
  entityS = [model entityNamed: @"SalaryHistory"];
  cdP = [entityP classDescriptionForInstances];
  cdS = [entityS classDescriptionForInstances];

  objP = [cdP createInstanceWithEditingContext: ec
	      globalID: nil
	      zone: NULL];
  [ec insertObject: objP];
  [objP takeValue:@"Smith" forKey:@"name"];
  [ec saveChanges];

  objS = [cdS createInstanceWithEditingContext: ec
	      globalID: nil
	      zone: NULL];
  [ec insertObject: objS];
  [objP addObject: objS
	toBothSidesOfRelationshipWithKey: @"salaryHistory"];
  [objS takeValue:[NSNumber numberWithInt:24000]
	forKey: @"salary"];
  [ec saveChanges];

  END_SET("Bug8993 preperation");
  START_SET(YES);
  [ec deleteObject: objS];
  START_TEST(YES);
  [ec saveChanges];
  END_TEST(YES, "Bug8993");
  END_SET("Bug8993");

  dropDatabaseWithModel(model);
  [pool release];
  return (0);
}




