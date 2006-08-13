#import "Testing.h"
#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSIndexPath.h>

int main()
{ 
  CREATE_AUTORELEASE_POOL(arp);
  NSIndexPath	*index1;
  NSIndexPath	*index2;
  unsigned	i0[2];
  unsigned	i1[2];
  
  i0[0] = i1[1] = 0;
  i0[1] = i1[0] = 1;

  index1 = [NSIndexPath indexPathWithIndex: 1];
  pass(index1 != nil &&
       [index1 isKindOfClass:[NSIndexPath class]] &&
       [index1 length] == 1 &&
       [index1 indexAtPosition: 0] == 1,
       "+indexPathWithIndex: works");
  
  index2 = [NSIndexPath indexPathWithIndex: 1];
  pass(index1 == index2,
       "index path gives a shared instance");
  
  pass([index1 indexAtPosition: 1] == NSNotFound, 
	"indexAtPosition: with bad location gives NSNotFound");
  
  index1 = [index1 indexPathByAddingIndex: 9];
  pass([index1 length] == 2
    && [index1 indexAtPosition: 0] == 1
    && [index1 indexAtPosition: 1] == 9,
       "indexPathByAddingIndex: works");

  index1 = [index1 indexPathByRemovingLastIndex];
  pass([index1 length] == 1
    && [index1 indexAtPosition: 0] == 1,
       "indexPathByRemovingLastIndex works");

  index1 = [NSIndexPath indexPathWithIndexes: i0 length: 2];
  pass([index1 length] == 2
    && [index1 indexAtPosition: 0] == i0[0]
    && [index1 indexAtPosition: 1] == i0[1],
       "indexPathWithindexes:length: works");

  index2 = [NSIndexPath indexPathWithIndexes: i1 length: 2];
  pass([index1 length] == 2
    && [index1 indexAtPosition: 0] == i0[0]
    && [index1 indexAtPosition: 1] == i0[1],
       "indexPathWithindexes:length: works for another path");

  pass([index1 isEqual: index2] == NO,
       "different index paths are not equal");

  pass([index1 compare: index2] == NSOrderedAscending,
       "comparison one way works");
  pass([index2 compare: index1] == NSOrderedDescending,
       "comparison the other way works");
  index1 = [index1 indexPathByAddingIndex: 1];
  pass([index1 compare: index2] == NSOrderedAscending,
       "longer index1 comparison one way works");
  pass([index2 compare: index1] == NSOrderedDescending,
       "longer index1 comparison the other way works");
  index1 = [index1 indexPathByRemovingLastIndex];
  index2 = [index2 indexPathByAddingIndex: 1];
  pass([index1 compare: index2] == NSOrderedAscending,
       "longer index2 comparison one way works");
  pass([index2 compare: index1] == NSOrderedDescending,
       "longer index2 comparison the other way works");

  DESTROY(arp);
  { 
    BOOL didNotSegfault = YES;
    pass(didNotSegfault, "+indexPathWithIndex: doesn't mess up memory");
  }
  return 0;
}
