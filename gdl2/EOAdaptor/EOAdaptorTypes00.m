/*
   Copyright (C) 2004 Free Software Foundation, Inc.

   Written by: David Ayers <d.ayers@inode.at>
   Date: February 2005
   
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

#include <Foundation/Foundation.h>
#include <EOAccess/EOAccess.h>

#include "../GDL2Testing.h"
@interface NSObject(GDL2Testing)
- (BOOL) testIsEqual:(id)obj;
@end

@implementation NSObject(GDL2Testing)
- (BOOL) testIsEqual:(id)obj;
{
  return [self isEqual:obj];
}
@end

@interface NSCalendarDate (GDL2Testing)
- (BOOL) testIsEqual:(id)obj;
@end

@implementation NSCalendarDate (GDL2Testing)
- (BOOL) testIsEqual:(id)obj
{
  // adaptors can change the time.
  if (self == obj) return YES;
  if (![obj isKindOfClass:[NSCalendarDate class]]) return NO;
  return ([self dayOfMonth] == [obj dayOfMonth]
	  && [self monthOfYear] == [obj monthOfYear]
	  && [self yearOfCommonEra] == [obj yearOfCommonEra]);
}
@end

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  NSArray   *adaptorNamesArr = nil;

  NSFileManager *mgr = [NSFileManager defaultManager];
  NSString  *currAdaptorName;
  EOAdaptor *currAdaptor = nil;
  EOAdaptorContext *currAdaptorContext = nil;
  EOAdaptorChannel *currAdaptorChannel = nil;
  Class    currAdaptorExprClass = 0;

  EOModel *model;
  EOEntity *entity;
  EOClassDescription *cd;
  NSString *filePath;
  EOEditingContext *ec;
  NSArray *attributes;

  id obj = nil, tmp = nil, tmp1 = nil, tmp2 = nil, tmp3 = nil, tmp4 = nil;
  volatile BOOL result = NO;
  unsigned tmpData[32];

  memset(&tmpData, 1, 32);
  memset(&tmpData, 0, 16);

  /*  Now we have the testcases for the installed Adaptors.  */

  START_SET("EOAdaptor/EOAdaptorTypes00.m");

      model = [[EOModel alloc] initWithContentsOfFile: @"EOAdaptorTypes.eomodel"];
      NSCAssert(model, @"Failed to load model. ");
      currAdaptorName = setupModel(model);
      
      START_TEST(YES)
      adaptorNamesArr = [EOAdaptor availableAdaptorNames];
      result = [adaptorNamesArr containsObject: currAdaptorName];
      END_TEST(result, "availableAdaptorNames contains '%s'", [currAdaptorName UTF8String]);
	      
      currAdaptor = [EOAdaptor adaptorWithName: currAdaptorName];
      [currAdaptor setConnectionDictionary: [model connectionDictionary]];
      [currAdaptor assertConnectionDictionaryIsValid];
      currAdaptorExprClass = [currAdaptor expressionClass];
      currAdaptorContext = [currAdaptor createAdaptorContext];
      currAdaptorChannel = [currAdaptorContext createAdaptorChannel];
      [currAdaptorChannel openChannel];

      [[currAdaptor class] assignExternalInfoForEntireModel: model];
      filePath = NSTemporaryDirectory();
      filePath = [filePath stringByAppendingPathComponent: currAdaptorName];
      if (! [mgr fileExistsAtPath: filePath] )
        {
          [mgr createDirectoryAtPath: filePath attributes: nil];
        }
      filePath = [filePath stringByAppendingPathComponent: [model name]];
      [model writeToFile: filePath];
      createDatabaseWithModel(model);

      [[EOModelGroup defaultGroup] addModel: model];
      ec = [EOEditingContext new];
      entity = [model entityNamed: @"MyEntity"];
      cd = [entity classDescriptionForInstances];
      obj = [cd createInstanceWithEditingContext: ec
		globalID: nil
		zone: NULL];
      [ec insertObject: obj];

      tmp4 = [NSCalendarDate date];
      tmp2 = [tmp4 description];
      tmp1 = [NSNumber numberWithInt: [tmp4 secondOfMinute]];
      tmp3 = [[tmp2 dataUsingEncoding: NSUTF8StringEncoding] md5Digest];

      [obj takeValue: tmp1 forKey: @"number"];
      [obj takeValue: tmp2 forKey: @"string"];
      [obj takeValue: tmp3 forKey: @"data"];
      [obj takeValue: tmp4 forKey: @"date"];

      START_TEST(YES);
      [ec saveChanges];
      END_TEST(YES, "-[EOEditingContext saveChanges] 1");

      [[ec rootObjectStore] invalidateAllObjects];

      START_TEST(YES);
      result = [[obj valueForKey: @"number"] testIsEqual: tmp1];
      END_TEST(result, "fetched number");

      START_TEST(YES);
      result = [[obj valueForKey: @"string"] testIsEqual: tmp2];
      END_TEST(result, "fetched string");

      START_TEST(YES);
      result = [[obj valueForKey: @"data"] testIsEqual: tmp3];
      END_TEST(result, "fetched data");

      START_TEST(YES);
      result = [[obj valueForKey: @"date"] testIsEqual: tmp4];
      END_TEST(result, "fetched date");

      [ec release];
      attributes = [NSArray arrayWithObjects:[entity attributeNamed:@"date"], 
		 		[entity attributeNamed:@"data"],
				[entity attributeNamed:@"string"],
				[entity attributeNamed:@"number"], nil];
      [currAdaptorChannel selectAttributes:attributes
	      		fetchSpecification:[EOFetchSpecification fetchSpecificationWithEntityName:@"MyEntity" qualifier:nil sortOrderings:nil]
			lock:NO
			entity:entity];
      tmp = [currAdaptorChannel fetchRowWithZone:NULL];
      START_TEST(YES)
      result = [[tmp valueForKey:@"number"] testIsEqual: tmp1];
      END_TEST(result, "fetched number 2");
      
      START_TEST(YES)
      result = [[tmp valueForKey:@"string"] testIsEqual: tmp2];
      END_TEST(result, "fetched string 2");
      
      START_TEST(YES)
      result = [[tmp valueForKey:@"data"] testIsEqual: tmp3];
      END_TEST(result, "fetched data 2");
      
      START_TEST(YES)
      result = [[tmp valueForKey:@"date"] testIsEqual: tmp4];
      END_TEST(result, "fetched date 2");
     
      START_TEST(YES)
      result = ([currAdaptorChannel fetchRowWithZone:NULL] == NULL); 
      END_TEST(result, "only one row exists");

      tmp = [NSMutableDictionary dictionaryWithDictionary:tmp];
      [tmp setObject:@"o','r','84','z'"  forKey:@"string"];
      [tmp setObject:@"99" forKey:@"number"];
      tmp3 = [NSData dataWithBytes:tmpData length:32];
      [tmp setObject:tmp3 forKey:@"data"];
      [currAdaptorChannel evaluateExpression:[[currAdaptor expressionClass] insertStatementForRow:tmp entity:entity]];
      
      [currAdaptorChannel selectAttributes:attributes
	      		fetchSpecification:[EOFetchSpecification fetchSpecificationWithEntityName:@"MyEntity" qualifier:nil sortOrderings:nil]
			lock:NO
			entity:entity];
      
      tmp = [currAdaptorChannel fetchRowWithZone:NULL];
      tmp = [currAdaptorChannel fetchRowWithZone:NULL];
      [currAdaptorChannel cancelFetch];
      
      START_TEST(YES)
      result = [[tmp objectForKey:@"string"] testIsEqual:@"o','r','84','z'"];
      END_TEST(result, "fetch string requiring single quote escaping");
      
      START_TEST(YES)
      result = [[tmp objectForKey:@"data"] testIsEqual:tmp3];
      END_TEST(result, "fetch data containing nulls");
      
      [[EOModelGroup defaultGroup] removeModel: model];
      dropDatabaseWithModel(model);

  END_SET("EOAdaptor/EOAdaptorTypes00.m");
  [pool release];
  return (0);
}

