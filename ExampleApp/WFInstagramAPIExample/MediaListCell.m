//
//  MediaListCell.m
//  WFInstagramAPIExample
//
//  Created by William Fleming on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MediaListCell.h"

static CGFloat kCellMargin = 5.0;

@implementation MediaListCell {
  UIImageView *_imageView;
}

@synthesize media;

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
  
  CGFloat x = _imageView.frame.size.width + _imageView.frame.origin.x + kCellMargin,
          w = self.contentView.frame.size.width - x - kCellMargin;
  
  self.textLabel.frame = CGRectMake(x,
                                    kCellMargin,
                                    w,
                                    self.textLabel.frame.size.height);
  self.detailTextLabel.frame = CGRectMake(x,
                                          kCellMargin + self.textLabel.frame.size.height,
                                          w,
                                          self.detailTextLabel.frame.size.height);
  
  self.textLabel.text = self.media.caption;
  self.detailTextLabel.text = [self.media.userData objectForKey:@"username"];
  [self.media thumbnailCompletionBlock:^(WFIGMedia* imgMedia, UIImage *img) {
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
