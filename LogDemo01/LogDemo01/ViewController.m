//
//  ViewController.m
//  LogDemo01
//
//  Created by Tyler Cloud on 2020/4/10.
//  Copyright © 2020 Tyler Cloud. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@import CocoaLumberjack;

@interface ViewController ()

@property (atomic, copy) NSString *testaStr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ddLogLevel = DDLogLevelVerbose;
}

- (IBAction)event_1:(id)sender {
    JHEventVerbose(@"轨迹追踪--获取权限失败");
}
- (IBAction)event_2:(id)sender {
    JHEventVerbose(@"轨迹追踪--没有权限");
}
- (IBAction)event_3:(id)sender {
    JHEventVerbose(@"轨迹追踪--数据上传成功");
}


@end
