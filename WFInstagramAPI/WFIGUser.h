//
//  WFIGUser.h
//
//  Created by William Fleming on 11/16/11.
//

#import <Foundation/Foundation.h>

@class WFIGMediaCollection;

@interface WFIGUser : NSObject {
  BOOL _isCurrentUser; // used to track effective 'id' for API calls
}

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *instagramId;
@property (strong, nonatomic) NSString *profilePicture;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSNumber *followedByCount;
@property (strong, nonatomic) NSNumber *followsCount;
@property (strong, nonatomic) NSNumber *mediaCount;

+ (WFIGUser*) remoteUserWithId:(NSString*)userId error:(NSError* __autoreleasing*)error;

- (id) initWithJSONFragment:(NSDictionary*)json;

- (WFIGMediaCollection*) recentMediaWithError:(NSError* __autoreleasing*)error;

- (WFIGMediaCollection*) feedMediaWithError:(NSError* __autoreleasing*)error;

@end
