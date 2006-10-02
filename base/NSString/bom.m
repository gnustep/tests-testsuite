/*
   Copyright (C) 2006 Free SoftwareFoundation, Inc.

   Written by: David Ayers <d.ayers@inode.at>
   Date: March 2006

   This file is part of the GNUstep Base Library.

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
   Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

/* **********************************************
  Testing of Various Byte Order Markers:
  
  UTF-8   :  EF BB BF
  UTF-16LE:  FF FE
  UTF-16BE:  FE FF
  UTF-32LE:  FF FE 00 00
  UTF-32BE:  00 00 FF FE
  
  Ref: Unicode 4.0
                   -SG
********************************************** */

#import "Testing.h"
#import <Foundation/Foundation.h>

int main(int argc, char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  NSString *file;
  NSString *contents;
  NSData *data;

  /* ----------------------------------------------------------------
   * TEST 1:
   * UTF-8, common on *nix
   * ------------------------------------------------------------- */
  file=@"utf8bom.txt";

  contents = [NSString stringWithContentsOfFile: file];
  pass([contents hasPrefix:@"This"], "stringWithContentsOfFile: UTF-8 BOM");

  data = [NSData dataWithContentsOfFile: file];
  contents = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease];
  pass([contents hasPrefix:@"This"], "initWithData:encoding: UTF-8 BOM");

  /* ----------------------------------------------------------------
   * TEST 2:
   * UTF-16LE, common on ms-windows
   * ------------------------------------------------------------- */
  file=@"utf16lebom.txt";

  contents = [NSString stringWithContentsOfFile: file];
  pass([contents hasPrefix:@"This"], "stringWithContentsOfFile: UTF-16LE BOM");

  data = [NSData dataWithContentsOfFile: file];
  contents = [[[NSString alloc] initWithData: data encoding: NSUnicodeStringEncoding] autorelease];
  pass([contents hasPrefix:@"This"], "initWithData:encoding: UTF-16LE BOM");

  /* ----------------------------------------------------------------
   * TEST 3:
   * UTF-16BE, canonical unicode on MacOS-X (PowerPC)
   * ------------------------------------------------------------- */
  file=@"utf16bebom.txt";

  contents = [NSString stringWithContentsOfFile: file];
  pass([contents hasPrefix:@"This"], "stringWithContentsOfFile: UTF-16LE BOM");

  data = [NSData dataWithContentsOfFile: file];
  contents = [[[NSString alloc] initWithData: data encoding: NSUnicodeStringEncoding] autorelease];
  pass([contents hasPrefix:@"This"], "initWithData:encoding: UTF-16LE BOM");

  /* ----------------------------------------------------------------
   * TEST 4:
   * UTF-32LE
   * ------------------------------------------------------------- */
  file=@"utf32lebom.txt";

  contents = [NSString stringWithContentsOfFile: file];
  pass([contents hasPrefix:@"This"], "stringWithContentsOfFile: UTF-32LE BOM");

  data = [NSData dataWithContentsOfFile: file];
  contents = [[[NSString alloc] initWithData: data encoding: NSUnicodeStringEncoding] autorelease];
  pass([contents hasPrefix:@"This"], "initWithData:encoding: UTF-32LE BOM");

  /* ----------------------------------------------------------------
   * TEST 5:
   * UTF-32BE
   * ------------------------------------------------------------- */
  file=@"utf32bebom.txt";

  contents = [NSString stringWithContentsOfFile: file];
  pass([contents hasPrefix:@"This"], "stringWithContentsOfFile: UTF-32BE BOM");

  data = [NSData dataWithContentsOfFile: file];
  contents = [[[NSString alloc] initWithData: data encoding: NSUnicodeStringEncoding] autorelease];
  pass([contents hasPrefix:@"This"], "initWithData:encoding: UTF-32BE BOM");

  [pool release];
  return 0;
}

