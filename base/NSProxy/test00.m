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
  [_remote release];
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
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
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
  pass([obj isEqual: obj], "proxy isEqual: to self without remote");
  [obj setRemote:rem];
  pass([obj remote] == rem, "Can set the remote object for the proxy");
  pass([obj length] == [rem length], "Can get the length of the remote object");
  pass(NO == [obj isEqual: rem], "proxy isEqual: to remote returns NO");
  pass(NO == [rem isEqual: obj], "remote isEqual: to proxy returns NO");
  pass([obj isEqualToString: rem], "proxy isEqualToString: to remote");
  pass([rem isEqualToString: obj], "remote isEqualToString: to proxy");
  pass([obj compare: rem] == NSOrderedSame, "proxy compare: remote");
  pass([rem compare: obj] == NSOrderedSame, "remote compare: proxy");
  
  [arp release]; arp = nil;
  return 0;
}
