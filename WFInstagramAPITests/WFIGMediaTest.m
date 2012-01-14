//
//  WFIGMediaTest.m
//
//  Created by William Fleming on 1/14/12.
//

#import "WFIGMediaTest.h"

#import "WFIGMedia.h"

@implementation WFIGMediaTest

#pragma mark - utility methods
- (NSMutableDictionary*) basicJSON {
  return [NSMutableDictionary dictionaryWithObjectsAndKeys:
          @"12345", @"id",
          @"http://foo.bar", @"link",
          @"479628000", @"created_time",
          [NSMutableArray arrayWithObjects:@"foo", @"bar", nil], @"tags",
          @"sample caption", @"caption",
          [NSMutableDictionary dictionaryWithObjectsAndKeys:
           [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @"http://image.url/standard_resolution", @"url",
            nil], @"standard_resolution",
           [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @"http://image.url/low_resolution", @"url",
            nil], @"low_resolution",
           [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @"http://image.url/thumbnail", @"url",
            nil], @"thumbnail",
           nil], @"images",
          nil];
}


#pragma mark - test methods
- (void) testBasicJSONInitialization {
  NSDictionary *json = [self basicJSON];
  WFIGMedia *media = [[WFIGMedia alloc] initWithJSONFragment:json];

  STAssertEqualObjects([json objectForKey:@"id"], media.instagramId,
                       @"incorrect instagram ID");
  STAssertEqualObjects([json objectForKey:@"link"], media.instagramURL,
                       @"incorrrect web link");
  NSDate *expectedDate = [NSDate dateWithTimeIntervalSince1970:479628000.0];
  STAssertEqualObjects(expectedDate, media.createdTime, @"wrong created date");
  STAssertEqualObjects([json objectForKey:@"tags"], media.tags, @"wrong tags");
  
  STAssertEqualObjects([[[json objectForKey:@"images"]
                         objectForKey:@"standard_resolution"]
                        objectForKey:@"url"],
                       media.imageURL, @"wrong standard image URL");
  STAssertEqualObjects([[[json objectForKey:@"images"]
                         objectForKey:@"low_resolution"]
                        objectForKey:@"url"],
                       media.lowResolutionURL, @"wrong low res image URL");
  STAssertEqualObjects([[[json objectForKey:@"images"]
                         objectForKey:@"thumbnail"]
                        objectForKey:@"url"],
                       media.thumbnailURL, @"wrong thumbnail image URL");
}

@end
