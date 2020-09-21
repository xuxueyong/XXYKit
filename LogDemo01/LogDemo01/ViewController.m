//
//  ViewController.m
//  LogDemo01
//
//  Created by Tyler Cloud on 2020/4/10.
//  Copyright © 2020 Tyler Cloud. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Model_db_List.h"
#import "JHEventFileManager.h"

@import CocoaLumberjack;

@interface ViewController ()

@property (atomic, copy) NSString *testaStr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ddLogLevel = DDLogLevelVerbose;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSMutableArray *pathes = [self filePathArray:[JHEventFileManager customLogsPath]];
    NSLog(@"获取的文件路径:%@", pathes);
}

- (IBAction)event_1:(id)sender {
    JHEventVerbose(@"轨迹追踪--获取权限失败");
}
- (IBAction)event_2:(id)sender {
    JHEventVerbose(@"轨迹追踪--没有权限");
}
- (IBAction)event_3:(id)sender {
    NSString *typeStr = [NSString stringWithFormat:@"%ld", 1];
    JHEventVerbose(@"开始发起单次定位，类型：%@", typeStr);
}

- (NSMutableArray *)filePathArray:(NSString *)directoryPath
{
    NSMutableArray *mFilePathArray = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *array = [fileManager contentsOfDirectoryAtPath:directoryPath error:nil];
    __block BOOL isDir = YES;
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        Model_db_List *model = [Model_db_List new];;
        
        NSString *path = [directoryPath stringByAppendingPathComponent:obj];
        if ([fileManager fileExistsAtPath:path isDirectory:&isDir]){

            model = [Model_db_List new];
            model.isDir = isDir;
            if (isDir) {
                model.subPaths = [self filePathArray:path];
            }
        }
        if (model) {
            model.fileName = obj;
            model.path = path;
            [mFilePathArray addObject:model];
        }
    }];
    return mFilePathArray;
}


@end
