//
//  BaseNetManager.m
//  BaseProject
//
//  Created by jiyingxin on 15/10/21.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "HApiManager.h"
#import "AFHTTPSessionManager.h"
#import "HConst.h"

static AFHTTPSessionManager *_manager = nil;

@implementation HApiManager

+ (AFHTTPSessionManager *)sharedAFManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""] sessionConfiguration:config];
        _manager.responseSerializer = (AFHTTPResponseSerializer *)[AFJSONResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/javascript",@"text/plain", nil];
    });
    return _manager;
}

/**
 发送getter请求
 
 @param path 请求网址
 @param params 请求参数
 @param success 请求成功的block
 @param failure 请求失败的block
 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)GET:(NSString *)path parameters:(NSDictionary *)params success:(void(^)(id result))success failure:(void(^)(NSError *error))failure{

    HLog(@"Request Path: %@, params %@", path, params);

    return [[self sharedAFManager] GET:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 发送post请求
 
 @param path 请求网址
 @param params 请求参数
 @param success 请求成功的block
 @param failure 请求失败的block
 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)Post:(NSString *)path parameters:(NSDictionary *)params success:(void(^)(id result))success failure:(void(^)(NSError *error))failure{
    // 如果是测试状态才打印网络请求网址
    HLog(@"Request Path: %@, params %@", path, params);

    return [[self sharedAFManager] POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [task cancel];
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 将含有中文的请求路径，转换成带%号的参数，主要用于get请求
 
 @param path 请求网址
 @param params 请求参数
 @return 完整路径
 */
+ (NSString *)percentPathWithPath:(NSString *)path params:(NSDictionary *)params{
    NSMutableString *percentPath =[NSMutableString stringWithString:path];
    NSArray *keys = params.allKeys;
    NSInteger count = keys.count;
    for (int i = 0; i < count; i++) {
        if (i == 0) {
            [percentPath appendFormat:@"?%@=%@", keys[i], params[keys[i]]];
        }else{
            [percentPath appendFormat:@"&%@=%@", keys[i], params[keys[i]]];
        }
    }
    return [percentPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

/**
 监听网路变化
 
 @param result 回调block
 */
+ (void)startMonitorNetworkChange:(void(^)(BOOL has))result{
    [[self sharedAFManager].reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{     // 无连线
                result(NO);
            }break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
            case AFNetworkReachabilityStatusReachableViaWiFi: // WiFi
            case AFNetworkReachabilityStatusUnknown:          // 未知网络
            default:
                result(YES);
                break;
        }
    }];
    // 开始监听
    [[self sharedAFManager].reachabilityManager startMonitoring];
}
+ (void)stopMonitorNetworkChange{
    [[self sharedAFManager].reachabilityManager stopMonitoring];
}

@end
