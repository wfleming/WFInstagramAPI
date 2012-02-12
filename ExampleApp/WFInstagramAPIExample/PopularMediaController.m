//
//  PopularMediaController.m
//  WFInstagramAPIExample
//
//  Created by William Fleming on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PopularMediaController.h"

@implementation PopularMediaController

- (id) init {
  if ((self = [self initWithNibName:nil bundle:nil])) {
    self.title = @"Popular";
  }
  return self;
}

- (void) loadMediaCollection {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    self.mediaCollection = [WFIGMedia popularMediaWithError:NULL];
    [self.tableView reloadData];
  });
}

@end
