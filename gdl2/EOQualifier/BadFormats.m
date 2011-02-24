#include "../GDL2Testing.h"

int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSArray *qfs = [NSArray arrayWithObjects:
	@"(NSString)%@ = 'foo'", // casting lhs
	@"(NSString)'foo' = 'foo'", // casting lhs
	@"(NSString)foo = 'foo'", // casting lhs
	@"foo = (NSString)bar", // casting unquoted 
	@"foo = (NSString)$bar", // casting binding variable
	@"foo = (NSString)%@", // casting format
	@"foo = $%@", // bad binding variable
	@"foo = %bar", // bad format
	@"foo = $%%", // bad binding variable
	@"foo = $'foo'", // ditto.
	@"foo = %$%", // bad format 
	nil];
  volatile BOOL result;
  unsigned i, c;

  START_SET("bad qualifiers formats");
  {
    for (i = 0, c = [qfs count]; i < c; i++)
      {
        NSString *qf = [qfs objectAtIndex:i];
       	NSLog(@"%@", qf); 
	START_TEST(YES)

        NS_DURING
        {
	  EOQualifier *qual = [EOQualifier qualifierWithQualifierFormat:qf, nil];
	  NSLog(@"%@", qual);
	  result = NO;
	}
	NS_HANDLER
	  NSLog(@"exceptions are good %@", localException, [localException userInfo]);
	  result = YES; 
	NS_ENDHANDLER
        END_TEST(result, "bad qualifier format: %s", [qf cString]);
      }
  }
  END_SET("bad qualifiers formats");
  [pool release];

  return 0;
}


