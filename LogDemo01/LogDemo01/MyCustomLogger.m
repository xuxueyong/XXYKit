//
//  MyCustomLogger.m
//  LogDemo01
//
//  Created by Tyler Cloud on 2020/4/10.
//  Copyright © 2020 Tyler Cloud. All rights reserved.
//

#import "MyCustomLogger.h"
@import CocoaLumberjack;

@implementation MyCustomLogger

- (void)logMessage:(DDLogMessage *)logMessage {
    NSString *logMsg = logMessage.message;
    
    if (self->_logFormatter)
        logMsg = [self->_logFormatter formatLogMessage:logMessage];
    if (logMsg) {
        // Write logMsg to wherever...
    }
}

@end
