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
    user = [[self alloc] init];
    NSDictionary *data = [[response parsedBody] objectForKey:@"data"];
    user.userId = [data objectForKey:@"id"];
    user.username = [data objectForKey:@"username"];
    user.profilePicture = [data objectForKey:@"profile_picture"];
    user.website = [data objectForKey:@"website"];
    user.bio = [data objectForKey:@"bio"];
    user.fullName = [data objectForKey:@"full_name"];
    
    NSDictionary *counts = [data objectForKey:@"counts"];
    user.followsCount = [counts objectForKey:@"follows"];
    WFIGDASSERT([user.followsCount isKindOfClass:[NSNumber class]]);
    user.followedByCount = [counts objectForKey:@"followed_by"];
    WFIGDASSERT([user.followedByCount isKindOfClass:[NSNumber class]]);
    user.mediaCount = [counts objectForKey:@"media"];
    WFIGDASSERT([user.mediaCount isKindOfClass:[NSNumber class]]);
    
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