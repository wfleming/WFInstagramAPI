//
//  WFIGImageCache.m
//
//  Created by William Fleming on 12/3/11.
//

#import "WFIGImageCache.h"

#import "WFIGResponse.h"
#import "WFIGConnection.h"

@interface WFIGImageCache ()
+ (NSString*) relativePathForURL:(NSString*)urlStr;
+ (NSURL*) absolutePathForURL:(NSString*)urlStr;
+ (NSString*) relativeDirectoryForPath:(NSString*)urlStr;
+ (NSURL*) absoluteDirectoryForURL:(NSString*)urlStr;
@end

/**
 * Used to fetch images that aren't expected to change (avatars & media photos).
 * The cache is not very intelligent, and doesn't expire anything: it just
 * writes files to a tmp directory, and when URLs come in, it looks them up there:
 * if it's not there, it pulls it down, writes it to disk, & returns it.
 */
@implementation WFIGImageCache

+ (NSURL*) cacheDirectory {
  static NSURL *cachDir = nil;
  if (!cachDir) {
    cachDir = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"IGInstagramCache"];
  }
  return cachDir;
}

+ (UIImage*) getImageAtURL:(NSString*)url {
  NSString *cachePath = [[self absolutePathForURL:url] path];
  
  UIImage *image = nil;
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
    NSData *data = [NSData dataWithContentsOfFile:cachePath];
    image = [UIImage imageWithData:data];
  } else {    
    WFIGResponse *response = [WFIGConnection get:url];
    if ([response isSuccess]) {
      image = [UIImage imageWithData:response.rawBody];
      
      // cache the image
      NSString *cacheDir = [[self absoluteDirectoryForURL:url] path];
      NSError *err = nil;
      if ([[NSFileManager defaultManager] createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:&err]) {
        [response.rawBody writeToFile:cachePath atomically:YES];
      }
    }
  }
  
  return image;
}


#pragma mark - utility/private methods
+ (NSString*) relativePathForURL:(NSString*)urlStr {
  NSURL *url = [NSURL URLWithString:urlStr];
  NSString *path = [url path];
  return [path substringFromIndex:1]; // remove initial slash, we want a relative path
}

+ (NSURL*) absolutePathForURL:(NSString*)urlStr {
  return [[self cacheDirectory] URLByAppendingPathComponent:[self relativePathForURL:urlStr]];
}

+ (NSString*) relativeDirectoryForPath:(NSString*)urlStr {
  NSURL *url = [NSURL URLWithString:urlStr];
  NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:[url pathComponents]];
  [pathComponents removeObjectAtIndex:([pathComponents count] - 1)];
  return [NSString pathWithComponents:pathComponents];
}

+ (NSURL*) absoluteDirectoryForURL:(NSString*)urlStr {
  NSString *relativeDirectory = [self relativeDirectoryForPath:urlStr];
  return [[self cacheDirectory] URLByAppendingPathComponent:relativeDirectory];
}

@end
