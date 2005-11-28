/*
   Copyright (C) 2005 Free SoftwareFoundation, Inc.

   Written by: David Ayers <d.ayers@inode.at>
   Date: October 2005

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
  EOEditingContext *ec = nil;
  EOSharedEditingContext *sec = nil;
  id tmp = nil;

  START_SET(YES);

  START_TEST(YES);
  {
    ec = [EOEditingContext new];
    result = ([EOEditingContext sharedContext] == nil);
  }
  END_TEST(result, "+[EOEditingContext sharedContext] nil");

  START_TEST(YES);
  {
    sec = [EOSharedEditingContext defaultSharedEditingContext];
    result = ([sec isKindOfClass: [EOSharedEditingContext class]]);
  }
  END_TEST(result, "+[EOEditingContext defaultSharedEditingContext]");

  START_TEST(YES);
  {
    result = ([EOEditingContext sharedContext] == sec);
  }
  END_TEST(result, "sharedContext updated in empty ec's");

  START_TEST(YES);
  {
    ec = [EOEditingContext new];
    result = ([EOEditingContext sharedContext] == sec);
  }
  END_TEST(result, "+[EOEditingContext sharedContext] sec");

  END_SET("EOSharedEditingContext/"__FILE__);

  [pool release];
  return (0);
}
