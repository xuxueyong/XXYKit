//
//  Model_db_List.h
//  LogDemo01
//
//  Created by Tyler Cloud on 2020/7/6.
//  Copyright © 2020 Tyler Cloud. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Model_db_List : NSObject

@property (nonatomic,strong) NSMutableArray <Model_db_List *>*subPaths;

@property (nonatomic, assign) BOOL isDir;

@property (nonatomic,copy) NSString *fileName;

@property (nonatomic,copy) NSString *path;

@end

NS_ASSUME_NONNULL_END
