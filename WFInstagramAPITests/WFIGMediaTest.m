//
//  WFIGMediaTest.m
//
//  Created by William Fleming on 1/14/12.
//

#import "WFIGMediaTest.h"

#import "WFIGMediaCollectionTest.h"

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
  STAssertEqualObjects([json objectForKey:@"caption"], media.caption, @"wrong caption");
  
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

/* some API calls return caption: "text", while others return more metadata,
 * which WFInstagramAPI currently discards. */
- (void) testComplexCaptionInitialization {
  NSMutableDictionary *json = [self basicJSON];
  NSString *expectedCaption = @"sample caption";
  [json setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                   @"479628000", @"created_time",
                   expectedCaption, @"text",
                   @"23456", @"id",
                   [NSDictionary dictionaryWithObjectsAndKeys:
                    @"abbynormal", @"username",
                    @"Abby Normal", @"full_name",
                    @"user", @"type",
                    @"12345", @"id",
                    nil], @"from",
                   nil]
           forKey:@"caption"];
  
  WFIGMedia *media = [[WFIGMedia alloc] initWithJSONFragment:json];
  STAssertEqualObjects(expectedCaption, media.caption, @"wrong caption");
}

- (void) testIOSURL {
  NSDictionary *json = [self basicJSON];
  WFIGMedia *media = [[WFIGMedia alloc] initWithJSONFragment:json];
  
  STAssertEqualObjects(@"instagram://media?id=12345", [media iOSURL], @"iOS URL should get generated");
}

- (void) testPopularMedia {
  [StubNSURLConnection stubResponse:200
                               body:[WFIGMediaCollectionTest pageOneJSON]
                             forURL:@"https://api.instagram.com/v1/media/popular?access_token=testAccessToken"];
  
  WFIGMediaCollection *photos = [WFIGMedia popularMediaWithError:NULL];
  STAssertTrue(([photos isKindOfClass:[WFIGMediaCollection class]]), nil);
  STAssertEquals((NSUInteger)2, [photos count], nil);
}

@end
