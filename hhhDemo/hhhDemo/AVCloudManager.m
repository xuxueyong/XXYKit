//
//  AVCloudManager.m
//  hhhDemo
//
//  Created by Tyler Cloud on 2020/7/6.
//  Copyright © 2020 Tyler Cloud. All rights reserved.
//

#import "AVCloudManager.h"
@import AVOSCloud;

@implementation AVCloudManager

+ (void)checkisLogEnableWithName:(NSString *)name comlpletion:(EnableBlock)comlpletion {
    // 基础查询
        AVQuery *query = [AVQuery queryWithClassName:@"LogEnable"];
    //    [query whereKey:@"names" equalTo:@"xueyong"];
        [query whereKey:@"names" containsString:name];
        [query findObjectsInBackgroundWithBlock:^(NSArray *students, NSError *error) {
            // students 是包含满足条件的 Student 对象的数组
            if (students.count > 0) {
                comlpletion(YES);
            } else {
                comlpletion(NO);
            }
        }];
}

@end
