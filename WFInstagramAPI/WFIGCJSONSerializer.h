//
//  WFIGCJSONSerializer.h
//
//  Created by William Fleming on 1/13/12.
//

#import <Foundation/Foundation.h>

#import "WFIGDefaultSerializer.h"

/**
 * A faster serializer using the CJSON library.
 *
 * TODO: make the default serializer shift to using this if CJSON
 * is available, and reduce compiler dependency (headers) so this can
 * be compiled in all the time
 */
@interface WFIGCJSONSerializer : NSObject <WFIGSerializer>

@end
