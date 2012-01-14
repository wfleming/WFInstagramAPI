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
+ (void) setOAuthRedirctURL:(NSString*)url;
+ (NSString*)oauthRedirectURL;
+ (void) setAccessToken:(NSString*)accessToken;
+ (NSString*) accessToken;
+ (void) setSerializer:(Class<WFIGSerializer>)serializer;
+ (Class<WFIGSerializer>) serializer;
+ (UIWindow*) authWindow;
+ (void) setAuthWindow:(UIWindow*)window;

/**
 * NB - there is no guarantee about what thread this handler will be run on.
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

+ (void) authenticateUser; // enter the OAuth flow if needed
+ (void) enterAuthFlow; // explicitly - doesn't check tokens or anything

@end
