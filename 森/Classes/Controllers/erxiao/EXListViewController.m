//
//  EXListViewController.m
//  森
//
//  Created by Lee on 2017/6/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "EXListViewController.h"
#import "SegmentControl.h"
#import "Order.h"
#import "EXDetailViewController.h"
#import "EXDetailParentViewController.h"
#import "EXSignViewController.h"
#import "BaseOrderListViewController.h"
#import "EXUpdatePayDateViewController.h"
#import "SegmentControl.h"
#import "RefreshView.h"

@interface EXListViewController ()

@end

@implementation EXListViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @[@"待处理", @"待审核", @"已完结", @"已驳回"];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadData];
}

- (void)loadMoreData {
    
}

- (void)loadNewDataWithStatus:(NSString *)status orderPage:(NSInteger)page success:(void (^)(NSArray *,NSInteger))success failure:(void (^)())failure {
    if ([status isEqualToString:@"4"]) {
        status = @"5"; // 没有状态4  驳回是5
    }
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
                        order.status = OrderStatusYiwanjie;
                        
                    } else if (order.order_status == 5) {
                        order.status = OrderStatusYibohui;
                        
                    }
                    
                    if (order.erxiao_sign_type == 1) {
                        order.erxiao_status = @"中款";
                    } else if (order.erxiao_sign_type == 2) {
                        order.erxiao_status = @"尾款";
                    } else if (order.erxiao_sign_type == 3) {
                        order.erxiao_status = @"附加款";
                    } else if (order.erxiao_sign_type == 4) {
                        order.erxiao_status = @"尾款时间修改";
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
#pragma mark SegmentControlDelegate
- (void)baseOrderListViewController:(BaseOrderListViewController *)viewController didSelectOrder:(Order *)order {
    if (order.order_status == 1) {
        EXDetailViewController *detailVc = [[EXDetailViewController alloc] init];
        detailVc.order = order;
        [self.navigationController pushViewController:detailVc animated:YES];
    } else {
        EXDetailParentViewController *detailVc = [[EXDetailParentViewController alloc] init];
        detailVc.order = order;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

- (void)baseOrderListViewController:(BaseOrderListViewController *)viewController orderCellBtnDidClick:(Order *)order {
    if (order.erxiao_sign_type == 4) {
        // 修改尾款时间
        EXUpdatePayDateViewController *updateVc = [[EXUpdatePayDateViewController alloc] init];
        updateVc.order_id = order.customerId;
        updateVc.editable = YES;
        [self.navigationController pushViewController:updateVc animated:YES];
    } else {
        EXSignViewController *signingVc = [[EXSignViewController alloc] init];
        signingVc.order = order;
        signingVc.editable = YES;
        signingVc.sign_type = [NSString stringWithFormat:@"%ld", order.erxiao_sign_type];
        [self.navigationController pushViewController:signingVc animated:YES];
    }
    
}


@end
