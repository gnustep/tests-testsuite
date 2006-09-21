/*
 *  Call a non-existent function so we will fail when linking.
 *
 *  AUTHOR:  Sheldon Gill
 *
 *  COPYRIGHT (C) 2006, Sheldon Gill
 *  License: GPL V2
 */
#include "Testing.h"

int non_existent(void);

int main(int argc, char *argv[])
{
  return non_existent();
}

