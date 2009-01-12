#import "Testing.h"
#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSString *key1, *key2, *key3, *val1, *val2, *val3;
  NSArray *keys1, *keys2, *keys3, *vals1, *vals2, *vals3;
  NSDictionary *obj,*old;
  old = nil;
  key1 = @"Key1";
  key2 = @"Key2";
  key3 = @"Key3";
  keys1 = [NSArray arrayWithObjects:key1, key2, nil];
  keys2 = [NSArray arrayWithObjects:key1, key2, key3, nil];
  /* duplicate keys */
  keys3 = [NSArray arrayWithObjects:key1, key2, key2, nil];
  val1 = @"Kidnapped";
  val2 = @"tied up";
  val3 = @"taken away and helf for ransom";
  vals1 = [NSArray arrayWithObjects:val1, val2, nil];
  /* duplicate values */
  vals2 = [NSArray arrayWithObjects:val1, val2, val2, nil];
  vals3 = [NSArray arrayWithObjects:val1, val2, val3, nil];
  obj = [NSDictionary new];
  pass(obj != nil && 
       [obj isKindOfClass:[NSDictionary class]] &&
       [obj count] == 0,
       "+new creates an empty dictionary");
  
  obj = [NSDictionary dictionary];
  pass(obj != nil && 
       [obj isKindOfClass:[NSDictionary class]] &&
       [obj count] == 0,
       "+dictionary creates an empty dictionary");
  
  TEST_EXCEPTION([NSDictionary dictionaryWithObject:val1 forKey:nil];,
                 NSInvalidArgumentException,YES,
		  "+dictionaryWithObject:forKey: with nil key");
  
  TEST_EXCEPTION([NSDictionary dictionaryWithObject:nil forKey:key1];,
                 NSInvalidArgumentException,YES,
		  "+dictionaryWithObject:forKey: with nil value");

  obj = [NSDictionary dictionaryWithObject:val1 forKey:key1];
  pass(obj != nil &&
       [obj isKindOfClass:[NSDictionary class]] &&
       [obj count] == 1, 
       "+dictionaryWithObject:forKey: builds minimal dictionary");
  
  obj = [NSDictionary dictionaryWithObjects:vals1 forKeys:keys1];
  pass(obj != nil &&
       [obj isKindOfClass:[NSDictionary class]] &&
       [obj count] == 2, 
       "+dictionaryWithObjects:forKeys: builds a dictionary");
  
  TEST_EXCEPTION([NSDictionary dictionaryWithObjects:vals1 forKeys:keys2];,
                 NSInvalidArgumentException, YES,
		 "+dictionaryWithObjects:forKeys: with arrays of different sizes");
  obj = [NSDictionary dictionaryWithObjects:vals2 forKeys:keys2];
  pass(obj != nil &&
       [obj isKindOfClass:[NSDictionary class]] &&
       [obj count] == 3, 
       "we can have multiple identical objects in a dictionary");
  
  obj = [NSDictionary dictionaryWithObjects:vals3 forKeys:keys3];
  pass(obj != nil &&
       [obj isKindOfClass:[NSDictionary class]] &&
       [obj count] == 2, 
       "we can't have multiple identical keys in a dictionary");
  old = obj;
  obj = [NSDictionary dictionaryWithDictionary:old];
  pass(obj != nil &&
       [obj isEqual: old], "+dictionaryWithDictionary: copies dictionary");
   
  IF_NO_GC(DESTROY(arp));
  return 0;
}
