//
//  WFInstagramAPITests.m
//
//  Created by William Fleming on 1/13/12.
//

#import "WFInstagramAPITests.h"

#import <OCMock/OCMock.h>
#import "StaticMock.h"

#import "WFInstagramAPI.h"

@implementation WFInstagramAPITests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

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

@end
