#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSSortDescriptor.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSArray		*array;
  NSSortDescriptor	*s1;
  NSSortDescriptor	*s2;
  NSSortDescriptor	*s3;
  NSSortDescriptor	*s4;
  NSDictionary		*d1;
  NSDictionary		*d2;
  NSDictionary		*d3;
  NSDictionary		*d4;
  NSArray		*a1;
  NSArray		*a2;
  NSArray		*a3;

  s1 = [[NSSortDescriptor alloc] initWithKey: @"name" ascending: YES];
  pass(s1 != nil, "can create a sort descriptor");
   
  array = [NSArray arrayWithObject: s1];
  test_NSObject(@"NSSortDescriptor", array);
  test_NSCoding(array);
  test_NSCopying(@"NSSortDescriptor", @"NSSortDescriptor", array, NO, NO);

  s2 = [[NSSortDescriptor alloc] initWithKey: @"name" ascending: YES];
  s3 = [[NSSortDescriptor alloc] initWithKey: @"other" ascending: YES];
  s4 = [[NSSortDescriptor alloc] initWithKey: @"other" ascending: NO];
  pass([s1 hash] == [s2 hash], "hash for similar descriptors is the same");
  pass([s1 isEqual: s2], "similar descriptors are equal");
  pass(![s1 isEqual: s3], "different keyed descriptors are not equal");
  pass(![s3 isEqual: s4], "different ordered descriptors are not equal");

  d1 = [NSDictionary dictionaryWithObjectsAndKeys:
    @"1", @"name",
    @"1", @"other",
    nil];
  d2 = [NSDictionary dictionaryWithObjectsAndKeys:
    @"1", @"name",
    @"2", @"other",
    nil];
  d3 = [NSDictionary dictionaryWithObjectsAndKeys:
    @"2", @"name",
    @"1", @"other",
    nil];
  d4 = [NSDictionary dictionaryWithObjectsAndKeys:
    @"2", @"name",
    @"2", @"other",
    nil];
  pass([s3 compareObject: d3 toObject: d4] == NSOrderedAscending,
    "basic comparison works for ascending descriptor");
  pass([s4 compareObject: d3 toObject: d4] == NSOrderedDescending,
    "basic comparison works for descending descriptor");

  array = [NSArray arrayWithObjects: s1, s3, nil];
  a1 = [NSArray arrayWithObjects: d1, d2, d3, d4, nil];
  a2 = [NSArray arrayWithObjects: d1, d3, d2, d4, nil];
  a3 = [a1 sortedArrayUsingDescriptors: array];
  pass([a2 isEqual: a3], "simple multilevel sort works");
  
  DESTROY(arp);
  return 0;
}
