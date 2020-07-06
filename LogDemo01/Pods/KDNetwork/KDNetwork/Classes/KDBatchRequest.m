//
//  KDBatchRequest.m
//  KDNetwork
//
//  Created by Gil on 16/7/26.
//
//

#import "KDBatchRequest.h"
#import "KDRequest.h"
#import "KDNetworkManager.h"

@class KDBatchRequest;
@interface KDBatchRequestManager : NSObject

@property (strong, nonatomic) NSMutableArray *requestArray;

+ (KDBatchRequestManager *)sharedManager;
- (void)addBatchRequest:(KDBatchRequest *)request;
- (void)removeBatchRequest:(KDBatchRequest *)request;

@end

@implementation KDBatchRequestManager

+ (instancetype)sharedManager {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)addBatchRequest:(KDBatchRequest *)request {
    @synchronized(self) {
        [self.requestArray addObject:request];
    }
}

- (void)removeBatchRequest:(KDBatchRequest *)request {
    @synchronized(self) {
        [self.requestArray removeObject:request];
    }
}

- (NSMutableArray *)requestArray {
    if (_requestArray == nil) {
        _requestArray = [NSMutableArray array];
    }
    return _requestArray;
}

@end

@interface KDBatchRequest ()
@property (strong, nonatomic) NSArray *requestArray;
@property (assign, nonatomic) NSInteger finishedCount;
@end

@implementation KDBatchRequest

- (void)dealloc {
    [self stop];
}

- (instancetype)initWithRequests:(NSArray<KDRequest *> *)requests {
    self = [super init];
    if (self) {
        for (KDRequest *request in requests) {
            if (![request isKindOfClass:[KDRequest class]]) {
                return nil;
            }
        }
        
        self.requestArray = [requests copy];
        self.finishedCount = 0;
    }
    
    return self;
}

- (void)startWithCompletionBlock:(KDBatchRequestCompletionBlock)completionBlock {
    NSAssert([self.requestArray count] > 0, @"requests count should be greater than zero");
    
    //请求已经开始
    if (self.finishedCount > 0) {
        return;
    }
    
    _completionBlock = completionBlock;
    
    [[KDBatchRequestManager sharedManager] addBatchRequest:self];
    
    __weak __typeof(self) weakSelf = self;
    for (KDRequest *request in self.requestArray) {
        KDRequestCompletionBlock success = request.successCompletionBlock;
        KDRequestCompletionBlock failure = request.failureCompletionBlock;
        [request startCompletionBlockWithSuccess:^(__kindof KDRequest * _Nonnull request) {
            if (success) {
                success(request);
            }
            [weakSelf oneRequestFinished];
        } failure:^(__kindof KDRequest * _Nonnull request) {
            if (failure) {
                failure(request);
            }
            [weakSelf oneRequestFinished];
        }];
    }
}

- (void)stop {
    for (KDRequest *request in self.requestArray) {
        [request stop];
    }
    [self clearCompletionBlock];
}

- (void)clearCompletionBlock {
    _completionBlock = nil;
    [[KDBatchRequestManager sharedManager] removeBatchRequest:self];
}

- (void)oneRequestFinished {
    self.finishedCount ++;
    if (self.finishedCount == [self.requestArray count]) {
        if (self.completionBlock) {
            self.completionBlock(self);
        }
        [self clearCompletionBlock];
    }
}

@end
