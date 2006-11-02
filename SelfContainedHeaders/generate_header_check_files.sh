#!/bin/bash
# Quick hack to auto-generate all the header checking files.

mkdir $1
for I in /usr/GNUstep/System/Library/Headers/$1/*.h ; do
  NAME=`basename $I`

  # Don't check compatibility headers from the great header exodus.
  if ! grep -l "#warning.*is now included" $I >/dev/null 2>&1 ; then
    echo "#include <"$1"/"$NAME">" > $1/$NAME".m"
    echo '#include "ObjectTesting.h"' >> $1/$NAME".m"
    echo '@class NSAutoreleasePool;' >> $1/$NAME".m"
    echo 'int main()' >> $1/$NAME".m"
    echo '{' >> $1/$NAME".m"
    echo '  NSAutoreleasePool *arp = [NSAutoreleasePool new];' >> $1/$NAME".m"
    echo '' >> $1/$NAME".m"
    echo "  pass (1, \"include of $1/$NAME works\");" >> $1/$NAME".m"
    echo '  [arp release];' >> $1/$NAME".m"
    echo '  return 0;' >> $1/$NAME".m"
    echo '}' >> $1/$NAME".m"
  fi
done

