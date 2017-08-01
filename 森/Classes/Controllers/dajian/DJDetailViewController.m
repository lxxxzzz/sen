//
//  DJDetailViewController.m
//  森
//
//  Created by Lee on 2017/6/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "DJDetailViewController.h"
#import "DJLogViewController.h"

@interface DJDetailViewController ()

@end

@implementation DJDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"跟进日志" target:self action:@selector(log)];
    
    self.navigationItem.title = @"搭建详情";
}

- (void)log {
    DJLogViewController *logVc = [[DJLogViewController alloc] init];
    logVc.order_id = self.order.customerId;
    [self.navigationController pushViewController:logVc animated:YES];
}

- (void)loadData {
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=orderDaJianDetail&debug=1", HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = TOKEN;
    parameters[@"order_id"] = self.order.customerId;
    [HTTPTool GET:url parameters:parameters success:^(HTTPResult *result) {
        Log(@"%@",result);
        [SVProgressHUD dismiss];
        if (result.success) {
            NSDictionary *dict = result.data[@"order_item"];
            ItemGroup *group1 = [[ItemGroup alloc] init];
            NSTimeInterval use_date = [dict[@"use_date"] doubleValue];
            NSString *strDate = nil;
            if (use_date > 0) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:use_date];
                NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
                fmt.dateFormat = @"yyyy-MM-dd";
                strDate = [fmt stringFromDate:date];
            }
            group1.items = @[[BaseItem itemWithTitle:@"姓名" value:dict[@"customer_name"] required:NO],
                             [BaseItem itemWithTitle:@"类型" value:@"布展" required:NO],
//                             [BaseItem itemWithTitle:@"类型" value:dict[@"order_type"] required:NO],
                             [TelephoneItem itemWithTitle:@"手机号" value:dict[@"order_phone"] click:^{
                                 NSMutableString *url = [[NSMutableString alloc] initWithFormat:@"tel:%@",dict[@"order_phone"]];
                                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                             }],
                             [BaseItem itemWithTitle:@"区域" value:dict[@"order_area_hotel_name"] required:YES],
                             [BaseItem itemWithTitle:@"预算" value:dict[@"order_money"] required:NO],
                             [BaseItem itemWithTitle:@"时间" value:strDate required:NO],
                             [BaseItem itemWithTitle:@"备注" value:dict[@"order_desc"] required:NO]];
            ItemGroup *group2 = [[ItemGroup alloc] init];
            group2.header = @"处理状态";
            NSTimeInterval timeInterval = [result.data[@"handle_time"] doubleValue];
            NSString *followDate = [NSString stringWithTimeInterval:timeInterval format:@"yyyy-MM-dd"];
            group2.items = @[[BaseItem itemWithTitle:@"处理进度" value:result.data[@"handle_note"] required:NO],
                             [BaseItem itemWithTitle:@"处理时间" value:followDate required:NO]];
            self.dataSource = @[group1, group2];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        } else {
            [self.tableView.mj_header endRefreshing];
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:NETWORK_ERROR];
    }];
}

@end
