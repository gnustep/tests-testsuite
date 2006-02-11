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
#include <EOAccess/EOAccess.h>

#include "../GDL2Testing.h"

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  volatile BOOL result = NO;
  volatile BOOL result1 = NO;
  id tmp = nil;
  id plist = nil;
  NSString *filePath;

  EOModel  *model = nil;
  START_SET(YES);

  /* Load eomodel file.  */
  START_TEST(YES);
  filePath = NSTemporaryDirectory();
  filePath = [filePath stringByAppendingPathComponent: @"test02.eomodeld"];
  model = [[EOModel alloc] initWithContentsOfFile: filePath];
  result = model != nil;
  END_TEST(result, "-[EOModel initWithConentsOfFile:] " __FILE__); 

  /* Save as eomodeld file.  */
  START_TEST(YES);
  filePath = NSTemporaryDirectory();
  filePath = [filePath stringByAppendingPathComponent: @"test03.eomodeld"];
  [model writeToFile: filePath];
  result = [[NSFileManager defaultManager] fileExistsAtPath: filePath
					   isDirectory: &result1];
  result = result && result1;
  END_TEST(result, "-[EOModel writeToFile:]" __FILE__); 
  END_SET("EOModel/" __FILE__);

  [pool release];
  return (0);
}


