//
//  WFInstagramAPITests.m
//
//  Created by William Fleming on 1/13/12.
//

#import "WFInstagramAPITests.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation WFInstagramAPITests

// less a test of InstagramAPI, and more a sanity check on my StaticStub
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
  [WFIGConnection setGlobalErrorHandler:^(WFIGResponse* response) {
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

- (void) testBasicAuthURLGeneration {
  NSString *expected = @"https://api.instagram.com/oauth/authorize/?client_id=testClientId&redirect_uri=testRedirectURL&response_type=code&display=touch";
  STAssertEqualObjects(expected, [WFInstagramAPI authURL], @"expected \"%@\", but authURL was %@", expected, [WFInstagramAPI authURL]);
}

- (void) testAuthURLGenerationWithScope {
  [WFInstagramAPI setClientScope:@"comments+likes"];
  NSString *expected = @"https://api.instagram.com/oauth/authorize/?client_id=testClientId&redirect_uri=testRedirectURL&response_type=code&display=touch&scope=comments+likes";
  STAssertEqualObjects(expected, [WFInstagramAPI authURL], @"expected \"%@\", but authURL was %@", expected, [WFInstagramAPI authURL]);
}

- (void) testHttpGetConvenienceMethod {
  NSString *url = @"https://api.instagram.com/v1/endpoint/path?access_token=testAccessToken";
  [StubNSURLConnection stubResponse:200 body:@"foo" forURL:url];
  
  WFIGResponse *response = nil;
  STAssertNoThrow((response = [WFInstagramAPI get:@"/endpoint/path"]), @"fetch should work");
  STAssertTrue([response isKindOfClass:[WFIGResponse class]], @"response should be a WFIGResponse");
  STAssertTrue([response isSuccess], @"response should be a success");
  STAssertEqualObjects(@"foo", [response bodyAsString], @"body should be as expected");
  
  // results should be same without initial / on path
  response = nil;
  STAssertNoThrow((response = [WFInstagramAPI get:@"endpoint/path"]), @"fetch should work");
  STAssertTrue([response isKindOfClass:[WFIGResponse class]], @"response should be a WFIGResponse");
  STAssertTrue([response isSuccess], @"response should be a success");
  STAssertEqualObjects(@"foo", [response bodyAsString], @"body should be as expected");
}

- (void) testHttpPostConvenienceMethod {
  NSString *url = @"https://api.instagram.com/v1/endpoint/path";
  [StubNSURLConnection stubResponse:200 body:@"foo" forURL:url];
  
  WFIGResponse *response = nil;
  STAssertNoThrow((response = [WFInstagramAPI post:nil to:@"/endpoint/path"]), @"fetch should work");
  STAssertTrue([response isKindOfClass:[WFIGResponse class]], @"response should be a WFIGResponse");
  STAssertTrue([response isSuccess], @"response should be a success");
  STAssertEqualObjects(@"foo", [response bodyAsString], @"body should be as expected");
  
  // results should be same without initial / on path
  response = nil;
  STAssertNoThrow((response = [WFInstagramAPI post:nil to:@"endpoint/path"]), @"fetch should work");
  STAssertTrue([response isKindOfClass:[WFIGResponse class]], @"response should be a WFIGResponse");
  STAssertTrue([response isSuccess], @"response should be a success");
  STAssertEqualObjects(@"foo", [response bodyAsString], @"body should be as expected");
}

- (void) testHttpPutConvenienceMethod {
  NSString *url = @"https://api.instagram.com/v1/endpoint/path";
  [StubNSURLConnection stubResponse:200 body:@"foo" forURL:url];
  
  WFIGResponse *response = nil;
  STAssertNoThrow((response = [WFInstagramAPI put:nil to:@"/endpoint/path"]), @"fetch should work");
  STAssertTrue([response isKindOfClass:[WFIGResponse class]], @"response should be a WFIGResponse");
  STAssertTrue([response isSuccess], @"response should be a success");
  STAssertEqualObjects(@"foo", [response bodyAsString], @"body should be as expected");
  
  // results should be same without initial / on path
  response = nil;
  STAssertNoThrow((response = [WFInstagramAPI put:nil to:@"endpoint/path"]), @"fetch should work");
  STAssertTrue([response isKindOfClass:[WFIGResponse class]], @"response should be a WFIGResponse");
  STAssertTrue([response isSuccess], @"response should be a success");
  STAssertEqualObjects(@"foo", [response bodyAsString], @"body should be as expected");
}

- (void) testHttpDeleteConvenienceMethod {
  NSString *url = @"https://api.instagram.com/v1/endpoint/path?access_token=testAccessToken";
  [StubNSURLConnection stubResponse:200 body:@"foo" forURL:url];
  
  WFIGResponse *response = nil;
  STAssertNoThrow((response = [WFInstagramAPI delete:@"/endpoint/path"]), @"fetch should work");
  STAssertTrue([response isKindOfClass:[WFIGResponse class]], @"response should be a WFIGResponse");
  STAssertTrue([response isSuccess], @"response should be a success");
  STAssertEqualObjects(@"foo", [response bodyAsString], @"body should be as expected");
  
  // results should be same without initial / on path
  response = nil;
  STAssertNoThrow((response = [WFInstagramAPI delete:@"endpoint/path"]), @"fetch should work");
  STAssertTrue([response isKindOfClass:[WFIGResponse class]], @"response should be a WFIGResponse");
  STAssertTrue([response isSuccess], @"response should be a success");
  STAssertEqualObjects(@"foo", [response bodyAsString], @"body should be as expected");
}

- (void) testHttpPutAndPostConvenienceFormEncoding {
  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"val1", @"key1",
                          @"val2", @"key2",
                          @"val+3", @"key3",
                          nil];
  
  StaticStub *connStub = [StaticStub stubForClass:[WFIGConnection class]];
  __block NSString *expectedRequestMethod = nil;
  [[[connStub stub] andExecute:(StubBlock)^(id selfObj, NSMutableURLRequest *request) {
    STAssertEqualObjects(expectedRequestMethod, [request HTTPMethod], @"wrong request method");
    STAssertEqualObjects(@"application/x-www-form-urlencoded",
                         [request valueForHTTPHeaderField:@"Content-Type"],
                         @"wrong Content-Type header");
    
    // test the body encoding - same technique as -[WFIGFunctionsTest testFormEncodeBodyOnRequest]
    NSArray *expectedBodyChunks = [[NSArray arrayWithObjects:@"key1=val1",
                                    @"key2=val2",
                                    @"key3=val%2B3",
                                    @"", //because of trailing &
                                    @"access_token=testAccessToken", // pushed in by -[WFInstagramAPI post:/put: to:]
                                    nil] sortedArrayUsingSelector:@selector(compare:)];
    NSString *body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    NSArray *bodyChunks = [[body componentsSeparatedByString:@"&"] sortedArrayUsingSelector:@selector(compare:)];
    STAssertEqualObjects(expectedBodyChunks, bodyChunks, @"expected: %@, got: %@", expectedBodyChunks, bodyChunks);
    
    return nil;
  }] sendRequest:[OCMArg any]];
  
  // test POST
  expectedRequestMethod = @"POST";
  [WFInstagramAPI post:params to:@"/endpoint/path"];
  
  // test PUT
  expectedRequestMethod = @"PUT";
  [WFInstagramAPI put:params to:@"/endpoint/path"];
  
  [connStub cancelStubs];
}

- (void) testPreAuthenticateUserState {
  __block int enterAuthFlowCalls = 0;
  StaticStub *apiStub = [StaticStub stubForClass:[WFInstagramAPI class]];
  [[[apiStub stub] andExecute:(StubBlock)^(id selfObj) {
    enterAuthFlowCalls++;
  }] enterAuthFlow];
  
  [WFInstagramAPI setAccessToken:nil];
  [StubNSURLConnection stopStubbing];
  
  WFIGUser *user = [WFInstagramAPI currentUser];
  STAssertNil(user, @"user should be nil");
  
  [WFInstagramAPI authenticateUser];
  
  STAssertEquals(1, enterAuthFlowCalls, @"enterAuthFlow should have been called once");
}


@end
