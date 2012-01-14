//
//  WFIGAuthDefaultInitialView.h
//
//  Created by William Fleming on 11/14/11.
//

#import <UIKit/UIKit.h>

@class WFIGAuthController;

@protocol WFIGAuthInitialView
- (id) initWithController:(WFIGAuthController*)controller;
@end


#pragma mark -
@interface WFIGAuthDefaultInitialView : UIView <WFIGAuthInitialView> {
  WFIGAuthController *_controller;
}

@end
