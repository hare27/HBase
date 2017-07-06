//
//  HBaseTableViewController.h
//  HBase
//
//  Created by hare on 2017/4/12.
//  Copyright © 2017年 hare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBaseViewModel.h"

@interface HBaseTableViewController : UITableViewController

@property(nonatomic,strong)HBaseViewModel *vm;

- (instancetype)initWithVM:(HBaseViewModel *)vm;

@end
