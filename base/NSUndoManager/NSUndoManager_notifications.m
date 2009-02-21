#import "Testing.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSUndoManager.h>
#import <Foundation/NSNotification.h>
#import <Foundation/NSString.h>

static NSUndoManager *um;

BOOL shouldBeUndoing; 
BOOL shouldBeRedoing;

BOOL checkPoint;
BOOL openUndoGroup;
BOOL willdidUndo;
BOOL willdidRedo;
BOOL closeUndoGroup;

BOOL gotCheckPoint;
BOOL gotOpenUndoGroup;
BOOL gotDidUndo;
BOOL gotWillUndo;
BOOL gotDidRedo;
BOOL gotWillRedo;
BOOL gotCloseUndoGroup;

@interface Foo : NSObject
{
  NSString *_foo;
  int _number;
}
@end

@implementation Foo
- (id) init
{
  NSNotificationCenter *nc;
  self = [super init];
  um  = [NSUndoManager new];
  nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self selector:@selector(checkPoint:) 
  	     name:NSUndoManagerCheckpointNotification object:um];
  [nc addObserver:self selector:@selector(openUndoGroup:)
  	     name:NSUndoManagerDidOpenUndoGroupNotification object:um];
  [nc addObserver:self selector:@selector(didUndo:) 
  	     name:NSUndoManagerDidUndoChangeNotification object:um];
  [nc addObserver:self selector:@selector(willUndo:)
  	     name:NSUndoManagerWillUndoChangeNotification object:um];
  [nc addObserver:self selector:@selector(didRedo:)
  	     name:NSUndoManagerDidRedoChangeNotification object:um];
  [nc addObserver:self selector:@selector(willRedo:)
  	     name:NSUndoManagerWillRedoChangeNotification object:um];
  [nc addObserver:self selector:@selector(closeUndoGroup:)
  	     name:NSUndoManagerWillCloseUndoGroupNotification object:um];
  
  return self;
}
- (void) checkPoint:(NSNotification *)notif
{
  gotCheckPoint = (checkPoint == YES); 
}
- (void) openUndoGroup:(NSNotification *)notif
{
  gotOpenUndoGroup = (openUndoGroup == YES);
}
- (void) didUndo:(NSNotification *)notif
{
  gotDidUndo = (willdidUndo == YES);
}
- (void) willUndo:(NSNotification *)notif
{ 
  gotWillUndo = (willdidUndo == YES);
}
- (void) didRedo:(NSNotification *)notif
{
  gotDidRedo = (willdidRedo == YES);
}
- (void) willRedo:(NSNotification *)notif
{
  gotWillRedo = (willdidRedo == YES);
}
- (void) closeUndoGroup:(NSNotification *)notif
{
  gotCloseUndoGroup = (closeUndoGroup == YES);
}
- (void) setFooReg:(id)newFoo
{ 
  [um registerUndoWithTarget:self selector:@selector(setFooReg:) object:_foo];
  _foo = newFoo;
}
- (void) setFooPrep:(id)newFoo
{
  [[um prepareWithInvocationTarget:self] setFooPrep:_foo];
  ASSIGN(_foo,newFoo);
}
@end

int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  id obj = [Foo new]; 
  id one, two, three, four, five, six, seven, eight;

  one = @"one";
  two = @"two";
  three = @"three";
  four = @"four";
  five = @"five"; 
  six = @"six";
  seven = @"seven";
  eight = @"eight";

  pass(([um groupingLevel] == 0), "level 0 before any grouping");
  [um beginUndoGrouping]; 
  [obj setFooReg:one];
  [um endUndoGrouping];
  pass(([um groupingLevel] == 1), "level 1 after making one group");
  
  gotWillUndo = NO;
  willdidUndo = YES;
  [um undo];
  pass((gotWillUndo == YES),
       "-undo posts NSUndoManagerWillUndoChangeNotification");
  willdidUndo = NO;
  pass(([um groupingLevel] == 0), "level 0 after undoing one group");
  
  gotWillRedo = NO;
  willdidRedo = YES;
  [um redo];
  pass((gotWillRedo == YES),
       "-undo posts NSUndoManagerWillRedoChangeNotification");
  willdidRedo = NO;
  pass(([um groupingLevel] == 0), "level 0 after redoing one group");
  
  gotDidUndo = NO;
  willdidUndo = YES;
  [um undo];
  pass((gotDidUndo == YES),
       "-undo posts NSUndoManagerDidUndoChangeNotification");
  willdidUndo = NO;
  pass(([um groupingLevel] == 0), "level 0 after undoing again");
  
  gotDidRedo = YES; 
  willdidRedo = YES;
  [um redo];
  pass((gotDidRedo == YES), 
       "-undo posts NSUndoManagerDidRedoChangeNotification");
  willdidRedo = NO;
  pass(([um groupingLevel] == 0), "level 0 after redoing again");
  
  gotOpenUndoGroup = NO;
  openUndoGroup = YES;
  [um beginUndoGrouping];
  openUndoGroup = NO;
  pass((gotOpenUndoGroup == YES), 
       "-beginUndoGroup sends a NSUndoManagerDidOpenUndoGroupNotification");
  
  pass(([um groupingLevel] == 2), "level 2 after beginning a group");
  [obj setFooReg:two];
  
  closeUndoGroup = YES;
  gotCloseUndoGroup = NO;
  [um endUndoGrouping];
  pass((gotCloseUndoGroup == YES),
       "-endUndoGroup sends a NSUndoManagerDidCloseUndoGroupNotification");
  
  pass(([um groupingLevel] == 1), "level 1 after ending a group");

  gotCheckPoint = NO;
  checkPoint = YES;
  [um beginUndoGrouping];
  pass(gotCheckPoint == YES,"-beginUndoGroup sends a NSUndoManagerCheckPointNotification");
  pass(([um groupingLevel] == 2), "level 2 after beginning another group");
  [obj setFooReg:three];
  gotCheckPoint = NO;
  [um endUndoGrouping];
  pass(gotCheckPoint == YES,"-endUndoGroup sends a NSUndoManagerCheckPointNotification");
  
  pass(([um groupingLevel] == 1), "level 1 after ending another group");
  [pool release]; pool = nil;
  return 0;
}
