/*
 *  Synthetic NSLog() output which should be immediately sent to console
 *    as well as picked up in the summary information.
 *
 *  AUTHOR:  Sheldon Gill
 *
 *  COPYRIGHT (C) 2006, Sheldon Gill
 *  License: GPL V2
 */
#include "Testing.h"

int main(int argc, char **argv)
{
	printf("1234-67-89 11:11:00 Dummy problem logged from test.\n");
	return 0;
}

