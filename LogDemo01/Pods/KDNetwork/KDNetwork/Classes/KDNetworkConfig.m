//
//  KDNetworkConfig.m
//  KDNetwork
//
//  Created by Gil on 16/7/25.
//  Copyright © 2016年 yunzhijia. All rights reserved.
//

#import "KDNetworkConfig.h"

@interface KDNetworkConfig ()
@property (strong, nonatomic) NSMutableDictionary *mutableRequestHTTPHeaderField;
@end

@implementation KDNetworkConfig

+ (instancetype)sharedConfig {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _scurityPolicy = [KDSecurityPolicy defaultPolicy];
        _mutableRequestHTTPHeaderField = [NSMutableDictionary dictionary];
    }
    return self;
}

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

@end

#pragma mark - KDSecurityPolicy -
@implementation KDSecurityPolicy

+ (instancetype)defaultPolicy {
    KDSecurityPolicy *securityPolicy = [[self alloc] init];
    return securityPolicy;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.allowInvalidCertificates = NO;
        self.validatesDomainName = YES;
    }
    return self;
}

@end
