//
//  KDBusinessRequest.m
//  kdweibo
//
//  Created by Gil on 2016/12/25.
//  Copyright © 2016年 www.kingdee.com. All rights reserved.
//

#import "KDBusinessRequest.h"
#import "KDBusinessResponse.h"
#import <objc/runtime.h>
#import "KDNetworkManager.h"
#import "KDBusinessRequestConfig.h"
#import "KDRequest+OAuth.h"
#import "KDURLPathManager.h"
#import "NSURL+Addition.h"

#import "KDSignUtil.h"

#if __has_include("KDFoundation.h")
#import "KDFoundation.h"
#import "KDLoggerHelper.h"
#import "KDClock.h"
#else
@import KDFoundation;
@import YZJLog;
#endif

@interface KDBusinessLogInterceptor : NSObject <KDRequestInterceptor>
@end

/**
 HTTP Header需要传入的数据类型
 
 - KDBusinessRequestHeaderTypeNone: 什么都不传
 - KDBusinessRequestHeaderTypeOpenToken: 需要传openToken（默认）
 - KDBusinessRequestHeaderTypeSignature: 需要传appKey和signature
 - KDBusinessRequestHeaderTypeOAuth: 需要做OAuth 1.0签名
 - KDBusinessRequestHeaderTypeAPPSign 接口需要上传 team id
 */
typedef NS_ENUM (NSInteger, KDBusinessRequestHeaderType) {
    KDBusinessRequestHeaderTypeNone = 1 << 0,
    KDBusinessRequestHeaderTypeOpenToken  = 1 << 1,
    KDBusinessRequestHeaderTypeSignature  = 1 << 2,
    KDBusinessRequestHeaderTypeOAuth  = 1 << 3,
    KDBusinessRequestHeaderTypeAPPSign = 1 << 4,
    KDBusinessRequestHeaderTypeGateway = 1 << 5
};

@implementation KDBusinessRequest

- (instancetype)init {
    return [self initWithResultClass:nil];
}

- (instancetype)initWithResultClass:(Class)resultClass {
    self = [super initWithResultClass:resultClass];
    if (self) {
        self.response = [[KDBusinessResponse alloc] init];
        
        KDBusinessLogInterceptor *interceptor = [[KDBusinessLogInterceptor alloc] init];
        [self addInterceptor:interceptor];
    }
    return self;
}

- (NSTimeInterval)requestTimeoutInterval {
    return 30.0;
}

- (KDRequestMethod)requestMethod {
    return KDRequestMethodPOST;
}

- (KDRequestSerializer)requestSerializer {
    return KDRequestJSONSerializer;
}

- (KDResponseSerializer)responseSerializer {
    return KDResponseJSONSerializer;
}

static NSDictionary *_headerTypes = nil;
- (NSDictionary *)requestHTTPHeaderField {
    //各自服务对应的Header头类型
    /*
     1、默认为KDBusinessRequestHeaderTypeOpenToken，不需要配置，服务如下：
        xuntong - IM服务
        inforecommend - 好友推荐
        3gol - 企业参数和部分应用接口
        invite - 二维码邀请
        docrest - 文档
        adware - 广告点击反馈
     2、KDBusinessRequestHeaderTypeOpenToken + KDBusinessRequestHeaderTypeSignature：
        openaccess - open系统
        openauth
     3、KDBusinessRequestHeaderTypeOpenToken + KDBusinessRequestHeaderTypeOAuth：
        openapi - 新待办、标记、轻应用ticket等服务
     4、KDBusinessRequestHeaderTypeNone：
        version-control - 新版本检测
        websecurity - 网址安全性检测
        attendancelight - 签到异常反馈
        lightapp - 微信分享记录
        maprest - 地址搜索
     */
    if (_headerTypes == nil) {
        _headerTypes = @{
                         @"gateway" : @(KDBusinessRequestHeaderTypeGateway),
                         @"openaccess" : @(KDBusinessRequestHeaderTypeOpenToken | KDBusinessRequestHeaderTypeSignature),
                         @"openauth" : @(KDBusinessRequestHeaderTypeOpenToken | KDBusinessRequestHeaderTypeSignature),
                         @"openapi" : @(KDBusinessRequestHeaderTypeOpenToken | KDBusinessRequestHeaderTypeOAuth),
                         @"snsapi" : @(KDBusinessRequestHeaderTypeOAuth),
                         @"attendance-signapi" : @(KDBusinessRequestHeaderTypeOpenToken | KDBusinessRequestHeaderTypeOAuth | KDBusinessRequestHeaderTypeAPPSign),
                         @"attendance-core" : @(KDBusinessRequestHeaderTypeOpenToken | KDBusinessRequestHeaderTypeOAuth),
                         @"version-control" : @(KDBusinessRequestHeaderTypeNone),
                         @"websecurity" : @(KDBusinessRequestHeaderTypeNone),
                         @"lightapp" : @(KDBusinessRequestHeaderTypeNone),
                         @"maprest" : @(KDBusinessRequestHeaderTypeNone)
                         };
    }
    
    NSURL *url = [[KDNetworkManager sharedManager] urlWithRequest:self];
    
    KDBusinessRequestHeaderType types = KDBusinessRequestHeaderTypeNone;
    if ([url isYZJDomain]) {
        types = KDBusinessRequestHeaderTypeOpenToken;
    }
    
    NSArray *pathComponents = url.pathComponents;
    if ([pathComponents count] > 2) {
        NSString *serverName = pathComponents[1];
        if (serverName && _headerTypes[serverName]) {
            types = [_headerTypes[serverName] integerValue];
        }
    }
    
    if (types & KDBusinessRequestHeaderTypeGateway) {
        NSString *openToken = [KDBusinessRequestConfig sharedConfig].userOpenToken;
        if (openToken.length > 0) {
            [self setValue:openToken forHTTPHeaderField:@"openToken"];
        }
    }
    
    if (types & KDBusinessRequestHeaderTypeOpenToken) {
        NSString *openToken = [KDBusinessRequestConfig sharedConfig].userOpenToken;
        if (openToken.length > 0) {
            [self setValue:openToken forHTTPHeaderField:@"openToken"];
        }
    }
    
    if (types & KDBusinessRequestHeaderTypeSignature) {
        [self setValue:@"eHVudG9uZw" forHTTPHeaderField:@"appkey"];
        [self setValue:@"Ld3dK-9E7r7HKQMZ9j7m1QOp5zCYqjWKH4xupXTaFMDl2UlJzdeQVYsWhb37scAVK-NCC6wW1A9aOYYNjzoQt-yGvup5xmOBR1SsSp690FN8aX4gUwCpxiarbesQ7Z7m9UL1fi7QUWSPBvFuD4twJNi75dOAZW287UWQHijsSqo" forHTTPHeaderField:@"signature"];
    }
    
    if (types & KDBusinessRequestHeaderTypeOAuth) {
        [self signRequestWithClientIdentifier:[KDBusinessRequestConfig sharedConfig].kdAppOauthKey
                                 clientSecret:[KDBusinessRequestConfig sharedConfig].kdAppOauthSecret
                              tokenIdentifier:[KDBusinessRequestConfig sharedConfig].userOauthToken
                                  tokenSecret:[KDBusinessRequestConfig sharedConfig].userOauthTokenSecret];
    }
    
    if (types & KDBusinessRequestHeaderTypeAPPSign) {
        [self setValue:NSBundle.mainBundle.bundleIdentifier forHTTPHeaderField: @"app-bundle-id"];
        [self setValue:KDSignUtil.codeSign->basicAppSig(self) forHTTPHeaderField: @"app-signature"];
//        [self setValue:KDSignUtil.codeSign->bundleTeamIdentifier() forHTTPHeaderField: @"bundleTeamIdentifier"];
//        [self setValue:self.oauthTimestamp forHTTPHeaderField: @"oauthTimestamp"];
//        [self setValue:self.oauthNonce forHTTPHeaderField: @"oauthNonce"];
    }
    
    return [super requestHTTPHeaderField];
}

@end

@interface KDRequest (Time)
@property (assign, nonatomic) NSTimeInterval startTimeInterval;

- (int)requestContentLength;
- (int)responseContentLength;

@end

@implementation KDRequest (Time)
- (NSTimeInterval)startTimeInterval {
    NSNumber *startTimeInterval = objc_getAssociatedObject(self, @selector(startTimeInterval));
    if (startTimeInterval) {
        return startTimeInterval.doubleValue;
    }
    return 0;
}

- (void)setStartTimeInterval:(NSTimeInterval)startTimeInterval {
    objc_setAssociatedObject(self, @selector(startTimeInterval), @(startTimeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (int)requestContentLength {
    int length = 0;
    if (self.requestTask) {
        NSDictionary *headers = self.requestTask.currentRequest.allHTTPHeaderFields;
        id requestContentLength = headers[@"content-length"];
        if (!requestContentLength) {
            requestContentLength = headers[@"Content-Length"];
        }
        if (requestContentLength) {
            length = [requestContentLength intValue];
        }
    }
    return length;
}

- (int)responseContentLength {
    int length = 0;
    if (self.response) {
        NSDictionary *headers = self.response.allHeaderFields;
        id responseContentLength = headers[@"content-length"];
        if (!responseContentLength) {
            responseContentLength = headers[@"Content-Length"];
        }
        if (responseContentLength) {
            length = [responseContentLength intValue];
        }
    }
    return length;
}

@end

@implementation KDBusinessLogInterceptor

static dispatch_queue_t interceptorQueue = nil;
- (instancetype)init {
    self = [super init];
    if (self) {
        if (!interceptorQueue) {
            interceptorQueue = dispatch_queue_create("com.kingdee.yzj.KDBusinessLogInterceptor", DISPATCH_QUEUE_SERIAL);
        }
    }
    return self;
}

- (void)requestWillStart:(KDRequest *)request {
    if (KDBusinessRequestConfig.sharedConfig.networkLogEnable) {
        dispatch_async(interceptorQueue, ^{
            request.startTimeInterval = [KDClock sharedClock].absoluteTime;//[NSDate timeIntervalSinceReferenceDate];
        });
    }
}

- (void)requestDidFinished:(KDRequest *)request {
    if (KDBusinessRequestConfig.sharedConfig.networkLogEnable) {
        dispatch_async(interceptorQueue, ^{
            long cost = ([KDClock sharedClock].absoluteTime - request.startTimeInterval) * 1000;
            // 在这里崩溃，找曲钉看原因。
            NSAssert(cost >= 0, @"");
            
//            NSString *commonLogContent = [KDLoggerHelper commonLogContent];
            int networkType = 7;
            NSString *requestId = request.requestId;
            NSString *url = [[KDNetworkManager sharedManager] urlWithRequest:request].absoluteString;
            int statusCode = (int)request.response.statusCode;
            int requestLength = [request requestContentLength];
            int responseLength = [request responseContentLength];
            //模块 通用部分 链接类型-短链接 短连接唯一ID 短连接URL HTTP成功响应代码 请求数据包大小 耗时 响应数据包大小
//            KDLogInfo(@"%@ %@ %d %@ %@ %d %d %ld %d", KDNetworkLogModule, commonLogContent, networkType, requestId, url, statusCode, requestLength, cost, responseLength);
            
            [KDLoggerHelper
             create:KDNetworkLogModule]
            .appendInt(networkType)
            .appendStr(requestId)
            .appendStr(url)
            .appendInt(statusCode)
            .appendInt(requestLength)
            .appendLong(cost)
            .appendInt(responseLength)
            .logInfo();
        });
    }
}
@end
