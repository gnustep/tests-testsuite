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

#import <Foundation/Foundation.h>
#include <EOAccess/EOAccess.h>
#include <EOControl/EOControl.h>
#include "../GDL2Testing.h"

int mybreak(void)
{
  return 0;
}

static void
insertObjects(EOModel *model, EOEditingContext *ec, id *objPrd)
{
  EOEntity *entity;
  EOClassDescription *cdPrd;

  entity = [model entityNamed: @"ProductGroup"];
  cdPrd = [entity classDescriptionForInstances];
  *objPrd = [cdPrd createInstanceWithEditingContext: ec 
		   globalID: nil zone: 0];
  [ec insertObject: *objPrd];
  [*objPrd takeValue: @"MyGroup" forKey: @"name"];
  [*objPrd takeValue: [NSCalendarDate date] forKey: @"date"];
}

int main()
{
  int brk = mybreak();
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  volatile BOOL result = NO;
  EOModel  *model;
  EOEditingContext *ec = nil;
  id objPrd = nil;
  
  START_SET("EOFault/" __FILE__);

  model = globalModelForKey(@"TSTTradingModel.eomodeld");
  setupModel(model);

  createDatabaseWithModel(model);
  [[EOModelGroup defaultGroup] addModel: model];

  ec = [EOEditingContext new];

  insertObjects(model, ec, &objPrd);
  [ec saveChanges];

  START_TEST(YES);
  [ec refaultObjects];
  result = [EOFault isFault:objPrd];
  END_TEST(result,"Fault existing object.");

  START_TEST(YES);
  [objPrd retain];
  result = [EOFault isFault:objPrd];
  END_TEST(result,"Fault does not fire on retain");
  
  [ec refaultObjects];
  START_TEST(YES);
  [objPrd release];
  result = [EOFault isFault:objPrd];
  END_TEST(result,"Fault does not fire on release");
  
  [objPrd retain];
  [ec refaultObjects];
  START_TEST(YES);
  [objPrd autorelease];
  result = [EOFault isFault:objPrd];
  END_TEST(result,"Fault does not fire on autorelease");
  
  [ec refaultObjects];
  START_TEST(YES);
  [objPrd retainCount];
  result = [EOFault isFault:objPrd];
  END_TEST(result,"Fault does not fire on retainCount");
  
  [ec refaultObjects];
  START_TEST(YES);
  [objPrd class];
  result = [EOFault isFault:objPrd];
  END_TEST(result,"Fault does not fire on class");
  
  [ec refaultObjects];
  START_TEST(YES);
  [objPrd superclass];
  result = [EOFault isFault:objPrd];
  END_TEST(result,"Fault does not fire on superclass");
  
  [ec refaultObjects];
  START_TEST(YES);
  [objPrd isKindOfClass:[NSObject class]];
  result = [EOFault isFault:objPrd];
  END_TEST(result,"Fault does not fire on isKindOfClass:");
  
  [ec refaultObjects];
  START_TEST(YES);
  [objPrd isMemberOfClass:[EOGenericRecord class]];
  result = [EOFault isFault:objPrd];
  END_TEST(result,"Fault does not fire on isMemberOfClass:");
  
  [ec refaultObjects];
  START_TEST(YES);
  [objPrd conformsToProtocol:@protocol(NSObject)];
  result = [EOFault isFault:objPrd];
  END_TEST(result,"Fault does not fire on conformsToProtocol:");
  
  [ec refaultObjects];
  START_TEST(YES);
  [objPrd isProxy];
  result = [EOFault isFault:objPrd];
  END_TEST(result,"Fault does not fire on isProxy");
  
  [ec refaultObjects];
  START_TEST(YES);
  [objPrd methodSignatureForSelector:@selector(takeValue:forKey:)];
  result = [EOFault isFault:objPrd];
  END_TEST(result,"Fault does not fire on methodSignatureForSelector:");
  
  [ec refaultObjects];
  START_TEST(YES);
  [objPrd respondsToSelector:@selector(takeValue:forKey:)];
  result = [EOFault isFault:objPrd];
  END_TEST(result,"Fault does not fire on resondsToSelector:");
  
  [ec refaultObjects];
  START_TEST(YES);
  [objPrd zone];
  result = [EOFault isFault:objPrd];
  END_TEST(result,"Fault does not fire on zone");
  
  [ec refaultObjects];
  START_TEST(YES);
  NS_DURING
    [objPrd doesNotRecognizeSelector:@selector(isFault:)];
  NS_HANDLER;
  NS_ENDHANDLER;
  result = [EOFault isFault:objPrd];
  END_TEST(result,"Fault does not fire on doesNotRecognizeSelector:");

  [ec refaultObjects];
  START_TEST(YES);
  [objPrd description];
  result = [EOFault isFault:objPrd];
  END_TEST(result,"Fault does not fire on description");
  
  [ec refaultObjects];
  START_TEST(YES);
  [objPrd descriptionWithLocale:nil];
  result = [EOFault isFault:objPrd];
  END_TEST(result,"Fault does not fire on descriptionWithLocale:");
  
  [ec refaultObjects];
  START_TEST(YES);
  [objPrd descriptionWithIndent:0];
  result = [EOFault isFault:objPrd];
  END_TEST(result,"Fault does not fire on descriptionWithIndent:");
  
  [ec refaultObjects];
  START_TEST(YES);
  [objPrd descriptionWithLocale:nil indent:0];
  result = [EOFault isFault:objPrd];
  END_TEST(result,"Fault does not fire on descriptionWithLocale:indent:");
  
  [ec refaultObjects];
  START_TEST(YES);
  [objPrd eoDescription];
  result = [EOFault isFault:objPrd];
  END_TEST(result,"Fault does not fire on eoDescription");
  
  [ec refaultObjects];
  START_TEST(YES);
  [objPrd eoShallowDescription];
  result = [EOFault isFault:objPrd];
  END_TEST(result,"Fault does not fire on eoShallowDescription");
  
  [ec refaultObjects];
  START_TEST(YES);
  [objPrd self];
  result = [EOFault isFault:objPrd] == NO;
  END_TEST(result,"Fire fault on existing object.");
  
  [ec refaultObjects];
  START_TEST(YES);
  [objPrd valueForKey:@"name"];
  result = [EOFault isFault:objPrd] == NO;
  END_TEST(result,"Fire fault via forwad invocation.");
  
  dropDatabaseWithModel(model);
  END_SET("EOFault/" __FILE__);

  [pool release];
  return 0;
}
