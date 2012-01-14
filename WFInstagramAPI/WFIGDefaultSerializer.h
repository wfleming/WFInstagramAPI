//
//  WFIGDefaultSerializer.h
//
//  Created by William Fleming on 11/16/11.
//

#import <Foundation/Foundation.h>

@protocol WFIGSerializer

/**
 * expected to return an NSArray or NSDictionary
 */
+ (id) deserializeJSON:(NSData*)jsonData error:(NSError* __autoreleasing*)error;

//+ (id) deserializeJSONString:(NSString*) error:(NSError**)error;

/**
 * object should be an NSArray or NSDictionary
 */
+ (NSData*) serializeJSON:(id)object error:(NSError* __autoreleasing*)error;

//+ (id) serializeJSONString:(NSString*) error:(NSError**)error;

@end

/**
 * a serializer implementation that uses NSJSONSerialization
 */
@interface WFIGDefaultSerializer : NSObject <WFIGSerializer>

@end
