//
//  WFIGConnectionDelegate.m
//
//  Created by William Fleming on 11/14/11.
//

#import "WFIGConnectionDelegate.h"

@implementation WFIGConnectionDelegate {
	NSMutableData *_data;
	NSURLResponse *_response;
	BOOL done;
	NSError *_error;
	NSURLConnection *_connection;	
}

@synthesize response=_response, data=_data, error=_error, connection=_connection;

- (id) init
{
	if ((self = [super init])) {
		self.data = [NSMutableData data];
		done = NO;
	}
	return self;
}

- (BOOL) isDone {
	return done;
}

- (void) cancel {
	[_connection cancel];
	self.response = nil;
	self.data = nil;
	self.error = nil;
	done = YES;
}

#pragma mark NSURLConnectionDelegate methods
- (NSURLRequest *)connection:(NSURLConnection *)aConnection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
	return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	if ([challenge previousFailureCount] > 0) {
		[[challenge sender] cancelAuthenticationChallenge:challenge];
	}
	else {
		[[challenge sender] useCredential:[challenge proposedCredential] forAuthenticationChallenge:challenge];
	}
}
- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	done = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse {
	self.response = aResponse;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)someData {
	[_data appendData:someData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
	done = YES;
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)aError {
	self.error = aError;
	done = YES;
}

//don't cache resources for now
- (NSCachedURLResponse *)connection:(NSURLConnection *)aConnection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	return nil;
}


@end
