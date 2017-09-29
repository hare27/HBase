//
//  BaseNetManager.m
//  BaseProject
//
//  Created by jiyingxin on 15/10/21.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "HApiManager.h"

#import <AFHTTPSessionManager.h>
#import <RealReachability/RealReachability.h>

NSString *const HNetworkStateChangeKey = @"HNetworkStateChangeKey";

@interface HApiManager()

@property(nonatomic,strong)AFHTTPSessionManager *manager;

@end


@implementation HApiManager

#pragma mark - 生命周期 Life Circle
+ (HApiManager *)defaultManager{
    
    static HApiManager *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj=[[self alloc]init];
    });
    return obj;
    
}

#pragma mark - 公开方法 public Methods

- (NSURLSessionDataTask *)GET:(NSString *)path parameters:(NSDictionary *)params success:(void(^)(id result))success failure:(void(^)(NSError *error))failure{
    return [self.manager GET:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (NSURLSessionDataTask *)GET:(NSString *)path parameters:(NSDictionary *)params success:(void(^)(id result))success failure:(void(^)(NSError *error))failure{
    return [[self defaultManager] GET:path parameters:params success:success failure:failure];
}

- (NSURLSessionDataTask *)Post:(NSString *)path parameters:(NSDictionary *)params success:(void(^)(id result))success failure:(void(^)(NSError *error))failure{
    return [self.manager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (NSURLSessionDataTask *)Post:(NSString *)path parameters:(NSDictionary *)params success:(void(^)(id result))success failure:(void(^)(NSError *error))failure{
    return [[self defaultManager] Post:path parameters:params success:success failure:failure];
}

/**
 将含有中文的请求路径，转换成带%号的参数，主要用于get请求
 */
- (NSString *)percentPathWithPath:(NSString *)path params:(NSDictionary *)params{
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
+ (NSString *)percentPathWithPath:(NSString *)path params:(NSDictionary *)params{
    return [[self defaultManager] percentPathWithPath:path params:params];
}

/** 网络状态*/
- (HNetworkState)networkState{
    [GLobalRealReachability startNotifier];
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    switch (status) {
        case RealStatusUnknown:return HNetworkStateUnknown;
        case RealStatusNotReachable:return HNetworkStateNotReachable;
        case RealStatusViaWiFi:return HNetworkStateWifi;
        case RealStatusViaWWAN:{
            WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
            switch (accessType) {
                case WWANType2G:return HNetworkState2G;
                case WWANType3G:return HNetworkState3G;
                case WWANType4G:return HNetworkState4G;
                case WWANTypeUnknown:return HNetworkStateWan;
            }
        };
    }
    return HNetworkStateUnknown;
}
+ (HNetworkState)networkState{
    return [self defaultManager].networkState;
}

/** 枚举转文字描述*/
- (NSString *)stringForNetworkState:(HNetworkState)state{
    switch (state) {
        case HNetworkStateUnknown:return @"未知";
        case HNetworkStateNotReachable:return @"没有网路";
        case HNetworkStateWifi:return @"wifi";
        case HNetworkState4G:return @"4G";
        case HNetworkState3G:return @"3G";
        case HNetworkState2G:return @"2G";
        case HNetworkStateWan:return @"手机";
    }
    return @"未知";
}
+ (NSString *)stringForNetworkState:(HNetworkState)state{
    return [[self defaultManager] stringForNetworkState:state];
}

/**
 监听网路变化:网络改变，会发通知出来HNetworkChangeKey userInfo:{@"oldState":@"",@"newState":@""}
 */
+ (void)startMonitorNetworkChange{
    [GLobalRealReachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange:) name:kRealReachabilityChangedNotification object:nil];
}

/**
 停止监听网路
 */
+ (void)stopMonitorNetworkChange{
    [GLobalRealReachability stopNotifier];
}

#pragma mark - private method
+ (void)networkChange:(NSNotification *)noti{
    
    RealReachability *reachability = (RealReachability *)noti.object;
    ReachabilityStatus newState = [reachability currentReachabilityStatus];
    HNetworkState newHState = 0;
    switch (newState) {
        case RealStatusUnknown:{
            newHState = HNetworkStateUnknown;
        }break;
        case RealStatusNotReachable:{
            newHState = HNetworkStateNotReachable;
        }break;
        case RealStatusViaWiFi:{
            newHState = HNetworkStateWifi;
        }break;
        case RealStatusViaWWAN:{
            WWANAccessType accessType = [reachability currentWWANtype];
            switch (accessType) {
                case WWANType2G:{
                    newHState = HNetworkState2G;
                }break;
                case WWANType3G:{
                    newHState = HNetworkState3G;
                }break;
                case WWANType4G:{
                    newHState = HNetworkState4G;
                }break;
                case WWANTypeUnknown:{
                    newHState = HNetworkStateWan;
                }break;
            }
        }break;
    }
    ReachabilityStatus oldState = [reachability previousReachabilityStatus];
    HNetworkState oldHState = 0;
    switch (oldState) {
        case RealStatusUnknown:{
            oldHState = HNetworkStateUnknown;
        }break;
        case RealStatusNotReachable:{
            oldHState = HNetworkStateNotReachable;
        }break;
        case RealStatusViaWiFi:{
            oldHState = HNetworkStateWifi;
        }break;
        case RealStatusViaWWAN:{
            WWANAccessType accessType = [reachability currentWWANtype];
            switch (accessType) {
                case WWANType2G:{
                    oldHState = HNetworkState2G;
                }break;
                case WWANType3G:{
                    oldHState = HNetworkState3G;
                }break;
                case WWANType4G:{
                    oldHState = HNetworkState4G;
                }break;
                case WWANTypeUnknown:{
                    oldHState = HNetworkStateWan;
                }break;
            }
        }break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HNetworkStateChangeKey object:nil userInfo:@{@"oldState":@(oldHState),@"newState":@(newHState)}];
}

#pragma mark - getter and stter
-(AFHTTPSessionManager *)manager{
    if (_manager == nil) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""] sessionConfiguration:config];
        _manager.responseSerializer = (AFHTTPResponseSerializer *)[AFJSONResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/javascript",@"text/plain", nil];
    }
    return _manager;
}

@end

