#import <Foundation/Foundation.h>
#import "ObjectTesting.h"
int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  test_alloc_only(@"NSKeyedArchiver");
  test_NSObject(@"NSKeyedArchiver",[NSArray arrayWithObject:[[NSKeyedArchiver alloc] initForWritingWithMutableData: [NSMutableData data]]]);
  test_alloc_only(@"NSKeyedUnarchiver");  
  test_NSObject(@"NSKeyedUnarchiver",[NSArray arrayWithObject:[[NSKeyedUnarchiver alloc] initForReadingWithData: [NSKeyedArchiver archivedDataWithRootObject: [NSData data]]]]);
  
  IF_NO_GC(DESTROY(arp));
  return 0;
}
