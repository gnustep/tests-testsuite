#import "Testing.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSString.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSData.h>
#import <Foundation/NSPropertyList.h>
#import <Foundation/NSProcessInfo.h>

static BOOL
test_parse_unparse(id object)
{
  return [[[object description] propertyList] isEqual: object];
}

static BOOL
test_parse_unparse_xml(id object)
{
  NSPropertyListFormat	format;
  NSData		*d;
  id			u;

  d = [NSPropertyListSerialization dataFromPropertyList: object
    format: NSPropertyListXMLFormat_v1_0 errorDescription: 0];
  u = [NSPropertyListSerialization propertyListFromData: d
    mutabilityOption: NSPropertyListImmutable
    format: &format
    errorDescription: 0];
  return [u isEqual: object];
}

static BOOL
test_parse_unparse_binary(id object)
{
  NSPropertyListFormat	format;
  NSData		*d;
  id			u;

  d = [NSPropertyListSerialization dataFromPropertyList: object
    format: NSPropertyListBinaryFormat_v1_0 errorDescription: 0];
  u = [NSPropertyListSerialization propertyListFromData: d
    mutabilityOption: NSPropertyListImmutable
    format: &format
    errorDescription: 0];
  return [u isEqual: object];
}

static BOOL
test_parse_unparse_binary_old(id object)
{
  NSPropertyListFormat	format;
  NSData		*d;
  id			u;

  d = [NSPropertyListSerialization dataFromPropertyList: object
    format: NSPropertyListGNUstepBinaryFormat errorDescription: 0];
  u = [NSPropertyListSerialization propertyListFromData: d
    mutabilityOption: NSPropertyListImmutable
    format: &format
    errorDescription: 0];
  return [u isEqual: object];
}

int main()
{
  BOOL	(*func)(id);
  int	i;
  CREATE_AUTORELEASE_POOL(arp);

  for (i = 0; i < 4; i++)
    {
      switch (i)
        {
	  case 0:
	    func = test_parse_unparse;
	    break;
	  case 1:
	    func = test_parse_unparse_xml;
	    break;
	  case 2:
	    func = test_parse_unparse_binary;
	    break;
	  case 3:
	    func = test_parse_unparse_binary_old;
	    break;
	}

      pass(func(@"ariosto"),
	   "We can generate a property list from a string");

      pass(func([NSArray array]),
	   "We can generate a property list from an empty array");

      pass(func([NSArray arrayWithObject: @"Palinuro"]),
	   "We can generate a property list from an array with a single object");

      pass(func([NSArray arrayWithObjects: 
					 @"Palinuro", @"Enea", nil]),
	   "We can generate a property list from an array with two objects");

      pass(func([NSArray arrayWithObjects: 
					 @"Palinuro", @"Enea", 
				       @"Eurialo e Niso", nil]),
       "We can generate a property list from "
       "an array with three objects and \"s");

      pass(func([NSDictionary dictionary]),
	   "We can generate a property list from an empty dictionary");

      pass(func([NSDictionary dictionaryWithObject: @"Virgilio"
					    forKey: @"Autore"]),
	"We can generate a property list from a "
	"dictionary with a single key/value pair");

      pass(func([NSDictionary dictionaryWithObjectsAndKeys: 
					      @"Virgilio", @"Autore",
					    @"Eneide", @"Titolo", nil]),
	"We can generate a property list from a "
	"dictionary with two key/value pairs");

      pass(func([NSDictionary dictionaryWithObjectsAndKeys: 
					      @"Virgilio", @"Autore",
					    [NSArray arrayWithObject: @"Molte"],
					    @"Opere", nil]),
	"We can generate a property list from a "
	"dictionary with an array inside");

      {
	id object  = [NSMutableDictionary dictionary];
	id objectA = [NSArray arrayWithObject: @"Ciao,"];
	id objectB = [NSArray arrayWithObject: objectA];
	id objectC = [NSDictionary dictionary];
	id objectD = [NSArray arrayWithObject:
	  [NSArray arrayWithObject:
	   [NSDictionary dictionaryWithObject:
	     [NSArray arrayWithObject: @"Ciao,"]
	     forKey: @"Ciao,"]]];
	[object setObject: objectA forKey: @"Utinam"];
	[object setObject: objectB forKey: @"bbb"];
	[object setObject: objectC forKey: @"ccc"];
	[object setObject: objectD forKey: @"Auri;"];
	pass(func(object),
	     "We can generate a medium-size property list (1)");
      }
      {
	id object;
	id objectA;
	id objectA_A;
	id objectA_B;
	id objectB;
	id objectB_A;
	id objectB_A_A;
	id objectB_A_B;
	id objectB_B;

	/* objectA */
	objectA_A = [NSMutableDictionary dictionary];
	[objectA_A setObject: @"1 2 3 4 5 6 7 8 9 0" forKey: @"numeri"];
	[objectA_A setObject: @"A B C D E F G H I J" forKey: @"lettere"];

	objectA_B = [NSMutableDictionary dictionary];
	[objectA_B setObject: @"3.1415296" forKey: @"PI greco"];
	[objectA_B setObject: @"0" forKey: @"zero"];
	[objectA_B setObject: @"1" forKey: @"uno"];

	objectA = [NSMutableDictionary dictionary];
	[objectA setObject: objectA_A forKey: @"Informazioni Utili"];
	[objectA setObject: objectA_B forKey: @"Costanti Numeriche"];

	/* objectB */
	objectB_A = [NSMutableDictionary dictionary];

	objectB_A_A = [NSMutableArray array];
	[objectB_A_A addObject: @"1"];
	[objectB_A_A addObject: @"2"];
	[objectB_A_A addObject: @"3"];
	[objectB_A_A addObject: @"4"];
	[objectB_A_A addObject: @"5"];
	[objectB_A_A addObject: @"6"];
	[objectB_A_A addObject: @"7"];
	[objectB_A_A addObject: @"8"];
	[objectB_A_A addObject: @"9"];
	[objectB_A_A addObject: @"0"];
	[objectB_A setObject: objectB_A_A forKey: @"numeri"];

	objectB_A_B = [NSMutableArray array];
	[objectB_A_B addObject: @"A"];
	[objectB_A_B addObject: @"B"];
	[objectB_A_B addObject: @"C"];
	[objectB_A_B addObject: @"D"];
	[objectB_A_B addObject: @"E"];
	[objectB_A_B addObject: @"F"];
	[objectB_A_B addObject: @"G"];
	[objectB_A_B addObject: @"H"];
	[objectB_A_B addObject: @"I"];
	[objectB_A_B addObject: @"J"];
	[objectB_A setObject: objectB_A_B forKey: @"letterine"];

	objectB_B = [NSMutableDictionary dictionary];
	[objectB_B setObject: @"3.1415296" forKey: @"PI greca"];
	[objectB_B setObject: @"0" forKey: @"el zero"];
	[objectB_B setObject: @"1" forKey: @"el uno"];

	objectB = [NSMutableDictionary dictionary];
	[objectB setObject: objectB_A forKey: @"Informazioni Utili"];
	[objectB setObject: objectB_B forKey: @"Costanti Numeriche"];

	/* object */
	object = [NSMutableDictionary dictionary];
	[object setObject: objectA forKey: @"Un dizionario"];
	[object setObject: objectB forKey: @"Un altro dizionario"];

	pass(func(object),
	     "We can generate a medium-size property list (2)");
      }

      pass(func([NSData data]),
	   "We can generate a property list from an empty data");

      pass(func([@"Questo e` un test" dataUsingEncoding: 1]),
	   "We can generate a property list from very simple data");

      pass(func([[[NSProcessInfo processInfo] 
				 globallyUniqueString] dataUsingEncoding: 7]),
	   "We can generate a property list from very simple data (2)");

      pass(func([NSMutableArray arrayWithObject:
				[@"*()3\"#@Q``''" dataUsingEncoding: 1]]),
	"We can generate a property list from an "
	"array containing very simple data");

      {
	id object = [NSMutableArray array];

	[object addObject: [@"*()3\"#@Q``''" dataUsingEncoding: 1]];
	[object addObject: @"nicola \" , ; <"];
	[object addObject: @"<nicola"];
	[object addObject: @"nicola;"];
	[object addObject: @"nicola,"];
	[object addObject: @"nicola>"];
	[object addObject: @"nicola@"];
	[object addObject: @"nicola "];
	[object addObject: @"nicola="];
	[object addObject: [NSArray arrayWithObject: @"="]];
	[object addObject: [NSDictionary dictionary]];

	pass(func(object),
	  "We can generate a property list from an array containing various things");
      }
    }

  IF_NO_GC(DESTROY(arp));
  return 0;
}

