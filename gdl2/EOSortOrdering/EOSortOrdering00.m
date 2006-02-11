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
#include <EOControl/EOControl.h>

#include "../GDL2Testing.h"

int main(int argc,char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  volatile BOOL result = NO;
  id tmp = nil;

  EOSortOrdering *sOrd1 = nil;
  EOSortOrdering *sOrd2 = nil;
  EOSortOrdering *sOrd3 = nil;
  EOSortOrdering *sOrd4 = nil;

  START_SET(YES);

  START_TEST(YES);
  sOrd1 = [[EOSortOrdering alloc] initWithKey: @"name"
				  selector: EOCompareCaseInsensitiveAscending];

  sOrd2 
    = [[EOSortOrdering alloc] initWithKey: @"details"
			      selector: EOCompareCaseInsensitiveDescending];

  sOrd3 = [[EOSortOrdering alloc] initWithKey: @"number"
				  selector: EOCompareAscending];

  sOrd4 = [[EOSortOrdering alloc] initWithKey: @"date"
				  selector: EOCompareDescending];

  result = [[sOrd1 key] isEqual: @"name"];
  result = result && sel_eq([sOrd1 selector],
			    EOCompareCaseInsensitiveAscending);

  result = result && [[sOrd2 key] isEqual: @"details"];
  result = result && sel_eq([sOrd2 selector],
			    EOCompareCaseInsensitiveDescending);

  result = result && [[sOrd3 key] isEqual: @"number"];
  result = result && sel_eq([sOrd3 selector],
			    EOCompareAscending);

  result = result && [[sOrd4 key] isEqual: @"date"];
  result = result && sel_eq([sOrd4 selector],
			    EOCompareDescending);

  END_TEST(result, "-[EOSortOrdering initWithKey:selector:]");

  START_TEST(YES);
  {
    NSDictionary *obj1 = [NSDictionary dictionaryWithObject: @"MySQL"
				       forKey: @"name"];
    NSDictionary *obj2 = [NSDictionary dictionaryWithObject: [EONull null]
				       forKey: @"name"];
    NSDictionary *obj3 = [NSDictionary dictionaryWithObject: @"postgresSQL"
				       forKey: @"name"];
    NSDictionary *obj4 = [NSDictionary dictionaryWithObject: @"SQLite"
				       forKey: @"name"];
    NSDictionary *obj5 = [NSDictionary dictionaryWithObject: @"Postgres95"
				       forKey: @"name"];

    NSArray *arr = [NSArray arrayWithObjects: 
			      obj1, obj2, obj3, obj4, obj5, nil];
    NSArray *sOrdAsc, *sOrdDesc, *sOrdAscCI, *sOrdDescCI;
    NSArray *arrAsc, *arrDesc, *arrAscCI, *arrDescCI;

    tmp = [[EOSortOrdering alloc] initWithKey: @"name"
				  selector: EOCompareAscending];
    sOrdAsc = [NSArray arrayWithObject: tmp];

    tmp = [[EOSortOrdering alloc] initWithKey: @"name"
				  selector: EOCompareDescending];
    sOrdDesc = [NSArray arrayWithObject: tmp];

    tmp = [[EOSortOrdering alloc] initWithKey: @"name"
				  selector: EOCompareCaseInsensitiveAscending];
    sOrdAscCI = [NSArray arrayWithObject: tmp];

    tmp 
      = [[EOSortOrdering alloc] initWithKey: @"name"
				selector: EOCompareCaseInsensitiveDescending];
    sOrdDescCI = [NSArray arrayWithObject: tmp];

    arrAsc = [arr sortedArrayUsingKeyOrderArray: sOrdAsc];
    arrDesc = [arr sortedArrayUsingKeyOrderArray: sOrdDesc];
    arrAscCI = [arr sortedArrayUsingKeyOrderArray: sOrdAscCI];
    arrDescCI = [arr sortedArrayUsingKeyOrderArray: sOrdDescCI];

    result = [[arrAsc objectAtIndex: 0] isEqual: obj2];
    result = result && [[arrAsc objectAtIndex: 1] isEqual: obj1];
    result = result && [[arrAsc objectAtIndex: 2] isEqual: obj5];
    result = result && [[arrAsc objectAtIndex: 3] isEqual: obj4];
    result = result && [[arrAsc objectAtIndex: 4] isEqual: obj3];

    result = result && [[arrDesc objectAtIndex: 0] isEqual: obj3];
    result = result && [[arrDesc objectAtIndex: 1] isEqual: obj4];
    result = result && [[arrDesc objectAtIndex: 2] isEqual: obj5];
    result = result && [[arrDesc objectAtIndex: 3] isEqual: obj1];
    result = result && [[arrDesc objectAtIndex: 4] isEqual: obj2];

    result = result && [[arrAscCI objectAtIndex: 0] isEqual: obj2];
    result = result && [[arrAscCI objectAtIndex: 1] isEqual: obj1];
    result = result && [[arrAscCI objectAtIndex: 2] isEqual: obj5];
    result = result && [[arrAscCI objectAtIndex: 3] isEqual: obj3];
    result = result && [[arrAscCI objectAtIndex: 4] isEqual: obj4];

    result = result && [[arrDescCI objectAtIndex: 0] isEqual: obj4];
    result = result && [[arrDescCI objectAtIndex: 1] isEqual: obj3];
    result = result && [[arrDescCI objectAtIndex: 2] isEqual: obj5];
    result = result && [[arrDescCI objectAtIndex: 3] isEqual: obj1];
    result = result && [[arrDescCI objectAtIndex: 4] isEqual: obj2];
  }
  END_TEST(result,
	   "-[NSArray (EOKeyBasedSorting) sortedArrayUsingKeyOrderArray:]"
	   " EONull");

  START_TEST(YES);
  {
    NSDate *today = [NSDate date];
    NSDictionary *obj1 = [NSDictionary dictionaryWithObjectsAndKeys:
					 @"MySQL", @"name",
				       [EONull null], @"details",
				       [NSNumber numberWithInt: 2], @"number",
				       today, @"date", nil];
    NSDictionary *obj2 = [NSDictionary dictionaryWithObjectsAndKeys:
					 @"Postrgres95", @"name",
				       @"Adaptor exsits", @"details",
				       [NSNumber numberWithInt: 1], @"number",
				       [EONull null], @"date", nil];
    NSDictionary *obj3 = [NSDictionary dictionaryWithObjectsAndKeys:
					 @"SQLite", @"name",
				       @"No Adaptor implmentation", @"details",
				       [EONull null], @"number",
				       today, @"date", nil];
    NSDictionary *obj4 = [NSDictionary dictionaryWithObjectsAndKeys:
					 @"PostgresSQL", @"name",
				       @"adaptor should fork", @"details",
				       [NSNumber numberWithInt: 4], @"number",
				       today, @"date", nil];

    NSMutableArray *arr0;
    NSArray *arr1, *arr2, *arr3, *arr4;
    NSArray *sOarr1, *sOarr2, *sOarr3, *sOarr4;

    arr0 = (id)[NSMutableArray arrayWithObjects: obj1, obj2, obj3, obj4, nil];

    /* (name ascCI) (details descCI) (number asc) (date desc)*/
    sOarr1 = [NSArray arrayWithObjects: sOrd1, sOrd2, sOrd3, sOrd4, nil];

    /* (date desc) (number asc) (details descCI) (name ascCI)*/
    sOarr2 = [NSArray arrayWithObjects: sOrd4, sOrd3, sOrd2, sOrd1, nil];

    /* (details descCI) (date desc) (name ascCI) (number asc)*/
    sOarr3 = [NSArray arrayWithObjects: sOrd2, sOrd4, sOrd1, sOrd3, nil];

    /* (date desc) (details descCI) (number asc) (name ascCI)*/
    sOarr4 = [NSArray arrayWithObjects: sOrd4, sOrd2, sOrd3, sOrd1, nil];

    [arr0 sortUsingKeyOrderArray: sOarr1];
    arr1 = [arr0 copy];

    [arr0 sortUsingKeyOrderArray: sOarr2];
    arr2 = [arr0 copy];

    [arr0 sortUsingKeyOrderArray: sOarr3];
    arr3 = [arr0 copy];

    [arr0 sortUsingKeyOrderArray: sOarr4];
    arr4 = [arr0 copy];

    result = [[arr1 objectAtIndex: 0] isEqual: obj1];
    result = result && [[arr1 objectAtIndex: 1] isEqual: obj4];
    result = result && [[arr1 objectAtIndex: 2] isEqual: obj2];
    result = result && [[arr1 objectAtIndex: 3] isEqual: obj3];

    result = result && [[arr2 objectAtIndex: 0] isEqual: obj3];
    result = result && [[arr2 objectAtIndex: 1] isEqual: obj1];
    result = result && [[arr2 objectAtIndex: 2] isEqual: obj4];
    result = result && [[arr2 objectAtIndex: 3] isEqual: obj2];

    result = result && [[arr3 objectAtIndex: 0] isEqual: obj3];
    result = result && [[arr3 objectAtIndex: 1] isEqual: obj4];
    result = result && [[arr3 objectAtIndex: 2] isEqual: obj2];
    result = result && [[arr3 objectAtIndex: 3] isEqual: obj1];

    result = result && [[arr4 objectAtIndex: 0] isEqual: obj3];
    result = result && [[arr4 objectAtIndex: 1] isEqual: obj4];
    result = result && [[arr4 objectAtIndex: 2] isEqual: obj1];
    result = result && [[arr4 objectAtIndex: 3] isEqual: obj2];

  }
  END_TEST(result,
	   "-[NSMutableArray (EOKeyBasedSorting) sortUsingKeyOrderArray:]");

  START_TEST(YES);
  END_TEST(result, "");

  END_SET("EOSortOrdering/EOSortOrdering00.m");

  [pool release];
  return (0);
}
#if 0

(greg-testcase "-[NSMutableArray (EOKeyBasedSorting) sortUsingKeyOrderArray:]" #t
(lambda ()
  (define obj1 ([] "NSMutableDictionary" dictionaryWithCapacity: 4))
  (define obj2 ([] "NSMutableDictionary" dictionaryWithCapacity: 4))
  (define obj3 ([] "NSMutableDictionary" dictionaryWithCapacity: 4))
  (define obj4 ([] "NSMutableDictionary" dictionaryWithCapacity: 4))

  (define arr0 ([] "NSMutableArray" arrayWithCapacity: 4))

  (define arr1   gstep-nil)
  (define arr2   gstep-nil)
  (define arr3   gstep-nil)
  (define arr4   gstep-nil)

  (define sOarr1 ([] "NSMutableArray" arrayWithCapacity: 4))
  (define sOarr2 ([] "NSMutableArray" arrayWithCapacity: 4))
  (define sOarr3 ([] "NSMutableArray" arrayWithCapacity: 4))
  (define sOarr4 ([] "NSMutableArray" arrayWithCapacity: 4))
  
  (define today  ([] "NSDate" date))
  
  ([] obj1 setObject:($$ "MySQL")                     forKey:($$ "name"))
  ([] obj1 setObject:([] "EONull" null)               forKey:($$ "details"))
  ([] obj1 setObject:([] "NSNumber" numberWithInt: 2) forKey:($$ "number"))
  ([] obj1 setObject: today                           forKey:($$ "date"))

  ([] obj2 setObject:($$ "Postrgres95")               forKey:($$ "name"))
  ([] obj2 setObject:($$ "Adaptor exsits")            forKey:($$ "details"))
  ([] obj2 setObject:([] "NSNumber" numberWithInt: 3) forKey:($$ "number"))
  ([] obj2 setObject:([] "EONull" null)               forKey:($$ "date"))

  ([] obj3 setObject:($$ "SQLite")                    forKey:($$ "name"))
  ([] obj3 setObject:($$ "No Adaptor implmentation")  forKey:($$ "details"))
  ([] obj3 setObject:([] "EONull" null)               forKey:($$ "number"))
  ([] obj3 setObject: today                           forKey:($$ "date"))

  ([] obj4 setObject:($$ "PostgresSQL")               forKey:($$ "name"))
  ([] obj4 setObject:($$ "adaptor should fork")       forKey:($$ "details"))
  ([] obj4 setObject:([] "NSNumber" numberWithInt: 4) forKey:($$ "number"))
  ([] obj4 setObject: today                           forKey:($$ "date"))

  ([] arr0 addObject: obj1)
  ([] arr0 addObject: obj2)
  ([] arr0 addObject: obj3)
  ([] arr0 addObject: obj4)

  ([] sOarr1 addObject: sOrd1) ; name    asc  CI
  ([] sOarr1 addObject: sOrd2) ; details desc CI
  ([] sOarr1 addObject: sOrd3) ; number  asc
  ([] sOarr1 addObject: sOrd4) ; date    desc

  ([] sOarr2 addObject: sOrd4) ; date    desc
  ([] sOarr2 addObject: sOrd3) ; number  asc
  ([] sOarr2 addObject: sOrd2) ; details desc CI
  ([] sOarr2 addObject: sOrd1) ; name    asc  CI

  ([] sOarr3 addObject: sOrd2) ; details desc CI
  ([] sOarr3 addObject: sOrd4) ; date    desc
  ([] sOarr3 addObject: sOrd1) ; name    asc  CI
  ([] sOarr3 addObject: sOrd3) ; number  asc

  ([] sOarr4 addObject: sOrd4) ; date    desc
  ([] sOarr4 addObject: sOrd2) ; details desc CI
  ([] sOarr4 addObject: sOrd3) ; number  asc
  ([] sOarr4 addObject: sOrd1) ; name    asc  CI

  ([] arr0 sortUsingKeyOrderArray: sOarr1)
  (set! arr1 ([] arr0 copy))

  ([] arr0 sortUsingKeyOrderArray: sOarr2)
  (set! arr2 ([] arr0 copy))

  ([] arr0 sortUsingKeyOrderArray: sOarr3)
  (set! arr3 ([] arr0 copy))

  ([] arr0 sortUsingKeyOrderArray: sOarr4)
  (set! arr4 ([] arr0 copy))

;  (greg-dlog sOarr1 "\n" arr1 "\n\n")
;  (greg-dlog sOarr2 "\n" arr2 "\n\n")
;  (greg-dlog sOarr3 "\n" arr3 "\n\n")
;  (greg-dlog sOarr4 "\n" arr4 "\n\n")

  (and
   (gstep-bool ([]([] arr1 objectAtIndex: 0) isEqual: obj1))
   (gstep-bool ([]([] arr1 objectAtIndex: 1) isEqual: obj4))
   (gstep-bool ([]([] arr1 objectAtIndex: 2) isEqual: obj2))
   (gstep-bool ([]([] arr1 objectAtIndex: 3) isEqual: obj3))

   (gstep-bool ([]([] arr2 objectAtIndex: 0) isEqual: obj3))
   (gstep-bool ([]([] arr2 objectAtIndex: 1) isEqual: obj1))
   (gstep-bool ([]([] arr2 objectAtIndex: 2) isEqual: obj4))
   (gstep-bool ([]([] arr2 objectAtIndex: 3) isEqual: obj2))

   (gstep-bool ([]([] arr3 objectAtIndex: 0) isEqual: obj3))
   (gstep-bool ([]([] arr3 objectAtIndex: 1) isEqual: obj4))
   (gstep-bool ([]([] arr3 objectAtIndex: 2) isEqual: obj2))
   (gstep-bool ([]([] arr3 objectAtIndex: 3) isEqual: obj1))

   (gstep-bool ([]([] arr4 objectAtIndex: 0) isEqual: obj3))
   (gstep-bool ([]([] arr4 objectAtIndex: 1) isEqual: obj4))
   (gstep-bool ([]([] arr4 objectAtIndex: 2) isEqual: obj1))
   (gstep-bool ([]([] arr4 objectAtIndex: 3) isEqual: obj2))
  )
))

)

#endif


