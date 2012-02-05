//
//  WFIGResponse.m
//
//  Created by William Fleming on 11/14/11.
//

#import "WFIGResponse.h"

#import "WFInstagramAPI.h"

NSString * const kWFIGErrorDomain = @"IGErrorDomain";

@implementation WFIGResponse

@synthesize rawBody=_rawBody, headers=_headers, statusCode=_statusCode, error=_error;

+ (id)responseFrom:(NSHTTPURLResponse *)response withBody:(NSData *)data andError:(NSError *)aError {
	return [[self alloc] initFrom:response withBody:data andError:aError];
}

- (void)normalizeError:(NSError *)aError {
  if (!aError) {
    return;
  }
	switch ([aError code]) {
		case NSURLErrorUserCancelledAuthentication:
			_statusCode = 401;
      _error = aError;
			break;
    case NSURLErrorCannotFindHost:
    case NSURLErrorCannotConnectToHost:
    case NSURLErrorNetworkConnectionLost:
    case NSURLErrorDNSLookupFailed:
      break;
    case 503: // means 'down for maintenance'
      _error = [NSError errorWithDomain:kWFIGErrorDomain
                                   code:WFIGErrorDownForMaintenance
                               userInfo:[NSDictionary dictionaryWithObject:@"Down for maintenance"
                                                                    forKey:NSLocalizedDescriptionKey]];
    case 400:
      _error = [NSError errorWithDomain:kWFIGErrorDomain
                                   code:WFIGErrorOAuthException
                               userInfo:[NSDictionary dictionaryWithObject:[[[self parsedBody] objectForKey:@"meta"] objectForKey:@"error_message"]
                                                                    forKey:NSLocalizedDescriptionKey]];
		default:
			_error = aError;
      if ([self parsedBody]) {
        _error = [NSError errorWithDomain:kWFIGErrorDomain
                                     code:aError.code
                                 userInfo:[NSDictionary dictionaryWithObject:[[[self parsedBody] objectForKey:@"meta"] objectForKey:@"error_message"] 
                                                                      forKey:NSLocalizedDescriptionKey]];
      }
			break;
	}
}

- (id)initFrom:(NSHTTPURLResponse *)response withBody:(NSData *)data andError:(NSError *)aError {
  if ((self = [self init])) {
    _rawBody = data;
    if(response) {
      _statusCode = [response statusCode];
      _headers = [response allHeaderFields];		
    }

    [self normalizeError:aError];
    
    // attempt to figure out *some* error if not a successful request
    if ([self isError] && ![self error]) {
      NSString *message = @"An error occurred.";
      if ([self parsedBody]) {
        if ([[self parsedBody] objectForKey:@"error_message"]) {
          message = [[self parsedBody] objectForKey:@"error_message"];
        } else if ([[self parsedBody] objectForKey:@"meta"]) {
          message = [[[self parsedBody] objectForKey:@"meta"] objectForKey:@"error_message"];
        }
      }
      _error = [NSError errorWithDomain:kWFIGErrorDomain
                                   code:_statusCode
                               userInfo:[NSDictionary dictionaryWithObject:message
                                                                    forKey:NSLocalizedDescriptionKey]];
    }
  }
	return self;
}

- (BOOL)isSuccess {
	return _statusCode >= 200 && _statusCode < 400;
}

- (BOOL)isError {
	return ![self isSuccess];
}

- (NSString*)bodyAsString {
  return [[NSString alloc] initWithData:_rawBody encoding:NSUTF8StringEncoding];
}

- (NSDictionary*) parsedBody {
  if (!_parsedBody) {
    NSError *parseError = nil;
    _parsedBody = [[WFInstagramAPI serializer] deserializeJSON:self.rawBody error:&parseError];
    if (!_parsedBody && parseError) {
      WFIGDLOG(@"ERROR parsing response body: %@", parseError);
      WFIGDLOG(@"original body was: %@", [self bodyAsString]);
    }
  }
  return _parsedBody;
}

- (NSString*) description {
  NSMutableString *d = [NSMutableString stringWithString:[super description]];
  [d appendFormat:@"{status = %d, body = %@, error = %@}", self.statusCode, [self bodyAsString], [self error]];
  return d;
}

@end
