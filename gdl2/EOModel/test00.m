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

#include <Foundation/NSPathUtilities.h>
#include <Foundation/NSAutoreleasePool.h>
#include <EOAccess/EOAccess.h>

#include "../GDL2Testing.h"

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  volatile BOOL result = NO;
  id tmp = nil;
  id plist = nil;
  NSString *filePath;
  NSDictionary *connDict = nil;

  EOModel  *model = nil;
  EOEntity *productEnt = nil;
  EOEntity *supplierEnt = nil;
  EOAttribute *pidAttr = nil;
  EOAttribute *nameAttr = nil;
  EOAttribute *posNrAttr = nil;
  EOAttribute *priceAttr = nil;
  EOAttribute *amountAttr = nil;
  EOAttribute *valueAttr = nil;
  EOAttribute *dateAttr = nil;
  EOAttribute *grpId = nil;
  EOAttribute *prdId = nil;
  EOAttribute *cstId = nil;
  EOAttribute *prlId = nil;
  EOAttribute *ordId = nil;
  EOAttribute *supplierId = nil;
  EOAttribute *srcAttr = nil;
  EOAttribute *dstAttr = nil;
  EORelationship *supplierRel = nil;
  EOJoin *prodSupJoin = nil;
  EOStoredProcedure *storedProc = nil;

  START_SET("EOModel/test00.m");

  START_TEST(YES);
  pidAttr = [EOAttribute new];
  [pidAttr setName: @"pid"];
  [pidAttr setColumnName: @"PID"];
  [pidAttr setExternalType: @"integer"];
  [pidAttr setValueClassName: @"NSNumber"];
  result = [pidAttr isKindOfClass: [EOAttribute class]];
  result = result && [[pidAttr name] isEqual: @"pid"];
  result = result && [[pidAttr columnName] isEqual: @"PID"];
  result = result && [[pidAttr externalType] isEqual: @"integer"];
  result = result && [[pidAttr valueClassName] isEqual: @"NSNumber"];
  END_TEST(result, "EOAttribute creation");

  START_TEST(YES);
  nameAttr = attributeWith(@"name", @"NAME", @"char", @"NSString");
  [nameAttr setWidth: 30];
  result = [nameAttr isKindOfClass: [EOAttribute class]];
  result = result && [nameAttr width] == 30;
  END_TEST(result, "EOAttribute creation via support function");
  
  pidAttr = attributeWith(@"pid", @"PID", @"integer", @"NSNumber");
  supplierId = attributeWith(@"supplierId", @"SUPPLIER_ID",
			     @"integer", @"NSNumber");
  grpId = attributeWith(@"groupId", @"GROUP_ID",
			@"integer", @"NSNumber");

  START_TEST(YES);
  productEnt = [EOEntity new];
  [productEnt setName: @"Product"];
  [productEnt setExternalName: @"PRODUCT"];
  [productEnt setClassName: @"EOGenericRecord"];
  [productEnt addAttribute: pidAttr];
  [productEnt addAttribute: nameAttr];
  [productEnt addAttribute: supplierId];
  [productEnt addAttribute: grpId];
  [productEnt setPrimaryKeyAttributes: [NSArray arrayWithObject: pidAttr]];
  START_SET("EOEntity creation result evaluation");
  {
    BOOL local;
    result = NO;
    local = [productEnt isKindOfClass: [EOEntity class]];
    local = local && [[productEnt name] isEqual: @"Product"];
    local = local && [[productEnt externalName] isEqual: @"PRODUCT"];
    local = local && [[productEnt className] isEqual: @"EOGenericRecord"];
    local = local && [[productEnt attributeNamed: @"pid"] isEqual: pidAttr];
    local = local && [[productEnt attributeNamed: @"name"] isEqual: nameAttr];
    local = local 
      && [[productEnt attributeNamed: @"supplierId"] isEqual: supplierId];
    local = local 
      && [[productEnt attributeNamed: @"groupId"] isEqual: grpId];
    local = local && [[productEnt primaryKeyAttributes] count] == 1;
    local = local 
      && [[productEnt primaryKeyAttributes] containsObject: pidAttr];

    result = local;
  }
  END_SET("EOEntity creation result evaluation");
  END_TEST(result, "EOEntity creation");

  pidAttr = attributeWith(@"pid", @"PID", @"integer", @"NSNumber");
  nameAttr = attributeWith(@"name", @"NAME", @"char", @"NSString");
  [nameAttr setWidth: 30];
  dateAttr = attributeWith(@"date", @"DATE", @"date", @"NSCalendarDate");

  supplierEnt = [EOEntity new];
  [supplierEnt setName: @"Supplier"];
  [supplierEnt setExternalName: @"SUPPLIER"];
  [supplierEnt setClassName: @"EOGenericRecord"];
  [supplierEnt addAttribute: pidAttr];
  [supplierEnt addAttribute: nameAttr];
  [supplierEnt addAttribute: dateAttr];
  [supplierEnt setPrimaryKeyAttributes: [NSArray arrayWithObject: pidAttr]];
  connDict = [NSDictionary dictionaryWithObject: @"gdl2test"
			   forKey: @"databaseName"];
  START_TEST(YES);
  model = [EOModel new];
  [model setName: @"gdl2test"];
  [model setAdaptorName: @"PostgreSQL"];
  [model setConnectionDictionary: connDict];
  [model addEntity: productEnt];
  [model addEntity: supplierEnt];
  START_SET("EOModel creation result evaluation");
  {
    BOOL local;
    result = NO;
    local = [model isKindOfClass: [EOModel class]];
    local = local && [[model name] isEqual: @"gdl2test"];
    local = local && [[model adaptorName] isEqual: @"PostgreSQL"];
    local = local && [[model connectionDictionary] isEqual: connDict];
    local = local && [[model entities] count] == 2;
    local = local && [[model entities] containsObject: productEnt];
    local = local && [[model entities] containsObject: supplierEnt];
    result = local;
  }
  END_SET("EOModel creation result evaluation");
  END_TEST(result, "EOModel creation");

  srcAttr = [productEnt attributeNamed: @"supplierId"];
  dstAttr = [supplierEnt attributeNamed: @"pid"];
  START_TEST(YES);
  prodSupJoin = [[EOJoin alloc] initWithSourceAttribute: srcAttr
				destinationAttribute: dstAttr];
  result = [prodSupJoin isKindOfClass: [EOJoin class]];
  result = result && [[prodSupJoin sourceAttribute] isEqual: srcAttr];
  result = result && [[prodSupJoin destinationAttribute] isEqual: dstAttr];
  END_TEST(result, "EOJoin creation");

  START_TEST(YES);
  supplierRel = [EORelationship new];
  [supplierRel setName: @"supplier"];
  [supplierRel addJoin: prodSupJoin];
  result = [supplierRel isKindOfClass: [EORelationship class]];
  result = result && [[supplierRel name] isEqual: @"supplier"];
  result = result && [[supplierRel joins] count] == 1;
  result = result && [[[supplierRel joins] lastObject] isEqual: prodSupJoin];
  END_TEST(result, "EORelationship creation");

  START_TEST(YES);
  [productEnt addRelationship: supplierRel];
  result = [[productEnt relationshipNamed: @"supplier"] isEqual: supplierRel];
  END_TEST(result, 
	   "-[EOEntity addRelationship:] -[EOEntity relationshipNamed:]");

  nameAttr = [productEnt attributeNamed: @"name"];
  supplierRel = [productEnt relationshipNamed: @"supplier"];
  tmp = [NSArray arrayWithObjects: nameAttr, supplierRel, nil];
  START_TEST(YES);
  [productEnt setClassProperties: tmp];
  result = [[productEnt classProperties] count] == 2;
  result = result && [[productEnt classProperties] containsObject: nameAttr];
  result 
    = result && [[productEnt classProperties] containsObject: supplierRel];
  END_TEST(result,
	   "-[EOEntity setClassProperties:] -[EOEntity classProperties]");

  nameAttr = [supplierEnt attributeNamed: @"name"];
  [supplierEnt setClassProperties: [NSArray arrayWithObject: nameAttr]];

  START_TEST(YES);
  storedProc = [[EOStoredProcedure alloc] initWithName: @"myProc1"];
  result = [[storedProc name] isEqual: @"myProc1"];
  END_TEST(result,
	   "-[EOStoredProcedure initWithName:] -[EOStoredProcedure name]");

  START_TEST(YES);
  [storedProc setExternalName: @"extProcName1"];
  result = [[storedProc externalName] isEqual: @"extProcName1"];
  END_TEST(result,
	   "-[EOStoredProcedure setExternalName:] "
	   "-[EOStoredProcedure externalName]");

  START_TEST(YES);
  [model addStoredProcedure: storedProc];
  tmp = [model storedProcedureNamed: @"myProc1"];
  result = tmp == storedProc;
  END_TEST(result,
	   "-[EOModel addStoredProcedure:] -[EOModel storedProcedureNamed:]");

  storedProc = [[EOStoredProcedure alloc] initWithName: @"myProc2"];
  [storedProc setExternalName: @"extProcName2"];
  nameAttr = attributeWith(@"name", @"NAME", @"char", @"NSString");
  [nameAttr setWidth: 30];

  START_TEST(YES);
  tmp = [NSArray arrayWithObject: nameAttr];
  [storedProc setArguments: tmp];
  result = [[storedProc arguments] isEqual: tmp];
  END_TEST(result,
           "-[EOStoredProcedure setArguments:] "
           "-[EOStoredProcedure arguments]");

  [model addStoredProcedure: storedProc];

  START_TEST(YES);
  {
    id entitiesPL;
    id entDictPL;
    id productPL;
    id supplierPL;

    plist = [NSMutableDictionary dictionary];
    [model encodeTableOfContentsIntoPropertyList: plist];
    START_SET("-[EOModel encodeTableOfContentsIntoPropertyList:]"
    {
      BOOL local;
      result = NO;
      entitiesPL = [plist objectForKey: @"entities"];
      local = [entitiesPL count] == 2;
      tmp = [entitiesPL valueForKey: @"name"];
      entDictPL = [NSDictionary dictionaryWithObjects: entitiesPL
				forKeys: tmp];
      local = local && [tmp containsObject: @"Product"];
      local = local && [tmp containsObject: @"Supplier"];
      productPL = [entDictPL objectForKey: @"Product"];
      supplierPL = [entDictPL objectForKey: @"Supplier"];
      local = local
	&& [[productPL objectForKey: @"className"] isEqual: 
						     @"EOGenericRecord"];
      local = local
	&& [[supplierPL objectForKey: @"className"] isEqual:
						      @"EOGenericRecord"];
      result = local;
    }
    END_SET("-[EOModel encodeTableOfContentsIntoPropertyList:]"
	    " result evaluation");
  }
  END_TEST(result, "-[EOModel encodeTableOfContentsIntoPropertyList:]");

  filePath = NSTemporaryDirectory();
  filePath = [filePath stringByAppendingPathComponent: [model name]];
  START_TEST(YES);
  [model writeToFile: filePath];
  START_SET("-[EOModel writeToFile:] result evaluation");
  {
    NSString *idxPath;
    NSString *fileContentString;
    id       fileContents;

    idxPath = [filePath stringByAppendingPathExtension: @"eomodeld"];
    idxPath = [idxPath stringByAppendingPathComponent: @"index.eomodeld"];
    fileContentString = [NSString stringWithContentsOfFile: idxPath];
    fileContents = [fileContentString propertyList];
    result = [fileContents isEqual: plist];
  }
  END_SET("-[EOModel writeToFile:] result evaluation");
  END_TEST(result, "-[EOModel writeToFile:]");

  START_TEST(YES);
  {
    EOModel *loadedModel;

    loadedModel = [[EOModel alloc] initWithContentsOfFile: filePath];
    result = [[[loadedModel description] propertyList] 
	       isEqual: [[model description] propertyList]];
							 
  }
  END_TEST(result, "-[EOModel initWithConentsOfFile:]"); 
  END_SET("EOModel/test00.m");

  [pool release];
  return (0);
}


