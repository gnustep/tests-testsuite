#include <Foundation/NSObject.h>
#include <Foundation/NSString.h>

@interface TestBundle : NSObject
{

}
-(NSString *)test;
@end

@implementation TestBundle
-(NSString *)test
{
  return @"Something"; 
}
@end
