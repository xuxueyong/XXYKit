//
//  KDJSBaseBridge.h
//  FBSnapshotTestCase
//
//  Created by hour on 2019/1/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * kJSBSuccess;
extern NSString * kJSBErrorMessage;
extern NSString * kJSBErrorCode;
extern NSString * kJSBData;

@protocol KDJSBridgeDelegate <NSObject>

- (UIViewController *)baseVC;

- (void)returnResult:(NSInteger)callbackID args:(NSDictionary<NSString *, id> *)args;
- (void)returnRefreshResult:(NSInteger)callbackID args:(NSDictionary<NSString *, id> *)args;

- (void)triggerEvent:(NSString * _Nullable)name args:(NSDictionary * _Nullable)args;

- (void)returnJSBridgeNotFound:(NSInteger)callbackID;

@end

@interface KDJSBaseBridge : NSObject

- (NSString *)bridgeName;

- (void)handle:(NSString *)funcName callbackID:(NSInteger)callbackID args:(NSDictionary<NSString *, id> *)args;

@property (nonatomic, weak) id<KDJSBridgeDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
