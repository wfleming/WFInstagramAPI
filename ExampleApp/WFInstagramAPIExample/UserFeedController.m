//
//  UserFeedController.m
//  WFInstagramAPIExample
//
//  Created by William Fleming on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserFeedController.h"

@implementation UserFeedController

- (id) init {
  if ((self = [self initWithNibName:nil bundle:nil])) {
    self.title = @"Your Feed";
  }
  return self;
}

- (void) loadMediaCollection {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    self.mediaCollection = [[WFInstagramAPI currentUser] feedMediaWithError:NULL];
    [self.tableView reloadData];
  });
}

@end
