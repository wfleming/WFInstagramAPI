//
//  WFIGAuthController.m
//
//  Created by William Fleming on 11/14/11.
//

#import "WFIGAuthController.h"
#import "WFInstagramAPI.h"

#define STATUS_HEIGHT 44.0

@interface WFIGAuthController (Private)
- (UIWebView*) webView;
- (UIActivityIndicatorView*) activityIndicator;
- (UILabel*) statusLabel;
- (UIView*) statusContainerView;
- (UIButton*) startOverButton;
@end

#pragma mark -
@implementation WFIGAuthController

Class initialViewClass = NULL;

+ (void) setInitialViewClass:(Class<WFIGAuthInitialView>)viewClass {
  initialViewClass = viewClass;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
  if (NULL != initialViewClass) {
    self.view = [[initialViewClass alloc] initWithController:self];
  } else {
    self.view = [[WFIGAuthDefaultInitialView alloc] initWithController:self];
  }
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
  [super viewDidUnload];
  _webView = nil;
  _activityIndicator = nil;
  _statusLabel = nil;
  _initialView = nil;
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - action handling

- (IBAction)gotoInstagramAuthURL:(id)sender {
  // rebuild view for webview
  UIView *newView = [[UIView alloc] initWithFrame:self.view.frame];
  [newView addSubview:[self statusContainerView]];
  [newView addSubview:[self webView]];
  self.view = newView;
  
  // go to the url
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[WFInstagramAPI authURL]]];
  [[self webView] loadRequest:request];
}

#pragma mark - UIWebViewDelegate Implementations
- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  // Determine if we want the system to handle it.
  NSURL *url = request.URL;
  if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"]) {
    if ([[UIApplication sharedApplication]canOpenURL:url]) {
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      [[UIApplication sharedApplication]openURL:url];
      return NO;
    }
  }
  return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  [[self startOverButton] removeFromSuperview];
  
  [_activityIndicator startAnimating];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  _statusLabel.text = @"Loading...";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [_activityIndicator stopAnimating];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  _statusLabel.text = nil;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  // Ignore NSURLErrorDomain error -999.
  if (error.code == NSURLErrorCancelled) return;
  
  // Ignore "Frame Load Interrupted" errors. Seen after app URLs
  if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) return;
  
  // normal error response
  [_activityIndicator stopAnimating];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  _statusLabel.text = @"ERROR";
  
  // show the start over button
  [[self statusContainerView] addSubview:[self startOverButton]];
}

- (void) startOver {
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[WFInstagramAPI authURL]]];
  [[self webView] loadRequest:request];
}


#pragma mark - properties

- (UIWebView*) webView {
  if (!_webView) {
    CGRect webFrame = CGRectMake(0, STATUS_HEIGHT, self.view.frame.size.width, (self.view.frame.size.height - STATUS_HEIGHT));
    _webView = [[UIWebView alloc] initWithFrame:webFrame];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
  }
  return _webView;
}

- (UIActivityIndicatorView*) activityIndicator {
  if (!_activityIndicator) {
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicator.frame = CGRectMake(10.0,
                                          ([self statusContainerView].frame.size.height - _activityIndicator.frame.size.height) / 2.0,
                                          _activityIndicator.frame.size.width,
                                          _activityIndicator.frame.size.height);
    WFIGDLOG(@"activity fram is %@", NSStringFromCGRect(_activityIndicator.frame));
    _activityIndicator.hidesWhenStopped = YES;
  }
  return _activityIndicator;
}

- (UILabel*) statusLabel {
  if (!_statusLabel) {
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0,
                                                             ([self statusContainerView].frame.size.height - 20.0) / 2.0,
                                                             200.0,
                                                             20.0)];
    _statusLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    _statusLabel.textColor = [UIColor whiteColor];
    _statusLabel.backgroundColor = [UIColor clearColor];
  }
  return _statusLabel;
}

- (UIView*) statusContainerView {
  if (!_statusContainer) {
    _statusContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, STATUS_HEIGHT)];
    _statusContainer.backgroundColor = [UIColor blackColor];
    [_statusContainer addSubview:[self activityIndicator]];
    [_statusContainer addSubview:[self statusLabel]];
  }
  
  return _statusContainer;
}

- (UIButton*) startOverButton {
  if (!_startOverButton) {
    _startOverButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGFloat width = 100.0, hPadding = 20.0, height = 34.0;
    _startOverButton.frame = CGRectMake([self statusContainerView].frame.size.width - width - hPadding,
                                        ([self statusContainerView].frame.size.height - height) / 2.0,
                                        width,
                                        height);
    [_startOverButton setTitle:@"Start Over" forState:UIControlStateNormal];
    [_startOverButton addTarget:self action:@selector(startOver) forControlEvents:UIControlEventTouchUpInside];
  }
  return _startOverButton;
}

@end
