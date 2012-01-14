//
//  WFIGDefaultSerializer.m
//
//  Created by William Fleming on 11/16/11.
//

#import "WFIGDefaultSerializer.h"


@implementation WFIGDefaultSerializer

+ (id) deserializeJSON:(NSData*)jsonData error:(NSError*__autoreleasing*)error {
  return [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:error];
}

+ (NSData*) serializeJSON:(id)object error:(NSError* __autoreleasing*)error {
  return [NSJSONSerialization dataWithJSONObject:object options:0 error:error];
}

@end
