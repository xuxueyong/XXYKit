//
//  KDNetworkManager.m
//  KDNetwork
//
//  Created by Gil on 16/7/25.
//  Copyright © 2016年 yunzhijia. All rights reserved.
//

#import "KDNetworkManager.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

#if __has_include(<JSONModel/JSONModel.h>)
#import <JSONModel/JSONModel.h>
#else
#import "JSONModel.h"
#endif

#import "KDNetworkConfig.h"
#import "KDNetworkPrivate.h"
#import "KDError.h"
#import "KDBatchRequest.h"

@interface KDNetworkManager ()
@property (strong, nonatomic) NSMutableDictionary *requests;

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) AFJSONResponseSerializer *jsonResponseSerializer;

@property (strong, nonatomic) KDNetworkConfig *config;
@property (strong, nonatomic) NSIndexSet *allStatusCodes;
@property (strong, nonatomic) dispatch_queue_t processingQueue;
@property (strong, nonatomic) dispatch_queue_t dateFormatterQueue;
@property (strong, nonatomic) NSLock *lock;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDate *clockSyncTime;
@property (strong, nonatomic) NSDate *serverClockTime;
@property (assign, nonatomic) NSTimeInterval serverClockTimeDelta;
@end

@implementation KDNetworkManager

+ (instancetype)sharedManager {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.config = [KDNetworkConfig sharedConfig];
        
        self.allStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
        self.processingQueue = dispatch_queue_create("com.kingdee.yzj.kdnetwork.process", DISPATCH_QUEUE_CONCURRENT);
        self.dateFormatterQueue = dispatch_queue_create("com.kingdee.yzj.kdnetwork.dateformat", DISPATCH_QUEUE_SERIAL);
        self.lock = [[NSLock alloc] init];
        self.dateFormatter = [self generateDateFormatter];
    }
    return self;
}

- (NSString *)baseUrlStringWithRequest:(KDRequest *)request {
    
    NSParameterAssert(request);
    
    NSString *url = request.requestUrl;
    NSURL *tempURL = [NSURL URLWithString:url];
    //如果requestUrl是有效的URL，则直接返回requestUrl
    if (tempURL && tempURL.host && tempURL.scheme) {
        return url;
    }
    
    NSString *baseUrl;
    if (request.baseUrl.length > 0) {
        baseUrl = request.baseUrl;
    }
    else {
        baseUrl = self.config.baseUrl;
    }
    NSParameterAssert(baseUrl);
    
    return baseUrl;
}

- (NSURL *)urlWithRequest:(KDRequest *)request{
    NSString *baseUrl = [self baseUrlStringWithRequest:request];
    NSURL *url = [NSURL URLWithString:baseUrl];
    if (baseUrl.length > 0 && ![baseUrl hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""];
    }
    
    NSURL *requestUrl = url;
    if (request.requestUrl) {
        requestUrl = [NSURL URLWithString:request.requestUrl relativeToURL:url];
    }
    return requestUrl;
}
 
#pragma mark - request -

- (void)addRequest:(KDRequest *)request {
    NSParameterAssert(request);
    
    #ifdef DEBUG
    //返回本地构造的数据
    if ([request isSimulated]) {
        [self handleSimulatedDataWithRequest:request];
        return;
    }
    #endif
    
    NSError * __autoreleasing error = nil;
    request.requestTask = [self sessionTaskForRequest:request error:&error];;
    
    if (error) {
        [self requestDidFailWithRequest:request error:error];
        return;
    }
    
    NSAssert(request.requestTask != nil, @"requestTask should not be nil");
    
    // Set request task priority
    if ([request.requestTask respondsToSelector:@selector(priority)]) {
        switch (request.requestPriority) {
            case KDRequestPriorityHigh:
                request.requestTask.priority = NSURLSessionTaskPriorityHigh;
                break;
            case KDRequestPriorityLow:
                request.requestTask.priority = NSURLSessionTaskPriorityLow;
                break;
            case KDRequestPriorityDefault:
                /*!!fall through*/
            default:
                request.requestTask.priority = NSURLSessionTaskPriorityDefault;
                break;
        }
    }
    
    [self addRequestToRecord:request];
    [request.requestTask resume];
}

- (void)cancelRequest:(KDRequest *)request {
    NSParameterAssert(request);
    
    #ifdef DEBUG
    //模拟请求，do nothing
    if ([request isSimulated]) {
        return;
    }
    #endif
    
    [request.requestTask cancel];
    [self removeRequestFromRecord:request];
    [request clearCompletionBlock];
}

- (void)cancelAllRequests {
    if ([self.requests count] == 0) {
        return;
    }
    
    [self.lock lock];
    NSArray *allKeys = [self.requests allKeys];
    [self.lock unlock];
    
    if (allKeys && allKeys.count > 0) {
        NSArray *copiedKeys = [allKeys copy];
        for (NSString *key in copiedKeys) {
            
            [self.lock lock];
            KDRequest *request = self.requests[key];
            [self.lock unlock];
            
            // We are using non-recursive lock.
            // Do not lock `stop`, otherwise deadlock may occur.
            [request stop];
        }
    }
}

#pragma mark - private method -

- (NSURLSessionTask *)sessionTaskForRequest:(KDRequest *)request error:(NSError * _Nullable __autoreleasing *)error {
    
    NSString *requestUrl = [self urlWithRequest:request].absoluteString;
    id requestParameters = request.requestParameters;
    if (!requestParameters && request.requestSerializer == KDRequestJSONSerializer) {
        requestParameters = @{};
    }
    
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerWithRequest:request];
    
    NSURLSessionTask *dataTask;
    switch ([request requestMethod]) {
        case KDRequestMethodGET:
        {
            if (request.downloadPath) {
                if (request.progressBlock) {
                    void (^downloadProgressBlock)(NSProgress *downloadProgress)
                    = ^(NSProgress *downloadProgress) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            request.progressBlock(downloadProgress);
                        });
                    };
                    dataTask = [self dataTaskWithDownloadPath:request.downloadPath request:request progress:downloadProgressBlock requestSerializer:requestSerializer URLString:requestUrl parameters:requestParameters error:error];
                }
                else {
                    dataTask = [self dataTaskWithDownloadPath:request.downloadPath request:request progress:nil requestSerializer:requestSerializer URLString:requestUrl parameters:requestParameters error:error];
                }
                
            }
            else {
                dataTask = [self dataTaskWithHTTPMethod:@"GET" request:request requestSerializer:requestSerializer URLString:requestUrl parameters:requestParameters error:error];
            }
        }
            break;
        case KDRequestMethodPOST:
        {
            if (request.downloadPath) {
                if (request.progressBlock) {
                    void (^downloadProgressBlock)(NSProgress *downloadProgress)
                    = ^(NSProgress *downloadProgress) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            request.progressBlock(downloadProgress);
                        });
                    };
                    dataTask = [self dataTaskWithDownloadPath:request.downloadPath request:request progress:downloadProgressBlock requestSerializer:requestSerializer URLString:requestUrl parameters:requestParameters error:error];
                }
                else {
                    dataTask = [self dataTaskWithDownloadPath:request.downloadPath request:request progress:nil requestSerializer:requestSerializer URLString:requestUrl parameters:requestParameters error:error];
                }
                
            }
            else {
                if (request.progressBlock) {
                    void (^uploadProgressBlock)(NSProgress *uploadProgress)
                    = ^(NSProgress *uploadProgress) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            request.progressBlock(uploadProgress);
                        });
                    };
                    dataTask = [self dataTaskWithHTTPMethod:@"POST" request:request requestSerializer:requestSerializer URLString:requestUrl parameters:requestParameters constructingBodyWithBlock:request.constructingBodyBlock progress:uploadProgressBlock error:error];
                }
                else {
                    dataTask = [self dataTaskWithHTTPMethod:@"POST" request:request requestSerializer:requestSerializer URLString:requestUrl parameters:requestParameters constructingBodyWithBlock:request.constructingBodyBlock progress:nil error:error];
                }
            }
        }
            break;
        case KDRequestMethodDELETE:
        {
            dataTask = [self dataTaskWithHTTPMethod:@"DELETE" request:request requestSerializer:requestSerializer URLString:requestUrl parameters:requestParameters error:error];
        }
            break;
        case KDRequestMethodPATCH:
        {
            dataTask = [self dataTaskWithHTTPMethod:@"PATCH" request:request requestSerializer:requestSerializer URLString:requestUrl parameters:requestParameters error:error];
        }
            break;
        case KDRequestMethodPUT:
        {
            dataTask = [self dataTaskWithHTTPMethod:@"PUT" request:request requestSerializer:requestSerializer URLString:requestUrl parameters:requestParameters error:error];
        }
            break;
        case KDRequestMethodHEAD:
        {
            dataTask = [self dataTaskWithHTTPMethod:@"HEAD" request:request requestSerializer:requestSerializer URLString:requestUrl parameters:requestParameters error:error];
        }
            break;
        default:
        {
            dataTask = [self dataTaskWithHTTPMethod:@"GET" request:request requestSerializer:requestSerializer URLString:requestUrl parameters:requestParameters error:error];
        }
            break;
    }
    
    return dataTask;
}

- (AFHTTPRequestSerializer *)requestSerializerWithRequest:(KDRequest *)request {
    
    NSParameterAssert(request);
    
    AFHTTPRequestSerializer *requestSerializer = (request.requestSerializer == KDRequestJSONSerializer) ? [AFJSONRequestSerializer serializer] : [AFHTTPRequestSerializer serializer];
    
    //设置超时时间
    requestSerializer.timeoutInterval = request.requestTimeoutInterval;
    
    //添加http header
    if ([self.config requestHTTPHeaderField].count > 0) {
        [[self.config requestHTTPHeaderField] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    if (request.requestHTTPHeaderField.count > 0) {
        [request.requestHTTPHeaderField enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    if (request.requestId) {
        [requestSerializer setValue:request.requestId forHTTPHeaderField:@"X-Request-Id"];
    }
    
    return requestSerializer;
}

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                         request:(KDRequest *)request
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                           error:(NSError * _Nullable __autoreleasing *)error {
    return [self dataTaskWithHTTPMethod:method request:request requestSerializer:requestSerializer URLString:URLString parameters:parameters constructingBodyWithBlock:nil progress:nil error:error];
}

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                         request:(KDRequest *)request
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                       constructingBodyWithBlock:(KDRequestConstructingBlock)constructingBlock
                                        progress:(KDRequestProgressBlock)uploadProgressBlock
                                           error:(NSError * _Nullable __autoreleasing *)error {
    NSMutableURLRequest *urlRequest = nil;
    
    if (constructingBlock) {
        void (^block)(id <AFMultipartFormData> formData)
        = ^(id <AFMultipartFormData> formData) {
            constructingBlock((id<KDMultipartFormData>)formData);
        };
        urlRequest = [requestSerializer multipartFormRequestWithMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block error:error];
    } else {
        urlRequest = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:error];
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:urlRequest uploadProgress:uploadProgressBlock downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable _error) {
        [self handleRequestResult:dataTask responseObject:responseObject error:_error];
    }];
    return dataTask;
}

- (NSURLSessionDownloadTask *)dataTaskWithDownloadPath:(NSString *)downloadPath
                                               request:(KDRequest *)request
                                              progress:(KDRequestProgressBlock)downloadProgressBlock
                                     requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                             URLString:(NSString *)URLString
                                            parameters:(id)parameters
                                                 error:(NSError * _Nullable __autoreleasing *)error {
    // add parameters to URL;
    NSString *method = (request.requestMethod == KDRequestMethodGET) ? @"GET" : @"POST";
    NSMutableURLRequest *urlRequest = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:error];
    
    NSString *downloadTargetPath;
    BOOL isDirectory;
    if(![[NSFileManager defaultManager] fileExistsAtPath:downloadPath isDirectory:&isDirectory]) {
        isDirectory = NO;
    }
    // If targetPath is a directory, use the file name we got from the urlRequest.
    // Make sure downloadTargetPath is always a file, not directory.
    if (isDirectory) {
        NSString *fileName = [urlRequest.URL lastPathComponent];
        downloadTargetPath = [NSString pathWithComponents:@[downloadPath, fileName]];
    } else {
        downloadTargetPath = downloadPath;
    }
    
    // AFN use `moveItemAtURL` to move downloaded file to target path,
    // this method aborts the move attempt if a file already exist at the path.
    // So we remove the exist file before we start the download task.
    // https://github.com/AFNetworking/AFNetworking/issues/3775
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadTargetPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:downloadTargetPath error:nil];
    }
    
    BOOL resumeDataFileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self incompleteDownloadTempPathForDownloadPath:downloadPath].path];
    NSData *data = [NSData dataWithContentsOfURL:[self incompleteDownloadTempPathForDownloadPath:downloadPath]];
    BOOL resumeDataIsValid = [KDNetworkUtils validateResumeData:data];
    
    BOOL canBeResumed = resumeDataFileExists && resumeDataIsValid;
    BOOL resumeSucceeded = NO;
    __block NSURLSessionDownloadTask *downloadTask = nil;
    // Try to resume with resumeData.
    // Even though we try to validate the resumeData, this may still fail and raise excecption.
    if (canBeResumed) {
        @try {
            downloadTask = [self.sessionManager downloadTaskWithResumeData:data progress:downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
            } completionHandler:
                            ^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                [self handleRequestResult:downloadTask responseObject:filePath error:error];
                            }];
            resumeSucceeded = YES;
        } @catch (NSException *exception) {
            resumeSucceeded = NO;
        }
    }
    if (!resumeSucceeded) {
        downloadTask = [self.sessionManager downloadTaskWithRequest:urlRequest progress:downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
        } completionHandler:
                        ^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                            [self handleRequestResult:downloadTask responseObject:filePath error:error];
                        }];
    }
    return downloadTask;
}

- (void)addRequestToRecord:(KDRequest *)request {
    [self.lock lock];
    self.requests[@(request.requestTask.taskIdentifier)] = request;
    [self.lock unlock];
}

- (void)removeRequestFromRecord:(KDRequest *)request {
    [self.lock lock];
    [self.requests removeObjectForKey:@(request.requestTask.taskIdentifier)];
    [self.lock unlock];
}

#pragma mark 返回值处理

- (void)handleRequestResult:(NSURLSessionTask *)task
             responseObject:(id)responseObject
                      error:(NSError *)error {
    
    [self.lock lock];
    KDRequest *request = self.requests[@(task.taskIdentifier)];
    [self.lock unlock];
    
    if (!request) {
        return;
    }
    
    NSError * __autoreleasing serializationError = nil;
    
    NSError *requestError = nil;
    BOOL succeed = YES;
    
    id response = responseObject;
    if ([response isKindOfClass:[NSData class]]) {
        switch (request.responseSerializer) {
            case KDResponseHTTPSerializer:
                // Default serializer. Do nothing.
                break;
            case KDResponseJSONSerializer:
                response = [self.jsonResponseSerializer responseObjectForResponse:task.response data:response error:&serializationError];
                break;
        }
    }
    
    if (error) {
        succeed = NO;
        requestError = error;
    } else if (serializationError) {
        succeed = NO;
        requestError = serializationError;
    }
    
    if (succeed) {
        [self requestDidSucceedWithRequest:request response:response];
    } else {
        [self requestDidFailWithRequest:request error:requestError];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeRequestFromRecord:request];
        [request clearCompletionBlock];
    });
    
    //时钟同步
    [self calculateServerTime:request];
}

- (void)requestDidSucceedWithRequest:(KDRequest *)request
                            response:(id)responseObject {
    if (!request.response) {
        request.response = [[KDResponse alloc] init];
    }
    [request.response setTask:request.requestTask response:responseObject error:nil];
    
    [self handleSuccWithRequest:request];
}

- (void)requestDidFailWithRequest:(KDRequest *)request error:(NSError *)error {
    
    // Save incomplete download data.
    NSData *incompleteDownloadData = error.userInfo[NSURLSessionDownloadTaskResumeData];
    if (incompleteDownloadData) {
        [incompleteDownloadData writeToURL:[self incompleteDownloadTempPathForDownloadPath:request.downloadPath] atomically:YES];
    }
    
    [self handleFailureWithRequest:request error:error];
}

- (void)handleSimulatedDataWithRequest:(KDRequest *)request {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(self.processingQueue, ^{
        if (!request.response) {
            request.response = [[KDResponse alloc] init];
        }
        [request.response setSimulatedResponse:[request simulatedResponse]];
        
        [weakSelf handleSuccWithRequest:request];
    });
}

- (void)handleSuccWithRequest:(KDRequest *)request {
    if ([request.response isValidResponse]) {
        
        BOOL isParseSuccess = YES;
        if (request.resultClass && [request.resultClass isSubclassOfClass:[JSONModel class]]) {
            isParseSuccess = [self parseResult:request];
        }
        
        if (isParseSuccess) {
            [self successCallback:request];
        }
        else {
            [self failureCallback:request];
        }
    }
    else {
        [self failureCallback:request];
    }
}

- (void)handleFailureWithRequest:(KDRequest *)request
                           error:(NSError *)error {
    if (!request.response) {
        request.response = [[KDResponse alloc] init];
    }
    [request.response setTask:request.requestTask response:nil error:error];
    
    [self failureCallback:request];
}

- (BOOL)parseResult:(KDRequest *)request {
    
    BOOL isParseSuccess = NO;
    
    __block NSError *error = nil;
    id responseObject = request.response.responseObject;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        JSONModel *result = [[request.resultClass alloc] initWithDictionary:responseObject error:&error];
        if (result && !error) {
            request.resultModel = result;
            isParseSuccess = YES;
        }
    }
    else if ([responseObject isKindOfClass:[NSData class]]) {
        JSONModel *result = [[request.resultClass alloc] initWithData:responseObject error:&error];
        if (result && !error) {
            request.resultModel = result;
            isParseSuccess = YES;
        }
    }
    else if ([responseObject isKindOfClass:[NSString class]]) {
        JSONModel *result = [[request.resultClass alloc] initWithString:responseObject error:&error];
        if (result && !error) {
            request.resultModel = result;
            isParseSuccess = YES;
        }
    }
    else if ([responseObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *resultModels = [NSMutableArray array];
        [responseObject enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                JSONModel *result = [[request.resultClass alloc] initWithDictionary:obj error:&error];
                if (result && !error) {
                    [resultModels addObject:result];
                }
            }
            if (error) {
                *stop = YES;
            }
        }];
        if (!error) {
            request.resultModels = resultModels;
            isParseSuccess = YES;
        }
    }
    
    if (!isParseSuccess) {
        [request.response setSpecialError:[[KDError alloc] initWithErrorCode:KDDataParseErrorCode errorMessage:nil]];
    }
    
    return isParseSuccess;
}

- (void)successCallback:(KDRequest *)request {
    dispatch_async(dispatch_get_main_queue(), ^{
        [request interceptorAtRequestDidFinished];
        if (request.successCompletionBlock) {
            request.successCompletionBlock(request);
        }
    });
}

- (void)failureCallback:(KDRequest *)request {
    dispatch_async(dispatch_get_main_queue(), ^{
        [request interceptorAtRequestDidFinished];
        if (request.failureCompletionBlock) {
            request.failureCompletionBlock(request);
        }
    });
}

#pragma mark Resumable Download

- (NSString *)incompleteDownloadTempCacheFolder {
    NSFileManager *fileManager = [NSFileManager new];
    static NSString *cacheFolder;
    
    if (!cacheFolder) {
        NSString *cacheDir = NSTemporaryDirectory();
        cacheFolder = [cacheDir stringByAppendingPathComponent:@"Incomplete"];
    }
    
    NSError *error = nil;
    if(![fileManager createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
        cacheFolder = nil;
    }
    return cacheFolder;
}

- (NSURL *)incompleteDownloadTempPathForDownloadPath:(NSString *)downloadPath {
    NSString *tempPath = nil;
    NSString *md5URLString = [KDNetworkUtils md5StringFromString:downloadPath];
    tempPath = [[self incompleteDownloadTempCacheFolder] stringByAppendingPathComponent:md5URLString];
    return [NSURL fileURLWithPath:tempPath];
}

#pragma mark 服务器时间

- (NSDateFormatter *)generateDateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss zzz";
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    return dateFormatter;
}

- (void)calculateServerTime:(KDRequest *)request {
    
    __weak __typeof(self) weakSelf = self;
    dispatch_async(self.dateFormatterQueue, ^{
        //10秒同步一次
        NSDate *nowDate = [NSDate date];
        if (!weakSelf.clockSyncTime || fabs([nowDate timeIntervalSinceDate:weakSelf.clockSyncTime]) > 10) {
            
            weakSelf.clockSyncTime = nowDate;
            
            NSDictionary *responseHeaders = request.response.allHeaderFields;
            NSString *dateString = responseHeaders[@"Date"];
            
            NSDate *serverDate = [weakSelf.dateFormatter dateFromString:dateString];
            
            weakSelf.serverClockTime = serverDate;
            weakSelf.serverClockTimeDelta = [serverDate timeIntervalSinceDate:weakSelf.clockSyncTime];
        }
    });
}

- (NSDate *)serverDate {
    if (self.serverClockTime) {
        return self.serverClockTime;
    }
    return [NSDate date];
}

- (NSTimeInterval)serverDateDelta {
    return self.serverClockTimeDelta;
}

#pragma mark - getter or setter -

- (NSMutableDictionary *)requests {
    if (_requests == nil) {
        _requests = [NSMutableDictionary dictionary];
    }
    return _requests;
}

- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        sessionConfig.HTTPMaximumConnectionsPerHost = 4;
        
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sessionConfig];
        
        AFSecurityPolicy *policy = [AFSecurityPolicy defaultPolicy];
        policy.allowInvalidCertificates = self.config.scurityPolicy.allowInvalidCertificates;
        policy.validatesDomainName = self.config.scurityPolicy.validatesDomainName;
        _sessionManager.securityPolicy = policy;
        
        _sessionManager.completionQueue = self.processingQueue;

        //sessionManager只使用AFHTTPResponseSerializer
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableStatusCodes = self.allStatusCodes;
    }
    return _sessionManager;
}

- (AFJSONResponseSerializer *)jsonResponseSerializer {
    if (_jsonResponseSerializer == nil) {
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        _jsonResponseSerializer.acceptableStatusCodes = self.allStatusCodes;
    }
    return _jsonResponseSerializer;
}

- (void)setJsonResponseSerializerSupportHtml:(BOOL)jsonResponseSerializerSupportHtml {
    if (jsonResponseSerializerSupportHtml) {
        self.jsonResponseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    } else {
        self.jsonResponseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
    }
}

@end
