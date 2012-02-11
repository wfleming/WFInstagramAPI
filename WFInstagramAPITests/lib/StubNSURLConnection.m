//
//  MockNSURLConnection.m
//  WFInstagramAPI
//
//  Created by William Fleming on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StubNSURLConnection.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation UnexpectedStubURLRequest

+ (void) raiseForURL:(NSString*)url {
  [super raise:NSStringFromClass(self)
        format:@"No stub request found for URL %@", url];
}

@end

@interface StubHTTPResponse : NSObject

@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, strong) NSData *body;

@end

@implementation StubHTTPResponse
@synthesize statusCode, body;
@end


static NSURLConnection *g_realConnection = nil; // used for method signature, etc.
static IMP g_realSelfAlloc = NULL;
static IMP g_originalConnAlloc = NULL;
static NSMutableDictionary *g_stubResponses = nil; // URL -> StubResponse

#pragma mark -
@implementation StubNSURLConnection {
  NSURLRequest *_request;
  id _delegate;
}

#pragma mark - our methods

+ (id) superAlloc {
  if ([NSURLConnection class] == self) {
    return [StubNSURLConnection alloc];
  } else {
    [NSException raise:@"ArgumentException" format:@"didn't expect to alloc %@", self];
    return nil;
  }
}

+ (void) beginStubbing {
  if (nil == g_stubResponses) {
    g_stubResponses = [NSMutableDictionary dictionary];
  }
  
  if (nil == g_realConnection) {
    g_realConnection = [[NSURLConnection alloc] init]; //WithRequest:nil delegate:nil startImmediately:NO];
  }
  
  if (NULL == g_originalConnAlloc) {
    Class klass = [NSURLConnection class];
    SEL allocSel = @selector(alloc);
    Method superMethod = class_getClassMethod(klass, allocSel);
    g_originalConnAlloc = method_getImplementation(superMethod);
    
    Method selfActualMethod = class_getClassMethod(self, allocSel);
    g_realSelfAlloc = method_getImplementation(selfActualMethod);
    
    Method selfSwizzledMethod = class_getClassMethod(self, @selector(superAlloc));
    IMP selfSwizzledAlloc = method_getImplementation(selfSwizzledMethod);
    Class urlConnClass = [NSURLConnection class];
    Class metaClass = objc_getMetaClass(class_getName(urlConnClass));
    class_addMethod(metaClass, allocSel, selfSwizzledAlloc, "@@:");
    
    /**
     * because we repeat this continually in setup/teardown,
     * it gets odd. The first time we -beginStubbing, NSURLConnection
     * is just using +[NSObject alloc], which we replace by adding our
     * IMP (which effectively becomes +[NSURLConnection alloc]).
     * But when we teardown, we can't remove a method, so we just change
     * the IMP back to +[NSObject alloc]. Which means on subsequent setup
     * calls, class_addMethod has no effect (because +alloc is defined on
     * NSURLConnection, even though it == +[NSObject alloc]).
     *
     * So, we double check: if the current IMP != our swizzled IMP,
     * this must be a subsequent setup call, so we can safely
     * method_setImplementation to get the effect we want.
     * (we couldn't do that initally because it would have actually
     * changed +[NSObject alloc], which would have been BAD.
     */
    superMethod = class_getClassMethod(klass, allocSel);
    if (selfSwizzledAlloc != method_getImplementation(superMethod)) {
      method_setImplementation(superMethod, selfSwizzledAlloc);
    }
  }
}

/**
 * reverse the mock
 */
+ (void) stopStubbing {
  g_stubResponses = nil;
  g_realConnection = nil;
  
  Class parentKlass = [NSURLConnection class];
  SEL allocSel = @selector(alloc);
  Method superMethod = class_getClassMethod(parentKlass, allocSel);
  method_setImplementation(superMethod, g_originalConnAlloc);
  g_originalConnAlloc = NULL;
}

+ (void) stubResponse:(NSInteger)statusCode body:(NSString*)body forURL:(NSString*)requestURL {
  StubHTTPResponse *r = [[StubHTTPResponse alloc] init];
  r.statusCode = statusCode;
  r.body = [body dataUsingEncoding:NSUTF8StringEncoding];
  [g_stubResponses setObject:r forKey:requestURL];
}


#pragma mark - NSURLConnection public overrides
- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately {
  _request = request;
  _delegate = delegate;
  return self;
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate {
  return [self initWithRequest:request delegate:delegate startImmediately:NO];
}

- (id) init {
  return self;
}

+ (NSURLConnection*)connectionWithRequest:(NSURLRequest *)request delegate:(id)delegate {
  return [self connectionWithRequest:request delegate:delegate];
}

- (NSURLRequest *)originalRequest {
  return _request;
}
- (NSURLRequest *)currentRequest {
  return _request;
}

- (void)start {
  if (nil == [g_stubResponses objectForKey:[_request.URL absoluteString]]) {
    [UnexpectedStubURLRequest raiseForURL:[_request.URL absoluteString]];
  }

  StubHTTPResponse *r = [g_stubResponses objectForKey:[self.currentRequest.URL absoluteString]];
  OCMockObject *httpMock = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
  NSInteger status = r.statusCode;
  [[[httpMock stub] andReturnValue:[NSValue value:&status withObjCType:@encode(NSInteger)]] statusCode];
  [[[httpMock stub] andReturn:[NSDictionary dictionary]] allHeaderFields];

  [_delegate connection:(NSURLConnection*)self didReceiveResponse:(NSURLResponse*)httpMock];
  [_delegate connection:(NSURLConnection*)self didReceiveData:r.body];
  [_delegate connectionDidFinishLoading:(NSURLConnection*)self];
}

- (void)cancel {
  return;
}

- (void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode {
  return;
}
- (void)unscheduleFromRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode {
  return;
}
- (void)setDelegateQueue:(NSOperationQueue*) queue {
  return;
}

@end
