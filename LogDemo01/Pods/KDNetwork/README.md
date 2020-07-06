## KDNetwork

KDNetwork是基于[AFNetworking](https://github.com/AFNetworking/AFNetworking)封装的一套网络库，支持iOS7以上。

KDNetwork同时依赖[JSONModel](https://github.com/jsonmodel/jsonmodel)，可以将返回的值转成自定义Model，该Model必须继承自JSONModel。

2018.9.3 

使用方式：

    // 引用之前KDNetwork库里的代码
    pod 'KDNetwork'
    
    // 在原来基础上，增加了business相关的类
    pod 'KDNetwork'
    pod 'KDNetwork/Business'

新增加了Business模块，从主项目中拿了KDBusinessRequest、KDBusinessResponse、KDJSONModel、KDURLPathManager4个类，启动App或者切换用户、切换圈子时需要调用方法重新设置参数（下面的参数原来是通过BOSConfig和其他类传过来的，现在为了解耦，当某个参数改变后，需要手动重置）。

    /**
    // 是否打印log (release需要设置为打印)
    [KDBusinessRequestConfig sharedConfig].networkLogEnable = NO;
    [KDBusinessRequestConfig sharedConfig].userOpenToken = [BOSConfig sharedConfig].user.token;
    [KDBusinessRequestConfig sharedConfig].userOauthToken = [BOSConfig sharedConfig].user.oauthToken;
    [KDBusinessRequestConfig sharedConfig].userOauthTokenSecret = [BOSConfig sharedConfig].user.oauthTokenSecret;
    
    [KDBusinessRequestConfig sharedConfig].kdAppOauthKey = KD_APP_OAUTH_KEY;
    [KDBusinessRequestConfig sharedConfig].kdAppOauthSecret = KD_APP_OAUTH_SECRET;
    */
    
## 待完成功能
*   断点续传
*   统一设置参数
*   失败重试机制

## 样例

获取代码，在Example目录下执行`pod install`

打开Example目录中的`KDNetwork.xcworkspace`，运行程序

## 安装

KDNetwork is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "KDNetwork"
```

## 用法

### 统一设置项
* 设置所有请求的baseUrl
    * 如果request自己设置了baseUrl，以request的优先
    * 如果request的requestUrl是完整的接口地址，忽略baseUrl
* 设置所有请求的HTTP Header字段
* 设置安全策略

```objc
KDNetworkConfig *networkConfig = [KDNetworkConfig sharedConfig];

//设置baseUrl
networkConfig.baseUrl = @"https://api.thinkpage.cn/v3/weather";

//给所有请求默认加上Header字段
networkConfig.requestHTTPHeaderField = @{@"token" : @"your token",@"deviceId":@"your deviceId"};

//安全策略（如果是DEBUG模式，则允许非认证的证书，不检测域名，方便调试）
#ifdef DEBUG
networkConfig.scurityPolicy.allowInvalidCertificates = YES;
networkConfig.scurityPolicy.validatesDomainName = NO;
#endif
```

### 简单请求

```objc
//KDWeatherRequest类声明
#import <KDNetwork/KDNetwork.h>
@interface KDWeatherRequest : KDRequest
@end

//KDWeatherRequest类实现
#import "KDWeatherRequest.h"
#import "KDWeatherAPI.h"

@implementation KDWeatherRequest

- (KDResponseSerializer)responseSerializer {
    return KDResponseJSONSerializer;
}

- (NSString *)requestUrl {
    return @"https://api.thinkpage.cn/v3/weather/now.json";
}

- (id)requestParameters {
    return @{@"key": [[KDWeatherAPI sharedWeatherAPI] apiKey],
             @"location": @"shenzhen",
             @"language": @"zh-Hans",
             @"unit" : @"c"};
}
@end
```

```objc
//方法调用
- (void)testGetWeather {
    KDWeatherRequest *request = [[KDWeatherRequest alloc] init];
    [request startCompletionBlockWithSuccess:^(__kindof KDRequest * _Nonnull request) {
        NSLog(@"response is: %@", request.response.responseObject);
    } failure:^(__kindof KDRequest * _Nonnull request) {
        NSLog(@"Expectation Failed with error: %@", request.response.error);
    }];
}
```

### 批量请求

```objc
- (void)batchRequest {
    KDWeatherRequest *request1 = [[KDWeatherRequest alloc] init];
    KDWeatherRequest *request2 = [[KDWeatherRequest alloc] init];
    KDWeatherRequest *request3 = [[KDWeatherRequest alloc] init];
    
    KDBatchRequest *batchRequest = [[KDBatchRequest alloc] initWithRequests:@[request1, request2, request3]];
    [batchRequest startWithCompletionBlock:^(KDBatchRequest *batchRequest) {
        NSLog(@"batchRequest finish");
    }];
}
```

### 自动解析自定义Model

```objc
#import <JSONModel/JSONModel.h>

@protocol KDResultsModel;
@class KDLocationModel, KDNowModel;

//自定义Model，继承自JSONModel
@interface KDWeatherModel : JSONModel
@property (strong, nonatomic) NSArray <KDResultsModel> *results;
@end

@interface KDResultsModel : JSONModel
@property (strong, nonatomic) NSString *last_update;
@property (strong, nonatomic) KDNowModel *now;
@property (strong, nonatomic) KDLocationModel *location;
@end


@interface KDLocationModel : JSONModel
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *path;
@end

@interface KDNowModel : JSONModel
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *temperature;
@end
```

```objc
//方法调用
- (void)testGetWeatherModel {
    KDWeatherRequest *request = [[KDWeatherRequest alloc] initWithResultClass:[KDWeatherModel class]];
    [request startCompletionBlockWithSuccess:^(__kindof KDRequest * _Nonnull request) {
        NSLog(@"response is: %@", request.resultModel);
    } failure:^(__kindof KDRequest * _Nonnull request) {
        NSLog(@"Expectation Failed with error: %@", request.response.error);
    }];
}
```

### 模拟接口数据

```objc
//KDWeatherSimulatedRequest类声明
#import "KDWeatherRequest.h"

@interface KDWeatherSimulatedRequest : KDWeatherRequest

@end

//KDWeatherSimulatedRequest类实现
#import "KDWeatherSimulatedRequest.h"

@implementation KDWeatherSimulatedRequest

- (BOOL)isSimulated {
    return YES;
}

- (id)simulatedResponse {
    return @{@"results" : @[@{@"location" : @{@"id" : @"WS10730EM8EV",
                                              @"name" : @"深圳",
                                              @"country" : @"CN",
                                              @"path" : @"深圳,深圳,广东,中国",
                                              @"timezone" : @"Asia/Shanghai",
                                              @"timezone_offset" : @"+08:00"},
                              @"now" : @{@"text" : @"多云",
                                         @"code" : @"4",
                                         @"temperature" : @"19"},
                              @"last_update" : @"2016-12-30T15:05:00+08:00"}]};
}

@end
```

## Author

Gil, hua_guan@kingdee.com

## License

KDNetwork is available under the MIT license. See the LICENSE file for more info.
