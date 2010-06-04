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
# Runs the specified tests, or "all" tests if no arguments are given.
# A summary is written to tests.sum, a log to tests.log, and a brief
# summary to stdout.
# The log and summary from the previous testrun are renamed to
# oldtests.log and oldtests.sum, available for comparison.

if test -z "$GNUSTEP_MAKEFILES"; then
  GNUSTEP_MAKEFILES=`gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null`
  if test -z "$GNUSTEP_MAKEFILES"; then
    echo "You need to have GNUstep-make installed and set up."
    echo "Did you remember to source GNUstep.sh?"
  else
    . $GNUSTEP_MAKEFILES/GNUstep.sh
  fi
fi

# Argument checking
while test $# != 0
do
  gs_option=
  case $1 in
    --help | -h)
      echo
      echo "$0: Script to run the GNUstep testsuite"
      echo "Usage: ./runtests.sh [directory | test1.m [test2.m ...]]"
      echo "Runs the specified tests, or "all" tests if no arguments are given."
      echo
      echo "Interpreting the output"
      echo "-----------------------"
      echo "The summary output lists all test failures ... there should not"
      echo "be any.  If a test fails then either there is a problem in the"
      echo "software beign tested, or a problem in the test itsself. Either"
      echo "way, you should try to fix the problem and provide a patch, or"
      echo "at least report it at: https://savannah.gnu.org/bugs/?group=gnustep"
      echo
      echo "After the listing of any failures is a summary of counts of events:"
      echo "COMPLETED:   The number of separate test files which were run."
      echo "COMPILEFAIL: The number of separate test files which failed to run."
      echo "DASHED:      The number of hopes dashed ... tests which failed, but"
      echo "             which were expected to perhaps fail (known bugs etc)."
      echo "FAIL:        The number of individual tests failed"
      echo "PASS:        The number of individual tests passed"
      echo "UNRESOLVED:  The number of unresolved tests ... tests which have"
      echo "             been omitted because of an earlier failure etc."
      echo "UNRESOLVED:  The number of unsupported tests ... those for features"
      echo "             which work on some platforms, but not on yours."
      echo
      exit 0
      ;;
      --debug | -d)	# ignore for backward compatibility.
      ;;
    *)
      break
      ;;
  esac
  shift
done

if [ ! "$MAKE_CMD" ]
then
  gmake --version > /dev/null 2>&1
  if [ $? = 0 ]
  then
    MAKE_CMD=gmake
  else
    MAKE_CMD=make
  fi
fi
export MAKE_CMD
TEMP=`echo *`
TESTDIRS=
for file in $TEMP
do
  if [ -d $file -a $file != CVS -a $file != obj ]
  then
    TESTDIRS="$TESTDIRS $file"
  fi
done

if [ x$1 != x ]
then
  if [ -d $1 ]
  then
    # Only find in the directories specified.
    TESTDIRS=$*
  else
    TESTDIRS=
    TESTS=$*
  fi
fi

CWD=`pwd`
TOP=$CWD
while [ ! -f runtests.sh ]; do
  if [ $TOP = / ]; then
    echo "Unable to locate top-level directory"
    exit 1;
  fi
  TOP=`dirname $TOP`
  cd $TOP
done
RUNCMD=$TOP/runtest.sh
cd $CWD

run_test_file ()
{
  echo >> $CWD/tests.log
  echo Testing $TESTFILE... >> $CWD/tests.log
  echo >> $CWD/tests.sum

  # Run the test. Log everything to a temporary file.
  $RUNCMD $run_args $TESTFILE > $CWD/tests.tmp 2>&1

  # Add the information to the detailed log.
  cat $CWD/tests.tmp >> $CWD/tests.log

  # Extract the summary information and add it to the summary file.
  grep "^\(PASS\|FAIL\|COMPILEFAIL\|COMPLETED\|DASHED\|UNRESOLVED\|UNSUPPORTED\)" $CWD/tests.tmp > $CWD/tests.sum.tmp
  cat $CWD/tests.sum.tmp >> $CWD/tests.sum

  # If there were failures or unresolved tests then report them...
  if grep -L "^\(COMPILEFAIL\|FAIL\|UNRESOLVED\)" $CWD/tests.sum.tmp > /dev/null; then
    echo
    echo $TESTFILE:
    grep "^\(COMPILEFAIL\|FAIL\|UNRESOLVED\)" $CWD/tests.sum.tmp
  fi
}


# Delete the old files.
if [ -f tests.log ]
then
  mv tests.log oldtests.log
fi
if [ -f tests.sum ]
then
  mv tests.sum oldtests.sum
fi

if [ x"$TESTDIRS" = x ]
then
  # I think we should depreciate this part, but for now...
  for TESTFILE in $TESTS
  do
    run_test_file
  done
else
  for dir in $TESTDIRS
  do
    echo "--- Running tests in $dir ---"
    TESTS=`find $dir -name \*.m | sort | sed -e 's/\(^\| \)X[^ ]*//g'`
    # If there is a GNUmakefile.tests in the directory, run it first.
    # Unless ... we are at the top level, in which case that file is
    # our template.
    cd $dir
    if [ $TOP != `pwd` ]
    then
      if [ -f GNUmakefile.tests ]
      then
        cp GNUmakefile.tests GNUmakefile
        $MAKE_CMD $MAKEFLAGS debug=yes 2>&1
	rm -f GNUmakefile
      fi
    fi
    cd $CWD
    for TESTFILE in $TESTS
    do
      run_test_file
    done
  done
fi

# Make some stats.
grep "^[A-Z]*:" tests.sum | cut -d: -f1 | sort | uniq -c > tests.tmp

echo >> tests.sum
cat tests.tmp >> tests.sum

echo
cat tests.tmp


# Delete the temporary file.
rm -f tests.tmp tests.sum.tmp

