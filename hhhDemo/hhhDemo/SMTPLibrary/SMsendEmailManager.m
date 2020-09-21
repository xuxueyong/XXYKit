//
//  SMsendEmailManager.m
//  hhhDemo
//
//  Created by Tyler Cloud on 2020/7/7.
//  Copyright © 2020 Tyler Cloud. All rights reserved.
//

#import "SMsendEmailManager.h"

@implementation SMsendEmailManager

+ (instancetype)shared {
    static SMsendEmailManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}



@end
