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

@implementation BaseMediaListController

@synthesize mediaCollection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
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
