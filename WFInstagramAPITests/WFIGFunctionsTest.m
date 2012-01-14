//
//  WFIGFunctionsTest.m
//
//  Created by William Fleming on 1/14/12.
//

#import "WFIGFunctionsTest.h"
#import "WFIGFunctions.h"

@implementation WFIGFunctionsTest

- (void) testDateParsing {
  // test that a simple 'now' matches how it should
  NSDate *now = [NSDate date];
  // we floor the time intervals because of rounding errors
  NSTimeInterval nowUnix = floor([now timeIntervalSince1970]);
  NSString *strVal = [NSString stringWithFormat:@"%f", nowUnix];
  NSDate *parsedNow = WFIGDateFromJSONString(strVal);
  NSTimeInterval parsedUnix = floor([parsedNow timeIntervalSince1970]);
  STAssertTrue(parsedUnix == nowUnix, @"parsed now did not equal initial now");
  
  //test a known date value 
  NSDate *parsed = WFIGDateFromJSONString(@"479628000");
  NSCalendar *cal = [NSCalendar currentCalendar];
  NSUInteger calFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|
    NSHourCalendarUnit|NSMinuteCalendarUnit;
  NSDateComponents *components = [cal components:calFlags fromDate:parsed];
  STAssertTrue(3 == [components month], @"parsed date did not have expected month");
  STAssertTrue(14 == [components day], @"parsed date did not have expected day");
  STAssertTrue(1985 == [components year], @"parsed date did not have expected year");
  STAssertTrue(1 == [components hour], @"parsed date did not have expected hour");
  STAssertTrue(0 == [components minute], @"parsed date did not have expected minute");
}

- (void) testURLEncoding {
  NSString *orig = @"http://host.dev/path?foo=bar";
  NSString *expected = @"http%3A%2F%2Fhost.dev%2Fpath%3Ffoo%3Dbar";
  
  STAssertTrue([expected isEqual:WFIGURLEncodedString(orig)], @"encoded did not match expected");
}

@end
