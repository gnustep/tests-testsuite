/*
   Copyright (C) 2005 Free Software Foundation, Inc.

   Written by: David Ayers <d.ayers@inode.at>
   Date: February 2005
   
   This file is part of the GNUstep Base Library.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
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

#import "Testing.h"
#import "ObjectTesting.h"
#import <Foundation/Foundation.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  /* We invert the order so that we really test the FD values when they
     are not opened in order.  */
  NSFileHandle *stdErrFH = [NSFileHandle fileHandleWithStandardError];
  NSFileHandle *stdOutFH = [NSFileHandle fileHandleWithStandardOutput];
  NSFileHandle *stdInFH = [NSFileHandle fileHandleWithStandardInput];
  NSFileHandle *stdNullFH = [NSFileHandle fileHandleWithNullDevice];
  NSFileHandle *t1FH, *t2FH;
  NSString *tPath = [NSString stringWithFormat:@"%@/%@",NSTemporaryDirectory(),[[NSProcessInfo processInfo]globallyUniqueString]];
  NSData *t1Data = [tPath dataUsingEncoding:NSUTF8StringEncoding];
  NSData *t2Data;

  pass([stdInFH isKindOfClass:[NSFileHandle class]],
       "NSFileHandle understands +fileHandleWithStandardInput");
  pass([stdInFH fileDescriptor]==0,
       "NSFileHandle +fileHandleWithStandardInput has 0 as fileDescriptor");

  pass([stdOutFH isKindOfClass:[NSFileHandle class]],
       "NSFileHandle understands +fileHandleWithStandardOutput");
  pass([stdOutFH fileDescriptor]==1,
       "NSFileHandle +fileHandleWithStandardOutput has 1 as fileDescriptor");

  pass([stdErrFH isKindOfClass:[NSFileHandle class]],
       "NSFileHandle understands +fileHandleWithStandardError");
  pass([stdErrFH fileDescriptor]==2,
       "NSFileHandle +fileHandleWithStandardError has 2 as fileDescriptor");

  pass([stdNullFH isKindOfClass:[NSFileHandle class]],
       "NSFileHandle understands +fileHandleWithNullDevice");

  t1FH = [[NSFileHandle alloc] initWithFileDescriptor: 0];
  pass([t1FH isKindOfClass:[NSFileHandle class]],
       "NSFileHandle understands -initWithFileDescriptor:");

  t1FH = [NSFileHandle fileHandleForWritingAtPath: tPath];
  pass(t1FH == nil,
       "NSFileHandle +fileHandleForWritingAtPath: with non-existing file return nil");

  [@"" writeToFile: tPath atomically: YES];
  t1FH = [NSFileHandle fileHandleForWritingAtPath: tPath];
  pass([t1FH isKindOfClass:[NSFileHandle class]],
       "NSFileHandle understands +fileHandleForWritingAtPath:");

  t2FH = [NSFileHandle fileHandleForReadingAtPath: tPath];
  pass([t2FH isKindOfClass:[NSFileHandle class]],
       "NSFileHandle understands +fileHandleForReadingAtPath:");

  [t1FH writeData: t1Data];
  t2Data = [t2FH availableData];
  pass([t1Data isEqual: t2Data],
       "NSFileHandle -writeData:/-availableData match");

  [[NSFileManager defaultManager] removeFileAtPath: tPath handler: nil];
  
  DESTROY(arp);
  return 0;
}
