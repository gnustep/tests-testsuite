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

static void pass(int testPassed, const char *description, ...) __attribute__ ((format(printf, 2, 3)));
static void pass(int testPassed, const char *description, ...)
{
  va_list args;
  va_start(args, description);
  fprintf(stderr, testPassed?"PASS: ":"FAIL: ");
  vfprintf(stderr, description, args);
  fprintf(stderr, "\n");
  va_end(args);
}
static void unresolved(const char *description, ...) __attribute__ ((format(printf, 1, 2), unused));
static void unresolved(const char *description, ...)
{
  va_list args;
  va_start(args, description);
  fprintf(stderr, "UNRESOLVED: ");
  vfprintf(stderr, description, args);
  fprintf(stderr, "\n");
  va_end(args);
}
static void unsupported(const char *description, ...) __attribute__ ((format(printf, 1, 2), unused));
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
#define POBJECT(obj)      [[obj description] lossyCString]

/* some good macros to compare floating point numbers */
#include <math.h>
#include <float.h>
#define EQ(x, y) (fabs((x) - (y)) <= fabs((x) + (y)) * (FLT_EPSILON * 100))
#define LE(x, y) ((x)<(y) || EQ(x, y))
#define GE(x, y) ((y)<(x) || EQ(x, y))
#define LT(x, y) (!GE(x, y))
#define GT(x, y) (!LE(x, y))

#endif

