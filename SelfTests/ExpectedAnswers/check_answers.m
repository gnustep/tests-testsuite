#include "Testing.h"

int main(int argc, char **argv)
{
  char *expected_answer = get_test_answer("WhatIsTheProjectName");

  pass(!strcmp("GNUstep",expected_answer),
         "Can get answer from TestAnswers.");
  return 0;
}

