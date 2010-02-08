/*
copyright 2004 Alexander Malmberg <alexander@malmberg.org>
*/

#include "Testing.h"

#include <stdio.h>

#include <Foundation/NSArchiver.h>
#include <Foundation/NSArray.h>
#include <Foundation/NSAttributedString.h>
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSCharacterSet.h>
#include <Foundation/NSData.h>
#include <Foundation/NSDate.h>
#include <Foundation/NSDateFormatter.h>
#include <Foundation/NSDictionary.h>
#include <Foundation/NSException.h>
#include <Foundation/NSFormatter.h>
#include <Foundation/NSNotification.h>
#include <Foundation/NSNull.h>
#include <Foundation/NSObject.h>
#include <Foundation/NSSet.h>
#include <Foundation/NSString.h>
#include <Foundation/NSURL.h>
#include <Foundation/NSValue.h>

@interface NSObject (DecodingTests)
+ (NSObject*) createTestInstance;
+ (BOOL) verifyTestInstance: (NSObject *)instance
	ofVersion: (int)version;
- (BOOL) testEquality;
@end

@implementation NSObject (DecodingTests)
+ (NSObject *) createTestInstance
{
  if (self == [NSException class])
    {
      return [[NSException alloc] initWithName: @"Test"
					reason: @"Testing"
				      userInfo: nil];
    }
  else
    {
      return [[self alloc] init];
    }
}

+ (BOOL) verifyTestInstance: (NSObject *)instance
		  ofVersion: (int)version
{
  
  return instance != nil
    && ([instance testEquality] == NO 
      || [[self createTestInstance] isEqual: instance]);
}

- (BOOL) testEquality
{
  static IMP impNSObject = 0;
  /* By default, assume that every class that overrides NSObject's
     isEqual: implementation can compare archived instances.  
     subclasses for which this doesn't hold can simply override this
     method in a category and return a constant YES/NO.  */

  if (!impNSObject) 
    {
      impNSObject = [NSObject instanceMethodForSelector:@selector(isEqual:)];
    }
  return [self methodForSelector:@selector(isEqual:)] == impNSObject
    ? NO : YES;
}
@end

@implementation NSCharacterSet (DecodingTests)
+ (NSObject *) createTestInstance
{
  return [[self characterSetWithCharactersInString: @"qwertzuiop"] retain];
}
@end

@implementation NSValue (DecodingTests)
+ (NSObject *) createTestInstance
{
  return [[self valueWithSize: NSMakeSize(1.1, 1.2)] retain];
}
@end

@implementation NSNumber (DecodingTests)
+ (NSObject *) createTestInstance
{
  return [[self numberWithInt: 1] retain];
}
@end

@implementation NSData (DecodingTests)
+ (NSObject *) createTestInstance
{
  return [[@"We need constant data" dataUsingEncoding: NSUnicodeStringEncoding] retain];
}
@end

@implementation NSDate (DecodingTests)
+ (NSObject *) createTestInstance
{
  return [[NSDate dateWithTimeIntervalSince1970: 4294967296.0] retain];
}
@end

@implementation NSURL (DecodingTests)
+ (NSObject *) createTestInstance
{
  return [[self alloc] initWithString: @"http://www.gnustep.org/"];
}
@end


/*
If set, we write out new .data files for the current versions for classes
that don't have them.
*/
BOOL update;

void test(Class class)
{
  NS_DURING
    {
      /*
      In order to catch decoders that don't consume all the data that they
      should, we decode/encode an array that includes the object and a string.
      We verify that the string was correctly decoded, although any errors will
      likely be caught by crashes in the unarchiver.
      */
      NSString	*sentinel = @"quux!";

      int	v = [class version];
      NSObject	*instance;
      NSArray	*decodedInstance;
      NSData	*d;
      NSString	*filename;

      instance = [class createTestInstance];

      d = [NSArchiver archivedDataWithRootObject:
	[NSArray arrayWithObjects: instance, sentinel, nil]];
      decodedInstance = [NSUnarchiver unarchiveObjectWithData: d];

      assert([sentinel isEqual: [decodedInstance objectAtIndex: 1]]);

      pass([class verifyTestInstance: [decodedInstance objectAtIndex: 0]
	ofVersion: v], "decoding current version of class %s", POBJECT(class));

      for (; v >= 0; v--)
	{
	  filename = [NSString stringWithFormat: @"%@.%i.data", class, v];
	  d = [NSData dataWithContentsOfFile: filename];
	  if (!d)
	    {
	      if (v == [class version])
		{
		  if (!update)
		    pass(0, "%s has reference data for the current version",
		      POBJECT(class));
		  else
		    [NSArchiver archiveRootObject:
		      [NSArray arrayWithObjects: instance, sentinel, nil]
					 toFile: filename];
		}
	      continue;
	    }

	  decodedInstance = [NSUnarchiver unarchiveObjectWithData: d];
	  assert([sentinel isEqual: [decodedInstance objectAtIndex: 1]]);
	  pass([class verifyTestInstance: [decodedInstance objectAtIndex: 0]
	    ofVersion: v], "decoding version %i of class %s",
	    v, POBJECT(class));
	}
    }
  NS_HANDLER
    {
      pass(0, "decoding class %s: %s", 
	POBJECT(class), POBJECT(localException));
    }
  NS_ENDHANDLER
}

int main(int argc, char **argv)
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];

  update = argc == 2 && !strcmp(argv[1], "--update");

#define T(c) test([c class]);
  T(NSArray)
  T(NSAttributedString)
  T(NSCharacterSet)
  T(NSData)
  T(NSMutableData)
  T(NSDate)
  T(NSDateFormatter)
  T(NSDictionary)
  T(NSException)
  T(NSNotification)
  T(NSNull)
  T(NSObject)
  T(NSSet)
  T(NSString)
  T(NSURL)
  T(NSValue)
  T(NSNumber)

  [arp release]; arp = nil;

  return 0;
}

