/* -*-objc-*- */

#ifdef GNUSTEP_TESTING
#include <GNUstepBase/GSTesting.h>
#else
#include "../stuff.h"
#endif

#include <EOAccess/EOAccess.h>

NSString *TSTTradingModelName = @"TSTTradingModel";

static EOAttribute *attributeWith(NSString *name,
				  NSString *columnName,
				  NSString *externalType,
				  NSString *valueClassName) __attribute__ ((unused));
static EOAttribute *attributeWith(NSString *name,
				  NSString *columnName,
				  NSString *externalType,
				  NSString *valueClassName)
{
  EOAttribute *att = [[EOAttribute new] autorelease];
  [att setName: name];
  [att setColumnName: columnName];
  [att setExternalType: externalType];
  [att setValueClassName: valueClassName];
  return att;
}

static EOModel *globalModelForKey(NSString *key) __attribute__ ((unused));
static EOModel *
globalModelForKey(NSString *key)
{
  static NSMutableDictionary *globalModelDictionary = nil;

  if (globalModelDictionary == nil)
    globalModelDictionary = [NSMutableDictionary new];

  EOModel *model = [globalModelDictionary objectForKey: key];
  if (model == nil)
    {
      NSString *path = [NSString stringWithFormat: @"../%@", key];
      model = [[EOModel alloc] initWithContentsOfFile: path];
      
      if (model)
	[globalModelDictionary setObject: model forKey: key];
      [model release];
    }
  return model;
}

static void createDatabaseWithModel(EOModel *model) __attribute__ ((unused));
static void createDatabaseWithModel(EOModel *model)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  NSArray *entities = [model entities];
  EOAdaptor *adaptor = [EOAdaptor adaptorWithModel: model];
  EOAdaptorContext *context = [adaptor createAdaptorContext];
  EOAdaptorChannel *channel = [context createAdaptorChannel];
  Class exprClass = [adaptor expressionClass];
  NSDictionary *createOptDict 
    = [NSDictionary dictionaryWithObjectsAndKeys:
		      @"NO", @"EODropTablesKey",
		    @"NO", @"EODropPrimaryKeySupportKey", nil];
  NSDictionary *dropOptDict 
    = [NSDictionary dictionaryWithObjectsAndKeys:
		      @"NO", @"EOPrimaryKeyConstraintsKey",
		    @"NO", @"EOCreatePrimaryKeySupportKey",
		    @"NO", @"EOCreateTablesKey",
		    nil];
  NSArray *exprs;
  EOSQLExpression *expr;
  unsigned i,c;

  exprs = [exprClass schemaCreationStatementsForEntities: entities
		     options: dropOptDict];

  [channel openChannel];
  for (i=0, c=[exprs count]; i<c; i++)
    {
      expr = [exprs objectAtIndex: i];
      NS_DURING
	{
	  [channel evaluateExpression: expr];
	}
      NS_HANDLER;
      NS_ENDHANDLER;
    }
  exprs = [exprClass schemaCreationStatementsForEntities: entities
		     options: createOptDict];
  for (i=0, c=[exprs count]; i<c; i++)
    {
      expr = [exprs objectAtIndex: i];
      [channel evaluateExpression: expr];
    }
  [channel closeChannel];
  
  [pool release];
}

static void dropDatabaseWithModel(EOModel *model) __attribute__ ((unused));
static void dropDatabaseWithModel(EOModel *model)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  NSArray *entities = [model entities];
  EOAdaptor *adaptor = [EOAdaptor adaptorWithModel: model];
  EOAdaptorContext *context = [adaptor createAdaptorContext];
  EOAdaptorChannel *channel = [context createAdaptorChannel];
  Class exprClass = [adaptor expressionClass];
  NSDictionary *dropOptDict 
    = [NSDictionary dictionaryWithObjectsAndKeys:
		      @"NO", @"EOPrimaryKeyConstraintsKey",
		    @"NO", @"EOCreatePrimaryKeySupportKey",
		    @"NO", @"EOCreateTablesKey",
		    nil];
  NSArray *exprs;
  EOSQLExpression *expr;
  unsigned i,c;

  exprs = [exprClass schemaCreationStatementsForEntities: entities
		     options: dropOptDict];

  [channel openChannel];
  for (i=0, c=[exprs count]; i<c; i++)
    {
      expr = [exprs objectAtIndex: i];
      NS_DURING
	{
	  [channel evaluateExpression: expr];
	}
      NS_HANDLER;
      NS_ENDHANDLER;
    }
  [channel closeChannel];
  
  [pool release];
}
