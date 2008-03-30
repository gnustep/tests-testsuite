#include "../GDL2Testing.h"

union things {
  const char *s;
  double f;
  NSObject *o;
  int d;
};

struct operators {
  char *format;
};

/*
 * not all operators make sense for all value types but...
 */
struct operators ops[] = {
  {"="},
  {"<="},
  {">="}, 
  {"<"},
  {">"}, 
  {"!="},
  {"<>"},
  {"like"},
  {"caseInsensitiveLike"},
  {"contains"},
  {"doesContain"}
};

struct foo {
  char *key;
  char *format;
  char valueType;
  char *qualifierClassName;
};

static struct foo stuff[] = {
{"a", "%@", '@', "EOKeyValueQualifier"}, 
{"b", "%f", 'f', "EOKeyValueQualifier"}, 
{"c", "%d", 'd', "EOKeyValueQualifier"}, 
{"d", "%s", 's', "EOKeyValueQualifier"}, 
{"e", "%@", '!', "EOKeyValueQualifier"}, 
{"f", "%f", '!', "EOKeyValueQualifier"}, 
{"g", "%d", '!', "EOKeyValueQualifier"}, 
{"h", "%s", '!', "EOKeyValueQualifier"}
}; 

struct aggregate {
  char *format;
  char *qualifierClassName;
}; 

struct aggregate aggStuff[] = {
  {"and", "EOAndQualifier"},
  {"or", "EOOrQualifier"},
};

@implementation NSObject(testStuff)
- (union things) thing
{
  return (union things)self;
}
@end

@implementation NSNumber(testStuff)
- (union things) thing
{
  return (union things)[self doubleValue];
}

@end
@implementation NSDecimalNumber (testStuff)
- (union things) thing
{
  return (union things)[self intValue];
}
@end

@implementation NSString (testStuff)
- (union things) thing
{
  return (union things)[self cString];
}
@end
int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSDictionary *typeDict = [[NSDictionary alloc] initWithObjectsAndKeys:
		[NSObject new], @"@",
		[NSNumber numberWithFloat:7.22342], @"f",
		[NSDecimalNumber numberWithInt:9999], @"d",
		@"foo", @"s", nil];	
  int i, j;
  BOOL result;
  int step = 0;
  
  for (step = 0; step <= 1; step++)
  for (i = 0; i < sizeof(stuff)/sizeof(stuff[0]); i++)
    {
      for (j = 0; j < sizeof(ops)/sizeof(ops[0]); j++)
         {
	   NSString *qFmt;
	   id object, objectKey;
	   NSArray *args;
	   EOQualifier *q;
	   NSString *className;
	   Class qClass = Nil;
	   NSString *key;

           START_SET(YES);
	   key = [NSString stringWithFormat:@"%s", stuff[i].key];

	   qFmt = [NSString stringWithFormat:@"(%@ %s %s)",
			 key, ops[j].format, stuff[i].format];

	   objectKey = [NSString stringWithFormat:@"%c", stuff[i].valueType];
	   object = [typeDict objectForKey:objectKey];

	   className = [NSString stringWithCString:stuff[i].qualifierClassName];
	   qClass = NSClassFromString(className);

	   if (object)
             args = [NSArray arrayWithObject:object];
	   else
	     args = [NSArray array]; 

	   // this test may need updating if we decide missing arguments should
	   // throw an exception, current we just produce undefined results.
	      
	     START_TEST(YES)
	     if (step == 0)
	         q = [EOQualifier qualifierWithQualifierFormat:qFmt
						arguments:args];
	     else
	       {
                 switch (stuff[i].valueType) {
		    case '@':
	            q = [EOQualifier qualifierWithQualifierFormat:qFmt, [object thing].o];
		    break;
		    case 'f':
	            q = [EOQualifier qualifierWithQualifierFormat:qFmt, [object thing].f];
		    break;
		    case 'd':
	            q = [EOQualifier qualifierWithQualifierFormat:qFmt, [object thing].d];
		    break;
		    case 's':
	            q = [EOQualifier qualifierWithQualifierFormat:qFmt, [object thing].s];
		    break;
		    default:	
	            q = [EOQualifier qualifierWithQualifierFormat:qFmt, nil];
		    break;
		 }
	       }
	     END_TEST(q != nil, "test0 %i.%i.%i", step, i, j);

	     NSLog(@"fmt:%@ q:%@ args:%@", qFmt, q, args);

	     START_TEST(YES);
	     result = [q isKindOfClass:qClass]; 
	     END_TEST(result, "test1 %i.%i.%i", step, i, j);
	   
	     if (object && [qClass isEqual:[EOKeyValueQualifier class]])
	       {
	         START_TEST(object);
	         [[(EOKeyValueQualifier *)q value] isEqual: object];
	         END_TEST(result, "test2 %i.%i.%i", step, i, j);
	       }
	  
	     START_TEST(YES)
	     [[q allQualifierKeys] isEqual:[NSSet setWithObject:key]]; 
	     END_TEST(result, "test3 %i.%i.%i", step, i, j);
	 
	     END_SET("qualifierWithQualifierFormat:arguments");
	 }
    }
  for (step = 0; step <= 1; step++)
  for (j = 0; j < sizeof(aggStuff)/sizeof(aggStuff[0]); j++)
    {
      NSMutableArray *formats = [[NSMutableArray alloc] init];
      NSMutableArray *args= [[NSMutableArray alloc] init];
      NSString *agFormat = [NSString stringWithFormat:@" %s ", aggStuff[j].format];
      NSMutableSet *keys = [[NSMutableSet alloc] init];
      NSString *className = [NSString stringWithCString:aggStuff[j].qualifierClassName];
      Class qClass = NSClassFromString(className);
      NSString *fmt;
      EOQualifier *q;
    
      for (i = 0; i < sizeof(stuff)/sizeof(stuff[0]); i++)
         {
	   NSString *qFmt;
	   NSString *key;
	   id objectKey = [NSString stringWithFormat:@"%c",stuff[i].valueType];
	   id object = [typeDict objectForKey:objectKey];

	   if (object || step == 1) {
	     key = [NSString stringWithFormat:@"%s", stuff[i].key];

	     qFmt = [NSString stringWithFormat:@"(%@ %s %s)",
			 key, ops[0].format, stuff[i].format];
	     [formats addObject:qFmt];
	     [keys addObject:key];
	     if (object)
	       [args addObject:object];
	   }
        }

      fmt = [formats componentsJoinedByString:agFormat];
      START_SET(YES);

      START_TEST(YES);
      q = [EOQualifier qualifierWithQualifierFormat:fmt arguments:args];
      END_TEST(q != nil, "test4 %i.%i", step, j);
      
      START_TEST(YES);
      result = [[q allQualifierKeys] isEqual:keys]; 
      END_TEST(result, "test5 %i.%i", step, j);

      START_TEST(YES);
      result = [q isKindOfClass:qClass]; 
      END_TEST(result, "test6 %i.%i", step, j);

      END_SET("aggregate qualifiers");
     }

  [pool release];
  return 0;
}
