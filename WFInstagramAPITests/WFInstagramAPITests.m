//
//  WFInstagramAPITests.m
//
//  Created by William Fleming on 1/13/12.
//

#import "WFInstagramAPITests.h"

@implementation WFInstagramAPITests

// less a test of InstagramAPI, and more a sanity check on my StaticMock
- (void)testStaticStubbing
{
  [WFInstagramAPI setClientId:@"bar"];
  
  StaticStub *stub = [StaticStub stubForClass:[WFInstagramAPI class]];
  [[[stub stub] andReturn:@"foo"] clientId];
  
  NSString *rv = [WFInstagramAPI clientId];
  STAssertEqualObjects(@"foo", rv, @"stubbed value should be return");
  
  [stub cancelStubs];
  
  rv = [WFInstagramAPI clientId];
  STAssertEqualObjects(@"bar", rv, @"stubbed value should be gone");
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
  WFIGUser *user = [WFInstagramAPI currentUser];
  
  STAssertTrue([user isKindOfClass:[WFIGUser class]], @"user was not fetched/inorrect class. user is %@", user);
  STAssertEqualObjects(user.username, @"thorisalaptop", @"bad parsing");
}

@end
