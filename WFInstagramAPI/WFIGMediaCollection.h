//
//  WFIGMediaCollection.h
//
//  Created by William Fleming on 12/2/11.
//

#import <Foundation/Foundation.h>

@interface WFIGMediaCollection : NSObject<NSFastEnumeration>

@property (strong, nonatomic) NSString *nextPageURL;

- (id) initWithJSON:(NSDictionary*)json;

- (BOOL) hasNextPage;
- (WFIGMediaCollection*) nextPageWithError:(NSError* __autoreleasing *)error;
- (BOOL) loadAndMergeNextPageWithError:(NSError* __autoreleasing *)error;

// NSArray proxy methods
- (NSUInteger) count;
- (BOOL) containsObject:(id)object;
- (id) objectAtIndex:(NSUInteger)index;

@end
