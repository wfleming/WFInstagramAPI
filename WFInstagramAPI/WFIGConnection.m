//
//  WFIGConnection.m
//
//  Created by William Fleming on 11/14/11.
//

#import "WFIGConnection.h"

#import "WFIGConnectionDelegate.h"
#import "WFIGResponse.h"
#import "WFInstagramAPI.h"

static WFInstagramAPIErrorHandler g_errorHandler = nil;

@implementation WFIGConnection

static float timeoutInterval = 10.0;

static NSMutableArray *activeDelegates = nil;

static NSString * const kRunLoopMode = @"com.willfleming.instagram.connectionLoop";

#pragma mark - private methods

+ (NSMutableArray *)activeDelegates {
  @synchronized(self) {
    if (nil == activeDelegates) {
      activeDelegates = [NSMutableArray array];
    }
  }
	return activeDelegates;
}

+ (WFIGResponse *)sendBy:(NSString *)method withDataBody:(NSData *)body to:(NSString *)url {
  NSMutableURLRequest * request = [self requestForMethod:method to:url];
	[request setHTTPBody:body];
  
	return [self sendRequest:request];
}

+ (WFIGResponse *)sendBy:(NSString *)method withBody:(NSString *)body to:(NSString *)url {
  return [self sendBy:method withDataBody:[body dataUsingEncoding:NSUTF8StringEncoding] to:url];
}

+ (WFIGResponse *)postData:(NSData *)body to:(NSString *)url {
  return [self sendBy:@"POST" withDataBody:body to:url];
}


#pragma mark - public methods

+ (WFIGResponse *)sendRequest:(NSMutableURLRequest *)request {
	WFIGConnectionDelegate *connectionDelegate = [[WFIGConnectionDelegate alloc] init];
  
  @synchronized([self activeDelegates]) {
    [[self activeDelegates] addObject:connectionDelegate];
  }
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:connectionDelegate startImmediately:NO];
	connectionDelegate.connection = connection;
  
	
	//use a custom runloop
	[connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:kRunLoopMode];
	[connection start];
	while (![connectionDelegate isDone]) {
		[[NSRunLoop currentRunLoop] runMode:kRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:.3]];
	}
	WFIGResponse *resp = [WFIGResponse responseFrom:(NSHTTPURLResponse *)connectionDelegate.response 
                                         withBody:connectionDelegate.data 
                                         andError:connectionDelegate.error];
	
  @synchronized([self activeDelegates]) {
    [activeDelegates removeObject:connectionDelegate];
  }
  
  if ([resp isError] && [self globalErrorHandler]) {
    [self globalErrorHandler](resp);
  }
	
	return resp;
}

+ (NSMutableURLRequest*) requestForMethod:(NSString *)method to:(NSString *)url {
  NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                          cachePolicy:NSURLRequestReloadIgnoringCacheData
																											timeoutInterval:timeoutInterval];
	[request setHTTPMethod:method];
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];	
  [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
  return request;
}

+ (WFIGResponse *)post:(NSString *)body to:(NSString *)url {
  return [self sendBy:@"POST" withBody:body to:url];
}

+ (WFIGResponse *)get:(NSString *)url {
  return [self sendBy:@"GET" withBody:nil to:url];
}

+ (WFIGResponse *)put:(NSString *)body to:(NSString *)url {
  return [self sendBy:@"PUT" withBody:body to:url];
}

+ (WFIGResponse *)delete:(NSString *)url {
  return [self sendBy:@"DELETE" withBody:nil to:url];
}

+ (void) cancelAllActiveConnections {
  @synchronized(activeDelegates) {
    for (WFIGConnectionDelegate *delegate in activeDelegates) {
      [delegate performSelectorOnMainThread:@selector(cancel) withObject:nil waitUntilDone:NO];
    }
    [activeDelegates removeAllObjects];
  }
}

+ (WFInstagramAPIErrorHandler)globalErrorHandler {
  return g_errorHandler;
}

+ (void) setGlobalErrorHandler:(WFInstagramAPIErrorHandler)block {
  g_errorHandler = [block copy];
}

@end
