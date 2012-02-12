//
//  OCPartialMockObject+MockStaticMethods.h
//  WFInstagramAPI
//
//  Created by William Fleming on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void* (^StubBlock)(id selfObj, ...);

@interface StaticStub : NSProxy

+ (id) stubForClass:(Class)klassToMock;

- (id) stub;

- (id) andReturn:(id)anObject;

/**
 * Replace a static method with a block execution.
 * selfObj will be self (in the context of the method, i.e. the class we're stubbing)
 * Subsequent arguments will be the method's arguments: you can use names
 * in your blocks to avoid dealing with va_list.
 * Your block *must* have an explicit return, even if it's just nil,
 * otherwise you will be unhappy.
 */
- (id) andExecute:(StubBlock)aBlock;

- (void) cancelStubs;

@end
