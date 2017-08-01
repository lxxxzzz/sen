//
//  TMCustomerDetailViewController.m
//  森
//
//  Created by Lee on 2017/4/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "TMCustomerDetailViewController.h"
#import "LogViewController.h"


@interface TMCustomerDetailViewController ()<MultiCellDelegate>

//@property (nonatomic, strong) NSMutableArray *workflow;

@end

@implementation TMCustomerDetailViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    [self setupNavigationItem];
}

- (void)dealloc {
    Log(@"%s",__func__);
}

#pragma mark - Override

#pragma mark - 私有方法
- (void)setupNavigationItem {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"跟进日志" target:self action:@selector(log)];
    self.navigationItem.title = @"客资详情";
}

#pragma mark ACTION
- (void)log {
    LogViewController *logVc = [[LogViewController alloc] init];
    logVc.order_id = self.order.customerId;
    [self.navigationController pushViewController:logVc animated:YES];
}

#pragma mark 网络请求
- (void)loadData {
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=orderKeZiDetail&debug=1", HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = TOKEN;
    parameters[@"order_id"] = self.order.customerId;
    parameters[@"detail_type"] = @"1";
    parameters[@"debug"] = @"1";
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        Log(@"%@",result.data);
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
            
            NSString *type;
            if ([dict[@"order_type"] integerValue] == 1) {
                type = @"婚宴";
            } else if ([dict[@"order_type"] integerValue] == 2) {
                type = @"会务";
            } else if ([dict[@"order_type"] integerValue] == 3) {
                type = @"团宴\\宝宝宴";
            }
            
            NSString *hotelType;
            NSString *hotelTitle;
            if ([dict[@"order_area_hotel_type"] integerValue] == 1) {
                hotelType = @"指定区域";
                hotelTitle = @"区域";
            } else if ([dict[@"order_area_hotel_type"] integerValue] == 2) {
                hotelType = @"指定酒店";
                hotelTitle = @"酒店";
            }
            
            group1.items = @[[BaseItem itemWithTitle:@"姓名" value:dict[@"customer_name"] required:NO],
                             [BaseItem itemWithTitle:@"类型" value:type required:NO],
                             [BaseItem itemWithTitle:@"手机号" value:dict[@"order_phone"] required:NO],
                             [BaseItem itemWithTitle:@"指定位置" value:hotelType required:YES],
                             [BaseItem itemWithTitle:hotelTitle value:dict[@"order_area_hotel_name"] required:YES],
                             [BaseItem itemWithTitle:@"桌数" value:dict[@"desk_count"] required:NO],
                             [BaseItem itemWithTitle:@"预算" value:dict[@"order_money"] required:NO],
                             [BaseItem itemWithTitle:@"时间" value:strDate required:NO],
                             [BaseItem itemWithTitle:@"备注" value:dict[@"order_desc"] required:NO]];
            ItemGroup *group2 = [[ItemGroup alloc] init];
            group2.header = @"处理状态";
            NSString *handle_note = result.data[@"handle_note"];
            NSTimeInterval timeInterval = [result.data[@"handle_time"] doubleValue];
            NSString *followDate = [NSString stringWithTimeInterval:timeInterval format:@"yyyy-MM-dd"];
            group2.items = @[[BaseItem itemWithTitle:@"处理进度" value:handle_note required:NO],
                             [BaseItem itemWithTitle:@"处理时间" value:followDate required:NO]];
            self.dataSource = @[group1, group2];
            
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:NETWORK_ERROR];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (MultiCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MultiCell *cell = (MultiCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.readOnly = YES;
    return cell;
}

#pragma mark MultiCellDelegate
- (void)multiCell:(UITableViewCell *)cell valueDidChange:(id)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ItemGroup *group = self.dataSource[indexPath.section];
    BaseItem *item = group.items[indexPath.row];
    
    if ([item isKindOfClass:[ButtonItem class]]) {
        ButtonItem *buttonItem = (ButtonItem *)item;
        if (buttonItem.click) {
            buttonItem.click();
        }
    }
}


@end
