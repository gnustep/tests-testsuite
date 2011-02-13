#
#  GNUmakefile for the GNUstep testsuite
#  
#  Copyright (C) 2005 Free Software Foundation, Inc.
#
#  Written by:	Adam Fedor <fedor@gnu.org>
#
#  This package is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public
#  License as published by the Free Software Foundation; either
#  version 2 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
#  General Public License for more details.
#
#
# Use this to clean the project and for various administrative
# functions. Use runtests.sh to run tests.

PACKAGE_NAME = Testsuite
VERSION = 0.1.0

SUBPROJECTS = base gui coding gdl2 SelfTests SelfContainedHeaders

include $(GNUSTEP_MAKEFILES)/common.make

-include GNUmakefile.preamble

# FIXME: Commented out since the subproject's makefiles don't seem to
# exist!
#include $(GNUSTEP_MAKEFILES)/aggregate.make

all:
	@(echo "Starting 'gnustep-tests base' to run the base library tests.")
	@(echo "Please use 'gnustep-tests' to run more tests.")
	gnustep-tests base

-include GNUmakefile.postamble

after-clean::
	rm -f tests.log tests.sum

after-distclean::
	rm -f SelfTests/GNUmakefile coding/GNUmakefile


