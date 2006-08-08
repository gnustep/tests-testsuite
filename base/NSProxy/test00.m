#import "Testing.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSInvocation.h>
#import <Foundation/NSProxy.h>
#import <Foundation/NSString.h>

@interface MyProxy : NSProxy
{
  id _remote;
}

-(id)initWithRemote:(id)receiver;
@end

@implementation MyProxy
-(id) init
{
  _remote = nil;
  return self;
}
- (void) dealloc
{
  RELEASE(_remote);
}
-(void) setRemote:(id)remote
{
  ASSIGN(_remote,remote);
}
-(NSString *) description
{
  return [_remote description];
}
-(id) remote
{
  return _remote;
}
- (NSMethodSignature *) methodSignatureForSelector:(SEL)aSelector
{
  NSMethodSignature *sig = [_remote methodSignatureForSelector:aSelector];
  if (sig == nil)
    sig = [self methodSignatureForSelector:aSelector];
  return sig;
}
- (void) forwardInvocation:(NSInvocation *)inv
{
  [inv setTarget:_remote];
  [inv invoke];
}
@end

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  char *prefix = "The class 'NSProxy' ";
  Class theClass = NSClassFromString(@"NSProxy");
  id obj = nil;
  id rem = @"Remote";
  
  pass(theClass == [NSProxy class], "uses +class to return self");
  pass([[NSProxy alloc] isProxy] == YES,
       "%s implements -isProxy to return YES",prefix);
  pass([[NSProxy alloc] description] != nil, "%s implements -description",prefix);
  obj = [[MyProxy alloc] init];
  pass(obj != nil, "Can create a MyProxy instance");
  [obj setRemote:rem];
  pass([obj remote] == rem, "Can set the remote object for the proxy");
  pass([obj length] == [rem length], "Can get the length of the remote object");
  
  DESTROY(arp);
  return 0;
}
