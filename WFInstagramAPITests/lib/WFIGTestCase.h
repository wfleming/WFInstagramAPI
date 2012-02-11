//
//  SenTestCaseAdditions.h
//  WFInstagramAPI
//
//  Created by William Fleming on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface WFIGTestCase : SenTestCase

- (WFIGResponse*) responseWithStatus:(NSInteger)status body:(NSString*)body;

@end
