//
//  JHEventFormatter.m
//  LogDemo01
//
//  Created by Tyler Cloud on 2020/4/10.
//  Copyright © 2020 Tyler Cloud. All rights reserved.
//


#import "AppDelegate.h"
#import "JHEventFormatter.h"

@implementation JHEventFormatter
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"E"; break;
        case DDLogFlagWarning  : logLevel = @"W"; break;
        case DDLogFlagInfo     : logLevel = @"I"; break;
        case DDLogFlagDebug    : logLevel = @"D"; break;
        default                : logLevel = @"V"; break;
    }
    if (logMessage.context == JHEVENT_CONTEXT) {
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
        NSString *time = [dateFormatter stringFromDate:date];
        return [NSString stringWithFormat:@"%@ | %@ | %@", time, logLevel, logMessage->_message];
    }
    return nil;
}
@end
