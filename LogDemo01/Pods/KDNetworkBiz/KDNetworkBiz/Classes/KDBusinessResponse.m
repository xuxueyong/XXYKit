//
//  KDBusinessResponse.m
//  kdweibo
//
//  Created by Gil on 2016/12/25.
//  Copyright © 2016年 www.kingdee.com. All rights reserved.
//

#import "KDBusinessResponse.h"
#import "KDError.h"

#if __has_include("KDFoundation.h")
#import "KDFoundation.h"
#else
@import KDFoundation;
#endif


@interface KDBusinessResultModel : NSObject
@property (assign, nonatomic) BOOL success;
@property (assign, nonatomic) NSInteger errorCode;
@property (strong, nonatomic) NSString *error;
@property (strong, nonatomic) NSDictionary *data;
@end

@implementation KDBusinessResultModel
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.success = [dict boolForKey:@"success"];
        self.errorCode = [dict integerForKey:@"errorCode"];
        NSString *errorStr = kd_safeString(dict[@"error"]);
        NSString *errorMsg = kd_safeString(dict[@"errorMessage"]);
        self.error = errorStr.length > 0 ? errorStr : (errorMsg.length > 0 ? errorMsg : @"服务器异常，请稍后重试。") ;
        self.data = [dict objectNotNSNullForKey:@"data"];
    }
    return self;
}
@end

@interface KDBusinessResponse ()
@property (strong, nonatomic) KDBusinessResultModel *result;
@end

@implementation KDBusinessResponse

- (void)setTask:(NSURLSessionTask *)task
       response:(id)responseObject
          error:(NSError *)error {
    [super setTask:task response:responseObject error:error];
    
    //防止一个request多次调用时，result复用问题
    if (_result) {
        _result = nil;
    }
    
    //业务错误
    if ([super isValidResponse] && self.result && !self.result.success) {
        [self setSpecialError:[[KDError alloc] initWithErrorCode:self.result.errorCode errorMessage:self.result.error]];
    }
}

- (KDBusinessResultModel *)result {
    if (_result == nil) {
        NSDictionary *responseObject = [super responseObject];
        //responseObject必须是NSDictionary，并且包含success标签
        if ([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject allKeys] containsObject:@"success"]) {
            _result = [[KDBusinessResultModel alloc] initWithDictionary:responseObject];
        }
    }
    return _result;
}

- (id)responseObject {
    //业务层接口直接返回data里的值
    if (self.result) {
        return self.result.data;
    }
    return [super responseObject];
}

- (BOOL)isValidResponse {
    BOOL isSuperValidResponse = [super isValidResponse];
    
    if (self.result) {
        return isSuperValidResponse && self.result.success;
    }
    return isSuperValidResponse;
}

@end
