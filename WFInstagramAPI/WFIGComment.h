//
//  WFIGComment.h
//  WFInstagramAPI
//
//  Created by William Fleming on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WFIGMedia, WFIGUser;

@interface WFIGComment : NSObject

@property (strong, nonatomic) NSDate *createdTime;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSNumber *commentId;
@property (strong, nonatomic) NSDictionary *userData;

+ (NSMutableArray*) commentsWithJSON:(NSArray*)json;

- (id) initWithJSONFragment:(NSDictionary*)json;

/**
 * The user from the local -userData JSON.
 * Note that user attrs given by the API on comment data are not
 * full: only a few attributes will actually be filled in.
 * You should use -[WFIGUser remoteUserWithId:error:] if you
 * require more user data.
 */
- (WFIGUser*) user;

- (BOOL) postToMedia:(WFIGMedia*)media error:(NSError* __autoreleasing*)error;

@end
