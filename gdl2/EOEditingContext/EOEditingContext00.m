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
  EOEditingContext *ec1 = nil;
  EOEditingContext *ec2 = nil;
  id tmp = nil;

  START_SET(YES);

  START_TEST(YES);
  {
    NSTimeInterval ti = [EOEditingContext defaultFetchTimestampLag];
    result = ti == 3600.0;
  }
  END_TEST(result, "+[EOEditingContext defaultFetchTimestampLag]");

  START_TEST(YES);
  {
    NSTimeInterval ti;
    [EOEditingContext setDefaultFetchTimestampLag: 360.0];
    ti = [EOEditingContext defaultFetchTimestampLag];
    result = ti == 360.0;
  }
  END_TEST(result, "+[EOEditingContext setDefaultFetchTimestampLag:]");

  START_TEST(YES);
  ec1 = [EOEditingContext new];
  result = ec1 != nil,
  END_TEST(result, "+[EOEditingContext new]");

  START_TEST(YES);
  ec2 = [[EOEditingContext alloc] initWithParentObjectStore: nil];
  result = ec2 != nil,
  END_TEST(result, "-[EOEditingContext initWithParentObjectStore:]");

  START_TEST(YES);
  tmp = [ec1 parentObjectStore];
  result = tmp != nil;
  END_TEST(result, "-[EOEditingContext parentObjectStore]");

  START_TEST(YES);
  tmp = [ec2 rootObjectStore];
  result = tmp != nil;
  END_TEST(result, "-[EOEditingContext parentObjectStore]");

  START_TEST(YES);
  result = [[ec1 parentObjectStore] isEqual: [ec2 rootObjectStore]];
  END_TEST(result, "-[EOEditingContext parent/rootObjectStore]");

  END_SET("EOEditingContext/EOEditingContext00.m");

  [pool release];
  return (0);
}
