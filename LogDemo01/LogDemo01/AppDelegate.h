//
//  AppDelegate.h
//  LogDemo01
//
//  Created by Tyler Cloud on 2020/4/10.
//  Copyright © 2020 Tyler Cloud. All rights reserved.
//

#define JHEVENT_CONTEXT 100

#define JHEventVerbose(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, JHEVENT_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#import <UIKit/UIKit.h>
@import CocoaLumberjack;

static DDLogLevel ddLogLevel = DDLogLevelVerbose;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

