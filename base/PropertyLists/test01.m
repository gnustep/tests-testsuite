#include "Testing.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSString.h>
#include <Foundation/NSArray.h>
#include <Foundation/NSDictionary.h>
#include <Foundation/NSData.h>
#include <Foundation/NSPropertyList.h>
#include <Foundation/NSProcessInfo.h>

static BOOL
test_parse_unparse(id object)
{
  return [[[object description] propertyList] isEqual: object];
}

int main()
{
  CREATE_AUTORELEASE_POOL(arp);

  pass(test_parse_unparse(@"ariosto"),
       "We can generate a property list from a string");

  pass(test_parse_unparse([NSArray array]),
       "We can generate a property list from an empty array");

  pass(test_parse_unparse([NSArray arrayWithObject: @"Palinuro"]),
       "We can generate a property list from an array with a single object");

  pass(test_parse_unparse([NSArray arrayWithObjects: 
				     @"Palinuro", @"Enea", nil]),
       "We can generate a property list from an array with two objects");

  pass(test_parse_unparse([NSArray arrayWithObjects: 
				     @"Palinuro", @"Enea", 
				   @"Eurialo e Niso", nil]),
       "We can generate a property list from an array with three objects and \"s");

  pass(test_parse_unparse([NSDictionary dictionary]),
       "We can generate a property list from an empty dictionary");

  pass(test_parse_unparse([NSDictionary dictionaryWithObject: @"Virgilio"
					forKey: @"Autore"]),
       "We can generate a property list from a dictionary with a single key/value pair");

  pass(test_parse_unparse([NSDictionary dictionaryWithObjectsAndKeys: 
					  @"Virgilio", @"Autore",
					@"Eneide", @"Titolo", nil]),
       "We can generate a property list from a dictionary with two key/value pairs");

  pass(test_parse_unparse([NSDictionary dictionaryWithObjectsAndKeys: 
					  @"Virgilio", @"Autore",
					[NSArray arrayWithObject: @"Molte"],
					@"Opere", nil]),
       "We can generate a property list from a dictionary with an array inside");

  {
    id object  = [NSMutableDictionary dictionary];
    id objectA = [NSArray arrayWithObject: @"Ciao,"];
    id objectB = [NSArray arrayWithObject: objectA];
    id objectC = [NSDictionary dictionary];
    id objectD = [NSArray arrayWithObject:
		  [NSArray arrayWithObject:
		   [NSDictionary dictionaryWithObject:
				   [NSArray arrayWithObject: @"Ciao,"]
				 forKey: [NSArray arrayWithObject: @"Ciao,"]]]];
    [object setObject: @"Utinam" forKey: objectA];
    [object setObject: objectC forKey: objectB];
    [object setObject: @"Auri;" forKey: objectD];
    pass(test_parse_unparse(object),
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

    pass(test_parse_unparse(object),
	 "We can generate a medium-size property list (2)");
  }

  pass(test_parse_unparse([NSData data]),
       "We can generate a property list from an empty data");

  pass(test_parse_unparse([@"Questo e` un test" dataUsingEncoding: 1]),
       "We can generate a property list from very simple data");

  pass(test_parse_unparse([[[NSProcessInfo processInfo] 
			     globallyUniqueString] dataUsingEncoding: 7]),
       "We can generate a property list from very simple data (2)");

  pass(test_parse_unparse([NSMutableArray arrayWithObject:
			    [@"*()3\"#@Q``''" dataUsingEncoding: 1]]),
       "We can generate a property list from an array containing very simple data");

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

    pass(test_parse_unparse(object),
	 "We can generate a property list from an array containing various things");
  }

  DESTROY(arp);
  return 0;
}

