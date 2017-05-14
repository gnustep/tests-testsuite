/*
   Copyright (C) 2005 Free SoftwareFoundation, Inc.

   Written by: David Ayers <d.ayers@inode.at>
   Date: November 2005

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

/* This file tests Qualifiers containing unicode characters.  */

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  volatile BOOL result = NO;
  id tmp = nil;

  NSArray *qualOperatorArr;
  id qual;
  NSSet *keys;
  Class qCls = [EOQualifier class];

  START_SET("EOQualifier/"__FILE__);

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat:
		 [@"\"key = 'const\\U00C0\\U038F\\U4E20'\"" propertyList]];
  result = [qual isKindOfClass: [EOKeyValueQualifier class]];
  result = result && [[qual key] isEqual: @"key"];
  result = result && [[qual value] isEqual: 
				     [@"\"const\\U00C0\\U038F\\U4E20\"" propertyList]];
  result = result && sel_isEqual([qual selector], EOQualifierOperatorEqual);
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "Unicode: @'key = 'const$$$''");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat:
		 [@"\"(key = value) and (key2 = 'const\\U00C0\\U038F\\U4E20')\"" propertyList]];
  result = [qual isKindOfClass: [EOAndQualifier class]];
  result = result && [[qual qualifiers] count] == 2;
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "Unicode: @'(key = value) and (key2 = 'cont$$$')'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat:
		 [@"\"(key = value) and (key2 = 'const\\U00C0\\U038F\\U4E20') and (key3 = value3)\"" propertyList]];
  result = [qual isKindOfClass: [EOAndQualifier class]];
  result = result && [[qual qualifiers] count] == 3;
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "Unicode: @'(key = value) and (key2 = 'const$$$') and (key3 = value3)'");

  START_TEST(YES);
  qual = [qCls qualifierWithQualifierFormat:
		 [@"\"(key = value) or (key2 = 'const\\U00C0\\U038F\\U4E20')\"" propertyList]];
  result = [qual isKindOfClass: [EOOrQualifier class]];
  result = result && [[qual qualifiers] count] == 2;
  END_TEST(result, "+[EOQualifier qualifierWithQualifierFormat:] "
	   "Unicode: @'(key = value) or (key2 = 'const$$$')'");


  END_SET("EOQualifier/"__FILE__);

  [pool release];
  return (0);
}
