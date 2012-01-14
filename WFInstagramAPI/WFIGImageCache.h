//
//  WFIGImageCache.h
//
//  Created by William Fleming on 12/3/11.
//

#import <Foundation/Foundation.h>

@interface WFIGImageCache : NSObject

+ (NSURL*) cacheDirectory;
+ (UIImage*) getImageAtURL:(NSString*)url;

@end
