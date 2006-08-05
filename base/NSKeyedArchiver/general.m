#include <Foundation/NSString.h>
#include <Foundation/NSArray.h>
#include <Foundation/NSKeyedArchiver.h>
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSData.h>
#include "Testing.h"
#include "ObjectTesting.h"

int main()
{
  // CREATE_AUTORELEASE_POOL(arp);
  NSString *val1, *val2, *val3, *s;
  NSArray  *vals1, *vals2;
  NSData   *data1;
  NSMutableData *data2;
  NSArray *a;
  NSKeyedArchiver *archiver = nil;
  NSKeyedUnarchiver *unarchiver = nil;

  TEST_EXCEPTION(val1 = [NSString stringWithCString:"Archiver.dat"];
  		 val2 = [NSString stringWithCString:"A Goodbye"];
		 val3 = [NSString stringWithCString:"Testing all strings"];
		 vals1 = [[NSArray arrayWithObject:val1] arrayByAddingObject:val2];
		 vals2 = [vals1 arrayByAddingObject:val2];, nil, NO, 
		 "We can build basic strings and arrays for tests");
  
  data1 = [NSKeyedArchiver archivedDataWithRootObject:vals2];
  pass((data1 != nil && [data1 length] != 0), "archivedDataWithRootObject: seems ok");
  
  pass([NSKeyedArchiver archiveRootObject:vals2 toFile:val1],"archiveRootObject:toFile: seems ok"); 
  
  a = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
  NSLog(@"From data: original array %@, decoded array %@",vals2, a);
  pass((a != nil && [a isKindOfClass:[NSArray class]] && [a isEqual:vals2]),
       "unarchiveObjectWithData: seems ok");
  
  a = [NSKeyedUnarchiver unarchiveObjectWithFile:val1];
  NSLog(@"From file: original array %@, decoded array %@",vals2, a);
  pass((a != nil && [a isKindOfClass:[NSArray class]] && [a isEqual:vals2]),
       "unarchiveObjectWithFile: seems ok");

  /**
  data2 = [NSMutableData data];
  archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData: data2];
  [archiver encodeObject: val3 forKey: @"string"];
  [archiver finishEncoding];
  unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData: data2];
  s = RETAIN([unarchiver decodeObjectForKey: @"string"]);
  pass((s != nil && [s isKindOfClass:[NSString class]] && [s isEqual: val3]),"encodeObject:forKey: seems okay");
  NSLog(@"Original string: %@, unarchived string: %@",val3,s);
  */
  // DESTROY(arp);
  return 0;
}
