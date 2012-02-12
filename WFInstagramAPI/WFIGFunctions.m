//
//  WFIGFunctions.m
//
//  Created by William Fleming on 11/16/11.
//

#import <stdio.h>
#import "WFIGFunctions.h"

NSDate* WFIGDateFromJSONString(NSString* str) {
  NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
  [f setNumberStyle:NSNumberFormatterNoStyle];
  double timestamp = [[f numberFromString:str] doubleValue];
  return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

NSString* WFIGURLEncodedString(NSString *str) {
  NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
                          @"@" , @"&" , @"=" , @"+" ,
                          @"$" , @"," , @"[" , @"]",
                          @"#", @"!", @"'", @"(", 
                          @")", @"*", @" ", nil];
  
  NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F" , @"%3F" ,
                           @"%3A" , @"%40" , @"%26" ,
                           @"%3D" , @"%2B" , @"%24" ,
                           @"%2C" , @"%5B" , @"%5D", 
                           @"%23", @"%21", @"%27",
                           @"%28", @"%29", @"%2A", @"%20", nil];
  
  int len = [escapeChars count];
  
  NSMutableString *temp = [str mutableCopy];
  
  int i;
  for(i = 0; i < len; i++)
  {
    
    [temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
                          withString:[replaceChars objectAtIndex:i]
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [temp length])];
  }
  
  NSString *out = [NSString stringWithString: temp];
  
  return out;
}

void WFIGFormEncodeBodyOnRequest(NSMutableURLRequest *request, NSDictionary *params) {
  [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
  
  NSMutableString *body = [[NSMutableString alloc] init];
  for (NSString *key in [params allKeys]) {
    NSString *val = [params objectForKey:key];
    [body appendFormat:@"%@=%@&", key, WFIGURLEncodedString(val)];
  }
  [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
}