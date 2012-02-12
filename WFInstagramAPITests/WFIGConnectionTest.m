//
//  WFIGConnectionTest.m
//  WFInstagramAPI
//
//  Created by William Fleming on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WFIGConnectionTest.h"

@implementation WFIGConnectionTest

- (void) testRequestForMethodTo {
  NSMutableURLRequest *request = [WFIGConnection requestForMethod:@"POST" to:@"http://foo.bar"];
  
  STAssertTrue([request isKindOfClass:[NSMutableURLRequest class]], nil);
  STAssertEqualObjects(@"POST", [request HTTPMethod], nil);
  STAssertEqualObjects(@"http://foo.bar", [[request URL] absoluteString], nil);
  
  // and again, with different values, just to be sure nothing got hardcoded
  request = [WFIGConnection requestForMethod:@"DELETE" to:@"http://foo.bar/blah"];
  
  STAssertTrue([request isKindOfClass:[NSMutableURLRequest class]], nil);
  STAssertEqualObjects(@"DELETE", [request HTTPMethod], nil);
  STAssertEqualObjects(@"http://foo.bar/blah", [[request URL] absoluteString], nil);
}

@end
