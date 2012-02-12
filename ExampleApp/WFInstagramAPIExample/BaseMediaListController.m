//
//  BaseMediaListController.m
//  WFInstagramAPIExample
//
//  Created by William Fleming on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseMediaListController.h"

#import "MediaListCell.h"
#import "MediaDetailController.h"

@interface BaseMediaListController ()

- (void) loadMore;
  
@end

@implementation BaseMediaListController {
  BOOL _isLoadingMore;
}

@synthesize mediaCollection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _isLoadingMore = NO;
    // so we can reload data after coming back from auth flow
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeKey:) name:UIWindowDidBecomeKeyNotification object:self.view.window];
  }
  return self;
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) windowDidBecomeKey:(NSNotification*)notification {
  if ([self isViewLoaded] && self.view.window == notification.object) {
    if (nil == self.mediaCollection) {
      [self loadMediaCollection];
    }
  }
}

- (void) loadMediaCollection {
  [NSException raise:@"UnimplmentedException"
              format:@"Your subclass should implement -loadMediaCollection and not call super."];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // start loading your photos if we don't have any right now
  if (nil == self.mediaCollection) {
    [self loadMediaCollection];
  }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (nil == self.mediaCollection) {
    return;
  }
  
  if (indexPath.row < [self.mediaCollection count]) { // go to media detail
    WFIGMedia *m = [self.mediaCollection objectAtIndex:indexPath.row];
    MediaDetailController *c = [[MediaDetailController alloc] initWithMedia:m];
    [self.navigationController pushViewController:c animated:YES];
  } else { // load more
    [self loadMore];
  }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (nil == self.mediaCollection) {
    return 1; // loading cell
  } else {
    return [self.mediaCollection count] + ([self.mediaCollection hasNextPage] ? 1 : 0);
  }
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
    if (indexPath.row < [self.mediaCollection count]) {
      WFIGMedia *photo = [self.mediaCollection objectAtIndex:indexPath.row];
      cell = [tableView dequeueReusableCellWithIdentifier:@"MediaCell"];
      if (nil == cell) {
        cell = [[MediaListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MediaCell"];
      }
      ((MediaListCell*)cell).media = photo;
    } else {
      cell = [tableView dequeueReusableCellWithIdentifier:@"LoadMoreCell"];
      if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoadMoreCell"];
      }
      cell.textLabel.text = (_isLoadingMore ? @"Loading More..." : @"Load More");
    }
  }
  return cell;
}

#pragma mark - private methods

- (void) loadMore {
  _isLoadingMore = YES;
  NSIndexPath *loadMoreIndexPath = [NSIndexPath indexPathForRow:[self.mediaCollection count] inSection:0];
  [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:loadMoreIndexPath]
                        withRowAnimation:UITableViewRowAnimationLeft];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self.mediaCollection loadAndMergeNextPageWithError:NULL];
    [self.tableView reloadData];
    _isLoadingMore = NO;
  });
}

@end
