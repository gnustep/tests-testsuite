/*
 *  Verify the unresolved() testsuite call.
 *
 *    Use this to note that the outcome of the particular test cannot be
 *    determined for correctness. This flags to everyone that there is
 *    an issue to be examined and resolved.
 *    Eventually it should be replaced with a pass()
 *
 *  AUTHOR:  Sheldon Gill
 *
 *  COPYRIGHT (C) 2006, Sheldon Gill
 *  License: GPL V2
 */
#include "Testing.h"

int main(int argc, char **argv)
{
	unresolved("Dummy unresolved test.");
	return 0;
}

