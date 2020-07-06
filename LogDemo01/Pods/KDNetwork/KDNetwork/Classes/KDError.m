//
//  KDError.m
//  KDNetwork
//
//  Created by Gil on 2016/12/23.
//
//

#import "KDError.h"

NSInteger const KDDataParseErrorCode = -1;

@implementation KDError

- (instancetype)initWithHTTPStatusCode:(NSInteger)httpStatusCode {
    self = [super init];
    if (self) {
        self.errorCode = httpStatusCode;
        self.errorMessage = [self errorMessageWithHTTPStatusCode:httpStatusCode];
    }
    return self;
}

- (instancetype)initWithErrorCode:(NSInteger)errorCode
                     errorMessage:(nullable NSString *)errorMessage {
    self = [super init];
    if (self) {
        self.errorCode = errorCode;
        self.errorMessage = errorMessage;
        if (errorCode == KDDataParseErrorCode && !errorMessage) {
            self.errorMessage = @"数据加载失败，请检查网络后重试。";
        }
    }
    return self;
}

- (NSString *)errorMessageWithHTTPStatusCode:(NSInteger)httpStatusCode {
    NSString *errorMessage = nil;
    if (httpStatusCode != 0) {
        switch (httpStatusCode) {
                
            case 400:
            case 403:
            case 404:
            case 406:
                errorMessage = @"数据加载失败，请检查网络后重试。";
                break;
                
            default:
                errorMessage = @"服务器异常，请稍后重试。";
                break;
        }
    }
    return errorMessage;
}

#pragma mark - super -

- (NSString *)description {
    return [NSString stringWithFormat:@"errorCode:%ld errorMessage:%@", (long)self.errorCode, self.errorMessage];
}

@end
