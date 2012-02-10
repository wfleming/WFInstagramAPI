//
//  NewCommentController.h
//  WFInstagramAPIExample
//
//  Created by William Fleming on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewCommentController : UIViewController

@property (strong, nonatomic) WFIGMedia *media;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (id) initWithMedia:(WFIGMedia*)newMedia;

- (IBAction) post;

@end
