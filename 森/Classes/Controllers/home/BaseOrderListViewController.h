//
//  BaseOrderListViewController.h
//  森
//
//  Created by Lee on 2017/6/20.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIBarButtonItem+Extension.h"
#import "HTTPTool.h"
#import "OrderCell.h"
#import "Order.h"
#import "RefreshView.h"
#import <Masonry.h>
#import <SVProgressHUD.h>
#import <MJRefresh.h>
#import <MJExtension.h>

@class BaseOrderListViewController;

@protocol BaseOrderListViewControllerDelegate <NSObject>

@optional
- (void)baseOrderListViewController:(BaseOrderListViewController *)viewController didSelectOrder:(Order *)order;
- (void)baseOrderListViewController:(BaseOrderListViewController *)viewController orderCellBtnDidClick:(Order *)order;
- (void)baseOrderListViewControllerLoadNewData:(BaseOrderListViewController *)viewController;
- (void)baseOrderListViewControllerLoadMoreData:(BaseOrderListViewController *)viewController;

@end

@interface BaseOrderListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, OrderCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) RefreshView *refreshView;
@property (nonatomic, weak) id <BaseOrderListViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger order_page;

@end
