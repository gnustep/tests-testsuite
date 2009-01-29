#import "Testing.h"
#import <Foundation/NSArray.h>
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSString.h>

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  pass([[@"" pathComponents] count] == 0, "pathComponents ''");
  pass([[@"usr" pathComponents] count] == 1, "pathComponents 'usr'");
  pass([[@"usr/" pathComponents] count] == 2, "pathComponents 'usr/'");
  pass([[@"usr/bin" pathComponents] count] == 2, "pathComponents 'usr/bin'");
  pass([[@"usr//bin" pathComponents] count] == 2, "pathComponents 'usr//bin'");
  pass([[@"usr///bin" pathComponents] count] == 2, "pathComponents 'usr///bin'");
  pass([[@"/" pathComponents] count] == 1, "pathComponents '/'");
  pass([[@"/usr" pathComponents] count] == 2, "pathComponents '/usr'");
  pass([[@"/usr/" pathComponents] count] == 3, "pathComponents '/usr/'");
  pass([[@"/usr/bin" pathComponents] count] == 3, "pathComponents '/usr/bin'");
  pass([[@"/usr//bin" pathComponents] count] == 3, "pathComponents '/usr//bin'");
  pass([[@"/usr///bin" pathComponents] count] == 3, "pathComponents '/usr///bin'");
  pass([[@"" stringByAppendingPathComponent:@""] isEqual:@""],
       "'' stringByAppendingPathComponent: ''");
  pass([[@"" stringByAppendingPathComponent:@"usr"] isEqual:@"usr"],
       "'' stringByAppendingPathComponent: 'usr'");
  pass([[@"" stringByAppendingPathComponent:@"usr/"] isEqual:@"usr"],
       "'' stringByAppendingPathComponent: 'usr/'");
  pass([[@"" stringByAppendingPathComponent:@"/usr"] isEqual:@"/usr"],
       "'' stringByAppendingPathComponent: '/usr'");
  pass([[@"" stringByAppendingPathComponent:@"/usr/"] isEqual:@"/usr"],
       "'' stringByAppendingPathComponent: '/usr/'");
  pass([[@"/" stringByAppendingPathComponent:@""] isEqual:@"/"],
       "'/' stringByAppendingPathComponent: ''");
  pass([[@"/" stringByAppendingPathComponent:@"usr"] isEqual:@"/usr"],
       "'/' stringByAppendingPathComponent: 'usr'");
  pass([[@"/" stringByAppendingPathComponent:@"usr/"] isEqual:@"/usr"],
       "'/' stringByAppendingPathComponent: 'usr/'");
  pass([[@"/" stringByAppendingPathComponent:@"/usr"] isEqual:@"/usr"],
       "'/' stringByAppendingPathComponent: '/usr'");
  pass([[@"/" stringByAppendingPathComponent:@"/usr/"] isEqual:@"/usr"],
       "'/' stringByAppendingPathComponent: '/usr/'");
  pass([[@"usr" stringByAppendingPathComponent:@""] isEqual:@"usr"],
       "'usr' stringByAppendingPathComponent: ''");
  pass([[@"usr" stringByAppendingPathComponent:@"bin"] isEqual:@"usr/bin"],
       "'usr' stringByAppendingPathComponent: 'bin'");
  pass([[@"usr" stringByAppendingPathComponent:@"bin/"] isEqual:@"usr/bin"],
       "'usr' stringByAppendingPathComponent: 'bin/'");
  pass([[@"usr" stringByAppendingPathComponent:@"/bin"] isEqual:@"usr/bin"],
       "'usr' stringByAppendingPathComponent: '/bin'");
  pass([[@"usr" stringByAppendingPathComponent:@"/bin/"] isEqual:@"usr/bin"],
       "'usr' stringByAppendingPathComponent: '/bin/'");
  pass([[@"/usr" stringByAppendingPathComponent:@""] isEqual:@"/usr"],
       "'/usr' stringByAppendingPathComponent: ''");
  pass([[@"/usr" stringByAppendingPathComponent:@"bin"] isEqual:@"/usr/bin"],
       "'/usr' stringByAppendingPathComponent: 'bin'");
  pass([[@"/usr" stringByAppendingPathComponent:@"bin/"] isEqual:@"/usr/bin"],
       "'/usr' stringByAppendingPathComponent: 'bin/'");
  pass([[@"/usr" stringByAppendingPathComponent:@"/bin"] isEqual:@"/usr/bin"],
       "'/usr' stringByAppendingPathComponent: '/bin'");
  pass([[@"/usr" stringByAppendingPathComponent:@"/bin/"] isEqual:@"/usr/bin"],
       "'/usr' stringByAppendingPathComponent: '/bin/'");
  pass([[@"/usr/" stringByAppendingPathComponent:@""] isEqual:@"/usr"],
       "'/usr/' stringByAppendingPathComponent: ''");
  pass([[@"/usr/" stringByAppendingPathComponent:@"bin"] isEqual:@"/usr/bin"],
       "'/usr/' stringByAppendingPathComponent: 'bin'");
  pass([[@"/usr/" stringByAppendingPathComponent:@"bin/"] isEqual:@"/usr/bin"],
       "'/usr/' stringByAppendingPathComponent: 'bin/'");
  pass([[@"/usr/" stringByAppendingPathComponent:@"/bin/"] isEqual:@"/usr/bin"],
       "'/usr/' stringByAppendingPathComponent: '/bin/'");
  [arp release]; arp = nil;
  return 0;
}
