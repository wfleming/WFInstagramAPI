//
//  WFIGResponse.h
//
//  Based off of ObjectiveResource's Response:
//  https://github.com/yfactorial/objectiveresource
//
//  Created by William Fleming on 11/14/11.
//

#import <Foundation/Foundation.h>

extern NSString * const kWFIGErrorDomain;

typedef enum {
  WFIGErrorTimeout,
  WFIGErrorOAuthException=400,
  WFIGErrorServerError=500,
  WFIGErrorDownForMaintenance=501
} WFIGErrorCode;

@interface WFIGResponse : NSObject {
  NSData *_rawBody;
  NSDictionary *_parsedBody;
	NSDictionary *_headers;
	NSInteger _statusCode;
	NSError *_error;
}

@property (nonatomic, readonly) NSData *rawBody;
@property (nonatomic, readonly) NSDictionary *parsedBody;
@property (nonatomic, readonly) NSDictionary *headers;
@property (nonatomic, readonly) NSInteger statusCode;
@property (nonatomic, readonly) NSError *error;

+ (id)responseFrom:(NSHTTPURLResponse *)response withBody:(NSData *)data andError:(NSError *)aError;
- (id)initFrom:(NSHTTPURLResponse *)response withBody:(NSData *)data andError:(NSError *)aError;
- (BOOL)isSuccess;
- (BOOL)isError;
- (NSString*)bodyAsString;


@end
