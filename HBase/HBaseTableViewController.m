//
//  HBaseTableViewController.m
//  HBase
//
//  Created by hare on 2017/4/12.
//  Copyright © 2017年 hare. All rights reserved.
//

#import "HBaseTableViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "NSObject+Common.h"

@interface HBaseTableViewController ()

@end

@implementation HBaseTableViewController

#pragma mark - life cycle
- (instancetype)initWithVM:(HBaseViewModel *)vm
{
    self = [super init];
    if (self) {
        _vm = vm;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
    if (self.vm) {
        
        __weak typeof(self) _weakSelf = self;
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_weakSelf.vm getNewDataSuccess:^{
                [_weakSelf.tableView.mj_header endRefreshing];
                [_weakSelf.tableView reloadData];
            } failure:^(NSError *error) {
                [_weakSelf.tableView.mj_header endRefreshing];
                [_weakSelf showErrorMsg:error.domain];
            }];
        }];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [_weakSelf.vm getMoreDataSuccess:^{
                 [_weakSelf.tableView.mj_footer endRefreshing];
                [_weakSelf hideProgress];
                [_weakSelf.tableView reloadData];
            } failure:^(NSError *error) {
                [_weakSelf.tableView.mj_footer endRefreshing];
                [_weakSelf showErrorMsg:error.domain];
            }];
        }];
        [self.tableView.mj_header beginRefreshing];
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.vm) {
        return self.vm.dataArr.count;
    }
    return 0 ;
}

#pragma mark - UITableViewDelegate
#pragma mark - CustomDelegate
#pragma mark - event response
#pragma mark - private methods
#pragma mark - getters and setters

@end
