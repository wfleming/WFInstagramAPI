//
//  WFIGMedia.m
//
//  Created by William Fleming on 11/14/11.
//

#import "WFIGMedia.h"

#import "WFIGFunctions.h"
#import "WFIGImageCache.h"

@implementation WFIGMedia

@synthesize instagramId, imageURL, thumbnailURL, lowResolutionURL, instagramURL,
  createdTime, caption, comments, tags, userData, locationData;

- (id) init {
  if ((self = [super init])) {
    self.comments = [NSMutableArray array];
  }
  return self;
}

- (id) initWithJSONFragment:(NSDictionary*)json {
  if ((self = [self init])) {
    self.instagramId = [json objectForKey:@"id"];
    
    self.imageURL = [[[json objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"];
    self.thumbnailURL = [[[json objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"url"];
    self.lowResolutionURL = [[[json objectForKey:@"images"] objectForKey:@"low_resolution"] objectForKey:@"url"];
    
    if (![[NSNull null] isEqual:[json objectForKey:@"link"]]) {
      self.instagramURL = [json objectForKey:@"link"];
    }
    
    self.createdTime = WFIGDateFromJSONString([json objectForKey:@"created_time"]);
    
    // from some requests, caption is just text. others, a dict.
    id captionInfo = [json objectForKey:@"caption"];
    if ([captionInfo isKindOfClass:[NSDictionary class]]) {
      self.caption = [(NSDictionary*)captionInfo objectForKey:@"text"];
    } else {
      self.caption = captionInfo;
    }
    
    //TODO: turn comments into actual comment data
    //TODO: do....something with likes.
    
    self.tags = [json objectForKey:@"tags"];
    self.userData = [json objectForKey:@"user"];
    self.locationData = [json objectForKey:@"location"];
  }
  return self;
}

- (NSString*) iOSURL {
  return [NSString stringWithFormat:@"instagram://media?id=%@", self.instagramId];
}


#pragma mark - Media methods
- (UIImage*) image {
  return [WFIGImageCache getImageAtURL:self.imageURL];
}

- (void) imageCompletionBlock:(WFIGMediaImageCallback)completionBlock {
  __block WFIGMedia *blockSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    __block UIImage *image = [blockSelf image];
    dispatch_async(dispatch_get_main_queue(), ^{
      completionBlock(blockSelf, image);
    });
  });
}

- (UIImage*) thumbnail {
  return [WFIGImageCache getImageAtURL:self.thumbnailURL];
}

- (void) thumbnailCompletionBlock:(WFIGMediaImageCallback)completionBlock {
  __block WFIGMedia *blockSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    __block UIImage *image = [blockSelf thumbnail];
    dispatch_async(dispatch_get_main_queue(), ^{
      completionBlock(blockSelf, image);
    });
  });
}

- (UIImage*) lowResolutionImage {
  return [WFIGImageCache getImageAtURL:self.lowResolutionURL];
}

- (void) lowResolutionImageWithCompletionBlock:(WFIGMediaImageCallback)completionBlock {
  __block WFIGMedia *blockSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    __block UIImage *image = [blockSelf lowResolutionImage];
    dispatch_async(dispatch_get_main_queue(), ^{
      completionBlock(blockSelf, image);
    });
  });
}

@end
