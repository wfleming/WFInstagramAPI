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

typedef void (^WFInstagramAPIErrorHandler)(WFIGResponse*);

@interface WFIGConnection : NSObject

+ (WFIGResponse *)post:(NSString *)body to:(NSString *)url;
+ (WFIGResponse *)get:(NSString *)url;
+ (WFIGResponse *)put:(NSString *)body to:(NSString *)url;
+ (WFIGResponse *)delete:(NSString *)url;


+ (WFIGResponse *)sendRequest:(NSMutableURLRequest *)request;
+ (NSMutableURLRequest*) requestForMethod:(NSString *)method to:(NSString *)url;

+ (void) cancelAllActiveConnections;

/**
 * NB - there is no guarantee about what thread this handler will be run on.
 * If you do any UI manipulation (i.e. display an error) in this handler,
 * you should ensure that code runs on the main thread.
 */
+ (WFInstagramAPIErrorHandler)globalErrorHandler;
+ (void) setGlobalErrorHandler:(WFInstagramAPIErrorHandler)block;


@end
