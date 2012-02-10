//
//  MediaDetailController.m
//  WFInstagramAPIExample
//
//  Created by William Fleming on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MediaDetailController.h"

#import "MediaImageCell.h"
#import "NewCommentController.h"


@implementation MediaDetailController

@synthesize media;

- (id)initWithMedia:(WFIGMedia*)newMedia
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
      self.media = newMedia;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  /*
   * 1. photo
   * 2. meta (byline, date)
   * 3. description
   * 4. comments
   */
  return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (1 == section) {
    return 2;
  } else if (section <= 2) {
    return 1;
  } else {
    // comment count + 1 (for add new)
    return [[self.media comments] count] + 1;
  }
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  NSString *t = nil;
  
  if (3 == section) { // comments
    t = [NSString stringWithFormat:@"%d Comments", [[self.media comments] count]];
  }
  
  return t;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *reuseId = @"TextCell";
  UITableViewCell *cell = nil;
  
  if (0 == indexPath.section) { // image
    reuseId = @"ImageCell";
    cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (nil == cell) {
      cell = [[MediaImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    ((MediaImageCell*)cell).media = self.media;
  } else if (1 == indexPath.section) { // meta (byline, date taken)
    cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (nil == cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    if (0 == indexPath.row) {
      cell.textLabel.text = [NSString stringWithFormat:@"by %@", self.media.user.username];
    } else if (1 == indexPath.row) {
      cell.textLabel.text = [NSString stringWithFormat:@"taken %@", self.media.createdTime];
    }
  } else if (2 == indexPath.section) { // caption
    cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (nil == cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.textLabel.text = self.media.caption;
  } else if (3 == indexPath.section) { // comments
    cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (nil == cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    if (indexPath.row < [[self.media comments] count]) {
      WFIGComment *comment = [[self.media comments] objectAtIndex:indexPath.row];
      cell.textLabel.text = [NSString stringWithFormat:@"%@ (by %@)", comment.text, comment.user.username];
    } else { // new comment
      cell.textLabel.text = @"Add Comment";
    }
  }
  
  return cell;
}

#pragma mark - Table view delegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (0 == indexPath.section) { // image
    return [MediaImageCell rowHeight];
  }
  
  return [tableView rowHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // add a new comment
  if (3 == indexPath.section && ([self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) == indexPath.row) {
    NewCommentController *c = [[NewCommentController alloc] initWithMedia:self.media];
    [self.navigationController pushViewController:c animated:YES];
  }
}

@end
