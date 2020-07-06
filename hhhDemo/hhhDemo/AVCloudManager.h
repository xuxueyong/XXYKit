//
//  AVCloudManager.h
//  hhhDemo
//
//  Created by Tyler Cloud on 2020/7/6.
//  Copyright © 2020 Tyler Cloud. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^EnableBlock)(BOOL isEnable);

@interface AVCloudManager : NSObject

+ (void)checkisLogEnableWithName:(NSString *)name comlpletion:(EnableBlock)comlpletion;

@end

NS_ASSUME_NONNULL_END
