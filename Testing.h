/* Testing - Include basic tests macros for the GNUstep Testsuite

   Copyright (C) 2005-2011 Free Software Foundation, Inc.

   Written by: Alexander Malmberg <alexander@malmberg.org>
   Updated by: Richard Frith-Macdonald <rfm@gnu.org>
 
   This package is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either
   version 3 of the License, or (at your option) any later version.
 
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   General Public License for more details.
 
*/

#ifndef Testing_h
#define Testing_h

#include <stdio.h>
#include <stdarg.h>

#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSException.h>
#import <Foundation/NSGarbageCollector.h>
#import <Foundation/NSObjCRuntime.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSString.h>

/* A flag indicating that the testsuite is currently processing tests
 * which are actually not expected to pass, but where we hope someone
 * might have committed a bugfix.
 */
static BOOL testHopeful __attribute__((unused)) = NO;

/* A flag indicating whether the most recently executed test passed.
 * This is set by the pass() function (and therefore by any PASS... macro).
 */
static BOOL testPassed __attribute__((unused)) = NO;

/* A variable set whenever a PASS... macro is executed, this contains
 * the exception which terminated the test macro, or nil if no exception
 * was raised.
 */
static NSException *testRaised __attribute__((unused)) = nil;

/* The pass() function is the low-level core of the testsuit.
 *
 * If there is a suitable higher-level test macro available, please use
 * that instead.  In particular, please use the PASS() macro to test any
 * expression where there is a chance that the expression might raise an
 * exception (unless your testcase is inside a set, and you want an
 * exception to end , and use the PASS_EQUAL() macro wherever you wish to test
 * the equality of a pair of objective-c objects.
 *
 * You call this with two arguments ... an integer expression indicating the
 * success or failure of the testcase (0 is a failure) and a string which
 * describes the testcase.
 * The global variable 'testHopeful' can be set to a non-zero value before
 * calling this function in order to specify that if the condition is
 * not true it should be treated as a dashed hope rather than a failure.
 */
static void pass(int testPassed, const char *format, ...)  __attribute__((unused)) __attribute__ ((format(printf, 2, 3)));
static void pass(int testPassed, const char *format, ...)
{
  va_list args;
  va_start(args, format);
  if (testPassed)
    {
      fprintf(stderr, "PASS: ");
      testPassed = YES;
    }
  else if (YES == testHopeful)
    {
      fprintf(stderr, "DASHED: ");
      testPassed = NO;
    }
  else
    {
      fprintf(stderr, "FAIL: ");
      testPassed = NO;
    }
  vfprintf(stderr, format, args);
  fprintf(stderr, "\n");
  va_end(args);
}

/* The unresolved() function is called with a single string argument to
 * notify the testsuite that a test failed to complete for some reason.
 * eg. You might call this if an earlier testcase failed and it makes no
 * sense to run subsequent tests.
 */
static void unresolved(const char *format, ...)  __attribute__((unused)) __attribute__ ((format(printf, 1, 2), unused));
static void unresolved(const char *format, ...)
{
  va_list args;
  va_start(args, format);
  fprintf(stderr, "UNRESOLVED: ");
  vfprintf(stderr, format, args);
  fprintf(stderr, "\n");
  va_end(args);
}

/* The unsupported() function is called with a single string argument to
 * notify the testsuite that a test could not be run because the capability
 * it is testing does not exist on the current platform.
 */
static void unsupported(const char *format, ...)  __attribute__((unused)) __attribute__ ((format(printf, 1, 2), unused));
static void unsupported(const char *format, ...)
{
  va_list args;
  va_start(args, format);
  fprintf(stderr, "UNSUPPORTED: ");
  vfprintf(stderr, format, args);
  fprintf(stderr, "\n");
  va_end(args);
}

/* Tests a code expression which evaluates to an integer value.
 * If the expression evaluates to zero the test does not pass.
 * If the expression causes an exception to be raised, the exception
 * is caught and logged but the test does not pass.
 * Otherwise, the test passes.
 * Basically equivalent to pass() but with exception handling.
 */
#define PASS(expression, args...) \
  NS_DURING \
    { \
      int _cond; \
      id _tmp = testRaised; testRaised = nil; [_tmp release]; \
      [[NSGarbageCollector defaultCollector] collectExhaustively]; \
      _cond = (int) expression; \
      [[NSGarbageCollector defaultCollector] collectExhaustively]; \
      pass(_cond, ## args); \
    } \
  NS_HANDLER \
    testRaised = [localException retain]; \
    pass(0, ## args); \
    printf("%s: %s", [[testRaised name] UTF8String], \
      [[testRaised description] UTF8String]); \
  NS_ENDHANDLER

/* Tests a code expression which evaluates to an object value.
 *
 * If the expression evaluates to an object which is identical to
 * the expect value, or where [object isEqual: expect] returns YES
 * then the test has passed.
 * In all other cases we report the expected value and the actual
 * value.
 *
 * The particularly useful thing about this macro is that, if the
 * results of the expression and the expected object are not equal,
 * the string representation of both values is logged so that you
 * can get a better idea of what went wrong.
 */
#define PASS_EQUAL(expression, expect, args...) \
  NS_DURING \
    { \
      int _cond; \
      id _obj; \
      id _tmp = testRaised; testRaised = nil; [_tmp release]; \
      [[NSGarbageCollector defaultCollector] collectExhaustively]; \
      _obj = ( expression );\
      _cond = _obj == expect || [_obj isEqual: expect]; \
      [[NSGarbageCollector defaultCollector] collectExhaustively]; \
      pass(_cond, ## args); \
      if (0 == _cond) \
	{ \
          NSString  *s = [_obj description]; \
          if ([s length] == 1) \
            { \
              fprintf(stderr, \
		"Expected '%s' and got '%s' (unicode codepoint %d)\n", \
                [[expect description] UTF8String], [s UTF8String], \
		[s characterAtIndex: 0]); \
            } \
	  else \
	    { \
	      fprintf(stderr, "Expected '%s' and got '%s'\n", \
                [[expect description] UTF8String], [s UTF8String]); \
	    } \
	} \
    } \
  NS_HANDLER \
    testRaised = [localException retain]; \
    pass(0, ## args); \
    printf("%s: %s", [[testRaised name] UTF8String], \
      [[testRaised description] UTF8String]); \
  NS_ENDHANDLER

/* Please use the PASS_EXCEPTION() macro to handle any code where you
 * want an exception to be thrown.  The macro checks that the supplied
 * code throws the specified exception.  If the code fails to throw,
 * or throws the wrong exception, then the code does not pass.
 * You can supply nil for expectedExceptionName if you don't care about the
 * type of exception.
 */
#define PASS_EXCEPTION(code, exceptionName, args...) \
  NS_DURING \
    id _tmp = testRaised; testRaised = nil; [_tmp release]; \
    { code; } \
    pass(0, ## args); \
  NS_HANDLER \
    testRaised = [localException retain]; \
    pass((exceptionName == nil \
      || [[testRaised name] isEqual: exceptionName]), ## args); \
    if (exceptionName != nil \
      && ![[testRaised name] isEqual: exceptionName]) \
      printf("%s: %s", [[localException name] UTF8String], \
        [[localException description] UTF8String]); \
  NS_ENDHANDLER

/* Please use the PASS_RUNS() macro to handle any code where you want the
 * code to run to completion without an exception being thrown, but you don't
 * have a particular expression to be checked.
 */
#define PASS_RUNS(code, args...) \
  NS_DURING \
    id _tmp = testRaised; testRaised = nil; [_tmp release]; \
    { code; } \
    pass(1, ## args); \
  NS_HANDLER \
    testRaised = [localException retain]; \
    pass(0, ## args); \
    printf("%s: %s", [[testRaised name] UTF8String], \
      [[testRaised description] UTF8String]); \
  NS_ENDHANDLER


/* SETs are used to group multiple testcases or code which is outside of
 * the scope of the current test but could raise exceptions that should
 * be caught to allow further tests to run.
 *
 * You must pass a 'supported' flag to say whether the code should be run
 * or not, if not then the set is reported as unsupported.
 *
 * The state of the 'testHopeful' flag is saved at the start of the set and
 * restored at the end of the set, so you can start your code by setting
 * 'testHopeful=YES;' to mark any tests within the set as being part of a group
 * of tests we don't expect to pass.
 *
 * The tests within the set are enclosed in an autorelease pool, and any
 * temporary objects are cleaned up at the end of the set.
 */

/* The START_SET() macro starts a set of grouped tests or, if the argument
 * is false, skips the set and reports the set as unsupported.
 */
#define START_SET(supported) \
  if ((supported)) \
    { \
      BOOL save_hopeful = testHopeful; \
      NS_DURING \
	NSAutoreleasePool *_setPool = [NSAutoreleasePool new]; \
	{


/* The END_SET() macro terminates a ser of grouped tests.  It's argument is
 * a printf style frmat string and variable arguments to print a message
 * describing the set.
 */
#define END_SET(desc, args...) \
	} \
      [_setPool release]; \
      NS_HANDLER \
	if (NO == [[localException name] isEqualToString: @"CheckSet"]) \
	  { \
	    fprintf(stderr, "EXCEPTION: %s %s %s\n", \
	      [[localException name] UTF8String], \
	      [[localException reason] UTF8String], \
	      [[[localException userInfo] description] UTF8String]); \
	  } \
	unresolved(desc, ## args); \
     NS_ENDHANDLER \
     testHopeful = save_hopeful; \
    } \
  else \
    { \
      unsupported(desc, ## args); \
    }

/* The NEED macro takes a test macro as an arugment and breaks out of a set
 * and reports it as unresolved test does not pass.
 */
#define	NEED(testToTry) \
  testToTry \
  if (NO == testPassed) \
    { \
      if (nil != testRaised) \
	{ \
	  [testRaised raise]; \
	} \
      else \
	{ \
	  [NSException raise: @"CheckSet" format: @"Test did not pass"]; \
	} \
    }


/* some good macros to compare floating point numbers */
#import <math.h>
#import <float.h>
#define EQ(x, y) (fabs((x) - (y)) <= fabs((x) + (y)) * (FLT_EPSILON * 100))
#define LE(x, y) ((x)<(y) || EQ(x, y))
#define GE(x, y) ((y)<(x) || EQ(x, y))
#define LT(x, y) (!GE(x, y))
#define GT(x, y) (!LE(x, y))

/* A convenience macro to pass an object as a string to a print function. 
 */
#define POBJECT(obj)      [[(obj) description] UTF8String]

#endif

#ifndef	CREATE_AUTORELEASE_POOL
#define	RETAIN(object)		[object retain]
#define	RELEASE(object)		[object release]
#define	AUTORELEASE(object)	[object autorelease]
#define	TEST_RETAIN(object)	({\
id __object = (id)(object); (__object != nil) ? [__object retain] : nil; })
#define	TEST_RELEASE(object)	({\
id __object = (id)(object); if (__object != nil) [__object release]; })
#define	TEST_AUTORELEASE(object)	({\
id __object = (id)(object); (__object != nil) ? [__object autorelease] : nil; })
#define	ASSIGN(object,value)	({\
id __value = (id)(value); \
id __object = (id)(object); \
if (__value != __object) \
  { \
    if (__value != nil) \
      { \
	[__value retain]; \
      } \
    object = __value; \
    if (__object != nil) \
      { \
	[__object release]; \
      } \
  } \
})
#define	ASSIGNCOPY(object,value)	({\
id __value = (id)(value); \
id __object = (id)(object); \
if (__value != __object) \
  { \
    if (__value != nil) \
      { \
	__value = [__value copy]; \
      } \
    object = __value; \
    if (__object != nil) \
      { \
	[__object release]; \
      } \
  } \
})
#define	DESTROY(object) 	({ \
  if (object) \
    { \
      id __o = object; \
      object = nil; \
      [__o release]; \
    } \
})
#define	CREATE_AUTORELEASE_POOL(X)	\
  NSAutoreleasePool *(X) = [NSAutoreleasePool new]
#define RECREATE_AUTORELEASE_POOL(X)  \
  if (X == nil) \
    (X) = [NSAutoreleasePool new]
#endif

