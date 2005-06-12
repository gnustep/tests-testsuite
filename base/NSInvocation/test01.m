#include "Testing.h"
#include "ObjectTesting.h"
#include "InvokeProxyProtocol.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSBundle.h>
#include <Foundation/NSException.h>
#include <Foundation/NSFileManager.h>
#include <Foundation/NSInvocation.h>
#include <Foundation/NSMethodSignature.h>
#include <Foundation/NSProxy.h>

int main()
{ 
  CREATE_AUTORELEASE_POOL(arp);
  NSInvocation *inv = nil; 
  NSObject <InvokeTarget>*tar;
  NSMethodSignature *sig;
  id ret;
  Class tClass = Nil;
  NSString *bundlePath;
  NSBundle *bundle; 
  int retc; 
  bundlePath = [[[NSFileManager defaultManager] 
                              currentDirectoryPath] 
			       stringByAppendingPathComponent:@"Resources"];
  bundlePath = [[NSBundle bundleWithPath:bundlePath]
                  pathForResource:@"InvokeProxy"
	                   ofType:@"bundle"];
  bundle = [NSBundle bundleWithPath:bundlePath];
  pass([bundle load],
       "loading resources from bundle");
  tClass = NSClassFromString(@"InvokeTarget");
   
  
  tar = [tClass new];
  
  /* 
    Test if the return value is retained. It is in the Apple OpenStep edition
    for Windows (YellowBox)
    matt: this doesn't seem like a valid test as pass/fail will vary on
    platforms
   */
  sig = [tar methodSignatureForSelector:@selector(retObject)];
  inv = [NSInvocation invocationWithMethodSignature: sig];
  retc = [[tar retObject] retainCount];
  [inv setSelector:@selector(retObject)];
  [inv invokeWithTarget:tar];
  pass(retc + 1 == [[tar retObject] retainCount],
       "Retain return value");
  
  sig = [tar methodSignatureForSelector:@selector(loopObject:)];
  inv = [NSInvocation invocationWithMethodSignature: sig];
  retc = [tar retainCount];
  [inv setSelector:@selector(loopObject:)];
  [inv invokeWithTarget:tar];
  [inv retainArguments];
  [inv setArgument:&tar atIndex:2];
  pass(retc + 1 == [tar retainCount],
       "Will Retain arguments after -retainArguments");
  
  sig = [tar methodSignatureForSelector:@selector(loopObject:)];
  inv = [NSInvocation invocationWithMethodSignature: sig];
  retc = [tar retainCount];
  [inv setSelector:@selector(loopObject:)];
  [inv invokeWithTarget:tar];
  [inv setArgument:&tar atIndex:2];
  pass(retc == [tar retainCount],
       "default will not retain arguments");
  
  sig = [tar methodSignatureForSelector:@selector(retObject)];
  inv = [NSInvocation invocationWithMethodSignature: sig];
  [inv setSelector:@selector(retObject)];
  [inv invokeWithTarget:nil];
  [inv getReturnValue:&ret];
  pass(ret == nil,"Check if nil target works");
  
  sig = [tar methodSignatureForSelector:@selector(returnIdButThrowException)];
  inv = [NSInvocation invocationWithMethodSignature: sig];
  [inv setSelector:@selector(returnIdButThrowException)];
  TEST_EXCEPTION([inv invokeWithTarget:tar];,@"AnException",YES,"Exception in invocation #1");
  TEST_EXCEPTION([inv getReturnValue:&ret];,NSGenericException,YES,"Exception getting return value #1");
 
  /* same as above but with a successful call first */
  sig = [tar methodSignatureForSelector:@selector(returnIdButThrowException)];
  inv = [NSInvocation invocationWithMethodSignature: sig];
  [inv setSelector:@selector(retObject)];
  
  [inv invokeWithTarget:tar]; /* these two lines */
  [inv getReturnValue:&ret];
  
  [inv setSelector:@selector(returnIdButThrowException)];
  TEST_EXCEPTION([inv invokeWithTarget:tar];,@"AnException",YES,"Exception in invocation #2");
  TEST_EXCEPTION([inv getReturnValue:&ret];,NSGenericException,YES,"Exception getting return value #2");
    
  
  DESTROY(arp);
  return 0;
}
