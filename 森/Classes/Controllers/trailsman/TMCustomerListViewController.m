//
//  TMCustomerListViewController.m
//  森
//
//  Created by Lee on 2017/4/27.
//  Copyright © 2017年 Lee. All rights reserved.
//  跟踪者订单列表

#import "TMCustomerListViewController.h"
#import "DrawerViewController.h"
#import "CheckCustomerViewController.h"
#import "SegmentControl.h"
#import "HTTPTool.h"
#import "Order.h"
#import "OrderCell.h"
#import "TMCustomerDetailViewController.h"
#import "Dropdown.h"
#import "TMCheckCustomerViewController.h"
#import "OrderSignViewController.h"

#import "UIBarButtonItem+Extension.h"

#import <Masonry.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <MJRefresh.h>

@interface TMCustomerListViewController ()


@end

@implementation TMCustomerListViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.titles = @[@"跟进中", @"待结算", @"已结算", @"已取消"];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

#pragma mark - 私有方法

#pragma mark 网络请求
- (void)loadNewDataWithStatus:(NSString *)status orderPage:(NSInteger)page success:(void (^)(NSArray *,NSInteger))success failure:(void (^)())failure {
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=orderKeZiList", HOST];
    NSDictionary *parameters = @{
                                 @"access_token" : TOKEN,
                                 @"order_status" : status,
                                 @"order_page"   : @(page)
                                 };
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        if (result.success) {
            Log(@"%@",result);
            NSArray *order_list = result.data[@"order_list"];
            NSInteger maxCount = [result.data[@"count"] integerValue];
            if (order_list.count) {
                NSMutableArray *orders = [NSMutableArray array];
                for(int i=0;i < order_list.count;i++) {
                    NSDictionary *dict = order_list[i];
                    Order *order = [Order mj_objectWithKeyValues:dict];
                    order.type = OrderTypeKezi;
                    if (order.order_status == 1) {
                        order.status = OrderStatusGenjinzhong;
                    } else if (order.order_status == 2) {
                        order.status = OrderStatusDaijiesuan;
                    } else if (order.order_status == 3) {
                        order.status = OrderStatusYijiesuan;
                    } else if (order.order_status == 4) {
                        order.status = OrderStatusYiquxiao;
                    }
                    [orders addObject:order];
                }
                
                if (success) {
                    success(orders, maxCount);
                }
            } else {
                if (success) {
                    success(@[], 0);
                }
            }
        } else {
            if (success) {
                success(@[], 0);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure();
        }
    }];
}

#pragma mark - delegate
#pragma mark UITableViewDataSource
- (void)baseOrderListViewController:(BaseOrderListViewController *)viewController orderCellBtnDidClick:(Order *)order {
    OrderSignViewController *signingVc = [[OrderSignViewController alloc] init];
    signingVc.order = order;
    [self.navigationController pushViewController:signingVc animated:YES];
}

- (void)baseOrderListViewController:(BaseOrderListViewController *)viewController didSelectOrder:(Order *)order {
    TMCustomerDetailViewController *detailVc = [[TMCustomerDetailViewController alloc] init];
    detailVc.order = order;
    [self.navigationController pushViewController:detailVc animated:YES];
}

//#pragma mark - setter and getter
//#pragma mark getter
//

@end
