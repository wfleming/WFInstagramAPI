//
//  FirstViewController.m
//  WFInstagramAPIExample
//
//  Created by William Fleming on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserMediaListController.h"

#import "MediaListCell.h"
#import "MediaDetailController.h"

@implementation UserMediaListController {
  WFIGUser *_user;
}

@synthesize mediaCollection;

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  [NSException exceptionWithName:NSInvalidArgumentException
                          reason:@"don't call that initializer, please."
                        userInfo:nil];
  return nil;
}
            
#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // start loading your photos if we don't have any right now
  if (nil == self.mediaCollection) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      WFIGUser *u = (_user ? _user : [WFInstagramAPI currentUser]);
      self.mediaCollection = [u recentMediaError:nil];
      [self.tableView reloadData];
    });
  }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  WFIGMedia *m = [self.mediaCollection objectAtIndex:indexPath.row];
  MediaDetailController *c = [[MediaDetailController alloc] initWithMedia:m];
  [self.navigationController pushViewController:c animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return ( nil == self.mediaCollection ? 1 : [self.mediaCollection count] ); 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  if (nil == self.mediaCollection) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell"];
    if (nil == cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoadingCell"];
    }
    cell.textLabel.text = @"Loading...";
  } else {
    WFIGMedia *photo = [self.mediaCollection objectAtIndex:indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:@"MediaCell"];
    if (nil == cell) {
      cell = [[MediaListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MediaCell"];
    }
    ((MediaListCell*)cell).media = photo;
    
    //TODO: add an extra cell to load more photos
  }
  return cell;
}

@end
