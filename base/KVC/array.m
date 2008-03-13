#include <Foundation/Foundation.h>

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  volatile BOOL result = NO;
  id tmp = nil;

  NSArray *array = [@"({value=10;},{value=12;})" propertyList];
  NSString *plist = @"{displayGroup={allObjects=({detailArray=({value=4;},{value=2;});},{detailArray=({value=8;},{value=10;});});}}";
  NSDictionary *root = [plist propertyList];

  result = [[array valueForKeyPath:@"@sum.value"] intValue] == 22;
  pass(result, "-[NSArray valueForKeyPath: @\"@sum.value\"]");

  result = [[array valueForKeyPath:@"@count.value"] intValue] == 2;
  pass(result, "-[NSArray valueForKeyPath: @\"@count.value\"]");

  result = [[array valueForKeyPath:@"@count"] intValue] == 2;
  pass(result, "-[NSArray valueForKeyPath: @\"@count\"]");


  /* Advanced KVC */

  result = [[root valueForKeyPath:@"displayGroup.allObjects.@sum.detailArray.@avg.value"] intValue] == 12;
  pass(result, "-[NSArray valueForKeyPath: @\"displayGroup.allObjects.@sum.detailArray.@avg.value\"]");

  result = [[root valueForKeyPath:@"displayGroup.allObjects.@sum.detailArray.@count.value"] intValue] == 4;
  pass(result, "-[NSArray valueForKeyPath: @\"displayGroup.allObjects.@sum.detailArray.@count.value\"]");

  result = [[root valueForKeyPath:@"displayGroup.allObjects.@sum.detailArray.@count"] intValue] == 4;
  pass(result, "-[NSArray valueForKeyPath: @\"displayGroup.allObjects.@sum.detailArray.@count\"]");

  [pool release];
  return (0);
}
