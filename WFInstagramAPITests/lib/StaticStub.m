//
//  OCPartialMockObject+MockStaticMethods.m
//  WFInstagramAPI
//
//  Created by William Fleming on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StaticStub.h"
#import <objc/runtime.h>
#import <objc/message.h>

#pragma mark - private interface
@interface StaticStub ()

@property (nonatomic, retain) Class klass;
// { MethodName => StaticStubRecord }
@property (nonatomic, retain) NSMutableDictionary *currentStubs;
@property (nonatomic, retain) id currentReturnVal;
@property (nonatomic, copy) StubBlock currentReturnBlock;

@end


#pragma mark - Recording bookeeping object
@interface StaticStubRecord : NSObject
@property (nonatomic, assign) IMP originalIMP;
@property (nonatomic, retain) id stubbedReturnValue;
@property (nonatomic, copy) StubBlock stubbedReturnBlock;
@end

@implementation StaticStubRecord
@synthesize originalIMP, stubbedReturnValue, stubbedReturnBlock;
@end

#pragma mark - StaticMock class implementation
@implementation StaticStub

@synthesize klass, currentStubs, currentReturnVal, currentReturnBlock;

#pragma mark - NSProxy implementations
- (id) init {
  self.currentStubs = [NSMutableDictionary dictionary];
  return self;
}

- (void) dealloc {
  [self cancelStubs];
  self.currentStubs = nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
  return [self.klass methodSignatureForSelector:aSelector];
}

- (void) forwardInvocation:(NSInvocation *)anInvocation {
  Method currentMethod = class_getClassMethod(self.klass, [anInvocation selector]);
  BOOL newStub = NO;
  StaticStubRecord *record = [self.currentStubs objectForKey:NSStringFromSelector([anInvocation selector])];
  if (nil == record) {
    record = [[StaticStubRecord alloc] init];
    newStub = YES;
  }
  record.stubbedReturnValue = self.currentReturnVal;
  record.stubbedReturnBlock = self.currentReturnBlock;
  IMP newIMP = nil;
  if (record.stubbedReturnBlock) {
    newIMP = imp_implementationWithBlock((__bridge void*)record.stubbedReturnBlock);
  } else {
    newIMP = imp_implementationWithBlock((__bridge void*)^(id obj) {
      return record.stubbedReturnValue;
    });
  }
  
  IMP originalIMP = method_setImplementation(currentMethod, newIMP);
  if (newStub) { // always make sure we'll go back to the real original
    record.originalIMP = originalIMP;
  }

  // bookkeeping
  [self.currentStubs setObject:record forKey:NSStringFromSelector([anInvocation selector])];
}

#pragma mark - StaticMock implementations
+ (id) stubForClass:(Class)klassToMock {
  StaticStub *m = [[StaticStub alloc] init];
  m.klass = klassToMock;
  return m;
}

- (id) stub {
  return self;
}

- (id) andReturn:(id)anObject {
  self.currentReturnVal = anObject;
  return self;
}

- (id) andExecute:(StubBlock)aBlock {
  self.currentReturnBlock = aBlock;
  return self;
}

- (void) cancelStubs {
  NSArray *mockedSels = [self.currentStubs allKeys];
  for (NSString *selStr in mockedSels) {
    StaticStubRecord *record = [self.currentStubs objectForKey:selStr];
    Method currentMethod = class_getClassMethod(self.klass, NSSelectorFromString(selStr));
    IMP blockIMP = method_setImplementation(currentMethod, record.originalIMP);
    imp_removeBlock(blockIMP); // cleanup the block
  }
}

@end
