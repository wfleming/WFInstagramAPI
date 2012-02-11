//
//  SenTestCaseAdditions.m
//  WFInstagramAPI
//
//  Created by William Fleming on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SenTestCaseAdditions.h"

@implementation SenTestCase (Additions)

- (WFIGResponse*) responseWithStatus:(NSInteger)status body:(NSString*)body {
  OCMockObject *httpMock = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
  [[[httpMock stub] andReturnValue:[NSValue value:&status withObjCType:@encode(NSInteger)]] statusCode];
  [[[httpMock stub] andReturn:[NSDictionary dictionary]] allHeaderFields];
  
  NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
                                  
  return [WFIGResponse responseFrom:(NSHTTPURLResponse*)httpMock
                           withBody:bodyData
                           andError:nil];
}

@end
