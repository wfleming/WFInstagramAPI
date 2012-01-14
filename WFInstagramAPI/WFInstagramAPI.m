//
//  WFInstagramAPI.m
//
//  Created by William Fleming on 11/13/11.
//

#import "WFInstagramAPI.h"

#import "WFIGFunctions.h"

static NSString *g_instagramClientId = nil;
static NSString *g_instagramOAuthRedirectURL = nil;
static NSString *g_instagramAccessToken = nil;
static Class<WFIGSerializer> g_instagramSerializer = nil;
static WFIGUser *g_instagramCurrentUser = nil;
static UIWindow *g_authWindow = nil;
static WFInstagramAPIErrorHandler g_errorHandler = nil;

@interface WFInstagramAPI (Private)
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

+ (void) setOAuthRedirctURL:(NSString*)url {
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

+ (WFInstagramAPIErrorHandler)globalErrorHandler {
  return g_errorHandler;
}

+ (void) setGlobalErrorHandler:(WFInstagramAPIErrorHandler)block {
  g_errorHandler = [block copy];
}


#pragma mark - URLs
+ (NSString*) endpoint {
  return @"https://api.instagram.com";
}

+ (NSString*) versionedEndpoint {
  return [NSString stringWithFormat:@"%@/v1", [self endpoint]];
}

+ (NSString*) authURL {
  return [NSString stringWithFormat:@"%@/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code&display=touch",
          [self endpoint],
          [self clientId],
          WFIGURLEncodedString([self oauthRedirectURL])];
}

+ (WFIGResponse *)post:(NSString *)body to:(NSString *)path {
  return [WFIGConnection post:body to:[self signedURLForPath:path]];
}

+ (WFIGResponse *)get:(NSString *)path {
  return [WFIGConnection get:[self signedURLForPath:path]];
}

+ (WFIGResponse *)put:(NSString *)body to:(NSString *)path {
  return [WFIGConnection put:body to:[self signedURLForPath:path]];
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
  
  // nothing more required -- +currentUser will enter flow if needed
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

@end




#pragma mark -
@implementation WFInstagramAPI (Private)
+ (NSString*) signedURLForPath:(NSString*)path {
  NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@%@",
                   [self versionedEndpoint],
                   ('/' == [path characterAtIndex:0] ? @"" : @"/"),
                   path];
  // append whichever token we have access to
  // append a ? if there are no query params, otherwise a &
  [url appendString:(NSNotFound == [url rangeOfString:@"?"].location ? @"?" : @"&")];
  if ([WFInstagramAPI accessToken]) {
    [url appendFormat:@"access_token=%@", [WFInstagramAPI accessToken]];
  } else {
    [url appendFormat:@"client_id=%@", [WFInstagramAPI clientId]];
  }
  return [NSString stringWithString:url];
}
@end