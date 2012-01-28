//
//  OCPartialMockObject+MockStaticMethods.m
//  WFInstagramAPI
//
//  Created by William Fleming on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StaticMock.h"
#import <objc/runtime.h>
#import <objc/message.h>

#pragma mark - private interface
@interface StaticMock ()

@property (nonatomic, retain) Class klass;
// { MethodName => StaticStubRecord }
@property (nonatomic, retain) NSMutableDictionary *currentMocks;
@property (nonatomic, retain) id currentReturnVal;

@end


#pragma mark - Recording bookeeping object
@interface StaticStubRecord : NSObject
@property (nonatomic, assign) IMP originalIMP;
@property (nonatomic, retain) id stubbedReturnValue;
@end

@implementation StaticStubRecord
@synthesize originalIMP, stubbedReturnValue;
@end

#pragma mark - StaticMock class implementation
@implementation StaticMock

@synthesize klass, currentMocks, currentReturnVal;

#pragma mark - NSProxy implementations
- (id) init {
  self.currentMocks = [NSMutableDictionary dictionary];
  return self;
}

- (void) dealloc {
  [self cancelMocks];
  self.currentMocks = nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
  return [self.klass methodSignatureForSelector:aSelector];
}

   
- (void) forwardInvocation:(NSInvocation *)anInvocation {
  Method currentMethod = class_getClassMethod(self.klass, [anInvocation selector]);
  StaticStubRecord *record = [[StaticStubRecord alloc] init];
  record.stubbedReturnValue = self.currentReturnVal;
  IMP newIMP = imp_implementationWithBlock((__bridge void*)^(id obj) {
   return record.stubbedReturnValue;
  });
  IMP originalIMP = method_setImplementation(currentMethod, newIMP);
  record.originalIMP = originalIMP;

  // bookkeeping
  [self.currentMocks setObject:record forKey:NSStringFromSelector([anInvocation selector])];
}
#pragma mark - StaticMock implementations
+ (id) mockForClass:(Class)klassToMock {
  StaticMock *m = [[StaticMock alloc] init];
  m.klass = klassToMock;
  return m;
}

- (id) stub {
  return self;
}

- (StaticMock*) andReturn:(id)anObject {
  self.currentReturnVal = anObject;
  return self;
}

- (void) cancelMocks {
  NSArray *mockedSels = [self.currentMocks allKeys];
  for (NSString *selStr in mockedSels) {
    StaticStubRecord *record = [self.currentMocks objectForKey:selStr];
    Method currentMethod = class_getClassMethod(self.klass, NSSelectorFromString(selStr));
    IMP blockIMP = method_setImplementation(currentMethod, record.originalIMP);
    imp_removeBlock(blockIMP); // cleanup the block
  }
}

@end
