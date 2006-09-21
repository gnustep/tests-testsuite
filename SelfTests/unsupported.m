/*
 *  Verify the unsupported() testsuite call.
 *
 *    Use this to note that the particular test is not supported in this
 *    execution. Generally it is because the underlying platform doesn't
 *    support the feature.
 *    It can also mark a test for features no longer supported but still
 *    present, or experimental features "in-development".
 *
 *  AUTHOR:  Sheldon Gill
 *
 *  COPYRIGHT (C) 2006, Sheldon Gill
 *  License: GPL V2
 */
#include "Testing.h"

int main(int argc, char **argv)
{
	unsupported("Dummy unsuppored test.");
	return 0;
}

