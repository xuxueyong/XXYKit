//
//  NSDate+Server.m
//  Pods
//
//  Created by Gil on 2017/8/1.
//
//

#import "NSDate+Server.h"
#import "KDNetworkPrivate.h"

@implementation NSDate (Server)
+ (instancetype)serverDate {
    return [[KDNetworkManager sharedManager] serverDate];
}
+ (NSTimeInterval)serverDateDelta {
    return [[KDNetworkManager sharedManager] serverDateDelta];
}
@end
