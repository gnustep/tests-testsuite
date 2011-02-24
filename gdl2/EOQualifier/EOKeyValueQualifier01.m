/*
   Copyright (C) 2005 Free SoftwareFoundation, Inc.

   Written by: Manuel Guesdon <mguesdon@orange-concept.com>
   Date: Aug 2005

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
  EOKeyValueQualifier *qual;
  EOQualifier* schemaBasedQual=nil;
  EOModel  *model=nil;
  EOEntity* orderEntity=nil;
  EOSQLExpression* sqlExpression=nil;
  NSString* sqlString=nil;
  
  START_SET("EOQualifier/EOKeyValueQualifier00.m");

/*
  NSMutableSet* debugSet=[[NSProcessInfo processInfo] debugSet];
  [debugSet addObject:@"dflt"];
  [debugSet addObject:@"EOFFn"];
  [debugSet addObject:@"EOFdflt"];
  [debugSet addObject:@"EOSQLExpression"];
  [debugSet addObject:@"EOQualifier"];
  [debugSet addObject:@"EOEntity"];
  [debugSet addObject:@"EORelationship"];
*/
  model = globalModelForKey(@"TSTTradingModel.eomodeld");
  setupModel(model);
  
  createDatabaseWithModel(model);
  [[EOModelGroup defaultGroup] addModel: model];
  
  orderEntity = [model entityNamed: @"Order"];
    
  // Testing keyPath (rel1.rel2.rel3.propertyName) as key
  START_TEST(YES);
  {
    qual = [[EOKeyValueQualifier alloc] initWithKey: @"orderPos.product.productGroup.name"
                                        operatorSelector: 
                                          EOQualifierOperatorEqual
                                        value: @"PostgresSQL"];
      
    schemaBasedQual=[qual schemaBasedQualifierWithRootEntity:orderEntity];
    NSLog(@"1 schemaBasedQual=%@",schemaBasedQual);

    sqlExpression=[EOSQLExpression sqlExpressionWithEntity:orderEntity];
    [sqlExpression setUseAliases: YES];

    sqlString=[schemaBasedQual sqlStringForSQLExpression: sqlExpression];
    NSLog(@"1 sqlString=%@",sqlString);
      
    sqlString=[sqlString stringByReplacingString:@" "
                         withString:@""];
    sqlString=[sqlString stringByReplacingString:@"t1"
                         withString:@"t0"];
    result = [sqlString isEqualToString:@"t0.NAME='PostgresSQL'"] 
	     || [sqlString isEqualToString:@"t0.\"NAME\"='PostgresSQL'"];
  }
  END_TEST(result,
           "EOKeyValueQualifier with keyPath (rel1.rel2.rel3.propertyName) as key");

  {
    EOEditingContext* ec = [EOEditingContext new];
    EOEntity* prdGroupEntity = [model entityNamed: @"ProductGroup"];
    EOClassDescription *prdGroupCD = nil;
    id prdGroup = nil;

    NSArray* classProperties=[prdGroupEntity classProperties];
    EOAttribute* pk=[prdGroupEntity attributeNamed: @"pid"];
    if ([classProperties indexOfObjectIdenticalTo:pk]==NSNotFound)
      [prdGroupEntity setClassProperties:[classProperties arrayByAddingObject:pk]];

    prdGroupCD = [prdGroupEntity classDescriptionForInstances];

    prdGroup = [prdGroupCD createInstanceWithEditingContext: ec 
                           globalID: nil zone: 0];

    [prdGroup takeStoredValue:[NSNumber numberWithInt:5]
              forKey:@"pid"];
    [prdGroup takeStoredValue:[NSCalendarDate date]
              forKey:@"date"];
    [prdGroup takeStoredValue:@"void"
              forKey:@"name"];

    [ec insertObject: prdGroup];
      
    // Testing keyPath (rel1.rel2.rel3) as key
    START_TEST(YES);
    {        
      qual = [[EOKeyValueQualifier alloc] initWithKey: @"orderPos.product.productGroup"
                                          operatorSelector: 
                                            EOQualifierOperatorEqual
                                          value: prdGroup];
      
      schemaBasedQual=[qual schemaBasedQualifierWithRootEntity:orderEntity];
      NSLog(@"2 schemaBasedQual=%@",schemaBasedQual);
        
      sqlExpression=[EOSQLExpression sqlExpressionWithEntity:orderEntity];
      [sqlExpression setUseAliases: YES];
        
      sqlString=[schemaBasedQual sqlStringForSQLExpression: sqlExpression];
      NSLog(@"2 sqlString=%@",sqlString);
        
      sqlString=[sqlString stringByReplacingString:@" "
                           withString:@""];
      sqlString=[sqlString stringByReplacingString:@"t1"
                           withString:@"t0"];
      sqlString=[sqlString stringByReplacingString:@"'5'"
                           withString:@"5"];
      result = [sqlString isEqualToString:@"t0.GRPID=5"]
	       || [sqlString isEqualToString:@"t0.\"GRPID\"=5"];
    }
    END_TEST(result,
             "EOKeyValueQualifier with keyPath (rel1.rel2.rel3) as key");

    // Testing keyPath (rel1.rel2.rel3) as key with flattened relationship
    START_TEST(YES);
    {
      EORelationship* orderPosProductsRel = [EORelationship new];
      [orderPosProductsRel setName: @"orderPosProducts"];
      [orderEntity addRelationship: orderPosProductsRel];
      [orderPosProductsRel setDefinition:@"orderPos.product"];
      NSLog(@"orderPosProductsRel=%@",orderPosProductsRel);
      NSLog(@"orderEntity=%@",orderEntity);
              
      qual = [[EOKeyValueQualifier alloc] initWithKey: @"orderPosProducts.productGroup"
                                          operatorSelector: 
                                            EOQualifierOperatorEqual
                                          value: prdGroup];
        
      schemaBasedQual=[qual schemaBasedQualifierWithRootEntity:orderEntity];
      NSLog(@"3 schemaBasedQual=%@",schemaBasedQual);
        
      sqlExpression=[EOSQLExpression sqlExpressionWithEntity:orderEntity];
      [sqlExpression setUseAliases: YES];
        
      sqlString=[schemaBasedQual sqlStringForSQLExpression: sqlExpression];
      NSLog(@"3 sqlString=%@",sqlString);
        
      sqlString=[sqlString stringByReplacingString:@" "
                           withString:@""];
      sqlString=[sqlString stringByReplacingString:@"t1"
                           withString:@"t0"];
      sqlString=[sqlString stringByReplacingString:@"'5'"
                           withString:@"5"];
      result = [sqlString isEqualToString:@"t0.GRPID=5"]
	       || [sqlString isEqualToString:@"t0.\"GRPID\"=5"];
    }
    END_TEST(result,
             "EOKeyValueQualifier with keyPath (rel1.rel2.rel3) as key with flattened relationship");
  }

  END_SET("EOQualifier/EOKeyValueQualifier00.m");
  
  [pool release];
  return (0);
}
