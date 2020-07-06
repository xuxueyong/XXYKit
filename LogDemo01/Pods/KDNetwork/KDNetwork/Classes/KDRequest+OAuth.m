//
//  KDRequest+OAuth.m
//  KDNetwork
//
//  Created by Gil on 16/8/17.
//
//

#include <sys/time.h>
#import <objc/runtime.h>
#import <CommonCrypto/CommonHMAC.h>
#import <AFNetworking/AFNetworking.h>

#import "KDRequest+OAuth.h"
#import "KDNetworkManager.h"

@implementation KDRequest (OAuth)

- (void)signRequestWithClientIdentifier:(NSString *)clientIdentifier
                           clientSecret:(NSString *)clientSecret
                        tokenIdentifier:(NSString *)tokenIdentifier
                            tokenSecret:(NSString *)tokenSecret {
    
    NSParameterAssert(clientIdentifier);
    
	NSMutableArray *oauthParameters = [NSMutableArray array];

    [oauthParameters addObject:@{@"key" : @"oauth_version", @"value" : @"1.0"}];
	[oauthParameters addObject:@{@"key" : @"oauth_consumer_key", @"value" : clientIdentifier}];
    if (tokenIdentifier) {
        [oauthParameters addObject:@{@"key" : @"oauth_token", @"value" : tokenIdentifier}];
    }
    [oauthParameters addObject:@{@"key" : @"oauth_signature_method", @"value" : @"HMAC-SHA1"}];
    
    NSString *oauth_timestamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    [self setOauthTimestamp:oauth_timestamp];
    [oauthParameters addObject:@{@"key" : @"oauth_timestamp", @"value" : oauth_timestamp}];
    
    NSString *oauth_nonce = [NSString stringWithFormat:@"%@", [NSUUID UUID].UUIDString];
    [self setOauthNonce:oauth_nonce];
    [oauthParameters addObject:@{@"key" : @"oauth_nonce", @"value" : oauth_nonce}];

    // Construct the signature base string
    NSURL *url = [[KDNetworkManager sharedManager] urlWithRequest:self];
    NSString *baseStringURI = [self oauthBaseStringURIWithUrl:url];
    NSString *requestParameterString = [self oauthRequestParameterStringWithUrl:url oauthParameters:oauthParameters];
    NSString *baseString = [NSString stringWithFormat:@"%@&%@&%@", [self requestMethodString], [self oauthURLEncode:baseStringURI], [self oauthURLEncode:requestParameterString]];

    // Generate the signature
    NSString *signature = [self oauthGenerateHMAC_SHA1SignatureFor:baseString withClientSecret:clientSecret andTokenSecret:tokenSecret];
    [oauthParameters addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"oauth_signature", @"key", signature, @"value", nil]];

    // Set the Authorization header
    NSMutableArray *oauthHeader = [NSMutableArray array];
    for (NSDictionary *param in oauthParameters) {
        [oauthHeader addObject:[NSString stringWithFormat:@"%@=\"%@\"", [self oauthURLEncode:param[@"key"]], [self oauthURLEncode:param[@"value"]]]];
    }
    
    [self setValue:[NSString stringWithFormat:@"OAuth %@", [oauthHeader componentsJoinedByString:@", "]] forHTTPHeaderField:@"Authorization"];
}

- (NSString *)oauthBaseStringURIWithUrl:(NSURL *)url {
	NSString *hostString;

	if (([url port] == nil)
		|| ([[[url scheme] lowercaseString] isEqualToString:@"http"] && ([[url port] integerValue] == 80))
		|| ([[[url scheme] lowercaseString] isEqualToString:@"https"] && ([[url port] integerValue] == 443))) {
		hostString = [[url host] lowercaseString];
	}
	else {
		hostString = [NSString stringWithFormat:@"%@:%@", [[url host] lowercaseString], [url port]];
	}

	NSString *pathString = [[url absoluteString] substringFromIndex:[[url scheme] length] + 3];
	NSRange pathStart = [pathString rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
	NSRange pathEnd = [pathString rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"?#"]];

	if (pathEnd.location != NSNotFound) {
		pathString = [pathString substringWithRange:NSMakeRange(pathStart.location, pathEnd.location - pathStart.location)];
	}
	else {
		pathString = (pathStart.location == NSNotFound) ? @"" :[pathString substringFromIndex:pathStart.location];
	}

	return [NSString stringWithFormat:@"%@://%@%@", [[url scheme] lowercaseString], hostString, pathString];
}

- (NSString *)oauthRequestParameterStringWithUrl:(NSURL *)url oauthParameters:(NSArray *)oauthParameters {
	NSMutableArray *parameters = [NSMutableArray array];

	// Decode the parameters given in the query string, and add their encoded counterparts
	NSArray *pairs = [[url query] componentsSeparatedByString:@"&"];

	for (NSString *pair in pairs) {
		NSString *key, *value;
		NSRange separator = [pair rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];

		if (separator.location != NSNotFound) {
			key = [self oauthURLDecode:[pair substringToIndex:separator.location]];
			value = [self oauthURLDecode:[pair substringFromIndex:separator.location + 1]];
		}
		else {
            key = [self oauthURLDecode:pair];
			value = @"";
		}

        [parameters addObject:@{@"key" : [self oauthURLEncode:key], @"value" : [self oauthURLEncode:value]}];
	}

	// Add the encoded counterparts of the parameters in the OAuth header
	for (NSDictionary *param in oauthParameters) {
		NSString *key = param[@"key"];

		if ([key hasPrefix:@"oauth_"]
			&& ![key isEqualToString:@"oauth_signature"]) {
            [parameters addObject:@{@"key" : [self oauthURLEncode:key], @"value" : [self oauthURLEncode:param[@"value"]]}];
		}
	}

    //KDRequestMethodGET 方式下参数一定要签名进去
    if (self.requestMethod == KDRequestMethodGET || self.requestSerializer == KDRequestHTTPSerializer) {
        // Add encoded counterparts of any additional parameters from the body
        NSDictionary *requestParameters = self.requestParameters;
        if (requestParameters && [requestParameters isKindOfClass:[NSDictionary class]]) {
            NSString *queryString = AFQueryStringFromParameters(self.requestParameters);
            NSArray *queryParameters = [queryString componentsSeparatedByString:@"&"];
            [queryParameters enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *eachParam = [obj componentsSeparatedByString:@"="];
                NSString *key = @"";
                NSString *value = @"";
                if ([eachParam count] == 2) {
                    key = [self oauthURLEncode:[self oauthURLDecode:eachParam[0]]];
                    value = [self oauthURLEncode:[self oauthURLDecode:eachParam[1]]];
                }
                else if ([eachParam count] == 1) {
                    key = [self oauthURLEncode:[self oauthURLDecode:eachParam[0]]];
                }
                if (key.length > 0) {
                    [parameters addObject:@{@"key" : key, @"value" : value}];
                }
            }];
        }
    }

	// Sort by name and value
	[parameters sortUsingComparator:^(id obj1, id obj2) {
		NSDictionary *val1 = obj1, *val2 = obj2;
		NSComparisonResult result = [val1[@"key"] compare:val2[@"key"] options:NSLiteralSearch];

		if (result != NSOrderedSame) {
			return result;
		}

		return [val1[@"value"] compare:val2[@"value"] options:NSLiteralSearch];
	}];

	// Join components together
	NSMutableArray *parameterStrings = [NSMutableArray array];
	for (NSDictionary *parameter in parameters) {
		[parameterStrings addObject:[NSString stringWithFormat:@"%@=%@", parameter[@"key"], parameter[@"value"]]];
	}

	return [parameterStrings componentsJoinedByString:@"&"];
}

- (NSString *)requestMethodString {
    NSString *requestMethodString = @"GET";
    switch (self.requestMethod) {
        case KDRequestMethodPOST:
            requestMethodString = @"POST";
            break;
        case KDRequestMethodHEAD:
            requestMethodString = @"HEAD";
            break;
        case KDRequestMethodPUT:
            requestMethodString = @"PUT";
            break;
        case KDRequestMethodPATCH:
            requestMethodString = @"PATCH";
            break;
        case KDRequestMethodDELETE:
            requestMethodString = @"DELETE";
            break;
        default:
            break;
    }
    return requestMethodString;
}

#pragma mark - Signing algorithms -

- (NSString *)oauthGeneratePlaintextSignatureFor:(NSString *)baseString
                                withClientSecret:(NSString *)clientSecret
                                  andTokenSecret:(NSString *)tokenSecret {
    // Construct the signature key
    return [NSString stringWithFormat:@"%@&%@", clientSecret != nil ? [self oauthURLEncode:clientSecret] : @"", tokenSecret != nil ? [self oauthURLEncode:tokenSecret] : @""];
}

- (NSString *)oauthGenerateHMAC_SHA1SignatureFor:(NSString *)baseString
                                withClientSecret:(NSString *)clientSecret
                                  andTokenSecret:(NSString *)tokenSecret {
    
    NSString *key = [self oauthGeneratePlaintextSignatureFor:baseString withClientSecret:clientSecret andTokenSecret:tokenSecret];
    
    const char *keyBytes = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *baseStringBytes = [baseString cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char digestBytes[CC_SHA1_DIGEST_LENGTH];
    
    CCHmacContext ctx;
    CCHmacInit(&ctx, kCCHmacAlgSHA1, keyBytes, strlen(keyBytes));
    CCHmacUpdate(&ctx, baseStringBytes, strlen(baseStringBytes));
    CCHmacFinal(&ctx, digestBytes);
    
    NSData *digestData = [NSData dataWithBytes:digestBytes length:CC_SHA1_DIGEST_LENGTH];
    return [digestData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}


#pragma mark - URL Encode || URL Decode -

- (NSString *)oauthURLEncode:(NSString *)value {
	return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
			   (__bridge CFStringRef)value,
			   NULL,
			   (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
			   CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
}

- (NSString *)oauthURLDecode:(NSString *)value {
	return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
			   (__bridge CFStringRef)value,
			   CFSTR(""),
			   CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
}

#pragma mark - oauthTimestamp oauthNonce
- (void)setOauthTimestamp:(NSString *)oauthTimestamp {
    objc_setAssociatedObject(self, @selector(oauthTimestamp), oauthTimestamp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)oauthTimestamp {
    return objc_getAssociatedObject(self, @selector(oauthTimestamp));
}

- (void)setOauthNonce:(NSString *)oauthNonce {
    objc_setAssociatedObject(self, @selector(oauthNonce), oauthNonce, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)oauthNonce {
    return objc_getAssociatedObject(self, @selector(oauthNonce));
}

@end
