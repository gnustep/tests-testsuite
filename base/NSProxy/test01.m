#define _GNU_SOURCE
#define _ISOC99_SOURCE
#import <Foundation/Foundation.h>

#import "Testing.h"

#include <limits.h>

typedef struct _GSFinePoint GSFinePoint;
struct _GSFinePoint
{
  double x;
  double y;
};
GSFinePoint
GSMakeFinePoint(double x, double y)
{
  GSFinePoint point;
  point.x = x;
  point.y = y;
  return point;
}
BOOL
GSEqualFinePoints(GSFinePoint aPoint, GSFinePoint bPoint)
{
  return ((aPoint.x == bPoint.x)
          && (aPoint.y == bPoint.y)) ? YES : NO;
}

typedef struct _GSBitField GSBitField;
struct _GSBitField
{
  unsigned int first:1;
  unsigned int unused:1;
  unsigned int second:1;
};
GSBitField
GSMakeBitField(BOOL first, BOOL second)
{
  GSBitField field;
  field.first = first;
  field.second = second;
  return field;
}
BOOL
GSEqualBitFields(GSBitField aField, GSBitField bField)
{
  return ((aField.first == bField.first)
          && (aField.second == bField.second)) ? YES : NO;
}


@interface TypeTester : NSObject
{
}
-(void)voidPvoid;
-(signed char)sCharPsChar:(signed char)v;
-(unsigned char)uCharPuChar:(unsigned char)v;
-(short)shortPshort:(short)v;
-(unsigned short)uShortPuShort:(unsigned short)v;
-(int)intPint:(int)v;
-(unsigned int)uIntPuInt:(unsigned int)v;
-(long)longPlong:(long)v;
-(unsigned long)uLongPuLong:(unsigned long)v;
-(long long)longlongPlonglong:(long long)v;
-(unsigned long long)ulonglongPulonglong:(unsigned long long)v;
-(float)floatPfloat:(float)v;
-(double)doublePdouble:(double)v;
-(long double)longdoublePlongdouble:(long double)v;
-(id)idPid:(id)v;

-(NSStringEncoding)enumPenum:(NSStringEncoding)v;
-(NSRange)rangePrange:(NSRange)v;
-(NSPoint)pointPpoint:(NSPoint)v;

-(GSFinePoint)finePointPfinePoint:(GSFinePoint)v;
-(GSBitField)bitFieldPbitField:(GSBitField)v;

@end

@implementation TypeTester
-(void)voidPvoid {}
-(signed char)sCharPsChar:(signed char)v { return v - 1; }
-(unsigned char)uCharPuChar:(unsigned char)v { return v - 1; }
-(short)shortPshort:(short)v { return v - 1; }
-(unsigned short)uShortPuShort:(unsigned short)v { return v - 1; }
-(int)intPint:(int)v { return v - 1; }
-(unsigned int)uIntPuInt:(unsigned int)v { return v - 1; }
-(long)longPlong:(long)v { return v - 1; }
-(unsigned long)uLongPuLong:(unsigned long)v { return v - 1; }
-(long long)longlongPlonglong:(long long)v { return v - 1; }
-(unsigned long long)ulonglongPulonglong:(unsigned long long)v { return v - 1; }
-(float)floatPfloat:(float)v { return v - 1.0; }
-(double)doublePdouble:(double)v { return v - 1.0; }
-(long double)longdoublePlongdouble:(long double)v { return v - 1.0; }
-(id)idPid:(id)v { return v == [NSProcessInfo processInfo] ? [NSNull null] : nil; }

-(NSStringEncoding)enumPenum:(NSStringEncoding)v { return v == NSSymbolStringEncoding ? NSNEXTSTEPStringEncoding : GSUndefinedEncoding; }
-(NSRange)rangePrange:(NSRange)v { return NSMakeRange(v.length,v.location); }
-(NSPoint)pointPpoint:(NSPoint)v { return NSMakePoint(v.y,v.x); }
-(GSFinePoint)finePointPfinePoint:(GSFinePoint)v { return GSMakeFinePoint(v.y,v.x); } 
-(GSBitField)bitFieldPbitField:(GSBitField)v { return GSMakeBitField(v.second,v.first); }

@end

@interface MyProxy : NSProxy
{
  id _remote;
}
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
  [super dealloc];
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

int
main(int argc, char *argv[])
{
  CREATE_AUTORELEASE_POOL(arp);
  id obj = nil;
  id rem = [TypeTester new];
  
  obj = [[MyProxy alloc] init];
  [obj setRemote:rem];

  [obj voidPvoid]; //shoudn't raise
  pass([obj sCharPsChar: 128] == 127, "Proxy signed char");
  pass([obj uCharPuChar: 255] == 254, "Proxy unsigned char");
  pass([obj shortPshort: SHRT_MAX] == (SHRT_MAX - 1), "Proxy signed short");
  pass([obj uShortPuShort: USHRT_MAX] == (USHRT_MAX - 1), "Proxy unsigned short");
  pass([obj intPint: INT_MAX] == (INT_MAX - 1), "Proxy singed int");
  pass([obj uIntPuInt: UINT_MAX] == (UINT_MAX - 1U), "Proxy unsigned int");
  pass([obj longPlong: LONG_MAX] == (LONG_MAX - 1L), "Proxy signed long");
  pass([obj uLongPuLong: ULONG_MAX] == (ULONG_MAX - 1UL), "Proxy unsigned long");
  pass([obj longlongPlonglong: LLONG_MAX] == (LLONG_MAX - 1LL), "Proxy signed long long");
  pass([obj ulonglongPulonglong: ULLONG_MAX] == (ULLONG_MAX - 1ULL), "Proxy unsigned long long");
  pass([obj floatPfloat: (float)3.14] == ((float)3.14 - (float)1.0), "Proxy float");
  pass([obj doublePdouble: (double)3.14] == ((double)3.14 - (double)1.0), "Proxy float");

  pass([obj idPid: [NSProcessInfo processInfo]] == [NSNull null], "Proxy id");
  pass([obj enumPenum: NSSymbolStringEncoding] == NSNEXTSTEPStringEncoding, "Proxy enum");
  pass(NSEqualRanges([obj rangePrange: NSMakeRange(243,432)],NSMakeRange(432,243)), "Proxy NSRange");
  pass(NSEqualPoints([obj pointPpoint: NSMakePoint(243.0F,432.0F)],NSMakePoint(432.0F,243.0F)), "Proxy NSPoint");
  pass(GSEqualFinePoints([obj finePointPfinePoint: GSMakeFinePoint(243.0L,432.0L)],GSMakeFinePoint(432.0L,243.0L)), "Proxy GSFinePoint");
  pass(GSEqualBitFields([obj bitFieldPbitField: GSMakeBitField(0,1)],GSMakeBitField(1,0)), "Proxy GSFinePoint");
  
  DESTROY(arp);
  return 0;
}
