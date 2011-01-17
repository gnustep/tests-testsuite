/* Testing - Include basic tests macros for the GNUstep Testsuite

   Copyright (C) 2005 Free Software Foundation, Inc.

   Written by: Alexander Malmberg <alexander@malmberg.org>
 
   This package is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.
 
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   General Public License for more details.
 
*/

#ifndef Testing_h
#define Testing_h

#include <stdio.h>
#include <stdarg.h>

/* The pass() function is the core of the testsuiit.
 * You call it with two arguments ... an intger expression indicating the
 * success or failure of the testcase (0 is a failure) and a string which
 * describes the testcase.
 */
static void pass(int testPassed, const char *description, ...)  __attribute__((unused)) __attribute__ ((format(printf, 2, 3)));
static void pass(int testPassed, const char *description, ...)
{
  va_list args;
  va_start(args, description);
  fprintf(stderr, testPassed ?"PASS: " : "FAIL: ");
  vfprintf(stderr, description, args);
  fprintf(stderr, "\n");
  va_end(args);
}

/* The hope() function is similar to pass() but is used where it is expected
 * that the testcase is likely to fail (eg. a test for a known bug which may
 * have been fixed by the time the testsuite is run).
 */
static void hope(int testPassed, const char *description, ...)  __attribute__((unused)) __attribute__ ((format(printf, 2, 3)));
static void hope(int testPassed, const char *description, ...)
{
  va_list args;
  va_start(args, description);
  fprintf(stderr, testPassed ? "PASS: " : "DASHED: ");
  vfprintf(stderr, description, args);
  fprintf(stderr, "\n");
  va_end(args);
}

/* The unresolved() function is called with a single string argument to
 * notify the testsuite that a test failed to complete for some reason.
 * eg. You might call this if an earlier testcase failed and it makes no
 * sense to run subsequent tests.
 */
static void unresolved(const char *description, ...)  __attribute__((unused)) __attribute__ ((format(printf, 1, 2), unused));
static void unresolved(const char *description, ...)
{
  va_list args;
  va_start(args, description);
  fprintf(stderr, "UNRESOLVED: ");
  vfprintf(stderr, description, args);
  fprintf(stderr, "\n");
  va_end(args);
}

/* The unsupported() function is called with a single string argument to
 * notify the testsuite that a test could not be run because the capability
 * it is testing does not exist on the current platform.
 */
static void unsupported(const char *description, ...)  __attribute__((unused)) __attribute__ ((format(printf, 1, 2), unused));
static void unsupported(const char *description, ...)
{
  va_list args;
  va_start(args, description);
  fprintf(stderr, "UNSUPPORTED: ");
  vfprintf(stderr, description, args);
  fprintf(stderr, "\n");
  va_end(args);
}

/* Pass an object as a string to a print function.  */
#define POBJECT(obj)      [[obj description] UTF8String]

/* some good macros to compare floating point numbers */
#import <math.h>
#import <float.h>
#define EQ(x, y) (fabs((x) - (y)) <= fabs((x) + (y)) * (FLT_EPSILON * 100))
#define LE(x, y) ((x)<(y) || EQ(x, y))
#define GE(x, y) ((y)<(x) || EQ(x, y))
#define LT(x, y) (!GE(x, y))
#define GT(x, y) (!LE(x, y))

#endif

#import	<Foundation/NSObject.h>

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

