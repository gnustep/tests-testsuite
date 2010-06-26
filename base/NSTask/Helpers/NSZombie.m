#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSObject.h>

int
main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSObject *anObject = AUTORELEASE([NSObject new]);

  RELEASE(anObject);
  RELEASE(anObject);
  [pool release];
  return 0;
}
