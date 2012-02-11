//
//  WFIGUserTest.m
//  WFInstagramAPI
//
//  Created by William Fleming on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WFIGUserTest.h"

@implementation WFIGUserTest

#pragma mark - utility methods
- (NSMutableDictionary*) basicJSON {
  return [NSMutableDictionary dictionaryWithObjectsAndKeys:
          @"12345", @"id",
          @"http://foo.bar", @"website",
          @"479628000", @"bio",
          @"abby_normal", @"username",
          @"Abby Normal", @"full_name",
          @"http://foo.bar/img.jpy", @"profile_picture",
          [NSDictionary dictionaryWithObjectsAndKeys:
           [NSNumber numberWithInt:10], @"media",
           [NSNumber numberWithInt:20], @"followed_by",
           [NSNumber numberWithInt:30], @"follows",
           nil], @"counts",
          nil];
}


#pragma mark - test methods
- (void) testBasicJSONInitialization {
  NSDictionary *json = [self basicJSON];
  WFIGUser *user = [[WFIGUser alloc] initWithJSONFragment:json];
  
  STAssertEqualObjects([json objectForKey:@"id"], user.userId,
                       @"incorrect instagram ID");
  STAssertEqualObjects([json objectForKey:@"website"], user.website,
                       @"incorrrect web link");
  STAssertEqualObjects([json objectForKey:@"bio"], user.bio,
                       @"incorrect bio");
  STAssertEqualObjects([json objectForKey:@"username"], user.username,
                       @"incorrect username");
  STAssertEqualObjects([json objectForKey:@"full_name"], user.fullName,
                       @"incorrect full name");
  STAssertEqualObjects([json objectForKey:@"profile_picture"], user.profilePicture,
                       @"incorrect bio");
  
  STAssertEqualObjects([[json objectForKey:@"counts"]
                         objectForKey:@"media"],
                       user.mediaCount, @"wrong media count");
  STAssertEqualObjects([[json objectForKey:@"counts"]
                         objectForKey:@"followed_by"],
                       user.followedByCount, @"wrong followed by count");
  STAssertEqualObjects([[json objectForKey:@"counts"]
                         objectForKey:@"follows"],
                       user.followsCount, @"wrong follows count");
}


@end
