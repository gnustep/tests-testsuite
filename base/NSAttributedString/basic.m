#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSAttributedString.h>
#import "ObjectTesting.h"
int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSArray *arr = [NSArray arrayWithObject:[NSAttributedString new]];
  
  test_alloc(@"NSAttributedString");
  test_NSObject(@"NSAttributedString", arr);
  test_NSCoding(arr);
  test_NSCopying(@"NSAttributedString",@"NSMutableAttributedString",arr,NO, NO);
  test_NSMutableCopying(@"NSAttributedString",@"NSMutableAttributedString",arr);

  DESTROY(arp);
  return 0;
}

