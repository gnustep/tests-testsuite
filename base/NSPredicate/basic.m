#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSKeyValueCoding.h>
#import <Foundation/NSPredicate.h>
#import <Foundation/NSString.h>
#import <Foundation/NSValue.h>

void
testKVC(NSDictionary *dict)
{
	pass([@"A Title" isEqual: [dict valueForKey: @"title"]], "valueForKeyPath: with string");
	pass([@"A Title" isEqual: [dict valueForKeyPath: @"title"]], "valueForKeyPath: with string");
  pass([@"John" isEqual: [dict valueForKeyPath: @"Record1.Name"]], "valueForKeyPath: with string");
	pass(30 == [[dict valueForKeyPath: @"Record2.Age"] intValue], "valueForKeyPath: with int");
}

void
testString(NSDictionary *dict)
{
  NSPredicate *p;

	p = [NSPredicate predicateWithFormat: @"%K == %@", @"Record1.Name", @"John"];
	pass([p evaluateWithObject: dict], "%%K == %%@");
	p = [NSPredicate predicateWithFormat: @"%K MATCHES[c] %@", @"Record1.Name", @"john"];
	pass([p evaluateWithObject: dict], "%%K MATCHES[c] %%@");
	p = [NSPredicate predicateWithFormat: @"%K BEGINSWITH %@", @"Record1.Name", @"Jo"];
	pass([p evaluateWithObject: dict], "%%K BEGINSWITH %%@");
	p = [NSPredicate predicateWithFormat: @"(%K == %@) AND (%K == %@)", @"Record1.Name", @"John", @"Record2.Name", @"Mary"];
	pass([p evaluateWithObject: dict], "(%%K == %%@) AND (%%K == %%@)");
}

void
testInteger(NSDictionary *dict)
{
  NSPredicate *p;

	p = [NSPredicate predicateWithFormat: @"%K == %d", @"Record1.Age", 34];
	pass([p evaluateWithObject: dict], "%%K == %%d");
	p = [NSPredicate predicateWithFormat: @"%K < %d", @"Record1.Age", 40];
	pass([p evaluateWithObject: dict], "%%K < %%d");
	p = [NSPredicate predicateWithFormat: @"%K BETWEEN %@", @"Record1.Age", [NSArray arrayWithObjects: [NSNumber numberWithInt: 20], [NSNumber numberWithInt: 40], nil]];
	pass([p evaluateWithObject: dict], "%%K BETWEEN %%@");
	p = [NSPredicate predicateWithFormat: @"(%K == %d) OR (%K == %d)", @"Record1.Age", 34, @"Record2.Age", 34];
	pass([p evaluateWithObject: dict], "(%%K == %%d) OR (%%K == %%d)");
}

void
testFloat(NSDictionary *dict)
{
  NSPredicate *p;

	p = [NSPredicate predicateWithFormat: @"%K < %f", @"Record1.Age", 40.5];
	pass([p evaluateWithObject: dict], "%%K < %%f");
  p = [NSPredicate predicateWithFormat: @"%f > %K", 40.5, @"Record1.Age"];
	pass([p evaluateWithObject: dict], "%%f > %%K");
}

void
testAttregate(NSDictionary *dict)
{
  NSPredicate *p;

	p = [NSPredicate predicateWithFormat: @"%@ IN %K", @"Kid1", @"Record1.Children"];
	pass([p evaluateWithObject: dict], "%%@ IN %%K");
	p = [NSPredicate predicateWithFormat: @"Any %K == %@", @"Record2.Children", @"Girl1"];
	pass([p evaluateWithObject: dict], "Any %%K == %%@");
}

int main()
{
	NSMutableDictionary *dict;
	NSDictionary *d;
  CREATE_AUTORELEASE_POOL(arp);

  dict = [[NSMutableDictionary alloc] init];
	[dict setObject: @"A Title" forKey: @"title"];

  d = [NSDictionary dictionaryWithObjectsAndKeys:
			@"John", @"Name",
			[NSNumber numberWithInt: 34], @"Age",
			[NSArray arrayWithObjects: @"Kid1", @"Kid2", nil], @"Children",
			nil];
	[dict setObject: d forKey: @"Record1"];

	d = [NSDictionary dictionaryWithObjectsAndKeys:
			@"Mary", @"Name",
			[NSNumber numberWithInt: 30], @"Age",
			[NSArray arrayWithObjects: @"Kid1", @"Girl1", nil], @"Children",
			nil];
	[dict setObject: d forKey: @"Record2"];

  testKVC(dict);
  testString(dict);
  testInteger(dict);
  testFloat(dict);
  testAttregate(dict);

  RELEASE(dict);
  DESTROY(arp);
  return 0;
}
