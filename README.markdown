WFInstagramAPI is an Objective-C iOS library for interacting with [Instagram's API](http://instagram.com/developer/). It was written initially to enable the development of [Lolgramz](http://lolgramz.com).

# Getting Started

## Linking WFInstagramAPI to your project

1. Clone the project locally
2. Drag WFInstagramAPI.xcodeproj to your project's *Frameworks group*.

   ![Your Frameworks Group](https://github.com/wfleming/WFinstagramAPI/raw/master/readme_assets/add_to_frameworks.png)
3. Open your project's settings, to the **Build Phases** tab, open the **Link Binary With Libraries** section, Click the **+** button, and add **libWFInstagramAPI.a**

   ![Project Dependencies](https://github.com/wfleming/WFinstagramAPI/raw/master/readme_assets/add_dependency.png)
4. Go to the **Build Settings** tab, find the **Header Search Paths** setting, and add `$(BUILT_PRODUCTS_DIR)/../WFInstagramAPI` for all build configurations.

   ![Header Search Paths](https://github.com/wfleming/WFinstagramAPI/raw/master/readme_assets/header_search_paths.png)
5. In your prefix header, or in particular files where you wish to use WFInstagramAPI, add `#import "WFInstagramAPI.h"`

## Beginning to use the library

Your going to need an Instagram Client. If you don't have one, [go take care of that](http://instagram.com/developer/manage).

You're going to want to configure a custom URL scheme for your app that you can use as a redirect after the OAuth flow is complete. Depending on your situation, you may want to have Instagram redirect to a web URL you control after authentication, and then redirect back to your app's URL from there. But you can also have Instagram redirect directly back to your app: the example app included in this repo does that.

You will probably want to do primary configuration in your application delegate's `-application:didFinishLaunchingWithOptions:`, similar to this:

```objc
#import "WFInstagramAPI.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [WFInstagramAPI setClientId:@"YOUR_CLIENT_ID"];
  [WFInstagramAPI setClientSecret:@"YOUR_CLIENT_SECRET"];
  [WFInstagramAPI setOAuthRedirectURL:kOAuthCallbackURL];
  
  /* you should store the user's access token somewhere (NSUserDefaults, database, etc.)
   * after they've authenticated, and set it on future runs here as well.
   */
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   [WFInstagramAPI setAccessToken:[defaults objectForKey:@"InstagramToken"]];
  ...
}
```

You will, presumably, need to have your user authenticate your app with Instagram. WFInstagramAPI tries to make this flow as painless as possible: there's a built-in UI flow to get you up and running quickly (and which can be altered to use a custom view later), or you can sidestep it & use your own UI flow if you prefer. To check for current authentication & jump into the baked-in UI flow if no user is authenticated, simply call `[WFInstagramAPI authenticateUser]`. For an alternative approach that will handle expired/cancelled tokens gracefully, see the example project.

Once you've got your basic client info set up & a user authenticated, you're finally ready to start actually querying for media and doing stuff with it! To get your authenticated user's recent photos, you could call `[[WFInstagramAPI currentUser] recentMediaWithError:NULL]`. For more details of available objects & methods, refer to the source & the example project.

## Further Details

The example project attempts to demonstrate usage of most aspects of the API, and is useful as a reference. Note that the example project has its own `README`, which you should read, as it requires some of its own setup to use.

The project's header files, particularly under the **Models** group, are the best reference to available methods and to understand how to interact with available data.

## Extension Points

There are a few extension points the library provides to better alter core parts the library provides for you.

### Error Handling

You can specify a block using `+[WFIGConnection setGlobalErrorHandler:]` that will get called any time an HTTP response from the API is an error code.

### Custom Auth Flow View

You can set a custom UIView class to be show when the user is prompted to authenticate using `[WFIGAuthController setInitialViewClass:]`. Your class must implement the `WFIGAuthInitialView` protocol, and must call `-gotoInstagramAuthURL:` on the given instance of the `WFIGAuthController` when appropriate.

### Custom JSON serializer

You can set a different class to use for JSON serialization using `+[WFIGInstagram setSerializer:]`. The class you set must implement the `WFIGSerializer` protocol. This repository actually contains files for one non-standard & currently non-compiled serializer: `WFIGCJSONSerializer`, which uses the [TouchJSON](https://github.com/TouchCode/TouchJSON). TouchJSON is *significantly* faster than Apple's built in `NSJSONSerialization`, so copying these files to your project, including `TouchJSON`, and using this serializer instead is encouraged.

# Contributing

If you use WFInstagramAPI, I hope it'll be useful for you. It is by no means, however, complete. If you find you need to add or fix parts of the library as you use it, it would be awesome if your work could get merged back to this repository so that other people can benefit as well. To that end, please submit pull requests!

# Future

Here are some things I'd like to add eventually (aside from simply being more complete with supporting Instagram API concepts).

* It would be nice to make it easier to use the library in desktop OS X development in addition to iOS. The major obstacles here are `UIImage` vs. `NSImage` & the auth flow.

* It would be nice to have the JSON serialization automatically use `TouchJSON` when available, without the extra step of having to compile `WFIGCJSONSerializer` into your project & explicitly set it as the serializer to use. This could be done with a lot of -performSelector: style ugliness, but 1) doing that with class methods is uglier and I haven't put in the time yet, and 2) I'm not sure if the overhead of that might end up being slow enough to make the whole exercise not worth the effort.
