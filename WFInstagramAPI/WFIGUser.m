//
//  WFIGUser.m
//
//  Created by William Fleming on 11/16/11.
//

#import "WFIGUser.h"

#import "WFInstagramAPI.h"
#import "WFIGResponse.h"
#import "WFIGMedia.h"
#import "WFIGMediaCollection.h"

@interface WFIGUser (Private)
- (NSString*) effectiveApiId;
@end

#pragma mark -
@implementation WFIGUser

@synthesize username, userId, profilePicture, website, fullName, bio,
  followedByCount, followsCount, mediaCount;

+ (WFIGUser*) remoteUserWithId:(NSString*)userId error:(NSError* __autoreleasing*)error {
  WFIGUser *user = nil;
  WFIGResponse *response = [WFInstagramAPI get:[NSString stringWithFormat:@"/users/%@", userId]];
  if ([response isSuccess]) {
    NSDictionary *data = [[response parsedBody] objectForKey:@"data"];
    user = [[self alloc] initWithJSONFragment:data];
    user->_isCurrentUser = [@"self" isEqual:userId];
  } else {
    if (error) {
      *error = [response error];
    }
    WFIGDLOG(@"response error: %@", [response error]);
    WFIGDLOG(@"response body: %@", [response parsedBody]);
  }
  return user;
}

- (id) initWithJSONFragment:(NSDictionary*)json {
  if ((self = [self init])) {
    self.userId = [json objectForKey:@"id"];
    self.username = [json objectForKey:@"username"];
    self.profilePicture = [json objectForKey:@"profile_picture"];
    self.website = [json objectForKey:@"website"];
    self.bio = [json objectForKey:@"bio"];
    self.fullName = [json objectForKey:@"full_name"];
    
    //TODO: counts properties on other than explicit user attrs
    NSDictionary *counts = [json objectForKey:@"counts"];
    self.followsCount = [counts objectForKey:@"follows"];
    self.followedByCount = [counts objectForKey:@"followed_by"];
    self.mediaCount = [counts objectForKey:@"media"];
  }
  return self;
}

- (WFIGMediaCollection*) recentMediaError:(NSError* __autoreleasing*)error; {
  WFIGMediaCollection *media = nil;
  WFIGResponse *response = [WFInstagramAPI get:[NSString stringWithFormat:@"/users/%@/media/recent", [self effectiveApiId]]];
  if ([response isSuccess]) {
    media = [[WFIGMediaCollection alloc] initWithJSON:[response parsedBody]];
  } else {
    if (error) {
      *error = [response error];
    }
    WFIGDLOG(@"response error: %@", [response error]);
    WFIGDLOG(@"response body: %@", [response parsedBody]);
  }
  
  return media;
}
@end


#pragma mark -
@implementation WFIGUser (Private)
- (NSString*) effectiveApiId {
  return (_isCurrentUser ? @"self" : self.userId);
}
@end