/* ObjectTesting - Include basic object tests for the GNUstep Testsuite

   Copyright (C) 2005 Free Software Foundation, Inc.

   Written by: Matt Rice?
 
   This package is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.
 
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   General Public License for more details.
 
*/
#include <Foundation/NSObjCRuntime.h>
#include <Foundation/NSString.h>
#include <Foundation/NSObject.h>
#include <Foundation/NSArray.h>
#include <Foundation/NSException.h>
#include <Foundation/NSData.h>
#include <Foundation/NSArchiver.h>
#include "Testing.h"

#define TEST_FOR_CLASS(aClassName,aClass,TestDescription) \
                pass([aClass isKindOfClass:NSClassFromString(aClassName)], \
		                     TestDescription)

#define TEST_STRING(code,description) \
	   { \
		NSString *_testString = code; \
		pass(_testString != nil	&& \
		     [_testString isKindOfClass:[NSString class]] && \
		     [_testString length], description); \
	   }

#define START_SET(supported) if ((supported)) { NS_DURING 
#define END_SET(desc , args...) NS_HANDLER \
           fprintf(stderr, "EXCEPTION: %s %s %s\n", \
		   [[localException name] cString], \
		   [[localException reason] cString], \
		   [[[localException userInfo] description] cString]); \
	   unresolved (desc , ## args); \
           NS_ENDHANDLER } \
           else unsupported (desc , ## args)

#define START_TEST(supported) if ((supported)) { NS_DURING 
#define END_TEST(result, desc , args...) \
           pass(result, desc , ## args); \
           NS_HANDLER \
           fprintf(stderr, "EXCEPTION: %s %s %s\n", \
		   [[localException name] cString], \
		   [[localException reason] cString], \
		   [[[localException userInfo] description] cString]); \
           pass (NO, desc , ## args); NS_ENDHANDLER } \
           else unsupported (desc , ## args)

/* i guess if shouldThrow == NO you can pass nil for expectedExceptionName */
/* test if an exception is thrown or not */
#define TEST_EXCEPTION(code, exceptionName, shouldThrow, description) \
		NS_DURING \
		  code \
		  pass(shouldThrow == NO, description); \
		NS_HANDLER \
		  pass((shouldThrow == YES && \
		       [[localException name] isEqual: exceptionName]), \
		       description); \
		  if (shouldThrow == YES && \
		      ![[localException name] isEqual: exceptionName]) \
		      [localException raise]; \
		NS_ENDHANDLER

/* dunno if i like this one... */
/* test a condition fail if any exceptions are thrown */
#define TEST_COND (cond,description) \
	NS_DURING \
	  { \
	    BOOL testCondition = cond; \
            pass(cond,description); \
	  } \
	NS_HANDLER \
	  pass(0, description); \
	  if (cond == NO) printf("%s: %s",[[localException name] cString], [[localException description] cString]); \
	NS_ENDHANDLER

static void test_NSMutableCopying(NSString *iClassName,
				  NSString *mClassName, 
				  NSArray *objects) __attribute__ ((unused));
static void test_alloc(NSString *className) __attribute__ ((unused));
static void test_NSObject(NSString *className, NSArray *objects) __attribute__ ((unused));
static void test_NSCopying(NSString *iClassName,
			   NSString *mClassName,
			   NSArray *objects,
			   BOOL mustRetain,
			   BOOL mustCopy) __attribute__ ((unused));
static void test_NSCoding(NSArray *objects) __attribute__ ((unused));

/* perform basic allocation tests */
static void test_alloc(NSString *className)
{
  Class theClass = NSClassFromString(className);
  id obj0 = nil;
  id obj1 = nil;
  const char *prefix = [[NSString stringWithFormat:@"Class '%@'",className] cString];
  NSZone *testZone = NSCreateZone(1024,1024,1);
  NSZone *theZone;
  pass(theClass != Nil, "%s exists", prefix);
  
  obj0 = [theClass alloc];
  pass(obj0 != nil, "%s has working alloc", prefix);
  pass([obj0 isKindOfClass:theClass], "%s alloc gives the correct class", prefix);
  obj0 = [[theClass alloc] init];
  pass([obj0 isKindOfClass:theClass], "%s has working init", prefix);
  
  obj0 = [theClass new];
  pass([obj0 isKindOfClass:theClass], "%s has working new", prefix);
  
  obj1 = [theClass allocWithZone:testZone];
  pass([obj1 isKindOfClass: theClass],"%s has working allocWithZone",prefix);
  theZone = NSZoneFromPointer(obj1);
  pass(theZone == testZone,"%s uses specified zone for allocWithZone",prefix);
}
/* test for the NSObject protocol */
/* TODO move to ProtocolTesting.h? */
static void test_NSObject(NSString *className, NSArray *objects)
{
  int i;
  Class theClass = Nil;
  theClass = NSClassFromString(className);
  pass(theClass != Nil, "%s is a known className",[className cString]);
  
  for (i=0; i<[objects count];i++)
    {
      id theObj = [objects objectAtIndex:i];
      id mySelf = nil;
      Class myClass = Nil;
      int count0;
      int count1;
      int count2;
      Class sup = Nil;
      const char *prefix;
      prefix = [[NSString stringWithFormat:@"Object %i of class '%@'",i,className] cString];
      pass([theObj conformsToProtocol:@protocol(NSObject)], "%s conforms to NSObject", prefix);
      mySelf = [theObj self];
      pass(mySelf == theObj, "%s can return self", prefix);
      myClass = [theObj class];
      pass(myClass != Nil, "%s can return own class", prefix);
      pass([theObj isKindOfClass:theClass],"%s object %.160s is of correct class", prefix, [[theObj description] cString]);
      pass(mySelf == myClass ? ![theObj isMemberOfClass:myClass] : [theObj isMemberOfClass:myClass],"%s isMemberOfClass works", prefix);
      sup = [theObj superclass];
      pass(theClass == NSClassFromString(@"NSObject") ? sup == nil : (sup != nil && sup != myClass), "%s can return superclass",prefix);
      pass([theObj respondsToSelector:@selector(hash)],"%s responds to hash",prefix);
      pass([theObj isEqual:theObj], "%s isEqual: to self",prefix);
      pass([theObj respondsToSelector:@selector(self)],"%s respondsToSelector:",prefix);
      [theObj isProxy];
      id r = [theObj retain];
      pass(theObj == r, "%s handles retain",prefix); 
      [theObj release];
      [theObj retain];
      [theObj autorelease];

      count0 = [theObj retainCount];
      [theObj retain];
      count1 = [theObj retainCount];
      [theObj release];
      count2 = [theObj retainCount];
      pass((count0 == count2), "%s has working retainCount",prefix);
      pass([[theObj description] isKindOfClass:[NSString class]],"%s has NSString description",prefix);
      pass([theObj performSelector:@selector(self)] == theObj,"%s handles performSelector",prefix);    
    }
}
static void test_NSCoding(NSArray *objects)
{
  int i;
  for (i=0; i < [objects count]; i++)
    { 
      id obj = [objects objectAtIndex:i];
      const char *prefix; 
      NSMutableData *data;
      NSArchiver *archiver;
      id decoded;

      pass([[[obj class] description] length],
	   "I can extract a class name for object");

      prefix = [[NSString stringWithFormat:@"Object %i of class '%s'",i,
                     [NSStringFromClass([obj class]) cString]] cString];
      pass([obj conformsToProtocol:@protocol(NSCoding)], 
           "conforms to NSCoding protocol");
      data = (NSMutableData *)[NSMutableData data]; 
      archiver = [[NSArchiver alloc] initForWritingWithMutableData: data];
      pass(archiver != nil, "I am able to set up an archiver");
      data = nil;
      [archiver encodeRootObject:obj];
      data = [archiver archiverData];
      pass(data && [data length] > 0, "%s can be encoded",prefix);
      decoded = [NSUnarchiver unarchiveObjectWithData:data];
      pass(decoded != nil, "can be decoded");
      pass([decoded isEqual:obj], "decoded object equals the original");
    }
}
static void test_NSCopying(NSString *iClassName,
			   NSString *mClassName,
			   NSArray *objects,
			   BOOL mustRetain,
			   BOOL mustCopy)
{
  Class iClass = NSClassFromString(iClassName);
  Class mClass = NSClassFromString(mClassName);
  int i;
  NSZone *defZone = NSDefaultMallocZone();
  NSZone *testZone = NSCreateZone(1024,1024,1);

  pass(iClass != Nil, "%s is a known class",[iClassName cString]);
  pass(mClass != Nil, "%s is a known class",[mClassName cString]);
  
  for (i=0; i < [objects count]; i++)
    {
      BOOL immutable;
      NSString *theName;
      const char *prefix;
      id theCopy = nil;
      Class theClass = Nil;
      BOOL shouldRetain; 
      id theObj = [objects objectAtIndex:i];
      if (iClass != mClass && [theObj isKindOfClass:mClass])
        { 
	  immutable=NO;
          theName = iClassName;
          theClass = iClass;
        }
      else
        {
	  immutable=YES;
          theName = mClassName;
	  theClass = mClass;
	}
     
      prefix = [[NSString 
                 stringWithFormat:@"Object %i of class '%s'", i, [theName cString]] cString];
      pass([theObj conformsToProtocol:@protocol(NSCopying)], 
           "conforms to NSCopying");
      if (mustCopy)
        {
	  shouldRetain = NO;
        }
      else if (mustRetain)
        {
	  shouldRetain = YES;
        }
      else	
        {
          shouldRetain = NSShouldRetainWithZone(theObj, defZone);
	}
      theCopy = [theObj copy];
      pass(theCopy != nil, "%s understands -copy", prefix);
      pass([theCopy isKindOfClass:iClass],"%s copy is of correct type",prefix);
      pass([theObj isEqual:theCopy], "%s original and copy are equal",prefix);
      if (immutable)
        { 
	  if (shouldRetain)
	    {
	      pass(theCopy == theObj, 
	           "%s is retained by copy with same zone",prefix);
            }
          else
            { 
	      pass(theCopy != theObj, "%s is not retained by copy with same zone",prefix);
	    }
	}
      if (theClass != iClass)
        {
          pass(![theCopy isKindOfClass: theClass], 
	       "%s result of copy is not immutable",prefix);
	}
    
      if (mustCopy)
        shouldRetain = NO;
      else if (mustRetain)
        shouldRetain = YES;
      else
        shouldRetain = NSShouldRetainWithZone(theObj,testZone);
      
      theCopy = [theObj copyWithZone:testZone];
      pass(theCopy != nil, "%s understands -copyWithZone",prefix);
      pass([theCopy isKindOfClass:iClass], "%s zCopy has correct type",prefix);
      pass([theObj isEqual:theCopy], "%s copy and original are equal",prefix);
      if (immutable)
        {
           if (shouldRetain)
	     {
	       pass(theCopy == theObj,"%s is retained by copy with other zone",prefix);
	     }
	   else
	     {
	       pass(theCopy != theObj,"%s is not retained by copy with other znoe",prefix);
             }
	}
     if (theClass != iClass)
       pass(![theCopy isKindOfClass:theClass], "%s result of copyWithZone: is not immutable",prefix);
    }
}


static void test_NSMutableCopying(NSString *iClassName,
				  NSString *mClassName, 
				  NSArray *objects)
{
  int i;
  Class iClass = Nil;
  Class mClass = Nil;
  NSZone *testZone = NSCreateZone(1024, 1024, 1);
  iClass = NSClassFromString(iClassName);
  pass(iClass != Nil, "%s is a known class", [iClassName cString]);
  
  mClass = NSClassFromString(mClassName);
  pass(mClass != Nil, "%s is a known class", [mClassName cString]);
  
  for (i = 0; i < [objects count]; i++)
    {
      id theObj = [objects objectAtIndex:i];
      NSString *theName = nil;
      const char *prefix;
      BOOL immutable;
      id theCopy = nil;
      Class theClass = Nil;
          
      if (iClass == mClass && [theObj isKindOfClass:mClass])
        immutable = NO;
      else
        immutable = YES;
      
      if (immutable)
        {
          theName = iClassName;
          theClass = iClass;
	}
      else
        {
          theName = mClassName;
	  theClass = mClass;
	}
      
      prefix = [[NSString 
                 stringWithFormat:@"Object %i of class '%s'", i, [theName cString]] cString];
      pass([theObj conformsToProtocol:@protocol(NSMutableCopying)],
           "%s conforms to NSMutableCopying protocol",prefix);
      theCopy = [theObj mutableCopy];
      pass(theCopy != nil, "%s understands -mutableCopy",prefix);
      pass([theCopy isKindOfClass:mClass], 
           "%s mutable copy is of correct type" ,prefix);
      pass([theCopy isEqual:theObj], "%s copy equals original",prefix);
      pass(theCopy != theObj, 
           "%s not retained by mutable copy in the same zone",[mClassName cString]);
      
      theCopy = [theObj mutableCopyWithZone:testZone];
      pass(theCopy != nil,"%s understands mutableCopyWithZone",[mClassName cString]);
      pass(theCopy != theObj, 
           "%s not retained by mutable copy in other zone",[mClassName cString]);
    }
  
}

