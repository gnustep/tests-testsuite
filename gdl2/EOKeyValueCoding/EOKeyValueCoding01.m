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

#import <Foundation/Foundation.h>
#import <EOControl/EOControl.h>

#include "../GDL2Testing.h"

@interface Master : NSObject
{
  NSString *_name;
  NSMutableArray *_details;
}
@end
@interface Detail : NSObject
{
  NSString *_name;
  NSNumber *_value;
}
@end

@implementation Master
- (id)init
{
  if ((self=[super init]))
    {
      _details = [NSMutableArray new];
    }
  return self;
}
- (void)dealloc
{
  DESTROY(_name);
  DESTROY(_details);
  [super dealloc];
}

- (NSString *)name
{
  return _name;
}
- (void)setName: (NSString *)name
{
  [self willChange];
  ASSIGNCOPY(_name,name);
}
- (void)addToDetails: (id)detail
{
  [self willChange];
  [_details addObject: detail];
}
- (void)removeFromDetails: (id)detail
{
  [self willChange];
  [_details removeObject: detail];
}
@end

@implementation Detail
- (id)init
{
  if ((self=[super init]))
    {
    }
  return self;
}
- (void)dealloc
{
  DESTROY(_name);
  DESTROY(_value);
  [super dealloc];
}
- (NSString *)name
{
  return _name;
}
- (void)setName: (NSString *)name
{
  [self willChange];
  ASSIGNCOPY(_name,name);
}
- (NSNumber *)value
{
  return _value;
}
- (void)setValue: (NSNumber *)value
{
  [self willChange];
  ASSIGNCOPY(_value,value);
}

@end

@implementation NSArray (EOKeyValueCodingTesting)
-(id)computeFilteredArrayForKey: (NSString *)key
{
  unsigned int i, cnt;
  NSMutableArray *arr;
  id obj;

  cnt = [self count];
  arr = [NSMutableArray arrayWithCapacity: cnt];
  for (i=0; i<cnt;i++)
    {
      obj = [self objectAtIndex: i];
      if ([[obj valueForKey:key] intValue] > 1)
        {
          [arr addObject: obj];
        }
    }
  return arr;
}
@end

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  volatile BOOL result = NO;
  id tmp = nil;

  id master;
  id detail;
  NSDictionary *dict;

  START_SET("EOKeyValueCoding/EOKeyValueCoding00.m");

  master = [Master new];
  [master setName:@"master"];

  detail = [Detail new];
  [detail setName:@"detail 1"];
  [detail setValue:[NSNumber numberWithInt: 1]];
  [master addToDetails: detail];

  detail = [Detail new];
  [detail setName:@"detail 2"];
  [detail setValue:[NSNumber numberWithInt: 2]];
  [master addToDetails: detail];

  START_TEST(YES);
  result = [[master valueForKeyPath: @"details.@count.value"] intValue] == 2;
  END_TEST(result, 
	   "eo valueForKeyPath: @\"details.@count.value\"");

  START_TEST(YES);
  result = [[master valueForKeyPath: @"details.@count"] intValue] == 2;
  END_TEST(result, 
	   "eo valueForKeyPath: @\"details.@count\"");

  START_TEST(YES);
  result = [[master valueForKeyPath: @"details.@sum.value"] intValue] == 3;
  END_TEST(result, 
	   "eo valueForKeyPath: @\"details.@sum.value\"");

  START_TEST(YES);
  result = [[master valueForKeyPath: @"details.@filteredArray.value"] isEqual: [NSArray arrayWithObject:detail]];
  END_TEST(result,
	   "eo valueForKeyPath: @\"details.@filteredArray.value\"");

  dict = [NSDictionary dictionaryWithObject:[master valueForKey:@"details"] forKey:@"details"];
  
  START_TEST(YES);
  result = [[dict valueForKeyPath: @"details.@count.value"] intValue] == 2;
  END_TEST(result, 
	   "dict valueForKeyPath: @\"details.@count.value\"");

  START_TEST(YES);
  result = [[dict valueForKeyPath: @"details.@count"] intValue] == 2;
  END_TEST(result, 
	   "dict valueForKeyPath: @\"details.@count\"");

  START_TEST(YES);
  result = [[dict valueForKeyPath: @"details.@sum.value"] intValue] == 3;
  END_TEST(result, 
	   "dict valueForKeyPath: @\"details.@sum.value\"");

  START_TEST(YES);
  result = [[dict valueForKeyPath: @"details.@filteredArray.value"] isEqual: [NSArray arrayWithObject:detail]];
  END_TEST(result,
	   "dict valueForKeyPath: @\"details.@filteredArray.value\"");


  END_SET("EOKeyValueCoding/EOKeyValueCoding00.m");

  [pool release];
  return (0);
}
