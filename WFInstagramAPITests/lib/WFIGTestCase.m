//
//  SenTestCaseAdditions.m
//  WFInstagramAPI
//
//  Created by William Fleming on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WFIGTestCase.h"

#import "StubNSURLConnection.h"

extern WFIGUser *g_instagramCurrentUser;

@implementation WFIGTestCase {

}

- (void) setUp {
  [WFInstagramAPI setClientId:@"testClientId"];
  [WFInstagramAPI setClientSecret:@"testClientSecret"];
  [WFInstagramAPI setAccessToken:@"testAccessToken"];
  [WFInstagramAPI setOAuthRedirectURL:@"testRedirectURL"];
  
  [StubNSURLConnection beginStubbing];
  
  [StubNSURLConnection stubResponse:200
                               body:@"{"
                                     "  \"meta\":  {"
                                     "    \"code\": 200"
                                     "  },"
                                     "  \"data\":  {"
                                     "    \"username\": \"thorisalaptop\","
                                     "    \"bio\": \"was born, still living\","
                                     "    \"website\": \"http://jwock.org\","
                                     "    \"profile_picture\": \"http://images.instagram.com/profiles/profile_980428_75sq_1291961825.jpg\","
                                     "    \"full_name\": \"Will Fleming\","
                                     "    \"counts\":  {"
                                     "      \"media\": 10,"
                                     "      \"followed_by\": 32,"
                                     "      \"follows\": 17"
                                     "    },"
                                     "    \"id\": \"980428\""
                                     "  }"
                                     "}"
                             forURL:@"https://api.instagram.com/v1/users/self?access_token=testAccessToken"];
}

- (void) tearDown {
  [StubNSURLConnection stopStubbing];
  
  // state that should be reset after all tests
  [WFIGConnection setGlobalErrorHandler:nil];
  [WFInstagramAPI setClientScope:nil];
  g_instagramCurrentUser = nil;
}

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
