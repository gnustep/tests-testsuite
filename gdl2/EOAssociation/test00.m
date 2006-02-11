/*
   Copyright (C) 2004 Free Software Foundation, Inc.

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
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA.
  
 */

#include <Foundation/NSAutoreleasePool.h>
#include <EOControl/EOControl.h>
#include <EOAccess/EOAccess.h>
#include <EOInterface/EOInterface.h>

#include "../GDL2Testing.h"

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  id tmp = nil, tmp1 = nil, tmp2 = nil, tmp3 = nil;
  unsigned i,c;
  volatile BOOL result = NO;

  START_SET(YES);

  START_TEST(YES);
  tmp = [EOAssociation aspects];
  result = [tmp isKindOfClass: [NSArray class]];
  result = result && [tmp isKindOfClass: [NSMutableArray class]] == NO;
  END_TEST(result, "+[EOAssociation aspects]");

  START_TEST(YES);
  tmp = [EOAssociation alloc];
  result = tmp != nil;
  END_TEST(result, "+[EOAssociation alloc]");

  START_TEST(YES);
  tmp = [tmp initWithObject: nil];
  result = tmp != nil;
  END_TEST(result, "+[EOAssociation initWithObject:] (nil)");

  END_SET("EOAssociation/test00.m");

  [pool release];
  return (0);
}


