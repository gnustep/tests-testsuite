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
#include <Foundation/NSCalendarDate.h>
#include <EOControl/EOControl.h>
#include <EOInterface/EOInterface.h>
#include <EOControl/EOQualifier.h>
#include "../GDL2Testing.h"

@implementation EOKeyValueQualifier(equality)
- (BOOL) isEqual:(id)obj
{
  if (![obj isKindOfClass: [self class]])
    return NO;

  return sel_eq(_selector, (SEL)((EOKeyValueQualifier *)obj)->_selector)
         && [_key isEqual:((EOKeyValueQualifier *)obj)->_key]
         && [_value isEqual:((EOKeyValueQualifier *)obj)->_value];
}
@end
@implementation NSCalendarDate(equality)
- (BOOL) isEqual:(id)obj
{
  if (![obj isKindOfClass:[self class]])
    return NO;
  return [[self description] isEqual: [obj description]];
}
@end
int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  volatile BOOL result = NO;
  id tmp = nil;
  EODisplayGroup *displayGroup;
  EOEditingContext *context;
  
  EOModel *model;
  EODataSource *dataSource;
  NSCalendarDate *date;

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
  END_TEST(result, "-[EODisplayGroup insert:]");
  
  START_TEST(YES)
  result = [displayGroup selectedObject] == [[displayGroup allObjects] objectAtIndex:0];
  END_TEST(result, "-[EODisplayGroup selectedObject]");
  
  START_TEST(YES)
  [displayGroup insert:nil]; 
  [displayGroup insert:nil]; 
  [displayGroup selectNext:nil];
  [displayGroup selectNext:nil];
  result = [displayGroup selectedObject] == [[displayGroup allObjects] objectAtIndex:2];
  END_TEST(result, "-[EODisplayGroup selectNext:]");
  
  START_TEST(YES)
  [displayGroup insert:nil]; 
  [displayGroup selectPrevious:nil];
  result = [displayGroup selectedObject] == [[displayGroup allObjects] objectAtIndex:1];
  END_TEST(result, "-[EODisplayGroup selectPrevious:]");

  START_TEST(YES)
  result = [displayGroup enabledToSetSelectedObjectValueForKey:@"foo"] == YES;
  END_TEST(result, "-[EODisplayGroup enabledToSetSelectedObjectValueForKey:] 1");

  START_TEST(YES)
  result = [displayGroup enabledToSetSelectedObjectValueForKey:@"@foo"] == YES;
  END_TEST(result, "-[EODisplayGroup enabledToSetSelectedObjectValueForKey:] 2");

  START_TEST(YES)
  result = [displayGroup enabledToSetSelectedObjectValueForKey:@"@query<"];
  END_TEST(result, "-[EODisplayGroup enabledToSetSelectedObjectValueForKey:] 3");

  [displayGroup clearSelection];
  START_TEST(YES)
  result = [displayGroup selectedObject] == nil;
  END_TEST(result, "-[EODisplayGroup clearSelection]");

  START_TEST(YES)
  result = [displayGroup enabledToSetSelectedObjectValueForKey:@"foo"] == NO;
  END_TEST(result, "-[EODisplayGroup enabledToSetSelectedObjectValueForKey:] 4");

  START_TEST(YES)
  result = [displayGroup enabledToSetSelectedObjectValueForKey:@"@foo"] == NO;
  END_TEST(result, "-[EODisplayGroup enabledToSetSelectedObjectValueForKey:] 5");
  
  START_TEST(YES)
  result = [displayGroup enabledToSetSelectedObjectValueForKey:@"@query<"];
  END_TEST(result, "-[EODisplayGroup enabledToSetSelectedObjectValueForKey:] 6"); 
  [displayGroup selectNext:nil];
	      
  START_TEST(YES);
  [displayGroup setValue:@"foo" forObject:nil key:@"@query<.name"];
  result = [[[displayGroup lessThanQueryValues] objectForKey:@"name"] isEqual:@"foo"];
  END_TEST(result, "-[EODisplayGroup lessThanQueryValues]");
  
  START_TEST(YES);
  [displayGroup setValue:@"bar" forObject:nil key:@"@query>.name"];
  result = [[[displayGroup greaterThanQueryValues] objectForKey:@"name"] isEqual:@"bar"];
  END_TEST(result, "-[EODisplayGroup greaterThanQueryValues]");
  
  START_TEST(YES);
  date = RETAIN([NSCalendarDate calendarDate]);
  
  [displayGroup setValue:[date description] forObject:nil key:@"@query=.date"];
  result = [[[displayGroup equalToQueryValues] objectForKey:@"date"]
	  	isEqual:[date description]];
  END_TEST(result, "-[EODisplayGroup equalToQueryValues] 1");

  START_TEST(YES);
  [displayGroup setValue:@"hmm" forObject:nil key:@"@query=.name"];
  result = [[[displayGroup equalToQueryValues] objectForKey:@"name"]
                isEqual:@"hmm"];
  END_TEST(result, "-[EODisplayGroup equalToQueryValues] 2");
  
  START_TEST(YES);
  NS_DURING
  [displayGroup setValue:@"bad" forObject:nil key:@"@query"];
  result = NO;
  NS_HANDLER
  result = YES;
  NS_ENDHANDLER
  END_TEST(result, "-[EODisplayGroup setValue:forObject:key:] (bad query values)");
  
  START_TEST(YES);
  NS_DURING
  [displayGroup setValue:@"bad" forObject:nil key:@"@query<"];
  result = NO;
  NS_HANDLER
  result = YES;
  NS_ENDHANDLER
  END_TEST(result, "-[EODisplayGroup setValue:forObject:key:] (bad query values)");
  
  START_TEST(YES);
  NS_DURING
  [displayGroup setValue:@"bad" forObject:nil key:@"@queryhmmm"];
  result = NO;
  NS_HANDLER
  result = YES;
  NS_ENDHANDLER
  END_TEST(result, "-[EODisplayGroup setValue:forObject:key:] (bad query values)");
  
  { 
    NSArray *arr;
    EOAndQualifier *qual = [displayGroup qualifierFromQueryValues];
    id tmpQual;
    
    arr = [qual qualifiers];
    START_TEST(YES)
    tmpQual = [EOKeyValueQualifier qualifierWithKey:@"date" 
    				operatorSelector:EOQualifierOperatorEqual
				value:date];
    result = [arr containsObject: tmpQual];
    END_TEST(result, "-[EODisplayGroup qualifierFromQueryValues] 1");
    RELEASE(date);
     
    START_TEST(YES)
    tmpQual = [EOKeyValueQualifier qualifierWithKey:@"name" 
    				operatorSelector:EOQualifierOperatorGreaterThanOrEqualTo
				value:@"bar"];
    result = [arr containsObject: tmpQual];
    END_TEST(result, "-[EODisplayGroup qualifierFromQueryValues] 2");
    
    [displayGroup setQueryOperatorValues:[NSDictionary dictionaryWithObject:@"!=" forKey:@"name"]];
    START_TEST(YES)
    tmpQual = [EOKeyValueQualifier qualifierWithKey:@"name" 
    				operatorSelector:EOQualifierOperatorLessThanOrEqualTo
				value:@"foo"];
    result = [arr containsObject:tmpQual];
    END_TEST(result, "-[EODisplayGroup qualifierFromQueryValues] 3");
    
    START_TEST(YES)
    tmpQual = [EOKeyValueQualifier qualifierWithKey:@"name"
                                operatorSelector:EOQualifierOperatorCaseInsensitiveLike
                                value:@"hmm*"];

    result = [arr containsObject:tmpQual];
    END_TEST(result, "-[EODisplayGroup qualifierFromQueryValues] 4");
  }
  
  END_SET("EODisplayGroup/EODisplayGroup00.m");

  [pool release];
  return (0);
}
