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
#include <Foundation/NSSet.h>
#include <Foundation/NSDecimalNumber.h>
#include <EOControl/EOControl.h>

#include "../GDL2Testing.h"

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  volatile BOOL result = NO;
  id tmp = nil;
  unsigned i;

  EOQualifier *qual;
  NSDictionary *dict1, *dict2, *dict3, *dict4, *dict5;
  NSArray *arr1, *arr1t, *arr1o, *arr2o;
  NSMutableArray *arr2, *arr2t;
  
  START_SET(YES);

  dict1 = [NSDictionary dictionaryWithObject: @"1" forKey: @"num"];
  dict2 = [NSDictionary dictionaryWithObject: @"2" forKey: @"num"];
  dict3 = [NSDictionary dictionaryWithObject: @"3" forKey: @"num"];
  dict4 = [NSDictionary dictionaryWithObject: @"4" forKey: @"num"];
  dict5 = [NSDictionary dictionaryWithObject: @"5" forKey: @"num"];

  arr1  = [NSArray arrayWithObjects: dict1, dict2, dict3, dict4, dict5, nil];
  arr1t = [NSArray arrayWithObjects: dict1, dict2, dict3, nil];

  arr2 = (id)[NSMutableArray array];
  arr2t = (id)[NSMutableArray array];

  for (i = 0; i < 5; i++)
    {
      [arr2 addObjectsFromArray: arr1];
      [arr2t addObjectsFromArray: arr1t];
    }
  
  START_TEST(YES);
  qual = [EOQualifier qualifierWithQualifierFormat: @"num < '4'"];
  arr1o = [arr1 filteredArrayUsingQualifier: qual];
  arr2o = [arr2 filteredArrayUsingQualifier: qual];

  result = [arr1o isEqual: arr1t];
  result = result && [arr2o isEqual: arr2t];
  END_TEST(result, "-[NSArray filteredArrayUsingQualifier:]");

  dict1 = [NSDictionary dictionaryWithObject: @"red" forKey: @"color"];
  dict2 = [NSDictionary dictionaryWithObject: @"black" forKey: @"color"];
  dict3 = [NSDictionary dictionaryWithObject: @"green" forKey: @"color"];
  dict4 = [NSDictionary dictionaryWithObject: @"light green" forKey: @"color"];
  dict5 = [NSDictionary dictionaryWithObject: @"dark red" forKey: @"color"];

  arr1 = [NSArray arrayWithObjects: dict1, dict2, dict3, dict4, dict5, nil];
  arr2 = [NSArray arrayWithObjects: dict3, dict4, nil];

  START_TEST(YES);
  qual = [EOQualifier qualifierWithQualifierFormat: @"color like '*green'"];
  arr1o = [arr1 filteredArrayUsingQualifier: qual];
  result = [[NSSet setWithArray: arr1o] isEqual: [NSSet setWithArray: arr2]];
  END_TEST(result, "-[NSArray filteredArrayUsingQualifier:] like");

  dict1 = [NSDictionary dictionaryWithObject: @"rot" forKey: @"farbe"];
  dict2 = [NSDictionary dictionaryWithObject: @"schwarz" forKey: @"farbe"];
  dict3 = [NSDictionary dictionaryWithObject: [@"\"gr\\U00FCn\\U00CA\\U4E50\"" propertyList] forKey: @"farbe"];
  dict4 = [NSDictionary dictionaryWithObject: [@"\"hellgr\\U00FCn\\U00CB\\U4E50\"" propertyList] forKey: @"farbe"];
  dict5 = [NSDictionary dictionaryWithObject: @"dunkel rot" forKey: @"farbe"];

  arr1 = [NSArray arrayWithObjects: dict1, dict2, dict3, dict4, dict5, nil];
  arr2 = [NSArray arrayWithObjects: dict3, dict4, nil];

  START_TEST(YES);
  qual = [EOQualifier qualifierWithQualifierFormat: [@"\"farbe like '*gr\\U00FCn?\\U4E50'\"" propertyList]];
  arr1o = [arr1 filteredArrayUsingQualifier: qual];
  result = [[NSSet setWithArray: arr1o] isEqual: [NSSet setWithArray: arr2]];
  END_TEST(result, "Unicode -[NSArray filteredArrayUsingQualifier:] like");

  END_SET("EOQualifier/"__FILE__);

  [pool release];
  return (0);
}
