//
//  WFIGComment.m
//  WFInstagramAPI
//
//  Created by William Fleming on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WFIGComment.h"

#import "WFIGFunctions.h"
#import "WFIGMedia.h"
#import "WFIGUser.h"
#import "WFInstagramAPI.h"

@implementation WFIGComment

@synthesize createdTime, text, commentId, userData;

+ (NSMutableArray*) commentsWithJSON:(NSArray*)json {
  NSMutableArray *comments = [[NSMutableArray alloc] init];
  for (NSDictionary *commentJson in json) {
    [comments addObject:[[WFIGComment alloc] initWithJSONFragment:commentJson]];
  }
  return comments;
}

- (id) initWithJSONFragment:(NSDictionary*)json {
  if ((self = [super init])) {
    self.commentId = [json objectForKey:@"id"];
    self.createdTime = WFIGDateFromJSONString([json objectForKey:@"created_time"]);
    self.text = [json objectForKey:@"text"];
    self.userData = [json objectForKey:@"from"];
  }
  return self;
}

- (WFIGUser*) user {
  return [[WFIGUser alloc] initWithJSONFragment:self.userData];
}

- (BOOL) postToMedia:(WFIGMedia*)media error:(NSError* __autoreleasing*)error {
  NSString *path = [NSString stringWithFormat:@"/media/%@/comments",
                    media.instagramId];
  NSDictionary *postParams = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.text, @"text",
                              nil];
  WFIGResponse *response = [WFInstagramAPI post:postParams to:path];
  
  if ([response isError]) {
    *error = [response error];
  }
  
  return [response isSuccess];
}

@end
