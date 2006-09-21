#!/bin/sh
#
#  self-check the GNUstep Testsuite
#
#  Copyright (C) 2006 Free Software Foundation, Inc.
#
#  Written by:  Sheldon Gill <sheldon@westnet.net.au>
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
# Usage: ./selfcheck.sh
#
# Runs a series of test cases to verify the operation of the testsuite
# scripts themselves.
#
# Summary is written to tests.sum, a log to tests.log, and a brief summary
# to stdout.

if [ ! x$1 == x ]; then
    echo "Self check script does not accept any arguments!"
    exit 1
fi

echo -------- GNUstep Testsuite Self Check ------------

./runtests.sh -v

./runtests.sh -V SelfTests

echo --------------------------------------------------

# FIXME: We should parse test.sum and produce a *real* analysis?

echo self check done
echo
echo "There should be 13 test blocks"
echo "There should be  3 compile failures"
echo "There should be  7 completed test blocks"
echo "There should be  2 failed tests"
echo "There should be  1 pass"
echo "There should be  1 unresolved"
echo "There should be  1 unsupported"
echo "There should be  1 log output"
echo
echo Testsuite is ready for action

