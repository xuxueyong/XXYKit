//
//  KDResponse.m
//  KDNetwork
//
//  Created by Gil on 16/7/26.
//  Copyright © 2016年 yunzhijia. All rights reserved.
//

#import "KDResponse.h"
#import "KDError.h"

@interface KDResponse ()
@property (assign, nonatomic) BOOL isSimulated;
@property (strong, nonatomic) id response;
@property (strong, nonatomic) KDError *error;
@end

@implementation KDResponse

- (void)setTask:(NSURLSessionTask *)task
       response:(id)responseObject
          error:(NSError *)error {
    _sessionTask = task;
    _response = responseObject;
    
    NSInteger statusCode = self.statusCode;
    if (statusCode > 0 && ![self isHTTPValidResponse]) {
        //HTTP错误，比如404、500等
        self.error = [[KDError alloc] initWithHTTPStatusCode:statusCode];
    }
    else if (error) {
        //框架报出的错误，比如超时、无网络等等
        self.error = [[KDError alloc] initWithErrorCode:error.code errorMessage:error.localizedDescription];
    }
}

- (void)setSimulatedResponse:(id)responseObject {
    _isSimulated = YES;
    _response = responseObject;
}

- (NSInteger)statusCode {
    //模拟状态下，返回状态码为200
    if (self.isSimulated) {
        return 200;
    }
    
    if ([self.sessionTask.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)self.sessionTask.response;
        return response.statusCode;
    }
    
    return 0;
}

- (NSDictionary *)allHeaderFields {
    //模拟状态下，返回Header Fields为nil
    if (self.isSimulated) {
        return nil;
    }
    
    if ([self.sessionTask.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)self.sessionTask.response;
        return response.allHeaderFields;
    }
    
    return nil;
}

- (id)responseObject {
    return self.response;
}

- (NSString *)responseString {
    if ([self.response isKindOfClass:[NSData class]]) {
        return [[NSString alloc] initWithData:self.response encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (id)originalResponseObject {
    return self.response;
}

- (BOOL)isHTTPValidResponse {
    NSInteger statusCode = self.statusCode;
    return (statusCode >= 200 && statusCode <= 299);
}

- (BOOL)isValidResponse {
    return [self isHTTPValidResponse];
}

- (void)setSpecialError:(KDError *)error {
    self.error = error;
}

#pragma mark - super -

- (NSString *)description {
    return [NSString stringWithFormat:@"isValidResponse:%d\nresponseHeaders:%@\nresponseObject:%@\noriginal response:%@\nerror:%@", [self isValidResponse], self.allHeaderFields, [self responseObject], self.response, self.error];
}

@end
