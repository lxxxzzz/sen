//
//  DJListViewController.m
//  森
//
//  Created by Lee on 2017/6/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "DJListViewController.h"
#import "Order.h"
#import "OrderCell.h"
#import "DJDetailViewController.h"

@interface DJListViewController ()

@end

@implementation DJListViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @[@"跟进中", @"待结算", @"已结算", @"已取消"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadData];
}

#pragma mark - 私有方法
#pragma mark 布局

#pragma mark 网络请求
- (void)loadNewDataWithStatus:(NSString *)status orderPage:(NSInteger)page success:(void (^)(NSArray *,NSInteger))success failure:(void (^)())failure {
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=orderDaJianList&debug=1", HOST];
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
                    order.type = OrderTypeDajian;
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
- (void)baseOrderListViewController:(BaseOrderListViewController *)viewController didSelectOrder:(Order *)order {
    DJDetailViewController *detailVc = [[DJDetailViewController alloc] init];
    detailVc.order = order;
    [self.navigationController pushViewController:detailVc animated:YES];
}


@end
