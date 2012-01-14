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

#endif
