//
//  MediaImageCell.h
//  WFInstagramAPIExample
//
//  Created by William Fleming on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaImageCell : UITableViewCell

+ (CGFloat) rowHeight;

@property (strong, atomic) WFIGMedia *media;

@end
