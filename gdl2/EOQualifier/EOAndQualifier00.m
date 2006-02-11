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

#include <Foundation/Foundation.h>
#include <EOControl/EOControl.h>

#include "../GDL2Testing.h"

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  volatile BOOL result = NO;
  id tmp = nil;
  EOQualifier *qual;

  START_SET(YES);

  START_TEST(YES);
  {
    NSArray *setQualArr = nil;
    NSArray *getQualArr = nil;
    EOKeyValueQualifier *keyValQual1 = nil;
    EOKeyValueQualifier *keyValQual2 = nil;
    EOKeyValueQualifier *keyValQual3 = nil;

    START_SET(YES);
    result = NO;
    keyValQual1 
      = [[EOKeyValueQualifier alloc] initWithKey: @"name"
				     operatorSelector:
				       EOQualifierOperatorGreaterThan
				     value: @"MySQL"];
    keyValQual2 
      = [[EOKeyValueQualifier alloc] initWithKey: @"name"
				     operatorSelector:
				    EOQualifierOperatorLessThanOrEqualTo
				     value: @"PostgresSQL"];
    setQualArr 
      = [NSArray arrayWithObjects: keyValQual1, keyValQual2, nil];
    END_SET("Prepare: -[EOAndQualifier initWithQualifierArray:]");

    qual = [[EOAndQualifier alloc] initWithQualifierArray: setQualArr];

    START_SET(YES);
    {
      BOOL local;
      NSSet *setQualSet;
      NSSet *getQualSet;
      getQualArr = [(EOAndQualifier *)qual qualifiers];

      setQualSet = [NSSet setWithArray: setQualArr];
      getQualSet = [NSSet setWithArray: getQualArr];

      local = [getQualSet isEqual: setQualSet];
      local = local && [getQualSet containsObject: keyValQual1];
      local = local && [getQualSet containsObject: keyValQual2];
      result = local;
    }
    END_SET("Evaluate: -[EOAndQualifier initWithQualifierArray:]");
  }
  END_TEST(result, "-[EOAndQualifier initWithQualifierArray:]"); 
  START_TEST(YES);
  {
    NSDictionary *dbDict1
      = [NSDictionary dictionaryWithObject: @"Postgres95"
		      forKey: @"name"];
    NSDictionary *dbDict2
      = [NSDictionary dictionaryWithObject: @"SQLite"
		      forKey: @"name"];
    NSDictionary *dbDict3
      = [NSDictionary dictionaryWithObject: @"MySQL"
		      forKey: @"name"];
    NSDictionary *dbDict4
      = [NSDictionary dictionaryWithObject: @"PostgresSQL"
		      forKey: @"name"];
      
    result = [qual evaluateWithObject: dbDict1];
    result = result && [qual evaluateWithObject: dbDict2] == NO;
    result = result && [qual evaluateWithObject: dbDict3] == NO;
    result = result && [qual evaluateWithObject: dbDict4];
  }
  END_TEST(result, "-[EOAndQualifier evaluateWithObject:]"); 

  [qual release];

  END_SET("EOQualifier/EOAndQualifier00.m");

  [pool release];
  return (0);
}


