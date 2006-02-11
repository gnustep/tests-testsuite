#include "Testing.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSUndoManager.h>
#include <Foundation/NSNotification.h>

static NSUndoManager *um;
BOOL sane;
BOOL isUndoing;
BOOL isRedoing;

static void checkSanity()
{
  sane = ([um isUndoing] == isUndoing && [um isRedoing] == isRedoing);
  if (sane == NO)
    {
      fprintf(stderr, "FAIL: basic sanity tests\n");
    }
}
@interface Foo : NSObject
{
  NSString *_foo;
  int _number;
}
@end

@implementation Foo
- (id) init
{
  self = [super init];
  um  = [NSUndoManager new];
  return self;
}

- (void) setFooReg:(id)newFoo
{ 
  checkSanity();
  [um registerUndoWithTarget:self selector:@selector(setFooReg:) object:_foo];
  ASSIGN(_foo,newFoo);
}

- (void) setFooPrep:(id)newFoo
{
  checkSanity();
  [[um prepareWithInvocationTarget:self] setFooPrep:_foo];
  ASSIGN(_foo,newFoo);
}
- (id) fooUndo
{
  isUndoing = YES;
  isRedoing = NO;
  [um undo];
  return _foo;
}

- (id) fooRedo
{
  isUndoing = NO;
  isRedoing = YES;
  [um redo];
  return _foo;
}

- (NSString *)foo
{
  return _foo;
}

- (int) numUndo
{
  isUndoing = YES;
  isRedoing = NO;
  [um undo];
  return _number;
}

- (int) numRedo
{
  isUndoing = NO;
  isRedoing = YES;
  [um redo];
  return _number;
}

- (void) setNumber:(int)newNum
{
  checkSanity();
  [[um prepareWithInvocationTarget:self] setNumber:_number];
  _number = newNum;
}

- (int) number
{
  return _number;
}
@end

int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  id obj = [Foo new]; 
  id one, two, three, four, five, six, seven, eight;
  id bar;
  int rc;

  one = @"one";
  two = @"two";
  three = @"three";
  four = @"four";
  five = @"five"; 
  six = @"six";
  seven = @"seven";
  eight = @"eight";

  [um beginUndoGrouping]; 
  isUndoing = NO;
  isRedoing = NO;
  [obj setFooReg:one];
  [um endUndoGrouping];
  
  pass(([obj fooUndo] == nil && sane),
       "registerWithUndoTarget:selector:object single level undo");
  pass(([obj fooRedo] == one && sane),
       "registerWithUndoTarget:selector:object single level redo");
  
  [um beginUndoGrouping];
  isUndoing = NO;
  isRedoing = NO;
  [obj setFooReg:two];
  [um endUndoGrouping];
  
  [um beginUndoGrouping];
  [obj setFooReg:three];
  [um endUndoGrouping];
  
  pass(([obj fooUndo] == two && sane
  	&& [obj fooUndo] == one && sane 
	&& [obj fooUndo] == nil && sane),
       "registerWithUndoTarget:selector:object multi level undo");

  pass(([obj fooRedo] == one && sane 
  	&& [obj fooRedo] == two && sane 
	&& [obj fooRedo] == three && sane),
       "registerWithUndoTarget:selector:object multi level redo");
  
  [um beginUndoGrouping];
  isUndoing = NO;
  isRedoing = NO;
  [obj setFooPrep:four];
  [um endUndoGrouping];
  
  [um beginUndoGrouping];
  [obj setFooPrep:five];
  [um endUndoGrouping];
  
  pass(([obj fooUndo] == four && sane),
       "prepareWithInvocationTarget single level undo");
  pass(([obj fooRedo] == five && sane),
       "prepareWithInvocationTarget single level redo");
  
  [um beginUndoGrouping];
  isUndoing = NO;
  isRedoing = NO;
  [obj setFooPrep:six];
  [um endUndoGrouping];
  
  pass(([obj fooUndo] == five && sane 
  	&& [obj fooUndo] == four && sane),
       "prepareWithInvocationTarget multi level undo");
  pass(([obj fooRedo] == five && sane 
  	&& [obj fooRedo] == six && sane),
       "prepareWithInvocationTarget multi level redo");
  
  pass(([obj fooUndo] == five && sane
	&& [obj fooUndo] == four && sane
	&& [obj fooUndo] == three && sane
	&& [obj fooUndo] == two && sane
	&& [obj fooUndo] == one && sane
	&& [obj fooUndo] == nil && sane),
       "mixing prepare... and register... in undo stack");
  
  pass(([obj fooRedo] == one && sane
  	&& [obj fooRedo] == two && sane
	&& [obj fooRedo] == three && sane
	&& [obj fooRedo] == four && sane
	&& [obj fooRedo] == five && sane
	&& [obj fooRedo] == six && sane),
       "mixing prepare... and register... in redo stack");
  
  [um beginUndoGrouping];
  isUndoing = NO;
  isRedoing = NO;
  [obj setNumber:1];
  [um endUndoGrouping];
  
  pass(([obj numUndo] == 0), "single level undo with int argument");
  pass(([obj numRedo] == 1), "single level redo with int argument");
  
  [um beginUndoGrouping];
  isUndoing = NO;
  isRedoing = NO;
  [obj setNumber:2];
  [um endUndoGrouping];
  
  [um beginUndoGrouping];
  isUndoing = NO;
  isRedoing = NO;
  [obj setNumber:3];
  [um endUndoGrouping];
  
  pass(([obj numUndo] == 2 && sane
  	&& [obj numUndo] == 1 && sane
	&& [obj numUndo] == 0 && sane),
       "multi level undo with int argument");
  pass(([obj numRedo] == 1 && sane 
       && [obj numRedo] == 2 && sane
       && [obj numRedo] == 3 && sane),
      "multi level redo with int argument");
  
  [um beginUndoGrouping];
  isUndoing = NO;
  isRedoing = NO;
  [obj setNumber:7];
  [obj setFooPrep:seven];
  [um endUndoGrouping];
  
  [um beginUndoGrouping];
  isUndoing = NO;
  isRedoing = NO;
  [obj setNumber:8];
  [obj setFooReg:eight];
  [um endUndoGrouping];
  
  isRedoing = NO;
  isUndoing = YES;  
  [um undo];
  pass(([obj number] == 7 && sane && [obj foo] == seven && sane),
       "undo grouping works with undo");
  
  isUndoing = NO;
  isRedoing = YES;
  [um redo];
  pass(([obj number] == 8 && sane && [obj foo] == eight && sane),
       "undo grouping works with redo");
  DESTROY(um);  
  um = [[NSUndoManager alloc] init];
  [um setLevelsOfUndo: 2];
  pass(([um levelsOfUndo] == 2), "setLevelsOfUndo: is sane.");
  
  one = @"one";
  two = @"two";
  three = @"three";
  four = @"four";
 
  [um beginUndoGrouping];
  isUndoing = NO;
  isRedoing = NO;
  [obj setFooPrep:one];
  [um endUndoGrouping];
  
  [um beginUndoGrouping];
  isUndoing = NO;
  isRedoing = NO;
  [obj setFooPrep:two];
  [um endUndoGrouping];
  
  [um beginUndoGrouping];
  isUndoing = NO;
  isRedoing = NO;
  [obj setFooPrep:three];
  [um endUndoGrouping];
  
  [um beginUndoGrouping];
  isUndoing = NO;
  isRedoing = NO;
  [obj setFooPrep:four];
  [um endUndoGrouping];

  pass(([obj fooUndo] == three && sane
	&& [obj fooUndo] == two && sane
	&& [obj fooUndo] == two && sane),
       "levels of undo really works with undo.");
  
  pass(([obj fooRedo] == three && sane 
	&& [obj fooRedo] == four && sane 
	&& [obj fooRedo] == four && sane),
       "levels of undo really works with redo.");
 
  bar = [[NSObject alloc] init];
  rc = [bar retainCount];
  [um registerUndoWithTarget:obj selector:@selector(setFooReg:) object:bar];
  pass(([bar retainCount] == (rc + 1)),"registerUndoWithTarget:selector:object: retains its argument object");
  isRedoing = NO;
  isUndoing = YES;
  
  rc = [bar retainCount];
  [um undo];  /* setFooReg: should cause a retain. */
  [pool dealloc];
  pool = [NSAutoreleasePool new];
  pass((rc == [bar retainCount]),"-undo causes NSUndoManager to release its argument object");
  DESTROY(pool);
  return 0;
}
