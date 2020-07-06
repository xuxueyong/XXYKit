//
//  JHEventFileManager.m
//  LogDemo01
//
//  Created by Tyler Cloud on 2020/4/10.
//  Copyright © 2020 Tyler Cloud. All rights reserved.
//

#import "JHEventFileManager.h"

@implementation JHEventFileManager

+ (NSString *)customLogsPath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@", path);
    NSString *LogesPath = [path stringByAppendingString:@"/Logs/locationTracker"];
    return LogesPath;
}

- (void)didArchiveLogFile:(NSString *)logFilePath
{
    
}

- (void)didRollAndArchiveLogFile:(NSString *)logFilePath
{
    
}

@end
