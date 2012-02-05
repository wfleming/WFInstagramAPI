//
//  WFInstagramAPI.h
//
//  Created by William Fleming on 11/13/11.
//

#import <Foundation/Foundation.h>

#import "WFIGConnection.h"
#import "WFIGResponse.h"
#import "WFIGDefaultSerializer.h"

#import "WFIGAuthController.h"
#import "WFIGAuthDefaultInitialView.h"

#import "WFIGUser.h"
#import "WFIGMedia.h"
#import "WFIGMediaCollection.h"

typedef void (^WFInstagramAPIErrorHandler)(WFIGResponse*);

@interface WFInstagramAPI : NSObject

+ (void) setClientId:(NSString*)clientId;
+ (NSString*) clientId;
+ (void) setClientSecret:(NSString*)clientSecret;
+ (NSString*) clientSecret;
+ (void) setOAuthRedirectURL:(NSString*)url;
+ (NSString*)oauthRedirectURL;
+ (void) setAccessToken:(NSString*)accessToken;
+ (NSString*) accessToken;
+ (void) setSerializer:(Class<WFIGSerializer>)serializer;
+ (Class<WFIGSerializer>) serializer;
+ (UIWindow*) authWindow;
+ (void) setAuthWindow:(UIWindow*)window;

/**
 * NB - there is no guarantee about what thread this handler will be run on.
 * If you do any UI manipulation (i.e. display an error) in this handler,
 * you should ensure that code runs on the main thread.
 */
+ (WFInstagramAPIErrorHandler)globalErrorHandler;
+ (void) setGlobalErrorHandler:(WFInstagramAPIErrorHandler)block;

+ (NSString*) endpoint;
+ (NSString*) versionedEndpoint;
+ (NSString*) authURL;
+ (WFIGResponse *)post:(NSString *)body to:(NSString *)path;
+ (WFIGResponse *)get:(NSString *)path;
+ (WFIGResponse *)put:(NSString *)body to:(NSString *)path;
+ (WFIGResponse *)delete:(NSString *)path;

+ (WFIGUser*)currentUser;

/**
 * enter the OAuth flow if needed
 */
+ (void) authenticateUser;

/**
 * enter the auth flow immediately, regardless of current auth status
 */
+ (void) enterAuthFlow;

/**
 * retrieve the access token for a user after they've authorized the client
 * via OAuth. This returns the raw response, so you get both the token & user JSON.
 * See the Instagram API documentation for details.
 */
+ (WFIGResponse*) accessTokenForCode:(NSString*)code;

@end
