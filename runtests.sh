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
# Usage: ./runtests.sh [directory | test1.m [test2.m ...]]
#
# Runs the specified tests, or "all" tests if no arguments are given. A
# summary is written to tests.sum, a log to tests.log, and a brief summary
# to stdout.

# Argument checking
while test $# != 0
do
  gs_option=
  case $1 in
    --help | -h)
      echo "$0: Script to run the GNUstep testsuite"
      echo "Usage: ./runtests.sh [directory | test1.m [test2.m ...]]"
      echo "Options:"
      echo "  --help	- Print help"
      echo "  --debug	- Compile using debug=yes"
      echo
      exit 0
      ;;
      --debug | -d)
      MAKEFLAGS="$MAKEFLAGS debug=yes"
      export MAKEFLAGS
      run_args="$run_args --debug"
      ;;
      --verbose | -V)
      VERBOSE=yes
      ;;
      --version | -v)
      echo "Testsuite 0.2 modified by Sheldon Gill"
      ;;
    *)
      break
      ;;
  esac
  shift
done

if [ ! "$MAKE_CMD" ]
  then
    if gmake --version > /dev/null 2>&1
    then
      MAKE_CMD=gmake
    else
      MAKE_CMD=make
    fi
fi
export MAKE_CMD
TEMP=`echo *`
TESTDIRS=
for file in $TEMP; do
    if [ -d $file -a $file != CVS ]; then
	TESTDIRS="$TESTDIRS $file"
    fi
done

TOPDIR=`pwd`

if [ x$1 != x ]; then
    if [ -d $1 ]; then
	# Only find in the directories specified.
	TESTDIRS=$*
    else
	TESTDIRS=
	TESTS=$*
    fi
fi

run_test_file ()
{
	echo >> tests.log
	echo begin test $TESTFILE... >> tests.log
	echo >> tests.sum
	echo TEST: $TESTFILE... >> tests.sum

	# Run the test. Log everything to a temporary file.
	$TOPDIR/runtest.sh $run_args $TESTFILE $TOPDIR > tests.tmp 2>&1

	# Add the information to the detailed log.
	cat tests.tmp >> tests.log

	# Extract the summary information and add it to the summary file.
#	grep "^[COMP|PAS|FAIL|TEST|UN][A-Z]*:" tests.tmp > tests.sum.tmp
	egrep "^[A-Z0-9]{4,20}[:-]" tests.tmp > tests.sum.tmp
	cat tests.sum.tmp >> tests.sum

	# If there was anything other than PASS and COMPLETE in the summary...
	if grep -L -v "^\(PASS\|COMPLETED\)" tests.sum.tmp > /dev/null; then
		# ... print them to stdout.
		echo
		echo $TESTFILE:
		grep -v "^\(PASS\|COMPLETED\)" tests.sum.tmp
	fi
}


# Delete the old files.
rm -f tests.log tests.sum

echo `date` Test commencing on `hostname` > tests.log
cat tests.log > tests.sum

if [ x"$TESTDIRS" = x ]; then
    # I think we should depreciate this part, but for now...
    for TESTFILE in $TESTS; do
	   run_test_file
    done
else
    for dir in $TESTDIRS; do
	echo "--- Running tests in $dir ---"
	if [ -f $dir/Custom_makefile ]; then
	    TESTS=$dir/Custom_makefile
	else
		TEST_BLOCKS=`find $dir -name \*.m | sort | sed -e 's/\(^\| \)X[^ ]*//g'`
		CUSTOM_TEST=`find $dir -name Custom_makefile | sort`

        TESTS="$TEST_BLOCKS $CUSTOM_TEST"
	fi

	# If there is a top-level makefile, run it first
	if [ -f $dir/Top_makefile ]; then
	    cd $dir; $MAKE_CMD $MAKEFLAGS 2>&1; cd $TOPDIR
	fi
	for TESTFILE in $TESTS; do
	    if [ $VERBOSE ]; then
            echo Found test block $TESTFILE
        fi
	    run_test_file
    done
    done
fi

# Make some stats.
TESTTOTAL=`grep "^[TEST][A-Z]*:" tests.sum | cut -d: -f1 | sort | uniq -c`
echo    $TESTTOTAL BLOCKS > tests.tmp
grep "^[COMP|PAS|FAIL|UN][A-Z]*:" tests.sum | cut -d: -f1 | sort | uniq -c >> tests.tmp

echo >> tests.sum
cat tests.tmp >> tests.sum

echo
cat tests.tmp


# Delete the temporary file.
rm -f tests.tmp tests.sum.tmp

