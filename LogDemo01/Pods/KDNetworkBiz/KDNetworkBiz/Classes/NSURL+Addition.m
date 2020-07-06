//
//  NSURL+Util.m
//  KDFoundation
//
//  Created by hour on 2018/10/15.
//

#import "NSURL+Addition.h"
#import "KDURLPathManager.h"

@implementation NSURL (Addition)

- (BOOL)isYZJDomain {
    NSURL *url = self;
    
    NSString *host = [[KDURLPathManager sharedURLPathManager] baseHost] ;
    if (host.length > 0 && [host containsString:@"www."]) {
        host = [host stringByReplacingOccurrencesOfString:@"www." withString:@""];
    }
    
    return url &&
    (
     [url.host hasSuffix:@"yunzhijia.com"]
     || [url.host hasSuffix:@"kdweibo.com"]
     || [url.host hasSuffix:@"kdweibo.cn"]
     || (host.length > 0 && [url.absoluteString containsString:host])
    );
}

@end
