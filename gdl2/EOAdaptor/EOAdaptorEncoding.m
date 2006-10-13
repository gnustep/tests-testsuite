/*
   Copyright (C) 2006 Free Software Foundation, Inc.

   Written by: David Ayers <ayers@fsfe.org>
   
   This file is part of the GNUstep Database Library.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.
   
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA.
  
 */

#include <Foundation/Foundation.h>
#include <EOAccess/EOAccess.h>

#include "../GDL2Testing.h"

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  EOAdaptor *adaptor;
  NSDictionary *map,*connectionDictionary;
  NSEnumerator *tEnum;
  NSString *encodingName;
  NSStringEncoding expectedEncoding, databaseEncoding;

  volatile BOOL result = NO;

  /*  Now we have the testcases for the installed Adaptors.  */

  START_SET(YES);

  adaptor = [EOAdaptor adaptorWithName:[[EOAdaptor availableAdaptorNames] lastObject]];
  map = [@"{"
	  @"NSASCIIStringEncoding = 1;"
	  @"NSNEXTSTEPStringEncoding = 2;"
	  @"NSJapaneseEUCStringEncoding = 3;"
	  @"NSUTF8StringEncoding = 4;"
	  @"NSISOLatin1StringEncoding = 5;"
	  @"NSSymbolStringEncoding = 6;"
	  @"NSNonLossyASCIIStringEncoding = 7;"
	  @"NSShiftJISStringEncoding = 8;"
	  @"NSISOLatin2StringEncoding = 9;"
	  @"NSUnicodeStringEncoding = 10;"
	  @"NSWindowsCP1251StringEncoding = 11;"
	  @"NSWindowsCP1252StringEncoding = 12;"
	  @"NSWindowsCP1253StringEncoding = 13;"
	  @"NSWindowsCP1254StringEncoding = 14;"
	  @"NSWindowsCP1250StringEncoding = 15;"
	  @"NSISO2022JPStringEncoding = 21;"
	  @"NSMacOSRomanStringEncoding = 30;"
	  @"NSProprietaryStringEncoding = 31;"
	  @"NSKOI8RStringEncoding = 50;"
	  @"NSISOLatin3StringEncoding = 51;"
	  @"NSISOLatin4StringEncoding = 52;"
	  @"NSISOCyrillicStringEncoding = 22;"
	  @"NSISOArabicStringEncoding = 53;"
	  @"NSISOGreekStringEncoding = 54;"
	  @"NSISOHebrewStringEncoding = 55;"
	  @"NSISOLatin5StringEncoding = 57;"
	  @"NSISOLatin6StringEncoding = 58;"
	  @"NSISOThaiStringEncoding = 59;"
	  @"NSISOLatin7StringEncoding = 61;"
	  @"NSISOLatin8StringEncoding = 62;"
	  @"NSISOLatin9StringEncoding = 63;"
	  @"NSGB2312StringEncoding = 56;"
	  @"NSUTF7StringEncoding = 64;"
	  @"NSGSM0338StringEncoding = 65;"
	  @"NSBIG5StringEncoding = 66;"
	  @"NSKoreanEUCStringEncoding = 67;"
	  @"}" propertyList];
  tEnum = [map keyEnumerator];
      
  START_TEST(YES);
  result = YES;
  while ((encodingName = [tEnum nextObject]))
    {
      connectionDictionary 
	= [NSDictionary dictionaryWithObject: encodingName 
			forKey: @"databaseEncoding"];
      [adaptor setConnectionDictionary: connectionDictionary];
      expectedEncoding = [[map objectForKey: encodingName] intValue];
      databaseEncoding = [adaptor databaseEncoding];
      result = result && (expectedEncoding == databaseEncoding ? YES : NO);
    }
  END_TEST(result, [@"-[EOAdaptor databaseEncoding]" cString]);
	      

  END_SET("EOAdaptorEncoding");

  [pool release];
  return (0);
}

