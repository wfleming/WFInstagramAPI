//
//  MockNSURLConnection.h
//  WFInstagramAPI
//
//  Created by William Fleming on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnexpectedStubURLRequest : NSException

+ (void) raiseForURL:(NSString*)url;

@end

/**
 * A stubbing proxy of NSURLConnection.
 *
 * ensures that no real HTTP behavior happens during tests.
 * throws an exception when an unexpected request comes through
 */
@interface StubNSURLConnection : NSObject

/**
 * begin mocking - after calling this,
 * +[NSURLConnection alloc] will return instances of
 * MockNSURLConnection
 */
+ (void) beginStubbing;

/**
 * reverse the mock
 */
+ (void) stopStubbing;

+ (void) stubResponse:(NSInteger)statusCode body:(NSString*)body forURL:(NSString*)requestURL;


#pragma mark - NSURLConnection public interface

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately;
- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate;

+ (NSURLConnection*)connectionWithRequest:(NSURLRequest *)request delegate:(id)delegate;

- (NSURLRequest *)originalRequest;
- (NSURLRequest *)currentRequest;

- (void)start;
- (void)cancel;

- (void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode;
- (void)unscheduleFromRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode;
- (void)setDelegateQueue:(NSOperationQueue*) queue;


@end
