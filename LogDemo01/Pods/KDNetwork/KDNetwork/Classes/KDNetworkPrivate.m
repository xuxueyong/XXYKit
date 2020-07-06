//
//  KDNetworkPrivate.m
//  Pods
//
//  Created by Gil on 2017/8/3.
//
//

#import "KDNetworkPrivate.h"
#import <CommonCrypto/CommonDigest.h>

@implementation KDNetworkUtils

+ (BOOL)validateResumeData:(NSData *)data {
    // From http://stackoverflow.com/a/22137510/3562486
    if (!data || [data length] < 1) return NO;
    
    NSError *error;
    NSDictionary *resumeDictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:&error];
    if (!resumeDictionary || error) return NO;
    
    // Before iOS 9 & Mac OS X 10.11
#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED < 90000)\
|| (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED < 101100)
    NSString *localFilePath = [resumeDictionary objectForKey:@"NSURLSessionResumeInfoLocalPath"];
    if ([localFilePath length] < 1) return NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:localFilePath];
#endif
    // After iOS 9 we can not actually detects if the cache file exists. This plist file has a somehow
    // complicated structue. Besides, the plist structure is different between iOS 9 and iOS 10.
    // We can only assume that the plist being successfully parsed means the resume data is valid.
    return YES;
}

+ (NSString *)md5StringFromString:(NSString *)string {
    NSParameterAssert(string != nil && [string length] > 0);
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

@end

@implementation KDRequest (Interceptor)

- (void)interceptorAtRequestWillStart {
    for (id<KDRequestInterceptor> interceptor in self.interceptors) {
        if ([interceptor respondsToSelector:@selector(requestWillStart:)]) {
            [interceptor requestWillStart:self];
        }
    }
}

- (void)interceptorAtRequestWillStop {
    for (id<KDRequestInterceptor> interceptor in self.interceptors) {
        if ([interceptor respondsToSelector:@selector(requestWillStop:)]) {
            [interceptor requestWillStop:self];
        }
    }
}

- (void)interceptorAtRequestDidStop {
    for (id<KDRequestInterceptor> interceptor in self.interceptors) {
        if ([interceptor respondsToSelector:@selector(requestDidStop:)]) {
            [interceptor requestDidStop:self];
        }
    }
}

- (void)interceptorAtRequestDidFinished {
    for (id<KDRequestInterceptor> interceptor in self.interceptors) {
        if ([interceptor respondsToSelector:@selector(requestDidFinished:)]) {
            [interceptor requestDidFinished:self];
        }
    }
}

@end
