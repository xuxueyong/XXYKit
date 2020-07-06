//
//  KDRequest.m
//  KDNetwork
//
//  Created by Gil on 16/7/25.
//  Copyright © 2016年 yunzhijia. All rights reserved.
//

#import "KDRequest.h"
#import "KDNetworkPrivate.h"
#import "KDNetworkManager.h"
#import "KDResponse.h"

@interface KDRequest ()
@property (strong, nonatomic) NSString *requestId;
@property (strong, nonatomic) NSMutableDictionary *mutableRequestHTTPHeaderField;
@property (assign, nonatomic) Class resultClass;

@property (copy, nonatomic) NSMutableArray *requestInterceptors;

@property (strong, nonatomic, readwrite) NSURLSessionTask *requestTask;
@property (strong, nonatomic, readwrite, nullable) id resultModel;
@property (strong, nonatomic, readwrite, nullable) NSArray *resultModels;
@end

@implementation KDRequest

- (instancetype)init {
    return [self initWithResultClass:nil];
}

- (instancetype)initWithResultClass:(Class)resultClass {
    self = [super init];
    if (self) {
        if (resultClass) {
            self.resultClass = resultClass;
        }
        self.mutableRequestHTTPHeaderField = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setCompletionBlockWithSuccess:(KDRequestCompletionBlock)success
                              failure:(KDRequestCompletionBlock)failure {
    _successCompletionBlock = success;
    _failureCompletionBlock = failure;
}

- (void)startCompletionBlockWithSuccess:(KDRequestCompletionBlock)success
                                failure:(KDRequestCompletionBlock)failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)start {
    [self interceptorAtRequestWillStart];
    [[KDNetworkManager sharedManager] addRequest:self];
}

- (void)stop {
    [self interceptorAtRequestWillStop];
    [[KDNetworkManager sharedManager] cancelRequest:self];
    [self interceptorAtRequestDidStop];
}

- (void)clearCompletionBlock {
    _successCompletionBlock = nil;
    _failureCompletionBlock = nil;
}

- (void)addInterceptor:(id<KDRequestInterceptor>)interceptor {
    if (interceptor) {
        [self.requestInterceptors addObject:interceptor];
    }
}

#pragma mark http header field

- (NSDictionary *)requestHTTPHeaderField {
    return [self.mutableRequestHTTPHeaderField copy];
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [self.mutableRequestHTTPHeaderField setValue:value forKey:field];
}

- (NSString *)valueForHTTPHeaderField:(NSString *)field {
    return [self.mutableRequestHTTPHeaderField valueForKey:field];
}

- (void)removeHTTPHeaderField:(NSString *)field {
    [self.mutableRequestHTTPHeaderField removeObjectForKey:field];
}

#pragma mark - subclass override -

- (nullable NSString *)baseUrl {
    return nil;
}

- (nullable NSString *)requestUrl {
    return nil;
}

- (nullable id)requestParameters {
    return nil;
}

- (NSTimeInterval)requestTimeoutInterval {
    return 60.0;
}

- (KDRequestMethod)requestMethod {
    return KDRequestMethodGET;
}

- (KDRequestSerializer)requestSerializer {
    return KDRequestHTTPSerializer;
}

- (KDResponseSerializer)responseSerializer {
    return KDResponseHTTPSerializer;
}

- (BOOL)isSimulated {
    return NO;
}

- (id)simulatedResponse {
    return nil;
}

#pragma mark - readonly method -

- (NSString *)requestId {
    if (_requestId == nil) {
        _requestId = [NSUUID UUID].UUIDString;
    }
    return _requestId;
}

- (NSArray *)interceptors {
    return [self.requestInterceptors copy];
}

- (NSMutableArray *)requestInterceptors {
    if (_requestInterceptors == nil) {
        _requestInterceptors = [NSMutableArray array];
    }
    return _requestInterceptors;
}

#pragma mark - super -

- (NSUInteger)hash {
    return [self.requestId hash];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"requestId:%@\nrequestUrl:%@\nrequestParameters:%@", self.requestId, [[KDNetworkManager sharedManager] urlWithRequest:self], self.requestParameters];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[KDRequest class]]) {
        return NO;
    }
    return [self.requestId isEqualToString:((KDRequest *)object).requestId];
}

@end
