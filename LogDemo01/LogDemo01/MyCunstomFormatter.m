//
//  MyCunstomFormatter.m
//  LogDemo01
//
//  Created by Tyler Cloud on 2020/4/10.
//  Copyright © 2020 Tyler Cloud. All rights reserved.
//

#import "MyCunstomFormatter.h"

@implementation MyCunstomFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"❤️"; break;
        case DDLogFlagWarning  : logLevel = @"💛"; break;
        case DDLogFlagInfo     : logLevel = @"💚"; break;
        case DDLogFlagDebug    : logLevel = @"💙"; break;
        default                : logLevel = @"💜"; break;
    }
    
    return [NSString stringWithFormat:@"%@ | %@", logLevel, logMessage->_message];
}

@end
