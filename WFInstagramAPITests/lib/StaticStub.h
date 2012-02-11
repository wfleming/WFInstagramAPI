//
//  OCPartialMockObject+MockStaticMethods.h
//  WFInstagramAPI
//
//  Created by William Fleming on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void* (^StubBlock)(void);

@interface StaticStub : NSProxy

+ (id) stubForClass:(Class)klassToMock;

- (id) stub;

- (StaticStub*) andReturn:(id)anObject;
- (StaticStub*) andDo:(StubBlock)aBlock;

- (void) cancelStubs;

@end
