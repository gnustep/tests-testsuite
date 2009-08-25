/*
copyright 2008 David Ayers <ayers@fsfe.org>

Tests that boolValue of certain strings return the correct value.
*/

#import "Testing.h"

#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSString.h>

int main(int argc, char **argv)
{
  NSString *constantStringY[]={
    @"y",@"Y",@"t",@"T",@"1",@"9",
    @"-y",@"-Y",@"-t",@"-T",@"-1",@"-9",
    @"Yes",@"YES",@"yes"
  };
  NSString *constantStringN[]={
    @"n",@"N",@"f",@"F",@"0",@"00",
    @"-n",@"-N",@"-f",@"-F",@"-0",@"-00",
    @"No",@"NO",@"no",
    @"0.0",@"0,0",
    @"0.1",@"0,1"
  };
  NSString *normalString;
  NSMutableString *mutableString;
  unsigned i;

  [NSAutoreleasePool new];
  for (i=0;i<(sizeof(constantStringY)/sizeof(constantStringY[0]));i++)
    {
      pass([constantStringY[i] boolValue] == YES, "constant:%s == YES", [constantStringY[i] lossyCString]);
      pass([constantStringN[i] boolValue] == NO,  "constant:%s == NO",  [constantStringN[i] lossyCString]);

      normalString = [NSString stringWithString:constantStringY[i]];
      pass([normalString boolValue] == YES, "normal:%s == YES", [normalString lossyCString]);
      normalString = [NSString stringWithString:constantStringN[i]];
      pass([normalString boolValue] == NO,  "normal:%s == NO",  [normalString lossyCString]);

      mutableString = (id)[NSMutableString stringWithString:constantStringY[i]];
      pass([mutableString boolValue] == YES, "mutable:%s == YES", [mutableString lossyCString]);
      mutableString = (id)[NSMutableString stringWithString:constantStringN[i]];
      pass([mutableString boolValue] == NO,  "mutable:%s == NO",  [mutableString lossyCString]);
    }

  return 0;
}
