/* InvokeProxy.h - Definitions for simple target and proxy classes 

   Written By: Adam Fedor <fedor@gnu.org>
*/
#include <Foundation/NSObject.h>

typedef struct {
  char	c;
  int	i;
} small;

typedef struct {
    int		i;
    char	*s;
    float	f;
} large;

@interface InvokeTarget: NSObject
- (char) loopChar: (char)v;
- (double) loopDouble: (double)v;
- (float) loopFloat: (float)v;
- (int) loopInt: (int)v;
- (large) loopLarge: (large)v;
- (long) loopLong: (long)v;
- (large) loopLargePtr: (large*)v;
- (id) loopObject: (id)v;
- (short) loopShort: (short)v;
- (small) loopSmall: (small)v;
- (small) loopSmallPtr: (small*)v;
- (char*) loopString: (char*)v;

- (char) retChar;
- (double) retDouble;
- (float) retFloat;
- (int) retInt;
- (large) retLarge;
- (long) retLong;
- (id) retObject;
- (short) retShort;
- (small) retSmall;
- (char*) retString;
@end

@interface InvokeProxy : NSObject
{
  id	obj;
}

- (id) initWithTarget: (id)target;

@end


