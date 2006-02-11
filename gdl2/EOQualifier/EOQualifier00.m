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
#include <Foundation/NSSet.h>
#include <Foundation/NSDecimalNumber.h>
#include <EOControl/EOControl.h>

#include "../GDL2Testing.h"

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  volatile BOOL result = NO;
  id tmp = nil;

  NSArray *qualOperatorArr;
  id qual;
  NSSet *keys;
  Class qCls = [EOQualifier class];

  START_SET(YES);

  START_TEST(YES);
  tmp = [NSSet setWithObjects: @"=", @"!=", @"<=", @"<", @">=", @">",
	       @"doesContain", @"like", @"caseInsensitiveLike", nil];
  qualOperatorArr = [EOQualifier allQualifierOperators];
  result = [[NSSet setWithArray: qualOperatorArr] isEqual: tmp];
  END_TEST(result, "+[EOQualifier allQualifierOperators]");

  START_TEST(YES);
  tmp = [NSSet setWithObjects: @"=", @"!=", @"<=", @"<", @">=", @">", nil];
  qualOperatorArr = [EOQualifier relationalQualifierOperators];
  result = [[NSSet setWithArray: qualOperatorArr] isEqual: tmp];
  END_TEST(result, "+[EOQualifier relationalQualifierOperators]");

  START_TEST(YES);
  result = sel_eq([qCls operatorSelectorForString: @"="],
		  EOQualifierOperatorEqual);
  result = result && sel_eq([qCls operatorSelectorForString: @"=="],
			    EOQualifierOperatorEqual);
  result = result && sel_eq([qCls operatorSelectorForString: @"!="],
			    EOQualifierOperatorNotEqual);
  result = result && sel_eq([qCls operatorSelectorForString: @"<>"],
			    EOQualifierOperatorNotEqual);
  result = result && sel_eq([qCls operatorSelectorForString: @"<"],
			    EOQualifierOperatorLessThan);
  result = result && sel_eq([qCls operatorSelectorForString: @">"],
			    EOQualifierOperatorGreaterThan);
  result = result && sel_eq([qCls operatorSelectorForString: @"<="],
			    EOQualifierOperatorLessThanOrEqualTo);
  result = result && sel_eq([qCls operatorSelectorForString: @">="],
			    EOQualifierOperatorGreaterThanOrEqualTo);
  result = result && sel_eq([qCls operatorSelectorForString: @"like"],
			    EOQualifierOperatorLike);
  result = result && sel_eq([qCls operatorSelectorForString:
				    @"caseInsensitiveLike"],
			    EOQualifierOperatorCaseInsensitiveLike);
  result = result && sel_eq([qCls operatorSelectorForString: @"doesContain"],
			    EOQualifierOperatorContains);
  END_TEST(result, "+[EOQualifier operatorSelectorForString:]");

  START_TEST(YES);
  result = [[qCls stringForOperatorSelector: 
		    EOQualifierOperatorEqual] isEqual: @"="];
  
  result = result && [[qCls stringForOperatorSelector: 
			      EOQualifierOperatorNotEqual] isEqual: @"!="];
  
  result = result && [[qCls stringForOperatorSelector: 
			      EOQualifierOperatorLessThan] isEqual: @"<"];

  result = result && [[qCls stringForOperatorSelector: 
			      EOQualifierOperatorGreaterThan] isEqual: @">"];
  
  result = result && [[qCls stringForOperatorSelector: 
			      EOQualifierOperatorLessThanOrEqualTo]
		       isEqual: @"<="];

  result = result && [[qCls stringForOperatorSelector: 
			      EOQualifierOperatorGreaterThanOrEqualTo]
		       isEqual: @">="];
  
  result = result && [[qCls stringForOperatorSelector: 
			      EOQualifierOperatorContains]
		       isEqual: @"doesContain"];

  result = result && [[qCls stringForOperatorSelector: 
			      EOQualifierOperatorLike] isEqual: @"like"];
  
  result = result && [[qCls stringForOperatorSelector: 
			      EOQualifierOperatorCaseInsensitiveLike] 
		       isEqual: @"caseInsensitiveLike"];

  result = result && [[qCls stringForOperatorSelector: @selector(isEqual:)]
		       isEqual: @"isEqual:"];
  
  END_TEST(result, "+[EOQualifier stringForOperatorSelector:]");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat: @"key = 'constant'"];
  result = [qual isKindOfClass: [EOKeyValueQualifier class]];
  result = result && [[qual key] isEqual: @"key"];
  result = result && [[qual value] isEqual: @"constant"];
  result = result && sel_eq([qual selector], EOQualifierOperatorEqual);
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@'key = 'constant''");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat: @"key = value"];
  result = [qual isKindOfClass: [EOKeyComparisonQualifier class]];
  result = result && [[qual leftKey] isEqual: @"key"];
  result = result && [[qual rightKey] isEqual: @"value"];
  result = result && sel_eq([qual selector], EOQualifierOperatorEqual);
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@'key = value'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat: @"(key = value)"];
  result = [qual isKindOfClass: [EOKeyComparisonQualifier class]];
  result = result && [[qual leftKey] isEqual: @"key"];
  result = result && [[qual rightKey] isEqual: @"value"];
  result = result && sel_eq([qual selector], EOQualifierOperatorEqual);
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@'(key = value)'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat: @"key = 25"];
  result = [qual isKindOfClass: [EOKeyValueQualifier class]];
  result = result && [[qual key] isEqual: @"key"];
  result = result && [[qual value] isEqual: [NSNumber numberWithInt: 25]];
  result = result && sel_eq([qual selector], EOQualifierOperatorEqual);
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@'key = 25'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat: @"key = -25"];
  result = [qual isKindOfClass: [EOKeyValueQualifier class]];
  result = result && [[qual key] isEqual: @"key"];
  result = result && [[qual value] isEqual: [NSNumber numberWithInt: -25]];
  result = result && sel_eq([qual selector], EOQualifierOperatorEqual);
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@'key = -25'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat: @"key = -12.8"];
  result = [qual isKindOfClass: [EOKeyValueQualifier class]];
  result = result && [[qual key] isEqual: @"key"];
  result = result && [[qual value] isEqual: [NSNumber numberWithDouble: -12.8]];
  result = result && sel_eq([qual selector], EOQualifierOperatorEqual);
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@'key = -12.8'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat: @"key = (NSNumber)'25'"];
  result = [qual isKindOfClass: [EOKeyValueQualifier class]];
  result = result && [[qual key] isEqual: @"key"];
  result = result && [[qual value] isEqual: [NSNumber numberWithInt: 25]];
  result = result && sel_eq([qual selector], EOQualifierOperatorEqual);
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@'key = (NSNumber)'25''");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat: @"key = (NSNumber)'25.5'"];
  result = [qual isKindOfClass: [EOKeyValueQualifier class]];
  result = result && [[qual key] isEqual: @"key"];
  result = result && [[qual value] isEqual: [NSNumber numberWithFloat: 25.5]];
  result = result && sel_eq([qual selector], EOQualifierOperatorEqual);
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@'key = (NSNumber)'25.5''");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat: @"key = (NSNumber)'42.94967296'"];
  result = [qual isKindOfClass: [EOKeyValueQualifier class]];
  result = result && [[qual key] isEqual: @"key"];
  result = result && [[qual value] 
		       isEqual: [NSNumber numberWithDouble: 42.94967296]];
  result = result && sel_eq([qual selector], EOQualifierOperatorEqual);
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@'key = (NSNumber)'42.94967296''");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat: @"key = (NSDecimalNumber)'25.1'"];
  tmp = [NSDecimalNumber decimalNumberWithString: @"25.1"];
  result = [qual isKindOfClass: [EOKeyValueQualifier class]];
  result = result && [[qual key] isEqual: @"key"];
  result = result && [[qual value] isEqual: tmp];
  result = result && sel_eq([qual selector], EOQualifierOperatorEqual);
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@'key = (NSDecimalNumber)'25.1''");

  [NSString string];
  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat:
		 @"(key = value) and (key2 = 'constant')"];
  result = [qual isKindOfClass: [EOAndQualifier class]];
  result = result && [[qual qualifiers] count] == 2;
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@'(key = value) and (key2 = 'constant')'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat:
		 @"(key = value) and (key2 = 'constant') and (key3 = value3)"];
  result = [qual isKindOfClass: [EOAndQualifier class]];
  result = result && [[qual qualifiers] count] == 3;
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@'(key = value) and (key2 = 'constant') and (key3 = value3)'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat:
		 @"(key = value) or (key2 = 'constant')"];
  result = [qual isKindOfClass: [EOOrQualifier class]];
  result = result && [[qual qualifiers] count] == 2;
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@'(key = value) or (key2 = 'constant')'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat:
		 @"(key = value) or (key2 = 'constant') or (key3 = value3)"];
  result = [qual isKindOfClass: [EOOrQualifier class]];
  result = result && [[qual qualifiers] count] == 3;
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@'(key = value) or (key2 = 'constant') or (key3 = value3)'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat:
		 @"(key = value) and (key2 = 'constant') or (key3 = value3)"];
  result = [qual isKindOfClass: [EOAndQualifier class]];
  result = result && [[qual qualifiers] count] == 2;
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@'(key = value) and (key2 = 'constant') or (key3 = value3)'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat:
		 @"key = value and key2 = 'constant' or key3 = value3"];
  result = result && [qual isKindOfClass: [EOAndQualifier class]];
  result = result && [[qual qualifiers] count] == 2;
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@'key = value and key2 = 'constant' or key3 = value3'");

  /* allQualifierKeys */
  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat:
		 @"(key = value) and (key2 = 'constant')"];
  keys = [qual allQualifierKeys];
  tmp = [NSSet setWithObjects: @"key", @"key2", nil];
  result = [keys isEqual: tmp];
  END_TEST(result, "+[EOQualifier allQualifierKeys] "
	   "@'(key = value) and (key2 = 'constant')'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat:
		 @"(key = value) and (key2 = 'constant') and (key3 = value3)"];
  keys = [qual allQualifierKeys];
  tmp = [NSSet setWithObjects: @"key", @"key2", @"key3", nil];
  result = [keys isEqual: tmp];
  END_TEST(result, "+[EOQualifier allQualifierKeys] "
	   "@'(key = value) and (key2 = 'constant') and (key3 = value3)'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat:
		 @"(key = value) or (key2 = 'constant')"];
  keys = [qual allQualifierKeys];
  tmp = [NSSet setWithObjects: @"key", @"key2", nil];
  result = [keys isEqual: tmp];
  END_TEST(result, "+[EOQualifier allQualifierKeys] "
	   "@'(key = value) or (key2 = 'constant')'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat:
		 @"(key = value) or (key2 = 'constant') or (key3 = value3)"];
  keys = [qual allQualifierKeys];
  tmp = [NSSet setWithObjects: @"key", @"key2", @"key3", nil];
  result = [keys isEqual: tmp];
  END_TEST(result, "+[EOQualifier allQualifierKeys] "
	   "@'(key = value) or (key2 = 'constant') or (key3 = value3)'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat:
		 @"(key = value) and (key2 = 'constant') or (key3 = value3)"];
  keys = [qual allQualifierKeys];
  tmp = [NSSet setWithObjects: @"key", @"key2", @"key3", nil];
  result = [keys isEqual: tmp];
  END_TEST(result, "+[EOQualifier allQualifierKeys] "
	   "@'(key = value) and (key2 = 'constant') or (key3 = value3)'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat:
		 @"key = value and key2 = 'constant' or key3 = value3"];
  keys = [qual allQualifierKeys];
  tmp = [NSSet setWithObjects: @"key", @"key2", @"key3", nil];
  result = [keys isEqual: tmp];
  END_TEST(result, "+[EOQualifier allQualifierKeys] "
	   "@'key = value and key2 = 'constant' or key3 = value3'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat: @"key = nil"];
  result = [qual isKindOfClass: [EOKeyValueQualifier class]];
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@'key = nil'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat: @"(key = nil)"];
  result = [qual isKindOfClass: [EOKeyValueQualifier class]];
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@'(key = nil)'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat: @" key = nil "];
  result = [qual isKindOfClass: [EOKeyValueQualifier class]];
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@' key = nil '");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat: @"key = nill"];
  result = [qual isKindOfClass: [EOKeyComparisonQualifier class]];
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@'key = nill'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat: @"key = nil0"];
  result = [qual isKindOfClass: [EOKeyComparisonQualifier class]];
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@'key = nil0'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat: @"key = nil_"];
  result = [qual isKindOfClass: [EOKeyComparisonQualifier class]];
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "@'key = nil_'");

  END_SET("EOQualifier/EOQualifier00.m");

  [pool release];
  return (0);
}
