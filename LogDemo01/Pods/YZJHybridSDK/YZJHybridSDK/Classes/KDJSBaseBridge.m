//
//  KDJSBaseBridge.m
//  FBSnapshotTestCase
//
//  Created by hour on 2019/1/22.
//

#import "KDJSBaseBridge.h"

const NSString * kJSBSuccess = @"success";
const NSString * kJSBErrorMessage = @"error";
const NSString * kJSBErrorCode = @"errorCode";
const NSString * kJSBData = @"data";

@implementation KDJSBaseBridge

- (NSString *)bridgeName {
    NSAssert(YES, @"需要自己实现");
    return @"";
}

- (void)handle:(NSString *)funcName callbackID:(NSInteger)callbackID args:(NSDictionary<NSString *, id> *)args {
    NSAssert(YES, @"需要自己实现");
}

@end
