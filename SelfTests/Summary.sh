#!/bin/sh
#
# Script to generate summary/advice based on the data in tests.sum
#
if [ "$GSTESTMODE" = "clean" ]
then
  exit 0
fi

grep -q "Passed test$" tests.sum
pt=$?
grep -q "Failed test$" tests.sum
ft=$?
grep -q "Failed build$" tests.sum
fb=$?
grep -q "Failed file$" tests.sum
ff=$?


if [ "$pt" = "0" -a "$ft" = "0" -a "$fb" = "0" -a "$ff" = "0" ]
then
  echo "Self tests all OK!"
else
  echo "Problem ... was expecting one passed test, one failed test,"
  echo "one failed build, one failed file."
fi

