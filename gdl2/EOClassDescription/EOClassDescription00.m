/*
   Copyright (C) 2004 Free SoftwareFoundation, Inc.

   Written by: David Ayers <d.ayers@inode.at>
   Date: October 2004

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
   Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSNotification.h>
#include <EOControl/EOControl.h>

#include "../GDL2Testing.h"


NSString *notifName = nil;

@interface MyClassDescription : EOClassDescription
{
  Class cdClass;
}
- (id)initWithClass:(Class)cls;
@end
@implementation MyClassDescription
- (id)initWithClass:(Class)cls
{
  if ((self = [super init]))
    {
      cdClass = cls;
    }
  return self;
}
@end

@interface MyEOClass : NSObject
{
  NSMutableDictionary *properties;
}
@end
@implementation MyEOClass
- (id)init
{
  if ((self = [super init]))
    {
      properties = [NSMutableDictionary new];
    }
  return self;
}
@end

@interface MyDelegate : NSObject
- (void)registerForNofifications;
- (void)notify: (NSNotification *)notif;
@end
@implementation MyDelegate
- (id)init
{
  if ((self = [super init]))
    {
      [self registerForNofifications];
    }
  return self;
}
- (void)registerForNofifications
{
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  [center addObserver: self
	  selector: @selector(notify:)
	  name: EOClassDescriptionNeededForClassNotification
	  object: nil];
  [center addObserver: self
	  selector: @selector(notify:)
	  name: EOClassDescriptionNeededForEntityNameNotification
	  object: nil];
}
- (void)notify: (NSNotification *)notif
{
  ASSIGN (notifName, [notif name]);
}
@end
int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  volatile BOOL result = NO;
  id tmp = nil;
  MyDelegate *del;

  EOClassDescription *clDesc;
  EOClassDescription *clDescDel;

  START_SET(YES);

  del = [MyDelegate new];

  START_TEST(YES);
  ASSIGN(notifName, nil);
  result = ([EOClassDescription classDescriptionForClass: [MyEOClass class]] 
	    == nil);
  result = result 
    && [notifName isEqual: EOClassDescriptionNeededForClassNotification];
  END_TEST(result, "+[EOClassDescription classDescriptionForClass:] #1");

  START_TEST(YES);
  ASSIGN(notifName, nil);
  result = ([EOClassDescription classDescriptionForEntityName: @"MyEOClass"] 
	    == nil);
  result = result 
    && [notifName isEqual: EOClassDescriptionNeededForEntityNameNotification];
  END_TEST(result, "+[EOClassDescription classDescriptionForEntityName:] #1");

  clDesc = [[MyClassDescription alloc] initWithClass: [MyEOClass class]];
  START_TEST(YES);
  [EOClassDescription registerClassDescription: clDesc
		      forClass: [MyEOClass class]];
  END_TEST(YES, "+[EOClassDescription registerClassDescription:forClass:]");

  START_TEST(YES);
  result = ([EOClassDescription classDescriptionForClass: [MyEOClass class]] 
	    == clDesc);
  END_TEST(result, "+[EOClassDescription classDescriptionForClass:] #2");

  START_TEST(YES);
  [EOClassDescription invalidateClassDescriptionCache];
  
  ASSIGN(notifName, nil);
  result = ([EOClassDescription classDescriptionForClass: [MyEOClass class]] 
	    == nil);
  result = result 
    && [notifName isEqual: EOClassDescriptionNeededForClassNotification];
  END_TEST(result, "+[EOClassDescription invalidateClassDescriptionCache]");
  

  END_SET("EOClassDescription/EOClassDescription00.m");

  [pool release];
  return (0);
}

