//
//  WFIGAuthDefaultInitialView.m
//
//  Created by William Fleming on 11/14/11.
//

#import "WFIGAuthDefaultInitialView.h"
#import "WFIGAuthController.h"

@implementation WFIGAuthDefaultInitialView 

- (id) initWithController:(WFIGAuthController*)controller {
  if((self = [self init])) {
    _controller = controller;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Sign in with Instagram" forState:UIControlStateNormal];
    [button addTarget:_controller
               action:@selector(gotoInstagramAuthURL:)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 200, 80);
    [self addSubview:button];
    
    self.backgroundColor = [UIColor yellowColor];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  if(0 == frame.size.width) {
    frame = CGRectMake(0, 0, 320, 480); //naive
  }
  self = [super initWithFrame:frame];
  if (self) {
      // Initialization code
  }
  return self;
}

@end
