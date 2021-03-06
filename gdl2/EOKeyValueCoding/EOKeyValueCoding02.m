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

@implementation NSArray (EOKeyValueCodingTesting)
-(id)computeStandardDeviationForKey: (NSString *)key
{
  NSNumber       *ret = nil;
  NSDecimal      mean, result, left, right;
  NSRoundingMode mode;
  unsigned int   count = 0;
  double         d;

  mode = [[NSDecimalNumber defaultBehavior] roundingMode];
  count = [self count];
  NSDecimalFromComponents(&result, 0, 0, NO);

  if (count>0)
    {
      unsigned int i;

      mean = [[self computeAvgForKey: key] decimalValue];
      
      for (i=0; i<count; i++)
        {
	  NSDecimal val, variance;
          val = [[[self objectAtIndex:i] valueForKeyPath: key] decimalValue];
          NSDecimalSubtract(&variance, &mean, &val, mode);
	  NSDecimalPower(&variance, &variance, 2, mode);
	  NSDecimalAdd(&result, &result, &variance, mode);
        }
    }
  else
    {
      return [NSDecimalNumber zero];
    }

  left = result;

  NSDecimalFromComponents(&right, (unsigned long long) count, 0, NO);
  NSDecimalDivide(&result, &left, &right, mode);
  d = NSDecimalDouble(&result);
  d = sqrt(d);

  ret = [NSNumber numberWithDouble: d];

  return ret;
}
@end

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  volatile BOOL result = NO;
  id tmp = nil;

  NSString *plist = @"{displayGroup={allObjects=({detailArray=({value=4;},{value=2;});},{detailArray=({value=8;},{value=10;});});};}";
  NSDictionary *root = [plist propertyList];

  START_SET("EOKeyValueCoding" __FILE__);

  START_TEST(YES);
  result = [[root valueForKeyPath:@"displayGroup.allObjects.@sum.detailArray.@avg.value"] intValue] == 12;
  END_TEST(result, "-[NSArray(EOKeyValueCoding) valueForKeyPath: @\"displayGroup.allObjects.@sum.detailArray.@avg.value\"]");

  START_TEST(YES);
  result = [[root valueForKeyPath:@"displayGroup.allObjects.@sum.detailArray.@count.value"] intValue] == 4;
  END_TEST(result, "-[NSArray(EOKeyValueCoding) valueForKeyPath: @\"displayGroup.allObjects.@sum.detailArray.@count.value\"]");

  START_TEST(YES);
  result = [[root valueForKeyPath:@"displayGroup.allObjects.@sum.detailArray.@count"] intValue] == 4;
  END_TEST(result, "-[NSArray(EOKeyValueCoding) valueForKeyPath: @\"displayGroup.allObjects.@sum.detailArray.@count\"]");

  START_TEST(YES);
  result = [[root valueForKeyPath:@"displayGroup.allObjects.@standardDeviation.detailArray.@avg.value"] intValue] == 3;
  END_TEST(result, "-[NSArray(EOKeyValueCoding) valueForKeyPath: @\"displayGroup.allObjects.@standardDeviation.detailArray.@avg.value\"]");

  START_TEST(YES);
  result = [[root valueForKeyPath:@"displayGroup.allObjects.@sum.detailArray.@standardDeviation.value"] intValue] == 2;
  END_TEST(result, "-[NSArray(EOKeyValueCoding) valueForKeyPath: @\"displayGroup.allObjects.@sum.detailArray.@standardDeviation.value\"]");

  END_SET("EOKeyValueCoding" __FILE__);

  [pool release];
  return (0);
}
