//
//  HApiManager.h
//  HBase
//  封装好的网络请求基本类
//  Created by jiyingxin on 15/10/21.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HNetworkStateUnknown = 0,
    HNetworkStateNotReachable = 1,
    HNetworkStateWifi,
    HNetworkState4G,
    HNetworkState3G,
    HNetworkState2G,
    HNetworkStateWan
} HNetworkState;

extern NSString *const HNetworkStateChangeKey;

@interface HApiManager : NSObject

+(HApiManager *)defaultManager;

- (NSURLSessionDataTask *)GET:(NSString *)path parameters:(NSDictionary *)params success:(void(^)(id result))success failure:(void(^)(NSError *error))failure;
+ (NSURLSessionDataTask *)GET:(NSString *)path parameters:(NSDictionary *)params success:(void(^)(id result))success failure:(void(^)(NSError *error))failure;

- (NSURLSessionDataTask *)Post:(NSString *)path parameters:(NSDictionary *)params success:(void(^)(id result))success failure:(void(^)(NSError *error))failure;
+ (NSURLSessionDataTask *)Post:(NSString *)path parameters:(NSDictionary *)params success:(void(^)(id result))success failure:(void(^)(NSError *error))failure;

/**
 将含有中文的请求路径，转换成带%号的参数，主要用于get请求
 */
- (NSString *)percentPathWithPath:(NSString *)path params:(NSDictionary *)params;
+ (NSString *)percentPathWithPath:(NSString *)path params:(NSDictionary *)params;

/** 网络状态*/
- (HNetworkState)networkState;
+ (HNetworkState)networkState;

/** 枚举转文字描述*/
- (NSString *)stringForNetworkState:(HNetworkState)state;
+ (NSString *)stringForNetworkState:(HNetworkState)state;

/**
 监听网路变化:网络改变，会发通知出来HNetworkChangeKey userInfo:{@"oldState":@"",@"newState":@""}
 */
+ (void)startMonitorNetworkChange;
/**
 停止监听网路
 */
+ (void)stopMonitorNetworkChange;

@end

