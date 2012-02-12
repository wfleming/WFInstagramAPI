//
//  FirstViewController.m
//  WFInstagramAPIExample
//
//  Created by William Fleming on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserMediaListController.h"

@implementation UserMediaListController {
  WFIGUser *_user;
}

- (id) initWithWFIGUser:(WFIGUser*)user {
  if ((self = [super initWithNibName:nil bundle:nil])) {
    _user = user;
    
    if (nil == user) {
      self.title = @"Your Photos";
    } else {
      self.title = [NSString stringWithFormat:@"%@'s Photos", _user.username];
    }
  }
  return self;
}

- (void) loadMediaCollection {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    WFIGUser *u = (_user ? _user : [WFInstagramAPI currentUser]);
    self.mediaCollection = [u recentMediaWithError:NULL];
    [self.tableView reloadData];
  });
}

@end
