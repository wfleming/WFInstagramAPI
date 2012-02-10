//
//  MediaImageCell.m
//  WFInstagramAPIExample
//
//  Created by William Fleming on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MediaImageCell.h"

static CGFloat kCellMargin = 5.0;

@implementation MediaImageCell {
  UIImageView *_imageView;
}

@synthesize media;

+ (CGFloat) rowHeight {
//  TODO
  return 302.0;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier])) {
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
  }
  return self;
}

- (void) layoutSubviews {
  [super layoutSubviews];
  
  CGFloat imgSize = self.contentView.frame.size.height - (2.0 * kCellMargin);
  _imageView.frame = CGRectMake(kCellMargin, kCellMargin, imgSize, imgSize);
  
  [self.media imageCompletionBlock:^(WFIGMedia* imgMedia, UIImage *img) {
    if (imgMedia == self.media) {
      _imageView.image = img;
    }
  }];
}


- (void)prepareForReuse {
  [super prepareForReuse];
  
  self.media = nil;
  _imageView.image = nil;
}

@end
