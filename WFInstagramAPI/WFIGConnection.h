//
//  WFIGConnection.h
//
//  Based off of ObjectiveResource's Connection:
//  https://github.com/yfactorial/objectiveresource
//
//  Created by William Fleming on 11/14/11.
//

#import <Foundation/Foundation.h>

@class WFIGResponse;

@interface WFIGConnection : NSObject

+ (WFIGResponse *)post:(NSString *)body to:(NSString *)url;
+ (WFIGResponse *)get:(NSString *)url;
+ (WFIGResponse *)put:(NSString *)body to:(NSString *)url;
+ (WFIGResponse *)delete:(NSString *)url;

// public so it can be overriden
+ (WFIGResponse *)sendRequest:(NSMutableURLRequest *)request;
+ (NSMutableURLRequest*) requestForMethod:(NSString *)method to:(NSString *)url;

+ (void) cancelAllActiveConnections;


@end
