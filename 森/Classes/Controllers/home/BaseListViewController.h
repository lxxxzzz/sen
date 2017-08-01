//
//  BaseListViewController.h
//  森
//
//  Created by Lee on 2017/5/25.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBarButtonItem+Extension.h"
#import "HTTPTool.h"
#import "SegmentControl.h"
#import "OrderCell.h"
#import "Order.h"
#import "RefreshView.h"
#import <Masonry.h>
#import <SVProgressHUD.h>
#import <MJRefresh.h>
#import <MJExtension.h>

@interface BaseListViewController : UIViewController <SegmentControlDelegate, UITableViewDelegate, UITableViewDataSource, OrderCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) SegmentControl *segmentControl;
@property (nonatomic, strong) RefreshView *refreshView;

@end
