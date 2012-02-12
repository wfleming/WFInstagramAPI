//
//  WFInstagramAPI.m
//
//  Created by William Fleming on 11/13/11.
//

#import "WFInstagramAPI.h"

#import "WFIGFunctions.h"

NSString *g_instagramClientId = nil;
NSString *g_instagramClientSecret = nil;
NSString *g_instagramClientScope = nil;
NSString *g_instagramOAuthRedirectURL = nil;
NSString *g_instagramAccessToken = nil;
Class<WFIGSerializer> g_instagramSerializer = nil;
WFIGUser *g_instagramCurrentUser = nil;
UIWindow *g_authWindow = nil;

@interface WFInstagramAPI (Private)
+ (NSString*) urlForPath:(NSString*)path;
+ (NSString*) signedURLForPath:(NSString*)path;
@end


#pragma mark -
@implementation WFInstagramAPI

+ (void) initialize {
  g_instagramSerializer = [WFIGDefaultSerializer class];
}

#pragma mark - configuration
+ (void) setClientId:(NSString*)clientId {
  g_instagramClientId = clientId;
}

+ (NSString*) clientId {
  return g_instagramClientId;
}

+ (void) setClientSecret:(NSString*)clientSecret {
  g_instagramClientSecret = clientSecret;
}

+ (NSString*) clientSecret {
  return g_instagramClientSecret;
}

+ (NSString*) clientScope {
  return g_instagramClientScope;
}

+ (void) setClientScope:(NSString*)scope {
  g_instagramClientScope = scope;
}

+ (void) setOAuthRedirectURL:(NSString*)url {
  g_instagramOAuthRedirectURL = url;
}

+ (NSString*)oauthRedirectURL {
  return g_instagramOAuthRedirectURL;
}

+ (void) setAccessToken:(NSString*)accessToken {
  g_instagramAccessToken = accessToken;
}

+ (NSString*) accessToken {
  return g_instagramAccessToken;
}

+ (void) setSerializer:(Class<WFIGSerializer>)serializer {
  g_instagramSerializer = serializer;
}

+ (Class<WFIGSerializer>) serializer {
  return g_instagramSerializer;
}

+ (UIWindow*) authWindow {
  return g_authWindow;
}

+ (void) setAuthWindow:(UIWindow*)window {
  g_authWindow = window;
}

#pragma mark - URLs
+ (NSString*) baseURL {
  return @"https://api.instagram.com";
}

+ (NSString*) versionedBaseURL {
  return [NSString stringWithFormat:@"%@/v1", [self baseURL]];
}

+ (NSString*) authURL {
  NSMutableString *url = [NSMutableString stringWithFormat:
                          @"%@/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code&display=touch",
                          [self baseURL],
                          [self clientId],
                          WFIGURLEncodedString([self oauthRedirectURL])];
  if (nil != [self clientScope]) {
    [url appendFormat:@"&scope=%@", [self clientScope]];
  }
  return url;
}

+ (WFIGResponse *)get:(NSString *)path {
  return [WFIGConnection get:[self signedURLForPath:path]];
}

+ (WFIGResponse *)post:(NSDictionary*)params to:(NSString *)path {
  NSString *url = [self urlForPath:path];
  NSMutableURLRequest *request = [WFIGConnection requestForMethod:@"POST" to:url];
  
  // POST requests want access token in body
  NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithDictionary:params];
  [mutableParams setValue:[self accessToken] forKey:@"access_token"];
  
  WFIGFormEncodeBodyOnRequest(request, mutableParams);
  
  return [WFIGConnection sendRequest:request];
}

+ (WFIGResponse *)put:(NSDictionary*)params to:(NSString *)path {
  NSString *url = [self urlForPath:path];
  NSMutableURLRequest *request = [WFIGConnection requestForMethod:@"PUT" to:url];
  
  // PUT requests want access token in body
  NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithDictionary:params];
  [mutableParams setValue:[self accessToken] forKey:@"access_token"];
  
  WFIGFormEncodeBodyOnRequest(request, mutableParams);
  
  return [WFIGConnection sendRequest:request];
}

+ (WFIGResponse *)delete:(NSString *)path {
  return [WFIGConnection delete:[self signedURLForPath:path]];
}


#pragma mark -
+ (WFIGUser*)currentUser {
  if (!g_instagramCurrentUser) {
    NSError *err = nil;
    g_instagramCurrentUser = [WFIGUser remoteUserWithId:@"self" error:&err];
    if (!g_instagramCurrentUser && err) {
      WFIGDLOG(@"Error attempting to fetch current user: %@", err);
    }
  }
  return g_instagramCurrentUser;
}


#pragma mark -
+ (void) authenticateUser {
  // first, if we actually have an access token, check it for validity
  if ([self accessToken] && [self currentUser]) {
    // if these two things exist, we're valid
    return;
  }
  
  [self enterAuthFlow];
}

+ (void) enterAuthFlow {
  // established that we're not valid yet - show the auth controller
  WFIGAuthController *authController = [[WFIGAuthController alloc] init];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:authController];
  navController.navigationBarHidden = YES;
  
  // swap out current window for a window containing our auth view
  UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
  UIWindow *authWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  authWindow.rootViewController = navController;
  [self setAuthWindow:authWindow];  // otherwise it gets released silently
  [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
    [keyWindow resignKeyWindow];
    keyWindow.hidden = YES;
    [authWindow makeKeyAndVisible];
  } completion:NULL];
}

+ (WFIGResponse*) accessTokenForCode:(NSString*)code {
  NSString *url = [NSString stringWithFormat:@"%@/oauth/access_token", [self baseURL]];
  NSMutableURLRequest *request = [WFIGConnection requestForMethod:@"POST" to:url];
  
  [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
  
  NSMutableString *body = [[NSMutableString alloc] init];
  [body appendFormat:@"client_id=%@&", [self clientId]];
  [body appendFormat:@"client_secret=%@&", [self clientSecret]];
  [body appendString:@"grant_type=authorization_code&"];
  [body appendFormat:@"redirect_uri=%@&", WFIGURLEncodedString([self oauthRedirectURL])];
  [body appendFormat:@"code=%@", code];
  [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
  
  return [WFIGConnection sendRequest:request];
}

@end


#pragma mark -
@implementation WFInstagramAPI (Private)
+ (NSString*) urlForPath:(NSString*)path {
  return [NSString stringWithFormat:@"%@%@%@",
   [self versionedBaseURL],
   ('/' == [path characterAtIndex:0] ? @"" : @"/"),
   path];
}

+ (NSString*) signedURLForPath:(NSString*)path {
  NSMutableString *url = [NSMutableString stringWithString:[self urlForPath:path]];
  // append whichever token we have access to
  // append a ? if there are no query params, otherwise a &
  [url appendString:(NSNotFound == [url rangeOfString:@"?"].location ? @"?" : @"&")];
  if ([self accessToken]) {
    [url appendFormat:@"access_token=%@", [self accessToken]];
  } else {
    [url appendFormat:@"client_id=%@", [self clientId]];
  }
  return [NSString stringWithString:url];
}
@end