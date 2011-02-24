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
#include <EOAccess/EOAccess.h>

#include "../GDL2Testing.h"

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  NSArray   *adaptorNamesArr = nil;

  NSString  *currAdaptorName;
  EOAdaptor *currAdaptor = nil;
  EOAdaptorContext *currAdaptorContext = nil;
  EOAdaptorChannel *currAdaptorChannel = nil;

  EOModel *model;
  NSArray *entities;

  Class    currAdaptorExprClass = 0;

  id readTableNames = nil;

  id tmp = nil, tmp1 = nil, tmp2 = nil, tmp3 = nil;
  unsigned i,c;
  volatile BOOL result = NO;

  model = globalModelForKey(TSTTradingModelName);
  currAdaptorName = setupModel(model);
  /*  Now we have the testcases for the installed Adaptors.  */

  START_SET("EOAdaptor/test00.m");
  [EOSQLExpression setUseQuotedExternalNames: YES];

  START_TEST(YES);
  adaptorNamesArr = [EOAdaptor availableAdaptorNames];
  result = [adaptorNamesArr containsObject:currAdaptorName];
  END_TEST(result, "+[EOAdaptor availableAdaptorNames:]" );

      START_SET("EOAdaptor")

      START_TEST(YES);
      currAdaptor = [EOAdaptor adaptorWithName: currAdaptorName];
      result = ([currAdaptor isKindOfClass: [EOAdaptor class]]
		&& ![currAdaptor isMemberOfClass: [EOAdaptor class]]);
      END_TEST(result, "+[EOAdaptor adaptorWithName: %s]", 
	       [currAdaptorName cString]);

      tmp = [currAdaptorName stringByAppendingString: @"EOAdaptor"];
      START_TEST(YES);
      result = [[currAdaptor name] isEqual: tmp];
      END_TEST(result, "-[EOAdaptor name]");

      START_TEST(YES);;
      result = [[currAdaptor defaultExpressionClass]
		 isSubclassOfClass: [EOSQLExpression class]];
      result = (result
		&& ([currAdaptor defaultExpressionClass]
		    != [EOSQLExpression class]));
      END_TEST(result, "-[EOAdaptor defaultExpressionClass]");

      START_TEST(YES);
      result = [[currAdaptor expressionClass]
		 isSubclassOfClass: [EOSQLExpression class]];
      result = (result
		&& ([currAdaptor expressionClass]
		    != [EOSQLExpression class]));
      END_TEST(result, "-[EOAdaptor expressionClass]");

      tmp = [model connectionDictionary];
      START_TEST(YES);
      [currAdaptor setConnectionDictionary: tmp];
      result = [[currAdaptor connectionDictionary] isEqual: tmp];
      END_TEST(result, "-[EOAdaptor setC/connectionDictionary]");

      START_TEST(YES);
      [currAdaptor assertConnectionDictionaryIsValid];
      END_TEST(result, "-[EOAdaptor assertConnectionDictionaryIsValid]");

      START_TEST(YES);
      currAdaptorContext = [currAdaptor createAdaptorContext];
      result = [currAdaptorContext isKindOfClass: [EOAdaptorContext class]];
      result = result
	&& [[currAdaptor contexts] containsObject: currAdaptorContext];
      result = result
	&& [currAdaptorContext adaptor] == currAdaptor;
      END_TEST(result, "-[EOAdaptor createAdaptorC/context/s]");

      START_TEST(YES);
      currAdaptorChannel = [currAdaptorContext createAdaptorChannel];
      result = [currAdaptorChannel isKindOfClass: [EOAdaptorChannel class]];
      result = result
	&& [currAdaptorChannel adaptorContext] == currAdaptorContext;
      END_TEST(result, "-[EOAdaptor createAdaptorC/channel]");

      START_TEST(YES);
      result = ![currAdaptor hasOpenChannels];
      END_TEST(result, "-[EOAdaptor hasOpenChannels] closed 1");

      START_TEST(YES);
      [currAdaptorChannel openChannel];
      END_TEST(YES, "-[EOAdatorChannel openChannel]");

      START_TEST(YES);
      result = [currAdaptor hasOpenChannels];
      END_TEST(result, "-[EOAdaptor hasOpenChannels] open");

      START_TEST(YES);
      [currAdaptorChannel closeChannel];
      result = ![currAdaptor hasOpenChannels];
      END_TEST(result, "-[EOAdatorChannel closeChannel]");

      START_TEST(YES);
      result = ![currAdaptor hasOpenChannels];
      END_TEST(result, "-[EOAdaptor hasOpenChannels] closed 2");

      START_TEST(YES);
      currAdaptorExprClass = [currAdaptor expressionClass];
      result 
	= [currAdaptorExprClass isSubclassOfClass: [EOSQLExpression class]];
      result = result
	&& currAdaptorExprClass != [EOSQLExpression class];
      END_TEST(result, "-[EOAdaptor expressionClass]");

      [currAdaptorChannel openChannel];
      START_TEST(YES);
      readTableNames = [currAdaptorChannel describeTableNames];
      result = (readTableNames && [readTableNames count] == 0);
      END_TEST(result, "-[EOAdatorChannel describeTableNames] empty %s",
	       [[readTableNames description] cString]);
      [currAdaptorChannel closeChannel];

      
      END_SET("EOAdaptor")

  entities = [model entities];
  tmp1 = [NSDictionary dictionaryWithObjectsAndKeys:
			 @"NO", @"EODropTablesKey",
		       @"NO", @"EODropPrimaryKeySupportKey", nil];

  START_TEST(YES);
  tmp = [currAdaptorExprClass schemaCreationStatementsForEntities: entities
			      options: tmp1];
  START_SET("-[EOSQLExpression schemaCreationStatementsForEntities:options:]"
	  " result evaluation");
  {
    BOOL local = NO;
    result = NO;
    tmp1 = [tmp valueForKey: @"statement"];
    tmp2 = [EOQualifier qualifierWithQualifierFormat:
			  @"description caseInsensitiveLike "
			@"'*CREATE*TABLE*PRODUCT*'"];
    tmp3 = [tmp1 filteredArrayUsingQualifier: tmp2];
    local = ([tmp3 count] == 2); /* PRODUCT & PRODUCTGROUP */
    tmp2 = [EOQualifier qualifierWithQualifierFormat:
			  @"description caseInsensitiveLike "
			@"'*CREATE*TABLE*SUPPLIER*'"];
    tmp3 = [tmp1 filteredArrayUsingQualifier: tmp2];
    result = local && ([tmp3 count] == 1);
  }
  END_SET("-[EOSQLExpression schemaCreationStatementsForEntities:options:]"
	  " result evaluation");
  END_TEST(result,
	   "-[EOSQLExpression schemaCreationStatementsForEntities:options:]"
	   " create tables");

  tmp1 = [tmp objectEnumerator];
  [currAdaptorChannel openChannel];
  START_TEST(YES);
  while ((tmp2 = [tmp1 nextObject]))
    {
      [currAdaptorChannel evaluateExpression: tmp2];
    }
  END_TEST(YES,"-[EOAdaptorChannel evaluateExpression:] create tables");
  [currAdaptorChannel closeChannel];
  
  [currAdaptorChannel openChannel];
  {
    NSMutableArray *ents = [NSMutableArray arrayWithArray:[model entities]];
    int i;
    for (i = 0; i < [ents count]; i++)
    {
      EOEntity *ent = [ents objectAtIndex:i];
      if ([ent isAbstractEntity])
        {
	  [ents removeObjectAtIndex:i];
	  i--;
	}
    }
    tmp1 = [ents valueForKey: @"externalName"];
    START_TEST(YES);
    tmp2 = [currAdaptorChannel describeTableNames];
    result = [tmp1 isEqual: tmp2];
    END_TEST(result,
	   "-[EOAdatorChannel describeTableNames] %s == %s", [[tmp1 description] cString], [[tmp2 description] cString]);
    [currAdaptorChannel closeChannel];
  }
  tmp1 = [NSDictionary dictionaryWithObjectsAndKeys:
			 @"NO", @"EOPrimaryKeyConstraintsKey",
		       @"NO", @"EOCreatePrimaryKeySupportKey",
		       @"NO", @"EOCreateTablesKey",
		       nil];
  
  START_TEST(YES);
  tmp = [currAdaptorExprClass schemaCreationStatementsForEntities: entities
			      options: tmp1];
  START_SET("-[EOSQLExpression schemaCreationStatementsForEntities:options:]"
	  " result evaluation");
  {
    BOOL local = NO;
    result = NO;
    tmp1 = [tmp valueForKey: @"statement"];
    tmp2 = [EOQualifier qualifierWithQualifierFormat:
			  @"description caseInsensitiveLike "
			@"'*DROP*TABLE*PRODUCT*'"];
    tmp3 = [tmp1 filteredArrayUsingQualifier: tmp2];
    local = ([tmp3 count] == 2); /* PRODUCT & PRODUCTGROUP */
    tmp2 = [EOQualifier qualifierWithQualifierFormat:
			  @"description caseInsensitiveLike "
			@"'*DROP*TABLE*SUPPLIER*'"];
    tmp3 = [tmp1 filteredArrayUsingQualifier: tmp2];
    result = local && ([tmp3 count] == 1);
  }
  END_SET("-[EOSQLExpression schemaCreationStatementsForEntities:options:]"
	  " result evaluation");
  END_TEST(result,
	   "-[EOSQLExpression schemaCreationStatementsForEntities:options:]"
	   " drop tables");

  tmp1 = [tmp objectEnumerator];
  [currAdaptorChannel openChannel];
  START_TEST(YES);
  while ((tmp2 = [tmp1 nextObject]))
    {
      [currAdaptorChannel evaluateExpression: tmp2];
    }
  END_TEST(YES,"-[EOAdaptorChannel evaluateExpression:] drop tables");
  [currAdaptorChannel closeChannel];
  
  [currAdaptorChannel openChannel];
  START_TEST(YES);
  readTableNames = [currAdaptorChannel describeTableNames];
  result = (readTableNames && [readTableNames count] == 0);
  END_TEST(result, "-[EOAdatorChannel describeTableNames] empty (2) %s",
	   [[readTableNames description] cString]);
  [currAdaptorChannel closeChannel];

  dropDatabaseWithModel(model);
  END_SET("EOAdaptor/test00.m");
  [pool release];
  return (0);
}




