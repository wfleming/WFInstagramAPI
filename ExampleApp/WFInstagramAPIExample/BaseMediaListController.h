//
//  BaseMediaListController.h
//  WFInstagramAPIExample
//
//  Created by William Fleming on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseMediaListController : UITableViewController

@property (strong, atomic) WFIGMediaCollection *mediaCollection;

/* called when the view needs its media collection.
 * base implementation throws an exception.
 */
- (void) loadMediaCollection;

@end
