#include "Testing.h"
#include "ObjectTesting.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSData.h>
#include <Foundation/NSString.h>

int main()
{ 
  CREATE_AUTORELEASE_POOL(arp);
  char *str1,*str2,*tmp;
  NSData *data1, *data2;
  NSMutableData *mutable;
  unsigned char *hold;
   
  str1 = "Test string for data classes";
  str2 = (char *) malloc(sizeof("insert")); 
  strcpy(str2,"insert");
  
  mutable = [NSMutableData dataWithLength:100];
  hold = [mutable mutableBytes]; 
  
  /* hmpf is this correct */
  data1 = [NSData dataWithBytes:str1 length:(strlen(str1) * sizeof(void*))];
  pass(data1 != nil &&
       [data1 isKindOfClass:[NSData class]] &&
       [data1 length] == (strlen(str1) * sizeof(void*)) &&
       [data1 bytes] != str1 &&
       strcmp(str1,[data1 bytes]) == 0,
       "+dataWithBytes:length: works");
  
  mutable = [NSMutableData data];
  pass(mutable != nil && 
       [mutable isKindOfClass:[NSMutableData class]] &&
       [mutable length] == 0,
       "+data creates empty mutable data");
  
  [mutable setData:data1];
  pass(mutable != nil &&
       [mutable length] == (strlen(str1) * sizeof(void*)),
       "-setData: works");
  
  [mutable replaceBytesInRange:NSMakeRange(22,6) withBytes:str2];
  tmp = (char *)malloc([mutable length]);
  [mutable getBytes:tmp range:NSMakeRange(22,6)];
  tmp[6] = '\0';
  pass(mutable != nil &&
       strcmp(tmp,str2) == 0,
       "-replaceBytesInRange:withBytes suceeds");
  free(tmp);
  TEST_EXCEPTION([mutable replaceBytesInRange:NSMakeRange([mutable length]+1,6) 
                                    withBytes:str2];,
		 NSRangeException,YES,"-replaceBytesInRange:withBytes out of range raises exception");
                 
  
  DESTROY(arp);
  return 0;
}
