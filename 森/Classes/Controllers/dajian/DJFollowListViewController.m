//
//  DJFollowListViewController.m
//  森
//
//  Created by Lee on 2017/6/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "DJFollowListViewController.h"
#import "DJFollowDetailViewController.h"
#import "DJDetailParentViewController.h"
#import "DJSignViewController.h"

@interface DJFollowListViewController ()

@end

@implementation DJFollowListViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @[@"待处理", @"待审核", @"待结算", @"已结算", @"已驳回", @"已取消"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadData];
}

#pragma mark - 私有方法
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
                    order.showSource = YES;
                    order.type = OrderTypeDajian;
                    if (order.order_status == 1) {
                        order.status = OrderStatusDaichuli;
                    } else if (order.order_status == 2) {
                        order.status = OrderStatusDaishenhe;
                    } else if (order.order_status == 3) {
                        order.status = OrderStatusDaijiesuan;
                    } else if (order.order_status == 4) {
                        order.status = OrderStatusYijiesuan;
                    } else if (order.order_status == 5) {
                        order.status = OrderStatusYibohui;
                    } else if (order.order_status == 6) {
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
    if (order.order_status == 1) {
        DJFollowDetailViewController *detailVc = [[DJFollowDetailViewController alloc] init];
        detailVc.order = order;
        [self.navigationController pushViewController:detailVc animated:YES];
    } else {
        DJDetailParentViewController *detailVc = [[DJDetailParentViewController alloc] init];
        detailVc.order = order;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

- (void)baseOrderListViewController:(BaseOrderListViewController *)viewController orderCellBtnDidClick:(Order *)order {
    DJSignViewController *signingVc = [[DJSignViewController alloc] init];
    signingVc.editable = YES;
    signingVc.order = order;
    
    [self.navigationController pushViewController:signingVc animated:YES];
}


@end
