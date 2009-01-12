#if	defined(GNUSTEP_BASE_LIBRARY)
/*
   Copyright (C) 2005 Free Software Foundation, Inc.

   Written by: David Ayers <d.ayers@inode.at>
   Date: November 2005
   
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

#define GST_PORT @"32329"

NSFileHandle *rFH = nil;

@interface Handler : NSObject
@end
@implementation Handler
- (id)init
{
  if ((self = [super init]))
    {
      NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
      [nc addObserver: self
	  selector: @selector(connect:)
	  name: NSFileHandleConnectionAcceptedNotification
	  object: nil];
    }
  return self;
}
- (void)connect:(NSNotification *)notif
{
  NSDictionary *d = [notif userInfo];
  rFH = [[d objectForKey: NSFileHandleNotificationFileHandleItem] retain];
}
@end

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSFileHandle *sFH, *cFH;
  NSData *wData = [@"Socket Test" dataUsingEncoding:NSASCIIStringEncoding];
  NSData *rData;
  /* Note that the above data should be short enough to fit into the
     socket send buffer otherwise we risk being blocked in this single
     threaded process.  */

  [[Handler new] autorelease];

  sFH = [NSFileHandle fileHandleAsServerAtAddress: @"127.0.0.1"
		       service: GST_PORT
		       protocol: @"tcp"];
  pass([sFH isKindOfClass:[NSFileHandle class]],
       "NSFileHandle understands +fileHandleAsServerAtAddress:");

  [sFH acceptConnectionInBackgroundAndNotify];

  
  cFH = [NSFileHandle fileHandleAsClientAtAddress: @"127.0.0.1"
		      service: GST_PORT
		      protocol: @"tcp"];
  pass([cFH isKindOfClass:[NSFileHandle class]],
       "NSFileHandle understands +fileHandleAsClientAtAddress:");

  [cFH writeData: wData];
  [[NSRunLoop currentRunLoop] run];
  pass(rFH != nil, "NSFileHandle connection was made");

  rData = [rFH availableData];
  pass([wData isEqual: rData],
       "NSFileHandle -writeData:/-availableData match with socket");

  IF_NO_GC(DESTROY(arp));
  return 0;
}
#else
int main()
{
  return 0;
}
#endif
