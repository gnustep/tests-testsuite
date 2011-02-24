#include "../GDL2Testing.h"

int
main(int argc, char *argv[])
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  volatile BOOL result;
  EOQualifier *qual;

  START_SET("EOQualifier/" __FILE__);
  START_TEST(YES);
  qual = [EOQualifier qualifierWithQualifierFormat:@"bla = %%"];
  result = [qual isKindOfClass:[EOKeyComparisonQualifier class]];
  END_TEST(result, "parsing fromat with 'bla = %%%%' literal");

  START_TEST(YES);
  qual = [EOQualifier qualifierWithQualifierFormat:@"bla = %%bla"];
  result = [qual isKindOfClass:[EOKeyComparisonQualifier class]];
  END_TEST(result, "parsing fromat with 'bla = %%%%bla' literal");

  START_TEST(YES);
  qual = [EOQualifier qualifierWithQualifierFormat:@"bla = bla%%"];
  result = [qual isKindOfClass:[EOKeyComparisonQualifier class]];
  END_TEST(result, "parsing fromat with 'bla = bla%%%%' literal");

  START_TEST(YES);
  qual = [EOQualifier qualifierWithQualifierFormat:@"bla = bla%%bla"];
  result = [qual isKindOfClass:[EOKeyComparisonQualifier class]];
  END_TEST(result, "parsing fromat with 'bla = bla%%%%bla' literal");

  START_TEST(YES);
  qual = [EOQualifier qualifierWithQualifierFormat:@"bla = %%bla%%"];
  result = [qual isKindOfClass:[EOKeyComparisonQualifier class]];
  END_TEST(result, "parsing fromat with 'bla = %%%%bla%%%%' literal");

  END_SET("EOQualifier/" __FILE__);
  [pool release];

  return 0;
}


