#!/bin/sh
#
#  run tests script for the GNUstep Testsuite
#
#  Copyright (C) 2005-2010 Free Software Foundation, Inc.
#
#  Written by:  Alexander Malmberg <alexander@malmberg.org>
#
#  This package is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public
#  License as published by the Free Software Foundation; either
#  version 2 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  General Public License for more details.
#
#
# Usage: ./runtest.sh test_name.m
#
# Compiles and runs the test test_name. Detailed logging should go to stdout;
# only summary information should go to stderr.

USEDEBUG=YES
# Argument checking
while test $# != 0
do
  gs_option=
  case $1 in
    --help | -h)
      echo "$0: Script to run a test a GNUstep testsuite program"
      echo "Usage: ./runtest.sh test_name.m"
      echo "Options:"
      echo "  --help	- Print help"
      echo
      exit 0
      ;;
    --debug | -d)	# ignore for backward compatibility
      ;;
    *)
      break
      ;;
  esac
  shift
done

if [ x$1 = x ]
then
  echo "ERROR: $0: No test given"
  exit 1
fi

if [ $# != 1 ]
then
  echo "ERROR: $0: Too many arguments (single test file name expected)"
  exit 1
fi

if [ -e $1 ]
then

  if [ ! -f $1 ]
  then
    echo "ERROR: $0: Argument ($1) is not the name of a regular file"
    exit 1
  fi

  if [ ! -r $1 ]
  then
    echo "ERROR: $0: Test file ($1) is not readable by you"
    exit 1
  fi

else
  echo "ERROR: $0: Test file ($1) does not exist"
  exit 1
fi

if test -z "$GNUSTEP_MAKEFILES"; then
  GNUSTEP_MAKEFILES=`gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null`
  if test -z "$GNUSTEP_MAKEFILES"; then
    echo "You need to have GNUstep-make installed and set up."
    echo "Did you remember to source GNUstep.sh?"
  else
    . $GNUSTEP_MAKEFILES/GNUstep.sh
  fi
fi

# Move to the test's directory.
DIR=`dirname $1`
if [ ! -d $DIR ]; then
  echo "Unable to proceed ... $DIR is not a directory"
  exit 1
fi
cd $DIR
DIR=`pwd`
TOP=$DIR
while [ ! -f runtest.sh ]; do
  if [ $TOP = / ]; then
    echo "Unable to locate top-level directory"
    exit 1;
  fi
  TOP=`dirname $TOP`
  cd $TOP
done
# Check that we are not in the top level ... where creating a GNUmakefile
# would trash an existing makefile.
cd $DIR
if [ -f runtest.sh ]; then
  echo "Unable to proceed ... test file is in top level directory"
  exit 1
fi

if [ ! "$MAKE_CMD" ]
then
  MAKE_CMD=gmake
  $MAKE_CMD --version > /dev/null 2>&1
  if [ $? != 0 ]
  then
    MAKE_CMD=make
  fi
fi

NAME=`basename $1`

if [ ! -f IGNORE ] 
then
  # Remove the extension, if there is one. If there is no extension, add
  # .obj .
  TESTNAME=`echo $NAME | sed -e"s/^\([^.]*\)$/\1.obj./;s/\.[^.]*//g"`

  # Check for a custom makefile, if it exists use it.
  if [ -r Custom.mk ]
  then
    if [ $NAME = "Custom.mk" ] 
    then
      echo "include Custom.mk" >>GNUmakefile
    else
      exit 0
    fi
  else
    # Create the GNUmakefile by filling in the name of the test.
    sed -e "s/@TESTNAME@/$TESTNAME/;s/@FILENAME@/$NAME/;s^@INCLUDEDIR@^$TOP^" < $TOP/GNUmakefile.tests > GNUmakefile
  fi

  # Clean up to avoid contamination by previous tests. (Optimistically) assume
  # that	this will never fail in any interesting way.
  $MAKE_CMD clean >/dev/null 2>&1

  # Compile it. Redirect errors to stdout so it shows up in the log, but not
  # in the summary.
  $MAKE_CMD $MAKEFLAGS messages=yes debug=yes 2>&1
  if [ $? != 0 ]
  then
    echo COMPILEFAIL: $1 >&2
  else
    # We want aggressive memory checking.

    # Tell glibc to check for malloc errors, and to crash if it detects
    # any.
    MALLOC_CHECK_=2
    export MALLOC_CHECK

    # Tell GNUstep-base to check for messages sent to deallocated objects
    # and crash if it happens.
    NSZombieEnabled=YES
    CRASH_ON_ZOMBIE=YES
    export NSZombieEnabled CRASH_ON_ZOMBIE

    echo Running $1...
    # Run it. If it terminates abnormally, mark it as a crash (unless we have
    # a special file to mark it as being expected to abort).
    $MAKE_CMD -s test
    if [ $? != 0 ]
    then
      if [ -r $NAME.abort ]
      then
        echo COMPLETED: $1 >&2
      else
        echo FAIL: $1 >&2
      fi
    else
      echo COMPLETED: $1 >&2
    fi
  fi

  rm -f GNUmakefile

  # Clean up to avoid contaminating later tests. (Optimistically) assume that
  # this will never fail in any interesting way.
  rm -f core
  #$MAKE_CMD clean >/dev/null 2>&1
fi
