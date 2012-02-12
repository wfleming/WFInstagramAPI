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
#import "WFIGComment.h"

@interface WFInstagramAPI : NSObject

+ (void) setClientId:(NSString*)clientId;
+ (NSString*) clientId;
+ (void) setClientSecret:(NSString*)clientSecret;
+ (NSString*) clientSecret;
+ (NSString*) clientScope;
/**
 * see http://instagram.com/developer/auth/#scope
 * specify this as a +-separated string of values.
 * e.g. @"likes+comments"
 */
+ (void) setClientScope:(NSString*)scope;
+ (void) setOAuthRedirectURL:(NSString*)url;
+ (NSString*)oauthRedirectURL;
+ (void) setAccessToken:(NSString*)accessToken;
+ (NSString*) accessToken;
+ (void) setSerializer:(Class<WFIGSerializer>)serializer;
+ (Class<WFIGSerializer>) serializer;
+ (UIWindow*) authWindow;
+ (void) setAuthWindow:(UIWindow*)window;

/**
 * The base API URL for *all* Instagram API URLs,
 * including auth URLs, etc.
 */
+ (NSString*) baseURL;

/**
 * The base URL for versioned API endpoints
 * (i.e. most API endpoints)
 */
+ (NSString*) versionedBaseURL;

/**
 * The OAuth URL to enter the OAuth flow.
 */
+ (NSString*) authURL;

/**
 * retrieve the response for a GET request to the given path,
 * which should be a relative endpoint for the API (e.g. /media/{media-id})
 */
+ (WFIGResponse *)get:(NSString*)path;

/**
 * retrieve the response for a POST request to the given path,
 * which should be a relative endpoint for the API (e.g. /media/{media-id})
 *
 * Params will be form encoded for the request. If you require more fine-tuned
 * control over your request, use +[WFIGConnection requestForMethod:to:]
 */
+ (WFIGResponse *)post:(NSDictionary*)params to:(NSString*)path;

/**
 * retrieve the response for a PUT request to the given path,
 * which should be a relative endpoint for the API (e.g. /media/{media-id})
 *
 * Params will be form encoded for the request. If you require more fine-tuned
 * control over your request, use +[WFIGConnection requestForMethod:to:]
 */
+ (WFIGResponse *)put:(NSDictionary*)params to:(NSString*)path;

/**
 * retrieve the response for a DELETE request to the given path,
 * which should be a relative endpoint for the API (e.g. /media/{media-id})
 */
+ (WFIGResponse *)delete:(NSString*)path;

/**
 * Retrieve the currently authenticated user.
 * Returns nil if no valid auth data is available.
 */
+ (WFIGUser*)currentUser;

/**
 * enter the OAuth flow if needed, otherwise do nothing
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
