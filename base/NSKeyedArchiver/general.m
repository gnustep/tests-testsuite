#import <Foundation/NSString.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSKeyedArchiver.h>
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSData.h>
#import <Foundation/NSFileManager.h>
#import <Foundation/NSValue.h>
#import "Testing.h"
#import "ObjectTesting.h"

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  NSString *val1, *val2, *val3, *s;
  NSNumber *val4;
  NSArray  *vals1, *vals2;
  NSData   *data1;
  NSMutableData *data2;
  NSArray *a;
  NSKeyedArchiver *archiver = nil;
  NSKeyedUnarchiver *unarchiver = nil;

  TEST_EXCEPTION(val1 = [NSString stringWithCString:"Archiver.dat"];
		 val2 = [NSString stringWithCString:"A Goodbye"];
		 val3 = [NSString stringWithCString:"Testing all strings"];
		 val4 = [NSNumber numberWithUnsignedInt: 100];
		 vals1 = [[[NSArray arrayWithObject:val1] 
			    arrayByAddingObject:val2] 
			   arrayByAddingObject: val4];		 
		 vals2 = [vals1 arrayByAddingObject: val2];, nil, NO, 
		 "We can build basic strings and arrays for tests");
  
  pass([NSKeyedArchiver archiveRootObject:vals2 toFile:val1],
    "archiveRootObject:toFile: seems ok"); 
  
  data1 = [NSKeyedArchiver archivedDataWithRootObject:vals2];
  pass((data1 != nil && [data1 length] != 0),
    "archivedDataWithRootObject: seems ok");
  
  a = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
  NSLog(@"From data: original array %@, decoded array %@",vals2, a);
  pass((a != nil && [a isKindOfClass:[NSArray class]] && [a isEqual:vals2]),
       "unarchiveObjectWithData: seems ok");
  
  a = [NSKeyedUnarchiver unarchiveObjectWithFile:val1];
  NSLog(@"From file: original array %@, decoded array %@",vals2, a);
  pass((a != nil && [a isKindOfClass:[NSArray class]] && [a isEqual:vals2]),
       "unarchiveObjectWithFile: seems ok");

  // encode
  data2 = [[NSMutableData alloc] initWithCapacity: 10240];
  archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData: data2];
  [archiver encodeObject: val3 forKey: @"string"];
  [archiver finishEncoding];

  // decode...
  unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData: data2];
  s = [[unarchiver decodeObjectForKey: @"string"] retain];
  pass((s != nil && [s isKindOfClass:[NSString class]] && [s isEqual: val3]),
    "encodeObject:forKey: seems okay");
  [data2 release];

  NSLog(@"Original string: %@, unarchived string: %@",val3, s);

  [[NSFileManager  defaultManager] removeFileAtPath: val1 handler: nil];
  [arp release]; arp = nil;
  return 0;
}
