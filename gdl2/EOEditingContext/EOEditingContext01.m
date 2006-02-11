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

@interface ECDelegate : NSObject
{
  BOOL shouldFetchObjectsDescribedByFetchSpecification_r;
  BOOL shouldFetchObjectsDescribedByFetchSpecification;
  BOOL shouldInvalidateObject_r;
  BOOL shouldInvalidateObject;
  BOOL editingContextWillSaveChanges_r;
  BOOL editingContextShouldValidateChanges_r;
  BOOL editingContextShouldValidateChanges;
  BOOL shouldPresentException_r;
  BOOL shouldPresentException;
  BOOL editingContextShouldUndoUserActionsAfterFailure_r;
  BOOL editingContextShouldUndoUserActionsAfterFailure;
  BOOL shouldMergeChangesForObject_r;
  BOOL shouldMergeChangesForObject;
  BOOL editingContextDidMergeChanges_r;
}
- (NSArray *)editingContext: (EOEditingContext *)editingContext
shouldFetchObjectsDescribedByFetchSpecification: (EOFetchSpecification *)fetchSpecification;

- (BOOL)editingContext: (EOEditingContext *)editingContext
shouldInvalidateObject: (id)object
              globalID: (EOGlobalID *)gid;

- (void)editingContextWillSaveChanges: (EOEditingContext *)editingContext;
- (BOOL)editingContextShouldValidateChanges: (EOEditingContext *)editingContext;
- (BOOL)editingContext: (EOEditingContext *)editingContext
shouldPresentException: (NSException *)exception;
- (BOOL)editingContextShouldUndoUserActionsAfterFailure: (EOEditingContext *)context;

- (BOOL)editingContext: (EOEditingContext *)editingContext
shouldMergeChangesForObject: (id)object;
- (void)editingContextDidMergeChanges: (EOEditingContext *)editingContext;

@end
@implementation ECDelegate
- (id)init
{
  if ((self = [super init]))
    {
      shouldFetchObjectsDescribedByFetchSpecification = YES;
      shouldInvalidateObject = YES;
      editingContextShouldValidateChanges = YES;
      shouldPresentException = YES;
      editingContextShouldUndoUserActionsAfterFailure = YES;
      shouldMergeChangesForObject = YES;
    }
  return self;
}
- (NSArray *)editingContext: (EOEditingContext *)editingContext
shouldFetchObjectsDescribedByFetchSpecification: (EOFetchSpecification *)fetchSpecification
{
  shouldFetchObjectsDescribedByFetchSpecification_r = YES;
  return shouldFetchObjectsDescribedByFetchSpecification 
    ? [NSArray array]: nil;
}

- (BOOL)editingContext: (EOEditingContext *)editingContext
shouldInvalidateObject: (id)object
              globalID: (EOGlobalID *)gid
{
  shouldInvalidateObject_r = YES;
  return shouldInvalidateObject;
}

- (void)editingContextWillSaveChanges: (EOEditingContext *)editingContext
{
  editingContextWillSaveChanges_r = YES;
}
- (BOOL)editingContextShouldValidateChanges: (EOEditingContext *)editingContext
{
  editingContextShouldValidateChanges_r = YES;
  return editingContextShouldValidateChanges;
}
- (BOOL)editingContext: (EOEditingContext *)editingContext
shouldPresentException: (NSException *)exception
{
  shouldPresentException_r = YES;
  return shouldPresentException;
}
- (BOOL)editingContextShouldUndoUserActionsAfterFailure: (EOEditingContext *)context
{
  editingContextShouldUndoUserActionsAfterFailure_r = YES;
  return editingContextShouldUndoUserActionsAfterFailure;
}

- (BOOL)editingContext: (EOEditingContext *)editingContext
shouldMergeChangesForObject: (id)object
{
  shouldMergeChangesForObject_r = YES;
  return shouldMergeChangesForObject;
}
- (void)editingContextDidMergeChanges: (EOEditingContext *)editingContext
{
  editingContextDidMergeChanges_r = YES;
}
@end

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  NSAutoreleasePool *tmpPool;

  volatile BOOL result = NO;
  EOModel  *model;
  EOEntity *entity;
  EOClassDescription *cd;
  EOGlobalID *gid;
  EOEditingContext *ec1 = nil;
  EOEditingContext *ec2 = nil;
  EOFetchSpecification *fs = nil;
  id obj = nil;
  id del = nil;
  id tmp = nil;

  START_SET(YES);

  model = globalModelForKey(@"TSTTradingModel.eomodeld");

  createDatabaseWithModel(model);

  [[EOModelGroup defaultGroup] addModel: model];
  entity = [model entityNamed: @"ProductGroup"];
  cd = [entity classDescriptionForInstances];
  ec1 = [EOEditingContext new];

  tmpPool = [NSAutoreleasePool new];
  obj = [cd createInstanceWithEditingContext: ec1
	    globalID: nil
	    zone: NULL];
  gid = [EOTemporaryGlobalID new];

  START_TEST(YES);
  [ec1 recordObject: obj globalID: gid];
  END_TEST(YES, "-[EOEditingContext registerObject:withGlobalID:] 1");

  START_TEST(YES);
  tmp = [ec1 objectForGlobalID: gid];
  result = tmp == obj;
  END_TEST(result, "EOEditingContext dealloc hack 1");
  
  START_TEST(YES);
  [tmpPool release];  /* This causes obj to be dealloced and it should
			 automagically be removed from the EC tables.  */
  tmp = [ec1 objectForGlobalID: gid];
  result = tmp == nil;
  END_TEST(result, "EOEditingContext dealloc hack 2");

  obj = [cd createInstanceWithEditingContext: ec1
	    globalID: nil
	    zone: NULL];

  START_TEST(YES);
  result = [ec1 hasChanges] == NO;
  END_TEST(result, "-[EOEditingContext hasChanges] 1");

  START_TEST(YES);
  [ec1 insertObject: obj];
  END_TEST(YES, "-[EOEditingContext insertObject:] plain");

  START_TEST(YES);
  result = [ec1 hasChanges];
  END_TEST(result, "-[EOEditingContext hasChanges] 2");

  START_TEST(YES);
  [ec1 revert];
  result = [ec1 hasChanges] == NO;
  END_TEST(result, "-[EOEditingContext revert] plain");

  [ec1 insertObject: obj];

  START_TEST(YES);
  gid = [ec1 globalIDForObject: obj];
  result = gid != nil;
  END_TEST(result, "-[EOEditingContext globalIDForObject:]");

  START_TEST(YES);
  tmp = [ec1 objectForGlobalID: gid];
  result = tmp == obj;
  END_TEST(result, "-[EOEditingContext objectForGlobalID:]");

  [obj takeValue: @"Software" forKey: @"name"];
  [obj takeValue: [NSCalendarDate date] forKey: @"date"];

  START_TEST(YES);
  [ec1 saveChanges];
  result = [ec1 hasChanges] == NO;
  tmp = [ec1 globalIDForObject: obj];
  result = result && [tmp isEqual: gid] == NO;
  result = result && [ec1 objectForGlobalID: tmp] == obj;
  gid = tmp; /* New globalID */
  END_TEST(result, "-[EOEditingContext saveChanges] 1");

  START_TEST(YES);
  [ec1 invalidateAllObjects];
  result = [EOFault isFault: obj];
  END_TEST(result, "-[EOEditingContext invalidateAllObjects]");

  START_TEST(YES);
  [ec1 lockObjectWithGlobalID: gid editingContext: ec1];
  END_TEST(YES,
	   "-[EOEditingContext lockObjectWithGlobalID:editingContext:] 1");

  START_TEST(YES);
  result = [ec1 isObjectLockedWithGlobalID: gid editingContext: ec1];
  END_TEST(result,
	   "-[EOEditingContext isObjectLockedWithGlobalID:editingContext:] 1");

  /* There seems to be no other way to release the lock being held here.
     The documentation claims -[EODatabaseContext invalidateAllObjects]
     would also release the locks in the server but that does not really
     seem to be the case according to my testing.  */
  [ec1 revert];
  [ec1 saveChanges];

  START_TEST(YES);
  result = [ec1 isObjectLockedWithGlobalID: gid editingContext: ec1] == NO;
  END_TEST(result,
	   "-[EOEditingContext isObjectLockedWithGlobalID:editingContext:] 2");

  START_TEST(YES);
  [ec1 lockObject: obj];
  END_TEST(YES, "-[EOEditingContext lockObject:] 1");

  START_TEST(YES);
  result = [ec1 isObjectLockedWithGlobalID: gid editingContext: ec1];
  END_TEST(result,
	   "-[EOEditingContext isObjectLockedWithGlobalID:editingContext:] 3");
  [ec1 saveChanges];

  [ec1 invalidateAllObjects];

  fs = [EOFetchSpecification fetchSpecificationWithEntityName: @"ProductGroup"
			     qualifier: nil
			     sortOrderings: nil];

  START_TEST(YES);
  tmp = [ec1 objectsWithFetchSpecification: fs];
  result = [tmp lastObject] == obj; /* This must be pointer equality.  */
  [obj release];
  END_TEST(result, "-[EOEditingContext objectsWithFetchSpecification:]");

  START_TEST(YES);
  result = [ec1 hasChanges] == NO;
  END_TEST(result, "-[EOEditingContext hasChanges] 3");

  START_TEST(YES);
  /* Verified: merely setting the same value will set hasChanges.  */
  tmp = [obj valueForKey: @"name"];
  [obj takeValue: tmp forKey: @"name"];
  result = [ec1 hasChanges];
  END_TEST(result, "-[EOEditingContext hasChanges] 4");

  START_TEST(YES);
  [ec1 saveChanges];
  result = [ec1 hasChanges] == NO;
  END_TEST(result, "-[EOEditingContext hasChanges] 5");

  START_TEST(YES);
  [ec1 deleteObject: obj];
  END_TEST(YES, "-[EOEditingContext deleteObject:] 1");

  START_TEST(YES);
  result = [ec1 hasChanges];
  END_TEST(result, "-[EOEditingContext hasChanges] 6");

  START_TEST(YES);
  [ec1 saveChanges];
  result = [ec1 hasChanges] == NO;
  END_TEST(result, "-[EOEditingContext hasChanges] 7");

  START_TEST(YES);
  result = [ec1 objectForGlobalID: gid] == nil;
  END_TEST(YES, "-[EOEditingContext deleteObject:] 2");

  del = [ECDelegate new];
  START_TEST(YES);
  [ec1 setDelegate: del];
  result = [ec1 delegate] == del;
  END_TEST(result, "-[EOEditingContext setDelegate:/delegate]");

  dropDatabaseWithModel(model);
  END_SET("EOEditingContext/EOEditingContext01.m");

  [pool release];
  return (0);
}
