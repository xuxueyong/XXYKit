//
//  KDURLPathManager.m
//  kdweibo
//
//  Created by Gil on 15/1/21.
//  Copyright (c) 2015年 www.kingdee.com. All rights reserved.
//

#import "KDURLPathManager.h"

//正式环境
static NSString *const KDURL = @"https://www.yunzhijia.com/";
static NSString *const KDURL_IMAGE = @"https://static.yunzhijia.com/";

//KDTest
static NSString *const KDURL_TEST = @"https://kdtest.kdweibo.cn/";

//Dev
static NSString *const KDURL_Dev = @"http://dev.kdweibo.cn/";

//DevTest
static NSString *const KDURL_DevTest = @"http://devtest.kdweibo.cn/";

//JD Red Packet
static NSString *const KDURL_RedPacket = @"http://jd-dev01.kdweibo.cn/";
NSString *const KDURLChangeNotification = @"KDURLChangeNotification";

//当前环境类型
#define kUrlType @"kUrlType"

#define kCustomHttpUrl @"kCustomHttpUrl"
#define kCustomWsUrl @"kCustomWsUrl"

@interface KDURLPathManager () {
    NSString *_initBaseUrl;
    NSString *_initImgBaseUrl;
    NSString *_baseHost;
}

@property (strong, nonatomic) NSString *serverBaseUrl;

@end

@implementation KDURLPathManager

+ (instancetype)sharedURLPathManager
{
    static dispatch_once_t pred;
    static KDURLPathManager *instance = nil;
    dispatch_once(&pred, ^{
        instance = [[KDURLPathManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _initBaseUrl = KDURL;
        _initImgBaseUrl = KDURL_IMAGE;
    }
    return self;
}

- (void)setupBaseUrl:(NSString * _Nonnull)baseUrl imgBaseUrl:(NSString * _Nonnull)imgBaseUrl {
    _initBaseUrl = baseUrl;
    _initImgBaseUrl = imgBaseUrl;
}

- (NSString *)serverBaseUrl {
    
	if (_serverBaseUrl == nil) {
        switch ([self urlType]) {
            case KDURLTypeProduction:
                _serverBaseUrl = _initBaseUrl;
                break;
                
            case KDURLTypeKDTest:
                _serverBaseUrl = KDURL_TEST;
                break;
                
            case KDURLTypeDev:
                _serverBaseUrl = KDURL_Dev;
                break;
                
            case KDURLTypeDevTest:
                _serverBaseUrl = KDURL_DevTest;
                break;
                
//            case KDURLTypeRedPacket:
//                _serverBaseUrl = KDURL_RedPacket;
//                break;
                
            case KDURLTypeCustom:
                _serverBaseUrl = [[NSUserDefaults standardUserDefaults] stringForKey:kCustomHttpUrl];;
                break;
                
            default:
                _serverBaseUrl = KDURL;
                break;
        }
	}

	return _serverBaseUrl;
}

- (nonnull NSString *)baseUrl {
    return self.serverBaseUrl;
}

- (nonnull NSString *)baseHost {
    if (_baseHost == nil) {
        _baseHost = @"";
    
        NSURL *url = [NSURL URLWithString:self.serverBaseUrl];
        if (url.host.length > 0) {
            _baseHost = url.host;
        }
    }
    
    return _baseHost;
}

- (nonnull NSString *)baseUrlWithoutTLS {
	NSString *baseUrl = [self baseUrl];
	if ([baseUrl hasPrefix:@"https"]) {
		return [baseUrl stringByReplacingOccurrencesOfString:@"https" withString:@"http" options:NSAnchoredSearch range:NSMakeRange(0, baseUrl.length)];
	}
	return baseUrl;
}

- (NSString *)imageBaseUrl {
    NSString *imageBaseUrl = nil;
    
    switch ([self urlType]) {
        case KDURLTypeProduction: {
            imageBaseUrl = _initImgBaseUrl;
        }
            break;
        default: {
            imageBaseUrl = [self baseUrl];
        }
            break;
    }
    
    return imageBaseUrl;
}

- (KDURLType)urlType {
	int type = (int)[[NSUserDefaults standardUserDefaults] integerForKey:kUrlType];
	if (type == 0) {
		//设置默认值
		type = KDURLTypeProduction;
		[[NSUserDefaults standardUserDefaults] setInteger:type forKey:kUrlType];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}

	return type;
}

- (void)setUrlType:(KDURLType)urlType {
	if (urlType != [self urlType]) {
        _serverBaseUrl = nil;
	}

	[[NSUserDefaults standardUserDefaults] setInteger:urlType forKey:kUrlType];
	[[NSUserDefaults standardUserDefaults] synchronize];

	[[NSNotificationCenter defaultCenter] postNotificationName:KDURLChangeNotification object:nil];
}

- (void)setCustomHttpUrl:(NSString *)httpUrl wsUrl:(NSString *)wsUrl {
    if (httpUrl && wsUrl) {
        [[NSUserDefaults standardUserDefaults] setObject:httpUrl forKey:kCustomHttpUrl];
        [[NSUserDefaults standardUserDefaults] setObject:wsUrl forKey:kCustomWsUrl];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)clearCustomUrl {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCustomHttpUrl];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCustomWsUrl];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)urlTypeText {
    NSString *text = nil;
    switch ([self urlType]) {
        case KDURLTypeKDTest:
            text = @"KDTest/";
            break;
            
        case KDURLTypeDev:
            text = @"Dev/";
            break;
            
        case KDURLTypeDevTest:
            text = @"DevTest/";
            break;
            
//        case KDURLTypeRedPacket:
//            text = @"RedPacket/";
//            break;
            
        case KDURLTypeCustom:
            text = @"Custom/";
            break;
            
        default:
            break;
    }
    return text;
}

- (NSString *)urlTypeDesc {
    if (self.urlType == 0) {
        self.urlType = KDURLTypeProduction;
    }
    if (self.urlType > [[self urlTypeDescList] count]) {
        self.urlType = KDURLTypeProduction;
    }
    return [self urlTypeDescList][self.urlType - 1];
}

- (NSArray *)urlTypeDescList {
    return @[
             @"正式环境",
             @"测试环境(KDTest)",
             @"开发环境(Dev)",
             @"开发测试环境(DevTest)",
//             @"红包环境(RedPacket)",
             @"自定义环境(Custom)"];
}

- (KDURLType)urlTypeWithDesc:(NSString *)desc {
    if ([desc isEqualToString:@"测试环境(KDTest)"]) {
        return KDURLTypeKDTest;
    }
    else if ([desc isEqualToString:@"开发测试环境(DevTest)"]) {
        return KDURLTypeDevTest;
    }
    else if ([desc isEqualToString:@"开发环境(Dev)"]) {
        return KDURLTypeDev;
    }
//    else if ([desc isEqualToString:@"红包环境(RedPacket)"]) {
//        return KDURLTypeRedPacket;
//    }
    else if ([desc isEqualToString:@"自定义环境(Custom)"]) {
        return KDURLTypeCustom;
    }
    return KDURLTypeProduction;
}
@end
