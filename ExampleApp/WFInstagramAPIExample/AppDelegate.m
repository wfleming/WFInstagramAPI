//
//  AppDelegate.m
//  WFInstagramAPIExample
//
//  Created by William Fleming on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "UserMediaListController.h"
#import "MediaDetailController.h"

NSString * const kDefaultsUserToken = @"user_token";
NSString * const kOAuthCallbackURL = @"egwfapi://auth";

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  // setup InstagramAPI client info
  NSString *config = [[NSBundle mainBundle] pathForResource:@"APIClient" ofType:@"plist"];
  if (nil == config) {
    [[NSException exceptionWithName:NSInternalInconsistencyException
                            reason:@"No client configuration plist found! Did you read the README?"
                           userInfo:nil] raise];
  }
  NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:config];
  [WFInstagramAPI setClientId:[plist objectForKey:@"id"]];
  [WFInstagramAPI setClientSecret:[plist objectForKey:@"secret"]];
  [WFInstagramAPI setClientScope:@"likes+relationships+comments"];
  [WFInstagramAPI setOAuthRedirectURL:kOAuthCallbackURL];
  [WFInstagramAPI setGlobalErrorHandler:^(WFIGResponse* response) {
    void (^logicBlock)(WFIGResponse*) = ^(WFIGResponse *response){
      switch ([response error].code) {
        case WFIGErrorOAuthException:
          [WFInstagramAPI enterAuthFlow];
          break;
        default: {
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:[[response error] localizedDescription]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
          [alert show];
        } break;
      }
    };
    // needs to be run on main thread because of UI changes. So we decide where to run & then run it.
    if ([NSThread isMainThread]) {
      logicBlock(response);
    } else {
      dispatch_sync(dispatch_get_main_queue(), ^{
        logicBlock(response);
      });
    }
  }];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [WFInstagramAPI setAccessToken:[defaults objectForKey:kDefaultsUserToken]];
  
  // more boilerplate app setup
  UIViewController *vc1 = [[UserMediaListController alloc] initWithWFIGUser:nil];
  UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
  self.tabBarController = [[UITabBarController alloc] init];
  self.tabBarController.viewControllers = [NSArray arrayWithObjects:nav1, nil];
  self.window.rootViewController = self.tabBarController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  NSDictionary *params = [url queryDictionary];
  
  // make the request to get the user's token, then store it in defaults/synchronize & set it on API
  WFIGResponse *response = [WFInstagramAPI accessTokenForCode:[params objectForKey:@"code"]];
  NSDictionary *json = [response parsedBody];
  NSString *token = [json objectForKey:@"access_token"];
  [WFInstagramAPI setAccessToken:token];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:token forKey:kDefaultsUserToken];
  [defaults synchronize];
  
  // dismiss our auth controller, get back to the regular application
  UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
  [keyWindow resignKeyWindow];
  keyWindow.hidden = YES;
  [WFInstagramAPI setAuthWindow:nil];
  [self.window makeKeyAndVisible];
  
  return YES;
}

@end
