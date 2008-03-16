/*
   Copyright (C) 2008 Free SoftwareFoundation, Inc.

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

void mybreak (void)
{}

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  volatile BOOL result = NO;
  id tmp = nil;

  NSString *plist = @"{displayGroup={allObjects=({detailArray=({value=4;},{value=2;});},{detailArray=({value=8;},{value=10;});});};}";
  NSDictionary *root = [plist propertyList];

  START_SET(YES);

  START_TEST(YES);
  mybreak();
  result = [[root valueForKeyPath:@"displayGroup.allObjects.@sum.detailArray.@avg.value"] intValue] == 12;
  END_TEST(result, "-[NSArray(EOKeyValueCoding) valueForKeyPath: @\"displayGroup.allObjects.@sum.detailArray.@avg.value\"]");

  START_TEST(YES);
  result = [[root valueForKeyPath:@"displayGroup.allObjects.@sum.detailArray.@count.value"] intValue] == 4;
  END_TEST(result, "-[NSArray(EOKeyValueCoding) valueForKeyPath: @\"displayGroup.allObjects.@sum.detailArray.@count.value\"]");

  START_TEST(YES);
  result = [[root valueForKeyPath:@"displayGroup.allObjects.@sum.detailArray.@count"] intValue] == 4;
  END_TEST(result, "-[NSArray(EOKeyValueCoding) valueForKeyPath: @\"displayGroup.allObjects.@sum.detailArray.@count\"]");

  END_SET("EOKeyValueCoding" __FILE__);

  [pool release];
  return (0);
}
