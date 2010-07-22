#import "Testing.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSInvocation.h>
#import <Foundation/NSProxy.h>
#import <Foundation/NSString.h>

@interface MyString : NSString
{
  id    _remote;
}
@end

@interface MyProxy : NSProxy
{
  id    _remote;
}
@end

@implementation MyString
- (id) init
{
  _remote = nil;
  return self;
}
- (void) dealloc
{
  [_remote release];
}
- (unichar) characterAtIndex: (NSUInteger)i
{
  return [_remote characterAtIndex: i];
}
- (NSUInteger) length
{
  return [_remote length];
}
- (void) setRemote:(id)remote
{
  ASSIGN(_remote,remote);
}
- (id) remote
{
  return _remote;
}
@end

@implementation MyProxy
- (id) init
{
  _remote = nil;
  return self;
}
- (void) dealloc
{
  [_remote release];
}
- (NSUInteger) hash
{
  if (_remote)
    return [_remote hash];
  else
    return [super hash];
}
- (BOOL) isEqual: (id)other
{
  if (_remote)
    return [_remote isEqual: other];
  else
    return [super isEqual: other];
}
- (void) setRemote:(id)remote
{
  ASSIGN(_remote,remote);
}
- (NSString *) description
{
  return [_remote description];
}
- (id) remote
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
  id sub = nil;
  
  pass(theClass == [NSProxy class], "uses +class to return self");
  pass([[NSProxy alloc] isProxy] == YES,
       "%s implements -isProxy to return YES",prefix);
  pass([[NSProxy alloc] description] != nil, "%s implements -description",prefix);
  obj = [[MyProxy alloc] init];
  pass(obj != nil, "Can create a MyProxy instance");
  pass([obj isEqual: obj], "proxy isEqual: to self without remote");
  [obj setRemote: rem];
  pass([obj remote] == rem, "Can set the remote object for the proxy");
  sub = [[MyString alloc] init];
  pass(sub != nil, "Can create a MyString instance");
  [sub setRemote: rem];
  pass([sub remote] == rem, "Can set the remote object for the subclass");
  pass([obj length] == [rem length], "Get the length of the remote object");
  pass([sub length] == [rem length], "Get the length of the subclass object");
  pass([obj isEqual: rem], "proxy isEqual: to remote");
  pass([obj isEqual: sub], "proxy isEqual: to subclass");
  pass([sub isEqual: rem], "subclass isEqual: to remote");
  pass([sub isEqual: obj], "subclass isEqual: to proxy");
  pass([rem isEqual: obj], "remote isEqual: to proxy");
  pass([rem isEqual: sub], "remote isEqual: to subclass");
  pass([obj isEqualToString: rem], "proxy isEqualToString: to remote");
  pass([obj isEqualToString: sub], "proxy isEqualToString: to subclass");
  pass([sub isEqualToString: rem], "subclass isEqualToString: to remote");
  pass([sub isEqualToString: obj], "subclass isEqualToString: to proxy");
  pass([rem isEqualToString: obj], "remote isEqualToString: to proxy");
  pass([rem isEqualToString: sub], "remote isEqualToString: to subclass");
  pass([obj compare: rem] == NSOrderedSame, "proxy compare: remote");
  pass([obj compare: sub] == NSOrderedSame, "proxy compare: subclass");
  pass([sub compare: rem] == NSOrderedSame, "subclass compare: remote");
  pass([sub compare: obj] == NSOrderedSame, "subclass compare: proxy");
  pass([rem compare: obj] == NSOrderedSame, "remote compare: proxy");
  pass([rem compare: sub] == NSOrderedSame, "remote compare: subclass");
  
  [arp release]; arp = nil;
  return 0;
}
