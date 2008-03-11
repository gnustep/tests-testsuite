#include "../GDL2Testing.h"

int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NS_DURING
  {
    EOModel *model = [[EOModel alloc] initWithContentsOfFile:@"bad1.eomodel"];
    [model entities];
    pass(0, "bad1.eomodel throws exception");
  }
  NS_HANDLER
  pass(1, "bad1.eomodel throws exception");
  NS_ENDHANDLER 
  

  {
    EOModel *model = [[EOModel alloc] initWithContentsOfFile:@"bad2.eomodel"];
    NSDictionary *userInfo = [model userInfo];
    NSArray *tests = [userInfo allKeys];
    int i, c; 
 
    for (i = 0, c = [tests count]; i < c; i++)
      {
        NSString *testName = [tests objectAtIndex:i];
        NS_DURING
          {
            [[model entityNamed:testName] attributes];
            [[model entityNamed:testName] relationships];
            pass(0, "%s throws exception", [testName cString]);
          }
        NS_HANDLER
          pass(1, "%s throws exception", [[userInfo objectForKey:testName] cString]);
        NS_ENDHANDLER 
      }
  }
  [pool release];
  return 0;
}
