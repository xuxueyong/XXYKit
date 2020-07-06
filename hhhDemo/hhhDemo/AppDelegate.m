//
//  AppDelegate.m
//  hhhDemo
//
//  Created by Tyler Cloud on 2020/7/2.
//  Copyright © 2020 Tyler Cloud. All rights reserved.
//

#import "AppDelegate.h"
@import AVOSCloud;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [AVOSCloud setApplicationId:@"lrmwlbxx4mo85jfmj31d10zt09a1u47hevb83174cdtkmm33"
          clientKey:@"7a276l2273s90jgoljsyfswmmisg4q8ybn4gpb0xbcul6xlo"
    serverURLString:@"https://lrmwlbxx.lc-cn-n1-shared.com"];
    
    
    // 基础查询
    AVQuery *query = [AVQuery queryWithClassName:@"LogEnable"];
//    [query whereKey:@"names" equalTo:@"xueyong"];
    [query whereKey:@"names" containsString:@"xueyong"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *students, NSError *error) {
        // students 是包含满足条件的 Student 对象的数组
    }];

    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
