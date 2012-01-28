//
//  OCPartialMockObject+MockStaticMethods.h
//  WFInstagramAPI
//
//  Created by William Fleming on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaticMock : NSProxy

+ (id) mockForClass:(Class)klassToMock;

- (id) stub;

- (StaticMock*) andReturn:(id)anObject;

- (void) cancelMocks;

@end
