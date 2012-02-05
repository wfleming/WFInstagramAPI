//
//  NSURL+WillFleming.m
//  Memegram
//
//  Created by William Fleming on 11/16/11.
//  Copyright (c) 2011 Endeca Technologies. All rights reserved.
//

#import "NSURL+WillFleming.h"

@implementation NSURL (WillFleming)

- (NSDictionary*) queryDictionary {
  NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
  NSString *queryString = [self query];
  
  if (queryString && [queryString length] > 0) {
    NSArray *parts = [queryString componentsSeparatedByString:@"&"];
    for (NSString *param in parts) {
      NSArray *paramParts = [param componentsSeparatedByString:@"="];
      if (paramParts && 2 == [paramParts count]) {
        [params setObject:[paramParts objectAtIndex:1] forKey:[paramParts objectAtIndex:0]];
      }
    }
  }
  
  return [NSDictionary dictionaryWithDictionary:params];
}

@end
