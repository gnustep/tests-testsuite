#!/bin/bash
# Quick hack to auto-generate all the header checking files.

for I in /opt/GNUstep/System/Library/Headers/$1/*.h ; do
	NAME=`basename $I`

	# Don't check compatibility headers from the great header exodus.
	if ! grep -l "#warning.*is now included" $I >/dev/null 2>&1 ; then
		echo "#include <"$1"/"$NAME">" > $1/$NAME".m"
		echo "int main(int argc,char **argv){return 0;}" >> $1/$NAME".m"
	fi
done

