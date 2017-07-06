//
//  HApiManager.h
//  HBase
//  封装好的网络请求基本类
//  Created by jiyingxin on 15/10/21.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HApiManager : NSObject

/**
 发送getter请求

 @param path 请求网址
 @param params 请求参数
 @param success 请求成功的block
 @param failure 请求失败的block
 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)GET:(NSString *)path parameters:(NSDictionary *)params success:(void(^)(id result))success failure:(void(^)(NSError *error))failure;

/**
 发送post请求
 
 @param path 请求网址
 @param params 请求参数
 @param success 请求成功的block
 @param failure 请求失败的block
 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)Post:(NSString *)path parameters:(NSDictionary *)params success:(void(^)(id result))success failure:(void(^)(NSError *error))failure;

/**
 将含有中文的请求路径，转换成带%号的参数，主要用于get请求

 @param path 请求网址
 @param params 请求参数
 @return 完整路径
 */
+ (NSString *)percentPathWithPath:(NSString *)path params:(NSDictionary *)params;


/**
 监听网路变化

 @param result 回调block
 */
+ (void)startMonitorNetworkChange:(void(^)(BOOL has))result;
+ (void)stopMonitorNetworkChange;
@end
