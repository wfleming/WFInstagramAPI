//
//  WFIGFunctions.h
//
//  Created by William Fleming on 11/16/11.
//

#ifndef WFIGFunctions_h
#define WFIGFunctions_h

#import <Foundation/Foundation.h>

/**
 * Instagram API gives dates as UNIX times, but they end up as strings in
 * decoded JSON objects. This function takes a string of a number
 * and returns a date.
 */
NSDate* WFIGDateFromJSONString(NSString* str);

/**
 * Takes any string, hex-encodes URL-unsafe characters (?, +, etc.),
 * and returns the result.
 */
NSString* WFIGURLEncodedString(NSString *str);

/**
 * Encodes the given `params` according as `application/x-www-form-urlencoded values`,
 * sets the result as the `request`'s body, and set's the `request`'s `Content-Type`
 * header to `application/x-www-form-urlencoded'
 */
void WFIGFormEncodeBodyOnRequest(NSMutableURLRequest *request, NSDictionary *params);

#endif
