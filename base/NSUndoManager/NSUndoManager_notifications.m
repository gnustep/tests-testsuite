#import "Testing.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSUndoManager.h>
#import <Foundation/NSNotification.h>
#import <Foundation/NSString.h>

static NSUndoManager *um;

unsigned        openGroupCount;
unsigned        groupingLevels[32] = {0};
unsigned        checkPointCounter = 0;

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
  if (checkPointCounter<sizeof(groupingLevels))
    groupingLevels[checkPointCounter++] = [um groupingLevel];
  gotCheckPoint = (checkPoint == YES); 
}
- (void) openUndoGroup:(NSNotification *)notif
{
  gotOpenUndoGroup = (openUndoGroup == YES);
  openGroupCount++;
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
  openGroupCount--;
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

  openGroupCount = 0;
  pass([um groupingLevel] == 0, "start at top level");
  [um beginUndoGrouping]; 
  pass(groupingLevels[0] == 1, "grouping level during 1. check point");
  pass(groupingLevels[1] == 2, "grouping level during 2. check point");
  pass(openGroupCount == 2 && [um groupingLevel] == 2,
    "implicit open when grouping by events");
  [um endUndoGrouping];
  pass(openGroupCount == 1 && [um groupingLevel] == 1,
    "no implicit close when grouping by events");
  [um endUndoGrouping];
  pass(openGroupCount == 0 && [um groupingLevel] == 0,
    "grouping level matched notifications");

  [um setGroupsByEvent: NO];

  pass(([um groupingLevel] == 0), "level 0 before any grouping");
  [um beginUndoGrouping]; 
  [obj setFooReg:one];
  [um endUndoGrouping];
  
  gotWillUndo = NO;
  willdidUndo = YES;
  [um undo];
  pass((gotWillUndo == YES),
       "-undo posts NSUndoManagerWillUndoChangeNotification");
  willdidUndo = NO;
  
  gotWillRedo = NO;
  willdidRedo = YES;
  [um redo];
  pass((gotWillRedo == YES),
       "-undo posts NSUndoManagerWillRedoChangeNotification");
  willdidRedo = NO;
  
  gotDidUndo = NO;
  willdidUndo = YES;
  [um undo];
  pass((gotDidUndo == YES),
       "-undo posts NSUndoManagerDidUndoChangeNotification");
  willdidUndo = NO;
  
  gotDidRedo = YES; 
  willdidRedo = YES;
  [um redo];
  pass((gotDidRedo == YES), 
       "-undo posts NSUndoManagerDidRedoChangeNotification");
  willdidRedo = NO;
  
  gotOpenUndoGroup = NO;
  openUndoGroup = YES;
  [um beginUndoGrouping];
  openUndoGroup = NO;
  pass((gotOpenUndoGroup == YES), 
       "-beginUndoGroup sends a NSUndoManagerDidOpenUndoGroupNotification");
  
  [obj setFooReg:two];
  
  closeUndoGroup = YES;
  gotCloseUndoGroup = NO;
  [um endUndoGrouping];
  pass((gotCloseUndoGroup == YES),
       "-endUndoGroup sends a NSUndoManagerDidCloseUndoGroupNotification");
  
  pass([um groupingLevel] == 0,"we are at level zero");

  gotCheckPoint = NO;
  checkPoint = YES;
  [um beginUndoGrouping];
  pass(gotCheckPoint == YES,"-beginUndoGroup sends a NSUndoManagerCheckPointNotification");
  [obj setFooReg:three];
  gotCheckPoint = NO;
  [um endUndoGrouping];
  pass(gotCheckPoint == YES,"-endUndoGroup sends a NSUndoManagerCheckPointNotification");
  
  [pool release]; pool = nil;
  return 0;
}
