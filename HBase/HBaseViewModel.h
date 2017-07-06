//
//  BaseViewModel.h
//  BaseProject
//
//  Created by jiyingxin on 15/10/21.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HBaseViewModelDelegate <NSObject>

@optional
//获取更多
- (void)getMoreDataSuccess:(void(^)())success failure:(void(^)(NSError *error))failure;
//刷新
- (void)getNewDataSuccess:(void(^)())success failure:(void(^)(NSError *error))failure;
//获取数据
- (void)getDataSuccess:(void(^)())success failure:(void(^)(NSError *error))failure;

@end

@interface HBaseViewModel : NSObject<HBaseViewModelDelegate>

@property(nonatomic,strong) NSMutableArray *dataArr;
@property(nonatomic,strong) NSURLSessionDataTask *dataTask;
- (void)cancelTask;  //取消任务
- (void)suspendTask; //暂停任务
- (void)resumeTask;  //继续任务

@end
