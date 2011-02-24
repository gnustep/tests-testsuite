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

  volatile BOOL result = NO;
  id tmp = nil;

  EOFetchSpecification *fSpec = nil;
  EOQualifier *qual;
  NSArray *sOrd;

  START_SET("EOFetchSpecification/EOFetchSpecification00.m");

  START_TEST(YES);
  fSpec = [[EOFetchSpecification alloc] init];
  result = [fSpec isDeep];
  result = result && [fSpec usesDistinct] == NO;
  END_TEST(result, "-[EOFetchSpecification init]");

  qual = [EOQualifier qualifierWithQualifierFormat: @"Supplier = 'FSF'"];
  START_TEST(YES);
  [fSpec setQualifier: qual];
  result = [[fSpec qualifier] isEqual: qual];
  END_TEST(result, "-[EOFetchSpecification setQualifier:]");

  tmp = [[EOSortOrdering alloc] initWithKey: @"name"
				selector: EOCompareAscending];
  sOrd = [NSArray arrayWithObject: tmp];
  START_TEST(YES);
  [fSpec setSortOrderings: sOrd];
  result = [[fSpec sortOrderings] isEqual: sOrd];
  END_TEST(result, "-[EOFetchSpecification setSortOrderings:]");

  START_TEST(YES);
  [fSpec setIsDeep: NO];
  result = [fSpec isDeep] == NO;
  END_TEST(result, "-[EOFetchSpecification setIsDeep:]");

  START_TEST(YES);
  [fSpec setEntityName: @"Product"];
  result = [[fSpec entityName] isEqual: @"Product"];
  END_TEST(result, "-[EOFetchSpecification setEntityName:]");

  START_TEST(YES);
  [fSpec setFetchLimit: 250];
  result = ([fSpec fetchLimit] == 250);
  END_TEST(result, "-[EOFetchSpecification setFetchLimit:]");

  START_TEST(YES);
  [fSpec setFetchesRawRows: YES];
  result = [fSpec fetchesRawRows];
  result = result && [[fSpec rawRowKeyPaths] isEqual: [NSArray array]];
  END_TEST(result, "-[EOFetchSpecification setFetchesRawRows:]");

  START_TEST(YES);
  {
    NSArray *keyPaths = [NSArray arrayWithObjects:
				   @"customer", @"customer.paymentTerms", nil];
    [fSpec setPrefetchingRelationshipKeyPaths: keyPaths];
    result = [[fSpec prefetchingRelationshipKeyPaths] isEqual: keyPaths];
  }
  END_TEST(result,
	   "-[EOFetchSpecification setPrefetchingRelationshipKeyPaths:]");

  START_TEST(YES);
  [fSpec setPromptsAfterFetchLimit: YES];
  result = [fSpec promptsAfterFetchLimit];
  END_TEST(result, "-[EOFetchSpecification setPromptsAfterFetchLimit:]");

  START_TEST(YES);
  {
    NSArray *keyPaths = [NSArray arrayWithObjects:
				   @"customer", @"customer.paymentTerms", nil];
    [fSpec setRawRowKeyPaths: keyPaths];
    result = [[fSpec rawRowKeyPaths] isEqual: keyPaths];
  }
  END_TEST(result, "-[EOFetchSpecification setRawRowKeyPaths:]");

  START_TEST(YES);
  [fSpec setRequiresAllQualifierBindingVariables: YES];
  result = [fSpec requiresAllQualifierBindingVariables];
  END_TEST(result,
	   "-[EOFetchSpecification setRequiresAllQualifierBindingVariables:]"
	   " TODO: Implement.");

  START_TEST(YES);
  {
    NSDictionary *hints 
      = [NSDictionary dictionaryWithObject: @"SELECT PID, NAME FROM PRODUCT"
		      forKey: EOCustomQueryExpressionHintKey];

    [fSpec setHints: hints];
    tmp = [[fSpec hints] objectForKey: EOCustomQueryExpressionHintKey];
    result 
      = [tmp isEqual: [hints objectForKey: EOCustomQueryExpressionHintKey]];
  }
  END_TEST(result, "-[EOFetchSpecification setHints:]");

  START_TEST(YES);
  [fSpec setLocksObjects: YES];
  result = [fSpec locksObjects];
  END_TEST(result, "-[EOFetchSpecification setLocksObjects:]");

  START_TEST(YES);
  [fSpec setRefreshesRefetchedObjects: YES];
  result = [fSpec refreshesRefetchedObjects];
  END_TEST(result, "-[EOFetchSpecification setRefreshesRefetchedObjects:]");

  START_TEST(YES);
  qual = [EOQualifier qualifierWithQualifierFormat: @"Supplier = 'FSF'"];
  tmp = [[EOSortOrdering alloc] initWithKey: @"name"
				selector: EOCompareAscending];
  sOrd = [NSArray arrayWithObject: tmp];
  
  fSpec = [[EOFetchSpecification alloc] initWithEntityName: @"Product"
					qualifier: qual
					sortOrderings: sOrd
					usesDistinct: YES
					isDeep: NO
					hints: nil];
  result = [[fSpec entityName] isEqual: @"Product"];
  result = result && [[fSpec qualifier] isEqual: qual];
  result = result && [[fSpec sortOrderings] isEqual: sOrd];
  result = result && ([fSpec isDeep] == NO);
  result = result && [fSpec usesDistinct];
  result = result && ([fSpec hints] == nil);
  END_TEST(result, "-[EOFetchSpecification "
	   "initWithEntityName:qualifier:sortOrderings:usesDistinct:"
	   "isDeep:hints:]");

  START_TEST(YES);
  qual = [EOQualifier qualifierWithQualifierFormat: @"Supplier = 'FSF'"];
  tmp = [[EOSortOrdering alloc] initWithKey: @"name"
				selector: EOCompareAscending];
  sOrd = [NSArray arrayWithObject: tmp];

  fSpec = [EOFetchSpecification fetchSpecificationWithEntityName: @"Product"
				qualifier: qual
				sortOrderings: sOrd];
  
  result = [[fSpec entityName] isEqual: @"Product"];
  result = result && [[fSpec qualifier] isEqual: qual];
  result = result && [[fSpec sortOrderings] isEqual: sOrd];
  result = result && [fSpec isDeep];
  result = result && ([fSpec usesDistinct] == NO);
  result = result && ([fSpec hints] == nil);
  END_TEST(result, "+[EOFetchSpecification "
	   "fetchSpecificationWithEntityName:qualifier:sortOrderings:]");

  END_SET("EOFetchSpecification/EOFetchSpecification00.m");

  [pool release];
  return (0);
}


