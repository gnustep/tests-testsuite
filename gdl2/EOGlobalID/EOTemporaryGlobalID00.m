/*
   Copyright (C) 2004 Free SoftwareFoundation, Inc.

   Written by: David Ayers <d.ayers@inode.at>
   Date: October 2008

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

#import <Foundation/Foundation.h>
#include <EOControl/EOControl.h>

#include "../GDL2Testing.h"


int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  volatile BOOL result = NO;
  id tmp = nil;
  unsigned i;
  EOGlobalID *gid1 = nil;
  EOGlobalID *gid2 = nil;
  NSMutableSet *gidset = [NSMutableSet setWithCapacity:300];

  START_SET("EOGlobalID/EOTemporaryGlobalID00.m");

  START_TEST(YES);
  gid1 = [EOTemporaryGlobalID temporaryGlobalID];
  result = [gid1 isKindOfClass:[EOTemporaryGlobalID class]];
  END_TEST(result, "[EOTemporaryGlobalID temporaryGlobalID]");

  START_TEST(YES);
  gid2 = [gid1 copy];
  result = gid1 == gid2;
  END_TEST(result, "[EOTemporaryGlobalID copy] returns reciever");

  START_TEST(YES);
  for (i=0;i<300;i++)
    {
      [gidset addObject:[EOTemporaryGlobalID temporaryGlobalID]];
    }
  result = i == [gidset count];
  END_TEST(result, "[EOTemporaryGlobalID temporaryGlobalID] is unique");

  END_SET("EOGlobalID/EOTemporaryGlobalID00.m");

  [pool release];
  return (0);
}






