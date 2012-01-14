//
//  WFIGCJSONSerializer.m
//
//  Created by William Fleming on 1/13/12.
//

#import "WFIGCJSONSerializer.h"

#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

@implementation WFIGCJSONSerializer

+ (id) deserializeJSON:(NSData*)jsonData error:(NSError*__autoreleasing*)error {
  return [[CJSONDeserializer deserializer] deserialize:jsonData error:error];
}

+ (NSData*) serializeJSON:(id)object error:(NSError* __autoreleasing*)error {
  return [[CJSONSerializer serializer] serializeObject:object error:error];
}

@end
