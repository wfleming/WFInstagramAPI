//
//  WFIGCJSONSerializer.m
//
//  Created by William Fleming on 1/13/12.
//

#import "WFIGCJSONSerializer.h"

@implementation WFIGCJSONSerializer

+ (id) deserializeJSON:(NSData*)jsonData error:(NSError*__autoreleasing*)error {
  Class cjsonDeserializer = NSClassFromString(@"CJSONDeserializer");
  WFIGDASSERT(nil != cjsonDeserializer);  // should only be called when CJSON is available
  id deserializer = (id __autoreleasing)[cjsonDeserializer deserializer];
  return [deserializer deserialize:jsonData error:error];
}

+ (NSData*) serializeJSON:(id)object error:(NSError* __autoreleasing*)error {
  Class cjsonSerializer = NSClassFromString(@"CJSONSerializer");
  WFIGDASSERT(nil != cjsonSerializer);  // should only be called when CJSON is available
  id serializer = (id __autoreleasing)[cjsonSerializer  serializer];
  return [serializer serializeObject:object error:error];
}

@end
