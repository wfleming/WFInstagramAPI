//
//  NewCommentController.m
//  WFInstagramAPIExample
//
//  Created by William Fleming on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewCommentController.h"

@implementation NewCommentController

@synthesize media, textField, activityIndicator;

- (id) initWithMedia:(WFIGMedia*)newMedia;
{
  self = [super initWithNibName:@"NewCommentController" bundle:nil];
  if (self) {
    self.media = newMedia;
    self.title = @"New Comment";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Post"
                                              style:UIBarButtonItemStyleDone
                                              target:self
                                              action:@selector(post)];
  }
  return self;
}

- (IBAction) post {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    WFIGComment *comment = [[WFIGComment alloc] init];
    comment.text = self.textField.text;
    NSError *err = nil;
    if ([comment postToMedia:self.media error:&err]) {
      dispatch_sync(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
      });
    } else {
      dispatch_sync(dispatch_get_main_queue(), ^{
        self.navigationItem.prompt = [err localizedDescription];
      });
    }
  });
}

@end
