#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSAttributedString.h>
#include "ObjectTesting.h"
int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSArray *arr = [NSArray arrayWithObject:[NSMutableAttributedString new]];
  
  test_alloc(@"NSMutableAttributedString");
  test_NSObject(@"NSMutableAttributedString", arr);
  test_NSCoding(arr);
  test_NSCopying(@"NSAttributedString",@"NSMutableAttributedString",arr,NO, NO);
  test_NSMutableCopying(@"NSAttributedString",@"NSMutableAttributedString",arr);

  DESTROY(arp);
  return 0;
}

