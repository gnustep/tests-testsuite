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
  EOKeyValueQualifier *qual;

  START_SET("EOQualifier/EOKeyValueQualifier00.m");

  START_TEST(YES);
  qual = [[EOKeyValueQualifier alloc] initWithKey: @"name"
				      operatorSelector: 
					EOQualifierOperatorGreaterThan
				      value: @"PostgresSQL"];
  result = [[qual key] isEqual: @"name"];
  result = result && sel_isEqual([qual selector], EOQualifierOperatorGreaterThan);
  result = result && [[qual value] isEqual: @"PostgresSQL"];
  END_TEST(result,
	   "-[EOKeyValueQualifier initWithKey:operatorSelector:value:]");

  START_TEST(YES);
  {
    NSDictionary *dbDict1 = [NSDictionary dictionaryWithObject: @"MySQL"
					  forKey: @"name"];
    NSDictionary *dbDict2 = [NSDictionary dictionaryWithObject: @"PostgresSQL"
					  forKey: @"name"];
    NSDictionary *dbDict3 = [NSDictionary dictionaryWithObject: @"SQLite"
					  forKey: @"name"];

    result = [qual evaluateWithObject: dbDict1] == NO;
    result = result && [qual evaluateWithObject: dbDict2] == NO;
    result = result && [qual evaluateWithObject: dbDict3];
  }
  END_TEST(result, "-[EOKeyValueQualifier evaluateWithObject:]");

  END_SET("EOQualifier/EOKeyValueQualifier00.m");

  [pool release];
  return (0);
}
