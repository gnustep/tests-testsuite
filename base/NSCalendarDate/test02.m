#import "Testing.h"
#import <Foundation/NSArray.h>
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSCalendarDate.h>
#import <Foundation/NSString.h>
#import <Foundation/NSTimeZone.h>
#import <Foundation/NSUserDefaults.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSMutableArray *tmpArray;
  NSMutableDictionary *myLocale;
  NSCalendarDate *myBirthday; 
  myLocale = [NSMutableDictionary new];
  
  tmpArray = [NSMutableArray new];
  [tmpArray addObject: @"Gen"]; 
  [tmpArray addObject: @"Feb"]; 
  [tmpArray addObject: @"Mar"]; 
  [tmpArray addObject: @"Apr"]; 
  [tmpArray addObject: @"Mag"]; 
  [tmpArray addObject: @"Giu"]; 
  [tmpArray addObject: @"Lug"]; 
  [tmpArray addObject: @"Ago"]; 
  [tmpArray addObject: @"Set"]; 
  [tmpArray addObject: @"Ott"]; 
  [tmpArray addObject: @"Nov"]; 
  [tmpArray addObject: @"Dic"]; 
  [myLocale setObject: tmpArray forKey:NSShortMonthNameArray];
  
  ASSIGN(tmpArray,[NSMutableArray new]);
  [tmpArray addObject: @"Gennaio"]; 
  [tmpArray addObject: @"Febbraio"]; 
  [tmpArray addObject: @"Marzo"]; 
  [tmpArray addObject: @"Aprile"]; 
  [tmpArray addObject: @"Maggio"]; 
  [tmpArray addObject: @"Giugno"]; 
  [tmpArray addObject: @"Luglio"]; 
  [tmpArray addObject: @"Agosto"]; 
  [tmpArray addObject: @"Settembre"]; 
  [tmpArray addObject: @"Ottobre"]; 
  [tmpArray addObject: @"Novembre"]; 
  [tmpArray addObject: @"Dicembre"]; 
  [myLocale setObject: tmpArray forKey:NSMonthNameArray];
  
  ASSIGN(tmpArray,[NSMutableArray new]);
  [tmpArray addObject:@"Dom"];
  [tmpArray addObject:@"Lun"];
  [tmpArray addObject:@"Mar"];
  [tmpArray addObject:@"Mer"];
  [tmpArray addObject:@"Gio"];
  [tmpArray addObject:@"Ven"];
  [tmpArray addObject:@"Sab"];
  [myLocale setObject: tmpArray forKey:NSShortWeekDayNameArray];
  
  ASSIGN(tmpArray,[NSMutableArray new]);
  [tmpArray addObject:@"Domencia"];
  [tmpArray addObject:@"Lunedi"];
  [tmpArray addObject:@"Martedi"];
  [tmpArray addObject:@"Mercoledi"];
  [tmpArray addObject:@"Giovedi"];
  [tmpArray addObject:@"Venerdi"];
  [tmpArray addObject:@"Sabato"];
  [myLocale setObject: tmpArray forKey:NSWeekDayNameArray];
  
  ASSIGN(tmpArray,[NSMutableArray new]);
  [tmpArray addObject:@"AM"];
  [tmpArray addObject:@"PM"];
  [myLocale setObject: tmpArray forKey:NSAMPMDesignation];
   
  myBirthday = [NSCalendarDate dateWithYear:1974 
  			 month:11
			   day:20
			  hour:13
			minute:0
			second:0
		      timeZone:[NSTimeZone timeZoneWithName:@"MET"]];
   
  pass([[myBirthday descriptionWithCalendarFormat:@"%%" 
                     locale:myLocale] isEqualToString:@"%"],
       "%% format works in description");
  
  pass([[myBirthday descriptionWithCalendarFormat:@"%a" 
                     locale:myLocale] isEqualToString:@"Mer"],
       "%%a format works in description");
  
  pass([[myBirthday descriptionWithCalendarFormat:@"%A" 
                     locale:myLocale] isEqualToString:@"Mercoledi"],
       "%%A format works in description");

  pass([[myBirthday descriptionWithCalendarFormat:@"%b" 
                     locale:myLocale] isEqualToString:@"Nov"],
       "%%b format works in description");
  
  pass([[myBirthday descriptionWithCalendarFormat:@"%B" 
                     locale:myLocale] isEqualToString:@"Novembre"],
       "%%B format works in description");
  
  pass([[myBirthday descriptionWithCalendarFormat:@"%d" 
                     locale:myLocale] isEqualToString:@"20"],
       "%%d format works in description");

  pass([[myBirthday descriptionWithCalendarFormat:@"%e" 
                     locale:myLocale] isEqualToString:@"20"],
       "%%e format works in description");
  
  pass([[myBirthday descriptionWithCalendarFormat:@"%F" 
                     locale:myLocale] isEqualToString:@"000"],
       "%%F format works in description");
  
  pass([[myBirthday descriptionWithCalendarFormat:@"%H" 
                     locale:myLocale] isEqualToString:@"13"],
       "%%H format works in description");

  pass([[myBirthday descriptionWithCalendarFormat:@"%I" 
                     locale:myLocale] isEqualToString:@"01"],
       "%%I format works in description");
  
  pass([[myBirthday descriptionWithCalendarFormat:@"%j" 
                     locale:myLocale] isEqualToString:@"324"],
       "%%j format works in description");
  
  pass([[myBirthday descriptionWithCalendarFormat:@"%m" 
                     locale:myLocale] isEqualToString:@"11"],
       "%%m format works in description");

  pass([[myBirthday descriptionWithCalendarFormat:@"%M" 
                     locale:myLocale] isEqualToString:@"00"],
       "%%M format works in description");
  
  pass([[myBirthday descriptionWithCalendarFormat:@"%p" 
                     locale:myLocale] isEqualToString:@"PM"],
       "%%p format works in description");
 
  pass([[myBirthday descriptionWithCalendarFormat:@"%S" 
                     locale:myLocale] isEqualToString:@"00"],
       "%%S format works in description");
  
  pass([[myBirthday descriptionWithCalendarFormat:@"%w" 
                     locale:myLocale] isEqualToString:@"3"],
       "%%w format works in description");
  
  pass([[myBirthday descriptionWithCalendarFormat:@"%y" 
                     locale:myLocale] isEqualToString:@"74"],
       "%%y format works in description");
  
  pass([[myBirthday descriptionWithCalendarFormat:@"%Y" 
                     locale:myLocale] isEqualToString:@"1974"],
       "%%Y format works in description");
  
  pass([[myBirthday descriptionWithCalendarFormat:@"%Z" 
                     locale:myLocale] isEqualToString:@"MET"],
       "%%Z format works in description");
  
  pass([[myBirthday descriptionWithCalendarFormat:@"%z" 
                     locale:myLocale] isEqualToString:@"+0100"],
       "%%z format works in description");
  
  pass([[myBirthday descriptionWithCalendarFormat:@"%d %m %Y" 
                     locale:myLocale] isEqualToString:@"20 11 1974"],
       "%%d %%m %%Y format works in description");
  
  pass([[myBirthday descriptionWithCalendarFormat:@"%d %B %y" 
                     locale:myLocale] isEqualToString:@"20 Novembre 74"],
       "%%d %%B %%Y format works in description");
  
  pass([[myBirthday descriptionWithCalendarFormat:@"%H:%M:%S" 
                     locale:myLocale] isEqualToString:@"13:00:00"],
       "%%H:%%M:%%S format works in description");
  
  pass([[myBirthday descriptionWithCalendarFormat:@"%H%%%M%%%S" 
                     locale:myLocale] isEqualToString:@"13%00%00"],
       "%%H%%%%%%M%%%%%%S format works in description");
  
  pass([[myBirthday descriptionWithCalendarFormat:@"%H:%M (%Z)" 
                     locale:myLocale] isEqualToString:@"13:00 (MET)"],
       "%%H%%M format works in description");
  
  pass([[myBirthday descriptionWithCalendarFormat:@"%R" 
                     locale:myLocale] isEqualToString:@"13:00"],
       "%R format works in description");
  
  pass([[myBirthday descriptionWithCalendarFormat:@"%r" 
                     locale:myLocale] isEqualToString:@"01:00:00 PM"],
       "%r format works in description");
  
  DESTROY(arp);
  return 0;
}
