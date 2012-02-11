//
//  WFInstagramAPITests.m
//
//  Created by William Fleming on 1/13/12.
//

#import "WFInstagramAPITests.h"

@implementation WFInstagramAPITests

// less a test of InstagramAPI, and more a sanity check on my StaticMock
- (void)testStaticMocking
{
  StaticMock *m = [StaticMock mockForClass:[WFInstagramAPI class]];
  [[[m stub] andReturn:@"foo"] clientId];
  
  NSString *rv = [WFInstagramAPI clientId];
  STAssertEqualObjects(@"foo", rv, @"stubbed value should be return");
  
  [m cancelMocks];
  
  rv = [WFInstagramAPI clientId];
  STAssertEqualObjects(nil, rv, @"stubbed value should be gone");
}

/**
 * this test isn't really feasible because of how WFIGConnection is designed,
 * how the global error handler works, and how rough mocking/stubbing is
 * in ObjC
 */
//- (void) testGlobalErrorHandler {
//  __block int blockCalled = 0;
//  [WFInstagramAPI setGlobalErrorHandler:^(WFIGResponse* response) {
//    blockCalled++;
//  }];
//  
//  StaticMock *connMock = [StaticMock mockForClass:[WFIGConnection class]];
//  WFIGResponse *mockResp = [self responseWithStatus:400
//                                               body:
//                            @"{\"meta\": {"
//                              "\"error_type\": \"OAuthParameterException\","
//                              "\"code\": 400,"
//                              "\"error_message\":\"full error message\""
//                            "}"];
//  [[[connMock stub] andReturn:mockResp] sendRequest:[OCMArg any]];
//  
//  [WFInstagramAPI currentUser];
//  
//  STAssertTrue((blockCalled > 0), @"error handler should have been called");
//  
//  [connMock cancelMocks];
//}

- (void) testCurrentUser {    
  StaticMock *connMock = [StaticMock mockForClass:[WFIGConnection class]];
  WFIGResponse *mockResp = [self responseWithStatus:200
                                               body:
                            @"{"
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
                            "}"];
  [[[connMock stub] andReturn:mockResp] sendRequest:[OCMArg any]];
  
  WFIGUser *user = [WFInstagramAPI currentUser];
  
  STAssertTrue([user isKindOfClass:[WFIGUser class]], @"user was not fetched/inorrect class");
  STAssertEqualObjects(@"thorisalaptop", user.username, @"bad parsing");
  
  [connMock cancelMocks];
}

@end
