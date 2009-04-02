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
      echo "$0: Script to run the GNUstep testsuite"
      echo "Usage: ./runtests.sh [directory | test1.m [test2.m ...]]"
      echo "Options:"
      echo "  --help	- Print help"
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
  grep "^[A-Z]*:" $CWD/tests.tmp > $CWD/tests.sum.tmp
  cat $CWD/tests.sum.tmp >> $CWD/tests.sum

  # If there was anything other than PASS and COMPLETE in the summary...
  if grep -L -v "^\(PASS\|COMPLETED\)" $CWD/tests.sum.tmp > /dev/null; then
    # ... print them to stdout.
    echo
    echo $TESTFILE:
    grep -v "^\(PASS\|COMPLETED\)" $CWD/tests.sum.tmp
  fi
}


# Delete the old files.
rm -f tests.log tests.sum

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

