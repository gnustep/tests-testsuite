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

@interface EOKVCTester : NSObject
{
  id  obj_iv;
  id  _obj_iv;
  id  _other_obj_iv;

  id _objGet;

  int _int_iv;
  int _other_int_iv;
}
@end

@implementation EOKVCTester
- (NSString *)description
{
  return [NSString stringWithFormat:
                     @"obj_iv = '%@'\n"
		   @"_obj_iv = '%@'\n"
		   @"_other_obj_iv = '%@'\n"
		   @"_int_iv = %i\n"
		   @"_other_int_iv = %i",
                   obj_iv, _obj_iv, _other_obj_iv,
                   _int_iv, _other_int_iv];
}
- (void)unableToSetNilForKey: (NSString *)key
{
  if ([key isEqualToString: @"int_iv"])
    {
      _int_iv = 0;
    }
  else
    {
      [super unableToSetNilForKey: key];
    }
}
- (id)getObjGet
{
  return [[_objGet description]
           stringByAppendingFormat: @"|%@", NSStringFromSelector(_cmd)];
}
- (void)setObjGet:(id)val
{
  [_objGet autorelease];
  _objGet = [[val description]
	      stringByAppendingFormat: @"|%@", NSStringFromSelector(_cmd)];
  [_objGet retain];
}
- (id)_getObjGet
{
  return [[_objGet description]
           stringByAppendingFormat: @"|%@", NSStringFromSelector(_cmd)];
}
- (void)_setObjGet:(id)val
{
  [_objGet autorelease];
  _objGet = [[val description]
	      stringByAppendingFormat: @"|%@", NSStringFromSelector(_cmd)];
  [_objGet retain];
}
- (id)objGet
{
  return [[_objGet description]
           stringByAppendingFormat: @"|%@", NSStringFromSelector(_cmd)];
}
- (id)_objGet
{
  return [[_objGet description]
           stringByAppendingFormat: @"|%@", NSStringFromSelector(_cmd)];
}
@end

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
-(id)computeFilteredArrayForKey: (NSString *)key
{
  unsigned int i, cnt;
  NSMutableArray *arr;
  id obj;

  if ([key length] == 0)
    {
      return self;
    }

  cnt = [self count];
  arr = [NSMutableArray arrayWithCapacity: cnt];
  for (i=0; i<cnt;i++)
    {
      obj = [self objectAtIndex: i];
      if ([obj intValue] == [key intValue])
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

  id obj = [EOKVCTester new];
  NSArray *arr0 = [NSArray array];
  NSArray *arr1 = [NSArray arrayWithObject: @"10"];
  NSArray *arr2 = [arr1 arrayByAddingObject: @"20"];
  NSDictionary *dic0 = [NSDictionary dictionary];
  NSDictionary *dic1 = [NSDictionary dictionaryWithObject: @"10" 
				     forKey: @"k1"];
  NSMutableDictionary *mdic0 = (id)[NSMutableDictionary dictionary];
  EONull *null = [EONull null];

  START_SET(YES);

  START_TEST(YES);
  [EOKVCTester flushAllKeyBindings];
  END_TEST(YES, "+[NSObject(EOKeyValueCoding) flushAllKeyBindings]");

  START_TEST(YES);
  [obj takeValue: @"obj_val" forKey: @"obj_iv"];
  [obj takeValue: @"_obj_val" forKey: @"_obj_iv"];
  [obj takeValue: @"_obj_other_val" forKey: @"other_obj_iv"];

  result = [[obj valueForKey: @"obj_iv"] isEqual: @"obj_val"];
  result = result
    && [[obj valueForKey: @"_obj_iv"] isEqual: @"_obj_val"];
  result = result 
    && [[obj valueForKey: @"other_obj_iv"] isEqual: @"_obj_other_val"];
  result = result 
    && [[obj valueForKey: @"_other_obj_iv"] isEqual: @"_obj_other_val"];
  END_TEST(result,
	   "-[NSObject(EOKeyValueCoding) takeValue:forKey:/valueForKey:](iv)");

  START_TEST(YES);
  [obj takeStoredValue: @"obj_val" forKey: @"objGet"];
  tmp = @"obj_val|_setObjGet:|getObjGet";
  result = [[obj valueForKey: @"objGet"] isEqual: tmp];
  END_TEST(result,
	   "-[NSObject(EOKeyValueCoding) "
	   "takeStoredValue:forKey:/valueForKey:](get)");

  START_TEST(YES);
  [obj takeValue: @"obj_val" forKey: @"objGet"];
  tmp = @"obj_val|setObjGet:|_getObjGet";
  result = [[obj storedValueForKey: @"objGet"] isEqual: tmp];
  END_TEST(result,
	   "-[NSObject(EOKeyValueCoding) "
	   "takeValue:forKey:/storedValueForKey:](set)");

  START_TEST(YES);
  /* unableToSetNilForKey is implemented and checks for this variable
     this test should not raise. */
  [obj takeValue: null forKey: @"int_iv"];
  [obj takeValue: nil forKey: @"int_iv"];
  END_TEST(result, "-[NSObject(EOKeyValueCoding) unableToSetNilForKey:]");

  obj = [EOKVCTester new];
  TEST_EXCEPTION(([obj takeValue: null forKey: @"other_int_iv"]); , 
		 NSInvalidArgumentException, YES,
		 "-[NSObject(EOKeyValueCoding) unableToSetNilForKey:]"
		 " raise (EONull)");
  TEST_EXCEPTION(([obj takeValue: nil forKey: @"other_int_iv"]); , 
		 NSInvalidArgumentException, YES,
		 "-[NSObject(EOKeyValueCoding) unableToSetNilForKey:]"
		 " raise (nil)");

  /* NSArray */
  START_TEST(YES);
  result = [[arr0 computeCountForKey: @"intValue"] intValue] == 0;
  result = result && [[arr1 computeCountForKey: @"intValue"] intValue] == 1;
  result = result && [[arr2 computeCountForKey: @"intValue"] intValue] == 2;
  END_TEST(result, "-[NSArray(EOKeyValueCoding) computeCountForKey: ]");

  START_TEST(YES);
  result = [[arr0 computeSumForKey: @"intValue"] intValue] == 0;
  result = result && [[arr1 computeSumForKey: @"intValue"] intValue] == 10;
  result = result && [[arr2 computeSumForKey: @"intValue"] intValue] == 30;
  END_TEST(result, "-[NSArray(EOKeyValueCoding) computeSumForKey: ]");

  START_TEST(YES);
  result = [[arr0 computeAvgForKey: @"intValue"] intValue] == 0;
  result = result && [[arr1 computeAvgForKey: @"intValue"] intValue] == 10;
  result = result && [[arr2 computeAvgForKey: @"intValue"] intValue] == 15;
  END_TEST(result, "-[NSArray(EOKeyValueCoding) computeAvgForKey: ]");

  START_TEST(YES);
  result = [[arr0 computeMinForKey: @"intValue"] intValue] == 0;
  result = result && [[arr1 computeMinForKey: @"intValue"] intValue] == 10;
  result = result && [[arr2 computeMinForKey: @"intValue"] intValue] == 10;
  END_TEST(result, "-[NSArray(EOKeyValueCoding) computeMinForKey: ]");

  START_TEST(YES);
  result = [[arr0 computeMaxForKey: @"intValue"] intValue] == 0;
  result = result && [[arr1 computeMaxForKey: @"intValue"] intValue] == 10;
  result = result && [[arr2 computeMaxForKey: @"intValue"] intValue] == 20;
  END_TEST(result, "-[NSArray(EOKeyValueCoding) computeMaxForKey: ]");

  /* This special case key is often used in WO key bindings.   */
  START_TEST(YES); 
  result = [[arr0 valueForKey: @"count"] intValue] == 0;
  result = result && [[arr1 valueForKey: @"count"] intValue] == 1;
  result = result && [[arr2 valueForKey: @"count"] intValue] == 2;
  END_TEST(result, "-[NSArray(EOKeyValueCoding) valueForKey: @\"count\"]");

  START_TEST(YES);
  result = [[arr0 valueForKey: @"@count"] intValue] == 0;
  result = result && [[arr1 valueForKey: @"@count"] intValue] == 1;
  result = result && [[arr2 valueForKey: @"@count"] intValue] == 2;
  END_TEST(result, "-[NSArray(EOKeyValueCoding) valueForKey: @\"@count\"]");

  START_TEST(YES);
  result = [[arr0 valueForKey: @"@count.intValue"] intValue] == 0;
  result = result && [[arr1 valueForKey: @"@count.intValue"] intValue] == 1;
  result = result && [[arr2 valueForKey: @"@count.intValue"] intValue] == 2;
  END_TEST(result, 
	   "-[NSArray(EOKeyValueCoding) valueForKey: @\"@count.intValue\"]");

  START_TEST(YES);
  result = [[arr0 valueForKey: @"@sum.intValue"] intValue] == 0;
  result = result && [[arr1 valueForKey: @"@sum.intValue"] intValue] == 10;
  result = result && [[arr2 valueForKey: @"@sum.intValue"] intValue] == 30;
  END_TEST(result, 
	   "-[NSArray(EOKeyValueCoding) valueForKey: @\"@sum.intValue\"]");

  START_TEST(YES);
  result = [[arr0 valueForKey: @"@avg.intValue"] intValue] == 0;
  result = result && [[arr1 valueForKey: @"@avg.intValue"] intValue] == 10;
  result = result && [[arr2 valueForKey: @"@avg.intValue"] intValue] == 15;
  END_TEST(result, 
	   "-[NSArray(EOKeyValueCoding) valueForKey: @\"@avg.intValue\"]");

  START_TEST(YES);
  result = [[arr0 valueForKey: @"@min.intValue"] intValue] == 0;
  result = result && [[arr1 valueForKey: @"@min.intValue"] intValue] == 10;
  result = result && [[arr2 valueForKey: @"@min.intValue"] intValue] == 10;
  END_TEST(result, 
	   "-[NSArray(EOKeyValueCoding) valueForKey: @\"@min.intValue\"]");

  START_TEST(YES);
  result = [[arr0 valueForKey: @"@max.intValue"] intValue] == 0;
  result = result && [[arr1 valueForKey: @"@max.intValue"] intValue] == 10;
  result = result && [[arr2 valueForKey: @"@max.intValue"] intValue] == 20;
  END_TEST(result, 
	   "-[NSArray(EOKeyValueCoding) valueForKey: @\"@max.intValue\"]");

  START_TEST(YES);
  tmp = [NSArray arrayWithObjects:
		   [NSNumber numberWithInt: 10],
		 [NSNumber numberWithInt: 20], nil];
  result = [[arr2 valueForKey: @"intValue"] isEqual: tmp];
  END_TEST(result, "-[NSArray(EOKeyValueCoding) valueForKey: @\"intValue\"]");

  START_TEST(YES);
  tmp = @"@max.intValue.description";
  result = [arr0 valueForKeyPath: tmp] == nil;
  result = result && [[arr1 valueForKeyPath: tmp] isEqual: @"10"];
  result = result && [[arr2 valueForKeyPath: tmp] isEqual: @"20"];
  END_TEST(result, "-[NSArray(EOKeyValueCoding) valueForKeyPath:]");

  START_TEST(YES);
  result =           [[arr2 valueForKey: @"@standardDeviation.doubleValue"] intValue] == 5;
  result = result && [[arr2 valueForKeyPath: @"@standardDeviation.doubleValue"] intValue] == 5;
  END_TEST(result,"-[NSArray(EOKeyValueCoding) valueForKey: @\"@standardDeviation.decimalValue\"]");

  START_TEST(YES);
  result =           [[arr2 valueForKey: @"@filteredArray.10"] isEqual: arr1];
  result = result && [[arr2 valueForKeyPath: @"@filteredArray.10"] isEqual: arr1];
  END_TEST(result,"-[NSArray(EOKeyValueCoding) valueForKey: @\"@filteredArray.10\"]");

  /* Fails on WO45 */
  START_TEST(YES);
  result = [[dic0 valueForKey: @"allValues"] isEqual: arr0];
  result = result && [[dic1 valueForKey: @"allValues"] isEqual: arr1];
  END_TEST(result,
	   "-[NSDictionary(EOKeyValueCoding) valueForKey:@\"allValues\"]");

  /* Fails on WO45 */
  START_TEST(YES);
  tmp = [NSArray arrayWithObject: @"k1"];
  result = [[dic0 valueForKey: @"allKeys"] isEqual: arr0];
  result = result && [[dic1 valueForKey: @"allKeys"] isEqual: tmp];
  END_TEST(result,
	   "-[NSDictionary(EOKeyValueCoding) valueForKey:@\"allKeys\"]");

  /* Fails on WO45 */
  START_TEST(YES);
  result = [[dic0 valueForKey: @"count"] intValue] == 0;
  result = result && [[dic1 valueForKey: @"count"] intValue] == 1;
  END_TEST(result, "-[NSDictionary(EOKeyValueCoding) valueForKey:@\"count\"]");

  START_TEST(YES);
  [mdic0 takeValue: @"val" forKey: @"key"];
  result = [[mdic0 valueForKey: @"key"] isEqual: @"val"];
  END_TEST(result, "-[NSDictionary(EOKeyValueCoding) take/valueForKey:]");

  /* Fails on WO45 */
  START_TEST(YES);
  result = [[dic0 storedValueForKey: @"allValues"] isEqual: arr0];
  result = result && [[dic1 storedValueForKey: @"allValues"] isEqual: arr1];
  END_TEST(result,
	   "-[NSDictionary(EOKeyValueCoding) "
	   "storedValueForKey:@\"allValues\"]");

  /* Fails on WO45 */
  START_TEST(YES);
  tmp = [NSArray arrayWithObject: @"k1"];
  result = [[dic0 storedValueForKey: @"allKeys"] isEqual: arr0];
  result = result && [[dic1 storedValueForKey: @"allKeys"] isEqual: tmp];
  END_TEST(result,
	   "-[NSDictionary(EOKeyValueCoding) "
	   "storedValueForKey:@\"allKeys\"]");

  /* Fails on WO45 */
  START_TEST(YES);
  result = [[dic0 storedValueForKey: @"count"] intValue] == 0;
  result = [[dic1 storedValueForKey: @"count"] intValue] == 1;
  END_TEST(result,
	   "-[NSDictionary(EOKeyValueCoding) storedValueForKey:@\"count\"]");

  START_TEST(YES);
  [mdic0 takeStoredValue: @"storedval" forKey: @"key"];
  result = [[mdic0 storedValueForKey: @"key"] isEqual: @"storedval"];
  END_TEST(result,
	   "-[NSDictionary(EOKeyValueCoding) take/storedValueForKey:]");

#ifndef GDL2
#define GDL2 0
#endif

  /* GDL2 Extensions. */
  START_TEST(GDL2);
  [mdic0 smartTakeValue: @"smartval" forKey: @"key"];
  result = [[mdic0 valueForKey: @"key"] isEqual: @"smartval"];
  END_TEST(result,
	   "-[NSObject(EOKVCGDL2Additions) smart(Take)ValueForKey:]");

  START_TEST(GDL2);
  [mdic0 takeValue: dic1 forKey: @"quoted.key.path"];
  NSLog(@"%@", mdic0);
  NSLog(@"%@",[mdic0 valueForKey: @"'quoted.key.path'"]);
  NSLog(@"%@",[[mdic0 valueForKey: @"'quoted.key.path'"] valueForKey:@"k1"]);
  NSLog(@"%@",[mdic0 valueForKey: @"'quoted.key.path'.k1"]);
  NSLog(@"%@",[mdic0 valueForKeyPath: @"'quoted.key.path'.k1"]);
  result = [[mdic0 valueForKeyPath: @"'quoted.key.path'.k1"] isEqual: @"10"];
  NSLog(@"result1:%d",result);
  result = result && [[mdic0 valueForKeyPath: @"quoted.key.path"] isEqual: dic1];
  NSLog(@"result2:%d",result);
  result = result && [mdic0 valueForKeyPath: @"quoted.key.path.k1"] == nil;
  NSLog(@"result3:%d",result);
  END_TEST(result,
	   "-[NSDictionary(EOKeyValueCoding) take/valueForKeyPath:]");

  END_SET("EOKeyValueCoding/EOKeyValueCoding00.m");

  [pool release];
  return (0);
}
