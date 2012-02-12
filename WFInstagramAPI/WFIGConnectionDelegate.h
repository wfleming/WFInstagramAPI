//
//  WFIGConnectionDelegate.h
//
//  Based off of ObjectiveResource's ConnectionDelegate:
//  https://github.com/yfactorial/objectiveresource
//
//  Created by William Fleming on 11/14/11.
//

#import <Foundation/Foundation.h>

@interface WFIGConnectionDelegate : NSObject

- (BOOL) isDone;
- (void) cancel;

@property(nonatomic, strong) NSURLResponse *response;
@property(nonatomic, strong) NSMutableData *data;
@property(nonatomic, strong) NSError *error;
@property(nonatomic, strong) NSURLConnection *connection;

@end
