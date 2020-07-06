//
//  AppDelegate.m
//  LogDemo01
//
//  Created by Tyler Cloud on 2020/4/10.
//  Copyright © 2020 Tyler Cloud. All rights reserved.
//



#import "AppDelegate.h"
#import "MyCunstomFormatter.h"
#import "JHEventLogger.h"
#import "JHEventFileManager.h"
#import "JHEventFormatter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [DDLog addLogger:[DDOSLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    JHEventFileManager *fileManager = [[JHEventFileManager alloc] init];    //自定义日志文件管理
    JHEventLogger *fileLogger = [[JHEventLogger alloc] initWithLogFileManager:fileManager]; //自定义文件Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 有效期是24小时
    fileLogger.logFileManager.maximumNumberOfLogFiles = 2;  //最多文件数量为2个
    fileLogger.logFormatter = [[JHEventFormatter alloc] init];  //日志消息格式化
    fileLogger.maximumFileSize = 1024*50;   //每个文件数量最大尺寸为50k
    fileLogger.logFileManager.logFilesDiskQuota = 200*1024;     //所有文件的尺寸最大为200k
    [DDLog addLogger:fileLogger];
    
    
    NSArray *filepaths = [fileManager sortedLogFileNames];
    NSString *path = [fileManager logsDirectory];
    NSString *header = [fileManager logFileHeader];
    NSLog(@"%@", header);
    NSLog(@"%@", path);
    NSLog(@"%@", filepaths);
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
