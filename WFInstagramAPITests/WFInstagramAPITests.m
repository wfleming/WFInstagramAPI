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

- (void) testGlobalErrorHandler {
  __block int blockCalled = 0;
  [WFInstagramAPI setGlobalErrorHandler:^(WFIGResponse* response) {
    blockCalled++;
  }];
  
  [StubNSURLConnection stubResponse:400
                               body:@"{\"meta\": {"
                                     "\"error_type\": \"OAuthParameterException\","
                                     "\"code\": 400,"
                                     "\"error_message\":\"full error message\""
                                     "}"
                             forURL:@"https://api.instagram.com/v1/users/self?access_token=testAccessToken"];
  
  [WFInstagramAPI currentUser];
  
  STAssertTrue((blockCalled > 0), @"error handler should have been called");
}

- (void) testCurrentUser {      
  WFIGUser *user = [WFInstagramAPI currentUser];
  
  STAssertTrue([user isKindOfClass:[WFIGUser class]], @"user was not fetched/inorrect class. user is %@", user);
  STAssertEqualObjects(user.username, @"thorisalaptop", @"bad parsing");
}

@end
