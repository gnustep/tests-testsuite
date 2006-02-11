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

#include "../GDL2Testing.h"

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  volatile BOOL result = NO;
  id tmp = nil;
  EOKeyComparisonQualifier *qual;

  START_SET(YES);

  START_TEST(YES);
  qual 
    = [[EOKeyComparisonQualifier alloc] initWithLeftKey: @"invented"
					operatorSelector:
					  EOQualifierOperatorGreaterThan
					rightKey: @"distributed"];
  result = [[qual leftKey] isEqual: @"invented"];
  result = result && sel_eq([qual selector],
			    EOQualifierOperatorGreaterThan);
  result = result && [[qual rightKey] isEqual: @"distributed"];
  END_TEST(result, 
	   "-[EOKeyComparisonQualifier"
	   "initWithLeftKey:operatorSelector:rightKey:]"); 

  START_TEST(YES);
  {
    NSDictionary *dbDict1;
    NSDictionary *dbDict2;
    NSDictionary *dbDict3;
    NSDictionary *dbDict4;
    NSDictionary *dbDict5;
    NSDictionary *dbDict6;
    NSDictionary *dbDict7;
    NSDictionary *dbDict8;

    EOQualifier *qualEqual;
    EOQualifier *qualNotEqual;
    EOQualifier *qualLessThan;
    EOQualifier *qualGreaterThan;
    EOQualifier *qualLessEqual;
    EOQualifier *qualGreaterEqual;
    EOQualifier *qualContains;
    EOQualifier *qualLike;
    EOQualifier *qualCaseInLike;

    qualEqual 
      = [[EOKeyComparisonQualifier alloc] initWithLeftKey: @"invented"
					  operatorSelector:
					    EOQualifierOperatorEqual
					  rightKey: @"distributed"];
    qualNotEqual
      = [[EOKeyComparisonQualifier alloc] initWithLeftKey: @"invented"
					  operatorSelector:
					    EOQualifierOperatorNotEqual
					  rightKey: @"distributed"];
    qualLessThan
      = [[EOKeyComparisonQualifier alloc] initWithLeftKey: @"invented"
					  operatorSelector:
					    EOQualifierOperatorLessThan
					  rightKey: @"distributed"];
    qualGreaterThan
      = [[EOKeyComparisonQualifier alloc] initWithLeftKey: @"invented"
					  operatorSelector:
					    EOQualifierOperatorGreaterThan
					  rightKey: @"distributed"];
    qualLessEqual
      = [[EOKeyComparisonQualifier alloc] initWithLeftKey: @"invented"
					  operatorSelector:
				    EOQualifierOperatorLessThanOrEqualTo
					  rightKey: @"distributed"];
    qualGreaterEqual
      = [[EOKeyComparisonQualifier alloc] initWithLeftKey: @"invented"
					  operatorSelector:
				    EOQualifierOperatorGreaterThanOrEqualTo
					  rightKey: @"distributed"];
    qualContains
      = [[EOKeyComparisonQualifier alloc] initWithLeftKey: @"invented"
					  operatorSelector:
					    EOQualifierOperatorContains
					  rightKey: @"distributed"];
    qualLike
      = [[EOKeyComparisonQualifier alloc] initWithLeftKey: @"invented"
					  operatorSelector:
					    EOQualifierOperatorLike
					  rightKey: @"distributed"];
    qualCaseInLike
      = [[EOKeyComparisonQualifier alloc] initWithLeftKey: @"invented"
					  operatorSelector:
				    EOQualifierOperatorCaseInsensitiveLike
					  rightKey: @"distributed"];

    dbDict1 = [NSDictionary dictionaryWithObjectsAndKeys:
			      @"Austria", @"invented",
			    @"Germany", @"distributed", nil];
    dbDict2 = [NSDictionary dictionaryWithObjectsAndKeys:
			      @"United Kingdom", @"invented",
			    @"United Kingdom", @"distributed", nil];
    dbDict3 = [NSDictionary dictionaryWithObjectsAndKeys:
			      @"New Guinea", @"invented",
			    @"Guinea", @"distributed", nil];
    dbDict4 = [NSDictionary dictionaryWithObjectsAndKeys:
			      @"United States", @"invented",
			    @"United *", @"distributed", nil];
    dbDict5 = [NSDictionary dictionaryWithObjectsAndKeys:
			      @"France", @"invented",
			    @"FRA*", @"distributed", nil];
    dbDict6 = [NSDictionary dictionaryWithObjectsAndKeys:
			      @"Italy", @"invented",
			    @"Ital?", @"distributed", nil];

    tmp = [NSArray arrayWithObjects: @"France", @"Italy", nil];
    dbDict7 = [NSDictionary dictionaryWithObjectsAndKeys:
			    tmp, @"invented",
			    @"Italy", @"distributed", nil];

    dbDict8 = [NSDictionary dictionaryWithObjectsAndKeys:
			    tmp, @"invented",
			    @"Germany", @"distributed", nil];

    result = [qualEqual evaluateWithObject: dbDict1] == NO;
    result = result && [qualEqual evaluateWithObject: dbDict2];
    result = result && [qualEqual evaluateWithObject: dbDict3] == NO;

    result = result && [qualNotEqual evaluateWithObject: dbDict1];
    result = result && [qualNotEqual evaluateWithObject: dbDict2] == NO;
    result = result && [qualNotEqual evaluateWithObject: dbDict3];

    result = result && [qualLessThan evaluateWithObject: dbDict1];
    result = result && [qualLessThan evaluateWithObject: dbDict2] == NO;
    result = result && [qualLessThan evaluateWithObject: dbDict3] == NO;

    result = result && [qualGreaterThan evaluateWithObject: dbDict1] == NO;
    result = result && [qualGreaterThan evaluateWithObject: dbDict2] == NO;
    result = result && [qualGreaterThan evaluateWithObject: dbDict3];

    result = result && [qualLessEqual evaluateWithObject: dbDict1];
    result = result && [qualLessEqual evaluateWithObject: dbDict2];
    result = result && [qualLessEqual evaluateWithObject: dbDict3] == NO;

    result = result && [qualGreaterEqual evaluateWithObject: dbDict1] == NO;
    result = result && [qualGreaterEqual evaluateWithObject: dbDict2];
    result = result && [qualGreaterEqual evaluateWithObject: dbDict3];

    result = result && [qualLike evaluateWithObject: dbDict1] == NO;
    result = result && [qualLike evaluateWithObject: dbDict2];
    result = result && [qualLike evaluateWithObject: dbDict3] == NO;
    result = result && [qualLike evaluateWithObject: dbDict4];
    result = result && [qualLike evaluateWithObject: dbDict5] == NO;
    result = result && [qualLike evaluateWithObject: dbDict6];

    result = result && [qualCaseInLike evaluateWithObject: dbDict1] == NO;
    result = result && [qualCaseInLike evaluateWithObject: dbDict2];
    result = result && [qualCaseInLike evaluateWithObject: dbDict3] == NO;
    result = result && [qualCaseInLike evaluateWithObject: dbDict4];
    result = result && [qualCaseInLike evaluateWithObject: dbDict5];
    result = result && [qualCaseInLike evaluateWithObject: dbDict6];

    result = result && [qualContains evaluateWithObject: dbDict7];
    result = result && [qualContains evaluateWithObject: dbDict8] == NO;
  }
  END_TEST(result, 
	   "-[EOKeyComparisonQualifier evaluateWithObject:]");

  END_SET("EOQualifier/EOKeyComparisonQualifier00.m");

  [pool release];
  return (0);
}

