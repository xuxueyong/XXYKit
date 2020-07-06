//
//  KDBusinessRequestConfig.m
//  AFNetworking
//
//  Created by hour on 2018/9/3.
//

#import "KDBusinessRequestConfig.h"

@implementation KDBusinessRequestConfig

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
        _networkLogEnable = NO;
//        _scurityPolicy = [KDSecurityPolicy defaultPolicy];
//        _mutableRequestHTTPHeaderField = [NSMutableDictionary dictionary];
    }
    return self;
}

@end
