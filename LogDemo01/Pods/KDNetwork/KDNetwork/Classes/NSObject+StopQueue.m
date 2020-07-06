//
//  NSObject+StopQueue.m
//  Pods
//
//  Created by Gil on 2017/8/4.
//
//

#import "NSObject+StopQueue.h"
#import <objc/runtime.h>
#import "KDRequest.h"

@interface NSObject ()
@property (strong, nonatomic) NSMutableArray *requestStopQueue;
@end

@implementation NSObject (StopQueue)

- (NSMutableArray *)requestStopQueue {
    NSMutableArray *requestStopQueue = objc_getAssociatedObject(self, @selector(requestStopQueue));
    if (requestStopQueue) {
        return requestStopQueue;
    }
    
    requestStopQueue = [NSMutableArray array];
    objc_setAssociatedObject(self, @selector(requestStopQueue), requestStopQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return requestStopQueue;
}

- (void)setRequestStopQueue:(NSMutableArray *)requestStopQueue {
    objc_setAssociatedObject(self, @selector(requestStopQueue), requestStopQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addRequestToStopQueue:(KDRequest *)request {
    if ([request isKindOfClass:[KDRequest class]]) {
        @synchronized(self) {
            [self.requestStopQueue addObject:request];
        }
    }
}

- (void)stopRequestsAtStopQueue {
    if ([self.requestStopQueue count] == 0) {
        return;
    }
    
    @synchronized(self) {
        [self.requestStopQueue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            KDRequest *request = obj;
            [request stop];
        }];
        [self.requestStopQueue removeAllObjects];
    }
}


@end
