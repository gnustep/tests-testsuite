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
#include <EOControl/EOControl.h>

#include "../GDL2Testing.h"

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  volatile BOOL result = NO;
  id tmp = nil;
  EOOrQualifier *qual;

  START_SET(YES);

  START_TEST(YES);
  {
    NSArray *setQualArr;
    NSArray *getQualArr;
    EOQualifier *keyValQual1;
    EOQualifier *keyValQual2;

    keyValQual1
      = [[EOKeyValueQualifier alloc] initWithKey: @"name"
				     operatorSelector:
				       EOQualifierOperatorLessThanOrEqualTo
				     value: @"MySQL"];
    keyValQual2
      = [[EOKeyValueQualifier alloc] initWithKey: @"name"
				     operatorSelector:
				       EOQualifierOperatorGreaterThan
				     value: @"PostgresSQL"];
    setQualArr = [NSArray arrayWithObjects: keyValQual1, keyValQual2, nil];

    qual = [[EOOrQualifier alloc] initWithQualifierArray: setQualArr];
    getQualArr = [qual qualifiers];
    result = [[NSSet setWithArray: setQualArr] 
	       isEqual: [NSSet setWithArray: getQualArr]];
    
  }
  END_TEST(result, "-[EOOrQualifier initWithQualifierArray:]"); 

  START_TEST(YES);
  END_TEST(result, "-[EOOrQualifier evaluateWithObject:]"); 
  {
    NSDictionary *dbDict1 = [NSDictionary dictionaryWithObject: @"Postgres95"
					  forKey: @"name"];
    NSDictionary *dbDict2 = [NSDictionary dictionaryWithObject: @"SQLite"
					  forKey: @"name"];
    NSDictionary *dbDict3 = [NSDictionary dictionaryWithObject: @"MySQL"
					  forKey: @"name"];
    NSDictionary *dbDict4 = [NSDictionary dictionaryWithObject: @"PostgresSQL"
					  forKey: @"name"];
    result = [qual evaluateWithObject: dbDict1] == NO;
    result = result && [qual evaluateWithObject: dbDict2];
    result = result && [qual evaluateWithObject: dbDict3];
    result = result && [qual evaluateWithObject: dbDict4] == NO;
  }
  END_SET("EOQualifier/EOOrQualifier00.m");

  [pool release];
  return (0);
}
