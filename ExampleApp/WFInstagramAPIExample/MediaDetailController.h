//
//  MediaDetailController.h
//  WFInstagramAPIExample
//
//  Created by William Fleming on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaDetailController : UITableViewController

@property (strong, nonatomic) WFIGMedia *media;

- (id)initWithMedia:(WFIGMedia*)newMedia;

@end
