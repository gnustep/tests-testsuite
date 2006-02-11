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

static BOOL
obj_arr_eq(id *p1, id *p2, unsigned n)
{
  BOOL result = YES;
  unsigned i;
  for (i=0; i<n; i++)
    result = result && [p1[i] isEqual: p2[i]];
  return result;
}


int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  volatile BOOL result = NO;
  id tmp = nil;
  EOKeyGlobalID *gid1 = nil;
  EOKeyGlobalID *gid2 = nil;
  EOKeyGlobalID *gid3 = nil;

  START_SET(YES);

  START_SET(YES);
  {
    NSArray *keyValArr1 = [NSArray arrayWithObjects:
				     @"keyVal1", @"keyVal2", nil];
    NSArray *keyValArr2 = [[keyValArr1 description] propertyList];
    NSArray *keyValArr3 = nil;

    NSString *keyVal1[2];
    NSString *keyVal2[2];
    NSString *keyVal3[2];

    keyValArr3 = [keyValArr2 mutableCopy];
    [(id)keyValArr3 replaceObjectAtIndex: 1 withObject: @"keyVal3"];

    [keyValArr1 getObjects: keyVal1];
    [keyValArr2 getObjects: keyVal2];
    [keyValArr3 getObjects: keyVal3];

    NSCAssert(keyVal1[0]!=keyVal2[0], @"Preperation failed 1");
    NSCAssert(keyVal1[1]!=keyVal2[1], @"Preperation failed 2");
    NSCAssert([keyValArr1 isEqual: keyValArr2], @"Preperation failed 3");
    NSCAssert([keyValArr1 isEqual: keyValArr3] == NO, @"Preperation failed 4");

    gid1 = [EOKeyGlobalID globalIDWithEntityName: @"MyEntity"
			  keys: keyVal1
			  keyCount: 2
			  zone: 0];
    gid2 = [EOKeyGlobalID globalIDWithEntityName: @"MyEntity"
			  keys: keyVal2
			  keyCount: 2
			  zone: 0];
    gid3 = [EOKeyGlobalID globalIDWithEntityName: @"MyEntity"
			  keys: keyVal3
			  keyCount: 2
			  zone: 0];

    START_TEST(YES);

    result = [[gid1 entityName] isEqual: @"MyEntity"];
    result = result && [[gid2 entityName] isEqual: @"MyEntity"];
    result = result && [[gid3 entityName] isEqual: @"MyEntity"];

    END_TEST(result,
	   "+[EOKeyGlobalID globalIDWithEntityName:keys:keyCount:zone:] "
	   "-[EOKeyGlobalID entityName]");

    START_TEST(YES);
    result = ([gid1 keyCount] == 2 
	      && [gid2 keyCount] == 2
	      && [gid3 keyCount] == 2);
    END_TEST(result,
	   "+[EOKeyGlobalID globalIDWithEntityName:keys:keyCount:zone:] "
	   "-[EOKeyGlobalID keyCount]");

    START_TEST(YES);
    result = obj_arr_eq ([gid1 keyValues], keyVal1, 2);
    result = result && obj_arr_eq ([gid2 keyValues], keyVal2, 2);
    result = result && obj_arr_eq ([gid3 keyValues], keyVal3, 2);
    END_TEST(result,
	   "+[EOKeyGlobalID globalIDWithEntityName:keys:keyCount:zone:] "
	   "-[EOKeyGlobalID keyValues]");

    START_TEST(YES);
    result = [[gid1 keyValuesArray] isEqual: keyValArr1];
    result = result && [[gid2 keyValuesArray] isEqual: keyValArr2];
    result = result && [[gid3 keyValuesArray] isEqual: keyValArr3];
    END_TEST(result,
	   "+[EOKeyGlobalID globalIDWithEntityName:keys:keyCount:zone:] "
	   "-[EOKeyGlobalID keyValuesArray] 1");

    START_TEST(YES);
    result = [[gid1 keyValuesArray] isEqual: keyValArr2];
    END_TEST(result,
	   "+[EOKeyGlobalID globalIDWithEntityName:keys:keyCount:zone:] "
	   "-[EOKeyGlobalID keyValuesArray] 2");

  }
  END_SET("+[EOKeyGlobalID globalIDWithEntityName:keys:keyCount:zone:]");

  START_TEST(YES);
  result = [gid1 hash] == [gid2 hash];

  /* The following two tests are technically wrong 
     but let's enforce "good" hash values.  */

  result = result && [gid1 hash] != [gid3 hash];
  result = result && [gid2 hash] != [gid3 hash];

  END_TEST(result, "EOKeyGlobalID hash values");

  START_TEST(YES);
  result = [gid1 isEqual: gid2];
  result = result && [gid2 isEqual: gid1];
  result = result && [gid1 isEqual: gid3] == NO;
  result = result && [gid3 isEqual: gid1] == NO;
  result = result && [gid2 isEqual: gid3] == NO;
  result = result && [gid3 isEqual: gid2] == NO;

  END_TEST(result, "EOKeyGlobalID comparisons");

  END_SET("EOGlobalID/EOKeyGlobalID00.m");

  [pool release];
  return (0);
}






