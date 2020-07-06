//
//  KDJSONModel.m
//  KDNetwork
//
//  Created by Gil on 2016/12/29.
//  Copyright © 2016年 Gil. All rights reserved.
//

#import "KDJSONModel.h"

@implementation KDJSONModel

//默认所有的参数都是可选的，如果没有则解析为nil
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (NSString *)kd_jsonStringFromModels:(NSArray *)array {
    
    NSMutableString *jsonStr = [[NSMutableString alloc] initWithString:@"["];
    for(JSONModel *model in array){
        [jsonStr appendString:model.toJSONString];
        [jsonStr appendString:@","];
    }
    
    NSRange range = NSMakeRange(jsonStr.length - 1, 1);
    [jsonStr replaceCharactersInRange:range withString:@"]"];
    
    return jsonStr;
}

@end
