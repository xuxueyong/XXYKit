//
//  JHEventLogger.m
//  LogDemo01
//
//  Created by Tyler Cloud on 2020/4/10.
//  Copyright © 2020 Tyler Cloud. All rights reserved.
//

#import "JHEventLogger.h"

@implementation JHEventLogger

- (void)logMessage:(DDLogMessage *)logMessage {
    [super logMessage:logMessage];
}
- (void)willLogMessage
{
    [super willLogMessage];
}

- (void)didLogMessage
{
    [super didLogMessage];
}

@end
