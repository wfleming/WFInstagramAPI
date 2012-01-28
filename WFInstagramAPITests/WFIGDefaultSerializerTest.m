//
//  WFIGDefaultSerializerTest.m
//
//  Created by William Fleming on 1/14/12.
//

#import "WFIGDefaultSerializerTest.h"

#import "WFIGDefaultSerializer.h"

@implementation WFIGDefaultSerializerTest

- (NSString*) testJSONString {
  return @"{"
          "  \"strVal\": \"foo\","
          "  \"numVal\": 123,"
          "  \"boolVal\": true,"
          "  \"emptyArray\": [],"
          "  \"emptyObject\": {},"
          "  \"subArray\": [1, 2, \"foo\"],"
          "  \"subObject\": {"
          "    \"foo\": \"bar\","
          "    \"baz\": 123"
          "  }"
          "}";
}

- (NSData*) testJSONData {
  return [[self testJSONString] dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSDictionary*) testJSONObject {
  return [NSDictionary dictionaryWithObjectsAndKeys:
          @"foo", @"strVal",
          [NSNumber numberWithInt:123], @"numVal",
          [NSNumber numberWithBool:YES], @"boolVal",
          [NSArray array], @"emptyArray",
          [NSDictionary dictionary], @"emptyObject",
          [NSArray arrayWithObjects:
           [NSNumber numberWithInt:1],
           [NSNumber numberWithInt:2],
           @"foo", nil], @"subArray",
          [NSDictionary dictionaryWithObjectsAndKeys:
           @"bar", @"foo",
           [NSNumber numberWithInt:123], @"baz",
           nil], @"subObject",
          nil];
}

- (void) testDeserialization {
  NSError *err = nil;
  NSDictionary *json = [WFIGDefaultSerializer deserializeJSON:[self testJSONData]
                                                        error:&err];
  STAssertEqualObjects([self testJSONObject], json,
                       @"deserialized json did not equal expectation");
  
  //TODO - test TouchJSON/CSJON deserializer when it's ready
}

- (void) testSerialization {
  NSError *err = nil;
  NSData *data = [WFIGDefaultSerializer serializeJSON:[self testJSONObject]
                                          error:&err];
  NSDictionary *json = [WFIGDefaultSerializer deserializeJSON:data error:&err];
  
  STAssertEqualObjects([self testJSONObject], json,
                       @"serialized json did not match expectation");
  
  //TODO - test TouchJSON/CSJON serializer when it's ready
}

@end
