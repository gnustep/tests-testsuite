#!/bin/sh
#
#  run tests script for the GNUstep Testsuite
#
#  Copyright (C) 2005 Free Software Foundation, Inc.
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
# Usage: ./runtest.sh test_name
#
# Compiles and runs the test test_name. Detailed logging should go to stdout;
# summary information should go to stderr.

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
      echo "  --debug	- Compile using debug=yes"
      echo
      exit 0
      ;;
    --debug | -d)
      MAKEFLAGS="$MAKEFLAGS debug=yes";;
    *)
      break
      ;;
  esac
  shift
done

if [ x$1 = x ]; then
	echo ERROR: $0: No test given
fi

DIR=`dirname $1`
NAME=`basename $1`
TOPDIR=$2
if [ ! "$MAKE_CMD" ]
  then
    MAKE_CMD=gmake
    if ( ! $MAKE_CMD --version > /dev/null 2>&1 )
      then
      MAKE_CMD=make
    fi
fi

if [ ! -e $DIR/IGNORE ]
  then
    # Remove the extension, if there is one. If there is no extension, add
    # .obj .
    TESTNAME=`echo $NAME | sed -e"s/^\([^.]*\)$/\1.obj./;s/\.[^.]*//g"`
    CWD=`pwd`

#DBG echo Invoked from $TOPDIR
#DBG echo In $DIR told to do $TESTNAME while in \"$CWD\"

    # Check for a custom makefile generator, if none exists generate one.
    if [ -r $DIR/Custom_makefile ]
      then
        if [ $NAME = "Custom_makefile" ]
          then
            echo "-include Flags.mk" >$DIR/GNUmakefile
            echo "ADDITIONAL_OBJCFLAGS += -I" $TOPDIR >>$DIR/GNUmakefile
            echo "include Custom_makefile" >>$DIR/GNUmakefile
          else
            echo file $NAME requires Custom_makefile so ignoring
	        exit 0
        fi
      else
        #DBG echo Checking GNUmakefile
        # Check the GNUmakefile and auto-generate one if necessary
        if [ -f $DIR/GNUmakefile ]; then
            IS_GEN=`head -n 1 $DIR/GNUmakefile | grep __GENERATED__`
            #DBG echo $IS_GEN
          else
            IS_GEN=""
        fi
        if [ "$IS_GEN" == "" ]
          then
            echo "PROBLEM_MAKEFILE: Can't generate $DIR/GNUmakefile. Custom one in the way"
            exit 1
          else
            # Create the GNUmakefile by filling in the name of the test.
            #DBG echo Creating $DIR/GNUmakefile
            sed -e "s/@TESTNAME@/$TESTNAME/;s/@FILENAME@/$NAME/;s^@INCLUDEDIR@^$CWD^" < $TOPDIR/GNUmakefile.tests > $DIR/GNUmakefile
        fi
    fi
    # Move to the test's directory.
    cd $DIR

    # Clean up to avoid contamination by previous tests. (Optimistically) assume
    # that	this will never fail in any interesting way.
    #make clean >/dev/null 2>&1

    # Compile it. Redirect errors to stdout so it shows up in the log, but not
    # in the summary.
    if [ ! -f GNUmakefile ]; then
        echo ERROR: No Makefile in `pwd`
        exit 1
    fi

    if ! ( $MAKE_CMD $MAKEFLAGS 2>&1 ); then
   	echo COMPILEFAIL: $1 >&2
    else
	# We want aggressive memory checking.

	# Tell glibc to check for malloc errors, and to crash if it detects
	# any.
	export MALLOC_CHECK_=2

	# Tell GNUstep-base to check for messages sent to deallocated objects
	# and crash if it happens.
	export NSZombieEnabled=YES
	export CRASH_ON_ZOMBIE=YES

	echo Running $1...
	# Run it. If it terminates abnormally, mark it as a crash.
	if ! $MAKE_CMD -s test; then
		echo FAIL: $1 >&2
	else
		echo COMPLETED: $1 >&2
	fi
    fi

    # Clean up to avoid contaminating later tests. (Optimistically) assume that
    # this will never fail in any interesting way.
    rm -f core
    rm -f obj/*
    #make clean >/dev/null 2>&1
fi
