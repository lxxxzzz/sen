//
//  GZOrderListViewController.m
//  森
//
//  Created by Lee on 2017/5/31.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "GZOrderListViewController.h"
#import "GZDetailParentViewController.h"
#import "GZDetailViewController.h"
#import "OrderSignViewController.h"

@interface GZOrderListViewController ()

@end

@implementation GZOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    self.titles = @[@"待处理", @"待审核", @"待结算", @"已结算", @"已驳回", @"已取消"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadData];
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"客资跟踪";
}

#pragma mark 网络请求
- (void)loadNewDataWithStatus:(NSString *)status orderPage:(NSInteger)page success:(void (^)(NSArray *,NSInteger))success failure:(void (^)())failure {
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=orderHandleKeZiList", HOST];
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

/*
- (void)loadDataWithStatus:(NSString *)status completion:(void(^)(NSArray *orders))completion {
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=orderHandleKeZiList", HOST];
    NSDictionary *parameters = @{
                                 @"access_token" : TOKEN,
                                 @"order_status" : status
                                 };
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        if (result.success) {
            Log(@"%@",result);
            NSArray *order_list = result.data[@"order_list"];
            if (order_list.count) {
                NSMutableArray *orders = [NSMutableArray array];
                for(int i=0;i < order_list.count;i++) {
                    NSDictionary *dict = order_list[i];
                    Order *order = [Order mj_objectWithKeyValues:dict];
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
                
                if (completion) {
                    completion(orders);
                } else {
                    if (completion) {
                        completion(@[]);
                    }
                }
            } else {
                if (completion) {
                    completion(@[]);
                }
            }
        } else {
            if (completion) {
                completion(@[]);
            }
        }
    } failure:^(NSError *error) {
        if (completion) {
            completion(@[]);
        }
    }];
}
 */

#pragma mark - delegate
#pragma mark UITableViewDataSource
- (void)baseOrderListViewController:(BaseOrderListViewController *)viewController didSelectOrder:(Order *)order {
    if (order.order_status == 1) {
        GZDetailViewController *detailVc = [[GZDetailViewController alloc] init];
        detailVc.order = order;
        [self.navigationController pushViewController:detailVc animated:YES];
    } else {
        GZDetailParentViewController *detailVc = [[GZDetailParentViewController alloc] init];
        detailVc.order = order;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

- (void)baseOrderListViewController:(BaseOrderListViewController *)viewController orderCellBtnDidClick:(Order *)order {
    OrderSignViewController *signingVc = [[OrderSignViewController alloc] init];
    signingVc.editable = YES;
    signingVc.order = order;
    
    [self.navigationController pushViewController:signingVc animated:YES];
}



@end
